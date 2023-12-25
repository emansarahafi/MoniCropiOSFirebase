//
//  ItemViewModel.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/28/23.
//

import Firebase
import Foundation
import Combine
import FirebaseFirestore
import FirebaseAuth

struct ItemsViewModel: Identifiable, Hashable {
    let id = UUID()
    var item: Items
    var image: String {
        return item.image
    }
    var name: String {
        return item.name
    }
    var date: String {
        return item.date
    }
    var price: String {
        return item.price
    }
}

class ApplicationData: ObservableObject {
    @Published var listOfItems: [ItemsViewModel] = []
    let userId = Auth.auth().currentUser?.uid
    let db = Firestore.firestore()
    private let itemsCollection = "items"

    func loadData() {
        db.collection(itemsCollection)
            .whereField("userId", isEqualTo: userId)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error getting documents: \(error)")
                    return
                }

                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }

                let items = documents.map { document -> Items in
                    let data = document.data()
                    let image = data["image"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let price = data["price"] as? String ?? ""

                    return Items(image: image, name: name, date: date, price: price)
                }

                DispatchQueue.main.async {
                    self.listOfItems = items.map(ItemsViewModel.init)
                }
            }
    }
}


















