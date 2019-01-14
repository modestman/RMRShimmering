//
//  Shimmering.swift
//  RMRShimmering
//
//  Created by Anton Glezman on 11/01/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit


public enum ShimmerDirection {
    
    /// Shimmer animation goes from left to right
    case right
    
    /// Shimmer animation goes from right to left
    case left
    
    /// Shimmer animation goes from below to above
    case up
    
    /// Shimmer animation goes from above to below
    case down
}


/// Slide animation begin time. Default shimmering starts after fade in animation
public let shimmerDefaultBeginTime = CFTimeInterval.greatestFiniteMagnitude


public protocol Shimmering {
    
    /// Set this to `true` to start shimming and `false` to stop. Defaults to `false`.
    var isShimmering: Bool { get set }
    
    /// The time interval between shimmerings in seconds. Defaults to 0.4.
    var shimmeringPauseDuration: CFTimeInterval { get set }
    
    /// The opacity of the content while it is shimmering. Defaults to 0.5.
    var shimmeringAnimationOpacity: CGFloat { get set }
    
    /// The opacity of the content before it is shimmering. Defaults to 1.0.
    var shimmeringOpacity: CGFloat { get set }
    
    /// The speed of shimmering, in points per second. Defaults to 230.
    var shimmeringSpeed: CGFloat { get set }
    
    /// The highlight length of shimmering. Range of [0,1], defaults to 1.0.
    var shimmeringHighlightLength: CGFloat { get set }
  
    /// The direction of shimmering animation. Defaults to `righ`.
    var shimmeringDirection: ShimmerDirection { get set }
    
    /// The duration of the fade used when shimmer begins. Defaults to 0.1.
    var shimmeringBeginFadeDuration: CFTimeInterval { get set }
    
    /// The duration of the fade used when shimmer ends. Defaults to 0.3.
    var shimmeringEndFadeDuration: CFTimeInterval { get set }
    
    /**
     The absolute CoreAnimation media time when the shimmer will fade in.
     - discussion: Only valid after setting `shimmering` to `false`.
     */
    var shimmeringFadeTime: CFTimeInterval { get }
    
    /**
     The absolute CoreAnimation media time when the shimmer will begin.
     - discussion: Only valid after setting `shimmering` to `true`.
     */
    var shimmeringBeginTime: CFTimeInterval { get set }
    
}
