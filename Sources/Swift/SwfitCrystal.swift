//
//  SwfitCrystal.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/21.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit


#if os(OSX)
    typealias RadiiSizeType = CGFloat
#else
    typealias RadiiSizeType = Float
#endif


class SwiftCrystal : NSObject {

    deinit { debugPrint("deinit \(self)") }

    override init() {
        super.init()
        camera.sceneController = axisSceneController
    }

    var cancelled : Bool = false {
        didSet { prime.cancelled = cancelled }
    }
    private func cancel() { cancelled = true }
    var cifData : CIF = CIF()

    // MARK: -

    func read( url: URL, ofType typeName: String) throws {
        updateData(path:url.path)
        updateCrystal()
    }

    func updateData(path:String) {
        let parser = CIFParser()
        postProgressKey(.FileLoading,progress:0.0)
        do {
            try parser.parse(path)
            postProgressKey(.FileLoading,progress:1.0)
            if cancelled { return }
            cifData = parser.result
        }
        catch {
        }
    }

    // MARK: -

    func updateCrystal() {
        if cancelled { return }
        updateCrystalInformation()
        if cancelled { return }
        generateColorScheme()
        if cancelled { return }
        generatePrimeCrystal()
        if cancelled { return }
        generateConcreteCrystal()
        if cancelled { return }
        generateSceneCrystal()
        if cancelled { return }
        updateContentNode()
        if cancelled { return }
    }

    // MARK: -

    var info = CrystalInfo_t()
    func updateCrystalInformation() {
        info = CrystalInfo_t( cifData: cifData )
        axisSceneController.cell = info.cell
    }

    var colors = CrystalColor([])
    func generateColorScheme() {
        colors = CrystalColor(info.types.map{$0.atomicSymbol})
    }

    var prime = PrimeCrystal_t()
    func generatePrimeCrystal() {
        prime = PrimeCrystal_t( info: info, bonding: bondingMode == .Off ? .off : .on )
//        if bondingRangeMode == .Grouping && prime.bondGroups.count < 2 {
//            bondingRangeMode = .UnitCell
//        }
    }

    var concrete: ConcreteCrystal_t = ConcreteCrystal_t()
    func generateConcreteCrystal() {
        concrete = ConcreteCrystal_t( prime: prime, bonding: bondingMode == .Off ? .off : .on )
    }

    // MARK: -

    let scene = SCNScene()
    let contentsNode = SCNNode()
    var latticeNode = SCNNode()
    let crystalNode = SCNNode()
    var camera = CameraScene_t()
    var axisSceneController = AxisSceneController()

    enum BondingMode : String {
        case Off, On
    }

    var bondingMode : BondingMode = DefaultBondingMode
    static var DefaultBondingMode : BondingMode = .On

    static let didChangeBondingRangeMode = Notification.Name( rawValue: "SwiftCrystalDidChangeBondingRangeModeNotification" )
    var bondingRangeMode : BondingRangeMode = DefaultBondingRangeMode {
        didSet {
            updateBondingRangeMode()
            NotificationCenter.default.post(name: SwiftCrystal.didChangeBondingRangeMode, object: self)
        }
    }

    static var DefaultBondingRangeMode : BondingRangeMode = .UnitCell
    enum BondingRangeMode : String {
        case Nothing, Site, UnitCell, OneStep, Grouping, Limited, Full
    }

    // MARK: -

    var isRadiiUpdated : Bool = false

    var radiiType : RadiiType = SwiftCrystal.stdRadiiType {
        didSet {
            updateRadii();
        }
    }

    var radiiSize : RadiiSizeType = SwiftCrystal.stdRadiiSize {
        didSet {
            updateRadiiSize()
        }
    }

    func sphereSize( _ atomicSymbol: AtomicSymbol, bondingCount : Int ) -> RadiiSizeType {
        let r = radiiType.radius( atomicSymbol )
        if bondingCount == 0 {
            return sphereRadiusScale * r
        }
        let size = max( bondDiameter, radiiSize * r )
        return size
    }

