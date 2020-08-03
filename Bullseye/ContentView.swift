//
//  ContentView.swift
//  Bullseye
//
//  Created by Jolec Palustre on 6/24/20.
//  Copyright © 2020 Jolec Palustre. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var alertIsVisible = false
    @State var sliderValue = 50.0
    @State var target = Int.random(in: 1...100)
    @State var score = 0
    @State var currentRound = 1
    let midnightBlue = Color(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 102.0 / 255.0)
    
    struct LabelStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.white)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
     }
    }
    
    struct ValueStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.yellow)
                .modifier(Shadow())
                .font(Font.custom("Arial Rounded MT Bold", size: 24))
     }
    }
    
    struct ButtonLargeTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 18))
     }
    }
    
    struct ButtonSmallTextStyle: ViewModifier {
        func body(content: Content) -> some View {
            content
                .foregroundColor(Color.black)
                .font(Font.custom("Arial Rounded MT Bold", size: 12))
     }
    }
    
    struct Shadow: ViewModifier {
        func body(content: Content) -> some View {
            content
               .shadow(color: Color.black, radius: 5, x:2, y:2)
     }
    }
    
    var body: some View {
     VStack {
        Spacer()
        // Target row
        HStack {
            Text("Put the bullseye as close as you can to:").modifier(LabelStyle())
            Text("\(target)").modifier(ValueStyle())
        }
        Spacer()
        
        // Slider row
        HStack {
            Text("1").modifier(LabelStyle())
            Slider(value: $sliderValue, in: 1...100).accentColor(Color.green)
            Text("100").modifier(LabelStyle())
        }
        Spacer()
        
        // Button row
        Button(action: {
          print("Button pressed!")
            self.alertIsVisible = true
        }) {
            Text(/*@START_MENU_TOKEN@*/"Hit Me!"/*@END_MENU_TOKEN@*/).modifier(ButtonLargeTextStyle())
        }
        .alert(isPresented: $alertIsVisible) { () ->
          Alert in
          return Alert(title: Text("\(alertFeedback())"),
                       message: Text(
                        "The slider's value is \(sliderValueRounded()).\n" +
                        "You scored \(pointsForCurrentRound()) points this round."
          ), dismissButton: .default(Text("Awesome!")) {
              self.score = self.score + self.pointsForCurrentRound()
              self.target = Int.random(in: 1...100)
              self.currentRound = self.currentRound + 1
            })
        }
        .background(Image("Button")).modifier(Shadow())
        Spacer()
        
        // Score row
        HStack {
            Button(action: {self.restartGame()}) {
                HStack{
                    Image("StartOverIcon")
                    Text("Start Over").modifier(ButtonSmallTextStyle())
             }
            }
            .background(Image("Button")).modifier(Shadow())
            Spacer()
            Text("Score:").modifier(LabelStyle())
            Text("\(score)").modifier(ValueStyle())
            Spacer()
            Text("Round:").modifier(LabelStyle())
            Text("\(currentRound)").modifier(ValueStyle())
            Spacer()
            NavigationLink(destination: AboutView()) {
                HStack{
                  Image("InfoIcon")
                  Text("Info").modifier(ButtonSmallTextStyle())
             }
            }
            .background(Image("Button")).modifier(Shadow())
        }
        .padding(.bottom, 20)
       }
     .accentColor(midnightBlue)
     .background(Image("Background"), alignment: .center)
     .navigationBarTitle("BullsEye")
    }
    
    func sliderValueRounded() -> Int {
        Int(sliderValue.rounded())
    }
    
    func pointsForCurrentRound() -> Int{
        let pointsScored = 100 - abs(target - sliderValueRounded())
        
        if pointsScored == 100 {
            return pointsScored + 100
        } else if pointsScored == 99 {
            return pointsScored + 50
        }
        return pointsScored
    }
    
    func alertFeedback() -> String{
        if pointsForCurrentRound() == 200 {
            return "Perfect!"
        } else if pointsForCurrentRound() > 95 {
            return "Almost got it!"
        } else if pointsForCurrentRound() > 90 {
            return "Not bad but not quite there yet!"
        } else {
            return "Are you even trying?"
        }
    }
    
    func restartGame() {
        score = 0
        currentRound = 1
        sliderValue = 50.0
        target = Int.random(in: 1...100)
    }
}

struct ContentView_Previews:
 PreviewProvider {
    static var previews: some View {
        ContentView().previewLayout(.fixed(width: 896, height: 414))
    }
}
