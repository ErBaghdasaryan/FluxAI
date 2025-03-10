//
//  AddAvatarViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 09.03.25.
//

import Foundation
import FluxAIModele

public protocol IAddAvatarViewModel {

}

public class AddAvatarViewModel: IAddAvatarViewModel {

    private let addAvatarService: IAddAvatarService

    public init(addAvatarService: IAddAvatarService) {
        self.addAvatarService = addAvatarService
    }
}
