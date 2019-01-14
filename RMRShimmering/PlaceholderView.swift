//
//  PlaceholderView.swift
//  Logo-iOS
//
//  Created by Anton Glezman on 11/01/2019.
//

import UIKit

class PlaceholderView: UIView {

  @IBOutlet var view: UIView!
  
  
  // MARK: - Initialization
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    Bundle.main.loadNibNamed(
      String(describing: type(of: self)),
      owner: self,
      options: nil)
    view.frame = bounds
    addSubview(view)
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    Bundle.main.loadNibNamed(
      String(describing: type(of: self)),
      owner: self,
      options: nil)
    view.frame = bounds
    addSubview(view)
  }

}
