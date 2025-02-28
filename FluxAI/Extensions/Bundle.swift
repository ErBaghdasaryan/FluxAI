//
//  Bundle.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 28.02.25.
//

import Foundation

public extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}
