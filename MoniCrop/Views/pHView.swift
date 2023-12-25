//
//  pHView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 4/22/23.
//

import SwiftUI
import Firebase

struct pHView: View {
    @State private var selectedFruit = ""
    @State private var selectedID = ""
    @State private var pHValues: [(Date, Double)] = []
    
    private let db = Firestore.firestore()
    private let user = Auth.auth().currentUser
    
    var body: some View {
        VStack {
            Picker("Select a fruit", selection: $selectedFruit) {
                ForEach(uniqueFruits(), id: \.self) { fruit in
                    Text(fruit)
                }
            }
            .padding()
            
            Picker("Select an ID", selection: $selectedID) {
                ForEach(uniqueIDsForFruit(selectedFruit), id: \.self) { id in
                    Text(id)
                }
            }
            .padding()
            .disabled(selectedFruit.isEmpty)
            
            Button(action: {
                getpHValues()
            }, label: {
                Text("Show pH Values")
            })
            .padding()
            
            if !pHValues.isEmpty {
                pHLineChartView(data: pHValues)
                    .padding()
            }
        }
    }
    
    private func uniqueFruits() -> [String] {
        var fruits: [String] = []
        db.collection("soil_data")
            .whereField("userId", isEqualTo: user?.uid ?? "")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let fruit = document.data()["fruit"] as? String ?? ""
                        if !fruits.contains(fruit) {
                            fruits.append(fruit)
                        }
                    }
                }
            }
        return fruits
    }
    
    private func uniqueIDsForFruit(_ fruit: String) -> [String] {
        var ids: [String] = []
        if !fruit.isEmpty {
            db.collection("soil_data")
                .whereField("userId", isEqualTo: user?.uid ?? "")
                .whereField("fruit", isEqualTo: fruit)
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            let id = document.documentID
                            if !ids.contains(id) {
                                ids.append(id)
                            }
                        }
                    }
                }
        }
        return ids
    }
    
    private func getpHValues() {
        pHValues.removeAll()
        db.collection("soil_data")
            .whereField("userId", isEqualTo: user?.uid ?? "")
            .whereField("fruit", isEqualTo: selectedFruit)
            .whereField("id", isEqualTo: selectedID)
            .order(by: "Timestamp")
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error getting documents: \(error)")
                } else {
                    for document in querySnapshot!.documents {
                        let pHValue = document.data()["pH"] as? Double ?? 0.0
                        let timestamp = document.data()["Timestamp"] as? Timestamp ?? Timestamp()
                        pHValues.append((timestamp.dateValue(), pHValue))
                    }
                }
            }
    }
}

struct pHLineChartView: View {
    var data: [(Date, Double)]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background grid
                Path { path in
                    // Vertical lines
                    for i in 1..<7 {
                        let x = CGFloat(i) * geometry.size.width / 7
                        path.move(to: CGPoint(x: x, y: 0))
                        path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                    }
                    // Horizontal lines
                    for i in 1..<5 {
                        let y = CGFloat(i) * geometry.size.height / 5
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                    }
                }
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
                
                // Line chart
                Path { path in
                    guard !data.isEmpty else { return }
                    let minData = data.map { $0.1 }.min() ?? 0
                    let maxData = data.map { $0.1 }.max() ?? 1
                    let xScale = geometry.size.width / CGFloat(data.count - 1)
                    let yScale = geometry.size.height / CGFloat(maxData - minData)
                    path.move(to: CGPoint(x: 0, y: (data[0].1 - minData) * yScale))
                    for i in 1..<data.count {
                        let x = CGFloat(i) * xScale
                        let y = (data[i].1 - minData) * yScale
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
        }
    }
}

