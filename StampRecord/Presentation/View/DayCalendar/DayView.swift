/*
 DayView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayView: View {
    @State var showErrorAlert: Bool = false
    @State var srError: SRError? = nil
    let columns: [GridItem]
    let summaryFont: Font
    let day: Day
    let removeStampHandler: (Day, LoggedStamp) throws -> Void

    init(
        device: Device,
        day: Day,
        removeStampHandler: @escaping (Day, LoggedStamp) throws -> Void
    ) {
        columns = Array(
            repeating: .init(.flexible(), spacing: 8),
            count: device.columnCount
        )
        summaryFont = device.summaryFont
        self.day = day
        self.removeStampHandler = removeStampHandler
    }

    var body: some View {
        VStack(spacing: 16) {
            Text(day.weekday.shortLabel)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundStyle(Color.weekday(day.weekday))
                .background(Color.cellBackground)
                .cornerRadius(8)
                .shadow(color: Color.shadow, radius: 3, x: 0, y: 3)
            VStack(spacing: 0) {
                Text(day.text)
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding(4)
                    .foregroundStyle(Color.weekday(day.weekday, day.isToday))
                    .background {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color.highlight(day.isToday))
                    }
                    .padding(4)
                Divider()
                    .overlay(Color.cellBorder)
                    .padding(.horizontal, 8)
                ScrollView(.vertical, showsIndicators: false) {
                    if let log = day.log {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(log.stamps) { stamp in
                                if stamp.isIncluded {
                                    stampCardView(stamp: stamp) {
                                        try removeStampHandler(day, stamp)
                                    }
                                }
                            }
                        }
                        .padding(8)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(Color.cellBackground)
            .cornerRadius(8)
            .shadow(color: Color.shadow, radius: 3, x: 0, y: 3)
        }
        .padding(16)
    }

    func stampCardView(
        stamp: LoggedStamp,
        removeStampHandler: @escaping () throws -> Void
    ) -> some View {
        VStack(spacing: 4) {
            Text(stamp.emoji)
                .font(.system(size: 100))
                .minimumScaleFactor(0.01)
                .accessibilityIdentifier("DayView_StampCard_\(stamp.summary)")
            Text(stamp.summary)
                .font(summaryFont)
                .lineLimit(1)
                .minimumScaleFactor(0.05)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .padding(8)
        .containerShape(RoundedRectangle(cornerRadius: 8))
        .contextMenu {
            Button(role: .destructive) {
                do {
                    try removeStampHandler()
                } catch let error as SRError {
                    srError = error
                    showErrorAlert = true
                } catch {}
            } label: {
                Label {
                    Text("remove")
                } icon: {
                    Image(.stampFillMinus)
                }
            }
            .accessibilityIdentifier("DayView_RemoveButton_\(stamp.summary)")
        }
        .alert(
            srError?.title ?? "",
            isPresented: $showErrorAlert,
            presenting: srError,
            actions: { _ in },
            message: { error in
                Text(error.errorDescription ?? "")
            }
        )
    }
}

#Preview {
    DayView(device: .default,
            day: Day(text: "", weekday: .sunday),
            removeStampHandler: { _, _ in })
}
