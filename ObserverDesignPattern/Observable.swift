//
//  Observable.swift
//  ObserverDesignPattern
//
//  Created by monitora on 11/09/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
    static let networkConnection = Notification.Name("networkConnection")
}

enum NetworkConnectionStatus: String {
    case connected
    case disconnected
}

enum StatusKey: String {
    case networkStatusKey
}

protocol ObservableProtocol {
    var statusValue : String { get set }
    var statusKey : String { get }
    var notificationOfInterest: Notification.Name { get }
    
    func subscribe()
    func unsubscribe()
    func handleNotification()
}

class Observer: ObservableProtocol {
    var statusValue: String
    var statusKey: String
    var notificationOfInterest: Notification.Name
    
    init(statusKey: StatusKey, notification: Notification.Name) {
        self.statusValue = ""
        self.statusKey = statusKey.rawValue
        self.notificationOfInterest = notification
        
        self.subscribe()
    }
    
    func subscribe() {
        NotificationCenter.default.addObserver(self, selector: #selector(receiveNotification(_:)), name: notificationOfInterest, object: nil)
    }
    
    func unsubscribe() {
        NotificationCenter.default.removeObserver(self, name: self.notificationOfInterest, object: nil)
    }
    
    func handleNotification() {
        fatalError("Error")
    }
    
    @objc func receiveNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo, let status = userInfo[statusKey] as? String {
            self.statusValue = status
            self.handleNotification()
            
            print("Notification \(notification.name) received")
            print("Status \(status)")
        }
    }
    
    deinit {
        self.unsubscribe()
    }
}

class NetworkConnectionHandler: Observer {
    var view: UIView
    
    init(view: UIView) {
        self.view = view
        super.init(statusKey: .networkStatusKey, notification: .networkConnection)
    }
    
    override func handleNotification() {
        if self.statusValue == NetworkConnectionStatus.connected.rawValue {
            self.view.backgroundColor = UIColor.green
        } else {
            self.view.backgroundColor = UIColor.red
        }
    }
}

protocol  ObservedProtocol {
    var statusKey : StatusKey { get }
    var notification: Notification.Name { get }
    func notifyObservers(about changeTo: String)
}

extension ObservedProtocol {
    func notifyObservers(about changeTo: String) {
        NotificationCenter.default.post(name: notification, object: self, userInfo: [statusKey.rawValue : changeTo])
    }
}
