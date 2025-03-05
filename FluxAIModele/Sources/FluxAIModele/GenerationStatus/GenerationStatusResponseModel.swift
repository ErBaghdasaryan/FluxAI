//
//  GenerationStatusResponseModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 05.03.25.
//

// MARK: - GenerationStatusResponseModel
public struct GenerationStatusResponseModel: Codable {
    public let error: Bool
    public let message: JSONNull?
    public let data: GenerationStatusDataClass
}

// MARK: - DataClass
public struct GenerationStatusDataClass: Codable {
    public let id, generationID: Int
    public let jobID: String
    public let templateID, preview: JSONNull?
    public let resultURL: String
    public let status: String
    public let isGodMode, isCouplePhoto, isPV, isPika: Bool
    public let isTxt2Img, isMarked: Bool
    public let mark: JSONNull?
    public let seconds: Int
    public let startedAt, finishedAt: String

    public enum CodingKeys: String, CodingKey {
        case id
        case generationID = "generationId"
        case jobID = "jobId"
        case templateID = "templateId"
        case preview
        case resultURL = "resultUrl"
        case status, isGodMode, isCouplePhoto, isPV, isPika, isTxt2Img, isMarked, mark, seconds, startedAt, finishedAt
    }
}
