/*
 DayView.swift
 StampCal

 Created by Takuto Nakamura on 2023/09/06.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct DayView: View {
    let shortWeekdays: [String]
    let day: Day

    var body: some View {
        VStack(spacing: 24) {
            Text(shortWeekdays[day.weekday])
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .foregroundColor(SCColor.weekday(day.weekday))
                .background(SCColor.cellHighlightWeek)
                .cornerRadius(8)
                .shadow(color: SCColor.shadow, radius: 3, x: 0, y: 3)
            VStack {
                Text(day.text)
                    .foregroundColor(SCColor.weekday(day.weekday, day.isToday))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(SCColor.highlight(day.isToday))
                Text("😃")
                    .font(.title)
                    .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(SCColor.cellBackground)
            .cornerRadius(8)
            .shadow(color: SCColor.shadow, radius: 3, x: 0, y: 3)
        }
        .padding(24)
    }
}

struct DayView_Previews: PreviewProvider {
    static var previews: some View {
        DayView(shortWeekdays: [], day: Day(text: "", weekday: 0))
    }
}
