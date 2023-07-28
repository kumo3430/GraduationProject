//
//  SpacedView.swift
//  SpacedRepetition
//
//  Created by heonrim on 5/1/23.
//

import SwiftUI

// 任務結構，每個任務都具有唯一的識別符
struct Task: Identifiable {
    // 以下是他的屬性
    let id = UUID()
    var title: String
    var description: String
    var nextReviewDate: Date
    var nextReviewTime: Date
}

// 任務存儲類別，用於存儲和管理任務列表
class TaskStore: ObservableObject {
    // 具有一個已發佈的 tasks 屬性，該屬性存儲任務的數組
    @Published var tasks: [Task] = [
        Task(title: "英文", description: "背L2單字", nextReviewDate: Date(), nextReviewTime: Date()),
        Task(title: "國文", description: "燭之武退秦師", nextReviewDate: Date(), nextReviewTime: Date()),
        Task(title: "歷史", description: "中世紀歐洲", nextReviewDate: Date(), nextReviewTime: Date())
    ]
    // 根據日期返回相應的任務列表
    func tasksForDate(_ date: Date) -> [Task] {
        return tasks.filter { Calendar.current.isDate($0.nextReviewDate, inSameDayAs: date) }
    }
    
}

struct SpacedView: View {
    // 用於觀察任務存儲的屬性，當任務存儲的 tasks 屬性發生變化時，將自動刷新視圖。
    @ObservedObject var taskStore = TaskStore()
    
