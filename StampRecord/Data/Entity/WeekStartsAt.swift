/*
 WeekStartsAt.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/12.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

enum WeekStartsAt: Int, CaseIterable, Identifiable {
    case sunday = 7
    case monday = 8

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .sunday: return String(localized: "sunday")
        case .monday: return String(localized: "monday")
        }
    }

    var weekdays: [Weekday] {
        switch self {
        case .sunday: return Weekday.allCasesFromSunday
        case .monday: return Weekday.allCasesFromMonday
        }
    }

    var ref: Int { rawValue }
}
