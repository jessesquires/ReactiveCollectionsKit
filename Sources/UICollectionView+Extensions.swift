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

extension UICollectionView {
    func _register(viewModel: CollectionViewModel) {
        viewModel.sections.forEach {
            self._register(sectionViewModel: $0)
        }
    }

    private func _register(sectionViewModel: SectionViewModel) {
        sectionViewModel.cellViewModels.forEach {
            $0.registerWith(collectionView: self)
        }
    }
}
