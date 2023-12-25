//
//  DisableDeletePage.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/7/23.
//

import SwiftUI
import Firebase

struct DisableDeletePage: View {
    
    @State private var selectedAction = "Disable Account"
    @State private var password = ""
    @State private var isActionPerformed = false
    
    var body: some View {
        VStack {
            Picker(selection: $selectedAction, label: Text("Choose Action")) {
                Text("Disable Account").tag("Disable Account")
                Text("Delete Account").tag("Delete Account")
            }
            .pickerStyle(SegmentedPickerStyle())
            Text("Please enter the password to confirm:")
                .font(.system(size: 20))
            SecureTextField(text: $password).textFieldStyle(.roundedBorder) .textInputAutocapitalization(.words)
                .font(.system(size: 20))
            
            Text("Kindly note that if you choose: \nDisable: The account will be disabled & the user can reactivate it at any moment by logging again. \nDelete: The account will be deleted instantly.")
                .multilineTextAlignment(.leading)
                .font(.system(size: 20))
                .padding()
            
            NavigationLink(destination: LandingPage().navigationBarBackButtonHidden(true), isActive: $isActionPerformed) {
                Button(action: {
                    guard let currentUser = Auth.auth().currentUser else { return }
                    
                    switch selectedAction {
                    case "Disable Account":
                        currentUser.updateEmail(to: "") { error in
                            if let error = error {
                                print("Error disabling account: \(error.localizedDescription)")
                                return
                            }
                            print("Account disabled.")
                            isActionPerformed = true
                        }
                    case "Delete Account":
                        let credential = EmailAuthProvider.credential(withEmail: currentUser.email ?? "", password: password)
                        currentUser.reauthenticate(with: credential) { authDataResult, error in
                            if let error = error {
                                print("Error reauthenticating user: \(error.localizedDescription)")
                                return
                            }
                            currentUser.delete { error in
                                if let error = error {
                                    print("Error deleting account: \(error.localizedDescription)")
                                    return
                                }
                                print("Account deleted.")
                                isActionPerformed = true
                            }
                        }
                    default:
                        break
                    }
                    
                }) {
                    Text("Perform Action")
                }
            }
        }
        .onAppear {
            guard let currentUser = Auth.auth().currentUser else { return }
            selectedAction = currentUser.isEmailVerified ? "Disable Account" : "Delete Account"
        }
    }
}



struct DeleteView_Previews: PreviewProvider {
    static var previews: some View {
        DisableDeletePage()
    }
}
