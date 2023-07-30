//
//  CalendarView.swift
//  GraduationProject
//
//  Created by heonrim on 3/27/23.
//

import SwiftUI
import EventKit

struct Event: Identifiable {
    let id = UUID()
    let title: String
    let date: Date
}

struct CalendarView: View {
//    @ObservedObject var taskStore = TaskStore()
    @EnvironmentObject var taskStore: TaskStore
    @State var selectedDate = Date()
    @State var showModal = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.white
                VStack {
                    Text("行事曆")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 40)
                    
                    Divider().frame(height: 1).background(.gray.opacity(0.4))
                    
                    datePicker()
                    
                    Divider().frame(height: 1).background(.gray.opacity(0.4))
                    
                    eventList()
                    
                    Spacer()
                }
            }
            .onAppear() {
                print("taskStore:\(taskStore)")
                print("taskStore.tasks_Calendar:\(taskStore.tasks)")
            }
        }
    }
    
    func datePicker() -> some View {
        DatePicker("Select Date", selection: $selectedDate,
                   in: ...Date.distantFuture, displayedComponents: .date)
            .datePickerStyle(.graphical)
            .onChange(of: selectedDate) { newValue in
                selectedDate = newValue
            }
    }
    
//    func eventList() -> some View {
//        let filteredTasks = taskStore.tasksForDate(selectedDate)
//
//
//        return List(filteredTasks) { task in
//            Text(task.title)
//        }
//    }
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
//    func eventList() -> some View {
//        return List(taskStore.tasks) { task in
//            VStack(alignment: .leading) {
////                Text(task.title)
//                // 顯示日期，根據當前選擇日期是 DATE1、DATE2 還是 DATE3 顯示相應的日期
//                if formattedDate(selectedDate) == formattedDate(task.nextReviewDate) {
//                    Text(task.title)
//                        .font(.headline)
//                    Text("第一天")
//                        .font(.subheadline)
//                } else {
//                    Text("selectedDate:\(selectedDate)")
//
//                    Text("nextReviewDate:\(task.nextReviewDate)")
//                    Text("今日沒有行程")
//                        .font(.headline)
//                }
//            }
//        }
//    }
//    func eventList() -> some View {
//        let filteredTasks = taskStore.tasksForDate(selectedDate)
//
//        return List(filteredTasks) { task in
//            VStack(alignment: .leading) {
////                Text(task.title)
//                // 顯示日期，根據當前選擇日期是 DATE1、DATE2 還是 DATE3 顯示相應的日期
//                if formattedDate(selectedDate) == formattedDate(task.nextReviewDate) {
//                    Text(task.title)
//                        .font(.headline)
//                    Text("第一天")
//                        .font(.subheadline)
//                } else {
//                    Text("selectedDate:\(selectedDate)")
//
//                    Text("nextReviewDate:\(task.nextReviewDate)")
//                    Text("今日沒有行程")
//                        .font(.headline)
//                }
//            }
//        }
//    }
    func eventList() -> some View {
        let filteredTasks = taskStore.tasksForDate(selectedDate)
        
        return Group {
            if filteredTasks.isEmpty {
                // If there are no tasks, display "今日沒有行程" message
                Text("今日沒有行程")
                    .font(.headline)
                    .padding(.vertical)
            } else {
                // If there are tasks, display the task list
                List(filteredTasks) { task in
                    VStack(alignment: .leading) {
                        if formattedDate(selectedDate) == formattedDate(task.nextReviewDate) {
                            Text(task.title)
                                .font(.headline)
                            Text("第一天")
                                .font(.subheadline)
                        } else {
                            Text("selectedDate:\(selectedDate)")
                            Text("nextReviewDate:\(task.nextReviewDate)")
                        }
                    }
                }
            }
        }
    }

}


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}

