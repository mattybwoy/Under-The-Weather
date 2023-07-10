//
//  AboutView.swift
//  Under The Weather
//
//  Created by Matthew Lock on 10/07/2023.
//

import UIKit
import SwiftUI

class AboutView: UIView {

    public var aboutModalView: UIHostingController <some View> = UIHostingController(rootView: AboutModalView())
    
    public override init(frame: CGRect) {
        super.init(frame: CGRect())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        addSubview(aboutModalView.view)
        setupAboutModal()
    }

    func setupAboutModal() {
        aboutModalView.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            aboutModalView.view.topAnchor.constraint(equalTo: topAnchor),
            aboutModalView.view.bottomAnchor.constraint(equalTo: bottomAnchor),
            aboutModalView.view.leadingAnchor.constraint(equalTo: leadingAnchor),
            aboutModalView.view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
