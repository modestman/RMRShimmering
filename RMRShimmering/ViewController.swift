//
//  ViewController.swift
//  RMRShimmering
//
//  Created by Anton Glezman on 11/01/2019.
//  Copyright © 2019 RedMadRobot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var shimmeringViews: [ShimmeringView]!

    override func viewDidLoad() {
        super.viewDidLoad()

        shimmeringViews.forEach { shimmeringView in
            shimmeringView.isShimmering = true
            shimmeringView.shimmeringBeginFadeDuration = 0.0
            shimmeringView.shimmeringBeginTime = 0.3
            shimmeringView.shimmeringAnimationOpacity = 0.18
            shimmeringView.shimmeringOpacity = 0.08
        }
    }

}

