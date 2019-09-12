//
//  Observable.swift
//  ObserverDesignPattern
//
//  Created by monitora on 11/09/19.
//  Copyright © 2019 Haroldo Leite. All rights reserved.
//

import Foundation

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
        }
    }
    
    deinit {
        self.unsubscribe()
    }
}
