//
//  GenericViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import UIKit

// to determine whether this generic vc is needed, it's important
// to identify the purpose(s) it serves. From what I can see here,
// all it's doing is setting the view to an instance of type `T`?
// you can do away with this class altogether
class GenericViewController<T: UIView>: UIViewController {

  public var rootView: T { return view as! T }
    
  override open func loadView() {
     self.view = T()
  }

}
