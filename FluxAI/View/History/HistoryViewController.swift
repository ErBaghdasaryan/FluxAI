//
//  HistoryViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIViewModel
import SnapKit

class HistoryViewController: BaseViewController {

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
extension HistoryViewController {
    
    private func makeButtonsAction() {

    }
}

extension HistoryViewController: IViewModelableController {
    typealias ViewModel = IHistoryViewModel
}


//MARK: Preview
import SwiftUI

struct HistoryViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let historyViewController = HistoryViewController()

        func makeUIViewController(context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) -> HistoryViewController {
            return historyViewController
        }

        func updateUIViewController(_ uiViewController: HistoryViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<HistoryViewControllerProvider.ContainerView>) {
        }
    }
}
