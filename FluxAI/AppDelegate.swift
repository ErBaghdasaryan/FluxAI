//
//  AppDelegate.swift
//  FluxAI
//
//  Created by Er Baghdasaryan on 27.02.25.
//

import UIKit
import ApphudSDK
import FluxAIViewModel
import AppTrackingTransparency
import AdSupport

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let appStorageService = AppStorageService()
    let networkService = NetworkService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        Apphud.start(apiKey: "app_7fiytz1WbZTn3kAob2rbNLR72ar5du")
        Apphud.enableDebugLogs()
        Apphud.setDeviceIdentifiers(idfa: nil, idfv: UIDevice.current.identifierForVendor?.uuidString)
        fetchIDFA()

        let appHudUserId = Apphud.userID()
        self.appStorageService.saveData(key: .apphudUserID, value: appHudUserId)

        let bundle = Bundle.main.bundleIdentifier ?? ""

        if !appStorageService.hasData(for: .skipOnboarding) {
            self.login(userId: appHudUserId,
                       gender: "m",
                       source: bundle)
        }

        return true
    }

    func fetchIDFA() {
        if #available(iOS 14.5, *) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    guard status == .authorized else { return }
                    let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
                    Apphud.setDeviceIdentifiers(idfa: idfa, idfv: UIDevice.current.identifierForVendor?.uuidString)
                }
            }
        }
    }

    func login(userId: String, gender: String, source: String) {
        Task {
            do {
                let response = try await networkService.login(userId: userId,
                                                              gender: gender,
                                                              source: source)
                print(response)
                print("###SUCCESS###")
            } catch {
                print("###ERROR###")
            }
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

