//
//  CardAttributes.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 05.12.2020.
//  Copyright © 2020 Алексей Сергеев. All rights reserved.
//

import Foundation

class PersonalAttributesOfCard {
    static var color    = 0
    static var shape    = 0
    static var filling  = 0
    static var quantity = 0
    // shape : romb = 0, vawe = 1, ellipse = 2
    // color : blue = 0,  purple = 1, green = 2
    // filling : none = 0, semi = 1, full = 2
    // quantity : one = 1, two = 2, three = 3
    
    var givenAttributes = [shape, color, filling, quantity]
    
    static func attributesGenerator() -> ([Int]) {
        if quantity < 3 && shape < 3 {
            quantity += 1
            return [shape, color, filling, quantity]
        } else if quantity == 3 && filling != 2 {
            quantity = 1
            filling += 1
            return [shape, color, filling, quantity]
        } else if filling == 2 && color != 2 {
            quantity = 1
            filling  = 0
            color   += 1
            return [shape, color, filling, quantity]
        } else if color == 2 && shape <= 2 {
            quantity = 1
            filling  = 0
            color    = 0
            shape   += 1
            return [shape, color, filling, quantity]
        }
        
        return [2, 2, 2, 3]
    }
    
    init() {
        self.givenAttributes = PersonalAttributesOfCard.attributesGenerator()
    }
}
