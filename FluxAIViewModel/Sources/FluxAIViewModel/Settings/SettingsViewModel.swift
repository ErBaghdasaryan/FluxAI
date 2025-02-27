//
//  SettingsViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import FluxAIModele

public protocol ISettingsViewModel {

}

public class SettingsViewModel: ISettingsViewModel {

    private let settingsService: ISettingsService

    public init(settingsService: ISettingsService) {
        self.settingsService = settingsService
    }
}
