//
//  TimerView.swift
//  Muscle
//
//  Created by abdallah negm on 24/11/2024.
//

import SwiftUI
import PhotosUI

// AddView
struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var tasks: [(String, Date, Bool, [(String, Double)], [UIImage])]

    @State private var taskName: String = ""
    @State private var taskDate: Date = Date()
    @State private var exercises: [(String, String)] = Array(repeating: ("", ""), count: 2)  // عدد التمارين الي هتضاف
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Task Name
                    TextField("Enter name", text: $taskName)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // Task Date
                    DatePicker("Select date", selection: $taskDate, displayedComponents: .date)
                        .padding()
                        .background(Color.white.opacity(0.3))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                        .padding(.horizontal)
                    
                    // Exercises Fields
                    ForEach(exercises.indices, id: \.self) { index in
                        HStack {
                            // Exercise Name Field
                            TextField("Exercise name", text: $exercises[index].0)
                                .padding()
                                .background(Color.white.opacity(0.3))
                                .cornerRadius(8)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            // Weight Field with Positioned Delete Button
                            ZStack {
                                TextField("Weight (kg)", text: $exercises[index].1)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .background(Color.white.opacity(0.3))
                                    .cornerRadius(8)
                                    .foregroundColor(.white)
                                    .frame(width: 100)
                                    .onChange(of: exercises[index].1) { newValue in
                                        exercises[index].1 = newValue.filter { "0123456789.".contains($0) }
                                        if exercises[index].1.count > 6 {
                                            exercises[index].1 = String(exercises[index].1.prefix(6))
                                        }
                                    }
                                
                                // Remove Button (Only for indices >= 1)
                                if index >= 1 {
                                    Button(action: {
                                        exercises.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: 40, y: -20) // Adjust this to your liking
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    
                    // Add More Exercises
                    HStack {
                        Button(action: {
                            exercises.append(("", ""))
                        }) {
                            Text("Add More")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        // Add Images
                        Button(action: {
                            isImagePickerPresented = true
                        }) {
                            Text("Add Image")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $isImagePickerPresented) {
                            ImagePicker(selectedImage: $selectedImages)
                        }
                    }
                    .padding(.top, 10)
                    
                    // Display Selected Images with Remove Button
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(selectedImages.indices, id: \.self) { index in
                                ZStack(alignment: .topTrailing) {
                                    Image(uiImage: selectedImages[index])
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                    
                                    Button(action: {
                                        selectedImages.remove(at: index)
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.red)
                                            .background(Color.white)
                                            .clipShape(Circle())
                                    }
                                    .offset(x: -5, y: 5)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Save Task
                    Button(action: {
                        let validExercises = exercises.compactMap { (name, weight) -> (String, Double)? in
                            guard let weightValue = Double(weight), !name.isEmpty else { return nil }
                            return (name, weightValue)
                        }
                        
                        if !taskName.isEmpty && !validExercises.isEmpty {
                            let newTask = (taskName, taskDate, false, validExercises, selectedImages)
                            tasks.append(newTask)
                            dismiss()
                        } else {
                            print("Invalid data entered!")
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
            }
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
        }
    }
}

// ImagePicker View
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: [UIImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                let provider = result.itemProvider
                
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                        DispatchQueue.main.async {
                            if let image = object as? UIImage {
                                self?.parent.selectedImage.append(image)
                            } else {
                                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                            }
                        }
                    }
                }
            }
        }
    }
}

struct AddView_Previews: PreviewProvider {
    @State static var sampleTasks: [(String, Date, Bool, [(String, Double)], [UIImage])] = []
    
    static var previews: some View {
        AddView(tasks: $sampleTasks)
    }
}
