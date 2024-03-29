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
    @State private var isButtonTapped = false
    @State private var tappedNumber = -1
    
    @State private var showingScore = false
    @State private var scoreTitle: String = ""
    @State private var totalScore: Int = 0
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
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
    
    struct FlageImage: View {
        var name: String
        var body: some View {
            Image(name)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
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
                    .accessibilityElement(children: .combine)
                    ForEach(0..<3){
                        number in
                        Button {
                            flagTapped(number)
                        }label: {
                            FlageImage(name: countries[number])
                                .accessibilityLabel(labels[countries[number], default: "Unknwon flag"])
                        }
                            .rotation3DEffect(.degrees(isButtonTapped && tappedNumber == number ? 0.0 : 360.0), axis: (x: 0, y: 1, z: 0))
                            .opacity(isButtonTapped && tappedNumber != number ? 0.25 : 1.0)
                            .scaleEffect(isButtonTapped && tappedNumber != number ? 0.75 : 1.0)
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
        isButtonTapped = false
        tappedNumber = -1
    }
    
    func flagTapped(_ number: Int) {
        withAnimation {
            isButtonTapped = true
            tappedNumber = number
        }
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
