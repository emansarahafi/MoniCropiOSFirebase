//
//  CustomerView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct CustomerFeedbackPage: View {
    @State private var email: String = ""
    @State private var opinion: String = ""

    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 150)
            Text("Customer Feedback")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
                .padding()
            VStack(alignment: .leading) {
                Text("Email Address")
                    .font(.system(size: 20))
                TextField("Insert Email", text: $email)
                    .keyboardType(.emailAddress).textFieldStyle(RoundedBorderTextFieldStyle()) .textContentType(.emailAddress)
            }
            VStack (alignment: .leading) {
                Text("Feedback or Complaint")
                    .font(.system(size: 20))
                TextField("Insert Opinion", text: $opinion) .textFieldStyle(RoundedBorderTextFieldStyle()) .textContentType(.none)
            }
            Button(action: {
                submitFeedback()
            }, label: {
                NavigationLink(destination: ConfirmationPage().navigationBarBackButtonHidden(true)) {
                    Text("Submit")
                        .frame(maxWidth: .infinity)
                }
            }).buttonStyle(.borderedProminent)
                .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(.top)
        }
        .padding()
    }
    private func submitFeedback() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        let feedbackText = "\(email) says: \(opinion)"
        
        // Send feedback to Telegram channel
        let telegramChatId = "@MoniCropFeedback"
        let telegramApiKey = "5391208108:AAGz6gTUOycK1v-61407-6wqJaOvHqhm7EU"
        let telegramMessage = "User \(userId) submitted feedback: \(feedbackText)"
        
        // Send message to Telegram
        let telegramURL = URL(string: "https://api.telegram.org/bot\(telegramApiKey)/sendMessage?chat_id=\(telegramChatId)&text=\(telegramMessage)")
        URLSession.shared.dataTask(with: telegramURL!).resume()
        
        // Write feedback to Firestore
        let db = Firestore.firestore()
        db.collection("feedback").document(userId).setData([
            "email": email,
            "opinion": opinion
        ]) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("Feedback successfully written to Firestore")
            }
        }
        
        // Clear feedback text
        email = ""
        opinion = ""
    }
}

struct ConfirmationPage: View {

    var body: some View {
        VStack {
            Image(systemName: "checkmark")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .imageScale(.large)
                .font(.system(size: 120))
                .padding()
            Text("Feedback Received!")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .fontWeight(.bold)
                .font(.system(size: 50))
                .padding()
            .padding()
            Button(action: {
                // Action for Done button
            }, label: {
                NavigationLink(destination: HamburgerMenu().navigationBarBackButtonHidden(true)) {
                    Text("Done")
                        .frame(maxWidth: .infinity)
                }
            }).buttonStyle(.borderedProminent)
                .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                .foregroundColor(.white)
                .font(.system(size: 20))
                .padding(.top)
        }
        .padding()
    }
}


struct CustomerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerFeedbackPage()
    }
}
