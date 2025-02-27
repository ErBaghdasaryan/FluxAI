//
//  BaseRouter.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import Combine
import FluxAIViewModel

class BaseRouter {

    class func popViewController(in navigationController: UINavigationController, completion: (() -> Void)? = nil) {
        completion?()
        navigationController.popViewController(animated: true)
    }
}
