//
//  ContactUsViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 28.02.25.
//

import UIKit
import WebKit
import SnapKit

final class ContactUsViewController: BaseViewController {

    private let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func setupUI() {
        view.backgroundColor = .white
        self.title = "Contact us"
        self.navigationController?.navigationBar.tintColor = .black
        self.webView.backgroundColor = .clear
        if let url = URL(string: "https://www.termsfeed.com/live/87a1ed10-b693-4c21-b95f-caaf3e3f7966") {
            webView.load(URLRequest(url: url))
        }

        setupConstraints()
    }

    private func setupConstraints() {
        self.view.addSubview(webView)

        webView.snp.makeConstraints { view in
            view.top.equalToSuperview()
            view.bottom.equalToSuperview()
            view.leading.equalToSuperview()
            view.trailing.equalToSuperview()
        }
    }

    override func setupViewModel() {

    }

}

import SwiftUI

struct ContactUsViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let contactUsViewController = ContactUsViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<ContactUsViewControllerProvider.ContainerView>) -> ContactUsViewController {
            return contactUsViewController
        }

        func updateUIViewController(_ uiViewController: ContactUsViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<ContactUsViewControllerProvider.ContainerView>) {
        }
    }
}
