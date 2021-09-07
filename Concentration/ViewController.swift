//
//  ViewController.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import UIKit

class ViewController: UIViewController {
  
  private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
  
  var numberOfPairsOfCards: Int {
      (cardButtons.count + 1) / 2
  }
  private(set) var score = 0 {
    didSet {
      self.updateFlipCountLabel()
    }
  }
  private func updateFlipCountLabel() {
    let attributes: [NSAttributedString.Key : Any] = [
      .strokeWidth : 5.0,
      .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    ]
    let attributedString = NSAttributedString(string: "Flips: \(score)", attributes: attributes)
    flipCountLabel.attributedText = attributedString
  }
  
  @IBOutlet weak var flipCountLabel: UILabel! {
    didSet {
      self.updateFlipCountLabel()
    }
  }
  
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
  
  private func updateViewFromModel() {
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
  
//  private var emojiChoises = (CardsTheme.allCases.randomElement() ?? .whether).emojiTheme
  private var emojiChoises = "🦇😱🙀😈🎃👻❄️☁️🍎"
  
  private var emoji = [Card : String]()
  
  private func emoji(for card: Card) -> String {
    if emoji[card] == nil, emojiChoises.count > 0 {
      let randomStringIndex = emojiChoises.index(emojiChoises.startIndex, offsetBy: emojiChoises.count.arc4random)
//      emoji[card] = emojiChoises.remove(at: emojiChoises.count.arc4random)
      emoji[card] = String(emojiChoises.remove(at: randomStringIndex))
    }
    return emoji[card] ?? "?"
  }
}

extension Int {
  var arc4random: Int {
    if self > 0 {
      return Int(arc4random_uniform(UInt32(self)))
    } else if self < 0 {
      return -Int(arc4random_uniform(UInt32(self)))
    } else {
      return 0
    }
  }
}
