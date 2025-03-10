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

    //MARK: Intro
    static func makeIntroViewController() -> IntroViewController {
        let assembler = Assembler(commonAssemblies + [IntroAssembly()])
        let viewController = IntroViewController()
        viewController.viewModel = assembler.resolver.resolve(IIntroViewModel.self)
        return viewController
    }

    //MARK: AddAvatar
    static func makeAddAvatarViewController() -> AddAvatarViewController {
        let assembler = Assembler(commonAssemblies + [AddAvatarAssembly()])
        let viewController = AddAvatarViewController()
        viewController.viewModel = assembler.resolver.resolve(IAddAvatarViewModel.self)
        return viewController
    }

    //MARK: Generate
    static func makeGenerateViewController(navigationModel: AvatarGenerationNavigationModel) -> GenerateViewController {
        let assembler = Assembler(commonAssemblies + [GenerateAssembly()])
        let viewController = GenerateViewController()
        viewController.viewModel = assembler.resolver.resolve(IGenerateViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: History
    static func makeHistoryViewController() -> HistoryViewController {
        let assembler = Assembler(commonAssemblies + [HistoryAssembly()])
        let viewController = HistoryViewController()
        viewController.viewModel = assembler.resolver.resolve(IHistoryViewModel.self)
        return viewController
    }

    //MARK: EditPhoto
    static func makeEditPhotoViewController(navigationModel: EditPhotoNavigationModel) -> EditPhotoViewController {
        let assembler = Assembler(commonAssemblies + [EditPhotoAssembly()])
        let viewController = EditPhotoViewController()
        viewController.viewModel = assembler.resolver.resolve(IEditPhotoViewModel.self, argument: navigationModel)
        return viewController
    }

    //MARK: Settings
    static func makeSettingsViewController() -> SettingsViewController {
        let assembler = Assembler(commonAssemblies + [SettingsAssembly()])
        let viewController = SettingsViewController()
        viewController.viewModel = assembler.resolver.resolve(ISettingsViewModel.self)
        return viewController
    }

    //MARK: PrivacyPolicy
    static func makePrivacyViewController() -> PrivacyViewController {
        let viewController = PrivacyViewController()
        return viewController
    }

    //MARK: Terms
    static func makeTermsViewController() -> TermsViewController {
        let viewController = TermsViewController()
        return viewController
    }

    //MARK: ContactUs
    static func makeContactUsViewController() -> ContactUsViewController {
        let viewController = ContactUsViewController()
        return viewController
    }
}
