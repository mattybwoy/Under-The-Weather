//
//  GenericViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 13/05/2023.
//

import UIKit
import Compass

class GenericViewController<T: UIView>: BasicViewController {

    public var rootView: T { return view as! T }

    override open func loadView() {
        view = T()
    }
}