    var sphereRadiusScale : RadiiSizeType {
        return radiiType == .Ellipsoid ? probabilityScale : radiiSize
    }

    var bondSize : RadiiSizeType = SwiftCrystal.stdBondSize {
        didSet {
            updateRadiiSize()
        }
    }

    var bondDiameter : RadiiSizeType {
        return sphereSize( .H, bondingCount: 0 ) * bondSize
    }

    var _probabilityScale : Double {
        return ProbabilityScale( from: Double(radiiSize) )
    }

    var probability : Double {
        return probabilityValue( from: _probabilityScale )
    }

    var probabilityScale : FloatType {
        return FloatType( _probabilityScale )
    }

    // MARK: -

    var latticeHidden : Bool {
        get { return latticeNode.isHidden }
        set(h) { latticeNode.isHidden = h }
    }
    private var sizeProcs : [()->Void] = []
    private var radiiProcs : [()->Void] = []
    private var bondingModeProcs : [() -> Void] = []

    func updateRadii() {
        isRadiiUpdated = true
        _ = radiiProcs.map{ $0() }
        _ = sizeProcs.map{ $0() }
    }

    private func updateRadiiSize() {
        _ = sizeProcs.map{ $0() }
    }

    func updateBondingRangeMode() {
        _ = bondingModeProcs.map{ $0() }
        updateCenterOfGravity()
    }

    // MARK: -

    fileprivate func latticeLines() -> SCNGeometry {
        func lineMaterial() -> SCNMaterial {
            if info.symopHasProblem {
                let l = SCNMaterial()
                l.diffuse.contents = Color.black
                l.specular.contents = Color.black
                l.ambient.contents = Color.black
                l.emission.contents = info.symopHasProblem ? Color.red : Color(white: 0.5, alpha: 1.0)
                return l
            }
            else {
                #if true
                    let l = SCNMaterial()
                    l.diffuse.contents = Color.black
                    l.specular.contents = Color.black
                    l.ambient.contents = Color.black
                    l.emission.contents = Color(white: 0.5, alpha: 1.0)
                    return l
                #else
                    let material = SCNMaterial()
                    material.transparent.contents = UIImage( named: "LatticeBreakTexture" )
                    material.transparent.wrapS = .Repeat
                    material.transparent.wrapT = .Repeat
                    material.transparent.minificationFilter = .Nearest
                    material.transparent.magnificationFilter = .Nearest
                    material.transparent.mipFilter = .None
                    material.transparent.maxAnisotropy = 5.0
                    material.diffuse.contents = Color.blackColor()
                    material.specular.contents = Color.blackColor()
                    return material
                #endif
            }
        }
        let vertices = info.cell.latticeLineVertices
        let g = SCNGeometry.lines( vertices.position, texcoords: vertices.texcoord )
        g.firstMaterial = lineMaterial()
        return g
    }

    // MARK: - Scene

    func updateScene() {
        scene.background.contents = Color.white
        scene.rootNode.addChildNode( contentsNode )
        scene.rootNode.addChildNode( camera.cameraNode() )
        scene.rootNode.addChildNode( camera.lightNode() )
    }

    private func clearContentNode() {
        isRadiiUpdated = false
        for node in contentsNode.childNodes {
            node.removeFromParentNode()
        }
    }

    private func clearCrystalNode() {
        for node in crystalNode.childNodes {
            node.removeFromParentNode()
        }
    }

    var sceneTypes : [SceneType_t] = []
    var sceneAtoms : [SceneAtom_t] = []
    var sceneBonds : [SceneBond_t] = []
    var sceneLineBonds : [SceneLineBond_t] = []
    var sceneHydrogenBonds : [SceneHydrogenBondLines_t] = []

