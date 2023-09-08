/*
 View+Extensions.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

extension View {
    func wrapText(
        maxKey: String,
        key: String
    ) -> some View {
        return Text(maxKey)
            .hidden()
            .overlay(alignment: .center) {
                Text(key)
            }
            .fixedSize()
    }

    func onRotate(_ orientation: Binding<UIDeviceOrientation>) -> some View {
        return modifier(DetectOrientation(orientation: orientation))
    }
}
