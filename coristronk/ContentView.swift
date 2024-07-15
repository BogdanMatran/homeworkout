//
//  ContentView.swift
//  coristronk
//
//  Created by Matran Bogdan on 08.07.2024.
//

import SwiftUI
import SwiftData

enum Segment: String, CaseIterable {
    case first = "1"
    case second = "10"
    case third = "20"
}

enum Exercitii: String, CaseIterable {
    case flotari = "Flotari"
    case abdomene = "Abdomene"
    case squat = "Genuflexiuni"
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Item.timestamp, order: .reverse) public var items: [Item]

    @State private var amount: Int = 0
    @State private var selectedStep: Segment = .first
    @State private var selectedExercise: Exercitii = .flotari
    @State private var showingSheet = false
    @State private var currentDate = Date()
    @State private var progressFlotari: Float = 0
    @State private var progressAbdomene: Float = 0
    @State private var progressSquat: Float = 0
    @State private var goalAchieved: Bool = false
    
    let segments = Segment.allCases
    let exerciseSegment = Exercitii.allCases
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color("background")
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading, spacing: 20) {
                        // day display for each exercise
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                ProgressBar(progress: $progressFlotari, fillColor: .constant(Color("almost-white")), image: .constant("arm"))
                                    .padding(48)
                                ProgressBar(progress: $progressAbdomene, fillColor: .constant(Color("pink")), image: .constant("chest"))
                                    .padding(24)
                                ProgressBar(progress: $progressSquat, fillColor: .constant(Color("purple")), image: .constant("leg"))
                                if goalAchieved {
                                    VStack {
                                        Text("Bravo love \n 😘")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                            .foregroundColor(Color("purple"))
                                        Image(systemName: "fireworks").foregroundColor(Color("almost-white"))
                                    }
                                } else {
                                    Text("You got this \n babe")
                                        .multilineTextAlignment(.center)
                                        .font(.caption)
                                }
                            }
                            Spacer()
                        }
                        .onAppear(perform: {
                            self.calculateProgress()
                        })
                        Picker("Exercises", selection: $selectedExercise) {
                            ForEach(Exercitii.allCases, id: \.self) { exercise in
                                Text(exercise.rawValue).tag(exercise)
                                    .foregroundStyle(.white)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(.clear)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: selectedExercise) { _ in
                            amount = 0
                        }
                        Picker("Step", selection: $selectedStep) {
                            ForEach(Segment.allCases, id: \.self) { step in
                                Text(step.rawValue).tag(step)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(.clear)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        HStack {
                            Button(action: {
                                let decreaseAmount: Int
                                switch selectedStep {
                                case .first:
                                    decreaseAmount = 1
                                case .second:
                                    decreaseAmount = 10
                                case .third:
                                    decreaseAmount = 20
                                }
                                
                                if amount >= decreaseAmount {
                                    amount -= decreaseAmount
                                }
                            }) {
                                
                                Image(systemName: "minus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("purple"))
                                    .frame(width: 44, height: 44)
                                    .background(Color.clear)
                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .stroke(Color("almost-white").opacity(0.5), lineWidth: 2))
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .shadow(color: Color("almost-white").opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            
                            Spacer()
                            
                            Text("\(amount)")
                                .foregroundColor(Color("purple"))
                                .font(.largeTitle)
                            Spacer()
                            Button(action: {
                                let increaseAmount: Int
                                switch selectedStep {
                                case .first:
                                    increaseAmount = 1
                                case .second:
                                    increaseAmount = 10
                                case .third:
                                    increaseAmount = 20
                                }
                                
                                amount = min(amount + increaseAmount, 100)
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(Color("purple"))
                                    .frame(width: 44, height: 44)
                                    .background(Color.clear)
                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .stroke(Color("almost-white").opacity(0.5), lineWidth: 2))
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .shadow(color: Color("almost-white").opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            Spacer()
                            Button(action: addItem) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                                    .frame(width: 88, height: 44)
                                    .background(Color.clear)
                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .stroke(Color("almost-white").opacity(0.5), lineWidth: 2))
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .shadow(color: Color("almost-white").opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            Spacer()
                            Button(action: showCalendar) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    .frame(width: 44, height: 44)
                                    .background(Color.clear)
                                    .overlay(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                                        .stroke(Color("almost-white").opacity(0.5), lineWidth: 2))
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 10, height: 10)))
                                    .shadow(color: Color("almost-white").opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                        }
                        .padding(.horizontal)
                        List {
                            ForEach(items.filter{$0.timestamp == currentDate.formatted(date: .abbreviated, time: .omitted)}) { exercise in
                                VStack(alignment: .leading, content: {
                                    HStack {
                                        Text(exercise.name)
                                            .font(.headline)
                                            .foregroundStyle(Color("purple"))
                                        Spacer()
                                        Text("\(exercise.reps)")
                                            .font(.subheadline)
                                            .foregroundStyle(Color("pink"))
                                    }
                                    .padding(.vertical)
                                    Text(exercise.timestamp)
                                        .font(.caption)
                                        .foregroundStyle(Color("almost-white"))
                                 })
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.plain)
                        .background(Color.clear)
                    }
                    .navigationTitle("Bubu's workouts \(currentDate.formatted(date: .abbreviated, time: .omitted))")
                    .navigationBarTitleDisplayMode(.inline)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
            }
            .sheet(isPresented: $showingSheet) {
                CalendarView(selectedDate: $currentDate, items: self.items)
            }
            .onAppear() {
                calculateProgress()
            }
            .onChange(of: currentDate, perform: { _ in
                self.calculateProgress()
            })
        }
    
    private func showCalendar() {
        showingSheet.toggle()
    }
    
    private func addItem() {
        if amount == 0 {
            return
        }
        withAnimation {
            let newItem = Item(timestamp: currentDate, name: selectedExercise.rawValue, reps: amount)
            modelContext.insert(newItem)
            try? modelContext.save()
            calculateProgress()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
                try? modelContext.save()
                calculateProgress()
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func calculateProgress() {
        let todayItems = items.filter { $0.timestamp == currentDate.formatted(date: .abbreviated, time: .omitted) }
        progressFlotari = Float(todayItems.filter { $0.name == Exercitii.flotari.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        progressAbdomene = Float(todayItems.filter { $0.name == Exercitii.abdomene.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        progressSquat = Float(todayItems.filter { $0.name == Exercitii.squat.rawValue }.reduce(0) { $0 + $1.reps }) / 100
        if progressFlotari >= 1 && progressSquat >= 1 && progressAbdomene >= 1 {
            /// goal achieved
            goalAchieved = true
        } else {
            goalAchieved = false
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8 * 17) & 0xFF, (int >> 4 * 17) & 0xFF, (int * 17) & 0xFF)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
