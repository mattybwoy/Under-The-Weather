//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenViewController: GenericViewController <LaunchScreenView> {
    
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
        setupNextButton()
    }
    
    override func loadView() {
        self.view = LaunchScreenView()
    }

    var contentView: LaunchScreenView {
        view as! LaunchScreenView
    }
    
    func setupNextButton() {
        contentView.nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
    }
    
    @objc private func nextButtonTapped() {
        viewModel.nextButtonTapped()
    }
    
}
