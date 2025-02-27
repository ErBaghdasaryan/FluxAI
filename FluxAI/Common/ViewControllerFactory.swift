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
}
