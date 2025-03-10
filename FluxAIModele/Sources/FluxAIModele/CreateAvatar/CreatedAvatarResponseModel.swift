//
//  CreatedAvatarResponseModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 10.03.25.
//

// MARK: - CreatedAvatarResponseModel
public struct CreatedAvatarResponseModel: Codable {
    public let error: Bool
    public let message: JSONNull?
    public let data: CreatedAvatar
}

// MARK: - DataClass
public struct CreatedAvatar: Codable {
    public let id: Int
    public let status, jobID: String
    public let avatar: Avatar
    public let createdAt: String

    public enum CodingKeys: String, CodingKey {
        case id, status
        case jobID = "jobId"
        case avatar, createdAt
    }
}

// MARK: - Avatar
public struct Avatar: Codable {
    public let id: Int
    public let title: JSONNull?
    public let preview: String
    public let gender: String
    public let isActive: Bool
}
