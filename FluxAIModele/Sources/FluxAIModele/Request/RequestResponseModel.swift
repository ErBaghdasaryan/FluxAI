//
//  RequestResponseModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 05.03.25.
//

// MARK: - RequestResponseModel
public struct RequestResponseModel: Codable {
    public let error: Bool
    public let message: JSONNull?
    public let data: RequestDataModel
}

// MARK: - RequestDataModel
public struct RequestDataModel: Codable {
    public let id, generationID: Int
    public let jobID: String
    public let templateID, preview, resultURL: JSONNull?
    public let status: String
    public let isGodMode, isCouplePhoto, isPV, isPika: Bool
    public let isTxt2Img, isMarked: Bool
    public let mark: JSONNull?
    public let seconds: Int
    public let startedAt: String
    public let finishedAt: JSONNull?

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

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}
