//
//  DetailsView.swift
//  Muscle
//
//  Created by abdallah negm on 01/12/2024.
//

import SwiftUI

struct DetailsView: View {
    @State private var isEditing = false
    @State private var editedTask: (String, Date, Bool, [(String, Double)], [UIImage])
    
    var task: (String, Date, Bool, [(String, Double)], [UIImage]) // البيانات المدخلة من HomeView مع الصور
    
    @Environment(\.locale) var locale: Locale
    
    init(task: (String, Date, Bool, [(String, Double)], [UIImage])) {
        _editedTask = State(initialValue: task) // Initialize the edited task with the original task data
        self.task = task
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                // إضافة HStack للزر في أعلى الصفحة على اليمين
                HStack {
                    Spacer() // يجعل الزر في اليمين
                    Button(action: {
                        isEditing.toggle()
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange) // تغيير اللون إلى البرتقالي
                    }
                    .padding()
                }
                
                // عرض التفاصيل الأخرى
                VStack(spacing: 25) {
                    // تعديل اسم المهمة
                    HStack {
                        Text("Name:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if isEditing {
                            TextField("Task Name", text: $editedTask.0)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                        } else {
                            Text(editedTask.0)
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                    
                    // تعديل تاريخ المهمة
                    HStack {
                        Text("Date:")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        if isEditing {
                            DatePicker("", selection: $editedTask.1, displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .labelsHidden()
                                .foregroundColor(.white)
                        } else {
                            Text(formatDate(editedTask.1))
                                .font(.title3)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.vertical, 12)
                    .padding(.horizontal, 16)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                    
                    // عرض قائمة التمارين
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Exercises:")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(.bottom, 15)
                        
                        ForEach(editedTask.3.indices, id: \.self) { index in
                            let exercise = editedTask.3[index]
                            HStack {
                                if isEditing {
                                    // Allow editing exercise name and weight
                                    TextField("Exercise \(index + 1)", text: Binding(
                                        get: { exercise.0 },
                                        set: { editedTask.3[index].0 = $0 }
                                    ))
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    TextField("Weight", value: Binding(
                                        get: { exercise.1 },
                                        set: { editedTask.3[index].1 = $0 }
                                    ), format: .number)
                                    .keyboardType(.numberPad) // يظهر كيبورد الأرقام فقط
                                    .font(.subheadline)
                                    .foregroundColor(.orange)
                                } else {
                                    Text("\(index + 1). \(exercise.0)")
                                        .font(.headline)
                                       
                                        .foregroundColor(.white)
                                        
                                        Spacer()
                                        
                                        Text("\(exercise.1, specifier: "%.2f") kg")
                                            .font(.subheadline)
                                            .foregroundColor(.orange)
                                    }
                                }
                                .padding(.vertical, 10)
                                .padding(.horizontal, 16)
                                .background(RoundedRectangle(cornerRadius: 12).fill(Color.white.opacity(0.2)))
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                        
                        // عرض الصور
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Images:")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .padding(.bottom, 15)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    ForEach(editedTask.4, id: \.self) { image in
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal, 16)
                    }
                }
            }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
        
        // Helper function to format the date
        func formatDate(_ date: Date) -> String {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.locale = locale
            return formatter.string(from: date)
        }
    }

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        // تم تمرير جميع القيم المطلوبة (String, Date, Bool, [(String, Double)], [UIImage])
        DetailsView(task: ("Sample Task", Date(), false, [("Exercise 1", 70.5), ("Exercise 2", 60.0)], [UIImage(named: "sampleImage") ?? UIImage()]))
            .environment(\.locale, Locale(identifier: "en")) // اللغة الإنجليزية
        DetailsView(task: ("مثال للمهمة", Date(), false, [("تمرين 1", 70.5), ("تمرين 2", 60.0)], [UIImage(named: "sampleImage") ?? UIImage()]))
            .environment(\.locale, Locale(identifier: "ar")) // اللغة العربية
    }
}
