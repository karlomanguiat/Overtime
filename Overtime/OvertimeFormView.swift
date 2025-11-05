//
//  OvertimeFormView.swift
//  Overtime
//
//  Created by Glenn Karlo Manguiat on 11/5/25.
//

import SwiftUI

struct OvertimeFormView: View {
    @ObservedObject var viewModel: OvertimeViewModel
        
    @State private var date = Date()
    @State private var timeIn = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State private var timeOut = Calendar.current.date(bySettingHour: 17, minute: 0, second: 0, of: Date())!
    @State private var notes: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                DatePicker("Date", selection: $date, displayedComponents: .date)
                DatePicker("Time In", selection: $timeIn, displayedComponents: .hourAndMinute)
                DatePicker("Time Out", selection: $timeOut, displayedComponents: .hourAndMinute)
                TextField("Notes (optional)", text: $notes)
            }
            .navigationTitle("Add Overtime")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        viewModel.addEntry(date: date, timeIn: timeIn, timeOut: timeOut, notes: notes)
                        dismiss()
                    }
                    .disabled(timeOut <= timeIn)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", action: { dismiss() })
                }
            }
        }
    }
}

#Preview {
    OvertimeFormView(viewModel: OvertimeViewModel())
}
