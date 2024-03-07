/*
 Dummy.swift
 StampRecord

 Created by Takuto Nakamura on 2023/12/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

enum Dummy {
    static let startDay: Date = {
        let components = DateComponents(year: 2023, month: 11, day: 1)
        return Calendar.current.date(from: components)!
    }()

    static let today: Date = {
        let components = DateComponents(year: 2023, month: 11, day: 16)
        return Calendar.current.date(from: components)!
    }()

    static let stamps: [Stamp] = {
        let today = Self.startDay
        let info: [(emoji: String, summary: String)] = [
            ("💪", String(localized: "dummyTraining")),
            ("📝", String(localized: "dummyStudy")),
            ("🧽", String(localized: "dummyDishWashing")),
            ("🏃", String(localized: "dummyRunning")),
            ("🧺", String(localized: "dummyLaundry")),
            ("🎤", String(localized: "dummySinging")),
            ("🧹", String(localized: "dummyCleaning"))
        ]
        return info.enumerated().map { (offset, element) in
            let date = Calendar.current.date(byAdding: .day, value: offset, to: today)!
            return Stamp(emoji: element.emoji, summary: element.summary, createdDate: date)
        }
    }()

    static let logs: [Log] = {
        let today = Self.startDay
        let stamps = Self.stamps
        let info: [[Int]] = [
            [0, 1, 4],
            [1],
            [1, 2],
            [3, 5],
            [4, 6],
            [1],
            [0, 2, 5],
            [1],
            [0, 1],
            [1, 2],
            [3, 6],
            [0, 4, 5],
            [1, 6],
            [2],
            [],
            [0, 1, 5]
        ]
        return info.enumerated().map { (offset, element) in
            let date = Calendar.current.date(byAdding: .day, value: offset, to: today)!
            return Log(date: date, stamps: element.map({ LoggedStamp(stamp: stamps[$0]) }))
        }
    }()
}
