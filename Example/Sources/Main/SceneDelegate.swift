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

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = scene as? UIWindowScene else { return }

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

        let tabBar = UITabBarController()
        tabBar.viewControllers = [
            UINavigationController(rootViewController: grid),
            UINavigationController(rootViewController: list),
            UINavigationController(rootViewController: simple),
            UINavigationController(rootViewController: flow)
        ]

        self.window = .init(windowScene: scene)
        self.window?.rootViewController = tabBar
        self.window?.makeKeyAndVisible()
    }
}
