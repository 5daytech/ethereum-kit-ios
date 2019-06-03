//
//  LotteryController.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/31/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import UIKit

class LotteryController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    let wallet = Manager.shared.ethereumAdapter.receiveAddress
    let key = Manager.shared.ethereumKit.privateKey!
    let network = Configuration.shared.networkType
    
    let contract = LotteryContract(walletAddress: wallet, privateKey: key, networkType: network)
    
    contract.playersCount()
    contract.getPlayers()
    contract.getTimesPlayed()
    contract.getWinnerAddresses()
    contract.getWinAmountHistory()
    
    contract.alreadyJoined()
    contract.join()
//    contract.alreadyJoined()
//
//    contract.selectWinner()
  }
}
