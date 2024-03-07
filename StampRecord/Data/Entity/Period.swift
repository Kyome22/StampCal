/*
 Period.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

enum Period: Int, Identifiable, CaseIterable {
    case day
    case week
    case month

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .day:   return String(localized: "day")
        case .week:  return String(localized: "week")
        case .month: return String(localized: "month")
        }
    }

    var tab: Tab {
        switch self {
        case .day:   return .dayCalendar
        case .week:  return .weekCalendar
        case .month: return .monthCalendar
        }
    }
}
