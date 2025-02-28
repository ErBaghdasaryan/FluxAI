//
//  HistoryViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation
import FluxAIModele

public protocol IHistoryViewModel {
    var savedItems: [HistoryModel] { get set }
    func loadShares()
}

public class HistoryViewModel: IHistoryViewModel {

    private let historyService: IHistoryService

    public var savedItems: [HistoryModel] = []

    public init(historyService: IHistoryService) {
        self.historyService = historyService
    }

    //MARK: TODO
    public func loadShares() {
        do {
//            self.savedItems = try self.historyService.getShares()
        } catch {
            print(error)
        }
    }
}
