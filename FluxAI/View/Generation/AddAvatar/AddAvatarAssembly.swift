//
//  AddAvatarAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIViewModel
import Swinject
import SwinjectAutoregistration

final class AddAvatarAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IAddAvatarViewModel.self, initializer: AddAvatarViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IAddAvatarService.self, initializer: AddAvatarService.init)
    }
}
