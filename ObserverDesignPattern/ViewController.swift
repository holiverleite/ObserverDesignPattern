//
//  ViewController.swift
//  ObserverDesignPattern
//
//  Created by monitora on 11/09/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ObservedProtocol {
    
    @IBOutlet weak var topBox: UIView!
    @IBOutlet weak var middleBox: UIView!
    @IBOutlet weak var bottomBox: UIView!
    
    var networkConnectionHandler0 : NetworkConnectionHandler?
    var networkConnectionHandler1 : NetworkConnectionHandler?
    var networkConnectionHandler2 : NetworkConnectionHandler?
    
    let statusKey: StatusKey = StatusKey.networkStatusKey
    let notification: Notification.Name = .networkConnection

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.networkConnectionHandler0 = NetworkConnectionHandler(view: self.topBox)
        self.networkConnectionHandler1 = NetworkConnectionHandler(view: self.middleBox)
        self.networkConnectionHandler2 = NetworkConnectionHandler(view: self.bottomBox)
    }
    
    @IBAction func switchChanged(_ sender: Any) {
        guard let networkSwitch: UISwitch = sender as? UISwitch else {
            return
        }
        
        if networkSwitch.isOn {
            notifyObservers(about: NetworkConnectionStatus.connected.rawValue)
        } else {
            notifyObservers(about: NetworkConnectionStatus.disconnected.rawValue)
        }
    }
}

