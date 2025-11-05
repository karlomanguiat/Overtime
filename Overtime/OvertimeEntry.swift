//
//  OvertimeEntry.swift
//  Overtime
//
//  Created by Glenn Karlo Manguiat on 11/5/25.
//

import Foundation

struct OvertimeEntry: Identifiable, Codable {
    let id: UUID
    var date: Date
    var timeIn: Date
    var timeOut: Date
    var notes: String = ""
    
    var overtimeHours: Double {
        let calendar = Calendar.current
            
        // Use timeIn’s calendar day as reference for work schedule
        guard let startOfWork = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: timeIn),
              let endOfWork = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: timeIn)
        else { return 0 }

        var adjustedTimeOut = timeOut
        
        // ✅ Handle overnight shifts (e.g. 10PM → 6AM next day)
        if adjustedTimeOut < timeIn {
            adjustedTimeOut = calendar.date(byAdding: .day, value: 1, to: adjustedTimeOut) ?? adjustedTimeOut
        }

        // Early time-in (before 9AM)
        let earlySeconds = timeIn < startOfWork
            ? startOfWork.timeIntervalSince(timeIn)
            : 0

        // Late time-out (after 5PM)
        let lateSeconds = adjustedTimeOut > endOfWork
            ? adjustedTimeOut.timeIntervalSince(endOfWork)
            : 0

        // Total overtime (seconds → hours)
        let totalSeconds = earlySeconds + lateSeconds
        let totalHours = totalSeconds / 3600.0
        
        // Rounded to 2 decimal places
        return (totalHours * 100).rounded() / 100
        
    }
    
    init(id: UUID = UUID(), date: Date, timeIn: Date, timeOut: Date, notes: String) {
        self.id = id
        self.date = date
        self.timeIn = timeIn
        self.timeOut = timeOut
        self.notes = notes
    }
    
    var isOvernight: Bool {
        // True if timeOut is earlier than timeIn (meaning shift crossed midnight)
        timeOut < timeIn
    }
}
