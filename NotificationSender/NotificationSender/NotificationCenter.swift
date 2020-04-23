//
//  NotificationCenter.swift
//  NotificationSender
//
//  Created by Jason Clemens on 4/23/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import UserNotifications

struct Notification {
    var id: String
    var title: String
    var datetime: DateComponents
}

class NotificationCenter {
    static var instance: NotificationCenter {
        get {
            if NotificationCenter._instance == nil {
                NotificationCenter._instance = NotificationCenter()
            }
            return _instance!
        }
    }
    static private var _instance: NotificationCenter?
    
    init() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted == true && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    var notifications = [Notification]()
    
}
