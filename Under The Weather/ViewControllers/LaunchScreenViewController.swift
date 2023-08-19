//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

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
        contentView.delegate = self
    }
    
    override func loadView() {
        self.view = LaunchScreenView()
    }

    var contentView: LaunchScreenView {
        view as! LaunchScreenView
    }
    
    func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }
    
}
