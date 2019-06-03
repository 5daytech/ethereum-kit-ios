//
//  GreeterContract.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/30/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import Foundation
import web3swift
import EthereumKit

class GreeterContract: BaseContract {
  typealias ReadResult = [String: Any]
  typealias WriteResult = TransactionSendingResult
  
  var address: String
  
  init(walletAddress: String, privateKey: Data, networkType: EthereumKit.NetworkType) {
    switch networkType {
    case .ropsten:
      address = Constants.Greeter.rophstenAddress
    case .kovan:
      address = Constants.Greeter.kovanAddress
    default:
      fatalError()
    }
    super.init(walletAddress: walletAddress, contractAddress: address, contractAbi: Constants.Greeter.abi, privateKey: privateKey, networkType: networkType)
  }

  func add() {
    write(methodName: "add", params: [])
  }

  func getCounter() -> Int {
    let res = read(methodName: "getCounter", params: [])
    print(res)
    let str = String(describing: res["0"]!)
    return Int(str)!
  }

  func subsctruct() {
    write(methodName: "substruct", params: [])
  }

  func setGreeting(greet: String) {
    write(methodName: "setGreeting", params: [greet as AnyObject])
  }

  func greet() -> String {
    let res = read(methodName: "greet", params: [])
    print(res)
    return String(describing: res["0"]!)
  }
}
