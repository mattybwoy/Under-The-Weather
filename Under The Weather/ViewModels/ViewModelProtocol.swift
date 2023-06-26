//
//  ViewModelProtocol.swift
//  Under The Weather
//
//  Created by Matthew Lock on 25/06/2023.
//

protocol ViewModelProtocol {
    associatedtype Routes
    var router: Routes { get set }
    func nextButtonTapped()
}
