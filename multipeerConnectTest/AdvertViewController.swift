//
//  AdvertViewController.swift
//  multipeerConnectTest
//
//  Created by Christhopher Ravian Hartono on 25/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class AdvertViewController: UIViewController {
    var conn = (UIApplication.shared.delegate as! AppDelegate).conn
    
    @IBOutlet weak var theLabel:UILabel!
    @IBOutlet weak var theLoading:UIActivityIndicatorView!
    
    var assist:MCAdvertiserAssistant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        conn?.serviceAdvertiser.startAdvertisingPeer()
        conn?.delegate = self
        print("Broadcasting now with peerID: \((conn?.myPeerId.displayName)!)")
        theLabel.text = "Waiting for Invitation"
        theLoading.startAnimating()
    }
}

extension AdvertViewController: ConnectivityModelDelegate
{
    func foundPeer() {
        
    }
    func lostPeer() {
        
    }
    func invitationWasReceived(fromPeer: String) {
        let popup = UIAlertController(title: "Invitation", message: "Invitation from \(fromPeer) Do you want to accept this invitation?", preferredStyle: .alert)
        let popupYes = UIAlertAction(title: "Accept", style: .default) { _ in
            self.conn?.invitationHandler(true, self.conn?.session)
        }
        let popupNo = UIAlertAction(title: "Decline", style: .destructive) { _ in
            self.conn?.invitationHandler(false, self.conn?.session)
        }
        
        popup.addAction(popupYes)
        popup.addAction(popupNo)
        
        self.present(popup, animated: true, completion: nil)
    }
    
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState) {
        OperationQueue.main.addOperation {
            let stateString = (state == .connected ? "Connected" : (state == .notConnected ? "Disconnected" : "Connecting"))
            self.theLabel.text = "\(stateString) with \(peerID.displayName)"
        }
        if state == .connected
        {
            let popup = UIAlertController(title: "Connected", message: "You are now connected with \(peerID.displayName)", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: {
                (UIAlertAction) in
                self.performSegue(withIdentifier: "joinRoomSegue", sender: nil)
                
                self.conn?.terminateBroadcast()
                })
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
            OperationQueue.main.addOperation {
                self.theLoading.isHidden = true
            }
        }
        if state == .notConnected
        {
            let popup = UIAlertController(title: "Disconnected", message: "Connection to \(peerID.displayName) has been lost", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: nil)
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
        }
    }
}
