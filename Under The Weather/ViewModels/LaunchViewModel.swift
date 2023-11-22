//
//  CitySearchViewModel.swift
//  Under The Weather
//
//  Created by Matthew Lock on 30/05/2023.
//

import Foundation

protocol LaunchNavigationDelegate: AnyObject {
    func nextButtonTapped()
}

struct LaunchViewModel {

    let navigationDelegate: LaunchNavigationDelegate

    func nextTapped() {
        navigationDelegate.nextButtonTapped()
    }

}
