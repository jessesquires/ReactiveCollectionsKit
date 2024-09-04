//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//  Documentation
//  https://jessesquires.github.io/ReactiveCollectionsKit
//
//  GitHub
//  https://github.com/jessesquires/ReactiveCollectionsKit
//
//  Copyright © 2019-present Jesse Squires
//

import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(
        _ application: UIApplication,
        // swiftlint:disable:next discouraged_optional_collection
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let grid = GridViewController()
        grid.title = "Grid"
        grid.tabBarItem.image = UIImage(systemName: "square.grid.2x2.fill")

        let list = ListViewController()
        list.title = "List"
        list.tabBarItem.image = UIImage(systemName: "list.dash")

        let simple = SimpleStaticViewController()
        simple.title = "Simple Static"
        simple.tabBarItem.image = UIImage(systemName: "list.bullet.rectangle.portrait.fill")

        let flow = SimpleFlowLayoutViewController()
        flow.title = "Flow Layout"
        flow.tabBarItem.image = UIImage(systemName: "square.grid.3x3.square")

        let browser = FileBrowserViewController()
        browser.title = "File Browser"
        browser.tabBarItem.image = UIImage(systemName: "folder.fill")

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            UINavigationController(rootViewController: grid),
            UINavigationController(rootViewController: list),
            UINavigationController(rootViewController: simple),
            UINavigationController(rootViewController: flow),
            UINavigationController(rootViewController: browser)
        ]

        self.window = UIWindow()
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
        return true
    }
}
