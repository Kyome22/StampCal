/*
 StampFilterState.swift
 StampRecord

 Created by Takuto Nakamura on 2023/11/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum StampFilterState {
    case allSelected(Int)
    case someSelected(Int)
    case notSelected

    var imageName: String {
        switch self {
        case .allSelected(_):
            return "checkmark.square.fill"
        case .someSelected(_):
            return "minus.square.fill"
        case .notSelected:
            return "square.fill"
        }
    }

    var imageColor: Color {
        if case .allSelected(_) = self {
            return Color.accentColor
        } else {
            return Color.disabled
        }
    }

    var label: String {
        switch self {
        case .allSelected(let count):
            return String(localized: "\(count) selected")
        case .someSelected(let count):
            return String(localized: "\(count) selected")
        case .notSelected:
            return String(localized: "selectAll")
        }
    }

    var expectedValue: Bool {
        if case .allSelected(_) = self {
            return false
        } else {
            return true
        }
    }

    init(stamps: [Stamp]) {
        switch stamps.filter({ $0.isIncluded }).count {
        case 0:
            self = .notSelected
        case stamps.count:
            self = .allSelected(stamps.count)
        case let count:
            self = .someSelected(count)
        }
    }
}
