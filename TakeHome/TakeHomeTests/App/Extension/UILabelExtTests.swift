//
//  UILabelExtTests.swift
//  TakeHomeTests
//
//  Created by Le on 17/5/25.
//

import XCTest
import UIKit
@testable import TakeHome

class UILabelSetTextWithLineSpacingTests: XCTestCase {
    
    func testSetTextWithDefaultLineSpacing() {
        // given
        let label = UILabel()
        let testText = "Hello\nWorld"
        // when
        label.setTextWithLineSpacing(text: testText)
        // then
        guard let attributed = label.attributedText else {
            XCTFail("attributedText should not be nil")
            return
        }
        
        XCTAssertEqual(attributed.string, testText)

        let paragraphStyle = attributed.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle
        XCTAssertNotNil(paragraphStyle)
        XCTAssertEqual(paragraphStyle?.lineHeightMultiple, 1.5)
        XCTAssertEqual(paragraphStyle?.alignment, .center)
    }
    
    func testSetTextWithCustomLineSpacing() {
        // given
        let label = UILabel()
        let testText = "Testing\nLine"
        let customLineHeight: CGFloat = 2.0
        // when
        label.setTextWithLineSpacing(text: testText, lineHeightMultiply: customLineHeight)
        // then
        guard let attributed = label.attributedText else {
            XCTFail("attributedText should not be nil")
            return
        }
        let paragraphStyle = attributed.attribute(.paragraphStyle, at: 0, effectiveRange: nil) as? NSMutableParagraphStyle
        XCTAssertNotNil(paragraphStyle)
        XCTAssertEqual(paragraphStyle?.lineHeightMultiple, customLineHeight)
        XCTAssertEqual(paragraphStyle?.alignment, .center)
    }
    
    func testSetTextWithEmptyString() {
        // given
        let label = UILabel()
        // when
        label.setTextWithLineSpacing(text: "")
        // then
        XCTAssertEqual(label.attributedText?.string, "")
    }
}
