//
//  URL+SY.swift
//  SYProxy
//
//  Created by Stanislas Chevallier on 02/06/15.
//  Copyright (c) 2015 Syan. All rights reserved.
//

import Foundation

extension URL {
    init(googleSearchQuery query: String) {
        var components = URLComponents(string: "https://www.google.com/search")!
        components.queryItems = [.init(name: "q", value: query)]
        self.init(string: components.url!.absoluteString)!
    }
}
