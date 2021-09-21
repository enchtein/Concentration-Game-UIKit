//
//  PlayingCardView.swift
//  Concentration
//
//  Created by Track Ensure on 2021-09-20.
//

import UIKit

class PlayingCardView: UIView {
  
  
  var isFaceUp: Bool = false {
    didSet { setNeedsDisplay(); setNeedsLayout() }
  }
  
  
  private lazy var smileLabel = createCornerLabel() {
    didSet { setNeedsDisplay(); setNeedsLayout() }
  }
  
  // Only override draw() if you perform custom drawing.
  // An empty implementation adversely affects performance during animation.
  override func draw(_ rect: CGRect) {
    // Drawing code
    let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
    roundedRect.addClip()
    UIColor.white.setFill()
    roundedRect.fill()
    
    if isFaceUp {
      self.smileLabel.text = "test"
      self.smileLabel.isHidden = !isFaceUp
    } else {
      UIColor.white.setFill()
    }
  }
  
  private func createCornerLabel() -> UILabel {
    let label = UILabel()
    label.numberOfLines = 0
    
    addSubview(label)
    
    label.translatesAutoresizingMaskIntoConstraints = false
    label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    
    return label
  }
}

//MARK: - extensions
extension PlayingCardView {
  private struct SizeRatio {
    static let cornerFontSizeToBoundsHeight: CGFloat = 0.085
    static let cornerRadiusToBoundsHeight: CGFloat = 0.06
    static let cornerOffsetToCornerRadius: CGFloat = 0.33
    static let faceCardImageSizeToBoundsSize: CGFloat = 0.75
  }
  
  private var cornerRadius: CGFloat {
    return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
  }
  private var cornerOffset: CGFloat {
    return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
  }
  private var cornerFontSize: CGFloat {
    return bounds.size.height * SizeRatio.cornerFontSizeToBoundsHeight
  }
  //  private var rankString: String {
  //    switch rank {
  //    case 1: return "A"
  //    case 2...10: return String(rank)
  //    case 11: return "J"
  //    case 12: return "Q"
  //    case 13: return "K"
  //    default: return "?"
  //    }
  //  }
}

//extension CGPoint {
//  func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
//    return CGPoint(x: x+dx, y: y+dy)
//  }
//}
