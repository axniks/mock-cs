//
//  ScoreStore.swift
//  mock-cs
//
//  Created by Axel Niklasson on 11/10/2021.
//

import Foundation

/// type used to decode mock credit score json response
struct CreditReportInfo: Decodable {
    let score: Int
    let maxScoreValue: Int
}

/// type used to decode mock credit score json response
struct Score: Decodable {
    let creditReportInfo: CreditReportInfo
}

/// A class encapsulating the specific endpoint and data structure for the mock API
/// credit score data retrieval
class ScoreStore: CodeTestStore {

    /// Fetches score and maxScore from mock API endpoint and decode according to Score type
    ///
    /// - Parameters:
    ///     - completion:   a block on which you want the Result containing score and maxScore returned
    func fetchScore(completion: @escaping (_ result: Result<(score: Int, maxScore: Int), Error>) -> Void) {

        /// API endpoint
        let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!

        /// retrieve JSON according to Score type and return score and maxScore on success
        fetch(Score.self, from: url) { result in
            switch result {
            case .success(let score):
                completion(Result.success((score.creditReportInfo.score, score.creditReportInfo.maxScoreValue)))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }
    }
}
