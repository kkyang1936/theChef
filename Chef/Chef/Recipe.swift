//
//  Recipe.swift
//  Chef
//
//  Created by Jason Clemens on 2/4/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI

struct Recipe: Hashable, Codable {
    var name: String
    var imageURL: URL?
    var ingredients: [String]
    var steps: [String]
}
