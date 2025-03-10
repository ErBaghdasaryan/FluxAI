//
//  GenerateViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIModele
import Combine

public protocol IGenerateViewModel {
    var requestResponse: CreateAvatarResponseModel? { get set }
    var createAvatarSuccessSubject: PassthroughSubject<Bool, Never> { get }
    func createAvatarRequest(userId: String, gender: String, photos: [URL]?, preview: URL)
    var photosFiles: [URL] { get }
    var previewFile: URL { get }
}

public class GenerateViewModel: IGenerateViewModel {

    private let generateService: IGenerateService
    public var photosFiles: [URL]
    public var previewFile: URL
    public let networkService: INetworkService

    public var requestResponse: CreateAvatarResponseModel?
    public var createAvatarSuccessSubject = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

    public init(generateService: IGenerateService,
                networkService: INetworkService,
                navigationModel: AvatarGenerationNavigationModel) {
        self.generateService = generateService
        self.networkService = networkService
        self.photosFiles = navigationModel.photosFiles
        self.previewFile = navigationModel.previewFile
    }

    public func createAvatarRequest(userId: String, gender: String, photos: [URL]?, preview: URL) {
        Task {
            do {
                let response = try await networkService.createAvatarRequest(userId: userId,
                                                                            gender: gender,
                                                                            photo: photos,
                                                                            preview: preview)
                requestResponse = response
                self.createAvatarSuccessSubject.send(true)
            } catch {
                self.createAvatarSuccessSubject.send(false)
            }
        }
    }


}
