/*
 MainView.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI

struct MainView: View {
    @State var isPhone: Bool = true

    var body: some View {
        TabView {
            Group {
                StampsView()
                    .tabItem {
                        Label("stamps", image: "stamp")
                    }
                DayCalendarView()
                    .tabItem {
                        Label("day", image: "calendar.day")
                    }
                WeekCalendarView(isPhone: $isPhone)
                    .tabItem {
                        if isPhone {
                            Label("week", image: "calendar.week.horizontal")
                        } else {
                            Label("week", image: "calendar.week.vertical")
                        }
                    }
                MonthCalendarView()
                    .tabItem {
                        Label("month", systemImage: "calendar")
                    }
                Text("Hello")
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
            }
            .toolbarBackground(SCColor.toolbarBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onAppear {
            judgeDevice()
        }
    }

    func judgeDevice() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            isPhone = false
        }
    }
}
