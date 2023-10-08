/*
 WeekCalendarViewModel.swift
 StampCal

 Created by Takuto Nakamura on 2023/08/27.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import Foundation

protocol WeekCalendarViewModel: ObservableObject {
    associatedtype SR: StampRepository
    associatedtype LR: LogRepository

    var title: String { get set }
    var weekList: [Week] { get set }
    var selectedDayID: UUID? { get set }
    var showStampPicker: Bool { get set }
    var shortWeekdays: [String] { get }

    init(_ stampRepository: SR, _ logRepository: LR)

    func setWeekList()
    func reloadLog()
    func paging(with pageDirection: PageDirection)
    func putStamp(stamp: Stamp)
    func removeStamp(day: Day, index: Int)
}

final class WeekCalendarViewModelImpl<SR: StampRepository,
                                      LR: LogRepository>: WeekCalendarViewModel {
    typealias SR = SR
    typealias LR = LR

    @Published var title: String = ""
    @Published var weekList: [Week] = []
    @Published var selectedDayID: UUID? = nil
    @Published var showStampPicker: Bool = false

    let shortWeekdays: [String]
    private let calendar = Calendar.current
    private let stampRepository: SR
    private let logRepository: LR
    private var notFirstOnAppear: Bool = false

    init(_ stampRepository: SR, _ logRepository: LR) {
        shortWeekdays = calendar.shortWeekdaySymbols
        self.stampRepository = stampRepository
        self.logRepository = logRepository
        setWeekList()
    }

    private func getPreviousWeek(of date: Date) -> Date? {
        if let endOfWeek = calendar.endOfWeek(for: date),
           let previousDate = calendar.date(byAdding: .day, value: -7, to: endOfWeek) {
            return previousDate
        }
        return nil
    }

    private func getNextWeek(of date: Date) -> Date? {
        if let endOfWeek = calendar.endOfWeek(for: date),
           let nextDate = calendar.date(byAdding: .day, value: 7, to: endOfWeek) {
            return nextDate
        }
        return nil
    }

    private func getDays(of targetDate: Date) -> [Day] {
        let now = Date.now
        var days = [Day]()
        if let daysInMonth = calendar.daysInMonth(for: targetDate),
           let startOfMonth = calendar.startOfMonth(for: targetDate) {
            let day = calendar.component(.day, from: targetDate)
            let weekday = calendar.component(.weekday, from: targetDate)
            days = (day - weekday ..< day + 7 - weekday).map { i in
                let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                return Day(date: date,
                           inMonth: (0 ..< daysInMonth).contains(i),
                           isToday: calendar.isEqual(a: date, b: now),
                           text: calendar.dayText(of: date),
                           weekday: calendar.weekday(of: date),
                           log: logRepository.getLog(of: date))
            }
        }
        return days
    }

    func setWeekList() {
        weekList.removeAll()
        let now = Date.now
        weekList.append(Week(title: now.title, days: getDays(of: now)))
        if let date = getPreviousWeek(of: now) {
            weekList.insert(Week(title: date.title, days: getDays(of: date)), at: 0)
        }
        if let date = getNextWeek(of: now) {
            weekList.append(Week(title: date.title, days: getDays(of: date)))
        }
        title = weekList[1].title
        selectedDayID = nil
    }

    func reloadLog() {
        if notFirstOnAppear {
            weekList.indices.forEach { i in
                weekList[i].days.indices.forEach { j in
                    weekList[i].days[j].log = logRepository.getLog(of: weekList[i].days[j].date)
                }
            }
        } else {
            notFirstOnAppear = true
        }
    }

    func paging(with pageDirection: PageDirection) {
        switch pageDirection {
        case .backward:
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let date = getPreviousWeek(of: baseDate) {
                weekList.insert(Week(title: date.title, days: getDays(of: date)), at: 0)
                weekList.removeLast()
            }
        case .forward:
            if let baseDate = weekList[pageDirection.baseIndex].days.first?.date,
               let date = getNextWeek(of: baseDate) {
                weekList.append(Week(title: date.title, days: getDays(of: date)))
                weekList.removeFirst()
            }
        }
        title = weekList[1].title
        selectedDayID = nil
    }

    func putStamp(stamp: Stamp) {
        guard let i = weekList.firstIndex(where: { $0.days.contains { $0.id == selectedDayID } }),
              let j = weekList[i].days.firstIndex(where: { $0.id == selectedDayID }) else {
            return
        }
        let day = weekList[i].days[j]
        if var log = day.log {
            log.stamps.append(stamp)
            logRepository.updateLog(log)
        } else if let date = day.date {
            let log = Log(date: date, stamps: [stamp])
            logRepository.updateLog(log)
        }
        weekList[i].days[j].log = logRepository.getLog(of: day.date)
    }

    func removeStamp(day: Day, index: Int) {
        if var log = day.log {
            log.stamps.remove(at: index)
            logRepository.updateLog(log)
        }
        if let i = weekList.firstIndex(where: { $0.days.contains(day) }),
           let j = weekList[i].days.firstIndex(of: day) {
            weekList[i].days[j].log = logRepository.getLog(of: day.date)
        }
    }
}

// MARK: - Preview Mock
extension PreviewMock {
    final class WeekCalendarViewModelMock: WeekCalendarViewModel {
        typealias SR = StampRepositoryMock
        typealias LR = LogRepositoryMock

        @Published var title: String = ""
        @Published var weekList: [Week] = []
        @Published var selectedDayID: UUID? = nil
        @Published var showStampPicker: Bool = false

        let shortWeekdays: [String]

        init(_ stampRepository: SR, _ logRepository: LR) {
            shortWeekdays = []
        }

        init() {
            let calendar = Calendar.current
            shortWeekdays = calendar.shortWeekdaySymbols
            let now = Date.now
            if let startOfMonth = calendar.startOfMonth(for: now) {
                let days = (0 ..< 7).map { i in
                    let date = calendar.date(byAdding: .day, value: i, to: startOfMonth)
                    return Day(date: date,
                               inMonth: true,
                               isToday: calendar.isEqual(a: date, b: now),
                               text: calendar.dayText(of: date),
                               weekday: calendar.weekday(of: date))
                }
                let week = Week(title: now.title, days: days)
                weekList.append(week)
                title = now.title
            }
        }

        func setWeekList() {}
        func reloadLog() {}
        func paging(with pageDirection: PageDirection) {}
        func putStamp(stamp: Stamp) {}
        func removeStamp(day: Day, index: Int) {}
    }
}
