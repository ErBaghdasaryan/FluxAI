//
//  HomeViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//
import Foundation
import FluxAIModele
import Combine

public protocol IHomeViewModel {
    var requestResponse: RequestResponseModel? { get set }
    var fetchGenerationModel: GenerationStatusResponseModel? { get set }
    var avatars: AvatarsResponseModel? { get set }
    var createByPromptSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var fetchGenerationSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var avatarsLoadSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByPromptRequest(userId: String?, prompt: String?)
    func fetchGenerationStatus(userId: String?, jobId: String)
    func addHistory(_ model: HistoryModel)
    var savedPrompt: String { get set }
    var savedAspectRatio: String { get set }
    var userID: String { get set }
    func getAvatars(userId: String)
}

public class HomeViewModel: IHomeViewModel {

    private let homeService: IHomeService
    public let networkService: INetworkService
    public var appStorageService: IAppStorageService

    public var requestResponse: RequestResponseModel?
    public var fetchGenerationModel: GenerationStatusResponseModel?
    public var avatars: AvatarsResponseModel?
    public var createByPromptSuccessSubject = PassthroughSubject<Bool, Never>()
    public var fetchGenerationSuccessSubject = PassthroughSubject<Bool, Never>()
    public var avatarsLoadSuccessSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    public var savedPrompt: String {
        get {
            return appStorageService.getData(key: .savedPrompt) ?? ""
        } set {
            appStorageService.saveData(key: .savedPrompt, value: newValue)
        }
    }

    public var savedAspectRatio: String {
        get {
            return appStorageService.getData(key: .savedAspectRatio) ?? ""
        } set {
            appStorageService.saveData(key: .savedAspectRatio, value: newValue)
        }
    }

    public var userID: String {
        get {
            return appStorageService.getData(key: .apphudUserID) ?? ""
        } set {
            appStorageService.saveData(key: .apphudUserID, value: newValue)
        }
    }

    public init(homeService: IHomeService,
                appStorageService: IAppStorageService,
                networkService: INetworkService) {
        self.homeService = homeService
        self.appStorageService = appStorageService
        self.networkService = networkService
    }

    public func createByPromptRequest(userId: String?, prompt: String?) {
        Task {
            do {
                let response = try await networkService.createByPromptRequest(userId: userId, prompt: prompt)
                requestResponse = response
                self.createByPromptSuccessSubject.send(true)
            } catch {
                self.createByPromptSuccessSubject.send(false)
            }
        }
    }

    public func fetchGenerationStatus(userId: String?, jobId: String) {
        networkService.fetchGenerationStatus(userId: userId, jobId: jobId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.fetchGenerationSuccessSubject.send(false)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.fetchGenerationModel = response
                self?.fetchGenerationSuccessSubject.send(true)
            })
            .store(in: &cancellables)
    }

    public func getAvatars(userId: String) {
        networkService.getAvatars(userId: userId)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure:
                    self?.avatarsLoadSuccessSubject.send(false)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] response in
                self?.avatars = response
                self?.avatarsLoadSuccessSubject.send(true)
            })
            .store(in: &cancellables)
    }

    public func addHistory(_ model: HistoryModel) {
        do {
            _ = try self.homeService.addHistory(model)
        } catch {
            print(error)
        }
    }
}
