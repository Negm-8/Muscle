//
//  LoginView.swift
//  Muscle
//
//  Created by abdallah negm on 30/11/2024.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var phoneNumber: String = ""
    @State private var isSignedIn: Bool = false // حالة التحقق من التسجيل
    @State private var googleButtonScale: CGFloat = 1.0 // تأثير الضغط على زر Google
    @State private var appleButtonScale: CGFloat = 1.0 // تأثير الضغط على زر Apple

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 40) {
                    // شعار التطبيق
                    Image("negm22")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .cornerRadius(60)
                        .shadow(radius: 10)

                    // النص الرئيسي
                    Text("ابدأ مع نجم")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom, 20)

                    // قسم تسجيل الدخول
                    VStack(spacing: 30) {
                        loginSection
                        Spacer()
                    }
                    .padding(.horizontal, 30)
                }
                .padding(.top, 50) // المسافة من الأعلى
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline) // عنوان صغير
            .toolbar {
//                ToolbarItem(placement: .principal) {
//                    Text("تسجيل الدخول")
//                        .font(.title3)
//                        .fontWeight(.semibold)
//                        .foregroundColor(.white)
//                }
            }
        }
    }

    // قسم تسجيل الدخول
    var loginSection: some View {
        VStack(spacing: 20) {
            // زر تسجيل الدخول بواسطة Google
            Button(action: {
                withAnimation {
                    googleButtonScale = 0.95 // تأثير الضغط
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    googleButtonScale = 1.0 // إعادة الزر إلى حجمه الطبيعي بعد فترة قصيرة
                }
            }) {
                HStack {
                    Image("google_logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    Text("تسجيل الدخول بواسطة Google")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding()
                .background(Color.black)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .scaleEffect(googleButtonScale) // إضافة تأثير الضغط
            }

            // زر تسجيل الدخول بواسطة Apple
            Button(action: {
                withAnimation {
                    appleButtonScale = 0.95 // تأثير الضغط
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    appleButtonScale = 1.0 // إعادة الزر إلى حجمه الطبيعي بعد فترة قصيرة
                }
            }) {
                HStack {
                    Image(systemName: "apple.logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.white)
                    Text("تسجيل الدخول بواسطة Apple")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .padding()
                .background(Color.black)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                .scaleEffect(appleButtonScale) // إضافة تأثير الضغط
            }
        }
        .padding(.horizontal, 0)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}



