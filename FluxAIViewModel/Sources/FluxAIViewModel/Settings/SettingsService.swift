//
//  SettingsService.swift
//  FluxAIViewModel
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import FluxAIModele

public protocol ISettingsService {
    func getSettingsItems() -> [[SettingsItem]]
}

public class SettingsService: ISettingsService {
    public init() { }

    public func getSettingsItems() -> [[SettingsItem]] {
        [
            [
                SettingsItem(icon: UIImage(named: "share"), title: "Share with friends", isSwitch: false, isVersion: false)
            ],
            [
                SettingsItem(icon: UIImage(named: "ntf"), title: "Notification", isSwitch: true, isVersion: false),
                SettingsItem(icon: UIImage(named: "upgrade"), title: "Upgrade your plan", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "likeUs"), title: "Like us, Rate us", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "trash"), title: "Clear Cache", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "restore"), title: "Restore Purchases", isSwitch: false, isVersion: false)
            ],
            [
                SettingsItem(icon: UIImage(named: "contactUs"), title: "Contact us", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "policy"), title: "Policy Privacy", isSwitch: false, isVersion: false),
                SettingsItem(icon: UIImage(named: "policy"), title: "Terms of use", isSwitch: false, isVersion: false),
                SettingsItem(icon: nil, title: "", isSwitch: false, isVersion: true)
            ]
        ]
    }
}
