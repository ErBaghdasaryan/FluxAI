//
//  EditPhotoViewModel.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 10.03.25.
//
import UIKit
import FluxAIModele
import Combine

public protocol IEditPhotoViewModel {
    var image: UIImage { get }
}

public class EditPhotoViewModel: IEditPhotoViewModel {

    private let editPhotoService: IEditPhotoService
    public var image: UIImage

    public init(editPhotoService: IEditPhotoService,
                navigationModel: EditPhotoNavigationModel) {
        self.editPhotoService = editPhotoService
        self.image = navigationModel.image
    }
}
