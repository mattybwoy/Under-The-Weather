//
//  AboutViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 10/07/2023.
//

import UIKit

class AboutViewController: GenericViewController <AboutView> {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        self.view = AboutView()
    }

    var contentView: AboutView {
        view as! AboutView
    }

}
