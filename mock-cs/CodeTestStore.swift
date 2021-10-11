//
//  ScoreStore.swift
//  mock-cs
//
//  Created by Axel Niklasson on 07/10/2021.
//

import Foundation

/// Error used by CodeTestStore to reflect failure
enum StoreError: Error {
    /// Network problem preventing retrieval
    case network
    /// Problem parsing the retrieved data
    case parsing
    /// Problem with the request
    case request
}

/// A store encapsulating retrieval of JSON data from an API endpoint
class CodeTestStore {

    /// URLSession composition for testability, defaults to shared URLSession
    let urlSession: URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }

    /// Fetches JSON data from the URL you specify and decodes it according to the type you specify
    ///
    /// - Parameters:
    ///     - type:         The type corresponding to the expected JSON response,
    ///                     conforming to Decodable protocol.
    ///     - url:          The url to fetch the JSON from.
    ///     - completion:   a block on which you want the fetched object returned
    func fetch<T>(_ type: T.Type, from url: URL, completion: @escaping (_ result: Result<T, Error>) -> Void) where T : Decodable {
        let dataTask = urlSession.dataTask(with: url) { (data, response, error) in

            /// check for fundamental networking error
            if let error = error {
                completion(Result.failure(error))
                return
            }

            /// check for http status codes
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(Result.failure(StoreError.network))
                return
            }

            /// check for properly parsed response, return data according to specified type or fail with error
            if let responseData = data, let object = try? JSONDecoder().decode(type, from: responseData) {
                completion(Result.success(object))
            } else {
                completion(Result.failure(StoreError.parsing))
            }
        }
        dataTask.resume()
    }
}
