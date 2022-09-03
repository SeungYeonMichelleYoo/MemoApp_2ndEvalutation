//
//  Date + Extension.swift
//  MemoApp
//
//  Created by SeungYeon Yoo on 2022/09/02.
//

import UIKit

extension UIViewController {
    
    //MARK: - 로직(오늘/ 이번주/ 그 외 날짜)
    func getDateFormat(memodate: Date) -> String {
        if memodate.isInSameDay(as: Date()) {
            return getTodayDate()
        } else if memodate.isInSameWeek(as: Date()) {
            return thisweekDate(memodate: memodate)
        } else {
            return otherDate(memodate: memodate)
        }
    }
    
    //MARK: - 오늘 날짜 표현
    func getTodayDate() -> String {
        return getFormatter(format: "a HH:mm").string(from: Date())
    }
    
    //MARK: - 이번주 작성한 메모
    func thisweekDate(memodate: Date) -> String {
        return getFormatter(format: "EEEE").string(from: memodate)
    }
    
    //MARK: - 그 외의 기간에 작성한 메모
    func otherDate(memodate: Date) -> String {
        return getFormatter(format: "yyyy.MM.dd a HH:mm").string(from: memodate)
    }
    
    func getFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = format
        return formatter
    }
}

extension Date {
    func isEqual(to date: Date, toGranularity component: Calendar.Component, in calendar: Calendar = .current) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: component)
    }
    func isInSameWeek(as date: Date) -> Bool { isEqual(to: date, toGranularity: .weekOfYear) }
    
    func isInSameDay(as date: Date) -> Bool { Calendar.current.isDate(self, inSameDayAs: date) }
}
