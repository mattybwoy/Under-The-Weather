//
//  Navigator.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

protocol Navigator: AnyObject {
    func present(_ viewController: UIViewController, presentation: Presentation, onDismissed: (() -> Void)?)
    func dismiss(animated: Bool)
}
