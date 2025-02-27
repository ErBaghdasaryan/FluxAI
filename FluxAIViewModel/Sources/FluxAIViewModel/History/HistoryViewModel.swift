//
//  HistoryViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import FluxAIModele

public protocol IHistoryViewModel {

}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }
}
