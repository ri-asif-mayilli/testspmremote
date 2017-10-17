import Darwin

enum RSdkSyctlInfoType {
    
    case hostname
    case machine
    case model
    case activeCPUs
    case osRelease
    case osRev
    case osType
    case osVersion
    case version
    case memSize
    case machineArch
    
    var sysctlValue : String {
        
        switch(self) {
        case .machineArch:
            return ""
            
        case .hostname:
            return Sysctl.sysctlHostName
            
        case .machine:
            return Sysctl.sysctlMachine
            
        case .model:
            return Sysctl.sysctlModel
            
        case .activeCPUs:
            return String(describing: Sysctl.sysctlActiveCPUs)
            
        case .osRelease:
            return Sysctl.sysctlOsRelease
            
        case .osRev:
            return String(describing: Sysctl.sysctlKernID)
            
        case .osType:
            return Sysctl.sysctlOsType
            
        case .osVersion:
            return Sysctl.sysctlOsVersion
            
        case .memSize:
            return Sysctl.sysctlMemSize.description
            
        case .version:
            return Sysctl.sysctlVersion
        }
    }
}


/// A "static"-only namespace around a series of functions that operate on buffers returned from the `Darwin.sysctl` function
private struct Sysctl {
    
    private static let _requestToken = RSdkRequestInfoManager.sharedRequestInfoManager._token
    private static let _snippetId = RSdkRequestInfoManager.sharedRequestInfoManager._snippetId
    
    /// Possible errors.
    private enum Error: Swift.Error {
        case unknown
        case malformedUTF8
        case invalidSize
        case posixError(POSIXErrorCode)
    }
    
