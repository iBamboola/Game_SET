//
//  ViewController.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 30.11.2020.
//  Copyright © 2020 Алексей Сергеев. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var game = SetGame()
    
    private var pickedCards = [Card](){
        didSet {
            makeSet()
        }
    }
    
    private var pickedCardsIsSet = false
    
    
    private var gridForCards = Grid(layout: .aspectRatio(2.0), frame: CGRect(x: 16.0, y: 44.0, width: 398.0, height: 600.0))
    
    @IBOutlet var cardButtons: [UIButton]!
    @IBOutlet weak var statsLabel: UILabel!
    @IBOutlet weak var dealMoreCards: UIButton!
    
    private(set) var cardsAndTheirButtons = [Card : Int]() // Cards on table
    
    @IBAction func touchCard(_ sender: UIButton) {
        assert(pickedCards.count <= 3, "Out of chosenCard range.")
        
        // find the button index in cardButtons array
        let buttonIndex = cardButtons.firstIndex(of: sender) ?? 100
        let findCard = { (buttonIndex: Int) -> (Card?) in
            for (card, index) in self.cardsAndTheirButtons {
                if index == buttonIndex {
                    return card
                }
            }
            return nil
        }
        // find out what the card in cardsAndTheirButtons array by providing index of button/sender
        let card = findCard(buttonIndex) ?? game.cards[81] // TODO: do it better
        
        // select and append card to set or diselect it
        if pickedCards.count < 3, !pickedCards.contains(card) {
            // if card is picked, it will do pick
            sender.layer.borderColor = #colorLiteral(red: 0.9071652293, green: 0, blue: 0, alpha: 1)
            pickedCards.append(card)
            
        } else if pickedCards.count <= 3, pickedCards.contains(card) {
            // if card was unpicked, it will undo pick and remove from pickedCard array
            sender.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            let pickedCardIndex = pickedCards.firstIndex(of: card) ?? 100
            pickedCards.remove(at: pickedCardIndex)
            
        } else if pickedCards.count == 3, !pickedCards.contains(card) {
            // if 3 cards are picked and user trying pick another one, it will undo selection and pick chosen card
            for i in pickedCards.indices {
                for (card, index) in cardsAndTheirButtons {
                    if pickedCards[i] == card {
                        cardButtons[index].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
                    }
                }
            }
            
            pickedCards.removeAll()
            pickedCards.append(card)
            sender.layer.borderColor = #colorLiteral(red: 0.9071652293, green: 0, blue: 0, alpha: 1)
        }
    }
    
    @IBAction func deal3MoreCard(_ sender: UIButton) {
        // TODO: добавлть 3 карты при клике на эту кнопку
        game.amountOfCardOnATable += 3
        if game.amountOfCardOnATable >= 24 || game.countOfCardsInDeck <= 0 {
            game.amountOfCardOnATable = 24
            dealMoreCards.isEnabled     = false
            dealMoreCards.isHidden      = true
        } else {
            dealMoreCards.isEnabled     = true
            dealMoreCards.isHidden      = false
        }
        refreshViewFromModel()
    }
    
    
    private let attributesForInit: [NSAttributedString.Key:Any] = [
        .foregroundColor: #colorLiteral(red: 0.9071652293, green: 0, blue: 0, alpha: 1)
    ]
    private let attributesForGame: [NSAttributedString.Key:Any] = [
        .foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    ]
    
    // this defines the position of chosen element in array of properties from the model
    private enum PosOfAttrFromModel: Int {
        case shape = 0, color, filling, quantity
    }
    
    private class AllAttrForCards {
        let allColors = [#colorLiteral(red: 0, green: 0.2, blue: 0.8, alpha: 1), #colorLiteral(red: 0.75, green: 0.2475, blue: 0.540625, alpha: 1), #colorLiteral(red: 0.14349287, green: 0.5809567637, blue: 0.0662933593, alpha: 1)]
        let allFilling = [ ["□", "△", "◯"], ["◨","◮", "◑"], ["■", "▲", "●"] ]
    }
    
    
    private func setSymbolsForButton(from card: Card) -> NSAttributedString {
        let cardProp = card.attributes
        var shape    = PosOfAttrFromModel.shape.rawValue // shape position/index in array
        var filling  = PosOfAttrFromModel.filling.rawValue
        var color    = PosOfAttrFromModel.color.rawValue
        var quantity = PosOfAttrFromModel.quantity.rawValue
        
        // get the value of a attribute from model
        filling  = cardProp[filling]
        shape    = cardProp[shape]
        color    = cardProp[color]
        quantity = cardProp[quantity]
        
        // define shape through filling attributes and get the demanded symbol (look at the class AllAttrForCards)
        let symbol      = AllAttrForCards().allFilling[filling][shape]
        let chosenColor = AllAttrForCards().allColors[color]
        
        let string = { () -> (String) in
            var string = ""
            for _ in 0 ..< quantity {
                string += symbol
            }
            return string
        }
        
        let attributes: [NSAttributedString.Key:Any] = [
            .foregroundColor: chosenColor,
            .font: UIFont.systemFont(ofSize: 20)
        ]
        
        return NSAttributedString(string: string(), attributes: attributes)
        
    }
    
    
    private func initilizeViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.layer.cornerRadius   = 10
            button.layer.borderWidth    = 3
            button.layer.borderColor    = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            button.backgroundColor      = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            button.setTitle("\(index)", for: .normal)
            
            let labelTextCardsNotMatched = NSAttributedString(string: "Have no match", attributes: attributesForInit)
            statsLabel.attributedText = labelTextCardsNotMatched
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initilizeViewFromModel()
        refreshViewFromModel()
        
        gridForCards.cellCount = 2
        addSomeViewsToGrid()
    }
    
    
    
    private func addSomeViewsToGrid() {

        var rect = gridForCards[0]!
        let playingCard = PlayingCardView(frame: rect, shape: .diamond, color: .systemRed, filiing: .full, amount: 1)
//        playingCard.shape = .diamond
//        playingCard.color = .systemRed
//        playingCard.filling = .full
//        playingCard.amountOfShapes = 1
        view.addSubview(playingCard)
        
        rect = gridForCards[1]!
        playingCard.bounds = rect
        playingCard.shape = .squiggle
        playingCard.color = .systemBlue
        playingCard.filling = .semi
        playingCard.amountOfShapes = 2
        view.addSubview(playingCard)
    }
    
    private func refreshViewFromModel() {
        // draw all cards through pasting Cards
        let drawCard = { (card: Card) -> () in
            let symbols = self.setSymbolsForButton(from: card)
            let buttonsIndex = self.cardsAndTheirButtons[card]
            self.cardButtons[buttonsIndex!].setAttributedTitle(symbols, for: .normal)
        }
        
        if game.gamePeriodWasSet {
            if pickedCardsIsSet {
                for index in 0 ..< pickedCards.count {
                    let buttonIndex = cardsAndTheirButtons[pickedCards[index]]!
                    cardButtons[buttonIndex].isEnabled         = false
                    cardButtons[buttonIndex].layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3)
                    cardButtons[buttonIndex].backgroundColor   = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 0.3)
                    pickedCardsIsSet = false
                }
            } else {
                for index in 0 ..< cardButtons.count {
                    if index < game.amountOfCardOnATable {
                        cardButtons[index].isEnabled        = true
                        cardButtons[index].isHidden         = false
                    } else {
                        cardButtons[index].isEnabled        = false
                        cardButtons[index].isHidden         = true
                    }
                }
            }
        } else {
            for index in 0 ..< cardButtons.count {
                let currentCard = game.cards[index]
                cardsAndTheirButtons[currentCard] = index
                drawCard(currentCard)
//                cardButtons[index].setTitle(cardsAndTheirButtons[cardButtons[index]]?.attributes.description, for: .normal)
                if index < game.amountOfCardOnATable{
                    cardButtons[index].isEnabled    = true
                    cardButtons[index].isHidden     = false
                } else {
                    cardButtons[index].isEnabled    = false
                    cardButtons[index].isHidden     = true
                }
            }
        }
    }
    
    private func makeSet() {
        if pickedCards.count == 3 {
            let firstCard = pickedCards[0]
            let secondCard = pickedCards[1]
            let thirdCard = pickedCards[2]
            
            if game.findSet(between: firstCard, secondCard, thirdCard){
                game.moveSetToPlayerAndIncreaseScore(firstCard, secondCard, thirdCard)
                statsLabel.attributedText = NSAttributedString(string: "RightSets: \(game.score)", attributes: attributesForGame)
                // refresh view
                pickedCardsIsSet = true
                refreshViewFromModel()
                // remove cards from table
                for i in pickedCards.indices {
                    cardsAndTheirButtons[pickedCards[i]] = nil
                }
            }
        }
    }

}
