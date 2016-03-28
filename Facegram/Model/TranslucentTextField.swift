//
//  TranslucentTextField.swift
//  Facegram
//
//  Created by Dominic Ong on 2/19/16.
//  Copyright © 2016 Dominic Ong. All rights reserved.
//

import UIKit

class TranslucentTextField: UITextField {
  required init?(coder aDecoder: NSCoder) {
    placeholderText = ""
    super.init(coder: aDecoder)
    tintColor = UIColor.whiteColor()
  }
  
  override func textRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 16, 0)
  }
  
  override func editingRectForBounds(bounds: CGRect) -> CGRect {
    return CGRectInset(bounds, 16, 0)
  }
  
  var placeholderText: String {
    didSet {
      attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName: UIColor(white: 1.0, alpha: 0.7)])
    }
  }
}