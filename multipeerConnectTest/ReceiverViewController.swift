//
//  ReceiverViewController.swift
//  multipeerConnectTest
//
//  Created by Christhopher Ravian Hartono on 25/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class ReceiverViewController: UIViewController, MCSessionDelegate {
    
    @IBOutlet weak var label: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let session = (UIApplication.shared.delegate as! AppDelegate).conn.session
        session?.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState)
    {
        if state == .connected
        {
            let popup = UIAlertController(title: "Connected", message: "You are now connected with \(peerID.displayName)", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: nil)
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
        }
        if state == .notConnected
        {
            let popup = UIAlertController(title: "Disconnected", message: "Connection to \(peerID.displayName) has been lost", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: {
                (UIAlertAction) in
                self.navigationController?.popViewController(animated: true)
            })
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID)
    {
        print("Receiving: \(String(bytes: data, encoding: .utf8) ?? "")")
        OperationQueue.main.addOperation {
            self.label.text = String(bytes: data, encoding: .utf8)
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID)
    {
        
    }
    
    public func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress)
    {
        
    }
    
    public func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?)
    {
        
    }
}
