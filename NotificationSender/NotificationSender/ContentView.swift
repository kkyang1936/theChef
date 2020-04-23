//
//  ContentView.swift
//  NotificationSender
//
//  Created by Jason Clemens on 4/23/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .onAppear() {
                DispatchQueue.main.async {
                    let content = UNMutableNotificationContent()
                    content.title = "Weekly Staff Meeting"
                    content.body = "Every Tuesday at 2pm"
                    var dateComponents = DateComponents()
                    dateComponents.calendar = Calendar.current
                    dateComponents.month = 4
                    dateComponents.day = 23
                    dateComponents.year = 2020
                    dateComponents.hour = Calendar.current.component(.hour, from: Date())
                    dateComponents.minute = Calendar.current.component(.minute, from: Date()) + 1
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                    let uuidString = UUID().uuidString
                    let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
                    let notificationCenter = UNUserNotificationCenter.current()
                    notificationCenter.add(request) { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        } else {
                            print("Notification should have been delivered")
                        }
                    }
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
