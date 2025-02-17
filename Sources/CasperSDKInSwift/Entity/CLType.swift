import Foundation
/**
 Enumeration for CLType
 */
public enum CLType {
    case Bool
    case I32
    case I64
    case U8
    case U32
    case U64
    case U128
    case U256
    case U512
    case Unit
    case String
    case Key
    case URef
    case PublicKey
    case BytesArray(UInt32);
    indirect case Result(CLType,CLType)
    indirect case Option(CLType)
    indirect case List(CLType)
    indirect case FixedList(CLType)
    indirect case Map(CLType,CLType)
    indirect case Tuple1(CLType)
    indirect case Tuple2(CLType,CLType)
    indirect case Tuple3(CLType,CLType,CLType)
    case CLAny
    case NONE
}
/**
 Class  for handling the  conversion from Json String to  CLType
 */
public class CLTypeHelper {
    //CLType to Json all
    public static func CLTypeToJsonString(clType:CLType) -> String {
        if CLValue.isCLTypePrimitive(cl_type: clType) {
            return "\""+CLTypeHelper.CLTypePrimitiveToJsonString(clType: clType)+"\""
        } else {
            return CLTypeHelper.CLTypeCompoundToJsonString(clType:  clType)
        }
    }
    public static func CLTypeToJson(clType:CLType) -> AnyObject {
        if CLValue.isCLTypePrimitive(cl_type: clType) {
            return CLTypeHelper.CLTypePrimitiveToJson(clType: clType) as AnyObject
        } else {
            return CLTypeHelper.CLTypeCompoundToJson(clType: clType) as AnyObject
        }
    }
    //CLType to Json string primitive
    public static func CLTypePrimitiveToJsonString(clType:CLType)-> String{
        switch clType {
        case .Bool:
            return "Bool"
        case .I32:
            return "I32"
        case .I64:
            return "I64"
        case .U8:
            return "U8"
        case .U32:
            return "U32"
        case .U64:
            return "U64"
        case .U128:
            return "U128"
        case .U256:
            return "U256"
        case .U512:
            return "U512"
        case .Unit:
            return "Unit"
        case .String:
            return "String"
        case .Key:
            return "Key"
        case .URef:
            return "URef"
        case .PublicKey:
            return "PublicKey"
        case .CLAny:
            return "Any"
        case .NONE:
            return "NONE"
        default:
            break;
        }
        return "NONE"
    }
    public static func CLTypeCompoundToJsonString(clType:CLType)->String {
        var ret:String = "";
        switch clType {
        case .BytesArray(_):
            ret = "{\"ByteArray\":32}";
            return ret
        case .Result(let clType1, let clType2):
            if CLValue.isCLTypePrimitive(cl_type: clType) {
                let clType1Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    ret = "{\"Result\":{\"ok\":\(clType1Str),\"err\":\(clType2Str)}}";
                    return ret;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    ret = "{\"Result\":{\"ok\":\(clType1Str),\"err\":\(clType2Str)}}";
                    return ret;
                }
            } else {
                let clType1Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    ret = "{\"Result\":{\"ok\":\(clType1Str),\"err\":\(clType2Str)}}";
                    return ret;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    ret = "{\"Result\":{\"ok\":\(clType1Str),\"err\":\(clType2Str)}}";
                    return ret;
                }
            }
        case .Option(let cLTypeOption):
            if CLValue.isCLTypePrimitive(cl_type: cLTypeOption) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeOption)
                ret = "{\"Option\":\"\(clTypeStr)\"}"
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeOption)
                ret = "{\"Option\":\(clTypeStr)}"
            }
            return ret
        case .List(let clTypeList):
            if CLValue.isCLTypePrimitive(cl_type: clTypeList) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeList)
                ret = "{\"List\":\"\(clTypeStr)\"}"
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJsonString(clType: clTypeList)
                ret = "{\"List\":\(clTypeStr)}"
            }
            return ret;
        case .FixedList(let cLTypeList):
            if CLValue.isCLTypePrimitive(cl_type: cLTypeList) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeList)
                ret = "{\"List\":\(clTypeStr)}"
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeList)
                ret = "{\"List\":\(clTypeStr)}"
            }
            return ret;
        case .Map(let clType1, let clType2):
            if CLValue.isCLTypePrimitive(cl_type: clType1) {
                let clType1Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:String = "{\"key\":\"\(clType1Str)\",\"value\":\"\(clType2Str)\"}";
                    ret = "{\"Map\":\(retResult)}";
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:String = "{\"key\":\"\(clType1Str)\",\"value\":\(clType2Str)}";
                    ret = "{\"Map\":\(retResult)}";
                }
            } else {
                let clType1Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:String = "{\"key\":\"\(clType1Str)\",\"value\":\"\(clType2Str)\"}";
                    ret = "{\"Map\":\(retResult)}";
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:String = "{\"key\":\(clType1Str),\"value\":\(clType2Str)}";
                    ret = "{\"Map\":\(retResult)}";
                }
            }
            return ret;
        case .Tuple1(let clTypeTuple):
            if CLValue.isCLTypePrimitive(cl_type: clTypeTuple) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeTuple)
                ret = "{\"Tuple\":\(clTypeStr)}";
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeTuple)
                ret = "{\"Tuple\":\(clTypeStr)}";
            }
            return ret;
        case .Tuple2(let clTypeTuple1, let clTypeTuple2):
            if CLValue.isCLTypePrimitive(cl_type: clTypeTuple1) {
                let clTypeStr1 : String = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeTuple1)
                if CLValue.isCLTypePrimitive(cl_type: clTypeTuple2) {
                    let clTypeStr2 :String = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeTuple2)
                    ret = "{\"Tuple2\":[\"\(clTypeStr1)\",\"\(clTypeStr2)\"]}";
                } else {
                    let clTypeStr2:[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeTuple2)
                    ret = "{\"Tuple2\":[\"\(clTypeStr1)\",\(clTypeStr2)]}";
                }
                
            } else {
                let clTypeStr1:[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeTuple1)
                if CLValue.isCLTypePrimitive(cl_type: clTypeTuple2) {
                    let clTypeStr2:String = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeTuple2)
                    ret = "{\"Tuple2\":[\(clTypeStr1),\"\(clTypeStr2)\"]}";
                } else {
                    let clTypeStr2:[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeTuple2)
                    ret = "{\"Tuple2\":[\(clTypeStr1),\(clTypeStr2)]}";
                }
            }
        case .Tuple3(let cLTypeTuple1, let cLTypeTuple2, let cLTypeTuple3):
            ret = "{\"Tuple3\":[";
            if CLValue.isCLTypePrimitive(cl_type: cLTypeTuple1) {
                let  clTypeStr1 : String = "\"" + CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeTuple1) + "\""
                ret = ret + "\(clTypeStr1),";
            } else {
                let  clTypeStr1 :[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeTuple1)
                ret = ret + "\(clTypeStr1),";
            }
            if CLValue.isCLTypePrimitive(cl_type: cLTypeTuple2) {
                let clTypeStr2:String = "\"" + CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeTuple2) + "\""
                ret = ret + "\(clTypeStr2),";
            } else {
                let clTypeStr2:[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeTuple2)
                ret = ret + "\(clTypeStr2),";
            }
            if CLValue.isCLTypePrimitive(cl_type: cLTypeTuple3) {
                let clTypeStr3:String = "\"" + CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeTuple3) + "\""
                ret = ret + "\(clTypeStr3)]";
            } else {
                let clTypeStr3:[String:Any] = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeTuple3)
                ret = ret + "\(clTypeStr3)]";
            }
            return ret;
        case .NONE:
            break;
        default:
            break;
        }
        return ret;
    }
    public static func CLTypePrimitiveToJson(clType:CLType)-> String{
        switch clType {
        case .Bool:
            return "Bool"
        case .I32:
            return "I32"
        case .I64:
            return "I64"
        case .U8:
            return "U8"
        case .U32:
            return "U32"
        case .U64:
            return "U64"
        case .U128:
            return "U128"
        case .U256:
            return "U256"
        case .U512:
            return "U512"
        case .Unit:
            return "Unit"
        case .String:
            return "String"
        case .Key:
            return "Key"
        case .URef:
            return "URef"
        case .PublicKey:
            return "PublicKey"
        case .CLAny:
            return "Any"
        case .NONE:
            return "NONE"
        default:
            break;
        }
        return "NONE"
    }
    /**
        Function to get  json object from CLType object
       - Parameter : CLType object
       - Returns: json object representing the current deploy object, in form of [String:Any]
     */
    public static func CLTypeCompoundToJson(clType:CLType)->[String:Any] {
        var ret:[String:Any]!;
        switch clType {
        case .BytesArray(_):
            ret = ["BytesArray":32]
            return ret
        case .Result(let clType1, let clType2):
            if CLValue.isCLTypePrimitive(cl_type: clType) {
                let clType1Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:[[String:String]] = [["ok":clType1Str],["err":clType2Str]]
                    let realRet:[String:Any] = ["Result":retResult];
                    return realRet;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["ok":clType1Str],["err":clType2Str]]
                    let realRet:[String:Any] = ["Result":retResult];
                    return realRet;
                }
            } else {
                let clType1Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["ok":clType1Str],["err":clType2Str]]
                    let realRet:[String:Any] = ["Result":retResult];
                    return realRet;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["ok":clType1Str],["err":clType2Str]]
                    let realRet:[String:Any] = ["Result":retResult];
                    return realRet;
                }
            }
        case .Option(let cLTypeOption):
            var optionRet:[String:Any] = [:];
            if CLValue.isCLTypePrimitive(cl_type: cLTypeOption) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeOption)
                optionRet = ["Option":clTypeStr]
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeOption)
                optionRet = ["Option":clTypeStr]
            }
            return optionRet;
        case .List(let clTypeList):
            var listRet:[String:Any] = [:];
            if CLValue.isCLTypePrimitive(cl_type: clTypeList) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeList)
                listRet = ["List":clTypeStr]
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeList)
                listRet = ["List":clTypeStr]
            }
            return listRet;
        case .FixedList(let cLTypeList):
            var listRet:[String:Any] = [:];
            if CLValue.isCLTypePrimitive(cl_type: cLTypeList) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: cLTypeList)
                listRet = ["List":clTypeStr]
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: cLTypeList)
                listRet = ["List":clTypeStr]
            }
            return listRet;
        case .Map(let clType1, let clType2):
            if CLValue.isCLTypePrimitive(cl_type: clType1) {
                let clType1Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:[[String:String]] = [["key":clType1Str],["value":clType2Str]]
                    let realRet:[String:Any] = ["Map":retResult];
                    return realRet;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["key":clType1Str],["value":clType2Str]]
                    let realRet:[String:Any] = ["Map":retResult];
                    return realRet;
                }
            } else {
                let clType1Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clType2Str = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["key":clType1Str],["value":clType2Str]]
                    let realRet:[String:Any] = ["Map":retResult];
                    return realRet;
                } else {
                    let clType2Str = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let retResult:[[String:Any]] = [["key":clType1Str],["value":clType2Str]]
                    let realRet:[String:Any] = ["Map":retResult];
                    return realRet;
                }
            }
        case .Tuple1(let clTypeTuple):
            if CLValue.isCLTypePrimitive(cl_type: clTypeTuple) {
                let clTypeStr = CLTypeHelper.CLTypePrimitiveToJson(clType: clTypeTuple)
                let realRet:[String:Any] = ["Tuple":clTypeStr];
                return realRet;
            } else {
                let clTypeStr = CLTypeHelper.CLTypeCompoundToJson(clType: clTypeTuple)
                let realRet:[String:Any] = ["Tuple":clTypeStr];
                return realRet;
            }
        case .Tuple2(let clType1, let clType2):
            if CLValue.isCLTypePrimitive(cl_type: clType1) {
                let clTypeStr1 = CLTypeHelper.CLTypePrimitiveToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clTypeStr2 = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let realRet:[String:Any] = ["Tuple2":[clTypeStr1,clTypeStr2]];
                    return realRet;
                } else {
                    let clTypeStr2 = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let realRet:[String:Any] = ["Tuple2":[clTypeStr1,clTypeStr2]];
                    return realRet;
                }
            } else {
                let clTypeStr1 = CLTypeHelper.CLTypeCompoundToJson(clType: clType1)
                if CLValue.isCLTypePrimitive(cl_type: clType2) {
                    let clTypeStr2 = CLTypeHelper.CLTypePrimitiveToJson(clType: clType2)
                    let realRet:[String:Any] = ["Tuple2":[clTypeStr1,clTypeStr2]];
                    return realRet;
                } else {
                    let clTypeStr2 = CLTypeHelper.CLTypeCompoundToJson(clType: clType2)
                    let realRet:[String:Any] = ["Tuple2":[clTypeStr1,clTypeStr2]];
                    return realRet;
                }
            }
        case .Tuple3(_,_,_):
            return ["":""];
        case .NONE:
            return ["":""];
        default:
            return ["":""]
        }
    }
    /**
     Get CLType from Json string
     - Parameter : a Json String represent the CLType object
     - Returns: CLType object
     */
    public static func jsonToCLType(from:AnyObject,keyStr:String = "cl_type")-> CLType {
        var ret :CLType = .NONE
        if let clTypeWrapper = from[keyStr] as? String {
            ret = CLTypeHelper.stringToCLTypePrimitive(input: clTypeWrapper)
            return ret
        }
        else if let clTypeWrapper = from[keyStr] as? AnyObject {
            ret = CLTypeHelper.jsonToCLTypeCompound(from: clTypeWrapper as  AnyObject)
        }
        return ret;
    }
    
    /**
     Get CLType primitive (CLType with no recursive type inside) from Json string
     - Parameter : a Json String represent the CLType object
     - Returns: CLType object
     */
    public static func jsonToCLTypePrimitive(from:AnyObject,keyStr:String="cl_type") -> CLType {
        let clType : CLType = .NONE
        //primitive type
        if (from["Bool"] as? Bool) != nil {
            return .Bool
        }
        if (from["U8"] as? UInt8) != nil {
            return .U8
        }
        if (from["U32"] as? UInt32) != nil {
            return .U32
        }
        if let _ = from["U64"] as? UInt64 {
            return .U64
        }
        if (from["U128"] as? String) != nil {
            return .U128
        }
        if (from["U256"] as? String) != nil {
            return .U256
        }
        if (from["U512"] as? String) != nil {
            return .U512
        }
        if (from["String"] as? String) != nil {
            return .String
        }
        if (from["key"] as? String) != nil {
            return .String
        }
        if (from["value"] as? String) != nil {
            return .String
        }
        if (from["ok"] as? String) != nil {
            return .String
        }
        if (from["err"] as? String) != nil {
            return .String
        }
        if let byteArrray = from["ByteArray"] as? UInt32 {
            return .BytesArray(byteArrray)
        }
        if (from["Key"] as? String) != nil {
            return .Key;
        }
        if (from["PublicKey"] as? String) != nil {
            return .PublicKey;
        }
        if (from["URef"] as? String) != nil {
            return .URef
        }
        if (from["Unit"] as? String) != nil {
            return .Unit
        }
        return clType
    }
    
    /**
     Get CLType compound from Json string, which are the recursive CLType such as List(CLType), Map(CLType,CLType), Tuple1(CLType), Tuple2(CLType,CLType),Tuple3(CLType,CLType,CLType)...
     - Parameter : a Json String represent the CLType object
     - Returns: CLType object
     */
    
    public static func jsonToCLTypeCompound(from:AnyObject,keyStr:String="cl_type")->CLType {
        var clType:CLType = .NONE
        if let listCLType = from["List"] as? String {
            clType = CLTypeHelper.stringToCLTypePrimitive(input: listCLType)
            return .List(clType)
        } else if let listCLType = from["List"] as? AnyObject {
            if !(listCLType is NSNull) {
                clType = CLTypeHelper.jsonToCLTypeCompound(from: listCLType)
                return .List(clType)
            }
        }
        if let byteArray = from["ByteArray"] as? UInt32 {
            return .BytesArray(byteArray)
        }
        if let mapCLType = from["Map"] as? AnyObject {
            if !(mapCLType is NSNull) {
                let keyCLType = CLTypeHelper.jsonToCLType(from: mapCLType,keyStr: "key")
                let valueCLType = CLTypeHelper.jsonToCLType(from: mapCLType,keyStr: "value")
                return .Map(keyCLType, valueCLType);
            }
        }
        
        if let tuple1CLType = from["Tuple1"] as? [AnyObject] {
            var tuple1:CLType?
            var counter : Int = 0;
            for oneTuple in tuple1CLType {
                if counter == 0 {
                    tuple1 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                }
                counter += 1
            }
            return .Tuple1(tuple1!)
        }
        
        if let tuple2CLType = from["Tuple2"] as? [AnyObject] {
            var tuple1:CLType?
            var tuple2:CLType?
            var counter : Int = 0;
            for oneTuple in tuple2CLType {
                if counter == 0 {
                    tuple1 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                } else if counter == 1 {
                    tuple2 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                }
                counter += 1
            }
            return .Tuple2(tuple1!, tuple2!)
        }
        
        if let tuple3CLType = from["Tuple3"] as? [AnyObject] {
            var tuple1:CLType?
            var tuple2:CLType?
            var tuple3:CLType?
            var counter : Int = 0;
            for oneTuple in tuple3CLType {
                if counter == 0 {
                    tuple1 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                } else if counter == 1 {
                    tuple2 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                } else if counter == 2 {
                    tuple3 = CLTypeHelper.directJsonToCLType(from: oneTuple)
                }
                counter += 1
            }
            return .Tuple3(tuple1!, tuple2!,tuple3!)
           
        }
        
        if let optionCLType = from["Option"] as? String {
            clType = CLTypeHelper.stringToCLTypePrimitive(input: optionCLType)
            return .Option(clType)
        } else if let optionCLType = from["Option"] as? AnyObject {
            if !(optionCLType is NSNull) {
                clType = CLTypeHelper.jsonToCLTypeCompound(from: optionCLType)
                return .Option(clType)
            }
        }
        if let resultCLType = from["Result"] as? AnyObject {
            if !(resultCLType is NSNull) {
                let okCLType = CLTypeHelper.jsonToCLType(from: resultCLType,keyStr: "ok")
                let errCLType = CLTypeHelper.jsonToCLType(from: resultCLType,keyStr: "err")
                return .Result(okCLType, errCLType)
            } else {
                NSLog("parse result cltype error")
            }
        }
        return .NONE
    }
    /**
     Get CLType  from Json string. If the Json string can convert to CLType primitive, then return the CLType primitive, otherwise return the CLType getting from the CLType compound
     - Parameter : a Json String represent the CLType object
     - Returns: CLType object
     */
    public static func directJsonToCLType(from:AnyObject?)->CLType {
        var ret :CLType = .NONE
        if let clTypeWrapper = from as? String {
            ret = CLTypeHelper.stringToCLTypePrimitive(input: clTypeWrapper)
            return ret
        }
        if let clTypeWrapper = from {
            ret = CLTypeHelper.jsonToCLTypeCompound(from: clTypeWrapper)
        }
        return ret;
    }
    /**
     Get CLType primitive from String
     - Parameter : a  String represent the CLType object
     - Returns: CLType object
     */
    public static func stringToCLTypePrimitive(input:String)->CLType {
        if input == "String" {
            return .String
        } else if input == "Bool" {
            return .Bool
        } else if input == "U8" {
            return .U8
        } else if input == "U32" {
            return .U32
        } else if input == "U64" {
            return .U64
        } else if input == "U128" {
            return .U128
        } else if input == "I32" {
            return .I32
        } else if input == "I64" {
            return .I64
        } else if input == "U256" {
            return .U256
        } else if input == "U512" {
            return .U512
        } else if input == "String" {
            return .String
        } else if input == "Key" {
            return .Key
        } else if input == "URef" {
            return .URef
        } else if input == "PublicKey" {
            return .PublicKey
        } else if input == "Any" {
            return .CLAny
        } else if input == "Unit" {
            return .Unit
        }
        return .NONE
    }
}

