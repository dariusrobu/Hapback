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
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Bar
            HStack {
                Spacer()
                Text("Calendar")
                    .font(.system(size: 20, weight: .bold))
                    .textCase(.uppercase)
                    .kerning(1.0)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "battery.100")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.black.opacity(0.1)),
                alignment: .bottom
            )
            
            VStack(spacing: 16) {
                Text(monthYearString(from: date))
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.black)
                    .padding(.top, 20)
                
                let days = daysInMonth(for: date)
                let firstDay = firstWeekdayOfMonth(for: date)
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(["S", "M", "T", "W", "T", "F", "S"], id: \.self) { day in
                        Text(day)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.black.opacity(0.5))
                    }
                    
                    ForEach(0..<firstDay-1, id: \.self) { _ in
                        Text("")
                    }
                    
                    ForEach(1...days, id: \.self) { day in
                        Text("\(day)")
                            .font(.system(size: 18, weight: isToday(day) ? .black : .bold))
                            .foregroundColor(isToday(day) ? .white : .black)
                            .frame(width: 30, height: 30)
                            .background(isToday(day) ? Color(red: 0, green: 0, blue: 128/255) : Color.clear)
                            .clipShape(Circle())
                    }
                }
                .padding(.horizontal, 20)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .background(Color(red: 216/255, green: 233/255, blue: 240/255))
}
