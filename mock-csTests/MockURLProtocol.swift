//
//  MockURLProtocol.swift
//  mock-csTests
//
//  Created by Axel Niklasson on 11/10/2021.
//

import Foundation

/// url protocol allowing us to use a mocking urlsession and test parsing code
class MockURLProtocol: URLProtocol {

    ///
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?

    /// abstract method requiring override, can always init for mocking purpose
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    /// abstract method requiring override, return request for mocking purpose
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    /// abstract method requiring override, this is where we do the mocking
    override func startLoading() {

        /// check that mocking requesthandler is implemented
        guard let handler = MockURLProtocol.requestHandler else {
            /// test is improperly implemented
            fatalError("Handler is unavailable.")
        }
        
        do {
            /// get mock response and data from test request handler
            let (response, data) = try handler(request)

            /// let url loading system know response is created
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)

            /// check data is provided and let url loading system know data is loaded
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            /// let url loading system know loading is finished
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            /// let url loading system know loading failed
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    /// abstract method requiring override, requires us to do nothing for mocking purpose
    override func stopLoading() {
    }
}
