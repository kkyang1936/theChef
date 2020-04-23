//
//  Notification.swift
//  Chef2
//
//  Created by Jason Clemens on 4/23/20.
//  Copyright © 2020 ExecutiveChef. All rights reserved.
//

import Foundation
import UIKit

struct NotificationManager {
	static func registerLocalTimerNotification(displayAt: Date) {
		let delegate = UIApplication.shared.delegate as? AppDelegate
		delegate?.registerLocalTimerNotification(displayAt: displayAt)
		
		//TODO schedule a Timer that executes if the app wasn't closed.
	}
}

