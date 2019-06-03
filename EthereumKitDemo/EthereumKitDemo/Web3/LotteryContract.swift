//
//  LotteryContract.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/30/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import Foundation
import EthereumKit

class LotteryContract: BaseContract {
  
  let address: String
  
  init(walletAddress: String, privateKey: Data, networkType: EthereumKit.NetworkType) {
    switch networkType {
    case .ropsten:
      address = Constants.Lottery.rophstenAddress
    case .kovan:
      address = Constants.Lottery.kovanAddress
    default:
      fatalError()
    }
    super.init(walletAddress: walletAddress, contractAddress: address, contractAbi: Constants.Lottery.abi, privateKey: privateKey, networkType: networkType)
  }
  
  func getWinnerAddresses() {
    print(#function)
    let res = read(methodName: "getWinnerAddresses", params: [])
    print(res)
  }
  
  func selectWinner() {
    print(#function)
    let res = write(methodName: "selectWinner", params: [])
    print(res)
  }
  
  func manager() {
    print(#function)
    let res = read(methodName: "manager", params: [])
    print(res)
  }
  
  func getPlayers() {
    print(#function)
    let res = read(methodName: "getPlayers", params: [])
    print(res)
  }
  
  func getWinAmountHistory() {
    print(#function)
    let res = read(methodName: "getWinAmountHistory", params: [])
    print(res)
  }
  
  func playersCount() {
    print(#function)
    let res = read(methodName: "playersCount", params: [])
    print(res)
  }
  
  func join() {
    print(#function)
    let res = write(methodName: "join", params: [], ethPrice: "0.2")
    print(res)
  }
  
  func alreadyJoined() {
    print(#function)
    let res = read(methodName: "alreadyJoined", params: [])
    print(res)
  }
  
  func currentGain() {
    print(#function)
    let res = read(methodName: "currentGain", params: [])
    print(res)
  }
  
  func getTimesPlayed() {
    print(#function)
    let res = read(methodName: "getTimesPlayed", params: [])
    print(res)
  }
  
  // Event ReceiverEther
  // Event WinnerEvent
}
