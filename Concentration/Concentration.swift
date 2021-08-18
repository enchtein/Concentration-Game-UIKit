//
//  Concentration.swift
//  Concentration
//
//  Created by Track Ensure on 2021-08-16.
//

import Foundation

class Concentration {
  var cards = [Card]()
  var score = 0
  
  var indexOfOneAndOnlyFaceUpCard: Int?
  
  func chooseCard(at index: Int) {
//    cards[index].isFaceUp = !cards[index].isFaceUp
    if !cards[index].isMatched {
      if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
        if cards[matchIndex].identifier == cards[index].identifier {
          cards[matchIndex].isMatched = true
          cards[index].isMatched = true
          score += 2
        }
        cards[index].isFaceUp = true
        indexOfOneAndOnlyFaceUpCard = nil
        
        
      } else {
        // either no cards or 2 cards are face up
        for flipDownIndex in cards.indices {
          cards[flipDownIndex].isFaceUp = false
        }
        cards[index].isFaceUp = true
        indexOfOneAndOnlyFaceUpCard = index
        
        score -= 1
      }
    }
  }
  
  init(numberOfPairsOfCards: Int) {
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
