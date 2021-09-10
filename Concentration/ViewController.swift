//
//  ViewController.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var deal3MoreCardsButton: UIButton!
  @IBOutlet var cardButtons: [UIButton]!
  @IBOutlet weak var flipCountLabel: UILabel! {
    didSet {
      self.updateFlipCountLabel()
    }
  }
  
  //  private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
  private lazy var game = Concentration(numberOfTrioOfCards: numberOfTrioOfCards)
  private var visibleCardsCount = 12
  private var numberOfPairsOfCards: Int {
    (cardButtons.count + 1) / 2
  }
  private var numberOfTrioOfCards: Int {
    (cardButtons.count + 1) / 3
  }
  private(set) var score = 0 {
    didSet {
      self.updateFlipCountLabel()
    }
  }
  //  private var emojiChoises = (CardsTheme.allCases.randomElement() ?? .whether).emojiTheme
  private var emojiChoises = "🦇😱🙀😈🎃👻❄️☁️🍎"
  private var emoji = [Card : String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    updateViewFromModel()
  }
  
  // MARK: - Update UI
  private func updateFlipCountLabel() {
    let attributes: [NSAttributedString.Key : Any] = [
      .strokeWidth : 5.0,
      .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    ]
    let attributedString = NSAttributedString(string: "Flips: \(score)", attributes: attributes)
    flipCountLabel.attributedText = attributedString
  }
  
  private func updateViewFromModel() {
    for index in cardButtons.indices {
      let button = cardButtons[index]
      button.isUserInteractionEnabled = !(index >= visibleCardsCount)
      let card = game.cards[index]
      if card.isFaceUp {
        button.setTitle(emoji(for: card), for: .normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      } else {
        button.setTitle("", for: .normal)
        button.backgroundColor = card.isMatched || index >= visibleCardsCount ? #colorLiteral(red: 0.9254902005, green: 0.4194166106, blue: 0.1966157824, alpha: 0) : UIColor.orange
      }
      
      self.provideBorderAnimate(for: button, at: card)
    }
  }
  
  // MARK: - Actions
  @IBAction func touchCard(_ sender: UIButton) {
    //    flipCount += 1
    
    if let cardNumber = cardButtons.firstIndex(of: sender) {
      //      game.chooseCard(at: cardNumber)
      game.runChoosingCard(at: cardNumber) { isMatched in
        if isMatched {
          self.add3MoreCardsIfNeed()
        }
      }
      score = game.score
      
      updateViewFromModel()
    } else {
      print("chosen card was nor in cardButtons")
    }
  }
  
  @IBAction func deal3MoreCards(_ sender: UIButton) {
    self.add3MoreCardsIfNeed()
    self.updateViewFromModel()
  }
  
  // MARK: - Methods
  private func add3MoreCardsIfNeed() {
    let invisibleCardsCount = self.cardButtons.count - self.visibleCardsCount
    
    if invisibleCardsCount > 3 {
      self.visibleCardsCount += 3
      print("3 cards to add (first condition)")
    } else if invisibleCardsCount <= 3 && invisibleCardsCount > 0 {
      print("\(invisibleCardsCount) cards to add (second condition)")
      self.visibleCardsCount += invisibleCardsCount
    } else {
      print("nothing to add (third condition)")
      self.deal3MoreCardsButton.isUserInteractionEnabled = false
    }
  }
  
  private func emoji(for card: Card) -> String {
    if emoji[card] == nil, emojiChoises.count > 0 {
      let randomStringIndex = emojiChoises.index(emojiChoises.startIndex, offsetBy: emojiChoises.count.arc4random)
      //      emoji[card] = emojiChoises.remove(at: emojiChoises.count.arc4random)
      emoji[card] = String(emojiChoises.remove(at: randomStringIndex))
    }
    return emoji[card] ?? "?"
  }
}

// MARK: - Extensions
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

extension ViewController {
  //MARK: - Card Animation
  private func provideBorderAnimate(for button: UIButton, at card: Card) {
    if card.isFaceUp {
      let animateBorder = CABasicAnimation(keyPath: "borderWidth")
      animateBorder.fromValue = 0
      animateBorder.toValue = 10
      animateBorder.duration = 1.5
      animateBorder.repeatCount = card.isMatched ? 1 :.infinity
      animateBorder.autoreverses = true
      
      button.layer.borderWidth = 10
      button.layer.borderColor = UIColor.red.cgColor
      button.layer.add(animateBorder, forKey: "Width")
      button.layer.borderWidth = 0.0
    } else {
      button.layer.removeAnimation(forKey: "Width")
    }
  }
}
