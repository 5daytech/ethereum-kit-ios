//
//  IContract.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/30/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import Foundation

protocol IContract {
  associatedtype Wallet
  associatedtype ReadResult
  associatedtype WriteResult
  
  var wallet: Wallet { get }
  
  func read(methodName: String, params: [AnyObject]) -> ReadResult
  func write(methodName: String, params: [AnyObject], ethPrice: String) -> WriteResult
}
