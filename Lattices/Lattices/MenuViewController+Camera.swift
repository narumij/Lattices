//
//  MenuViewController+Camera.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/05.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension MenuViewController {

    enum ViewDirectionType : Int {
        case initial,d100,d010,d001,d111,n100,n010,n001,n111
    }

    fileprivate func orientationOf( _ cell: CrystalCell_t, type: ViewDirectionType ) -> SCNQuaternion {
        let from = (look:SCNVector3(0,0,1),up:SCNVector3(0,1,0))
        var orientation = SCNQuaternionIdentity
        switch type {
        case .d100:
            let to = (look:SCNVector3(-cell.direction100),up:SCNVector3(cell.normal010))
            orientation = SCNQuaternion(from:from,to:to)
        case .d010:
            let to = (look:SCNVector3(-cell.direction010),up:SCNVector3(cell.normal100))
            orientation = SCNQuaternion(from:from,to:to)
        case .d001:
            let to = (look:SCNVector3(-cell.direction001),up:SCNVector3(cross(cell.normal100,cell.direction001)))
            orientation = SCNQuaternion(from:from,to:to)
        case .d111:
            let up = normalize(cross(cell.direction001,cell.direction111))
            let to = (look:SCNVector3(-cell.direction111),up:SCNVector3(-up))
            orientation = SCNQuaternion(from:from,to:to)
        case .n100:
            let to = (look:SCNVector3(-cell.normal100),up:SCNVector3(-cell.direction010))
            orientation = SCNQuaternion(from:from,to:to)
        case .n010:
            let to = (look:SCNVector3(cell.normal010),up:SCNVector3(cell.direction001))
            orientation = SCNQuaternion(from:from,to:to)
        case .n001:
            let to = (look:SCNVector3(-cell.normal001),up:SCNVector3(-cell.direction010))
            orientation = SCNQuaternion(from:from,to:to)
        case .n111:
            let up = normalize(cross(cell.normal111,cell.direction001))
            let to = (look:SCNVector3(cell.normal111),up:SCNVector3(-up))
            orientation = SCNQuaternion(from:from,to:to)
        default:
            break
        }
        return orientation
    }

    fileprivate func orientationOf( _ cell: CrystalCell_t, tag: Int ) -> SCNQuaternion {
        var orientation = SCNQuaternionIdentity
        switch tag {
        case 0:
            orientation = orientationOf(cell, type: .d100)
        case 1:
            orientation = orientationOf(cell, type: .d010)
        case 2:
            orientation = orientationOf(cell, type: .d001)
        case 3:
            orientation = orientationOf(cell, type: .d111)
        case 4:
            orientation = orientationOf(cell, type: .n100)
        case 5:
            orientation = orientationOf(cell, type: .n010)
        case 6:
            orientation = orientationOf(cell, type: .n001)
        case 7:
            orientation = orientationOf(cell, type: .n111)
        default:
            break
        }
        return orientation
    }

    @IBAction func cameraAction( _ sender: UIButton? ) {
        if let cell = crystal?.info.cell {
            if let button = sender {
                var info : [AnyHashable: Any] = [:]
                info["tag"] = sender!.tag
                info["text"] = sender?.titleLabel?.text
                #if false
                    SCNTransaction.begin()
                    SCNTransaction.setAnimationDuration(0.5)
                    let orientation = orientationOf(cell, tag: button.tag)
                    crystal?.camera.setOrientation(orientation: orientation)
                    crystal?.camera.refresh()
                    SCNTransaction.commit()
                #else
                    let orientation = orientationOf(cell, tag: button.tag)
                    crystal?.camera.rig.rotate(orientation: orientation)
                    crystal?.camera.refreshAnimated()
                #endif
                updateUI()
//                SharedAppDelegate().currentDocument?.crystal.cameraRig.refresh()
            }
        }
    }

    func updateCameras() {
        let cameraOrientation = crystal?.camera.rig.orientation
        if let cell = crystal?.info.cell {
            _ = cameraItems.map{
                let orientation = orientationOf(cell, tag: $0.tag)
                $0.selected = orientation =~~ (cameraOrientation ?? SCNQuaternionIdentity)
            }
        }
    }
}

extension MenuViewController {

    func prepareCameras() {
        #if true
            cameras.axis = .vertical
            mainStackView.addArrangedSubview( cameras )
            cameras.addArrangedSubview( lineView() )
            cameras.addArrangedSubview( spaceView(lineSpace) )
            cameras.addArrangedSubview( titleView("View Direction") )
            let cameraData = ["a axis","b axis","c axis","[111]","N(100)","N(010)","N(001)","N(111)"]
            cameraItems = cameraData.enumerated().map({
                let item = itemView( $0.element, action: #selector(cameraAction), tag: $0.offset )
                cameras.addArrangedSubview( item )
                return item
            })
            cameras.addArrangedSubview( spaceView(12) )
        #endif
    }

}






