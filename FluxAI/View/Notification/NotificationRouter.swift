//
//  NotificationRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import UIKit
import FluxAIViewModel

final class NotificationRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
