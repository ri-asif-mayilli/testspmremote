/*
 * This file is subject to the terms and conditions defined in
 * the LICENSE file that is distributed in the same package.
 */
import Darwin


/// A "static"-only namespace around a series of functions that operate on buffers returned from the `Darwin.sysctl` function
class Sysctl {
    var errors:[String] = []
    let throwable:Bool = true
    
    
    /// Possible errors.
    private enum Error: Swift.Error {
        case unknown
        case malformedUTF8
        case invalidSize
        case posixError(POSIXErrorCode)
    }
    
    /// Access the raw data for an array of sysctl identifiers.
    private func dataForKeys (_ keys: [Int32]) throws -> [Int8] {
        return try keys.withUnsafeBufferPointer() { keysPointer throws -> [Int8] in
            // Preflight the request to get the required data size
            var requiredSize = 0
            let preFlightResult = Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), nil, &requiredSize, nil, 0)
            if preFlightResult != 0 {
                throw POSIXErrorCode(rawValue: errno).map { Error.posixError($0) } ?? Error.unknown
            }
            
            // Run the actual request with an appropriately sized array buffer
            let data = Array<Int8>(repeating: 0, count: requiredSize)
            let result = data.withUnsafeBufferPointer() { dataBuffer -> Int32 in
                return Darwin.sysctl(UnsafeMutablePointer<Int32>(mutating: keysPointer.baseAddress), UInt32(keys.count), UnsafeMutableRawPointer(mutating: dataBuffer.baseAddress), &requiredSize, nil, 0)
            }
            if result != 0 {
                throw POSIXErrorCode(rawValue: errno).map { Error.posixError($0) } ?? Error.unknown
            }
            
