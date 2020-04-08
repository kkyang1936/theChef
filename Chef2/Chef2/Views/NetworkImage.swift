//
//  NetworkImage.swift
//  Chef
//
//  Created by Jason Clemens on 2/12/20.
//  Copyright © 2020 Executive Chef. All rights reserved.
//

import SwiftUI
import URLImage

struct NetworkImage: View {

    let url: URL

    var body: some View {
        URLImage(url, placeholder: {
            ProgressView($0) { progress in
                Image("recipe-default-image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
        }, content: {
            $0.image
                .resizable()
                .aspectRatio(contentMode: .fill)
        })
    }
}

struct NetworkImage_Previews: PreviewProvider {
    static var previews: some View {
        NetworkImage(url: URL(string: "https://images.media-allrecipes.com/userphotos/560x315/1029125.jpg")!)
    }
}
