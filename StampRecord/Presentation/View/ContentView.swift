//
//  ContentView.swift
//  StampRecord
//
//  Created by Takuto Nakamura on 2023/10/14.
//

import SwiftUI

struct ContentView<SAM: StampRecordAppModel>: View {
    @EnvironmentObject private var appModel: SAM
    @State var isPhone: Bool = true
    @State var orientation: DeviceOrientation = .portrait

    var body: some View {
        TabView(selection: $appModel.tabSelection) {
            Group {
                StampsView(
                    viewModel: StampsViewModelImpl(appModel.stampRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    Label("stamps", image: "stamp.fill")
                }
                .tag(Tab.stamps)
                DayCalendarView(
                    viewModel: DayCalendarViewModelImpl(appModel.stampRepository, appModel.logRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    Label("day", image: "calendar.day")
                }
                .tag(Tab.dayCalendar)
                WeekCalendarView(
                    viewModel: WeekCalendarViewModelImpl(appModel.stampRepository, appModel.logRepository),
                    isPhone: isPhone
                )
                .tabItem {
                    if isPhone {
                        Label("week", image: "calendar.week.horizontal")
                    } else {
                        Label("week", image: "calendar.week.vertical")
                    }
                }
                .tag(Tab.weekCalendar)
                MonthCalendarView(
                    viewModel: MonthCalendarViewModelImpl(appModel.stampRepository, appModel.logRepository),
                    isPhone: isPhone,
                    orientation: orientation
                )
                .tabItem {
                    Label("month", systemImage: "calendar")
                }
                .tag(Tab.monthCalendar)
                SettingsView(viewModel: SettingsViewModelImpl())
                    .tabItem {
                        Label("settings", systemImage: "gearshape")
                    }
                    .tag(Tab.settings)
            }
            .toolbarBackground(Color.toolbarBackground, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .onJudgeDevice($isPhone)
        .onJudgeOrientation($orientation)
    }
}

#Preview {
    ContentView<PreviewMock.StampRecordAppModelMock>()
        .environmentObject(PreviewMock.StampRecordAppModelMock())
}
