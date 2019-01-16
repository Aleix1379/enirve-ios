//
//  verb.swift
//  enirve
//
//  Created by Aleix Martínez on 20/09/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//

import Foundation

class Verb: NSObject, Decodable {
    var id: Int!
    var present: String!
    var simple: String!
    var participle: String!
    var matched: Bool = false
    var itemClass: String?
    
    init (id: Int, present: String, simple: String, participle: String, matched: Bool, itemClass: String) {
        self.id = id
        self.present = present
        self.simple = simple
        self.participle = participle
        self.matched = matched
        self.itemClass = itemClass
    }

    override var description: String {
        return "Present: \(self.present!) Simple: \(self.simple!) Participle: \(self.participle!)"
    }
}
