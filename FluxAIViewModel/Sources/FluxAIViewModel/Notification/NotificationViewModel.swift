//
//  NotificationViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import FluxAIModele

public protocol INotificationViewModel {
    var isEnabled: Bool { get set }
}

public class NotificationViewModel: INotificationViewModel {

    private let notificationService: INotificationService
    public var appStorageService: IAppStorageService

    public var isEnabled: Bool {
        get {
            return appStorageService.getData(key: .isEnabled) ?? false
        } set {
            appStorageService.saveData(key: .isEnabled, value: newValue)
        }
    }

    public init(notificationService: INotificationService, appStorageService: IAppStorageService) {
        self.notificationService = notificationService
        self.appStorageService = appStorageService
    }
}
