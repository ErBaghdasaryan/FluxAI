//
//  HomeViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIViewModel
import SnapKit

class HomeViewController: BaseViewController {

    var viewModel: ViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        setupConstraints()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

    }

}

//MARK: Make buttons actions
extension HomeViewController {
    
    private func makeButtonsAction() {

    }
}

extension HomeViewController: IViewModelableController {
    typealias ViewModel = IHomeViewModel
}


//MARK: Preview
import SwiftUI

struct HomeViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let homeViewController = HomeViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) -> HomeViewController {
            return homeViewController
        }

        func updateUIViewController(_ uiViewController: HomeViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HomeViewControllerProvider.ContainerView>) {
        }
    }
}
