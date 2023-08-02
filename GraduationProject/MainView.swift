//
//  MainView.swift
//  GraduationProject
//
//  Created by heonrim on 4/24/23.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var taskStore: TaskStore
    var body: some View {
        TabView {
            SpacedView(ReviewChecked0: false, ReviewChecked1: false, ReviewChecked2: false, ReviewChecked3: false)
                .tabItem {
                    Image(systemName: "house")
                    Text("首頁")
                }
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("行事曆")
                }
        }
    }
}

//struct CalendarListView: View {
//    var body: some View {
//        Text("Hello, World!")
//    }
//}

struct MainView_Previews: PreviewProvider {
    @EnvironmentObject var taskStore: TaskStore
    static var previews: some View {
        let taskStore = TaskStore()
        MainView()
            .environmentObject(taskStore)
    }
}
