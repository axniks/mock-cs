//
//  ViewController.swift
//  mock-cs
//
//  Created by Axel Niklasson on 05/10/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var scoreView: ScoreView!

    /// provides mock credit score data to present to the user
    let scoreStore = ScoreStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()


        /// fetch credit score
        scoreStore.fetchScore { result in
            switch result {
            case .success(let score):
                /// head back on main thread before updating view
                DispatchQueue.main.async {
                    /// update credit score info
                    /// put up some placeholders while fetching credit score
                    self.scoreView.score = (score.score, score.maxScore)
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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

