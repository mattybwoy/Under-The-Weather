//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenViewController: GenericViewController <LaunchScreenView> {
    
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
        let secondVC = InitialSearchViewController()
        let navVC = UINavigationController(rootViewController: secondVC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true)
    }
    
}
