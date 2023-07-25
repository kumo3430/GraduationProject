//
//  LoginView.swift
//  GraduationProject
//
//  Created by heonrim on 5/23/23.
//

import SwiftUI
import FirebaseAuth
import GoogleSignIn
import Firebase

struct LoginView: View {
    var body: some View {
        
        ZStack{
            
            // LinearGradient: 用來創建漸層顏色的視圖，這裡創建了一個由三種不同顏色組成的漸層背景
            // startPoint 和 endPoint: 用於指定漸層的起點和終點，這裡設置為 .top 和 .bottom，表示漸層從頂部到底部
            // edgesIgnoringSafeArea(.all): 這個修飾器用於忽略安全區域，讓漸層顏色佔滿整個螢幕
            LinearGradient(gradient: .init(colors: [Color("Color"),Color("Color1"),Color("Color2")]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            // 根據螢幕高度的不同，顯示不同的內容。
            if UIScreen.main.bounds.height > 800{
                LoginHome()
            } else{
                // 當螢幕高度小於 800 時，使用這個捲動視圖來顯示
                ScrollView(.vertical, showsIndicators: false) {
                    LoginHome()
                }
            }
        }
    }
}

struct LoginHome : View {
    
    @State var index = 0

    var body : some View{
        
        VStack{
            Image("logo")
                .resizable()
                .frame(width: 200, height: 180)
            HStack{
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index = 0
                    }
                }) {
                    Text("Existing")
                        .foregroundColor(self.index == 0 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }.background(self.index == 0 ? Color.white : Color.clear)
                    .clipShape(Capsule())
                
                Button(action: {
                    withAnimation(.spring(response: 0.8, dampingFraction: 0.5, blendDuration: 0.5)){
                        self.index = 1
                    }
                }) {
                    Text("New")
                        .foregroundColor(self.index == 1 ? .black : .white)
                        .fontWeight(.bold)
                        .padding(.vertical, 10)
                        .frame(width: (UIScreen.main.bounds.width - 50) / 2)
                }.background(self.index == 1 ? Color.white : Color.clear)
                    .clipShape(Capsule())
            }.background(Color.black.opacity(0.1))
                .clipShape(Capsule())
                .padding(.top, 25)
            
            if self.index == 0{
                Login()
            }
            else{
                SignUp()
            }
            
            if self.index == 0{
                Button(action: {
                    
                }) {
                    Text("Forget Password?")
                        .foregroundColor(.white)
                }
                .padding(.top, 20)
            }
            
            GoogleSigninBtn {
                FireAuth.share.signinWithGoogle(presenting: getRootViewController()) { error in
                    print("GoogleLoginERROR: \(String(describing: error))")
                }
            }
            HStack(spacing: 15){
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

struct Login : View {
    
    @State var mail = ""
    @State var pass = ""
    @State var isPasswordVisible = false
    
    var body : some View{
        
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    TextField("Enter Email Address", text: self.$mail)
                }.padding(.vertical, 20)
                
                Divider()

                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if isPasswordVisible {
                        TextField("Password", text: self.$pass)
                    } else {
                        SecureField("Password", text: self.$pass)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                }.padding(.vertical, 20)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            
            Button(action: {
                // 我要輸入登入的function
                // 登入成功後要改成true
            }) {
                Text("LOGIN")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
            }.background(
                // 創建一個線性漸層背景
                LinearGradient(gradient: .init(colors: [Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }
}

struct SignUp : View {
    
    @State var mail = ""
    @State var pass = ""
    @State var repass = ""
    @State var isPasswordVisible = false
    
    var body : some View{
        
        VStack{
            VStack{
                HStack(spacing: 15){
                    Image(systemName: "envelope")
                        .foregroundColor(.black)
                    
                    TextField("Enter Email Address", text: self.$mail)
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    
                    if isPasswordVisible {
                        TextField("Password", text: self.$pass)
                    } else {
                        SecureField("Password", text: self.$pass)
                    }
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.black)
                    }
                }.padding(.vertical, 20)
                
                Divider()
                
                HStack(spacing: 15){
                    Image(systemName: "lock")
                        .resizable()
                        .frame(width: 15, height: 18)
                        .foregroundColor(.black)
                    SecureField("Re-Enter", text: self.$repass)
                    Button(action: {
                    }) {
                        Image(systemName: "eye")
                            .foregroundColor(.black)
                    }
                }.padding(.vertical, 20)
            }
            .padding(.vertical)
            .padding(.horizontal, 20)
            .padding(.bottom, 40)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            Button(action: {
                // 我要輸入註冊的function
            }) {
                Text("SIGNUP")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 100)
            }.background(
                LinearGradient(gradient: .init(colors: [Color("Color2"),Color("Color1"),Color("Color")]), startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(8)
            .offset(y: -40)
            .padding(.bottom, -40)
            .shadow(radius: 15)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
