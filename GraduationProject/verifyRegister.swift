//
//  verifyRegister.swift
//  smtp
//
//  Created by 呂沄 on 2023/7/12.
//

import SwiftUI
import SwiftSMTP

struct verifyRegister: View {
    
    var aViewInstance = ContentView()
    
    @Binding var verify :Int
//    @Binding var userName :String
    @Binding var mail :String
    @Binding var pass :String
    
    @State var set_date: Date = Date()
    @State var Set_date: String = ""
    @State var Verify = ""
    @State var messenge = ""
    //    @State var timeRemaining = 300
    @State var timeRemaining = 40
    @State var verificationCode:Int = 0
    @State var verifyNumber:Int = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    struct UserData : Decodable {
        var userId: String?
        var email: String
        var password: String
        var create_at: String
        var message: String
    }
    
    
    var body: some View {
        VStack {
            VStack {
                Text("剩餘時間：\(timeRemaining / 60)分 \(timeRemaining % 60)秒")
                    .onReceive(timer) { _ in
                        if timeRemaining > 0 {
                            timeRemaining -= 1
                        }
                    }
                    .padding(10)
                    .frame(width: 400)
                
                Button {
                    print("verify - 再次發送驗證碼")
                    timeRemaining = 40
//                    Task {
//                        //                        verify = 0
//                        let verificationCode = await random()
//                        await sendMail(verificationCode)
//                    }
                    DispatchQueue.global().async {
                        verificationCode =  random()
                        sendMail(verificationCode)
                    }
                    //                    aViewInstance.mix()
                } label: {
                    Text("重新發送驗證碼")
                }
                .padding(10)
                
            }
            HStack {
                Text("您的驗證碼：")
                TextField("驗證碼", text: $Verify)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.numberPad)
                    .padding(10)
            }
            Button {
                print("verify - 進行驗證中")
                doVerify()
            } label: {
                Text("進行驗證")
            }
            Text(messenge)
                .foregroundColor(Color.red)
        }
        .navigationTitle("驗證帳號")
    }
    
    func doVerify() {
        // 如果上個畫面的驗證碼還存在的話使用上個畫面的驗證碼去判斷使用者是否輸入錯誤
        if (verify != 0){
            verifyNumber = verify
        } else {
            // 如果上個畫面的驗證碼為0使用新的驗證碼去判斷
            verifyNumber = verificationCode
        }
        //        print("驗證碼為：\(verify)")
        print("verify - 驗證碼為：\(verifyNumber)")
        print("verify - 使用者輸入為：\(Verify)")
        if (timeRemaining == 0) {
            print("verify - 時效已過，請重新再驗證一次")
            messenge = "時效已過，請重新再驗證一次"
        } else {
            //            if (Verify == String(verify)) {
            if (Verify == String(verifyNumber)) {
                // 將使用者資料加入資料庫
                print("verify - 驗證碼輸入正確")
                messenge = "使用者輸入正確"
                setTime()
                register()
            } else {
                print("verify - 驗證碼輸輸入錯誤，請重新輸入")
                messenge = "驗證碼輸輸入錯誤，請重新輸入"
            }
        }
    }
    
    //    private func random() async {
    //        verify = Int.random(in: 1..<99999999)
    //        print("隨機變數為：\(verify)")
    //    }
    
//    private func random() async -> Int {
    private func random()  -> Int {
        // 如果重新寄送驗證碼的話，上個畫面的驗證碼紀錄會為0
        verify = 0
        self.verificationCode = Int.random(in: 1..<99999999)
        print("verify - 隨機變數為：\(self.verificationCode)")
        return self.verificationCode
    }
    
    //    func sendMail() async {
//    func sendMail(_ verificationCode: Int) async {
    func sendMail(_ verificationCode: Int)  {
        let smtp = SMTP(
            hostname: "smtp.gmail.com",     // SMTP server address
            email: "3430yun@gmail.com",        // username to login
            password: "knhipliavnpqxwty"            // password to login
        )
        
        //        let megaman = Mail.User(name: "coco", email: "3430coco@gmail.com")
        print("verify - aViewInstance.email:\(mail)")
        let megaman = Mail.User(name: "我習慣了使用者", email: mail)
        let drLight = Mail.User(name: "Yun", email: "3430yun@gmail.com")
        
        
        let mail = Mail(
            from: drLight,
            to: [megaman],
            subject: "歡迎使用我習慣了！這是您的驗證信件",
            text: "以下是您的驗證碼： \(String(self.verificationCode))"
        )
        
        smtp.send(mail) { (error) in
            if let error = error {
                print("verify - \(error)")
            } else {
                print("verify - Send email successful")
            }
        }
    }
    func setTime() {
        Set_date = dateToDateString(set_date)
    }
    
    func dateToDateString(_ date: Date) -> String {
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: date)
        print(dateString)
        return dateString
    }
    
    func register() {
        class URLSessionSingleton {
            static let shared = URLSessionSingleton()
            let session: URLSession
            private init() {
                let config = URLSessionConfiguration.default
                config.httpCookieStorage = HTTPCookieStorage.shared
                config.httpCookieAcceptPolicy = .always
                session = URLSession(configuration: config)
            }
        }
        
//        let url = URL(string: "http://127.0.0.1:8888/account/register.php")!
        let url = URL(string: "http://163.17.136.73:443/account/register.php")!
//        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = ["email": mail, "password": pass, "create_at": Set_date]
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("verify - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("verify - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    //                    print(String(data: data, encoding: .utf8)!)
                    
                    let userData = try decoder.decode(UserData.self, from: data)
                    
                    if (userData.message == "User registered successfully") {
                        print("============== verifyView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("regiest - userDate:\(userData)")
                        print("使用者ID為：\(userData.userId ?? "N/A")")
                        print("使用者email為：\(userData.email)")
                        print("註冊日期為：\(userData.create_at)")
                        print("message：\(userData.message)")
                        UserDefaults.standard.set(true, forKey: "signIn")
                        print("============== verifyView ==============")
                        
                    } else if (userData.message == "not yet filled") {
                        print("verifyMessage：\(userData.message)")
                        messenge = "請確認電子郵件、使用者名稱、密碼都有輸入"
                    } else if (userData.message == "email is registered") {
                        print("verify - Message：\(userData.message)")
                        messenge = "電子郵件已被註冊過 請重新輸入"
                    } else {
                        print("verify - Message：\(String(data: data, encoding: .utf8)!)")
                        messenge = "註冊失敗請重新註冊"
                    }
                } catch {
                    print("verify - 解碼失敗：\(error)")
                    messenge = "註冊失敗請重新註冊"
                }
            }
            // 測試
            //            guard let data = data else {
            //                print("No data returned from server.")
            //                return
            //            }
            //            if let content = String(data: data, encoding: .utf8) {
            //                print(content)
            //            }
        }
        .resume()
    }
}

struct verifyRegister_Previews: PreviewProvider {
    static var previews: some View {
        @State var verify: Int = 00000000
//        @State var userName: String = "userName"
        @State var mail: String = "Email"
        @State var pass: String = "password"
        NavigationView {
            verifyRegister(verify: $verify, mail: $mail,pass:$pass)
        }
    }
}
