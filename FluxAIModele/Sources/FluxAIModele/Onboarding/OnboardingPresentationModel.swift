//
//  OnboardingPresentationModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 27.02.25.
//
import Foundation

public struct OnboardingPresentationModel {
    public let image: String
    public let header: String
    public let subheader: String

    public init(image: String, header: String, subheader: String) {
        self.image = image
        self.header = header
        self.subheader = subheader
    }
}
