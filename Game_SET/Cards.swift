//
//  Cards.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 30.11.2020.
//  Copyright © 2020 Алексей Сергеев. All rights reserved.
//

import Foundation

struct Card: Hashable {
    var hashValue: Int { return cardIdentifier }
    
    private var cardIdentifier: Int
    
    let attributes: [Int]
    
    private static var identifierFactory = 0
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.cardIdentifier = Card.getUniqueIdentifier()
        let getPersonalAttributes = PersonalAttributesOfCard()
        attributes = getPersonalAttributes.givenAttributes
    }
}

