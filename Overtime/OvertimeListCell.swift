//
//  OvertimeListCell.swift
//  Overtime
//
//  Created by Glenn Karlo Manguiat on 11/17/25.
//

import SwiftUI

struct OvertimeListCell: View {
    var entry: OvertimeEntry
    
    var body: some View {
        VStack(alignment:.leading, spacing: 8) {
            Text(entry.date, style: .date)
                .font(.caption)
                .foregroundColor(.blue.opacity(0.8))
            
            Text("Overtime: \(entry.overtimeHours, specifier: "%.2f") hrs (\(Int(entry.overtimeHours))h \(Int((entry.overtimeHours.truncatingRemainder(dividingBy: 1)) * 60))m)")
                .font(.body)
                .fontWeight(.light)
            
            HStack {
                Text("In: \(entry.timeIn.formatted(date: .omitted, time: .shortened))")
                Text("Out: \(entry.timeOut.formatted(date: .omitted, time: .shortened))")
            }
            .font(.caption2)
            .foregroundColor(.secondary)
            
            if entry.isOvernight {
                Label("Overnight Shift", systemImage: "moon.stars.fill")
                    .font(.caption2)
                    .foregroundColor(.orange)
            }
            if !entry.notes.isEmpty {
                Text(entry.notes)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    OvertimeListCell(entry: MockOvertimeEntry.mockEntry)
}
