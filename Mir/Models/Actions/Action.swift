//
//  Action.swift
//  Mir
//
//  Created by Dmitry Rogov on 06.12.2021.
//

import Foundation

struct Action: Decodable {
    var id: String
    var image: String
    var name: String
    var category: String
    var description: String
    var marker: String
    
    var conditions: String
    var date: String
}

extension Action: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}
