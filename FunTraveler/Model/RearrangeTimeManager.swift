//
//  RearrangeTimeManager.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/19.
//

import UIKit
import CoreLocation

class RearrangeTimeManager {
    
    func rearrangeSchedulesTime(_ schedule: [Schedule]) -> [Schedule] {
        var previousEndTime = ""
        var newSchedules: [Schedule] = schedule
        
        for (index, plan) in newSchedules.enumerated() {
            do {
                
                let distance = calculateTrafficTime(index, newSchedules)
                
                let totalDuration = plan.duration + distance/60
                
                let date = try TimeManager.getDateFromString(startTime: plan.startTime, duration: totalDuration)
                
                let endTime = "\(date.endHours):\(String(format: "%02d", date.endMinutes))"
                
                if plan.startTime == previousEndTime || previousEndTime == "" {
                    previousEndTime = endTime
                    continue
                }
                
                newSchedules[index].startTime = previousEndTime
                
                let newDate = try TimeManager.getDateFromString(startTime: previousEndTime, duration: totalDuration)
                
                let newEndTime = "\(newDate.endHours):\(String(format: "%02d", newDate.endMinutes))"
                
                previousEndTime = newEndTime
                
            } catch let wrongError {
                print("Error message: \(wrongError), Please add correct time!")
            }
        }
        return newSchedules
    }
    
    func calculateTrafficTime(_ index: Int, _ schedule: [Schedule]) -> Double {
        let lastIndex = schedule.count - 1
        
        if index == lastIndex || lastIndex <= 0 {
            return 0
        }
        let coordinate₀ = CLLocation(
            latitude: schedule[index].position.lat,
            longitude: schedule[index].position.long
        )
        
        let coordinate₁ = CLLocation(
            latitude: schedule[index+1].position.lat,
            longitude: schedule[index+1].position.long
        )
        return coordinate₀.distance(from: coordinate₁)/1000.ceiling(toInteger: 1)
    }
    
}
