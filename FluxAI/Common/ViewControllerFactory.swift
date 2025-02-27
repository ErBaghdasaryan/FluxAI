//
//  ViewControllerFactory.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import Swinject
import FluxAIModele
import FluxAIViewModel

final class ViewControllerFactory {
    private static let commonAssemblies: [Assembly] = [ServiceAssembly()]

    //MARK: Onboarding
    static func makeOnboardingViewController() -> OnboardingViewController {
        let assembler = Assembler(commonAssemblies + [OnboardingAssembly()])
        let viewController = OnboardingViewController()
        viewController.viewModel = assembler.resolver.resolve(IOnboardingViewModel.self)
        return viewController
    }

    //MARK: Notification
    static func makeNotificationViewController() -> NotificationViewController {
        let assembler = Assembler(commonAssemblies + [NotificationAssembly()])
        let viewController = NotificationViewController()
        viewController.viewModel = assembler.resolver.resolve(INotificationViewModel.self)
        return viewController
    }

    //MARK: Payment
    static func makePaymentViewController() -> PaymentViewController {
        let assembler = Assembler(commonAssemblies + [PaymentAssembly()])
        let viewController = PaymentViewController()
        viewController.viewModel = assembler.resolver.resolve(IPaymentViewModel.self)
        return viewController
    }

    //MARK: - TabBar
    static func makeTabBarViewController() -> TabBarViewController {
        let viewController = TabBarViewController()
        return viewController
    }

    //MARK: Home
    static func makeHomeViewController() -> HomeViewController {
        let assembler = Assembler(commonAssemblies + [HomeAssembly()])
        let viewController = HomeViewController()
        viewController.viewModel = assembler.resolver.resolve(IHomeViewModel.self)
        return viewController
    }

    //MARK: History
    static func makeHistoryViewController() -> HistoryViewController {
        let assembler = Assembler(commonAssemblies + [HistoryAssembly()])
        let viewController = HistoryViewController()
        viewController.viewModel = assembler.resolver.resolve(IHistoryViewModel.self)
        return viewController
    }

    //MARK: Settings
    static func makeSettingsViewController() -> SettingsViewController {
        let assembler = Assembler(commonAssemblies + [SettingsAssembly()])
        let viewController = SettingsViewController()
        viewController.viewModel = assembler.resolver.resolve(ISettingsViewModel.self)
        return viewController
    }
}
