//
//  mock_csUITests.swift
//  mock-csUITests
//
//  Created by Axel Niklasson on 05/10/2021.
//

import XCTest

class UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIDevice.shared.orientation = .portrait
    }

    func testMainJourney() throws {
        let app = XCUIApplication()
        app.launch()

        /// assert static navigation bar title and label texts
        XCTAssert(app.navigationBars["Dashboard"].exists)
        XCTAssert(app.staticTexts["Your credit score is"].exists)

        /// assert circle image through identifier
        XCTAssert(app.images["CircleImage"].exists)

        /// assert score label exists and is a number
        let scoreLabel = app.staticTexts["ScoreLabel"]
        XCTAssert(scoreLabel.exists)
        XCTAssert(CharacterSet(charactersIn: scoreLabel.label).isSubset(of: CharacterSet.decimalDigits))

        /// assert max score label exists and ends with a number
        let maxScoreLabel = app.staticTexts["MaxScoreLabel"]
        XCTAssert(maxScoreLabel.exists)
        XCTAssert(maxScoreLabel.label.starts(with: "out of "))
        if let maxScore = maxScoreLabel.label.components(separatedBy: " ").last {
            XCTAssert(CharacterSet(charactersIn: maxScore).isSubset(of: CharacterSet.decimalDigits))
        } else {
            XCTFail("Could not get max score text")
        }
    }
}
