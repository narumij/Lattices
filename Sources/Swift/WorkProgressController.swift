//
//  WorkProgressController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/07/30.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import Foundation


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}


func postProgressKey( _ name : WorkProgressController.JobKind, progress : Double ) {
    SharedAppDelegate().workProgressController.updateProgress( name, progress: progress )
}

class WorkProgressController: NSObject {

    static let ProgressKeyNotification = "WorkProgressControllerProgressKeyNotification"

    static let WillStartProgressNotification = "WorkProgressControllerWillStartProgressNotification"
    static let DidChangeProgressNotification = "WorkProgressControllerDidChangeProgressNotification"
    static let DidFinishProgressNotification = "WorkProgressControllerDidFinishProgressNotification"

    static let JobNameKey = "JobNameKey"
    static let JobProgressKey = "JobProgressKey"
    static let WorkNameKey = "WorkNameKey"

    var jobInfo : [JobKind:Int64] = WorkProgressController.fileLoadJobInfo

    func postNotification( _ name: String ) {
        NotificationCenter.default.post( name: Notification.Name(rawValue: name),
                                                                   object: self)
    }

    func prepareForFileLoad() {
        context = nil
        jobInfo = WorkProgressController.fileLoadJobInfo
        progress = Progress( totalUnitCount: totalUnitCount )

        postNotification( WorkProgressController.WillStartProgressNotification )

        progressChildren = [:]
        _ = jobInfo.map{
            let child = Progress( totalUnitCount: 100 )
            child.kind = ProgressKind(rawValue: $0.0.rawValue)
            progressChildren[$0.0] = child
            progress?.addChild( child, withPendingUnitCount: $0.1 )
        }
        progressChildren[.Prepare]?.completedUnitCount = 100
        currentProgress = progressChildren[.Start]
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
    }

    var totalUnitCount : Int64 {
        return jobInfo.map{ $0.1 }.reduce(0){ $0 + $1 }
    }

    // parse 13.8% rest 58.2%
    // updateCrystal 42.6
    // content node 15.5

    enum JobKind : String {
        case Prepare,Start,FileLoading
        case ReadCell,ReadSymop,ReadSites,ReadAniso,ReadBonds,ReadHBonds
        case PrimeAtom,PrimeBond
        case ConcreteAtom,ConcreteBond
        case SceneType,SceneAtom,SceneBond
        case ContentAtom,ContentBond,ConcreteHydrogenBond,ContentLine
        case UpdateContentCenterAndRadius
        case UpdateScene
        case finish
        case unknown
    }

    static let fileLoadJobInfo : [JobKind:Int64] = [
        .Prepare      : 1,
        .Start        : 3,
        .FileLoading  : 10,
        .ReadCell     : 1,
        .ReadSymop    : 2,
        .ReadSites    : 2,
        .ReadAniso    : 2,
        .ReadBonds    : 2,
        .ReadHBonds   : 3,
        .PrimeAtom    : 5,
        .PrimeBond    : 30,
        .ConcreteAtom : 3,
        .ConcreteBond : 18,
        .SceneType    : 1,
        .SceneAtom    : 1,
        .SceneBond    : 3,
        .ContentAtom  : 2,
        .ContentBond  : 45,
        .ConcreteHydrogenBond  : 3,
        .ContentLine  : 1,
        .UpdateContentCenterAndRadius : 3,
        .UpdateScene  : 3
    ]

    var progress : Progress?
    var progressChildren: [JobKind:Progress] = [:]
    var currentProgress : Progress?

    func cleanUp() {
        progress = nil
        progressChildren = [:]
        currentProgress = nil
    }

    var working : Bool {
        return currentProgress != nil
    }
    weak var context : AnyObject?

    fileprivate func _updateProgress( _ name: JobKind, progress : Double ) {

            let noteProgress = progressChildren[name]
            if noteProgress != currentProgress {
                currentProgress?.completedUnitCount = 100
                currentProgress = noteProgress
            }

            if name == .finish {
                progressChildren[ jobInfo.map{$0}.last?.0 ?? .unknown ]?.completedUnitCount = 100
                RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
                currentProgress = nil
                postNotification( WorkProgressController.DidFinishProgressNotification )
            } else {
                let count = Int64( progress * 100 )
                if currentProgress?.completedUnitCount < count {
                    currentProgress?.completedUnitCount = count
                }
                postNotification( WorkProgressController.DidChangeProgressNotification )
            }
    }

    func updateProgress( _ name: JobKind, progress : Double ) {
        OperationQueue.main.addOperation({
            self._updateProgress( name, progress: progress )
        })
    }

}

