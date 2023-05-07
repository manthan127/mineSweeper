//
//  Board.swift
//  mineSweeper
//
//  Created by home on 12/11/21.
//

import SwiftUI

struct Land: View {
    @State var land: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 15)
    @State var mined: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 15)
    
    @State var bombDetected: Int = 0
    
    @State var bombPos: [Int] = []
    
    @State var win = false{
        didSet {
            if win {
                showAlert = true
                self.timer.upstream.connect().cancel()
                if bestTime == nil {
                    bestTime = time
                }
                else if time < bestTime! {
                    bestTime = time
                }
            }
        }
    }
    @State var lose = false {
        didSet {
            if lose {
                showAlert = true
                self.timer.upstream.connect().cancel()
            }
        }
    }
    @State var showAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    /// Time manage
    @State var startTime = Date()
    
    @State var time: Int = 0
    @AppStorage("bestTime") var bestTime: Int?
    
    @State var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var tappedOnce: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Spacer()
                Spacer()
                Text("\(bombDetected) / 13")
                Spacer()
                HStack {
                    if bestTime == nil { Text("--") }
                    else {
                        Text("best:- \(bestTime!.description)")
                    }
                    Text(time.description)
                        .onReceive(timer, perform: { _ in
                            if tappedOnce {
                                time += 1
                            }
                        })
                }
                .padding(.horizontal)
            }
            ForEach((0..<15), id: \.self) { i in
                HStack(spacing: 0) {
                    ForEach((0..<10), id: \.self) { j in
                        landCellView(i, j)
                    }
                }
            }
        }
        .padding(1)
        .onAppear {
            reset()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("You " + (win ? "won" : "lost")),
                  primaryButton: .default(Text("Home screen"), action: {
                    presentationMode.wrappedValue.dismiss()
                  }),
                  secondaryButton: .default(Text("Play again"), action: {
                    reset()
                  })
            )
        }
    }
    
    func landCellView(_ i: Int,_ j: Int) -> some View {
        ZStack {
            Rectangle()
                .fill(i%2 == j%2 ? Color.white : Color.green)
                .aspectRatio(contentMode: .fit)
                .onTapGesture(count: 2, perform: {
                    if action.flag == .DTap {
                        flaging(i, j)
                    } else if action.open == .DTap {
                        open(i, j)
                    }
                    if action.autoFlag == .DTap {
                        autoFlag(i, j)
                    }
                    if action.autoOpen == .DTap {
                        autoOpen(i, j)
                    }
                })
                .onTapGesture {
                    if action.flag == .Tap {
                        flaging(i, j)
                    } else if action.open == .Tap {
                        open(i, j)
                    }
                    if action.autoFlag == .Tap {
                        autoFlag(i, j)
                    }
                    if action.autoOpen == .Tap {
                        autoOpen(i, j)
                    }
                }
                .onLongPressGesture {
                    if action.flag == .Long {
                        flaging(i, j)
                    } else if action.open == .Long {
                        open(i, j)
                    }
                    if action.autoFlag == .Long {
                        autoFlag(i, j)
                    }
                    if action.autoOpen == .Long {
                        autoOpen(i, j)
                    }
                }
            
            Text(land[i][j] != 0 ? land[i][j] == -1 ? "💥" :"\(land[i][j])" : "•")
            Rectangle()
                .fill((i%2 == j%2 ? Color.orange : Color.red).opacity(mined[i][j] == 1 ? 0 : 1))
                .aspectRatio(contentMode: .fit)
                .allowsHitTesting(false)
            
            if mined[i][j] == -1 {
                Text("🚩")
            }
        }
    }
    
    func reset() {
        timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        land = Array(repeating: Array(repeating: 0, count: 10), count: 15)
        mined = Array(repeating: Array(repeating: 0, count: 10), count: 15)
        
        bombPos = Array((0...149).shuffled()[0..<13])
        bombDetected = 0
        
        win = false
        lose = false
        showAlert = false
        tappedOnce = false
        
        time = 0
        
        for a in bombPos{
            let i = a / 10, j = a % 10
            land[i][j] = -1
            for x in i-1...i+1 {
                for y in j-1...j+1 {
                    if land[safe: x]?[safe: y] ?? -1 != -1{
                        land[x][y] += 1
                    }
                }
            }
        }
    }
    
    func lose(_ i: Int,_ j: Int) {
        if land[i][j] == -1 && mined[i][j] == 1 {
            for n in bombPos {
                if mined[n / 10][n % 10] == 0 {
                    mined[n / 10][n % 10] = 1
                }
            }
            lose = true
        }
    }
    
    func open(_ i: Int,_ j: Int) {
        if mined[i][j] == 0 {
            mined[i][j] = 1
            if land[i][j] == 0{
                openZero(i, j)
            }
            lose(i, j)
            allAreOpen()
        }
        if !tappedOnce {
            
            
            startTime = Date()
            tappedOnce = true
        }
    }
    
    func allAreOpen() {
        for i in 0..<15 {
            for j in 0..<10 where land[i][j] != -1 {
                if mined[i][j] != 1 {
                    return
                }
            }
        }
        win = true
    }
    
    func flaging(_ i: Int,_ j: Int) {
        if mined[i][j] == -1 {
            mined[i][j] = 0
            bombDetected -= 1
        } else if mined[i][j] == 0 {
            mined[i][j] = -1
            bombDetected += 1
            win = bombPos.filter{mined[$0/10][$0%10] == -1} == bombPos
        }
        if !tappedOnce {
            
            tappedOnce = true
        }
    }
    
    func numOfFlage(_ i: Int,_ j: Int) -> Int {
        var c = 0
        for x in i-1...i+1 {
            for y in j-1...j+1 {
                if mined[safe: x]?[safe: y] == -1 {
                    c+=1
                }
            }
        }
        return c
    }
    
    func numOfLand(_ i: Int, _ j: Int) -> Int {
        var c = 0
        for x in i-1...i+1 {
            for y in j-1...j+1 {
                if mined[safe: x]?[safe: y] ?? 1 <= 0 {
                    c+=1
                }
            }
        }
        return c
    }
    
    
    func autoOpen(_ i: Int,_ j: Int) {
        if numOfFlage(i, j) == land[i][j] {
            for x in i-1...i+1 {
                for y in j-1...j+1 {
                    if mined[safe: x]?[safe: y] ?? -1 != -1{
                        open(x, y)
                    }
                }
            }
        }
    }
    
    func autoFlag(_ i: Int,_ j: Int) {
        if numOfLand(i, j) == land[i][j] {
            for x in i-1...i+1 {
                for y in j-1...j+1 {
                    if mined[safe: x]?[safe: y] == 0 {
                        flaging(x, y)
                    }
                }
            }
        }
    }
    
    func openZero(_ i: Int,_ j: Int) {
        for x in i-1...i+1 {
            for y in j-1...j+1 {
                if land[safe: x]?[safe: y] ?? -1 >= 0 && mined[safe: x]?[safe: y] == 0 {
                    mined[x][y] = 1
                    if land[x][y] == 0 {
                        openZero(x, y)
                    }
                }
            }
        }
    }
    
    
}


extension Array{
    subscript(safe index: Index) -> Element? {
        (0..<count) ~= index ? self[index] : nil
    }
}

struct Land_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{Land()}
    }
}
