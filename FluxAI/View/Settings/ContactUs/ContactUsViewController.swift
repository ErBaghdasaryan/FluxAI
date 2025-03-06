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
        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSf2MIMwp1ZOS9OEM_NCXb7nP_cJIb3Zlm9IXaxA6WdN1GG1cQ/viewform?usp=header") {
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
