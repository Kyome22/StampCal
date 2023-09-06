/*
 Array+Extensions.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

struct Chunk<Element>: Identifiable {
    var id = UUID()
    var elements: [Element]
}

extension Array {
    func chunked(by chunkSize: Int) -> [Chunk<Element>] {
        return stride(from: 0, to: count, by: chunkSize).map {
            Chunk(elements: Array(self[$0 ..< Swift.min($0 + chunkSize, count)]))
        }
    }
}