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
            VStack(alignment: .leading, spacing: 8) {
                let currentYear = Calendar.current.component(.year, from: Date())
                let annualEntries = viewModel.entries.filter {
                    Calendar.current.component(.year, from: $0.date) == currentYear
                }
                let annualTotal = viewModel.totalOvertime(for: annualEntries)
                
                HStack {
                    Text("Annual Total: \(annualTotal, specifier: "%.2f") hrs (\(Int(annualTotal))h \(Int((annualTotal.truncatingRemainder(dividingBy: 1)) * 60))m)")
                        .font(.footnote)
                        .fontWeight(.medium)
                        .foregroundColor(.blue)
                    Spacer()
                }
                .padding(.leading, 24)
                
                List {
                    ForEach(viewModel.monthlyGroupedEntries(), id: \.month) { group in
                        Section(header: Text(group.month)
                            .font(.caption)
                            .padding(.bottom, 4)) {
                                ForEach(group.entries) { entry in
                                    OvertimeListCell(entry: entry)
                                }
                                .onDelete { indexSet in
                                    let entriesToDelete = indexSet.map { group.entries[$0] }
                                    viewModel.deleteEntry(entriesToDelete)
                                }
                                .listRowSeparatorTint(.blue, edges: .bottom)
                                
                                HStack {
                                    Spacer()
                                    Text("Total: \(viewModel.totalOvertime(for: group.entries), specifier: "%.2f") hrs (\(Int(viewModel.totalOvertime(for: group.entries)))h \(Int((viewModel.totalOvertime(for: group.entries).truncatingRemainder(dividingBy: 1)) * 60))m)")
                                        .font(.footnote)
                                        .fontWeight(.bold)
                                        .foregroundColor(.black)
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
    }
}

#Preview {
    OvertimeListView()
}
