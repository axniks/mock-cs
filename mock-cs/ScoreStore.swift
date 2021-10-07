//
//  ScoreStore.swift
//  mock-cs
//
//  Created by Axel Niklasson on 07/10/2021.
//

import Foundation

struct Score {
    let score: Int
    let maxScore: Int
}

struct ScoreStore {
    static func refreshScore(completion:@escaping ((_ score: Score) -> Void)) {
        let session = URLSession.shared
        let url = URL(string: "https://5lfoiyb0b3.execute-api.us-west-2.amazonaws.com/prod/mockcredit/values")!

        let task = session.dataTask(with: url, completionHandler: { data, response, error in

            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Failed to retrieve a response from server")
                return
            }

            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                if let jsonData = json as? [String: Any],
                   let reportInfo = jsonData["creditReportInfo"] as? [String: Any],
                   let score = reportInfo["score"] as? Int,
                   let maxScore = reportInfo["maxScoreValue"] as? Int {
                    completion(Score(score: score, maxScore: maxScore))
                } else {
                    print("Failed to parse json response: ", json)
                }
            } catch {
                print("Failed JSON serialization: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}
