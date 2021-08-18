//
//  ViewController.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import UIKit

class ViewController: UIViewController {
  
  lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
  
  var score = 0 {
//    print(game.score)
//    flipCountLabel.text = "Flips: \(game.score)"
//    return 0
//    return game.score
    didSet {
      flipCountLabel.text = "Flips: \(score)"
    }
  }
  
  
  @IBOutlet weak var flipCountLabel: UILabel!
  
  @IBOutlet var cardButtons: [UIButton]!
  
  @IBAction func touchCard(_ sender: UIButton) {
//    flipCount += 1
    
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      game.chooseCard(at: cardNumber)
      score = game.score
      
      updateViewFromModel()
    } else {
      print("chosen card was nor in cardButtons")
    }
  }
  
  @IBAction func newGame(_ sender: UIButton) {
    emojiChoises = (CardsTheme.allCases.randomElement() ?? .whether).emojiTheme
    game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    self.updateViewFromModel()
  }
  
  func updateViewFromModel() {
    for index in cardButtons.indices {
      let button = cardButtons[index]
      let card = game.cards[index]
      if card.isFaceUp {
        button.setTitle(emoji(for: card), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      } else {
        button.setTitle("", for: .normal)
        button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.9254902005, green: 0.4194166106, blue: 0.1966157824, alpha: 0) : UIColor.orange
      }
    }
  }
  
//  var emojiChoises = ["🦇", "😱", "🙀", "😈", "🎃", "👻", "❄️", "☁️", "🍎"]
  var emojiChoises = (CardsTheme.allCases.randomElement() ?? .whether).emojiTheme
  
  var emoji = [Int : String]()
  
  func emoji(for card: Card) -> String {
    if emoji[card.identifier] == nil, emojiChoises.count > 0 {
      let randomIndex = Int(arc4random_uniform(UInt32(emojiChoises.count)))
      emoji[card.identifier] = emojiChoises.remove(at: randomIndex)
    }
    
    
    return emoji[card.identifier] ?? "?"
  }
}

