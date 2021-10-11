//
//  ViewController.swift
//  mock-cs
//
//  Created by Axel Niklasson on 05/10/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!

    /// provides mock credit score data to present to the user
    let scoreStore = ScoreStore()

    override func viewDidLoad() {
        super.viewDidLoad()

        /// put up some placeholders while fetching credit score
        scoreLabel.text = "-"
        maxScoreLabel.text = "out of -"

        /// fetch credit score
        scoreStore.fetchScore { result in
            switch result {
            case .success(let score):
                /// head back on main thread before updating view
                DispatchQueue.main.async {
                    /// update credit score info
                    self.scoreLabel.text = "\(score.score)"
                    self.maxScoreLabel.text = "out of \(score.maxScore)"
                }
            case .failure(let error):
                    /// head back on main thread before updating view
                    DispatchQueue.main.async {
                        /// show generic error alert, no retrying
                        print(error.localizedDescription)
                        let alert = UIAlertController(title: "Hmmm", message: "Seems we're not able to show your credit score at the moment, please check your internet connection and try again later.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(alert, animated: true)
                    }
            }
        }
    }
}

