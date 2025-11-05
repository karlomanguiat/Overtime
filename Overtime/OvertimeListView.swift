//
//  ContentView.swift
//  Overtime
//
//  Created by Glenn Karlo Manguiat on 11/5/25.
//

import SwiftUI

struct OvertimeListView: View {
    @StateObject private var viewModel = OvertimeViewModel()
    @State private var showAddView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.monthlyGroupedEntries(), id: \.month) { group in
                    Section(header: Text(group.month)
                        .font(.caption)
                        .padding(.bottom, 4)) {
                        ForEach(group.entries) { entry in
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
                        .onDelete { indexSet in
                            deleteItems(in: group, at: indexSet)
                        }
                        .listRowSeparatorTint(.blue, edges: .bottom)
                        // ✅ Monthly total
    
                        HStack {
                            Spacer()
                            Text("Total: \(viewModel.totalOvertime(for: group.entries), specifier: "%.2f") hrs (\(Int(viewModel.totalOvertime(for: group.entries)))h \(Int((viewModel.totalOvertime(for: group.entries).truncatingRemainder(dividingBy: 1)) * 60))m)")
                                .font(.footnote)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Overtime Checker")
            .toolbar {
                Button(action: { showAddView = true }) {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showAddView) {
                OvertimeFormView(viewModel: viewModel)
            }
        }
    }
    
    private func deleteItems(in group: (month: String, entries: [OvertimeEntry]), at offsets: IndexSet) {
       let entriesToDelete = offsets.map { group.entries[$0] }
       for entry in entriesToDelete {
           viewModel.removeEntry(entry)
       }
   }
}

#Preview {
    OvertimeListView()
}
