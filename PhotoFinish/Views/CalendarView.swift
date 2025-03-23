//
//  CalendarView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import SwiftUI
import FirebaseStorage
import FirebaseFirestore

struct CalendarView: View {
    let monthDate: Date
    @State private var imagesByDate: [Date: UIImage] = [:]
    @State private var isLoading = true

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if isLoading {
                LoadingScreen()
            } else {
                let days = generateMonthDays(for: monthDate, imagesByDate: imagesByDate)
                VStack {
                    Text("PhotoFinish")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [
                                    Color.blue,
                                    Color.cyan
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                    
                    Text(monthTitle(from: monthDate))
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 60)
                        .foregroundStyle(.white)
                    
                    HStack(spacing: 0) {
                        ForEach(weekdaySymbols, id: \.self) { symbol in
                            Text(symbol)
                                .font(.headline)
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 8)
                    
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(days) { day in
                            DayCell(day: day)
                        }
                    }
                    Spacer()
                    .padding()
                }
            }
        }
        .onAppear {
            fetchAllImagesForMonth()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                self.isLoading = false
            }
        }
    }

    // MARK: - Fetch All Images for This Month
    private func fetchAllImagesForMonth() {
        // We'll do one big fetch. Adjust if you only want to fetch specific dates.
        let imagesRef = Storage.storage().reference().child("images")
        
        imagesRef.listAll { (result, error) in
            if let error = error {
                print("Error listing files: \(error)")
                self.isLoading = false
                return
            }
            guard let items = result?.items else {
                self.isLoading = false
                return
            }
            
            // We'll use a dispatch group to wait for all downloads
            let dispatchGroup = DispatchGroup()
            var tempDict: [Date: UIImage] = [:]
            
            // Filter for the current month if needed:
            let calendar = Calendar.current
            let startOfMonth = monthDate.startOfMonth(using: calendar)
            guard let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) else {
                self.isLoading = false
                return
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"  // match your file naming convention
            
            // Filter references to just those in this month
            let filteredRefs = items.filter { ref in
                // Example filename: "2025-03-22_12-34-56.jpg"
                let name = ref.name
                let prefix = name.prefix(10) // "YYYY-MM-DD"
                if let fileDate = formatter.date(from: String(prefix)) {
                    return fileDate >= startOfMonth && fileDate < endOfMonth
                }
                return false
            }
            
            // Download each relevant file
            for ref in filteredRefs {
                dispatchGroup.enter()
                ref.getData(maxSize: 5 * 1024 * 1024) { data, error in
                    if let data = data, let image = UIImage(data: data) {
                        // Convert file prefix to a Date key
                        let name = ref.name
                        let prefix = name.prefix(10)
                        if let fileDate = formatter.date(from: String(prefix)) {
                            tempDict[fileDate] = image
                        }
                    }
                    dispatchGroup.leave()
                }
            }
            
            // Once all downloads complete, update the state
            dispatchGroup.notify(queue: .main) {
                self.imagesByDate = tempDict
                self.isLoading = false
            }
        }
    }

    // Month title
    func monthTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

// MARK: - DayCell (Simplified)
struct DayCell: View {
    let day: TaskDay
    
    var body: some View {
        if day.date == Date.distantPast {
            // Blank cell for alignment
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
        } else {
            VStack(spacing: 4) {
                if let image = day.image {
                    NavigationLink(destination: DailyPhotoGalleryView(date: day.date)) {
                        ZStack {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 50)
                                .cornerRadius(5)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundStyle(Color.black.opacity(0.5))
                                .frame(width: 40, height: 50)
                            
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.white, lineWidth: 1)
                                .frame(width: 40, height: 50)
                            
                            Text("\(Calendar.current.component(.day, from: day.date))")
                                .font(.headline)
                                .foregroundStyle(.white)
                        }
                    }
                } else {
                    // If no image found for that date
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.white, lineWidth: 1)
                            .frame(width: 40, height: 50)
                        
                        Text("\(Calendar.current.component(.day, from: day.date))")
                            .font(.headline)
                            .foregroundStyle(.white)
                    }
                }
            }
            .frame(height: 50)
        }
    }
}

#Preview {
    CalendarView(
        monthDate: DateComponents(calendar: .current, year: 2025, month: 3).date!
    )
}
