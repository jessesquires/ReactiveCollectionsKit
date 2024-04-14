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

final class ColorViewController: UIViewController {
    let color: ColorModel

    let label = UILabel()

    init(color: ColorModel) {
        self.color = color
        super.init(nibName: nil, bundle: nil)
        self.title = "Color"
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        self.label.font = UIFont.preferredFont(forTextStyle: .title1)
        self.label.textAlignment = .center
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.label)
        let size = 200.0
        NSLayoutConstraint.activate([
            self.label.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.label.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.label.widthAnchor.constraint(equalToConstant: size),
            self.label.heightAnchor.constraint(equalToConstant: size)
        ])

        self.label.text = self.color.name
        self.label.backgroundColor = self.color.uiColor
    }
}
