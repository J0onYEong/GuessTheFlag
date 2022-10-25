//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by 최준영 on 2022/10/21.
//

import SwiftUI

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0..<3)
    @State private var wrongSelection = -1
    
    @State private var showingScore = false
    @State private var scoreTitle: String = ""
    @State private var totalScore: Int = 0
    
    private var scoreAlertMessage: String {
        if scoreTitle == "Wrong" {
            return """
            Score: \(totalScore)
            That is flag of \(countries[wrongSelection]).
            """
        } else if scoreTitle == "Correct" {
            return "Score: \(totalScore)"
        } else {
            return ""
        }
    }
    
    private var maxGame: Int = 8
    @State private var game: Int = 1
    @State private var showingGameResult: Bool = false
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),
            ], center: .top, startRadius: 200, endRadius: 400)
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.weight(.bold))
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    .foregroundStyle(.secondary)
                    ForEach(0..<3){
                        number in
                        Button {
                            flagTapped(number)
                        } label: {
                            Image(countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }.padding()
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("Score: \(totalScore)\nGame: \(game) / \(maxGame)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
        }
        .ignoresSafeArea()
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Ok") { askQuestion() }
        } message: {
            Text(scoreAlertMessage)
        }
        .alert("Game Over", isPresented: $showingGameResult) {
            Button("Restart") {
                reset()
            }
        } message: {
            Text("Good job!\nScore: \(totalScore)")
        }
    }
    
    func askQuestion() {
        //Game is finished
        if game == maxGame {
            showingGameResult = true
            return;
        }
        game += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func flagTapped(_ number: Int) {
        if number == self.correctAnswer {
            wrongSelection = -1
            scoreTitle = "Correct"
            totalScore += 100
        } else {
            wrongSelection = number
            scoreTitle = "Wrong"
            totalScore -= 100
        }
        showingScore.toggle()
    }
    
    func reset() {
        game = 0
        totalScore = 0
        wrongSelection = -1
        scoreTitle = ""
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
