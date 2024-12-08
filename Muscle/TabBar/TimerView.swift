//
//  TimersView.swift
//  Muscle
//
//  Created by abdallah negm on 28/11/2024.
//

import SwiftUI
import UserNotifications

struct TimerView: View {
    @State private var selectedHours: Int = 0
    @State private var selectedMinutes: Int = 0
    @State private var selectedSeconds: Int = 0
    @State private var timeRemaining: Int = 0
    @State private var totalDuration: Int = 0
    @State private var isRunning: Bool = false
    @State private var timer: DispatchSourceTimer?

    var body: some View {
        VStack {
            Spacer()

            // الدائرة المتحركة
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)

                Circle()
                    .trim(from: 0.0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color.orange, Color.red]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progress) // أنيميشن مستمر
                
                VStack {
                    Text(formatTime(timeRemaining))
                        .font(.custom("HelveticaNeue", size: 50))
                        .monospacedDigit()
                        .foregroundColor(.white)
                    
                    Text("\(Int(progress * 100))%")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.7))
                }
            }
            .frame(width: 250, height: 250)
            .padding(.bottom, 50)
            
            if !isRunning {
                HStack {
                    Picker("Hours", selection: $selectedHours) {
                        ForEach(0...23, id: \.self) { hour in
                            Text("\(hour) h")
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 150)
                    
                    Picker("Minutes", selection: $selectedMinutes) {
                        ForEach(0...59, id: \.self) { minute in
                            Text("\(minute) m")
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 150)
                    
                    Picker("Seconds", selection: $selectedSeconds) {
                        ForEach(0...59, id: \.self) { second in
                            Text("\(second) s")
                                .font(.system(size: 30))
                                .foregroundColor(.orange)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 100, height: 150)
                }
                .padding()
            }
            
            Spacer()
            
            HStack {
                Button(action: {
                    toggleTimer()
                }) {
                    Text(isRunning ? "Pause" : "Start")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isRunning ? Color.orange : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    resetTimer()
                }) {
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isRunning && timeRemaining == 0) // إلغاء تعطيل الزر عند التوقف
            }
            .padding()
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }

    // MARK: - Helper Functions

    var progress: CGFloat {
        guard totalDuration > 0 else { return 1.0 }
        return CGFloat(timeRemaining) / CGFloat(totalDuration)
    }

    func toggleTimer() {
        if isRunning {
            // عند الضغط على التوقف (pause)
            isRunning = false
            timer?.cancel()
            timer = nil // إلغاء التايمر بعد الإيقاف
        } else {
            // عند الضغط على البدء (start)
            if timeRemaining == 0 {
                // إذا كانت قيمة timeRemaining صفر، نقوم بتعيينها بناءً على القيم المحددة من قبل المستخدم
                timeRemaining = (selectedHours * 3600) + (selectedMinutes * 60) + selectedSeconds
                totalDuration = timeRemaining
            }
            guard timeRemaining > 0 else { return }
            isRunning = true
            startCountdown()
        }
    }

    func resetTimer() {
        // إيقاف التايمر وإعادة تعيين القيم
        isRunning = false
        timeRemaining = 0
        totalDuration = 0
        selectedHours = 0
        selectedMinutes = 0
        selectedSeconds = 0
        timer?.cancel()
        timer = nil // التأكد من إلغاء التايمر عند إعادة تعيينه
    }

    func startCountdown() {
        timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
        timer?.schedule(deadline: .now(), repeating: .seconds(1))
        timer?.setEventHandler {
            DispatchQueue.main.async {
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                    self.isRunning = false
                    self.sendNotification()
                }
            }
        }
        timer?.resume()
    }

    func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Timer Finished"
        content.body = "The countdown timer has finished."
        content.sound = UNNotificationSound.default

        let request = UNNotificationRequest(identifier: "timerNotification", content: content, trigger: nil)
        UNUserNotificationCenter.current().add(request)
    }

    func formatTime(_ totalSeconds: Int) -> String {
        let hours = totalSeconds / 3600
        let minutes = (totalSeconds % 3600) / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView()
    }
}