    private func generateSceneCrystal() {

        sceneTypes = info.types.enumerated().map{ SceneType_t( crystal: self, type: $1 ) }
        postProgressKey( .SceneType,progress: 1.0 )
        sceneAtoms = concrete.atoms.enumerated().map{ SceneAtom_t( crystal: self, atom: $1 ) }
        postProgressKey( .SceneAtom,progress: 1.0 )
        let modes : [BondingRangeMode] = [ .UnitCell, .OneStep, .Grouping, .Limited ]
        sceneBonds = []
        if bondingMode == .On {
            sceneBonds = concrete.bonds.enumerated().map{ SceneBond_t( crystal: self, bond: $1 ) }
            sceneLineBonds = modes.map{ SceneLineBond_t( crystal: self, rangeMode: $0 ) }
        }
        sceneHydrogenBonds = modes.map{ SceneHydrogenBondLines_t( crystal: self, rangeMode: $0 ) }
        postProgressKey( .SceneBond, progress: 1.0 )

    }

    private func updateContentNode() {

        _ = contentsNode.childNodes.map{ $0.removeFromParentNode() }
        sizeProcs = []
        radiiProcs = []
        bondingModeProcs = []
        clearContentNode()
        clearCrystalNode()
        latticeNode.geometry = latticeLines()
        latticeNode.castsShadow = false
        contentsNode.addChildNode(latticeNode)
        contentsNode.addChildNode(crystalNode)

//        let wyckoffPointsNode = SCNNode()
//        wyckoffPointsNode.geometry = wyckoffPoints()
//        wyckoffPointsNode.geometry?.firstMaterial = SCNMaterial()
//        wyckoffPointsNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blackColor()
//        contentsNode.addChildNode(wyckoffPointsNode)

        for sceneType in sceneTypes {
            radiiProcs.append( { sceneType.updateRadii() } )
        }

        for sceneAtom in sceneAtoms {
            sceneAtom.contentsNode = crystalNode
            sizeProcs.append( { sceneAtom.updateSize() } )
            bondingModeProcs.append( { sceneAtom.updateRange() } )
        }
        postProgressKey(.ContentAtom,progress:1.0)

        if bondingMode == .On {

            for (i,sceneBond) in sceneBonds.enumerated() {
                sceneBond.contentsNode = crystalNode
                sizeProcs.append( { sceneBond.updateSize() } )
                bondingModeProcs.append( { sceneBond.updateRange() } )
                postProgressKey( .ContentBond, progress: Double(i)/Double(sceneBonds.count) )
            }

            for sceneLineBond in sceneLineBonds {
                sceneLineBond.contentsNode = crystalNode
                bondingModeProcs.append( { sceneLineBond.updateRange() } )
            }

            for sceneHydrogenBond in sceneHydrogenBonds {
                sceneHydrogenBond.contentsNode = crystalNode
                bondingModeProcs.append( { sceneHydrogenBond.updateRange() } )
//                radiiProcs.append( { sceneHydrogenBond.updateRadii() } )
            }
            postProgressKey( .ContentLine, progress: 1.0 )
        }

        updateCenterOfGravity()
        postProgressKey( .UpdateContentCenterAndRadius, progress: 1.0 )
        camera.initialPosition()
        debugPrint("contents update complete.")
    }

    static var stdRadiiType : RadiiType = .Calculated
    static var stdRadiiSize : RadiiSizeType = 1.0
    static var stdBondSize : RadiiSizeType = 0.5

    // MARK: -

    let centerNode = SCNNode()

    // MARK: -

    enum LabelMode {
        case nothing, atomicSymbol, typeSymbol, siteLabel
        case xyz, fract, cartn
        case siteSymmetry, wyckoffLetter
        case symmetryCode, multiplicity, occupancy
        case angle, bondDistance, contactDistance, torsion
    }

    /*
    var labelMode : LabelMode = .nothing {
        didSet{
            updateLabels()
        }
    }

    func updateLabels() {
        _ = sceneAtoms.map{
            $0.updateLabel(labelMode)
        }
        _ = sceneBonds.map{
            $0.updateLabel(labelMode)
        }
    }
*/

}












