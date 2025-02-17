import Foundation
/**
 Class supports the getting of GetItemResult from Json String
 */

class GetItem {
    /**
        Get GetItemResult object from Json string
        - Parameter : a Json string represents the GetItemResult object
        - Throws: CasperMethodCallError.CasperError with code and message according to the error returned by the Casper system
        - Returns: GetItemResult object
        */

    public static func getItem(from:[String:Any])throws -> GetItemResult {
        if let error = from["error"] as AnyObject? {
            var code:Int!
            var message:String!
            if let code1 = error["code"] as? Int {
                code = code1
            }
            if let message1 = error["message"] as? String {
                message = message1
            }
            throw CasperMethodCallError.CasperError(code: code, message: message,methodCall: "state_get_item")
        }
        let retItem:GetItemResult = GetItemResult();
        if let result = from["result"] as? [String:Any] {
            if let api_version = result["api_version"] as? String {
                retItem.api_version = ProtocolVersion.strToProtocol(from: api_version)
            }
            if let storedValue = result["stored_value"] as? [String:Any] {
                retItem.stored_value = StoredValueHelper.getStoredValue(from: storedValue)
            }
            if let merkle_proof = result["merkle_proof"] as? String {
                retItem.merkle_proof = merkle_proof;
            }
        }
        return retItem;
    }
}
