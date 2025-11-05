//
//  OvertimeViewModel.swift
//  Overtime
//
//  Created by Glenn Karlo Manguiat on 11/5/25.
//

import Foundation


class OvertimeViewModel: ObservableObject {
    @Published var entries: [OvertimeEntry] = [] {
        didSet {
            saveEntries()
        }
    }
    
    private let defaultsKey = "OvertimeEntries"
    
    init() {
        loadEntries()
    }
    
    func addEntry(date: Date, timeIn: Date, timeOut: Date, notes: String) {
        // Check if an entry already exists for the same day
        if let index = entries.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: date) }) {
            // Update existing entry
            entries[index].timeIn = timeIn
            entries[index].timeOut = timeOut
            entries[index].notes = notes
        } else {
            // Add new entry
            let newEntry = OvertimeEntry(date: date, timeIn: timeIn, timeOut: timeOut, notes: notes)
            entries.append(newEntry)
        }
        sortEntries()
    }
    
    func removeEntry(_ entry: OvertimeEntry) {
            entries.removeAll { $0.id == entry.id }
        }
    
    func monthlyGroupedEntries() -> [(month: String, entries: [OvertimeEntry])] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let grouped = Dictionary(grouping: entries) { entry in
            formatter.string(from: entry.date)
        }
        
        return grouped
            .map { (month: $0.key, entries: $0.value.sorted { $0.date > $1.date }) }
            .sorted { $0.month > $1.month }
    }
    
    func totalOvertime(for monthEntries: [OvertimeEntry]) -> Double {
       monthEntries.reduce(0) { $0 + $1.overtimeHours }
    }
       
    private func sortEntries() {
       entries.sort { $0.date > $1.date }
    }
    
    private func saveEntries() {
        let data = try? JSONEncoder().encode(entries)
        UserDefaults.standard.set(data, forKey: defaultsKey)
    }
    
    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else { return }
        guard let encodedEntries = try? JSONDecoder().decode([OvertimeEntry].self, from: data) else { return }
        
        self.entries = encodedEntries
    }
}
