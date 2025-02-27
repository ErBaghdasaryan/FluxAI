//
//  ServiceAssembly.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import FluxAIViewModel

public final class ServiceAssembly: Assembly {

    public init() {}

    public func assemble(container: Container) {
        container.autoregister(IKeychainService.self, initializer: KeychainService.init)
        container.autoregister(IAppStorageService.self, initializer: AppStorageService.init)
    }
}
