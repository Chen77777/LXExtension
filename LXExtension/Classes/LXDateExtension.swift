//
/**
*
*File name:		LXDateExtension.swift
*History:		yoctech create on 2021/7/30       
*Description:
	
*/


import Foundation

extension Date{
    
    /// 格式化字符串
    /// - Parameters:
    ///   - formart: 格式
    ///   - locale: 地区
    /// - Returns: 日期字符串
    func lx_toString(_ formart:String = "yyyy-MM-dd", locale: Locale = .current) -> String{
        let formartter = DateFormatter.init()
        formartter.locale = locale
        formartter.dateFormat = formart
        return formartter.string(from: self)
    }
    
    
    /// 日历
    var lx_calendar: Calendar {
        Calendar.current
    }
    
    
    /// 当月天数
    var lx_daysInMonth: Int {
        lx_calendar.range(of: .day, in: .month, for: self)!.count
    }
    /// 星期几
    var lx_weekday: Int {
        return lx_calendar.component(.weekday, from: self)
    }
    /// 几号
    var lx_day: Int {
        get {
            return lx_calendar.component(.day, from: self)
        }
        set {
            let allowedRange = lx_calendar.range(of: .day, in: .month, for: self)!
            guard allowedRange.contains(newValue) else { return }
            
            let currentDay = lx_calendar.component(.day, from: self)
            let daysToAdd = newValue - currentDay
            if let date = lx_calendar.date(byAdding: .day, value: daysToAdd, to: self) {
                self = date
            }
        }
    }

    
    /// 获取当前日期开头的日期
    /// - Parameter component: 开头的格式,年月日
    /// - Returns: 起始日期
    func beginning(of component: Calendar.Component) -> Date? {
        if component == .day {
            return lx_calendar.startOfDay(for: self)
        }
        
        var components: Set<Calendar.Component> {
            switch component {
            case .second:
                return [.year, .month, .day, .hour, .minute, .second]
                
            case .minute:
                return [.year, .month, .day, .hour, .minute]
                
            case .hour:
                return [.year, .month, .day, .hour]
                
            case .weekOfYear, .weekOfMonth:
                return [.yearForWeekOfYear, .weekOfYear]
                
            case .month:
                return [.year, .month]
                
            case .year:
                return [.year]
                
            default:
                return []
            }
        }
        
        guard !components.isEmpty else { return nil }
        return lx_calendar.date(from: lx_calendar.dateComponents(components, from: self))
    }
    
    mutating func add(_ component: Calendar.Component, value: Int) {
        if let date = lx_calendar.date(byAdding: component, value: value, to: self) {
            self = date
        }
    }
    
    /// 农历日期字符串
    /// - Parameter formatterString: 格式
    /// - Returns: 农历字符串
    func lx_toLunarString(_ formatterString:String = "yyyyMMdd") -> String {
        //初始化农历日历
        let lunarCalendar = Calendar.init(identifier: .chinese)
        //日期格式和输出
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "zh_CN")
        formatter.dateStyle = .medium
        formatter.calendar = lunarCalendar
        formatter.dateFormat = formatterString
        return formatter.string(from: self)
        
    }

}
