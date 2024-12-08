//
// TimerView.swift
//  Muscle
//
//  Created by abdallah negm on 24/11/2024.
//

import SwiftUI

struct StopwatchView: View {
    @State private var timeElapsed: Double = UserDefaults.standard.double(forKey: "timeElapsed")
    @State private var timerRunning = UserDefaults.standard.bool(forKey: "timerRunning")
    @State private var timer: Timer?
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color.black, Color.gray]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer()

                    // الساعة مع العقارب
                    ZStack {
                        // إطار الساعة
                        Circle()
                            .stroke(lineWidth: 10)
                            .foregroundColor(.white.opacity(0.2))
                            .frame(width: geometry.size.width / 1.5, height: geometry.size.width / 1.5)
                        
                        // عقرب الساعات
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 4, height: geometry.size.width / 4)
                            .offset(y: -geometry.size.width / 8)
                            .rotationEffect(Angle.degrees(hourAngle()))
                            .animation(.easeInOut(duration: 0.5), value: timeElapsed)

                        // عقرب الدقائق
                        Capsule()
                            .fill(Color.white)
                            .frame(width: 3, height: geometry.size.width / 3.5)
                            .offset(y: -geometry.size.width / 7)
                            .rotationEffect(Angle.degrees(minuteAngle()))
                            .animation(.easeInOut(duration: 0.5), value: timeElapsed)

                        // عقرب الثواني
                        Capsule()
                            .fill(Color.red)
                            .frame(width: 2, height: geometry.size.width / 3)
                            .offset(y: -geometry.size.width / 6)
                            .rotationEffect(Angle.degrees(secondAngle()))
                            .animation(.easeInOut(duration: 0.5), value: timeElapsed)

                        // النقطة المركزية
                        Circle()
                            .fill(Color.white)
                            .frame(width: 10, height: 10)

                        // عرض عداد التايمر داخل الساعة
                        Text(timeString(from: timeElapsed))
                            .font(.system(size: 40, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding()
                            .offset(y: 45) // هنا يتم تعديل مكان النص
                    }


                    Spacer()

                    // الأزرار
                    HStack {
                        Button(action: {
                            if self.timerRunning {
                                self.stopTimer()
                            } else {
                                self.startTimer()
                            }
                        }) {
                            Text(timerRunning ? "Stop" : "Start")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(timerRunning ? Color.red : Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Spacer().frame(width: 20)

                        Button(action: {
                            self.resetTimer()
                        }) {
                            Text("Reset")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                saveTimerState()
            }
        }
        .onAppear {
            if timerRunning {
                startTimer()
            }
        }
    }

    // باقي الدوال نفسها
    private func hourAngle() -> Double {
        let hours = timeElapsed / 3600
        return (hours.truncatingRemainder(dividingBy: 12)) * 30
    }

    private func minuteAngle() -> Double {
        let minutes = timeElapsed / 60
        return (minutes.truncatingRemainder(dividingBy: 60)) * 6
    }

    private func secondAngle() -> Double {
        let seconds = timeElapsed.truncatingRemainder(dividingBy: 60)
        return seconds * 6
    }

    func startTimer() {
        if !timerRunning {
            self.timerRunning = true
            UserDefaults.standard.set(true, forKey: "timerRunning")
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                self.timeElapsed += 0.01
                UserDefaults.standard.set(self.timeElapsed, forKey: "timeElapsed")
            }
        }
    }

    func stopTimer() {
        if timerRunning {
            self.timer?.invalidate()
            self.timerRunning = false
            UserDefaults.standard.set(false, forKey: "timerRunning")
        }
    }

    func resetTimer() {
        self.timer?.invalidate()
        self.timeElapsed = 0
        self.timerRunning = false
        UserDefaults.standard.set(false, forKey: "timerRunning")
        UserDefaults.standard.set(0, forKey: "timeElapsed")
    }

    func saveTimerState() {
        UserDefaults.standard.set(timeElapsed, forKey: "timeElapsed")
        UserDefaults.standard.set(timerRunning, forKey: "timerRunning")
    }

    func timeString(from time: Double) -> String {
        if time < 3600 {
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            let milliseconds = Int((time * 100).truncatingRemainder(dividingBy: 100))
            return String(format: "%02d:%02d:%02d", minutes, seconds, milliseconds)
        } else {
            let hours = Int(time) / 3600
            let minutes = (Int(time) % 3600) / 60
            let seconds = Int(time) % 60
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
    }
}
