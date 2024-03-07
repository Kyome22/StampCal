/*
 View+Extension.swift
 StampRecord

 Created by Takuto Nakamura on 2023/08/28.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

extension View {
    func wrapText(maxKey: String, key: String) -> some View {
        return Text(maxKey)
            .hidden()
            .overlay(alignment: .center) {
                Text(key)
            }
            .fixedSize()
    }

    func onJudgeDevice(_ device: Binding<Device>) -> some View {
        return modifier(JudgeDeviceModifier(device: device))
    }

    func backable() -> some View {
        return modifier(BackableModifier())
    }

    func onChangeWithMigration<V>(
        of value: V,
        _ action: @escaping () -> Void
    ) -> some View where V: Equatable {
        Group {
            if #available(iOS 17, *) {
                onChange(of: value) { _, _ in action() }
            } else {
                onChange(of: value) { _ in action() }
            }
        }
    }
}
