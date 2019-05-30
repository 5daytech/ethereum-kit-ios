//
//  BaseContract.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/30/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import Foundation
import web3swift
import EthereumKit

class BaseContract: IContract {  
  typealias Wallet = EthereumAddress
  typealias ReadResult = [String: Any]
  typealias WriteResult = TransactionSendingResult

  var wallet: EthereumAddress  
  private let contract: web3.web3contract

  init(walletAddress: String, contractAddress: String, contractAbi: String, privateKey: Data, networkType: EthereumKit.NetworkType) {
    guard let wallet = Wallet(walletAddress) else { fatalError("Cannot create wallet") }
    self.wallet = wallet

    guard let contractAddressEth = EthereumAddress(contractAddress) else { fatalError("Cannot create contract address") }
    let web3 = Web3.InfuraRopstenWeb3()
    guard let contract = web3.contract(contractAbi, at: contractAddressEth, abiVersion: 2) else { fatalError("Cannot create web3contract") }
    self.contract = contract

    do {
      guard let ether = try EthereumKeystoreV3(privateKey: privateKey) else { fatalError("Cannot create etherium keystore v3") }
      let keystore = KeystoreManager([ether])
      web3.addKeystoreManager(keystore)
    } catch {
      fatalError("Cannot create etherium keystore v3")
    }
  }

  func read(methodName: String, params: [AnyObject]) -> ReadResult {
    let extraData: Data = Data()
    var transactionOptions: TransactionOptions = TransactionOptions.defaultOptions
    transactionOptions.from = wallet
    transactionOptions.gasLimit = .automatic
    transactionOptions.gasPrice = .automatic
    guard let transaction = contract.read(methodName, parameters: params, extraData: extraData, transactionOptions: transactionOptions) else {
      fatalError("Cannot create read transation")
    }
    do {
      let result = try transaction.call()
      return result
    } catch {
      fatalError("Cannot call transaction")
    }
  }

  func write(methodName: String, params: [AnyObject], ethPrice: String = "0") -> WriteResult {
    let extraData: Data = Data()
    let amount = Web3.Utils.parseToBigUInt(ethPrice, units: .eth)
    var transactionOptions: TransactionOptions = TransactionOptions.defaultOptions
    transactionOptions.value = amount
    transactionOptions.from = wallet
    transactionOptions.gasLimit = .automatic
    transactionOptions.gasPrice = .automatic
    guard let transaction = contract.write(methodName, parameters: params, extraData: extraData, transactionOptions: transactionOptions) else {
      fatalError("Cannot create write transation")
    }
    do {
      let result = try transaction.send()
      return result
    } catch {
      fatalError("Cannot send transaction")
    }
  }
}

