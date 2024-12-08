//
//  AddViewToDo.swift
//  Muscle
//
//  Created by abdallah negm on 28/11/2024.
//

import SwiftUI

struct AddViewToDo: View {
    @Binding var tasks: [(String, Date, Bool)]
    @Environment(\.dismiss) var dismiss

    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // حقل إدخال اسم المهمة
                    TextField("Enter task name", text: $taskName)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .multilineTextAlignment(isArabic(text: taskName) ? .trailing : .leading) // ضبط الاتجاه

                    // اختيار تاريخ المهمة
                    DatePicker("Select date", selection: $taskDate, in: Date()..., displayedComponents: .date)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal)

                    // زر إضافة المهمة
                    Button(action: {
                        if !taskName.isEmpty {
                            tasks.append((taskName, taskDate, false))
                            dismiss()
                        }
                    }) {
                        Text("Add Task")
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.orange)
                            .cornerRadius(8)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Add Task")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.orange)
                }
            }
        }
    }

    // دالة للتحقق من اللغة
    private func isArabic(text: String) -> Bool {
        guard let firstCharacter = text.first else { return false }
        let scalarValue = firstCharacter.unicodeScalars.first?.value ?? 0
        return (scalarValue >= 0x0600 && scalarValue <= 0x06FF)
    }
}

struct AddViewToDo_Previews: PreviewProvider {
    @State static var sampleTasks: [(String, Date, Bool)] = []

    static var previews: some View {
        AddViewToDo(tasks: $sampleTasks)
    }
}
