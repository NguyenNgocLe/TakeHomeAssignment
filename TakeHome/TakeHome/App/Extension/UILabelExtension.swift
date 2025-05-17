//
//  UILabelExtension.swift
//  TakeHome
//
//  Created by Le on 17/5/25.
//

import Foundation
import UIKit

extension UILabel {
    func setTextWithLineSpacing(text: String, lineHeightMultiply: CGFloat = 1.5) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = lineHeightMultiply
        paragraphStyle.alignment = .center
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}
