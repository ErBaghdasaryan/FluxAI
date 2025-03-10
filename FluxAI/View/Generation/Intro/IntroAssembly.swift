//
//  IntroAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIViewModel
import Swinject
import SwinjectAutoregistration

final class IntroAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IIntroViewModel.self, initializer: IntroViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IIntroService.self, initializer: IntroService.init)
    }
}
