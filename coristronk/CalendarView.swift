//
//  CalendarView.swift
//  coristronk
//
//  Created by Matran Bogdan on 15.07.2024.
//

import SwiftUI
import FSCalendar

struct CalendarView: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    var items: [Item]
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: dismissSheet) {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.gray)
                    .frame(width: 44, height: 44)
                    .background(Color.clear)
                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                        .stroke(Color("almost-white").opacity(0.5), lineWidth: 2))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                    .shadow(color: Color("almost-white").opacity(0.5), radius: 3, x: 1, y: 1)
            }
            .padding()
        }
        CalendarViewRepresentable(items: items, selectedDate: $selectedDate)
    }
    
    private func dismissSheet() {
        dismiss()
    }
}

struct CalendarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = FSCalendar
    fileprivate var calendar = FSCalendar()
    var items: [Item]
    @Binding var selectedDate: Date
    func makeUIView(context: Context) -> FSCalendar {
        calendar.delegate = context.coordinator
        calendar.dataSource = context.coordinator
        
        // Added the below code to change calendar appearance
        calendar.appearance.todayColor = UIColor(displayP3Red: 0,
                                                 green: 0,
                                                 blue: 0, alpha: 0)
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.selectionColor = .purple
        calendar.appearance.eventDefaultColor = .red
        calendar.appearance.titleTodayColor = .almostWhite
        calendar.appearance.titleFont = .boldSystemFont(ofSize: 24)
        calendar.appearance.titleWeekendColor = .pink
        calendar.appearance.weekdayTextColor = .purple
        calendar.appearance.headerMinimumDissolvedAlpha = 0.12
        calendar.appearance.headerTitleFont = .systemFont(
            ofSize: 30,
            weight: .black)
        calendar.appearance.headerTitleColor = .darkGray
        calendar.appearance.headerDateFormat = "MMMM"
        calendar.scrollDirection = .vertical
        calendar.scope = .month
        calendar.clipsToBounds = false
        
        return calendar
    }
    
    func updateUIView(_ uiView: FSCalendar, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject,
                       FSCalendarDelegate, FSCalendarDataSource {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        func calendar(_ calendar: FSCalendar,
                      didSelect date: Date,
                      at monthPosition: FSCalendarMonthPosition) {
            parent.selectedDate = date
        }
        
        func calendar(_ calendar: FSCalendar,
                      imageFor date: Date) -> UIImage? {
            if parent.isProgressComplete(for: date) {
                return UIImage(systemName: "star.fill")?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
            } else {
                return UIImage(systemName: "star.slash.fill")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
            }
        }
    }
    func isProgressComplete(for date: Date) -> Bool {
        let dateString = date.formatted(date: .abbreviated, time: .omitted)
        let itemsForDate = items.filter { $0.timestamp == dateString }
        let progressFlotari = Float(itemsForDate.filter { $0.name == Exercitii.flotari.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        let progressAbdomene = Float(itemsForDate.filter { $0.name == Exercitii.abdomene.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        let progressSquat = Float(itemsForDate.filter { $0.name == Exercitii.squat.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        return progressFlotari >= 1 && progressAbdomene >= 1 && progressSquat >= 1
    }
}
