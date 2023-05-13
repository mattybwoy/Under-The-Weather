//
//  GenericViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import UIKit

class GenericViewController<T: UIView>: UIViewController {

  public var rootView: T { return view as! T }
    
  override open func loadView() {
     self.view = T()
  }

}
