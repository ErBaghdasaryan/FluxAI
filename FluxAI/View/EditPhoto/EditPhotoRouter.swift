//
//  EditPhotoRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import Foundation
import UIKit
import FluxAIViewModel

final class EditPhotoRouter: BaseRouter {
    static func showPaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }

    static func showUpdatePaymentViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeUpdatePaymentViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
