//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

// as mentioned in the comments for the `GenericViewController` class, you don't
// need launch vc to be a subclass of generic vc. you can just set the launch
// vc's view to `LaunchScreenView` to achieve the same result
final class LaunchScreenViewController: GenericViewController <LaunchScreenView>, LaunchDelegate {
    
    private let viewModel: LaunchViewModel
    
    init(viewModel: LaunchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.delegate = self
    }
    
    func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }
    
}
