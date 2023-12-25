//
//  Components.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 12/26/22.
//

import SwiftUI
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct SecureTextField: View {
    
    @State private var isSecureField: Bool = true
    @Binding var text: String
    
    var body: some View {
        HStack {
            if isSecureField {
                SecureField("Insert Password", text: $text)
            } else {
                TextField(text, text: $text)
            }
        }.overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash": "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

struct ReSecureTextField: View {
    
    @State private var isSecureField: Bool = true
    @Binding var text: String
    
    var body: some View {
        HStack {
            if isSecureField {
                SecureField("Retype Password", text: $text)
            } else {
                TextField(text, text: $text)
            }
        }.overlay(alignment: .trailing) {
            Image(systemName: isSecureField ? "eye.slash": "eye")
                .onTapGesture {
                    isSecureField.toggle()
                }
        }
    }
}

struct FruitPickerView: View {
    @State var selectedFruit: String = ""
    @State var fruits: [String] = []
    
    var body: some View {
        Picker("Select a fruit", selection: $selectedFruit) {
            ForEach(fruits, id: \.self) { fruit in
                Text(fruit)
            }
        }
        .onAppear {
            guard let userId = Auth.auth().currentUser?.uid else {
                            // handle the case where the user is not logged in
                            return
            }
            let db = Firestore.firestore()
            db.collection("soil_data")
                .whereField("userId", isEqualTo: userId)
                .getDocuments { querySnapshot, error in
                    if error != nil {
                        // handle the error
                    } else {
                        var uniqueFruits = Set<String>()
                        querySnapshot?.documents.forEach { document in
                            let data = document.data()
                            if let fruit = data["fruit"] as? String {
                                uniqueFruits.insert(fruit)
                            }
                        }
                        fruits = Array(uniqueFruits)
                    }
                }
        }
    }
}

