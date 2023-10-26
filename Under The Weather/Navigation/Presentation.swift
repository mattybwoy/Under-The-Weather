//
//  Presentation.swift
//  Under The Weather
//
//  Created by Abel Demoz on 14/10/2023.
//

import UIKit

enum Presentation {
    case push(animated: Bool)
    case modal(
        animated: Bool,
        presentationStyle: UIModalPresentationStyle = .automatic,
        transitionStyle: UIModalTransitionStyle = .coverVertical
    )
}
