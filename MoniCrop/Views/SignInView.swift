//
//  SignInView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/6/23.
//

import SwiftUI
import Firebase
import FirebaseAuth

struct SignInPage: View {
    @State var email: String = ""
    @State var pwd: String = ""
    @State var alert = false
    @State var error = ""
    @State var isAuthenticated = false
    
    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 150)
            Text("Sign In")
                .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                .font(.title)
                .fontWeight(.bold)
            
            VStack (alignment: .leading){
                Text("Email Address")
                    .font(.system(size: 20))
                TextField("Insert Email", text: self.$email)
                    .keyboardType(.emailAddress).textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
            }
            VStack (alignment: .leading){
                Text("Password")
                    .font(.system(size: 20))
                SecureTextField(text: self.$pwd) .textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                    .font(.system(size: 20))
            }
            Button(action: { verify() }) {
                            Text("Sign in")
                        }.buttonStyle(.borderedProminent)
                            .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding(.top)
            Button {
            }
            label: {
                NavigationLink(destination: ForgotPasswordPage()) {
                    Text("Forgot Your Password Page?").underline()
                }}                        .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                        .font(.system(size: 20))
            Button {
            }
            label: {
                NavigationLink(destination: FirstSignUpPage()) {
                    Text("Sign Up Instead")
                }}                        .foregroundColor(Color(red: 148/255, green: 178/255, blue: 2/255))
                        .font(.system(size: 20))
        }
        .padding()
        .padding(.top, 100)
        .alert(isPresented: $alert) {
            Alert(title: Text("Error"), message: Text(self.error), dismissButton: .default(Text("OK")))
        }
        .background(
            NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true), isActive: $isAuthenticated) {
                SignInPage()
            }
        )
    }
    
    func verify() {
        if self.email != "" && self.pwd != "" {
            Auth.auth().signIn(withEmail: self.email, password: self.pwd) { (result, error) in
                if error != nil {
                    self.error = error!.localizedDescription
                    self.alert.toggle()
                    return
                }
                // If the user is authenticated successfully, change the view to HomeView()
                isAuthenticated = true
                
                // Set a boolean flag in UserDefaults to indicate that the user is authenticated
                UserDefaults.standard.set(true, forKey: "status")
                // Post a notification to let other parts of the app know that the authentication status has changed
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
        } else {
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInPage()
    }
}
