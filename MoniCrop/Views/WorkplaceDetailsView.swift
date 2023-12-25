//
//  WorkplaceView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct WorkplaceDetailsPage: View {

    @State private var workplaceName: String = ""
    @State private var foundingDate: Date = Date()
    @State private var joinedDate: Date = Date()
    @State private var items: [String] = []

    var body: some View {
        VStack {
            Text("Workplace Details")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
            
            VStack {
                Text("Workplace Name:\(workplaceName)")
                    .font(.headline)
                Text("Founding Date: \(foundingDate, style: .date)")
                    .font(.subheadline)
                Text("Joined MoniCrop on: \(joinedDate, style: .date)")
                    .font(.subheadline)
                Text("Items: \(items.joined(separator: ", "))")
                    .font(.subheadline)
            }
            .multilineTextAlignment(.center)
            .font(.system(size: 20))
            .padding()
        }
        .padding()
        .onAppear(perform: {
            // Replace "workplaces" with the name of your Firestore collection
            let db = Firestore.firestore().collection("workplaces")
            
            if let userID = Auth.auth().currentUser?.uid {
                // Retrieve the data based on the user ID
                db.whereField("userId", isEqualTo: userID).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting documents: \(error)")
                    } else {
                        for document in querySnapshot!.documents {
                            if let name = document.data()["name"] as? String {
                                self.workplaceName = name
                            }
                            if let foundingTimestamp = document.data()["foundingDate"] as? Timestamp {
                                self.foundingDate = foundingTimestamp.dateValue()
                            }
                            if let joinedTimestamp = document.data()["joinedDate"] as? Timestamp {
                                self.joinedDate = joinedTimestamp.dateValue()
                            }
                            if let items = document.data()["items"] as? [String] {
                                self.items = items
                            }
                        }
                    }
                }
            }
        })
    }
}


struct WorkplaceView_Previews: PreviewProvider {
    static var previews: some View {
        WorkplaceDetailsPage()
    }
}
