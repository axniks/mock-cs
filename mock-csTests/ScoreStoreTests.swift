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
    let mockURL = URL(string: "https://anyurl.com")!

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

    func testThatItParsesWellFormedResponse() {

        /// normal case data
        let data =  """
                    {
                       "creditReportInfo":{
                          "score":514,
                          "maxScoreValue":700,
                       }
                    }
                    """.data(using: .utf8)

        /// set the request handler with mock response and data
        MockURLProtocol.requestHandler = { request in
            // mock response
            let response = HTTPURLResponse(url: self.mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            // return mock response and data
            return (response, data)
        }

        /// fetch score and make assertions
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

    func testThatItReturnsANetworkErrorFor404() {

        /// set the request handler with mock response and data
        MockURLProtocol.requestHandler = { request in
            // mock response
            let response = HTTPURLResponse(url: self.mockURL, statusCode: 404, httpVersion: nil, headerFields: nil)!
            // return mock response and data
            return (response, nil)
        }

        /// fetch score and make assertions
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
                XCTAssertEqual(error, StoreError.network, "Network error expected.")
            }
            self.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func testThatItReturnsAParsingErrorForMalformedData() {

        /// malformed data
        let data =  """
                    {
                       "creditReportInfo":{
                          "score":514,
                          "maxScore":700,
                       }
                    }
                    """.data(using: .utf8)

        /// set the request handler with mock response and data
        MockURLProtocol.requestHandler = { request in
            // mock response
            let response = HTTPURLResponse(url: self.mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            // return mock response and data
            return (response, data)
        }

        /// fetch score and make assertions
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

    func testThatItReturnsAParsingErrorForMissingData() {

        /// empty data
        let data = Data()

        /// mock response and data
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: self.mockURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }

        /// fetch score and make assertions
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
