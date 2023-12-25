//
//  HomeView.swift
//  MoniCrop
//
//  Created by Eman Sarah Afi on 1/30/23.
//

import SwiftUI
import Firebase

struct HomeView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
        var body: some View{
            
            NavigationView{
                
                VStack{
                    
                    if self.status{
                        
                        HamburgerMenu()
                    }
                    else{
                        
                        LandingPage()
                    }
                }
                .navigationBarBackButtonHidden(true)
                .onAppear {
                    NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                        
                        self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                    }
                }
            }
        }
    }

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
