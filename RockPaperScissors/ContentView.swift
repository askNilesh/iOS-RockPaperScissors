//
//  ContentView.swift
//  RockPaperScissors
//
//  Created by Nilesh Rathod on 20/04/23.
//

import SwiftUI

struct CapsuleButtonStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 100)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(Capsule())
        
    }
}


extension View{
    func capsuleButtonStyle() -> some View {
        self.modifier(CapsuleButtonStyle())
    }
    
    func titleStyle() -> some View {
        self.modifier(TitleStyle())
    }
    
    func smallTextStyle() -> some View {
        self.modifier(SmallTextStyle())
    }
}

struct TitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.black)
    }
}

struct SmallTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.title)
            .foregroundColor(.white)
    }
}



struct ContentView: View {
    
    @State private var gameMoves = ["Rock", "Paper", "Scissors"]
    
    @State private var computerMove = Int.random(in: 0..<3)
    
    @State private var gameResult = ""
    
    @State private var allowUserToWin = Bool.random()
    
    var correctChoice: Int {
        if allowUserToWin {
            switch computerMove {
            case 0: return 1
            case 1: return 2
            case 2: return 0
            default: return 0
            }
        } else {
            switch computerMove {
            case 0: return 2
            case 1: return 0
            case 2: return 1
            default: return 0
            }
        }
    }
    
    @State private var userScore = 0
    
    @State private var userCorrect = false
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    
    var body: some View {
        NavigationView{
            ZStack {
                
                LinearGradient(gradient: Gradient(colors: [Color(red: 0.5, green: 0.4, blue: 0.2),
                                                           Color.red]),
                               startPoint: .top, endPoint: .bottom)
                VStack(spacing:30) {
                    
                    Text("The computer choses...")
                        .smallTextStyle()
                    
                    Text("\(gameMoves[computerMove])")
                        .fontWeight(.black)
                        .titleStyle()
                    
                    if allowUserToWin {
                        Text("Beat the computer!")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .titleStyle()
                    } else {
                        Text("Let the computer win!")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    
                    
                    ForEach(0..<gameMoves.count){ position in Button(gameMoves[position], action: {
                        self.battle(position)
                    })
                    .capsuleButtonStyle()
                    }
                    
                    VStack(spacing: 25) {
                        Text("Your score is: \(userScore)")
                            .smallTextStyle()
                        
                        Text("Get to 10 to win!")
                            .smallTextStyle()
                    }
                    
                }
            }
            .navigationTitle("Rock, Paper & Scissors")
            .navigationBarTitleDisplayMode(.automatic)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text(alertTitle),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("Let's play!")) {
                        self.resetGame()
                    })
            }
            
        }
    }
    
    func resetGame() {
        let previousChosenMove = computerMove
        
        while previousChosenMove == computerMove {
            computerMove = Int.random(in: 0...2)
        }
        
        allowUserToWin = Bool.random()
    }
    
    func battle(_ number: Int) {
        
        if number == correctChoice {
            if userScore == 10 {
                alertTitle = "You win!"
                alertMessage = """
                            Your final score is: \(userScore + 1)
                            Play again?
                            """
                userScore = 0
            } else {
                userCorrect = true
                alertTitle = "Correct"
                userScore += 1
                alertMessage = """
                            You're so smart!
                            Your score is: \(userScore)
                            Keep going!
                            """
            }
        } else {
            userCorrect = false
            alertTitle = "Incorrect"
            userScore -= 1
            alertMessage = """
                        The correct answer was \(gameMoves[correctChoice]).
                        Your score is: \(userScore)
                        Have another go?
                        """
        }
        
        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
