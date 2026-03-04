//
//  CalendarView.swift
//  Hapback
//
//  Created by Conductor on 30.01.2026.
//

import SwiftUI

struct CalendarView: View {
    let date = Date()
    let calendar = Calendar.current
    
    // Theme Colors
    let chicagoFont = Font.system(size: 19, weight: .bold)
    let chicagoFontSmall = Font.system(size: 14, weight: .bold)
    let primaryColor = Color(red: 0, green: 0, blue: 0.5) // Navy Blue
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 12) {
                Text(monthYearString(from: date).uppercased())
                    .font(chicagoFont)
                    .foregroundColor(.black)
                    .padding(.top, 24)
                
                let days = daysInMonth(for: date)
                let firstDay = firstWeekdayOfMonth(for: date)
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(chicagoFontSmall)
                            .foregroundColor(.black.opacity(0.4))
                    }
                    
                    ForEach(0..<max(0, firstDay-1), id: \.self) { _ in
                        Text("")
                    }
                    
                    ForEach(1...days, id: \.self) { day in
                        Text("\(day)")
                            .font(chicagoFontSmall)
                            .foregroundColor(isToday(day) ? .white : .black)
                            .frame(width: 28, height: 28)
                            .background(isToday(day) ? primaryColor : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 2))
                    }
                }
                .padding(.horizontal, 16)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
    }
    
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func daysInMonth(for date: Date) -> Int {
        return calendar.range(of: .day, in: .month, for: date)?.count ?? 30
    }
    
    private func firstWeekdayOfMonth(for date: Date) -> Int {
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstOfMonth = calendar.date(from: components)!
        return calendar.component(.weekday, from: firstOfMonth)
    }
    
    private func isToday(_ day: Int) -> Bool {
        let today = calendar.component(.day, from: Date())
        return day == today
    }
}

#Preview {
    CalendarView()
}

