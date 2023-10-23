/*
 Month.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation
import InfinitePaging

struct Month: Pageable {
    var id = UUID()
    var title: String
    var days: [Day]
}
