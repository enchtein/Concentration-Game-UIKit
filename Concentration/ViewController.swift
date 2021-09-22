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
  
  var additionalViews: [PlayingCardView]?
//  private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    private lazy var game = Concentration(numberOfTrioOfCards: numberOfTrioOfCards)
  private var visibleCardsCount = 12 {
    didSet {
      let difference = visibleCardsCount - oldValue
      for _ in 0..<difference {
        let temp = PlayingCardView()
        if additionalViews?.isEmpty ?? true {
          additionalViews = [temp]
        } else {
          additionalViews?.append(temp)
        }
      }
      
      isAllowTransitionAnimation = false
      let subViews = self.view.subviews.filter({$0 is PlayingCardView})
        subViews.forEach({$0.removeFromSuperview()})
      
      setupCardOnScreen()
    }
  }
  private var numberOfPairsOfCards: Int {
    //    (cardButtons.count + 1) / 2
    (49 + 1) / 2
  }
  private var numberOfTrioOfCards: Int {
//    (cardButtons.count + 1) / 3
    (18 + 1) / 3
  }
  private(set) var score = 0 {
    didSet {
      self.updateFlipCountLabel()
    }
  }
  private var emojiChoises = "🦇😱🙀😈🎃👻❄️☁️🍎"
  private var emoji = [Card : String]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    gameCardsEmoji.shuffle()
    settingCardDictionary()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    if self.gameCards == nil {
      setupCardOnScreen()
    }
  }
  
  @objc func playingCardViewTapped(_ gesture: UITapGestureRecognizer) {
    let tappedViewIndex = gesture.view?.tag ?? 0
    print(tappedViewIndex)
    
    self.game.runChoosingCard(at: tappedViewIndex) { isMatched in
      print("find trio")
    }
    
      self.updateModelToUI()
  }
  
  var gameCards: [PlayingCardView]? {
    didSet {
      self.emojiForCards.forEach { card, emoji in
        if !self.game.cards.contains(card) {
          self.emojiForCards.removeValue(forKey: card)
        }
      }
    }
  }
  
  var emojiForCards = [Card : String]()
  var gameCardsEmoji = ["🌈", "🌪", "☀️", "🌤", "⛅️", "🌧", "🌩", "❄️", "💨", "🌊", "🌫", "☔️", "🐪", "🦒", "🦘", "🦬", "🐃", "🐖", "🦏", "🦃", "🦤", "🦫", "🦝", "🦨", "🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚", "😀", "😆", "🥲", "😉", "🤪", "😎", "🤑", "😴", "🥱", "😮", "😱", "🤠", "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒"]
  
  
  
  // MARK: - Update UI
  private func updateFlipCountLabel() {
    let attributes: [NSAttributedString.Key : Any] = [
      .strokeWidth : 5.0,
      .strokeColor : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
    ]
    let attributedString = NSAttributedString(string: "Flips: \(score)", attributes: attributes)
    flipCountLabel.attributedText = attributedString
  }
  private func updateModelToUI() {
    score = game.score
    let subViews = self.view.subviews.filter({$0 is PlayingCardView})
    
    if let _ = self.game.removingIndexes {
      subViews.forEach({$0.removeFromSuperview()})
      setupCardOnScreen()
      self.game.removingIndexes = nil
      return
    }
    
    for playingCardView in subViews.indices {
      let playingCardView = subViews[playingCardView]
      let index = subViews.firstIndex(of: playingCardView) ?? 0
      
      let card = game.cards[index]
      
      if let playingCardView = playingCardView as? PlayingCardView {
        playingCardView.isFaceUp = card.isFaceUp
      }
    }
  }
  
  private func setupCardOnScreen() {
    var startPlayingCardViewsArray = [PlayingCardView]()
    let cardsCount = self.game.cards.count < self.visibleCardsCount ? self.game.cards.count : self.visibleCardsCount
    
    guard cardsCount > 0 else {
      let alert = UIAlertController(title: "End of Game", message: "You are win", preferredStyle: .alert)
      let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alert.addAction(okButton)
      self.present(alert, animated: true, completion: nil)
      return
    }
    
    for index in 0..<cardsCount {
      let tempPlayingCardView = PlayingCardView()
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(playingCardViewTapped(_:)))
      tempPlayingCardView.addGestureRecognizer(tapGesture)
      
      tempPlayingCardView.tag = index
      
      // Set emoji title >>>
      let card = game.cards[index]
      let smile = self.emojiForCards[card] ?? "?"
      tempPlayingCardView.setLabelTitle(with: smile)
      tempPlayingCardView.isFaceUp = card.isFaceUp
      // <<< Set emoji title
      
      if startPlayingCardViewsArray.isEmpty {
        startPlayingCardViewsArray = [tempPlayingCardView]
      } else {
        startPlayingCardViewsArray.append(tempPlayingCardView)
      }
    }
    
    if self.gameCards == nil {
      self.gameCards = startPlayingCardViewsArray
    } else {
      self.gameCards = startPlayingCardViewsArray
    }
    
    var cardsTuple = (cardsInLine: 0, countOfLines: 0)
    let sqrtFromCardsCount = sqrt(Double(cardsCount))
    if sqrtFromCardsCount.truncatingRemainder(dividingBy: 1) == 0 {
      
      cardsTuple = (cardsInLine: Int(sqrtFromCardsCount), countOfLines: Int(sqrtFromCardsCount))
    } else {
      cardsTuple = (cardsInLine: Int(sqrtFromCardsCount)+1, countOfLines: Int(sqrtFromCardsCount)+1)
    }
    
    let cardAspectRatio = self.view.frame.width / (self.flipCountLabel.frame.origin.y-50)
    let cardWidth = self.view.frame.size.width / CGFloat(cardsTuple.cardsInLine)
    let cardHeight = cardWidth / CGFloat(cardAspectRatio)
    
    // Set Anchors for Views
    guard let gameCards = gameCards else { return }
    
    for cardView in gameCards {
      if cardView == gameCards.first {
        
        UIView.transition(with: self.view, duration: 0.5, options: [.transitionCrossDissolve], animations: {
          self.view.addSubview(cardView)
        }, completion: nil)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        cardView.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
      } else {
        if let currentIndex = gameCards.firstIndex(of: cardView) {
          let previousPlayingCardView = gameCards[currentIndex-1]
          
          let options: UIView.AnimationOptions = isAllowTransitionAnimation ? [.transitionCrossDissolve] : []
          UIView.transition(with: self.view, duration: 0.5, options: options) {
            self.view.addSubview(cardView)
          } completion: { isAdded in
            if isAdded {
              if let _ = self.additionalViews {
                self.setAditionalViews(cardWidth: cardWidth, cardHeight: cardHeight)
              }
            }
          }
          
          let currentLine = currentIndex / cardsTuple.cardsInLine
          let distance = currentLine-1 < 0 ? 0 : currentLine-1
          
          let rowAnchorPlayingCardView = gameCards[distance * cardsTuple.cardsInLine]
          
          let topAnchor = currentIndex < cardsTuple.cardsInLine ? self.view.safeAreaLayoutGuide.topAnchor : rowAnchorPlayingCardView.bottomAnchor
          let leftAnchor = currentIndex % cardsTuple.cardsInLine == 0 ? self.view.leftAnchor : previousPlayingCardView.rightAnchor
          
          cardView.translatesAutoresizingMaskIntoConstraints = false
          cardView.topAnchor.constraint(equalTo: topAnchor).isActive = true
          cardView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
          cardView.widthAnchor.constraint(equalToConstant: cardWidth).isActive = true
          cardView.heightAnchor.constraint(equalToConstant: cardHeight).isActive = true
        }
      }
    }
    
  }
  
  var isAllowTransitionAnimation: Bool = true
  private func setAditionalViews(cardWidth: CGFloat, cardHeight: CGFloat) {
    self.additionalViews?.forEach({self.view.addSubview($0)})
    
    guard let range = additionalViews?.count, let gameCards = gameCards else { return }
    let lastViews = gameCards[gameCards.endIndex-range..<gameCards.endIndex]
    for view in lastViews {
      view.isHidden = true
    }
    
    
    for additionalView in additionalViews! {
      guard let currentIndex = additionalViews?.firstIndex(of: additionalView) else { return }
      let index = lastViews.endIndex - (lastViews.count - currentIndex)
      UIView.animate(withDuration: 0.75) {
        additionalView.frame.origin = gameCards[index].frame.origin
        additionalView.frame.size = gameCards[index].frame.size
        self.view.layoutIfNeeded()
        
        print(additionalView.frame)
      } completion: { success in
        print(success)
        gameCards[index].isHidden = false
        additionalView.removeFromSuperview()
      }
    }
    additionalViews = nil
  }
  
  // MARK: - Actions
  @IBAction func deal3MoreCards(_ sender: UIButton) {
    self.add3MoreCardsIfNeed()
  }
  
  // MARK: - Methods
  private func add3MoreCardsIfNeed() {
    let invisibleCardsCount = self.game.cards.count - self.visibleCardsCount
    if invisibleCardsCount > 3 {
      self.visibleCardsCount += 3
      print("3 cards to add (first condition)")
    } else if invisibleCardsCount <= 3 && invisibleCardsCount > 0 {
      print("\(invisibleCardsCount) cards to add (second condition)")
      self.visibleCardsCount += invisibleCardsCount
    } else {
      print("nothing to add (third condition)")
      self.deal3MoreCardsButton.isUserInteractionEnabled = false
      let alert = UIAlertController(title: "nothing to add", message: "no more cards in queue", preferredStyle: .alert)
      let okButton = UIAlertAction(title: "Ok", style: .default, handler: nil)
      alert.addAction(okButton)
      self.present(alert, animated: true, completion: nil)
    }
  }
  private func settingCardDictionary() {
    let unique = Array(Set(self.game.cards))
    for card in unique {
      if emojiForCards[card] == nil {
        let cardIndex = unique.firstIndex(of: card) ?? 0
        
        emojiForCards[card] = String(gameCardsEmoji[cardIndex])
      }
    }
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
