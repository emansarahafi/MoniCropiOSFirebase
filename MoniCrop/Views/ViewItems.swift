//
//  ViewItems.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI
import FirebaseFirestore

let appData = ApplicationData()

struct ViewItemsPage: View {
    var body: some View {
        ContentViewItems()
            .environmentObject(appData)
    }
}

struct ContentViewItems: View {
    @EnvironmentObject var appData: ApplicationData

    var body: some View {
        VStack {
            Text("View Items")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
                List { ForEach(appData.listOfItems) { item in
                        CellItem(item: item)
                }
            }.background(Color(red: 148/255, green: 178/255, blue: 2/255))
                .scrollContentBackground(.hidden)
                .foregroundColor(Color.black)
            
        }
        .padding()
        .onAppear {
            appData.loadData()
        }
    }
}

struct CellItem: View {
    let item: ItemsViewModel
    var body: some View {
        HStack {
            Image(item.image)
            .resizable()
            .scaledToFit()
            .frame(width: 100, height: 100)
            VStack (alignment: .leading){
                Text("Item: \(item.name)").bold()
                Text("Date: \(item.date)").bold()
                Text("Price: \(item.price)").bold()
            }
        }
    }
}

