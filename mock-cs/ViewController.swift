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

    override func viewDidLoad() {
        super.viewDidLoad()

        scoreLabel.text = "-"
        maxScoreLabel.text = "out of -"

        ScoreStore.refreshScore { score in
            DispatchQueue.main.async {
                self.scoreLabel.text = String(format: "%d", score.score)
                self.maxScoreLabel.text = String(format: "out of %d", score.maxScore)
            }
        }
    }
}

