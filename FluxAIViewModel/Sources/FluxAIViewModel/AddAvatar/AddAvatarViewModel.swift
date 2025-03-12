//
//  AddAvatarViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIModele

public protocol IAddAvatarViewModel {
    func login(userId: String, gender: String, source: String)
    var userID: String { get set }
    var loginResponse: LoginResponseModel? { get set }
}

public class AddAvatarViewModel: IAddAvatarViewModel {

    private let addAvatarService: IAddAvatarService
    public let networkService: INetworkService
    public let appStorageService: IAppStorageService

    public var userID: String {
        get {
            return appStorageService.getData(key: .apphudUserID) ?? ""
        } set {
            appStorageService.saveData(key: .apphudUserID, value: newValue)
        }
    }

    public var loginResponse: LoginResponseModel?

    public init(addAvatarService: IAddAvatarService,
                appStorageService: IAppStorageService,
                networkService: INetworkService) {
        self.addAvatarService = addAvatarService
        self.networkService = networkService
        self.appStorageService = appStorageService
    }

    public func login(userId: String, gender: String, source: String) {
        Task {
            do {
                self.loginResponse = try await networkService.login(userId: userId,
                                                              gender: gender,
                                                              source: source)
            } catch {
                print("###ERROR###ADDAVATARVIEWMODEL: login")
            }
        }
    }

}
