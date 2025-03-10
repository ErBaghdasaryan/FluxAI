//
//  IntroViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIModele

public protocol IIntroViewModel {

}

public class IntroViewModel: IIntroViewModel {

    private let introService: IIntroService

    public init(introService: IIntroService) {
        self.introService = introService
    }
}
