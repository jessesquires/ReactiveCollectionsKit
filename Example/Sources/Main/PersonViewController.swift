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

final class PersonViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var flagLabel: UILabel!

    let person: PersonModel

    init(person: PersonModel) {
        self.person = person
        super.init(nibName: "\(PersonViewController.self)", bundle: nil)
        self.title = "Person"
    }

    @available(*, unavailable)
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
