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

import Foundation
import ReactiveCollectionsKit
import UIKit

final class FavoriteBadgeView: UICollectionReusableView {
    let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.imageView)
        let inset = 4.0
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: inset),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -inset),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: inset),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -inset)
        ])
        self.imageView.image = UIImage(systemName: "star.fill")
        self.imageView.tintColor = .systemBackground
        self.backgroundColor = .systemRed
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = self.bounds.height / 2
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct FavoriteBadgeViewModel: SupplementaryViewModel {
    static let kind = "favorite-badge-view"

    let isHidden: Bool

    let id: UniqueIdentifier

    var kind: SupplementaryViewKind { Self.kind }

    func configure(view: FavoriteBadgeView) {
        view.isHidden = self.isHidden
    }
}
