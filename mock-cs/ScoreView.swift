//
//  DonutView.swift
//  mock-cs
//
//  Created by Axel Niklasson on 12/10/2021.
//

import UIKit

@IBDesignable class ScoreView: UIView {


    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var progressView: UIView!

    private let scoreArcLayer = CAShapeLayer()

    private func setupScoreArcLayer() {

        /// add sublayer to show progress towards max score
        progressView.layer.addSublayer(scoreArcLayer)

        /// centre layer in view
        scoreArcLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        scoreArcLayer.position = CGPoint(x: progressView.layer.bounds.midX, y: progressView.layer.bounds.midY)

        /// no fill, orange color, line width from property and round caps
        scoreArcLayer.fillColor = nil
        scoreArcLayer.strokeColor = UIColor.orange.cgColor
        scoreArcLayer.lineWidth = CGFloat(scoreArcWidth)
        scoreArcLayer.lineCap = .round

        /// create path for circle with start point "up" and centered in layer
        let radius = layer.bounds.width / 2 - scoreArcWidth - inset.x
        scoreArcLayer.path = UIBezierPath(arcCenter: CGPoint(x: scoreArcLayer.bounds.width/2.0, y: scoreArcLayer.bounds.height/2.0), radius: radius, startAngle: (-0.5) * .pi, endAngle: 1.5 * .pi, clockwise: true).cgPath

        /// do not stroke it yet
        scoreArcLayer.strokeStart = 0.0
        scoreArcLayer.strokeEnd = 0.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupScoreArcLayer()
    }

    private func animateProgress() {
        /// A - slow animation to new value
        let grow = CABasicAnimation(keyPath: "strokeEnd")
        grow.toValue = CGFloat(score.score)/CGFloat(score.maxScore)
        grow.duration = 0.5
        grow.fillMode = .forwards
        grow.isRemovedOnCompletion = false

        /// B - near instant expansion of width
        let expand = CABasicAnimation(keyPath: "lineWidth")
        expand.beginTime = 0.5
        expand.toValue = scoreArcWidth * 1.5
        expand.duration = 0.01
        expand.fillMode = .forwards
        expand.isRemovedOnCompletion = false

        /// B - near instant lighter color
        let flash = CABasicAnimation(keyPath: "strokeColor")
        flash.beginTime = 0.5
        flash.toValue = UIColor.yellow.cgColor
        flash.duration = 0.01
        flash.fillMode = .forwards
        flash.isRemovedOnCompletion = false

        /// C - slowly back to original color
        let unflash = CABasicAnimation(keyPath: "strokeColor")
        unflash.beginTime = 0.51
        unflash.toValue = UIColor.orange.cgColor
        unflash.duration = 0.4
        unflash.fillMode = .forwards
        unflash.isRemovedOnCompletion = false

        /// C - slowly back to original width
        let shrink = CABasicAnimation(keyPath: "lineWidth")
        shrink.beginTime = 0.51
        shrink.toValue = scoreArcWidth
        shrink.duration = 0.4
        shrink.fillMode = .forwards
        shrink.isRemovedOnCompletion = false

        /// group and add animations
        let growAndExpand = CAAnimationGroup()
        growAndExpand.animations = [grow, expand, flash, unflash, shrink]
        growAndExpand.duration = 4.0
        growAndExpand.fillMode = .forwards
        growAndExpand.isRemovedOnCompletion = false
        scoreArcLayer.add(growAndExpand, forKey: "line")
    }

    var score: (score: Int, maxScore: Int) = (0, 0) {
        didSet {
            scoreLabel?.text = "\(score.score)"
            maxScoreLabel?.text = "out of \(score.maxScore)"

            /// only animate progress if it is valid
            if score.maxScore != 0 {
                animateProgress()
            }
        }
    }

    @IBInspectable
    var scoreArcColor: UIColor = .orange

    @IBInspectable
    var scoreArcWidth: CGFloat = 4.0

    @IBInspectable
    var inset: CGPoint = CGPoint(x: 2.0, y: 2.0)

}
