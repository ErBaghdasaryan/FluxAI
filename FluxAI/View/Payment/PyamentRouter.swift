//
//  PyamentRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import UIKit
import FluxAIViewModel

final class PyamentRouter: BaseRouter {
    static func showTabBarViewController(in navigationController: UINavigationController) {
        let viewController = ViewControllerFactory.makeTabBarViewController()
        viewController.navigationItem.hidesBackButton = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(viewController, animated: true)
    }
}
