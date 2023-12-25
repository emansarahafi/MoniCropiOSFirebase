//
//  ContentView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 12/2/22.
//

import SwiftUI

struct LandingPage: View {

    var body: some View {
        NavigationView {
            VStack {
                Image("MoniCrop")
                    .frame(width: 50, height: 50)
                    .padding(.bottom, 200)
                Button {
                }
                label: {
                    NavigationLink(destination: SignInPage()) {
                        Text("Sign In")
                            .frame(maxWidth: .infinity)
                    }}.buttonStyle(.borderedProminent)
                            .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.top)
                Button {
                }
                label: {
                    NavigationLink(destination: FirstSignUpPage()) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                    }}.buttonStyle(.borderedProminent)
                            .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.top)
                Button {
                }
                label: {
                    NavigationLink(destination: AboutUsPage()) {
                        Text("About Us")
                    }}                        .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                            .font(.system(size: 20))
                            .padding(.top)
            }
        }.accentColor(.black)
        .padding()
    }
}

struct AboutUsPage: View {
    
    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 150)
            Text("MoniCrop is an iOS application developed by two students in 2022 from the American University of Bahrain (AUBH), Ali Abdulla & Eman Sarah Afi.")
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .padding()
            Text("The purpose of this application is for the user being able to monitor their crop, check any essential information, and communicate with specific users at any moment of the day.")
                .font(.system(size: 18))
                .multilineTextAlignment(.leading)
                .padding()
        }
        .padding()
        .padding(.top, 20)
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LandingPage()
    }
}
