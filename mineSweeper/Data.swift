//
//  Data.swift
//  mineSweeper
//
//  Created by home on 17/11/21.
//

import Foundation


enum Action: String, CaseIterable {
    case Tap
    case DTap
    case Long
    case n0
    
    var index: Int {
        switch self{
        case .Long:return 0
        case .Tap: return 1
        case .DTap: return 2
        case .n0: return 3
        }
    }
}


struct TapAction {
    init(){
        open = .Tap
        flag = .DTap
        autoOpen = .Long
        autoFlag = .Long
    }
    var open: Action
    var flag: Action
    var autoOpen: Action
    var autoFlag: Action
}

var action = TapAction()
