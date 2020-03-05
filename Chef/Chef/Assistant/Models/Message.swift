//
//  Message.swift
//  TestApp
//
//  Created by Stephen Radvansky on 3/4/20.
//  Copyright © 2020 Stephen Radvansky. All rights reserved.
//

import Foundation
import AssistantV2


struct Message: Hashable {
    var content: String
    var user: User
}
class DataSource : ObservableObject{
    static let Watson = User(name: "Watson Assistant", avatar: "Watson")
    static var currentUser = User(name: "Stephen", avatar: "myAvatar", isCurrentUser: true)
}
