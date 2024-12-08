//
//  MainTabBarView.swift
//  Muscle
//
//  Created by abdallah negm on 27/11/2024.
//

import SwiftUI

struct MainTabBarView: View {
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            // التبويب الأول - الصفحة الرئيسية
            NavigationStack {
                HomeView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            }
            .tag(0)

            // التبويب الثاني - TimerView
            NavigationStack {
                StopwatchView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "stopwatch.fill")
                    Text("Stop Watch")
                }
            }
            .tag(1)

            // التبويب الثالث - Timer
            NavigationStack {
                TimerView()
            }
            .tabItem {
                VStack {
                    Image(systemName: "timer")
                    Text("Timers")
                }
            }
            .tag(2)

            // التبويب الرابع - ToDo
            NavigationStack {
                ToDoView() // عرض صفحة ToDo
            }
            .tabItem {
                VStack {
                    Image(systemName: "checkmark.circle.fill") // يمكنك اختيار أي أيقونة
                    Text("ToDo")
                }
            }
            .tag(3)
        }
        .onAppear {
            // تغيير خلفية شريط التبويبات إلى الأسود
            UITabBar.appearance().backgroundColor = .systemGray

            // تعيين لون الأيقونات والنصوص في شريط التبويبات إلى الأسود بشكل افتراضي
            UITabBar.appearance().unselectedItemTintColor = .black

            // تعيين لون الأيقونات والنصوص في شريط التبويبات إلى البرتقالي عند التحديد
            UITabBar.appearance().tintColor = .orange
        }
        .accentColor(.orange) // تغيير اللون عند تحديد التبويب إلى البرتقالي
    }
}

struct MainTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabBarView()
    }
}
