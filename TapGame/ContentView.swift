//
//  ContentView.swift
//  TapGame
//
//


struct picItem{
    var name:String;
    var index:Int;
    
}

import SwiftUI

struct ContentView: View {
    
    
    
    let picList:[picItem] = [
        picItem(name: "apple", index: 0),
        picItem(name: "dog", index: 1),
        picItem(name: "egg", index: 2),
    ];
    @State private var currentIndex: Int = 0
    @State private var targetIndex: Int = Int.random(in: 0..<3)
    @State private var score: Int = 0
    @State private var difficulty: Difficulties = .easy
    @State private var timer = Timer.publish(every: Difficulties.easy.rawValue,
                                             on: .main, in: .common).autoconnect()
    @State private var onGame: Bool = true
    @State private var showAlert: Bool = false
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    enum Difficulties: Double, CaseIterable {
        case easy = 1
        case medium = 0.5
        case hard = 0.2
        
        var delay: Double {
            rawValue
        }
        
        var title : String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }}
    
    
    
    var body: some View {
        VStack {
            HStack(){
                if !onGame {
                    Menu("Difficulty : \(difficulty.title)"){
                        menuButtons(level: .easy)
                        menuButtons(level: .medium)
                        menuButtons(level: .hard)
                    }
                }
                Spacer()
                Text("Score: \(score)")
            }
            Image( picList[currentIndex].name).resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.tint).frame(
                    height: 300
                ).onTapGesture {
                    onImageTapped()
                }
            Text("Target: \(picList[targetIndex].name)")
            if !onGame
            {
                Button("Restart", action: {
                    restartGame()
                 
                }).padding(.top,10)
            }
        }.padding()
        .onReceive(timer, perform: { _ in
            changePic()
        }).alert(alertTitle, isPresented: $showAlert) {
            Button("OK", action: {
                
            })
        } message: {
            Text(alertMessage)
        }
        
    };
    
    
    
    
    func changePic() {
        currentIndex = (currentIndex + 1) % picList.count
    }

    func onImageTapped() {
        if currentIndex == targetIndex {
            score += 1
            alertTitle = "Correct!"
            alertMessage = "You scored a point."
        } else {
            score -= 1
            alertTitle = "Wrong!"
            alertMessage = "Better luck next time."
        }

        showAlert = true
        onGame = false
        timer.upstream.connect().cancel()
    }

    func restartGame() {
     
        targetIndex = Int.random(in: 0..<picList.count)
        onGame = true
        timer = Timer.publish(every: difficulty.rawValue, on: .main, in: .common).autoconnect()
    }

    private func menuButtons(level: Difficulties) -> some View {
        Button(level.title) {
            difficulty = level
        }
    }
    
}



#Preview {
    ContentView()
}
