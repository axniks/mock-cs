//
//  mock_csTests.swift
//  mock-csTests
//
//  Created by Axel Niklasson on 05/10/2021.
//

import XCTest
@testable import mock_cs

class ScoreStoreTests: XCTestCase {

    var scoreStore: ScoreStore!
    var expectation: XCTestExpectation!
    let scoreURL = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!

    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)

        scoreStore = ScoreStore(urlSession: urlSession)
        expectation = expectation(description: "Expectation")
    }

    override func tearDownWithError() throws {
        scoreStore = nil
        expectation = nil
    }

    func testThatItParsesResponse() {

        let data =  """
                    {
                       "creditReportInfo":{
                          "score":514,
                          "maxScoreValue":700,
                       }
                    }
                    """.data(using: .utf8)

        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.scoreURL else {
                throw StoreError.request
            }

            let response = HTTPURLResponse(url: self.scoreURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        scoreStore.fetchScore { result in
            switch result {
            case .success(let score):
                XCTAssertEqual(score.score, 514)
                XCTAssertEqual(score.maxScore, 700)
            case .failure(let error):
                XCTFail("Unexpected error: \(error)")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

    func testThatItFailsToParse() {
        let data = Data()
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.scoreURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        scoreStore.fetchScore(completion: { result in
            switch result {
            case .success(_):
                XCTFail("Request expected to fail.")
            case .failure(let error):
                guard let error = error as? StoreError else {
                    XCTFail("Store error expected.")
                    self.expectation.fulfill()
                    return
                }
                XCTAssertEqual(error, StoreError.parsing, "Parsing error expected.")
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
