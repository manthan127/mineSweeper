//
//  ContentView.swift
//  mineSweeper
//
//  Created by home on 12/11/21.
//

import SwiftUI

enum difficulty {
    case easy
    case meadium
    case hard
}


struct ContentView: View {
    let width = UIScreen.main.bounds.width/3
    var body: some View {
        VStack(spacing: 15) {
            NavigationLink(
                destination: Land(),
                label: {
                    Text("Play")
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .frame(width: width, height: (width/3)*2)
                        .background(RadialGradient(gradient: Gradient(colors: [Color.white, Color.blue]), center: .init(x: 0.4, y: 0.4), startRadius: 5, endRadius: 70))
                        .cornerRadius(10)
                })
            NavigationLink(
                destination: SettingView(),
                label: {
                    Text("Setting")
                })
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
