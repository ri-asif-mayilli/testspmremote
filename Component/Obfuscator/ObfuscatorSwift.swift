import Foundation

internal class Obfuscator {
    
    // MARK: - Variables
    
    /// The salt used to obfuscate and reveal the string.
    private let obfuscatorSalt: String
    
    static let sharedObfuscator = Obfuscator()
    private init() {
        
        self.obfuscatorSalt = ["YAjUEttrXaLpbgtYwffEUCkHE", "PejNUJnJzeNqduTvfqKEmorms", "wErHWRwyFPoVeFEzcJoLwbAkm", "HdcpjjFFfLoouquKPCstbUWKM", "XYpFoYzkWrsusYuhArxeVKsbx"].description
    }
    
    
    // MARK: - Instance Methods
    
    /**
     This method obfuscates the string passed in using the salt
     that was used when the Obfuscator was initialized.
     
     - parameter string: the string to obfuscate
     
     - returns: the obfuscated string in a byte array
     */
    func bytesByObfuscatingString(string: String) -> [UInt8] {
        
        let text = [UInt8](string.utf8)
        let cipher = [UInt8](self.obfuscatorSalt.utf8)
        let length = cipher.count
        
        var encrypted = [UInt8]()
        
        for t in text.enumerated() {
            
            encrypted.append(t.element ^ cipher[t.offset % length])
        }
        
        #if DEBUG
            print("Salt used: \(self.obfuscatorSalt)\n")
            print("Swift Code:\n************")
            print("// Original \"\(string)\"")
            print("let key: [UInt8] = \(encrypted)\n")
        #endif
        
        return encrypted
    }
    
    /**
     This method reveals the original string from the obfuscated
     byte array passed in. The salt must be the same as the one
     used to encrypt it in the first place.
     
     - parameter key: the byte array to reveal
     
     - returns: the original string
     */
    func revealObfuscation(key: [UInt8]) -> String {
        
        let cipher = [UInt8](self.obfuscatorSalt.utf8)
        let length = cipher.count
        
        var decrypted = [UInt8]()
        
        for k in key.enumerated() {
            
            decrypted.append(k.element ^ cipher[k.offset % length])
        }
        
        return String(bytes: decrypted, encoding: String.Encoding.utf8)!
    }
}
