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

struct PersonModel: Equatable, Hashable {
    let name: String
    let birthdate: Date
    let nationality: String

    var birthDateText: String {
        _formatter.string(from: self.birthdate)
    }
}

private let _formatter: DateFormatter = {
    let fm = DateFormatter()
    fm.dateStyle = .long
    fm.timeStyle = .none
    return fm
}()

extension Date {
    init(year: Int, month: Int, day: Int) {
        let components = DateComponents(calendar: .current,
                                        timeZone: .current,
                                        year: year,
                                        month: month,
                                        day: day)
        self = components.date!
    }
}

extension PersonModel {
    static func makePeople() -> [PersonModel] {
        [
            PersonModel(name: "Noam Chomsky", birthdate: Date(year: 1_928, month: 12, day: 7), nationality: "🇺🇸"),
            PersonModel(name: "Emma Goldman", birthdate: Date(year: 1_869, month: 6, day: 27), nationality: "🇷🇺"),
            PersonModel(name: "Mikhail Bakunin", birthdate: Date(year: 1_814, month: 5, day: 30), nationality: "🇷🇺"),
            PersonModel(name: "Ursula K. Le Guin", birthdate: Date(year: 1_929, month: 10, day: 21), nationality: "🇺🇸"),
            PersonModel(name: "Peter Kropotkin", birthdate: Date(year: 1_842, month: 12, day: 9), nationality: "🇷🇺"),
            PersonModel(name: "Marie Louise Berneri", birthdate: Date(year: 1_918, month: 3, day: 1), nationality: "🇮🇹")
        ]
    }
}
