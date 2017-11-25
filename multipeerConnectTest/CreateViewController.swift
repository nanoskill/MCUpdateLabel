//
//  CreateViewController.swift
//  multipeerConnectTest
//
//  Created by Christhopher Ravian Hartono on 25/11/17.
//  Copyright © 2017 Communication iOS Foundation Batch 4. All rights reserved.
//

import UIKit
import MultipeerConnectivity

class CreateViewController: UIViewController, ConnectivityModelDelegate{

    @IBOutlet weak var theTable: UITableView!
    var conn = (UIApplication.shared.delegate as! AppDelegate).conn
    //var game = Game()
    
    override func viewDidLoad() {
        conn?.delegate = self
        theTable.dataSource = self
        theTable.delegate = self
        conn?.serviceBrowser.startBrowsingForPeers()
    }

    func foundPeer() {
        theTable.reloadData()
    }
    
    
    func lostPeer() {
        theTable.reloadData()
    }
    
    func invitationWasReceived(fromPeer: String) {
        
    }
    
    func connectedWithPeer(peerID: MCPeerID, state: MCSessionState) {
        if state == .connected
        {
            let popup = UIAlertController(title: "Connected", message: "You are now connected with \(peerID.displayName)", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: nil)/*{
                (UIAlertAction) in
                self.performSegue(withIdentifier: "createRoomSegue", sender: nil)
            })*/
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
        }
        if state == .notConnected
        {
            let popup = UIAlertController(title: "Disonnected", message: "Connection to \(peerID.displayName) has been lost", preferredStyle: .alert)
            let popupOk = UIAlertAction(title: "Okay", style: .default, handler: nil)
            popup.addAction(popupOk)
            self.present(popup, animated: true, completion: nil)
        }
    }
    
    @IBAction func nextPage(_ sender: Any) {
        performSegue(withIdentifier: "createRoomSegue", sender: sender)
    }
    
   /* override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail"
        {
            let dest = segue.destination as! SharingScreenController
            dest.game = game
        }
    }*/
    
}

extension CreateViewController: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (conn?.foundPeers.count)!
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = theTable.dequeueReusableCell(withIdentifier: "theCell", for: indexPath)
        cell.textLabel?.text = conn?.foundPeers[indexPath.row].displayName
        return cell
    }
}

extension CreateViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let sb = conn?.serviceBrowser
        sb?.invitePeer((conn?.foundPeers[indexPath.row])!, to: (conn?.session)!, withContext: nil, timeout: 10)
    }
}
