//
//  UpdatePaymentAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 18.03.25.
//

import Foundation
import FluxAIViewModel
import Swinject
import SwinjectAutoregistration

final class UpdatePaymentAssembly: Assembly {
    func assemble(container: Swinject.Container) {
        registerViewModelServices(in: container)
        registerViewModel(in: container)
    }

    func registerViewModel(in container: Container) {
        container.autoregister(IPaymentViewModel.self, initializer: PaymentViewModel.init)
    }

    func registerViewModelServices(in container: Container) {
        container.autoregister(IPaymentService.self, initializer: PaymentService.init)
    }
}
