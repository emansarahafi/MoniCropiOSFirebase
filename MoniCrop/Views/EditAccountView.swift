//
//  EditAccountView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI
import Firebase

struct FirstEditAccountPage: View {
    @State var email: String = ""
    @State var pwd: String = ""
    @State var cpwd: String = ""

    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 150)
            Text("Edit Account")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
            Text("Email Address")
                .font(.system(size: 20))
                .padding()
            TextField("Insert Email", text: $email)
                .keyboardType(.emailAddress).textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                .font(.system(size: 20))
            Text("Insert Password")
                .font(.system(size: 20))
            SecureTextField(text: $pwd) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
            Text("Confirm Password")
                .font(.system(size: 20))
            ReSecureTextField(text: $cpwd) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                .font(.system(size: 20))
            Button {
                if email.isEmpty && pwd != cpwd
                {
                    Text("Password does not match. Try again.").foregroundColor(.red)
                        .offset(y: -10)
                }
            }
            label: {
                NavigationLink(destination: chooseDestination()) {
                    Text("Next")
                        .frame(maxWidth: .infinity)
                }}.buttonStyle(.borderedProminent)
                        .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.top)
        }
        .padding()
        .padding(.top, 50)
    }
    @ViewBuilder
    func chooseDestination() -> some View {
        if !email.isEmpty && pwd == cpwd
        {
            SecondEditAccountPage()
        }
        else {
            FirstEditAccountPage().animation(nil)
        }
    }
}

struct SecondEditAccountPage: View {
    @State var date = Date()
    @State var fname: String = ""
    @State var mname: String = ""
    @State var lname: String = ""
    @State var wname: String = ""
    @State var position: String = ""

    var body: some View {
        VStack {
            Group {
                Text("First Name")
                    .font(.system(size: 20))
                TextField("Insert First Name", text: $fname) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
                Text("Middle Name")
                    .font(.system(size: 20))
                TextField("Insert Middle Name", text: $mname) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
                Text("Last Name")
                    .font(.system(size: 20))
                TextField("Insert Last Name", text: $lname) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
            }
            DatePicker("Date of Birth",
                        selection: $date,
                        in: ...Date(),
                        displayedComponents: [.date])
            .font(.system(size: 20))
                        .padding()
            Text("Workplace Name")
                .font(.system(size: 20))
            TextField("Insert Workplace Name", text: $wname) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                .font(.system(size: 20))
            Text("Position")
                .font(.system(size: 20))
            TextField("Insert Position", text: $position) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                .font(.system(size: 20))
            Button {
                // Authenticate the user
                                guard let user = Auth.auth().currentUser else {
                                    print("No user is currently signed in")
                                    return
                                }

                                // Construct a reference to the user's document in Firestore
                                let db = Firestore.firestore()
                                let userRef = db.collection("users").document(user.uid)

                                // Update the fields in the document
                                userRef.setData([
                                    "firstName": fname,
                                    "middleName": mname,
                                    "lastName": lname,
                                    "dob": date,
                                    "workplaceName": wname,
                                    "position": position
                                ], merge: true) { error in
                                    if let error = error {
                                        print("Error updating document: \(error)")
                                    } else {
                                        print("Document updated successfully")
                                    }
                                }
            }
            label: {
                NavigationLink(destination: HamburgerMenu()) {
                    Text("Update Account")
                        .frame(maxWidth: .infinity)
                }}.buttonStyle(.borderedProminent)
                        .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                        .foregroundColor(.white)
                        .font(.system(size: 20))
                        .padding(.top)
            Button {
            }
            label: {
                NavigationLink(destination: DisableDeletePage()) {
                    Text("Disable or Delete Your Account")
                }}                        .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                        .font(.system(size: 20))
                        .padding(.top)
        }
        .padding()
    }}

struct Previews_EditAccountView_Previews: PreviewProvider {
    static var previews: some View {
        FirstEditAccountPage()
    }
}
