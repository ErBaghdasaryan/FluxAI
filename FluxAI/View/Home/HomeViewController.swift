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

    private let promptView = PromptView()
    private let useByPrompt = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        makeButtonsAction()
    }

    override func setupUI() {
        super.setupUI()

        self.view.backgroundColor = .black

        self.useByPrompt.backgroundColor = UIColor(hex: "#7500D2")
        self.useByPrompt.layer.masksToBounds = true
        self.useByPrompt.layer.cornerRadius = 20
        self.useByPrompt.setTitle("Use by Prompt", for: .normal)
        self.useByPrompt.setTitleColor(.white, for: .normal)
        self.useByPrompt.titleLabel?.font = UIFont(name: "SFProText-Semibold", size: 15)

        self.view.addSubview(promptView)
        self.view.addSubview(useByPrompt)
        setupConstraints()
        setupNavigationItems()
    }

    override func setupViewModel() {
        super.setupViewModel()
    }

    func setupConstraints() {

        promptView.snp.makeConstraints { view in
            view.top.equalToSuperview().offset(108)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(296)
        }

        useByPrompt.snp.makeConstraints { view in
            view.top.equalTo(promptView.snp.bottom).offset(16)
            view.leading.equalToSuperview().offset(16)
            view.trailing.equalToSuperview().inset(16)
            view.height.equalTo(40)
        }
    }

}

//MARK: Make buttons actions
extension HomeViewController {
    
    private func makeButtonsAction() {
        useByPrompt.addTarget(self, action: #selector(useByPromptTapped), for: .touchUpInside)
    }

    @objc func useByPromptTapped() {
        
    }

    private func setupNavigationItems() {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "getPro"), for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 113, height: 32)
        button.addTarget(self, action: #selector(getProSubscription), for: .touchUpInside)

        let proButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = proButton
    }

    @objc func getProSubscription() {
        guard let navigationController = self.navigationController else { return }

        HomeRouter.showPaymentViewController(in: navigationController)
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
