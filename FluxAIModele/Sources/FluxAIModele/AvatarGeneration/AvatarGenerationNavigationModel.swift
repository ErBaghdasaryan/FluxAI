//
//  AvatarGenerationNavigationModel.swift
//  FluxAIModele
//
//  Created by Er Baghdasaryan on 10.03.25.
//

import Foundation

public final class AvatarGenerationNavigationModel {
    public var photosFiles: [URL]
    public var previewFile: URL

    public init(photosFiles: [URL], previewFile: URL) {
        self.photosFiles = photosFiles
        self.previewFile = previewFile
    }
}
