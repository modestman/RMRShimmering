//
//  ShimmeringLayer.swift
//  RMRShimmering
//
//  Created by Anton Glezman on 11/01/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit


public class ShimmeringLayer: CALayer, Shimmering {
    
    // MARK: - Constants
    
    private enum Constant {
        // animations keys
        static let shimmerSlideAnimationKey = "slide"
        static let fadeAnimationKey = "fade"
        static let endFadeAnimationKey = "fade-end"
        static let shimmeringLayerDragCoefficient: Float = 1.0
    }
    
    
    // MARK: - Public properties
    
    public var isShimmering: Bool = false {
        didSet {
            if isShimmering != oldValue {
                updateShimmering()
            }
        }
    }
    
    public var shimmeringPauseDuration: CFTimeInterval = 0.4 {
        didSet {
            if shimmeringPauseDuration != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringAnimationOpacity: CGFloat = 0.5 {
        didSet {
            if shimmeringAnimationOpacity != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringOpacity: CGFloat = 1.0 {
        didSet {
            if shimmeringAnimationOpacity != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringSpeed: CGFloat = 230.0 {
        didSet {
            if shimmeringSpeed != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringHighlightLength: CGFloat = 1.0 {
        didSet {
            if shimmeringHighlightLength != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringDirection: ShimmerDirection = .right {
        didSet {
            if shimmeringDirection != oldValue {
                clearMask()
                updateShimmering()
            }
        }
    }
    
    public var shimmeringBeginFadeDuration: CFTimeInterval = 0.1
    
    public var shimmeringEndFadeDuration: CFTimeInterval = 0.3
    
    public var shimmeringFadeTime: CFTimeInterval = 0.0
    
    public var shimmeringBeginTime: CFTimeInterval = ShimmerDefaultBeginTime {
        didSet {
            if shimmeringBeginTime != oldValue {
                updateShimmering()
            }
        }
    }
    
    public var contentLayer: CALayer? {
        didSet {
            // reset mask
            maskLayer = nil
            // note content layer and add for display
            if let content = contentLayer {
                sublayers = [content]
            } else {
                sublayers = nil
            }
            updateShimmering()
        }
    }
    

    // MARK: - Private properties
    
    private var maskLayer: ShimmeringMaskLayer?
    
    
    // MARK: - Override
    
    override public var bounds: CGRect {
        didSet {
            if bounds != oldValue {
                updateShimmering()
            }
        }
    }
    
    override public func layoutSublayers() {
        super.layoutSublayers()
        if let contentLayer = contentLayer {
            contentLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            contentLayer.bounds = bounds
            contentLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        }
        if maskLayer != nil {
            updateMaskLayout()
        }
    }
    
    
    // MARK: - Private methods
    
    private func clearMask() {
        if nil == maskLayer {
            return
        }
        
        let disableActions = CATransaction.disableActions()
        CATransaction.setDisableActions(true)
        
        maskLayer = nil
        contentLayer?.mask = nil
        
        CATransaction.setDisableActions(disableActions)
    }
    
    private func createMaskIfNeeded() {
        if isShimmering && maskLayer == nil {
            maskLayer = ShimmeringMaskLayer()
            maskLayer?.delegate = self
            contentLayer?.mask = maskLayer
            updateMaskColors()
            updateMaskLayout()
        }
    }

    private func updateMaskColors() {
        if nil == maskLayer {
            return
        }
        
        // We create a gradient to be used as a mask.
        // In a mask, the colors do not matter, it's the alpha that decides the degree of masking.
        let maskedColor = UIColor(white: 1.0, alpha: shimmeringOpacity)
        let unmaskedColor = UIColor(white: 1.0, alpha: shimmeringAnimationOpacity)
        
        // Create a gradient from masked to unmasked to masked.
        maskLayer?.colors = [
            maskedColor.cgColor,
            unmaskedColor.cgColor,
            maskedColor.cgColor
        ]
    }
    
    func updateMaskLayout() {
        guard let contentLayer = contentLayer, let maskLayer = maskLayer else {
            return
        }
        // Everything outside the mask layer is hidden, so we need to create a mask long enough for
        // the shimmered layer to be always covered by the mask.
        var length: CGFloat = 0.0
        if shimmeringDirection == .down || shimmeringDirection == .up {
            length = contentLayer.bounds.height
        } else {
            length = contentLayer.bounds.width
        }
        if length == 0 {
            return
        }
        
        // extra distance for the gradient to travel during the pause.
        let extraDistance: CGFloat = length + shimmeringSpeed * CGFloat(shimmeringPauseDuration)
        
        // compute how far the shimmering goes
        let fullShimmerLength: CGFloat = length * 3.0 + extraDistance
        let travelDistance: CGFloat = length * 2.0 + extraDistance
        
        // position the gradient for the desired width
        let highlightOutsideLength: CGFloat = (1.0 - shimmeringHighlightLength) / 2.0
        maskLayer.locations = [NSNumber(value: Float(highlightOutsideLength)),
                               NSNumber(value: 0.5),
                               NSNumber(value: Float(1.0 - highlightOutsideLength))]
        
        let startPoint: CGFloat = (length + extraDistance) / fullShimmerLength
        let endPoint: CGFloat = travelDistance / fullShimmerLength
        
        // position for the start of the animation
        maskLayer.anchorPoint = CGPoint.zero
        if shimmeringDirection == .down || shimmeringDirection == .up {
            maskLayer.startPoint = CGPoint(x: 0.0, y: startPoint)
            maskLayer.endPoint = CGPoint(x: 0.0, y: endPoint)
            maskLayer.position = CGPoint(x: 0.0, y: -travelDistance)
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: contentLayer.bounds.width, height: fullShimmerLength)
        } else {
            maskLayer.startPoint = CGPoint(x: startPoint, y: 0.0)
            maskLayer.endPoint = CGPoint(x: endPoint, y: 0.0)
            maskLayer.position = CGPoint(x: -travelDistance, y: 0.0)
            maskLayer.bounds = CGRect(x: 0.0, y: 0.0, width: fullShimmerLength, height: contentLayer.bounds.height)
        }
    }

    private func updateShimmering() {
        createMaskIfNeeded()
        
        // if not shimmering and no mask, noop
        guard let maskLayer = maskLayer, isShimmering else { return }
        
        // ensure layout
        layoutIfNeeded()
        
        let disableActions = CATransaction.disableActions()
        if !isShimmering {
            if disableActions {
                // simply remove mask
                clearMask()
            } else {
                // end slide
                var slideEndTime: CFTimeInterval = 0
                
                if let slideAnimation = maskLayer.animation(forKey: Constant.shimmerSlideAnimationKey) {
                    // determine total time sliding
                    let now = CACurrentMediaTime()
                    let slideTotalDuration: CFTimeInterval = now - slideAnimation.beginTime
                    
                    // determine time offset into current slide
                    let slideTimeOffset = fmod(slideTotalDuration, slideAnimation.duration)
                    
                    // transition to non-repeating slide
                    let finishAnimation = shimmerSlideFinish(slideAnimation)
                    
                    // adjust begin time to now - offset
                    finishAnimation.beginTime = now - slideTimeOffset
                    
                    // note slide end time and begin
                    slideEndTime = finishAnimation.beginTime + slideAnimation.duration
                    maskLayer.add(finishAnimation, forKey: Constant.shimmerSlideAnimationKey)
                }
                
                // fade in text at slideEndTime
                let fadeInAnimation = fadeAnimation(
                    layer: maskLayer.fadeLayer,
                    opacity: 1.0,
                    duration: shimmeringEndFadeDuration)
                fadeInAnimation.delegate = self
                fadeInAnimation.setValue(NSNumber(value: true), forKey: Constant.endFadeAnimationKey)
                fadeInAnimation.beginTime = slideEndTime
                maskLayer.fadeLayer.add(fadeInAnimation, forKey: Constant.fadeAnimationKey)
                
                // expose end time for synchronization
                shimmeringFadeTime = slideEndTime
            }
        } else {
            // fade out text, optionally animated
            var fadeOutAnimation: CABasicAnimation? = nil
            if shimmeringBeginFadeDuration > 0.0 && !disableActions {
                let animation = fadeAnimation(
                    layer: maskLayer.fadeLayer,
                    opacity: 0.0,
                    duration: shimmeringBeginFadeDuration)
                maskLayer.fadeLayer.add(animation, forKey: Constant.fadeAnimationKey)
                fadeOutAnimation = animation
            } else {
                let innerDisableActions = CATransaction.disableActions()
                CATransaction.setDisableActions(true)
                maskLayer.fadeLayer.opacity = 0.0
                maskLayer.fadeLayer.removeAllAnimations()
                CATransaction.setDisableActions(innerDisableActions)
            }
            
            // begin slide animation

            // compute shimmer duration
            var length: CGFloat = 0.0
            if shimmeringDirection == .down || shimmeringDirection == .up {
                length = contentLayer?.bounds.height ?? 0
            } else {
                length = contentLayer?.bounds.width ?? 0
            }
            let animationDuration = CFTimeInterval((length / shimmeringSpeed) + CGFloat(shimmeringPauseDuration))
            
            if let slideAnimation = maskLayer.animation(forKey: Constant.shimmerSlideAnimationKey) {
                // ensure existing slide animation repeats
                let repeatsAnimation = shimmerSlideRepeat(
                    slideAnimation,
                    duration: animationDuration,
                    direction: shimmeringDirection)
                maskLayer.add(repeatsAnimation, forKey: Constant.shimmerSlideAnimationKey)
            } else {
                // add slide animation
                let slideAnimation = shimmerSlideAnimation(duration: animationDuration, direction: shimmeringDirection)
                slideAnimation.fillMode = .forwards
                slideAnimation.isRemovedOnCompletion = false
                if shimmeringBeginTime == ShimmerDefaultBeginTime {
                    slideAnimation.beginTime = CACurrentMediaTime() + (fadeOutAnimation?.duration ?? 0)
                } else {
                    slideAnimation.beginTime = CACurrentMediaTime() + shimmeringBeginTime
                }
                maskLayer.add(slideAnimation, forKey: Constant.shimmerSlideAnimationKey)
            }
        }
    }
    
    private func shimmeringLayerAnimationApplyDragCoefficient(_ animation: CAAnimation) {
        let k = Constant.shimmeringLayerDragCoefficient
        if k != 0 && k != 1 {
            animation.speed = 1 / k
        }
    }
    
    private func fadeAnimation(layer: CALayer, opacity: CGFloat, duration: CFTimeInterval) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.fromValue = NSNumber(value: (layer.presentation() ?? layer).opacity)
        animation.toValue = NSNumber(value: Float(opacity))
        animation.fillMode = .both
        animation.isRemovedOnCompletion = false
        animation.duration = duration
        shimmeringLayerAnimationApplyDragCoefficient(animation)
        return animation
    }
    
    private func shimmerSlideAnimation(duration: CFTimeInterval, direction: ShimmerDirection) -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "position")
        animation.toValue = NSValue(cgPoint: CGPoint.zero)
        animation.duration = duration
        animation.repeatCount = Float.greatestFiniteMagnitude
        shimmeringLayerAnimationApplyDragCoefficient(animation)
        if direction == .left || direction == .up {
            animation.speed = -fabsf(animation.speed)
        }
        return animation
    }
    
    // take a shimmer slide animation and turns into repeating
    private func shimmerSlideRepeat(
        _ a: CAAnimation,
        duration: CFTimeInterval,
        direction: ShimmerDirection) -> CAAnimation {
        
        let anim = a.copy() as! CAAnimation
        anim.repeatCount = Float.greatestFiniteMagnitude
        anim.duration = duration
        switch direction {
        case .right, .down:
            anim.speed = fabsf(anim.speed)
        case .left, .up:
            anim.speed = -fabsf(anim.speed)
        }
        return anim
    }
    
    // take a shimmer slide animation and turns into finish
    private func shimmerSlideFinish(_ a: CAAnimation) -> CAAnimation {
        let anim = a.copy() as! CAAnimation
        anim.repeatCount = 0
        return anim
    }
    
}


// MARK: - CALayerDelegate

extension ShimmeringLayer: CALayerDelegate {
    
    public func action(for layer: CALayer, forKey event: String) -> CAAction? {
        return nil
    }
    
}


// MARK: - CAAnimationDelegate

extension ShimmeringLayer: CAAnimationDelegate {
    
    public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag && (anim.value(forKey: Constant.endFadeAnimationKey) as? NSNumber)?.boolValue ?? false {
            maskLayer?.fadeLayer.removeAnimation(forKey: Constant.endFadeAnimationKey)
            clearMask()
        }
    }
    
}


class ShimmeringMaskLayer: CAGradientLayer {
    
    var fadeLayer = CALayer()
    
    override init() {
        super.init()
        fadeLayer.backgroundColor = UIColor.white.cgColor
        addSublayer(fadeLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers() {
        super.layoutSublayers()
        fadeLayer.bounds = bounds
        fadeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
}
