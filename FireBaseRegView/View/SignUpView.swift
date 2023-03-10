//
//  SingUpView.swift
//  FireBaseRegView
//
//  Created by Alex Karamanets on 04.01.2023.
//

import SwiftUI

struct SignUpView: View {
    
    @ObservedObject var showHome = AuthorizationModel()
    @Environment(\.dismiss) var goBack
    
    @State private var signUpLog  = ""
    @State private var signUpPass = ""
    @State private var signUpPassConfirm = ""
    @State private var alert = false
    @State private var message = ""
    @State private var dialog = false
    
    var body: some View {
        
        VStack {
            VStack {
                Button {
                    goBack()
                } label: {
                    Image(systemName: "arrow.uturn.backward")
                        .font(.system(size: 24) .bold())
                        .foregroundColor(.mint)
                }
                .offset(x: -160, y: -85)
            }
            
            VStack {
                Text("Sign Up")
                    .font(.system(size: 29) .bold())
                    .foregroundColor(.mint)
            }
            
            VStack {
                HStack {
                    Text("Username")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                TextField("Enter You're Username", text: $signUpLog)
                    .textFieldStyle(CustomTextField(icon: "person", colorLeft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            VStack {
                HStack {
                    Text("Password")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                SecureField("Enter You're password", text: $signUpPass)
                    .textFieldStyle(CustomTextField(icon: "key", colorLeft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            VStack {
                HStack {
                    Text("Password")
                        .font(.system(size: 19))
                        .padding(.leading)
                        .opacity(0.5)
                    Spacer(minLength: 0)
                }
                SecureField("Confirm password", text: $signUpPassConfirm)
                    .textFieldStyle(CustomTextField(icon: "key", colorLeft: .blue, colorRight: .mint))
            }
            .padding(.top)
            
            Button {
                if signUpPass == signUpPassConfirm {
                    AuthService.shared.SignUp(email: self.signUpLog, password: self.signUpPass) { result in
                        switch result {
                        case .success(let user):
                            self.message = "Congratulations you have an Account! You're email is : \(user.email!)"
                            self.alert.toggle()
                            self.signUpLog = ""
                            self.signUpPass = ""
                            self.signUpPassConfirm = ""
                        case .failure(let error):
                            self.message = "\(error.localizedDescription)"
                            self.dialog.toggle()
                            self.signUpPass = ""
                            self.signUpPassConfirm = ""
                        }
                    }
                } else {
                    self.message = "Error"
                    self.dialog.toggle()
                    self.signUpPass = ""
                    self.signUpPassConfirm = ""
                }
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.mint)
                        .frame(width: 260, height: 60)
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .font(.system(size: 19))
                }
            }
            .padding(.top, 30)
        }
        .alert(isPresented: $alert) {
            Alert(title: Text("\(message) ????"),
                  dismissButton: .default(Text("Ok")) {
                goBack()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.showHome.showHome.toggle() }
                
            })
        }
        .confirmationDialog("\(message)", isPresented: $dialog, titleVisibility: .visible) {
            Button("Go Back", role: .destructive) {
                self.signUpLog = ""
                self.signUpPass = ""
                self.signUpPassConfirm = ""
                goBack()
            }
        }
    }
}
//                    ????
struct SingUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
