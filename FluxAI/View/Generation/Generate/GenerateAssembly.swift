//
//  GenerateAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIViewModel
import FluxAIModele
import Swinject
import SwinjectAutoregistration

final class GenerateAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IGenerateViewModel.self, argument: AvatarGenerationNavigationModel.self,
                               initializer: GenerateViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IGenerateService.self, initializer: GenerateService.init)
    }
}
