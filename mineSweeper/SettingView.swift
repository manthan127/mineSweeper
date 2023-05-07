//
//  SettingView.swift
//  mineSweeper
//
//  Created by home on 17/11/21.
//

import SwiftUI




struct SettingView: View {
    @State var open = action.open
    @State var flag = action.flag
    @State var autoOpen = action.autoOpen
    @State var autoFlag = action.autoFlag
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Open")
            Picker(selection: $open, label: Text("Picker")  , content: {
                ForEach (Action.allCases[0..<3], id: \.self) { i in
                    Text(i.rawValue)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Flag")
            Picker(selection: $flag, label: Text("Picker")  , content: {
                ForEach (Action.allCases[0..<3], id: \.self) { i in
                    Text(i.rawValue)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Auto open")
            Picker(selection: $autoOpen, label: Text("Picker")  , content: {
                ForEach (Action.allCases, id: \.self) { i in
                    Text(i.rawValue)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
            
            Text("Auto flag")
            Picker(selection: $autoFlag, label: Text("Picker")  , content: {
                ForEach (Action.allCases, id: \.self) { i in
                    Text(i.rawValue)
                }
            })
            .pickerStyle(SegmentedPickerStyle())
        }
        .padding()
        .onChange(of: open, perform: { _ in
            if open == flag {
                flag = Action.allCases[(open.index+1) % 3]
            }
            action.open = open
        })
        .onChange(of: flag, perform: { _ in
            if open == flag {
                for i in 0..<3 {
                    if Action.allCases[i] == open {
                        open = Action.allCases[(flag.index+1) % 3]
                        break
                    }
                }
            }
            action.flag = flag
        })
        .onChange(of: autoOpen, perform: { _ in
            action.autoOpen = autoOpen
        })
        .onChange(of: autoFlag, perform: { _ in
            action.autoFlag = autoFlag
        })
    }
    
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
