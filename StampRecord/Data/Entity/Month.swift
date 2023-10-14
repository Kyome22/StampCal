/*
 Month.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Month: Hashable, Identifiable {
    var id = UUID()
    var title: String
    var days: [Day]

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
