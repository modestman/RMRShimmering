//
//  ShimmeringView.swift
//  RMRShimmering
//
//  Created by Anton Glezman on 11/01/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit


/// Lightweight, generic shimmering view.
public class ShimmeringView: UIView, Shimmering {
    
    
    // MARK: - Public properties
    
    public var isShimmering: Bool {
        get { return shimmeringLayer.isShimmering }
        set { shimmeringLayer.isShimmering = newValue }
    }
    
    public var shimmeringPauseDuration: CFTimeInterval {
        get { return shimmeringLayer.shimmeringPauseDuration }
        set { shimmeringLayer.shimmeringPauseDuration = newValue }
    }
    
    public var shimmeringAnimationOpacity: CGFloat {
        get { return shimmeringLayer.shimmeringAnimationOpacity }
        set { shimmeringLayer.shimmeringAnimationOpacity = newValue }
    }
    
    public var shimmeringOpacity: CGFloat {
        get { return shimmeringLayer.shimmeringOpacity }
        set { shimmeringLayer.shimmeringOpacity = newValue }
    }
    
    public var shimmeringSpeed: CGFloat {
        get { return shimmeringLayer.shimmeringSpeed }
        set { shimmeringLayer.shimmeringSpeed = newValue }
    }
    
    public var shimmeringHighlightLength: CGFloat {
        get { return shimmeringLayer.shimmeringHighlightLength }
        set { shimmeringLayer.shimmeringHighlightLength = newValue }
    }
    
    public var shimmeringDirection: ShimmerDirection {
        get { return shimmeringLayer.shimmeringDirection }
        set { shimmeringLayer.shimmeringDirection = newValue }
    }
    
    public var shimmeringBeginFadeDuration: CFTimeInterval {
        get { return shimmeringLayer.shimmeringBeginFadeDuration }
        set { shimmeringLayer.shimmeringBeginFadeDuration = newValue }
    }
    
    public var shimmeringEndFadeDuration: CFTimeInterval {
        get { return shimmeringLayer.shimmeringEndFadeDuration }
        set { shimmeringLayer.shimmeringEndFadeDuration = newValue }
    }
    
    public var shimmeringFadeTime: CFTimeInterval {
        return shimmeringLayer.shimmeringFadeTime
    }
    
    public var shimmeringBeginTime: CFTimeInterval {
        get { return shimmeringLayer.shimmeringBeginTime }
        set { shimmeringLayer.shimmeringBeginTime = newValue }
    }
    
    /// The content view to be shimmered.
    public var contentView: UIView? {
        get {
            return _contentView
        }
        set {
            if _contentView != newValue {
                _contentView = newValue
                shimmeringLayer.contentLayer = newValue?.layer
            }
        }
    }
    
    
    // MARK: - Private properties
    
    private var _contentView: UIView?
    
    private var shimmeringLayer: ShimmeringLayer {
        // swiftlint:disable force_cast
        return layer as! ShimmeringLayer
        // swiftlint:enable force_cast
    }
    
    
    // MARK: - Override
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // if shimmering view created on storyboard, use its first subview as content view
        if let firstSubview = subviews.first {
            contentView = firstSubview
        }
    }
    
    override public class var layerClass: AnyClass {
        return ShimmeringLayer.self
    }
    
    override public func layoutSubviews() {
        _contentView?.bounds = bounds
        _contentView?.center = center
        super.layoutSubviews()
    }
    
}
