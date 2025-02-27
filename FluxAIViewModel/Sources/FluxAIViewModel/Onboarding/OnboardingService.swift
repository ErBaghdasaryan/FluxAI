//
//  OnboardingService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIModele

public protocol IOnboardingService {
    func getOnboardingItems() -> [OnboardingPresentationModel]
}

public class OnboardingService: IOnboardingService {
    public init() { }

    public func getOnboardingItems() -> [OnboardingPresentationModel] {
        [
            OnboardingPresentationModel(image: "onboarding1",
                                        header: "Welcome",
                                        subheader: "To AI photo model Generator"),
            OnboardingPresentationModel(image: "onboarding2",
                                        header: "AI Photo model Generator",
                                        subheader: "Stary creating your masterpieses"),
            OnboardingPresentationModel(image: "onboarding3",
                                        header: "AI headshot Editor",
                                        subheader: "Generate a beautiful avatar"),
            OnboardingPresentationModel(image: "onboarding4",
                                        header: "Reviews about our application in the app store",
                                        subheader: ""),
        ]
    }
}
