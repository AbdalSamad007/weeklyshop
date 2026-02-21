//
//  AuthView.swift
//  WeeklyShop
//
//  Created by Abd-Al-Samad Syed on 17/02/2026.
//

import Foundation
import SwiftUI
import FirebaseAuth

struct AuthView: View {

    @EnvironmentObject var authService: AuthService

    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {

                Text(isLogin ? "Sign In" : "Create Account")
                    .font(.largeTitle.bold())

                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .autocorrectionDisabled()
                    .textFieldStyle(.roundedBorder)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)

                if let errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                Button {
                    Task {
                        await authenticate()
                    }
                } label: {
                    Text(isLogin ? "Sign In" : "Create Account")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(isLogin ? "Don't have an account? Sign up" :
                                  "Already have an account? Sign in") {
                    isLogin.toggle()
                }
                .font(.footnote)

                Spacer()
            }
            .padding()
        }
    }

    private func authenticate() async {
        do {
            print("Authenticating...")
            if isLogin {
                try await authService.signIn(email: email, password: password)
            } else {
                try await authService.signUp(email: email, password: password)
            }
        } catch {
            print("AUTH ERROR FULL:", error)
            errorMessage = String(describing: error)
        }
    }


}
