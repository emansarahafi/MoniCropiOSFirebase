//
//  ViewData.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI

struct ViewDataPage: View {
    init() {
        UITabBar.appearance().barTintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 148/255, green: 178/255, blue: 2/255, alpha: 1)
        UITabBar.appearance().tintColor = UIColor.black
    }

    var body: some View {
        VStack {
            Text("View Data")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
            
            TabView {
                nitrogenView().tabItem({
                    Label("Nitrogen Level", systemImage: "n.circle")
                })
                phosphorusView().tabItem({
                    Label("Phosphorus Level", systemImage: "p.circle")
                })
                potassiumView().tabItem({
                    Label("Potassium Level", systemImage: "k.circle")
                })
                pHView().tabItem({
                    Label("pH Level", systemImage: "arrow.up.right")
                })
                conductivityView().tabItem({
                    Label("Conductivity Level", systemImage: "arrow.up.forward.app")
                })
                moistureView().tabItem({
                    Label("Moisture Level", systemImage: "drop.fill")
                })
                distanceView().tabItem({
                    Label("Growth Speed Rate", systemImage: "speedometer")
                })
                temperatureView().tabItem({
                    Label("Soil temperature", systemImage: "thermometer.high")
                })

            }.accentColor(.black)
        }
        .padding()
    }
}






