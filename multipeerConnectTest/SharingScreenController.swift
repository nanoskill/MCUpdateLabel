//
//  SharingScreenController.swift
//  multipeerConnectTest
//
//  Created by Christhopher Ravian Hartono on 25/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class SharingScreenController: UIViewController{
    @IBOutlet weak var textField: UITextField!

    let session = (UIApplication.shared.delegate as! AppDelegate).conn.session
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func buttonDidTap(_ sender: Any) {
        do {
            print("Trying to sending \(textField.text!) to \(session!.connectedPeers.count) peer(s)")
            try session?.send(textField.text!.data(using: .utf8)!, toPeers: session!.connectedPeers, with: .reliable)
        } catch let error {
            print("Error rav.. \(error.localizedDescription)")
        }
    }
}
