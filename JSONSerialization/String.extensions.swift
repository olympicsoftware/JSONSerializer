import Foundation

extension String {
    init(_ aDecimal : Decimal){
        self.init(describing: aDecimal)
    }
    
    func appendPath(_ path: String) -> String{
        return (self as NSString).appendingPathComponent(path)
    }
    
    var first: String {
        return String(characters.prefix(1))
    }
    
    var last: String {
        return String(characters.suffix(1))
    }
    
    var uppercaseFirst: String {
        return first.uppercased() + String(characters.dropFirst())
    }
    
    func hyphenate() -> String {
        return self.replacingOccurrences(of: "[^a-zA-Z0-9]+", with: "_", options: .regularExpression, range: nil)
    }
    
    func contains(_ str: String) -> Bool {
        return self.range(of: str) != nil
    }
}
