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
    var createByPromptSuccessSubject: PassthroughSubject<Bool, Never> { get }
    var fetchGenerationSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createByPromptRequest(userId: String?, prompt: String?)
    func fetchGenerationStatus(userId: String?, jobId: String)
    func addHistory(_ model: HistoryModel)
}

public class HomeViewModel: IHomeViewModel {

    private let homeService: IHomeService
    let networkService: INetworkService

    public var requestResponse: RequestResponseModel?
    public var fetchGenerationModel: GenerationStatusResponseModel?
    public var createByPromptSuccessSubject = PassthroughSubject<Bool, Never>()
    public var fetchGenerationSuccessSubject = PassthroughSubject<Bool, Never>()

    public init(homeService: IHomeService, networkService: INetworkService) {
        self.homeService = homeService
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
        Task {
            do {
                let response = try await networkService.fetchGenerationStatus(userId: userId, jobId: jobId)
                fetchGenerationModel = response
                self.fetchGenerationSuccessSubject.send(true)
            } catch {
                self.fetchGenerationSuccessSubject.send(false)
            }
        }
    }

    public func addHistory(_ model: HistoryModel) {
        do {
            _ = try self.homeService.addHistory(model)
        } catch {
            print(error)
        }
    }
}
