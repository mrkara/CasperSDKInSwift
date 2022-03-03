import XCTest
@testable import CasperSDKInSwift
final class TestSecp256k1KeyWrapper: XCTestCase {
    func testAll()  {
        let secp256k1 : Secp256k1Crypto = Secp256k1Crypto();
        do {
            let pemFile:String = "Assets/Secp256k1/privateKeySecp256k1.pem"// "/secp256k1/SwiftSecp256K1AutoGenerated.pem"
            let secp256k1PrivateKey =  try secp256k1.readPrivateKeyFromFile(pemFileName: pemFile)
            let (privateKey,publicKey) = secp256k1.secp256k1GenerateKey()
            //test for write to Pem file
            /*let isSuccess = try secp256k1.writePrivateKeyToPemFile(privateKeyToWrite: privateKey, fileName: "/secp256k1/SwiftSecp256k1PrivateKeyAutoGen1.pem")
            if isSuccess {
                NSLog("Success write to file")
            } else {
                NSLog("Fail write to file")
            }*/
        } catch {
            NSLog("Error secp256k1:\(error)")
        }
    }
}
