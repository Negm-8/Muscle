//
//  ContentView.swift
//  Muscle
//
//  Created by abdallah negm on 24/11/2024.

//import SwiftUI
//
//struct HomeView: View {
//    @State private var showAddView = false
//    @State private var showLoginView = false
//    @State private var tasks: [(String, Date, Bool, [(String, Double)], [UIImage])] = []
//    @State private var showDeleteConfirmation = false
//    @State private var taskToDeleteIndex: Int? = nil
//    @State private var searchText = ""  // حالة لتخزين النص المدخل في شريط البحث
//    @State private var showSearchBar = false  // حالة لإظهار/إخفاء شريط البحث
//    @FocusState private var isSearchFieldFocused: Bool // خاصية التحكم في الفوكس
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                if showSearchBar { // إذا كانت حالة إظهار شريط البحث مفعلة
//                    searchBar
//                }
//
//                if tasks.isEmpty {
//                    emptyTasksView
//                } else {
//                    tasksListView
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(
//                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
//                    .edgesIgnoringSafeArea(.all)
//            )
//            .navigationBarTitleDisplayMode(.inline)
//            .toolbar {
//                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    // عرض زر البحث فقط إذا كانت عدد المهام 10 أو أكثر
//                    if tasks.count >= 10 {
//                        Button(action: { showSearchBar.toggle() }) {
//                            Image(systemName: "magnifyingglass")
//                                .font(.system(size: 24))
//                                .foregroundColor(.orange)
//                        }
//                    }
//                    
//                    Button(action: { showAddView.toggle() }) {
//                        Image(systemName: "plus.circle.fill")
//                            .font(.system(size: 27))
//                            .foregroundColor(.orange)
//                    }
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button(action: { showLoginView.toggle() }) {
//                        Image(systemName: "person.circle.fill")
//                            .font(.system(size: 26))
//                            .foregroundColor(.orange)
//                    }
//                }
//            }
//            .sheet(isPresented: $showAddView) {
//                AddView(tasks: $tasks)
//                    .onDisappear {
//                        // بعد إضافة التمرين، ترتيب المهام من الماضي إلى المستقبل
//                        tasks.sort { $0.1 < $1.1 }
//                    }
//            }
//            .sheet(isPresented: $showLoginView) {
//                LoginView()
//            }
//            .alert(isPresented: $showDeleteConfirmation) {
//                Alert(
//                    title: Text("Confirm Deletion"),
//                    message: Text("Are you sure you want to delete this task?"),
//                    primaryButton: .destructive(Text("Delete")) {
//                        if let index = taskToDeleteIndex {
//                            tasks.remove(at: index)
//                        }
//                    },
//                    secondaryButton: .cancel()
//                )
//            }
//        }
//    }
//    
//    // شريط البحث
//    private var searchBar: some View {
//        HStack {
//            TextField("Search by date...", text: $searchText)
//                .padding(8)
//                .background(Color.white.opacity(0.3))
//                .cornerRadius(8)
//                .foregroundColor(.white)
//                .keyboardType(.numberPad) // تحديد لوحة المفاتيح التي تظهر لإدخال الأرقام فقط
//                .focused($isSearchFieldFocused) // ربط الـ focus
//                .padding(.horizontal)
//            
//            Button(action: {
//                showSearchBar = false
//                searchText = ""  // إعادة تعيين النص عند إخفاء شريط البحث
//            }) {
//                Image(systemName: "xmark.circle.fill")
//                    .font(.system(size: 20))
//                    .foregroundColor(.white)
//                    .padding(.trailing)
//            }
//        }
//        .padding(.top)
//        .onChange(of: showSearchBar) { newValue in
//            if newValue {
//                isSearchFieldFocused = true // عندما يظهر شريط البحث، نركز الفوكس عليه
//            }
//        }
//    }
//
//    private var emptyTasksView: some View {
//        VStack(spacing: 20) {
//            Image(systemName: "list.bullet.rectangle.portrait")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 100, height: 100)
//                .foregroundColor(.gray.opacity(0.7))
//            Text("No Exercises Yet")
//                .font(.title3)
//                .fontWeight(.semibold)
//                .foregroundColor(.white.opacity(0.8))
//            Text("Add exercises and start tracking your progress to get started!")
//                .font(.subheadline)
//                .foregroundColor(.white.opacity(0.6))
//        }
//        .padding()
//    }
//
//    private var tasksListView: some View {
//        ScrollView {
//            VStack(spacing: 10) {
//                ForEach(tasks.indices, id: \.self) { index in
//                    taskRow(index: index)
//                }
//            }
//            .padding(10)
//        }
//    }
//
//    private func taskRow(index: Int) -> some View {
//        let task = tasks[index]
//        let taskName = task.0
//        let taskDate = formatDate(task.1)
//
//        return NavigationLink(destination: DetailsView(task: task)) {
//            HStack {
//                VStack(alignment: .leading, spacing: 5) {
//                    Text(taskName)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                    Text(taskDate)
//                        .font(.subheadline)
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                Spacer()
//            }
//            .padding(12)
//            .background(
//                RoundedRectangle(cornerRadius: 12)
//                    .fill(Color.black.opacity(0.7))
//            )
//        }
//        .contextMenu {
//            Button(action: {
//                taskToDeleteIndex = index
//                showDeleteConfirmation = true
//            }) {
//                Label("Delete", systemImage: "trash.fill")
//            }
//        }
//    }
//
//    private func formatDate(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "d/M/yyyy" // تنسيق اليوم/الشهر/السنة
//        formatter.locale = Locale(identifier: "ar") // التأكد من أن التنسيق باللغة العربية
//        return formatter.string(from: date)
//    }
//
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}


import SwiftUI

struct HomeView: View {
    @State private var showAddView = false
    @State private var showLoginView = false
    @State private var tasks: [(String, Date, Bool, [(String, Double)], [UIImage])] = []
    @State private var showDeleteConfirmation = false
    @State private var taskToDeleteIndex: Int? = nil
    @State private var searchText = ""  // حالة لتخزين النص المدخل في شريط البحث
    @State private var showSearchBar = false  // حالة لإظهار/إخفاء شريط البحث
    @FocusState private var isSearchFieldFocused: Bool // خاصية التحكم في الفوكس

    var body: some View {
        NavigationStack {
            VStack {
                if showSearchBar { // إذا كانت حالة إظهار شريط البحث مفعلة
                    searchBar
                }

                if tasks.isEmpty {
                    emptyTasksView
                } else {
                    tasksListView
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    // عرض زر البحث فقط إذا كانت عدد المهام 10 أو أكثر
                    if tasks.count >= 3 {
                        Button(action: { showSearchBar.toggle() }) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 24))
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Button(action: { showAddView.toggle() }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 27))
                            .foregroundColor(.orange)
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { showLoginView.toggle() }) {
                        Image(systemName: "person.circle.fill")
                            .font(.system(size: 26))
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAddView) {
                AddView(tasks: $tasks)
                    .onDisappear {
                        // بعد إضافة التمرين، ترتيب المهام من الماضي إلى المستقبل
                        tasks.sort { $0.1 < $1.1 }
                    }
            }
            .sheet(isPresented: $showLoginView) {
                LoginView()
            }
            .alert(isPresented: $showDeleteConfirmation) {
                Alert(
                    title: Text("Confirm Deletion"),
                    message: Text("Are you sure you want to delete this task?"),
                    primaryButton: .destructive(Text("Delete")) {
                        if let index = taskToDeleteIndex {
                            tasks.remove(at: index)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // شريط البحث
    private var searchBar: some View {
        HStack {
            TextField("Search by date...", text: $searchText)
                .padding(8)
                .background(Color.white.opacity(0.3))
                .cornerRadius(8)
                .foregroundColor(.white)
                .keyboardType(.numbersAndPunctuation) // استخدام لوحة مفاتيح تدعم الأرقام والفواصل
                .focused($isSearchFieldFocused) // ربط الـ focus
                .padding(.horizontal)
                .onChange(of: searchText) { newValue in
                    // فحص النص المدخل وتحديث المهام بناءً على ذلك
                    filterTasks(by: newValue)
                }
            
            Button(action: {
                showSearchBar = false
                searchText = ""  // إعادة تعيين النص عند إخفاء شريط البحث
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(.trailing)
            }
        }
        .padding(.top)
        .onChange(of: showSearchBar) { newValue in
            if newValue {
                isSearchFieldFocused = true // عندما يظهر شريط البحث، نركز الفوكس عليه
            }
        }
    }

    private func filterTasks(by searchText: String) {
        // تحويل النص المدخل إلى تاريخ (إذا كان بالإمكان)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d/M/yyyy" // تنسيق التاريخ باليوم/الشهر/السنة
        dateFormatter.locale = Locale(identifier: "ar")

        if let searchDate = dateFormatter.date(from: searchText) {
            // تصفية المهام بناءً على التاريخ المدخل
            tasks = tasks.filter { task in
                Calendar.current.isDate(task.1, inSameDayAs: searchDate)
            }
        }
    }

    private var emptyTasksView: some View {
        VStack(spacing: 20) {
            Image(systemName: "list.bullet.rectangle.portrait")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray.opacity(0.7))
            Text("No Exercises Yet")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.8))
            Text("Add exercises and start tracking your progress to get started!")
                .font(.subheadline)
                .foregroundColor(.white.opacity(0.6))
        }
        .padding()
    }

    private var tasksListView: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(tasks.indices, id: \.self) { index in
                    taskRow(index: index)
                }
            }
            .padding(10)
        }
    }

    private func taskRow(index: Int) -> some View {
        let task = tasks[index]
        let taskName = task.0
        let taskDate = formatDate(task.1)

        return NavigationLink(destination: DetailsView(task: task)) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(taskName)
                        .font(.headline)
                        .foregroundColor(.white)
                    Text(taskDate)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.7))
                }
                Spacer()
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.7))
            )
        }
        .contextMenu {
            Button(action: {
                taskToDeleteIndex = index
                showDeleteConfirmation = true
            }) {
                Label("Delete", systemImage: "trash.fill")
            }
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/yyyy" // تنسيق اليوم/الشهر/السنة
        formatter.locale = Locale(identifier: "ar") // التأكد من أن التنسيق باللغة العربية
        return formatter.string(from: date)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
