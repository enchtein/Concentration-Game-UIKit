//
//  Concentration.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import Foundation

struct Concentration {
  private(set) var cards = [Card]()
  private var cardMatchedCount: CardMatchedCount
  var score = 0
  
  private var indexOfOneAndOnlyFaceUpCard: Int? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
    }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = (index == newValue)
      }
    }
  }
  private var indexOfTwoAndOnlyFaceUpCard: [Int]? {
    get {
      return cards.indices.filter { cards[$0].isFaceUp }.twoAndOnly
    }
    set {
      for index in cards.indices {
        cards[index].isFaceUp = ((newValue?.contains(index)) ?? false)
      }
    }
  }
  
  //MARK: - choosing cards methods
  mutating func runChoosingCard(at index: Int, setMatch: (Bool) -> Void) {
    switch self.cardMatchedCount {
    case .pair:
      self.chooseCard(at: index, setMatch: setMatch)
    case .trio:
      self.chooseTrioCard(at: index, setMatch: setMatch)
    }
  }
  
  mutating func chooseCard(at index: Int, setMatch: (Bool) -> Void) {
    assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
    if !cards[index].isMatched {
      if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
        if cards[matchIndex] == cards[index] {
          cards[matchIndex].isMatched = true
          cards[index].isMatched = true
          setMatch(true)
          score += 2
        }
        cards[index].isFaceUp = true
      } else if cards[index].isFaceUp { // deselecting card
        cards[index].isFaceUp.toggle()
      } else {
        indexOfOneAndOnlyFaceUpCard = index
        
        score -= 1
      }
    }
  }
  
  mutating private func chooseTrioCard(at index: Int, setMatch: (Bool) -> Void) {
    if !cards[index].isMatched {
      if let matchIndexes = indexOfTwoAndOnlyFaceUpCard, !matchIndexes.contains(index) {
        var cardsInHeap: [Card] = []
        for index in matchIndexes {
          cardsInHeap.append(self.cards[index])
        }
        if cardsInHeap.count == 2, cardsInHeap.allSatisfy({ $0 == cards[index]}) {
          for matchIndexCard in matchIndexes {
            self.cards[matchIndexCard].isMatched = true
          }
          cards[index].isMatched = true
          setMatch(true)
          score += 3
        }
        cards[index].isFaceUp = true
      } else if cards[index].isFaceUp {
        cards[index].isFaceUp.toggle()
      } else {
        if let _ = self.indexOfTwoAndOnlyFaceUpCard {
          indexOfTwoAndOnlyFaceUpCard?.append(index)
        } else {
          indexOfTwoAndOnlyFaceUpCard = [index]
        }
        score -= 1
      }
    }
  }
  
  //MARK: - init
  init(numberOfPairsOfCards: Int) {
    assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
    for _ in 0..<numberOfPairsOfCards {
      let card = Card()
      cards += [card, card]
    }
    // TODO: Shuffle the cards
    self.cards.shuffle()
    self.cardMatchedCount = .pair
  }
  
  init(numberOfTrioOfCards: Int) {
    assert(numberOfTrioOfCards > 0, "Concentration.init(\(numberOfTrioOfCards)): you must have at least one trio of cards")
    for _ in 0..<numberOfTrioOfCards {
      let card = Card()
      cards += [card, card, card]
    }
    // TODO: Shuffle the cards
    self.cards.shuffle()
    self.cardMatchedCount = .trio
  }
  
  enum CardMatchedCount: Int {
    case pair = 2
    case trio = 3
  }
}

// MARK: - CardsTheme
enum CardsTheme: CaseIterable {
  case whether
  case animals
  case cars
  case smiles
  case characters
  case food
  
  var emojiTheme: [String] {
    switch self {
    case .whether:
      return ["🌈", "🌪", "☀️", "🌤", "⛅️", "🌧", "🌩", "❄️", "💨", "🌊", "🌫", "☔️"]
    case .animals:
      return ["🐪", "🦒", "🦘", "🦬", "🐃", "🐖", "🦏", "🦃", "🦤", "🦫", "🦝", "🦨"]
    case .cars:
      return ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🛻", "🚚"]
    case .smiles:
      return ["😀", "😆", "🥲", "😉", "🤪", "😎", "🤑", "😴", "🥱", "😮", "😱", "🤠"]
    case .characters:
      return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L"]
    case .food:
      return ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍈", "🍒"]
    }
  }
}

// MARK: - extensions
extension Collection {
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
  
  var twoAndOnly: [Element]? {
    if count == 1 {
      var returnValue: [Element]? = []
      returnValue?.append(first!)
      return returnValue
    } else if count == 2 {
      var returnValue: [Element]? = []
      for elem in self {
        returnValue?.append(elem)
      }
      return returnValue
    } else {
      return nil
    }
  }
}
