//
//  HomeService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIModele
import SQLite

public protocol IHomeService {
    func addHistory(_ model: HistoryModel) throws -> HistoryModel
}

public class HomeService: IHomeService {

    public init() { }

    private let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!

    typealias Expression = SQLite.Expression

    public func addHistory(_ model: HistoryModel) throws -> HistoryModel {
        let db = try Connection("\(path)/db.sqlite3")
        let history = Table("History")
        let idColumn = Expression<Int>("id")
        let imageColumn = Expression<Data>("image")
        let dateColumn = Expression<String>("date")
        let promptColumn = Expression<String>("prompt")

        try db.run(history.create(ifNotExists: true) { t in
            t.column(idColumn, primaryKey: .autoincrement)
            t.column(imageColumn)
            t.column(dateColumn)
            t.column(promptColumn)
        })

        let imageData = model.image.pngData() ?? Data()

        let rowId = try db.run(history.insert(
            imageColumn <- imageData,
            dateColumn <- model.date,
            promptColumn <- model.prompt
        ))

        return HistoryModel(id: Int(rowId),
                            image: model.image,
                            date: model.date,
                            prompt: model.prompt)
    }
}
