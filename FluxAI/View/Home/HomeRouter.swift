//
//  HomeRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import UIKit
import FluxAIViewModel

final class HomeRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
