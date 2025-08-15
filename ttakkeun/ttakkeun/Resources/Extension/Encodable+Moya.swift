// Create an extension for Encodable to provide a `toJSONData()` helper method. This will be used project-wide for encoding any Encodable to Data.
import Foundation

extension Encodable {
    func toJSONData() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        let obj = try JSONSerialization.jsonObject(with: data, options: [])
        return obj as? [String: Any] ?? [:]
    }
}
