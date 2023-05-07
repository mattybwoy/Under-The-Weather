//
//  LaunchScreen.swift
//  Under The Weather
//
//  Created by Matthew Lock on 06/05/2023.
//

import UIKit

class LaunchScreenView: UIView {
    
    public init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title: UILabel = {
        var title = UILabel()
        title.textColor = .systemYellow
        title.text = "Under The Weather"
        title.font = .systemFont(ofSize: 30)
        title.textAlignment = .center
        return title
    }()

}
