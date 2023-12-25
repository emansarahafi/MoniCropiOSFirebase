//
//  SignUpView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/6/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct FirstSignUpPage: View {
    @State var date = Date()
    @State var email: String = ""
    @State var pwd: String = ""
    @State var cpwd: String = ""
    @State var alert = false
    @State var error = ""
    @State var isRegistered = false

    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 60)
            Text("Sign Up")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 50)
            Group {
                VStack (alignment: .leading){
                    Text("Email Address")
                        .font(.system(size: 20))
                        .padding(.top, 10)
                    TextField("Insert Email", text: $email)
                        .keyboardType(.emailAddress).textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                        .font(.system(size: 20))
                }
                VStack (alignment: .leading) {
                    Text("Password")
                        .font(.system(size: 20))
                    SecureTextField(text: $pwd) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                        .font(.system(size: 20))
                }
                VStack (alignment: .leading){
                    Text("Confirm Password")
                        .font(.system(size: 20))
                    ReSecureTextField(text: $cpwd) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                        .font(.system(size: 20))
                }
            }
            Button(action: { register() }) {
                            Text("Sign Up")
                        }.buttonStyle(.borderedProminent)
                            .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.top)
        
        }
        .padding()
        .padding(.top, 70)
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.error), dismissButton: .default(Text("OK")))
        }
        .background(
            NavigationLink(destination: SecondSignUpPage(), isActive: $isRegistered) {
                FirstSignUpPage()
            }
        )
    }
    func register() {
        if self.email != "" {
            if self.pwd == self.cpwd {
                Auth.auth().createUser(withEmail: self.email, password: self.pwd) { (res, err) in
                    if err != nil {
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    isRegistered = true
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                }
            } else {
                self.error = "Password mismatch"
                self.alert.toggle()
            }
        } else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }

}

struct SecondSignUpPage: View {
    @State var selection = "Select your account type"
    let options = ["Select your account type", "Business Owner", "Farm Owner"]
    @State var date = Date()
    @State var fname: String = ""
    @State var mname: String = ""
    @State var lname: String = ""
    @State var wname: String = ""
    @State var position: String = ""
    @State var email: String = ""
    @State var isSaved = false

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
            Group {
                Text("Account type")
                    .font(.system(size: 20))
                Picker("Account type", selection: $selection) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(.menu)
                .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.system(size: 20))
                Text("Workplace Name")
                    .font(.system(size: 20))
                TextField("Insert Workplace Name", text: $wname) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
                Text("Position")
                    .font(.system(size: 20))
                TextField("Insert Position", text: $position) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
                Button {
                }
            label: {
                NavigationLink(destination: HamburgerMenu()) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                }}.buttonStyle(.borderedProminent)
                    .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .padding(.top)
            }
            .padding()
            .background(
                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $isSaved) {
                    SecondSignUpPage()
                }
            )
        }
    }
    func saveUserData() {
        // Get the current user's ID and email
            guard let userID = Auth.auth().currentUser?.uid, let userEmail = Auth.auth().currentUser?.email else {
                // Handle the case where there is no logged in user
                return
            }
            
            // Get a reference to the "users" collection and the document with the user's ID
            let userRef = Firestore.firestore().collection("users").document(userID)
            
            // Set the document data with the user's details
            userRef.setData([
                "email": userEmail,
                "firstName": fname,
                "middleName": mname,
                "lastName": lname,
                "dob": date,
                "accountType": selection,
                "workplaceName": wname,
                "position": position
            ]) { error in
                if let error = error {
                    // Handle the case where there was an error saving the data
                    print("Error saving user data: \(error.localizedDescription)")
                } else {
                    // Handle the case where the data was successfully saved
                    print("User data saved successfully!")
                    
                    // Navigate to the next screen
                    isSaved = true
                }
            }
        }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        FirstSignUpPage()
    }
}
