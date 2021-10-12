//
//  DonutView.swift
//  mock-cs
//
//  Created by Axel Niklasson on 12/10/2021.
//

import UIKit

class ScoreView: UIView {

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var maxScoreLabel: UILabel!
    @IBOutlet weak var progressView: UIView!

    /// properties
    private let progressIndicatorLayer = CAShapeLayer()
    var progressIndicatorColor: UIColor = .orange
    var progressIndicatorWidth: CGFloat = 4.0
    var inset: CGPoint = CGPoint(x: 2.0, y: 2.0)

    var score: (score: Int, maxScore: Int) = (0, 0) {
        didSet {
            scoreLabel?.text = "\(score.score)"
            maxScoreLabel?.text = "out of \(score.maxScore)"

            /// only animate progress if it is valid
            if score.maxScore != 0 {
                animateProgressIndicator()
            }
        }
    }

    /// sublayer in which to draw animated progress indicator
    private func setupProgressIndicatorLayer() {

        /// add progress sublayer to view layer
        progressView.layer.addSublayer(progressIndicatorLayer)

        /// centre progress layer in view layer
        progressIndicatorLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        progressIndicatorLayer.position = CGPoint(x: progressView.layer.bounds.midX, y: progressView.layer.bounds.midY)

        /// no fill, color and line width from properties and round caps
        progressIndicatorLayer.fillColor = nil
        progressIndicatorLayer.strokeColor = progressIndicatorColor.cgColor
        progressIndicatorLayer.lineWidth = CGFloat(progressIndicatorWidth)
        progressIndicatorLayer.lineCap = .round

        /// create path for circle with start point "up" and centered in layer
        let radius = layer.bounds.width / 2 - progressIndicatorWidth - inset.x
        progressIndicatorLayer.path = UIBezierPath(arcCenter: CGPoint(x: progressIndicatorLayer.bounds.width/2.0, y: progressIndicatorLayer.bounds.height/2.0), radius: radius, startAngle: (-0.5) * .pi, endAngle: 1.5 * .pi, clockwise: true).cgPath

        /// do not stroke it yet
        progressIndicatorLayer.strokeStart = 0.0
        progressIndicatorLayer.strokeEnd = 0.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupProgressIndicatorLayer()
    }

    private func animateProgressIndicator() {
        /// A - slow animation to new value
        let grow = CABasicAnimation(keyPath: "strokeEnd")
        grow.toValue = CGFloat(score.score)/CGFloat(score.maxScore)
        grow.duration = 0.5
        grow.fillMode = .forwards
        grow.isRemovedOnCompletion = false

        /// B - near instant expansion of width
        let expand = CABasicAnimation(keyPath: "lineWidth")
        expand.beginTime = 0.5
        expand.toValue = progressIndicatorWidth * 1.5
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
        shrink.toValue = progressIndicatorWidth
        shrink.duration = 0.4
        shrink.fillMode = .forwards
        shrink.isRemovedOnCompletion = false

        /// group and add animations
        let growAndExpand = CAAnimationGroup()
        growAndExpand.animations = [grow, expand, flash, unflash, shrink]
        growAndExpand.duration = 4.0
        growAndExpand.fillMode = .forwards
        growAndExpand.isRemovedOnCompletion = false
        progressIndicatorLayer.add(growAndExpand, forKey: "line")
    }
}
