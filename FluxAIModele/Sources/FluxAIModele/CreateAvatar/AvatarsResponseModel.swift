//
//  AvatarsResponseModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 10.03.25.
//

public struct AvatarsResponseModel: Codable {
    public let error: Bool
    public let message: JSONNull?
    public let data: [Avatar]
}
