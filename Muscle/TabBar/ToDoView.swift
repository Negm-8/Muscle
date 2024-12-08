//
//  ToDoView.swift
//  Muscle
//
//  Created by abdallah negm on 28/11/2024.
//

import SwiftUI

struct ToDoView: View {
    @State private var showAddViewToDo = false
    @State private var tasks: [(String, Date, Bool)] = []

    var body: some View {
        NavigationStack {
            VStack {
                if tasks.isEmpty {
                    VStack(spacing: 20) {
                        Image(systemName: "list.bullet.rectangle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Text("No Tasks Yet")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.white.opacity(0.8))
                        
                        Text("Add tasks to get started!")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.6))
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(tasks.indices, id: \.self) { index in
                                let task = tasks[index]
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(task.0)
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    
                                        Text(formatDate(task.1))
                                            .font(.subheadline)
                                            .foregroundColor(.white.opacity(0.7))
                                    }
                                    Spacer()
                                    
                                    Button(action: {
                                        tasks[index].2.toggle()
                                    }) {
                                        Image(systemName: task.2 ? "checkmark.circle.fill" : "circle")
                                            .font(.title2)
                                            .foregroundColor(task.2 ? .orange : .orange)
                                    }
                                }
                                .padding(12)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(task.2 ? Color.orange.opacity(0.7) : Color.black.opacity(0.7))
                                )
                                .contextMenu {
                                    Button(action: {
                                        deleteTask(at: IndexSet([index]))
                                    }) {
                                        Label("Delete", systemImage: "trash.fill")
                                    }
                                }
                            }
                        }
                        .padding(10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddViewToDo.toggle()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 27))
                            .foregroundColor(.orange)
                    }
                }
            }
            .sheet(isPresented: $showAddViewToDo) {
                AddViewToDo(tasks: $tasks)
            }
            .navigationTitle("To Do List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
