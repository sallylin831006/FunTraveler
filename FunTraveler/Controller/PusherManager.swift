//
//  PusherManager.swift
//  FunTraveler
//
//  Created by 林翊婷 on 2022/5/19.
//

import UIKit
import PusherSwift

protocol PusherManagerDelegate: AnyObject {
    func updaateSchedules(tripSchedule: Schedules)
}

class PusherManager: PusherDelegate {
    
    weak var delegate: PusherManagerDelegate?
    
    var pusher: Pusher! //
    
    func listenEvent() {
        let options = PusherClientOptions(host: .cluster(StringConstant.pusherCluster))
        
        pusher = Pusher(key: KeyConstants.pusherKey, options: options)
        
        pusher.delegate = self
        
        let channel = pusher.subscribe(StringConstant.pusherSubscribe)
        
        let _ = channel.bind(eventName: StringConstant.pusherEventName, eventCallback: { (event: PusherEvent) in
            if let data = event.data {
                do {
                    
                    let tripSchedule = try JSONDecoder().decode(
                        Schedules.self,
                        from: data.data(using: .utf8)!
                    )
                    
                    self.delegate?.updaateSchedules(tripSchedule: tripSchedule)
                    
//                    self.updaateSchedules(tripSchedule: tripSchedule)
//                    if tripSchedule.tripId != self.tripId { return }
//                    if tripSchedule.schedules.first == nil {
//                        self.schedule = []
//                        self.tableView.reloadData()
//                    }
//                    if tripSchedule.schedules.first?.day != self.currentDay { return }
//                    self.schedule = tripSchedule.schedules
//                    self.rearrangeTime()
//                    self.tableView.reloadData()
                } catch {
                    print(error)
                }
            }
        })
        
        pusher.connect()
    }
    
//    func updaateSchedules(tripSchedule: Schedules) {
//        delegate?.updaateSchedules(tripSchedule: Schedules)
//    }
    
}
