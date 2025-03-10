//
//  CreateAvatarResponseModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import Foundation

// MARK: - CreateAvatarResponseModel
public struct CreateAvatarResponseModel: Codable {
    public let error: Bool
    public let message: JSONNull?
    public let data: AvatarResponseModel
}

// MARK: - DataClass
public struct AvatarResponseModel: Codable {
    public let id: Int
    public let status, jobID: String
    public let avatar: JSONNull?
    public let createdAt: String

    public enum CodingKeys: String, CodingKey {
        case id, status
        case jobID = "jobId"
        case avatar, createdAt
    }
}
