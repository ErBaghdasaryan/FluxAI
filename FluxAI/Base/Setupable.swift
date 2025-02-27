//
//  Setupable.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import Foundation

protocol ISetupable {
    associatedtype SetupModel
    func setup(with model: SetupModel)
}
