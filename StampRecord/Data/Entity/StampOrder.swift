/*
 StampOrder.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

enum StampOrderBy: String, Identifiable, CaseIterable {
    case createdDate
    case summary

    var id: String { rawValue }

    var label: String {
        switch self {
        case .createdDate:
            return String(localized: "createdDate")
        case .summary:
            return String(localized: "summary")
        }
    }

    var image: Image {
        switch self {
        case .createdDate:
            return Image(.clockBadgePlus)
        case .summary:
            return Image(systemName: "abc")
        }
    }
}

enum StampOrderIn: String, Identifiable, CaseIterable {
    case ascending
    case descending

    var id: String { rawValue }

    var label: String {
        switch self {
        case .ascending:
            return String(localized: "ascending")
        case .descending:
            return String(localized: "descending")
        }
    }

    var image: Image {
        switch self {
        case .ascending:
            return Image(systemName: "text.line.first.and.arrowtriangle.forward")
        case .descending:
            return Image(systemName: "text.line.last.and.arrowtriangle.forward")
        }
    }
}
