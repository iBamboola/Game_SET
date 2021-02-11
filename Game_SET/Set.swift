//
//  Set.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 30.11.2020.
//  Copyright © 2020 Алексей Сергеев. All rights reserved.
//

import Foundation

class SetGame{
    
    private(set) var firstPlayersHand = [Card]() // cards in player's hand
    private(set) var cards = [Card]() // all cards in deck
    
    private(set) var score = 0 // player's score
    func moveSetToPlayerAndIncreaseScore(_ first: Card, _ second: Card, _ third: Card){
        let moveCardToPlayersHand = { (card: Card) -> Void in
            let removedCard = self.cards.remove(at: self.cards.firstIndex(of: card)!)
            self.firstPlayersHand.append(removedCard)
        }
        moveCardToPlayersHand(first)
        moveCardToPlayersHand(second)
        moveCardToPlayersHand(third)
        
        score += 1
    }
    
    var countOfCardsInDeck = 81
    var amountOfCardOnATable = 12
    
    private(set) var gamePeriodWasSet = false
    
    init() {
        // game just started
        for _ in 0 ..< countOfCardsInDeck {
            let card = Card()
            cards.append(card)
        }
        cards.shuffle()
    }
    
    func findSet(between first: Card, _ second: Card, _ third: Card) -> Bool {
        var resultOfCardsComparison = [false, false, false, false]
        for index in 0 ..< 4 {
            if ( first.attributes[index] == second.attributes[index] )  &&  ( second.attributes[index] == third.attributes[index] ) {
                resultOfCardsComparison[index] = true
            } else if ( first.attributes[index] != second.attributes[index] )  &&  ( second.attributes[index] != third.attributes[index] )  &&  (first.attributes[index] != third.attributes[index] )  {
                resultOfCardsComparison[index] = true
            }
        }
        if let _ = resultOfCardsComparison.first(where: {$0 == false}) {
            return false
        }
        gamePeriodWasSet = true
        return true
    }
    
}
