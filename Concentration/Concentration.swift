//
//  Concentration.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import Foundation

struct Concentration {
  private(set) var cards = [Card]()
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
  
  mutating func chooseCard(at index: Int) {
    assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in the cards")
//    cards[index].isFaceUp = !cards[index].isFaceUp
    if !cards[index].isMatched {
      if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
        if cards[matchIndex] == cards[index] {
          cards[matchIndex].isMatched = true
          cards[index].isMatched = true
          score += 2
        }
        cards[index].isFaceUp = true
      } else {
        indexOfOneAndOnlyFaceUpCard = index
        
        score -= 1
      }
    }
  }
  
  init(numberOfPairsOfCards: Int) {
    assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
    for _ in 0..<numberOfPairsOfCards {
      let card = Card()
      cards += [card, card]
    }
    // TODO: Shuffle the cards
    self.cards.shuffle()
  }
}

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

extension Collection {
  var oneAndOnly: Element? {
    return count == 1 ? first : nil
  }
}