    var body: some View {
        NavigationView {
            // 這是一個 List 的視圖，用於顯示一個項目的列表。$taskStore.tasks 表示綁定到 taskStore 中的 tasks 屬性，使得列表可以動態地反映 tasks 屬性的變化。$task 是一個綁定到 task 的綁定值，表示列表中的每一個項目。
            List($taskStore.tasks) { $task in
                // 這是一個導航連結，用於導航到指定的目標視圖。當用戶點擊列表中的項目時，將導航到 TaskDetailView 視圖，並將相應的 task 傳遞給目標視圖。
                NavigationLink(destination: TaskDetailView(task: task)) {
                    // alignment 參數設置對齊方式，spacing 參數設置子視圖之間的間距
                    VStack(alignment: .leading, spacing: 4) {
                        Text(task.title)
                            .font(.headline)
                        Text(task.description)
                            .font(.subheadline)
                        Text("Start time: \(formattedDate(task.nextReviewDate))")
                            .font(.caption)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("間隔重複")
            .navigationBarItems(leading:
                                    HStack {
                Button {
                    UserDefaults.standard.set(false, forKey: "signIn")
                } label: {
                    Image(systemName: "person.badge.minus")
                }
                
            },
                                // 改1
                                //                                trailing: NavigationLink(destination: AddTaskView(taskStore: taskStore)) {
                                trailing: NavigationLink(destination: AddTaskView()) {
                Image(systemName: "plus")
            }
            )
        }
    }
    
    // 用於將日期格式化為指定的字符串格式
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

// 右上角 新增的button
struct AddTaskView: View {
    @Environment(\.presentationMode) var presentationMode
    // 改1
    //    @ObservedObject var taskStore: TaskStore
    @State var title = ""
    @State var description = ""
    @State var nextReviewDate = Date()
    @State var nextReviewTime = Date()
    @State var messenge = ""
    @State var isError = false
    
    //    @State var messenge = ""
    struct UserData : Decodable {
        var userId: String?
        var category_id: Int
        var todoTitle: String
        var todoIntroduction: String
        var startDateTime: String
        var reminderTime: String
        var todo_id: String
        var repetition1Count: String
        var repetition2Count: String
        var repetition3Count: String
        var repetition4Count: String
        var message: String
    }
    
    //    @State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: nextReviewDate)! }
    }
    
    var body: some View {
        Form {
            // 此部分為欄位上面小小的字
            Section(header: Text("標題").textCase(nil)) {
                TextField("輸入標題", text: $title)
            }
            Section(header: Text("內容").textCase(nil)) {
                TextField("輸入內容", text: $description)
            }
            Section(header: Text("開始時間").textCase(nil)) {
                DatePicker("選擇時間", selection: $nextReviewDate, displayedComponents: [.date])
                DatePicker("提醒時間", selection: $nextReviewTime, displayedComponents: [.hourAndMinute])
            }
            Section(header: Text("間隔學習法日程表")) {
                ForEach(0..<4) { index in
                    HStack {
                        Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                    }
                }
            }
        }
        // 一個隱藏的分隔線
        .listStyle(PlainListStyle())
        .navigationBarTitle("新增任務")
        .navigationBarItems(
            trailing: Button("完成") {
                // 建立一個 Task 物件，傳入使用者輸入的 title、description 和 nextReviewDate。
                //                let task = Task(title: title, description: description, nextReviewDate: nextReviewDate)
                //                let task = Task(title: title, description: description, nextReviewDate: nextReviewDate, nextReviewTime: nextReviewTime)
                
                // 將新建立的 task 加入到 taskStore 的 tasks 陣列中。
                // 這行程式碼試圖將 task 強制轉換為 Task 類型，然後再將其添加到 taskStore.tasks 陣列中。然而，由於 task 已經是 Task 類型，所以這個強制轉換是多餘的，並不會產生任何效果。
                //                taskStore.tasks.append(task as! Task)
                //                taskStore.tasks.append(task )
                
                addStudySpaced()
            }
            // 如果 title 為空，按鈕會被禁用，即無法點擊。
                .disabled(title.isEmpty)
        )
        Text(messenge)
            .foregroundColor(.red)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:MM"
        return formatter.string(from: date)
    }
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func addStudySpaced() {
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
        
        let url = URL(string: "http://127.0.0.1:8888/addStudySpaced.php")!
        //        let url = URL(string: "http://10.21.1.164:8888/account/register.php")!
        var request = URLRequest(url: url)
        //        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "POST"
        let body = ["title": title, "description": description, "nextReviewDate": formattedDate(nextReviewDate),"nextReviewTime": formattedTime(nextReviewTime),"First": formattedDate(nextReviewDates[0]),"third": formattedDate(nextReviewDates[1]),"seventh": formattedDate(nextReviewDates[2]),"fourteenth": formattedDate(nextReviewDates[3]) ]
        print("addStudySpaced - body:\(body)")
        let jsonData = try! JSONSerialization.data(withJSONObject: body, options: [])
        request.httpBody = jsonData
        URLSessionSingleton.shared.session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("addStudySpaced - Connection error: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                print("addStudySpaced - HTTP error: \(httpResponse.statusCode)")
            }
            else if let data = data{
                let decoder = JSONDecoder()
                do {
                    //                    確認api會印出的所有內容
                    print(String(data: data, encoding: .utf8)!)
                    
                    let userData = try decoder.decode(UserData.self, from: data)
                    
                    if (userData.message == "User New StudySpaced successfully") {
                        print("============== verifyView ==============")
                        print(String(data: data, encoding: .utf8)!)
                        print("regiest - userDate:\(userData)")
                        print("使用者ID為：\(userData.userId ?? "N/A")")
                        print("事件種類為：\(userData.category_id)")
                        print("事件名稱為：\(userData.todoTitle)")
                        print("事件簡介為：\(userData.todoIntroduction)")
                        print("開始時間為：\(userData.startDateTime)")
                        print("提醒時間為：\(userData.reminderTime)")
                        print("事件編號為：\(userData.todo_id)")
                        print("第一次間隔重複時間為：\(userData.repetition1Count)")
                        print("第二次間隔重複時間為：\(userData.repetition2Count)")
                        print("第三次間隔重複時間為：\(userData.repetition3Count)")
                        print("第四次間隔重複時間為：\(userData.repetition4Count)")
                        print("addStudySpaced - message：\(userData.message)")
                        DispatchQueue.main.async {
                            isError = false
                            // 如果沒有錯才可以關閉視窗
                            presentationMode.wrappedValue.dismiss()
                        }
                        print("============== verifyView ==============")
                    } else if (userData.message == "The Todo is repeated") {
                        isError = true
                        print("addStudySpaced - message：\(userData.message)")
                        messenge = "已建立過，請重新建立"
                    } else if (userData.message == "New Todo - Error: <br>Incorrect integer value: '' for column 'uid' at row 1") {
                        isError = true
                        print("addStudySpaced - message：\(userData.message)")
                        messenge = "登入出錯 請重新登入"
                    } else  {
                        isError = true
                        print("addStudySpaced - message：\(userData.message)")
                        messenge = "建立失敗，請重新建立"
                    }
                } catch {
                    isError = true
                    print("addStudySpaced - 解碼失敗：\(error)")
                    messenge = "建立失敗，請重新建立"
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

struct TaskDetailView: View {
    @State var task: Task
    @State var isReviewChecked: [Bool] = Array(repeating: false, count: 4)
    
    
    var nextReviewDates: [Date] {
        let intervals = [1, 3, 7, 14]
        return intervals.map { Calendar.current.date(byAdding: .day, value: $0, to: task.nextReviewDate)! }
    }
    
    var body: some View {
        Form {
            Section(header: Text("標題")) {
                TextField("輸入標題", text: $task.title)
            }
            Section(header: Text("內容")) {
                TextField("輸入內容", text: $task.description)
            }
            
            Section(header: Text("提醒時間")) {
                DatePicker("", selection: $task.nextReviewTime, displayedComponents: [.hourAndMinute])
                //                    .disabled(true)
            }
            
            Section(header: Text("間隔學習法日程表")) {
                ForEach(0..<4) { index in
                    HStack {
                        Toggle(isOn: $isReviewChecked[index]) {
                            Text("第\(formattedInterval(index))天： \(formattedDate(nextReviewDates[index]))")
                        }
                    }
                }
            }
        }
        .navigationBarTitle("任務")
        .navigationBarItems(
            trailing: Button("完成", action: handleCompletion)
        )
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func formattedInterval(_ index: Int) -> Int {
        let intervals = [1, 3, 7, 14]
        return intervals[index]
    }
    
    func handleCompletion() {
        // Handle the completion action here
    }
}


struct SpacedView_Previews: PreviewProvider {
    static var previews: some View {
        // 改1
        SpacedView()
        AddTaskView()
    }
}
