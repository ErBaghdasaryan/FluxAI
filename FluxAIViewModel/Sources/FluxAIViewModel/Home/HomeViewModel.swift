//
//  HomeViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//
import Foundation
import FluxAIModele

public protocol IHomeViewModel {

}

public class HomeViewModel: IHomeViewModel {

    private let homeService: IHomeService

    public init(homeService: IHomeService) {
        self.homeService = homeService
    }
}
