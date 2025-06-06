//
//  TabBarViewController.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIViewModel
import SnapKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        lazy var homeViewController = self.createNavigation(title: "Home",
                                                            image: "home",
                                                            vc: ViewControllerFactory.makeHomeViewController())

        lazy var historyViewController = self.createNavigation(title: "History",
                                                               image: "history",
                                                               vc: ViewControllerFactory.makeHistoryViewController())

        lazy var settingsViewController = self.createNavigation(title: "Settings",
                                                                image: "settings",
                                                                vc: ViewControllerFactory.makeSettingsViewController())

        self.setViewControllers([homeViewController, historyViewController, settingsViewController], animated: true)

        homeViewController.delegate = self
        historyViewController.delegate = self
        settingsViewController.delegate = self
    }

    private func createNavigation(title: String, image: String, vc: UIViewController) -> UINavigationController {
        let navigation = UINavigationController(rootViewController: vc)
        self.tabBar.backgroundColor = UIColor.black
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.itemPositioning = .centered

        let nonselectedTitleColor: UIColor = UIColor(hex: "#8D929B")!
        let selectedTitleColor: UIColor = UIColor.white

        let unselectedImage = UIImage(named: image)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(nonselectedTitleColor)

        let selectedImage = UIImage(named: image)?
            .withRenderingMode(.alwaysOriginal)
            .withTintColor(selectedTitleColor)

        navigation.tabBarItem.image = unselectedImage
        navigation.tabBarItem.selectedImage = selectedImage
        navigation.tabBarItem.title = title

        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: nonselectedTitleColor
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: selectedTitleColor
        ]

        navigation.tabBarItem.setTitleTextAttributes(normalAttributes, for: .normal)
        navigation.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)

        return navigation
    }

    // MARK: - Deinit
    deinit {
        #if DEBUG
        print("deinit \(String(describing: self))")
        #endif
    }
}

//MARK: Navigation & TabBar Hidden
extension TabBarViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController.hidesBottomBarWhenPushed {
            self.tabBar.isHidden = true
        } else {
            self.tabBar.isHidden = false
        }
    }
}

//MARK: Preview
import SwiftUI

struct TabBarViewControllerProvider: PreviewProvider {

    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let tabBarViewController = TabBarViewController()
        
        func makeUIViewController(context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) -> TabBarViewController {
            return tabBarViewController
        }

        func updateUIViewController(_ uiViewController: TabBarViewControllerProvider.ContainerView.UIViewControllerType, context: UIViewControllerRepresentableContext<TabBarViewControllerProvider.ContainerView>) {
        }
    }
}
