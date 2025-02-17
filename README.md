
# casper-swift-sdk

Swift sdk library for interacting with a CSPR node.

## What is casper-swift-sdk?

SDK  to streamline the 3rd party Swift client integration processes. Such 3rd parties include exchanges & app developers. 

## System requirement


The SDK use Swift 5.0 and support device running IOS from 10.0, MacOS from 10.4.4, WatchOS from 5.3, tvOS from 12.3


## Build and test from terminal 

Go to the SDK root folder.

- Build command in terminal, type this in terminal

```swift
swift build
```

- Test command in terminal, type this in terminal

```swift
swift test
```

- For a full build,test on the SDK, run the following command

```swift
swift package clean

swift build

swift test
```

Note: The project is built and tested successfully without error and warning in Xcode. There are 2 warnings in Github automated script for building or when you run with build script "swift build" in Terminal. The warnings comes from the external package https://github.com/leif-ibsen/SwiftECC.git, which refers to the unused result of 2 function calls, in detail the two warnings are:

1) SwiftECC/Sources/SwiftECC/Domain2/Domain2.swift, at line 196: result of call to 'add' is unused
                seq1.add(ASN1Integer(BInt(self.rp.k1)))
                
2) SwiftECC/Sources/SwiftECC/Domain2/Domain2.swift, at line 198: result of call to 'add' is unused
                seq1.add(ASN1Sequence()
                
The result maybe used for the next work of the external package. (More implementation or extenstion of the encrypting functions).

It does not effect the overall performance or cause any problem to the SDK. 

## Build and test from Xcode IDE

In order to build and test the SDK from Xcode, you need to have a Mac run MacOS and Xcode 13 (or above) installed.

To install Xcode 13 go to this link: https://developer.apple.com/xcode/

Once you have Xcode 13 or above installed in your Mac machine, download or clone the CasperSDKInSwift from Github. An easy way to clone the SDK is just to open XCode and choose "Clone an existing project" in the left panel like what it is in the image below

<img width="803" alt="Screen Shot 2022-03-14 at 11 16 26" src="https://user-images.githubusercontent.com/94465107/158104000-25f5ca27-93ea-4c51-886e-cdd4a2459703.png">

Enter the Github url (for example "https://github.com/hienbui9999/CasperSDKInSwift.git")  for the Clone address, then hit "Clone"

<img width="701" alt="Screen Shot 2022-03-14 at 11 18 20" src="https://user-images.githubusercontent.com/94465107/158104206-155bec32-2a66-459c-8b9c-a8faf1c9f4d2.png">

When you have the SDK and all source code in your local machine, you can then Build or Test the SDK.

To Build the project hit "Product->Build" like this

<img width="1432" alt="Screen Shot 2022-03-14 at 11 22 11" src="https://user-images.githubusercontent.com/94465107/158104446-c31cce1d-f599-4b83-9345-27264f769c89.png">

To Test the project hit "Product->Test" like this

<img width="1440" alt="Screen Shot 2022-03-14 at 11 21 21" src="https://user-images.githubusercontent.com/94465107/158104483-f125952c-b1d2-4f20-8558-7795829acd8b.png">

You can see log information by "View->Debug Area->Active Console" or just press the combination of Key "Cmd + Shift + C"

# Information for Secp256k1, Ed25519 Key Wrapper and Put Deploy

## Key wrapper specification:

The Key wrapper do the following work:(for both Secp256k1 and Ed25519):

- (PrivateKey,PublicKey) generation

- Sign message 

- Verify message

- Read PrivateKey/PublicKey from PEM file

- Write PrivateKey/PublicKey to PEM file

The key wrapper is used in account_put_deploy RPC method to generate approvals signature based on deploy hash.

## Put deploy specification:

The put deploy RPC method implements the call "account_put_deploy". User needs to declare a deploy and assign the information for the deploy (header,payment,session,approvals). The following information is generated based on the deploy:

- Deploy body hash - base on the serialization of deploy body, which is a string of payment serialization + deploy session serialization. Then use the blake2b256 hash over the generated serialized string to make the deploy body hash. The deploy body hash is an attribute of the deploy header.

- Deploy hash: Use the blake2b256 hash over the header of the deploy.

- Signature in deploy approvals is generated using the deploy hash using the key wrapper to sign over the deploy hash. You can use either Secp256k1 or Ed25519 to sign over the deploy hash, based on the account type of the deploy. If the deploy use account of type Secp256k1 then you have to sign with Secp256k1 key. If the deploy use account of type Ed25519 then you have to sign with Ed25519 key.

- The whole deploy with full information is then serialized to a Json string and sent with a POST request to Casper main or test net, or localhost to call account_put_deploy RPC method.

### To call the Put Deploy correctly, remember to do the following thing:

- Know what your account type is, Ed25519 or Secp256k1.

- Save your private key in 1 place that you can point to from code.

- Choose correct path to private key to sign for the deploy hash in put deploy function.

# Information for CLType, CLValue and Serialization

- [CLType](./Docs/Help.md#cltype)

- [CLValue](./Docs/Help.md#clvalue)

- [Casper Domain Specific Objects](./Docs/Help.md#casper-domain-specific-objects)

- [Serialization](./Docs/Help.md#serialization)

# Documentation for classes and methods


* [List of classes and methods](./Docs/Help.md)

-  [Get State Root Hash](./Docs/Help.md#i-get-state-root-hash)

-  [Get Peer List](./Docs/Help.md#ii-get-network-peers-list)

-  [Get Deploy](./Docs/Help.md#iii-get-deploy)

-  [Get Node Status](./Docs/Help.md#iv-get-node-status)

-  [Get Block Transfer](./Docs/Help.md#v-get-blocktransfers)

-  [Get Block](./Docs/Help.md#vi-get-block)

-  [Get EraInfo By Switch Block](./Docs/Help.md#vii-get-erainfo-by-switch-block)

-  [Get State Item](./Docs/Help.md#viii-get-stateitem)

-  [Get Dictionary Item](./Docs/Help.md#ix-get-dictionaryitem)

-  [Get Balance](./Docs/Help.md#x-get-balance)

-  [Get Current Auction State](./Docs/Help.md#x-get-balance)

## Flow of processing:

Instantiate one instance of the CasperSKD, which is defined in file "CasperSDK.swift". In the test section of this project we instantiate it from "CasperSDKInSwiftTests.swift" file and set parameter and call the methods from this file.

The call for each method will then send POST request and get data back from server, this process is done in "HttpHandler" file.

For processing the data back from server (as Json format), base on which method call, the corresponding class and functions will be call to catch and put data in proper data structure, which started from this code line "if self.methodCall == .chainGetStateRootHash {" in "HttpHandler" file.


# Usage examples 

## Create a Client

To query a node, use the CasperSDK as the entry point. Instantiate CasperSDK with the URL address for calling Casper method, like this:

```swift
let casperSDK:CasperSKD = CasperSDK(url:"https://node-clarity-testnet.make.services/rpc");
```

You can change the method url by running this code line

```swift
casperSDK.setMethodUrl(url: "https://node-clarity-mainnet.make.services/rpc")
```

## RPC Calls

### I. Get State Root Hash  

Retrieves  the state root hash String. There are 3 cases for calling this method

1 - call method without any param
2 - call method with BlockHash param
3 - call method with BlockHeight param

And this is the detail for each cases:

1- call method without any param:

``` swift
let getStateRootHashParam:GetStateRootHashParam = GetStateRootHashParam();
do {
    try casperSDK.getStateRootHash(getStateRootHashParam: getStateRootHashParam)
} catch {
    throw error
}
```

2 - call method with BlockHash param - You can test with other block_hash by replacing the below hash in .Hash("") parameter

``` swift
do {
    getStateRootHashParam.block_identifier = .Hash("20e6cf8001a9456e9e202f0923393b1f551470934683800f62d11c1685d4710d")
    try casperSDK.getStateRootHash(getStateRootHashParam: getStateRootHashParam)
} catch {
    throw error
}
```

3 - call method with BlockHeight param - You can test with other block Height by replacing the below Height in the .Height() parameter

``` swift
do {
    getStateRootHashParam.block_identifier = .Height(473861)
    try casperSDK.getStateRootHash(getStateRootHashParam: getStateRootHashParam)
} catch {
    throw error
}
```

### II. Get network peers list  

Retrieves  a list of Peers.

``` swift
       
do {
    try casperSDK.getPeers()
} catch {
    throw error
}
```

### III. Get Deploy

Retrieves a Deploy object.

call parameters :
- deploy hash

``` swift
do {
      let getDeployParam:GetDeployParams = GetDeployParams();
      getDeployParam.deploy_hash = "1b6a2f1a67bc087babe46455f4c6e7775528999fd3a37dbcba5b438f439abda2";
      try casperSDK.getDeploy(getDeployParam: getDeployParam)
} catch {
    throw error
  }
```

###  IV. Get Node Status

Retrieves a NodeStatus object.

``` swift
do {
    try casperSDK.getStatus()
} catch {
    throw error
}
```
### V. Get BlockTransfers

Retrieves Transfert List within a block.

call parameters :

- block_identifier, and enum type which can be either BlockHash or BlockHeight 

Call by BlockHash, you can change the BlockHash in the .Hash("") parameter

``` swift
do {
    let block_identifier : BlockIdentifier = .Hash("ae173969cb6ce3c99439c81e5b803c15797a8559796d980daa99f52beb7192e3")
    try casperSDK.getBlockTransfers(input: block_identifier)
}  catch {
    throw error
}
```

Call by BlockHeight, you can change the BlockHeight in the .Height() parameter

``` swift
do {
    let block_identifier  : BlockIdentifier = .Height(448471)
    try casperSDK.getBlockTransfers(input: block_identifier)
}  catch {
    throw error
}
```

### VI. Get Block 

Retrieves a Block object.

call parameters :

- block_identifier, and enum type which can be either BlockHash or BlockHeight

Call by BlockHash, you can change the BlockHash in the .Hash("") parameter

``` swift
do {
    let block_identifier2 : BlockIdentifier = .Hash("830fd58dd08189981d7535fc9de0606bc789b2c8ef2af895ebce5ffc23c4530e")
    try casperSDK.getBlock(input: block_identifier2)
}  catch {
    throw error
}
```

Call by BlockHeight, you can change the BlockHeight in the .Height() parameter

``` swift
do {
    let block_identifier:BlockIdentifier = .Height(449797)
    try casperSDK.getBlock(input: block_identifier)
}  catch {
    throw error
}
```

### VII. Get EraInfo By Switch Block 

Retrieves an EraSummury object.

call parameters :

- switch  block (last block within an era) hash, which is a block_identifier, and enum type which can be either BlockHash or BlockHeight

Call by BlockHeight, you can change the BlockHeight in the .Height() parameter

``` swift
do {
    let block_identifier:BlockIdentifier = .Height(441636)
    try casperSDK.getEraBySwitchBlock(input: block_identifier)
} catch {
    throw error
}
```

Call by BlockHash, you can change the BlockHash in the .Hash("") parameter

``` swift
do {
    let block_identifier:BlockIdentifier = .Hash("83a86ba2d753d85cdd974cf2bb0f6cb5d446f00c2f7f89b5a5e4fef208b19fcc")
    try casperSDK.getEraBySwitchBlock(input: block_identifier)
} catch {
    throw error
}
```

### VIII. Get StateItem

Retrieves a StoredValue object.

Here is some example of getting different kinds of StoredValue

   #### 1. StoredValue as Contract

call parameters :

- state root hash
- contract hash

``` swift
do {
    let getStateItemParam:GetItemParams = GetItemParams();
    getStateItemParam.state_root_hash = "83f6dca28102ecf1cf79d2e32172044b2eacf527e47a8781cead3850d01e6328"
    getStateItemParam.key = "hash-b36478fa545160796de902e61ac504b33bc14624eea245a9df525b4d92d150bc"
    try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```

  #### 2. StoredValue as account

call parameters :

- state root hash
- account hash

``` swift
do {
    let getStateItemParam:GetItemParams = GetItemParams();
    getStateItemParam.state_root_hash = "b31f42523b6799d6d403a3119596c958abf2cdba31066322f01e5fa38ef999aa"
    getStateItemParam.key = "account-hash-ff2ae80f71c1ffcac4921100a21b67ddecf59a30fb86eb6979f47c8838b3b7d3"   
    try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```
  #### 3. StoredValue as transfer

call parameters :

- state root hash
- transfer hash

``` swift
do {
    let getStateItemParam:GetItemParams = GetItemParams();
   // getStateItemParam.state_root_hash = "1416302b2c637647e2fe8c0b9f7ee815582cc7a323af5823313ff8a8684c8cf8"
   // getStateItemParam.key = "transfer-8218fa8c55c19264e977bf2bae9f5889082aee4d2c4eaf9642478173c37d1ed4"
         try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```

  #### 4. StoredValue as DeployInfo

call parameters :

- state root hash
- deploy info hash

``` swift
do {
    let getStateItemParam:GetItemParams = GetItemParams();
    getStateItemParam.state_root_hash = "1416302b2c637647e2fe8c0b9f7ee815582cc7a323af5823313ff8a8684c8cf8"
    getStateItemParam.key = "deploy-a49c06f9b2adf02812a7b2fdcad08804a2ce4896ffec7c06c920d417e7e39cfe"
    try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```

  #### 5. StoredValue as Bid

call parameters :

- state root hash
- bid hash
This example call the main net

``` swift
do {
    casperSDK.setMethodUrl(url: "https://node-clarity-mainnet.make.services/rpc")
    let getStateItemParam:GetItemParams = GetItemParams();
    getStateItemParam.state_root_hash = "647C28545316E913969B032Cf506d5D242e0F857061E70Fb3DF55980611ace86"
    getStateItemParam.key = "bid-24b6D5Aabb8F0AC17D272763A405E9CECa9166B75B745Cf200695E172857c2dD"
     try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```

  #### 6. StoredValue as Withdraw

call parameters :

- state root hash
- withdraw hash
This example call the test net

``` swift
do {
    casperSDK.setMethodUrl(url: "https://node-clarity-mainnet.make.services/rpc")
    let getStateItemParam:GetItemParams = GetItemParams();
    getStateItemParam.state_root_hash = "d360e2755f7cee816cce3f0eeb2000dfa03113769743ae5481816f3983d5f228"
    getStateItemParam.key = "withdraw-df067278a61946b1b1f784d16e28336ae79f48cf692b13f6e40af9c7eadb2fb1"
     try casperSDK.getItem(input: getStateItemParam)
} catch {
    throw error
}
```

### IX. Get DictionaryItem

Retrieves a CLValue object.

call parameters :

- state root hash
- dictionary_identifier (which an enum type defined in this page https://docs.rs/casper-node/latest/casper_node/rpcs/state/enum.DictionaryIdentifier.html) - there can be 4 possible kinds of value for parameters:

 1 - AccountNamedKey
 
 2 - ContractNamedKey
 
 3 - URef
 
 4 - Dictionary

Call specification in detail for each type: 

  #### 1. dictionary_identifier  parameter as  AccountNamedKey

``` swift
 do {
     let getDic : GetDictionaryItemParams = GetDictionaryItemParams();
     getDic.state_root_hash = "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8";
     getDic.dictionary_identifier = DictionaryIdentifier.AccountNamedKey(key: "account-hash-ad7e091267d82c3b9ed1987cb780a005a550e6b3d1ca333b743e2dba70680877", dictionary_name: "dict_name", dictionary_item_key: "abc_name")
         try casperSDK.getDictionaryItem(from: getDic)
 }  catch {
     throw error
 }
 ```
 
   #### 2. dictionary_identifier  parameter as  ContractNamedKey

``` swift
 do {
     let getDic : GetDictionaryItemParams = GetDictionaryItemParams();
     getDic.state_root_hash = "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8";
     getDic.dictionary_identifier = DictionaryIdentifier.ContractNamedKey(key: "hash-d5308670dc1583f49a516306a3eb719abe0ba51651cb08e606fcfc1f9b9134cf", dictionary_name: "dictname", dictionary_item_key: "abcname")
    try casperSDK.getDictionaryItem(from: getDic)
 }  catch {
     throw error
 }
 ```
 
   #### 3. dictionary_identifier  parameter as  URef

``` swift
 do {
     let getDic : GetDictionaryItemParams = GetDictionaryItemParams();
     getDic.state_root_hash = "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8";
     getDic.dictionary_identifier = DictionaryIdentifier.URef(seed_uref: "uref-30074a46a79b2d80cff437594d2422383f6c754de453b732448cc711b9f7e129-007", dictionary_item_key: "abc_name")
             try casperSDK.getDictionaryItem(from: getDic)
 }  catch {
     throw error
 }
 ```
 
   #### 4. dictionary_identifier  parameter as  Dictionary

``` swift
 do {
     let getDic : GetDictionaryItemParams = GetDictionaryItemParams();
     getDic.state_root_hash = "146b860f82359ced6e801cbad31015b5a9f9eb147ab2a449fd5cdb950e961ca8";
     getDic.dictionary_identifier = DictionaryIdentifier.Dictionary( "dictionary-5d3e90f064798d54e5e53643c4fce0cbb1024aadcad1586cc4b7c1358a530373")
 }  catch {
     throw error
 }
 ```
### X. Get Balance

Retrieves the balances(in motes) of an account

call parameters :

- state root hash
- account uref hash


``` swift
        
do {
    let getBP : GetBalanceParams = GetBalanceParams();
    getBP.state_root_hash = "8b463b56f2d124f43e7c157e602e31d5d2d5009659de7f1e79afbd238cbaa189";
    getBP.purse_uref = "uref-be1dc0fd639a3255c1e3e5e2aa699df66171e40fa9450688c5d718b470e057c6-007";
    try casperSDK.getStateBalance(input: getBP)
}  catch {
    throw error
}
 ```
 ### XI. Get current auction state

Retrieves an AutionState object.

call parameters :
- block_identifier, and enum type which can be either BlockHash or BlockHeight 

Call by BlockHash, you can change the BlockHash in the .Hash("") parameter

``` swift
do {
    let block_identifier:BlockIdentifier = .Hash("cb8dab9f455538bc6cedb217a6234faeece8ce32c94d053b5b770450290b3a30")
    try casperSDK.getAuctionInfo(input: block_identifier)
} catch {
    
}
```
Call by BlockHeight, you can change the BlockHeight in the .Height() parameter

``` swift
do {
    let block_identifier:BlockIdentifier = .Height(473576)
    try casperSDK.getAuctionInfo(input: block_identifier)
} catch {
    
}
```

## CLType primitives, Casper Domain Specific Objects, Serialization

### CLType primitives: 

Are built with Swift enumeration type, which consisted of all the value described in this page:

https://docs.rs/casper-types/1.4.6/casper_types/enum.CLType.html

### CLValue

Is the value corresponding to the CLType. In Swift it is built with enumeration type also, with two attributes: CLType and the value of CLType

### Casper Domain Specific Objects: 

Are built with corresponding Swift classes, and in Entity folder

### Serialization

The serialization for CLType, CLValue and Deploy (which consists of Deploy Header, Deploy Session, Deploy Payment, Approvals) is implemented based on the document at this address: https://casper.network/docs/design/serialization-standard#serialization-standard-state-keys

For CLType and CLValue, the serialization is done within class CLTypeSerializeHelper, which consists of two main methods:

 - CLTypeSerialize is for CLType serialization
 
 - CLValueSerialize is for CLValue serialization
 
 For Deploy and Deploy related objects (Deploy Header, Deploy Session, Deploy Payment, Approvals) is done within file DeploySerialization.swift, in which there are classes for the serialization work
  
- DeploySerialization class is for Deploy Serialization

- DeployHeaderSerialization class is for Deploy Header Serialization

- ExecutableDeployItemSerializaton class is for Session and Payment Serialization

- DeployApprovalSerialization class is for Approval Serialization

For detail information please refer to this:

- [CLType](./Docs/Help.md#cltype)

- [CLValue](./Docs/Help.md#clvalue)

- [Casper Domain Specific Objects](./Docs/Help.md#casper-domain-specific-objects)

- [Serialization](./Docs/Help.md#serialization)

## External libraries/package

This package use the following external packages from github

- https://github.com/leif-ibsen/SwiftECC.git for implementing Secp256k1 key Wrapper

- https://github.com/tesseract-one/Blake2.swift.git for implementing blake2b256 hash function

All the packages are under MIT licence.
 

