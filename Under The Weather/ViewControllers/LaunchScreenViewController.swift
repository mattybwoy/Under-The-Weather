//
//  LaunchScreenViewController.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenViewController: GenericViewController <LaunchScreenView>, UITextFieldDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextField()
        setupLaunchButton()
    }
    
    override func loadView() {
        self.view = LaunchScreenView()
    }

    var contentView: LaunchScreenView {
        view as! LaunchScreenView
    }
    
    func setupTextField() {
        contentView.cityTextField.delegate = self
    }
    
    func setupLaunchButton() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(launchButtonTapped))
        gesture.numberOfTapsRequired = 1
        gesture.numberOfTouchesRequired = 1
        contentView.launchButton.addGestureRecognizer(gesture)
    }
    
    @objc func launchButtonTapped() {
        guard let text = contentView.cityTextField.text, !text.isEmpty else {
            let alert = UIAlertController(title: "Alert", message: "Invalid city, please try again", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            alert.view.accessibilityIdentifier = "Invalid city"
            self.present(alert, animated: true, completion: nil)
            return
        }
        DataManager.sharedInstance.prefixCitySearch(city: text, completionHandler: {_ in
            print(DataManager.sharedInstance.originCity)
        })
    }
    
}