    /// Access the raw data for an array of sysctl identifiers.
    private static func dataForKeys (_ keys: [Int32]) throws -> [Int8] {
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
    private static func keysForName (_ name: String) throws -> [Int32] {
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
    private static func valueOfType <T>(_ type: T.Type, forKeys keys: [Int32]) throws -> T {
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
    private static func valueOfType <T>(_ type: T.Type, forKeys keys: Int32...) throws -> T {
        return try valueOfType(type, forKeys: keys)
    }
    
    /// Invoke `sysctl` with the specified name, interpreting the returned buffer as the specified type. This function will throw `Error.invalidSize` if the size of buffer returned from `sysctl` fails to match the size of `T`.
    private static func valueOfType <T>(_ type: T.Type, forName name: String) throws -> T {
        return try valueOfType(type, forKeys: keysForName(name))
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private static func stringForKeys (_ keys: [Int32]) throws -> String {
        let optionalString = try dataForKeys(keys).withUnsafeBufferPointer() { dataPointer -> String? in
            dataPointer.baseAddress.flatMap { String(validatingUTF8: $0) }
        }
        guard let s = optionalString else {
            throw Error.malformedUTF8
        }
        return s
    }
    
    /// Invoke `sysctl` with an array of identifers, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private static func stringForKeys (_ keys: Int32...) throws -> String {
        return try stringForKeys(keys)
    }
    
    /// Invoke `sysctl` with the specified name, interpreting the returned buffer as a `String`. This function will throw `Error.malformedUTF8` if the buffer returned from `sysctl` cannot be interpreted as a UTF8 buffer.
    private static func stringForName (_ name: String) throws -> String {
        return try stringForKeys(keysForName(name))
    }

    private static func missingDataError(error: Error) -> String {
        
        guard let _snippetId = _snippetId, let _requestToken = _requestToken else {
            
            let dataError = RSdkErrorType.missingData
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: dataError), completion: { (_, _) in
                
            })
            return ""
        }
        
        return createErrorMessage(_requestToken: _requestToken, _snippetId: _snippetId, _error: error)
    }
    
    private static func createErrorMessage(_requestToken : String, _snippetId: String, _error : Error)  -> String {
        
        let sdkError = RSdkErrorType.getSystemData(_snippetId, _requestToken, _error.localizedDescription)
        RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: sdkError), completion: { (_, _) in
            
        })
        return ""
    }
    
    private static func missingInt32DataError(error: Error) -> Int32 {
        
        guard let _snippetId = _snippetId, let _requestToken = _requestToken else {
            
            let dataError = RSdkErrorType.missingData
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: dataError), completion: { (_, _) in
                
            })
            return 0
        }
        
        return createInt32ErrorMessage(_requestToken: _requestToken, _snippetId: _snippetId, _error: error)
    }
    
    private static func createInt32ErrorMessage(_requestToken : String, _snippetId: String, _error : Error)  -> Int32 {
        
        let sdkError = RSdkErrorType.getSystemData(_snippetId, _requestToken, _error.localizedDescription)
        RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: sdkError), completion: { (_, _) in
            
        })
        return 0
    }
    
    private static func missingInt64DataError(error: Error) -> UInt64 {
        
        guard let _snippetId = _snippetId, let _requestToken = _requestToken else {
            
            let dataError = RSdkErrorType.missingData
            RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: dataError), completion: { (_, _) in
                
            })
            return 0
        }
        
        return createInt64ErrorMessage(_requestToken: _requestToken, _snippetId: _snippetId, _error: error)
    }
    
    private static func createInt64ErrorMessage(_requestToken : String, _snippetId: String, _error : Error)  -> UInt64 {
        
        let sdkError = RSdkErrorType.getSystemData(_snippetId, _requestToken, _error.localizedDescription)
        RSdkRequestManager.sharedRequestManager.doRequest(requestType: .postError(error: sdkError), completion: { (_, _) in
            
        })
        return 0
    }
    
    /// e.g. "MyComputer.local" (from System Preferences -> Sharing -> Computer Name) or
    /// "My-Name-iPhone" (from Settings -> General -> About -> Name)
    internal static var sysctlHostName : String {
        
        do {
        
            return try Sysctl.stringForKeys([CTL_KERN, KERN_HOSTNAME])
            
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "x86_64" or "N71mAP"
    /// NOTE: this is *corrected* on iOS devices to fetch hw.model
    internal static var sysctlMachine : String {
        
        do {
        
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try Sysctl.stringForKeys([CTL_HW, HW_MODEL])
        #else
            return try Sysctl.stringForKeys([CTL_HW, HW_MACHINE])
        #endif
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "MacPro4,1" or "iPhone8,1"
    /// NOTE: this is *corrected* on iOS devices to fetch hw.machine
    internal static var sysctlModel : String {
        
        do {
        
        #if os(iOS) && !arch(x86_64) && !arch(i386)
            return try Sysctl.stringForKeys([CTL_HW, HW_MACHINE])
        #else
            return try Sysctl.stringForKeys([CTL_HW, HW_MODEL])
        #endif
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    internal static var sysctlMachineArch : String {
        
        do {
        
        return try Sysctl.stringForKeys([CTL_HW, HW_MACHINE_ARCH])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    internal static var sysctlActiveCPUs : Int32 {
        
        do {
            return try Sysctl.valueOfType(Int32.self, forKeys: [CTL_HW, HW_AVAILCPU])
        } catch let error {
            
            return missingInt32DataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "15.3.0" or "15.0.0"
    internal static var sysctlOsRelease : String {
        
        do {
            return try Sysctl.stringForKeys([CTL_KERN, KERN_OSRELEASE])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. 199506 or 199506
    internal static var sysctlOsRev : Int32 {
        
        do {
            return try Sysctl.valueOfType(Int32.self, forKeys: [CTL_KERN, KERN_OSREV])
        } catch let error {
            
            return missingInt32DataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "Darwin" or "Darwin"
    internal static var sysctlOsType : String {
        
        do {
            return try Sysctl.stringForKeys([CTL_KERN, KERN_OSTYPE])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    internal static var sysctlKernID : Int32 {
        
        do {
            return try Sysctl.valueOfType(Int32.self, forKeys: [CTL_KERN, KERN_SAVED_IDS])
        } catch let error {
            
            return missingInt32DataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "15D21" or "13D20"
    internal static var sysctlOsVersion : String {
        
        do {
            return try Sysctl.stringForKeys([CTL_KERN, KERN_OSVERSION])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    /// e.g. "Darwin Kernel Version 15.3.0: Thu Dec 10 18:40:58 PST 2015; root:xnu-3248.30.4~1/RELEASE_X86_64" or
    /// "Darwin Kernel Version 15.0.0: Wed Dec  9 22:19:38 PST 2015; root:xnu-3248.31.3~2/RELEASE_ARM64_S8000"
    internal static var sysctlVersion : String {
        
        do {
            return try Sysctl.stringForKeys([CTL_KERN, KERN_VERSION])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    internal static var sysctlDomainName : String {
        
        do {
            return try Sysctl.stringForKeys([CTL_KERN, KERN_DOMAINNAME])
        } catch let error {
            
            return missingDataError(error: error as! Sysctl.Error)
        }
    }
    
    internal static var sysctlMemSize : UInt64 {
        
        do {
            return try Sysctl.valueOfType(UInt64.self, forKeys: [CTL_HW, HW_MEMSIZE])
        } catch let error {
            
            return missingInt64DataError(error: error as! Sysctl.Error)
        }
    }
}
