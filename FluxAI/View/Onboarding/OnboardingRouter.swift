//
//  OnboardingRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//
import Foundation
import UIKit
import FluxAIViewModel

final class OnboardingRouter: BaseRouter {
    static func showNotificationViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeNotificationViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