            return data
        }
    }
    
    /// Convert a sysctl name string like "hw.memsize" to the array of `sysctl` identifiers (e.g. [CTL_HW, HW_MEMSIZE])
    private func keysForName (_ name: String) throws -> [Int32] {
        var keysBufferSize = Int(CTL_MAXNAME)
        var keysBuffer = Array<Int32>(repeating: 0, count: keysBufferSize)
        try keysBuffer.withUnsafeMutableBufferPointer { (lbp: inout UnsafeMutableBufferPointer<Int32>) throws in
            try name.withCString { (nbp: UnsafePointer<Int8>) throws in
                guard sysctlnametomib(nbp, lbp.baseAddress, &keysBufferSize) == 0 else {
                    throw POSIXErrorCode(rawValue: errno).map { Error.posixError($0) } ?? Error.unknown
                }
            }
        }
        if keysBuffer.count > keysBufferSize {
            keysBuffer.removeSubrange(keysBufferSize..<keysBuffer.count)
        }
        return keysBuffer
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as the specified type. This function will throw `Error.invalidSize` if the size of buffer returned from `sysctl` fails to match the size of `T`.
    private func valueOfType <T>(_ type: T.Type, forKeys keys: [Int32]) throws -> T {
        let buffer = try dataForKeys(keys)
        if buffer.count != MemoryLayout<T>.size {
            throw Error.invalidSize
        }
        return try buffer.withUnsafeBufferPointer() { bufferPtr throws -> T in
            guard let baseAddress = bufferPtr.baseAddress else { throw Error.unknown }
            return baseAddress.withMemoryRebound(to: T.self, capacity: 1) { $0.pointee }
        }
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as the specified type. This function will throw `Error.invalidSize` if the size of buffer returned from `sysctl` fails to match the size of `T`.
    private func valueOfType <T>(_ type: T.Type, forKeys keys: Int32...) throws -> T {
        return try valueOfType(type, forKeys: keys)
    }
    
    /// Invoke `sysctl` with the specified name, interpreting the returned buffer as the specified type. This function will throw `Error.invalidSize` if the size of buffer returned from `sysctl` fails to match the size of `T`.
    private func valueOfType <T>(_ type: T.Type, forName name: String) throws -> T {
        return try valueOfType(type, forKeys: keysForName(name))
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private func stringForKeys (_ keys: [Int32]) throws -> String {
        let optionalString = try dataForKeys(keys).withUnsafeBufferPointer() { dataPointer -> String? in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }
        guard let s = optionalString else {
            throw Error.malformedUTF8
        }
        return s
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private func stringForKeys (_ keys: Int32...) throws -> String {
        return try stringForKeys(keys)
    }
    
    /// Invoke `sysctl` with the specified name, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private func stringForName (_ name: String) throws -> String {
        return try stringForKeys(keysForName(name))
    }

    private func missingDataError(error: Error) {

        self.errors.append(error.localizedDescription)

    }
    
    
    

    /// e.g. "MyComputer.local" (from System Preferences -> Sharing -> Computer Name) or
    /// "My-Name-iPhone" (from Settings -> General -> About -> Name)
    internal var sysctlHostName : String? {
        
        do {
        
            return try stringForKeys([CTL_KERN, KERN_HOSTNAME])
            
        } catch let error {
            
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }

    
    /// e.g. "x86_64" or "N71mAP"
    /// NOTE: this is *corrected* on iOS devices to fetch hw.model
    internal var sysctlMachine : String? {
        
        do {
        
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try stringForKeys([CTL_HW, HW_MODEL])
        #else
            return try stringForKeys([CTL_HW, HW_MACHINE])
        #endif
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    

    /// e.g. "MacPro4,1" or "iPhone8,1"
    /// NOTE: this is *corrected* on iOS devices to fetch hw.machine
    internal var sysctlModel : String? {
        
        do {
        
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try stringForKeys([CTL_HW, HW_MACHINE])
        #else
            return try stringForKeys([CTL_HW, HW_MODEL])
        #endif
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    
    

    
    internal var sysctlActiveCPUs : Int32 {
        
        do {
            return try valueOfType(Int32.self, forKeys: [CTL_HW, HW_AVAILCPU])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return 0
        }
    }
    

    /// e.g. "15.3.0" or "15.0.0"
    internal var sysctlOsRelease : String? {
        
        do {
            return try stringForKeys([CTL_KERN, KERN_OSRELEASE])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    

    /// e.g. 199506 or 199506
    internal var sysctlOsRev : Int32 {
        
        do {
            return try valueOfType(Int32.self, forKeys: [CTL_KERN, KERN_OSREV])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return 0
        }
    }
    

    /// e.g. "Darwin" or "Darwin"
    internal var sysctlOsType : String? {
        
        do {
            return try stringForKeys([CTL_KERN, KERN_OSTYPE])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    

    internal var sysctlKernID : Int32 {
        
        do {
            return try valueOfType(Int32.self, forKeys: [CTL_KERN, KERN_SAVED_IDS])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return 0
        }
    }
    

    /// e.g. "15D21" or "13D20"
    internal var sysctlOsVersion : String? {
        
        do {
            return try stringForKeys([CTL_KERN, KERN_OSVERSION])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }

    /// e.g. "Darwin Kernel Version 15.3.0: Thu Dec 10 18:40:58 PST 2015; root:xnu-3248.30.4~1/RELEASE_X86_64" or
    /// "Darwin Kernel Version 15.0.0: Wed Dec  9 22:19:38 PST 2015; root:xnu-3248.31.3~2/RELEASE_ARM64_S8000"
    internal var sysctlVersion : String? {
        
        do {
            return try stringForKeys([CTL_KERN, KERN_VERSION])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    

    internal var sysctlDomainName : String? {
        
        do {
            return try stringForKeys([CTL_KERN, KERN_DOMAINNAME])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    

    internal var sysctlMemSize : UInt64 {
        
        do {
            return try valueOfType(UInt64.self, forKeys: [CTL_HW, HW_MEMSIZE])
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return 0
        }
    }
    

    internal var bootTimestamp: String? {

        do {
            let secs = try UInt64(valueOfType(timeval.self, forKeys: [CTL_KERN, KERN_BOOTTIME]).tv_sec)
            let msecs = try UInt64(valueOfType(timeval.self, forKeys: [CTL_KERN, KERN_BOOTTIME]).tv_usec)
            let timestamp = Date(timeIntervalSince1970: Double(secs) + Double(msecs) / 1_000_000.0)
            return Date.setDate(date: timestamp)
        } catch let error {
            missingDataError(error: error as? Sysctl.Error ?? Error.unknown)
            return nil
        }
    }
    
}
