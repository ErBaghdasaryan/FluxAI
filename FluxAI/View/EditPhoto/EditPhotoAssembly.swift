//
//  EditPhotoAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import Foundation
import FluxAIViewModel
import FluxAIModele
import Swinject
import SwinjectAutoregistration

final class EditPhotoAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IEditPhotoViewModel.self, argument: EditPhotoNavigationModel.self,
                               initializer: EditPhotoViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IEditPhotoService.self, initializer: EditPhotoService.init)
    }
}
