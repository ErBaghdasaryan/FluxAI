//
//  HistoryModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 28.02.25.
//

import UIKit

public struct HistoryModel {
    public let id: Int?
    public let image: UIImage
    public let date: String
    public let prompt: String

    public init(id: Int? = nil, image: UIImage, date: String, prompt: String) {
        self.id = id
        self.image = image
        self.date = date
        self.prompt = prompt
    }
}
