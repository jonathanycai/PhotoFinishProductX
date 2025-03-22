//
//  CalendarView.swift
//  PhotoFinish
//
//  Created by Renata Liu on 2025-03-22.
//

import SwiftUI

struct CalendarView: View {
    let monthDate: Date
    let imagesByDate: [Date: UIImage]

    private let columns = Array(repeating: GridItem(.flexible()), count: 7)
    private let weekdaySymbols = Calendar.current.shortStandaloneWeekdaySymbols

    var body: some View {
        let days = generateMonthDays(for: monthDate, imagesByDate: imagesByDate)
        
        VStack {
            // month label
            Text(monthTitle(from: monthDate))
                .font(.title)
                .bold()
                .padding(.top)

            // days of the week letters
            HStack(spacing: 0) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // grid of days
            LazyVGrid(columns: columns, spacing: 10) {
                ForEach(days) { day in
                    DayCell(day: day)
                }
            }
            .padding()
        }
    }

    // month title
    func monthTitle(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
}

struct DayCell: View {
    let day: TaskDay
    
    var body: some View {
        if day.date == Date.distantPast {
            Rectangle()
                .foregroundColor(.clear)
                .frame(height: 50)
        } else {
            VStack(spacing: 4) {
                if let image = day.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .cornerRadius(5)
                } else {
                    Text("\(Calendar.current.component(.day, from: day.date))")
                        .font(.headline)
                        .foregroundColor(.black)
                        .frame(width: 40, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(5)
                }
            }
            .frame(height: 50)
        }
    }
}

#Preview {
    CalendarView(
        monthDate: DateComponents(calendar: .current, year: 2025, month: 3).date!,
        imagesByDate: [:] // or your own dictionary of Date -> UIImage
    )
}
