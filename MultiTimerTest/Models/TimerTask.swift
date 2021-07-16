//
//  TimerTask.swift
//  MultiTimerTest
//
//  Created by Zhansaya Ayazbayeva on 2021-07-15.
//

import Foundation


class TimerTask {
    typealias OnUpdate = (Int) -> Void
    typealias Pause = (Bool) -> Void
    
    let id: UUID
    let name: String
    var secondsLeft: Int
    
    var onUpdate: OnUpdate?
    var pause: Pause?
    
    var isComplete: Bool {
        return secondsLeft == 0
    }
    
    func countTick() {
        secondsLeft -= 1
        onUpdate?(secondsLeft)
    }
    
    var onPause: Bool
    func setOnPause() {
        self.onPause.toggle()
        pause?(self.onPause)
    }
    
    init(name: String, secondsLeft: Int) {
        self.id = UUID()
        self.name = name
        self.secondsLeft = secondsLeft
        onPause = false
    }
}
