//
//  AddAvatarRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import UIKit
import FluxAIViewModel
import FluxAIModele

final class AddAvatarRouter: BaseRouter {
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

    static func showGenerateViewController(in navigationController: UINavigationController, navigationModel: AvatarGenerationNavigationModel) {
        let viewController = ViewControllerFactory.makeGenerateViewController(navigationModel: navigationModel)
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = false
        viewController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
