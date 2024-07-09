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
   
    @State private var amount: Int = 0
    @State private var selectedStep: Segment = .first
    @State private var selectedExercise: Exercitii = .flotari
    
    @Query(sort: \Item.timestamp)  private var items: [Item]
    @State private var progressFlotari: Float = 0
    @State private var progressAbdomene: Float = 0
    @State private var progressSquat: Float = 0
    @State private var goalAchieved: Bool = false
    
    let segments = Segment.allCases
    let exerciseSegment = Exercitii.allCases
    
    var body: some View {
            NavigationStack {
                ZStack {
                    Color.white
                        .edgesIgnoringSafeArea(.all)
                    VStack(alignment: .leading, spacing: 20) {
                        // day display for each exercise
                        Spacer()
                        HStack {
                            Spacer()
                            ZStack {
                                ProgressBar(progress: $progressFlotari, fillColor: .constant(Color(hex: "#88b04b")), image: .constant("arm"))
                                    .padding(40)
                                ProgressBar(progress: $progressAbdomene, fillColor: .constant(Color(hex: "#6b5b95")), image: .constant("chest"))
                                    .padding(20)
                                ProgressBar(progress: $progressSquat, fillColor: .constant(Color(hex: "#ff6f61")), image: .constant("leg"))
                                if goalAchieved {
                                    VStack {
                                        Text("Bravo love \n 😘")
                                            .multilineTextAlignment(.center)
                                            .font(.caption)
                                        Image(systemName: "fireworks").foregroundColor(.red)
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
                        Text("Exercise")
                            .foregroundColor(.black)
                            .font(.caption)
                            .padding(.leading)
                        
                        Picker("Exercises", selection: $selectedExercise) {
                            ForEach(Exercitii.allCases, id: \.self) { exercise in
                                Text(exercise.rawValue).tag(exercise)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(.clear)
                        .cornerRadius(8)
                        .padding(.horizontal)
                        .onChange(of: selectedExercise) { _ in
                            amount = 0
                        }
                        Text("Reps")
                            .foregroundColor(.black)
                            .font(.caption)
                            .padding(.leading)
                        
                        Picker("Step", selection: $selectedStep) {
                            ForEach(Segment.allCases, id: \.self) { step in
                                Text(step.rawValue).tag(step)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .background(Color.gray.opacity(0.2))
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
                                    .foregroundColor(.black)
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            
                            Spacer()
                            
                            Text("\(amount)")
                                .foregroundColor(.black)
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
                                    .foregroundColor(.black)
                                    .frame(width: 64, height: 64)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                            Spacer()
                            Button(action: addItem) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.green)
                                    .frame(width: 128, height: 64)
                                    .background(Color.white)
                                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 32, height: 32)))
                                    .shadow(color: .black.opacity(0.5), radius: 3, x: 1, y: 1)
                            }
                                
                        }
                        .padding(.horizontal)
                        
                        List {
                            ForEach(items) { exercise in
                                VStack(alignment: .leading, content: {
                                    HStack {
                                        Text(exercise.name)
                                            .font(.headline)
                                        Spacer()
                                        Text("\(exercise.reps)")
                                            .font(.subheadline)
                                    }
                                    .padding(.vertical)
                                    Text(exercise.timestamp, format: .dateTime.month(.wide).day().year())
                                        .font(.caption)
                                 })
                            }
                            .onDelete(perform: deleteItems)
                        }
                        .listStyle(.insetGrouped)
                        .background(Color.clear)
                    }
                    .navigationTitle("Bubu's workouts")
                    .navigationBarTitleDisplayMode(.inline)
                    .onTapGesture {
                        hideKeyboard()
                    }
                }
            }
        }

    private func addItem() {
        if amount == 0 {
            return
        }
        withAnimation {
            let newItem = Item(timestamp: Date(), name: selectedExercise.rawValue, reps: amount)
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
        let todayItems = items.filter { Calendar.current.isDateInToday($0.timestamp) }
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
