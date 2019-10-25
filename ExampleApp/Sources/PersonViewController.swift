//
//  Created by Jesse Squires
//  https://www.jessesquires.com
//
//
//  Documentation
//  https://jessesquires.github.io/DiffableCollectionsKit
//
//
//  GitHub
//  https://github.com/jessesquires/DiffableCollectionsKit
//
//
//  License
//  Copyright © 2019-present Jesse Squires
//  Released under an MIT license: https://opensource.org/licenses/MIT
//

import UIKit

final class PersonViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var flagLabel: UILabel!

    let person: Person

    init(person: Person) {
        self.person = person
        super.init(nibName: "\(PersonViewController.self)", bundle: nil)
        self.title = "Person"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = self.person.name
        self.subtitleLabel.text = self.person.birthDateText
        self.flagLabel.text = self.person.nationality
    }
}
