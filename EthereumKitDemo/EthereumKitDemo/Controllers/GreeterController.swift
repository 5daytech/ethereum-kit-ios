//
//  GreeterController.swift
//  EthereumKitDemo
//
//  Created by Abai Abakirov on 5/30/19.
//  Copyright © 2019 Horizontal Systems. All rights reserved.
//

import UIKit

class GreeterController: UIViewController {
  @IBOutlet weak var counterLabel: UILabel!
  @IBOutlet weak var greetLabel: UILabel!
  @IBOutlet weak var greetField: UITextField!
  
  var contract: GreeterContract!
  
  override func viewDidLoad() {
    
    navigationItem.title = "Greeter contract"
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresh))
    
    greetField.delegate = self
    
    let wallet = Manager.shared.ethereumAdapter.receiveAddress
    let key = Manager.shared.ethereumKit.privateKey!
    let network = Configuration.shared.networkType
    contract = GreeterContract(walletAddress: wallet, privateKey: key, networkType: network)
    updateCounter()
    updateGreeter()
  }
  
  @objc private func refresh() {
    updateCounter()
    updateGreeter()
  }
  
  private func updateCounter() {
    let res = contract.getCounter()
    counterLabel.text = "\(res)"
  }
  
  private func updateGreeter() {
    let res = contract.greet()
    greetLabel.text = res
  }
  
  @IBAction func substructAction(_ sender: Any) {
    contract.subsctruct()
    updateCounter()
  }
  
  @IBAction func addAction(_ sender: Any) {
    contract.add()
    updateCounter()
  }
  
  @IBAction func greetAction(_ sender: Any) {
    if greetField.text == nil || greetField.text == "" {
      return
    }
    let text = greetField.text!
    contract.setGreeting(greet: text)
    updateGreeter()
  }
}

extension GreeterController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
}
