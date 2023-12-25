//
//  ForgotPasswordView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI
import FirebaseAuth

struct ForgotPasswordPage: View {
    @State var email: String = ""
    @State var pwd: String = ""
    @State var newpwd: String = ""
    @State var error = ""
    @State var alert = false

    var body: some View {
        VStack {
            Image("MoniCrop")
                .frame(width: 50, height: 50)
                .padding(.bottom, 200)
            Text("Email Address")
            TextField("Insert Email", text: self.$email)
                .keyboardType(.emailAddress).textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
            Button(action: { reset() }) {
                Text("Send Verification Link").frame(maxWidth: .infinity)
                }.buttonStyle(.borderedProminent)
                    .tint(Color(red: 148/255, green: 178/255, blue: 2/255))
                    .font(.system(size: 20))
                    .padding(.top)
        }
        .padding()
    }
    func reset(){
            
            if self.email != ""{
                
                Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                    
                    if err != nil{
                        
                        self.error = err!.localizedDescription
                        self.alert.toggle()
                        return
                    }
                    
                    self.error = "RESET"
                    self.alert.toggle()
                }
            }
            else{
                
                self.error = "Email Id is empty"
                self.alert.toggle()
            }
        }
}

struct ForgotPasswordPage_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordPage()
    }
}
