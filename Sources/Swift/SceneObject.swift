//
//  SceneCrystal.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/08/20.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class SceneType_t {
    weak var crystal : SwiftCrystal? = nil
    let type: CrystalAtomType_t

    init( crystal c: SwiftCrystal?, type t: CrystalAtomType_t ) {
        crystal = c
        type = t
        sphere = SCNSphere(radius: 1.0)
        sphere.firstMaterial = material
        cylinder = SCNCylinder(radius: 1.0, height: 1.0)
        cylinder.firstMaterial = bondMaterial

        t.scene = self
    }

    var atomicSymbol : AtomicSymbol { return type.atomicSymbol }

    let sphere : SCNSphere
    let cylinder : SCNCylinder

    let material : SCNMaterial = SCNMaterial()
    let bondMaterial : SCNMaterial = SCNMaterial()

    func updateRadii() {
        if let crystal = crystal {
            material.diffuse.contents = crystal.colors.color( atomicSymbol )
            material.specular.contents = crystal.colors.specularColor( atomicSymbol )
            material.ambient.contents = Color.black
            material.emission.contents = Color.black
            material.shininess = crystal.colors.shininess( atomicSymbol )
            material.reflective.contents = "envmap.jpg"
            material.reflective.intensity = 0.02

            bondMaterial.diffuse.contents = crystal.colors.color( atomicSymbol )
            bondMaterial.specular.contents = Color.darkGray
            bondMaterial.reflective.contents = "envmap.jpg"
            bondMaterial.reflective.intensity = 0.6
        }
    }
}

// MARK: -

class SceneAtom_t {
    weak var crystal: SwiftCrystal?
    // MARK: -
    let atom: ConcreteAtom_t
    let node: SCNNode = SCNNode()
    let textLayer: CATextLayer = CATextLayer()
    // MARK: -
    var contentsNode: SCNNode? = nil {
        didSet {
            contentsNode?.addChildNode(node)
            setupIfNeed()
        }
    }
    init( crystal c: SwiftCrystal?, atom a: ConcreteAtom_t ) {
        crystal = c
        atom = a
//        textLayer.string = atom.siteLabel
        textLayer.fontSize = 8
        textLayer.cornerRadius = 3
    }
    // MARK: -
    let sizeNode = SCNNode()
    let ellipsoidOrth = SCNNode()
    let ellipsoidSize = SCNNode()
    let ellipsoid = SCNNode()
    let ellipsoidX = SCNNode()
    // MARK: -
    var atomicSymbol : AtomicSymbol { return atom.atomicSymbol }
    var startRadius : RadiiSizeType { return 0.0 }
    var bondingCount : Int { return atom.bondingCount }
    // MARK: -
    var sphere : SCNGeometry? {
        return atom.primeAtom.site.type?.scene?.sphere
    }
    var material : SCNMaterial? {
        return atom.primeAtom.site.type?.scene?.material
    }
    // MARK: -
    func setupIfNeed() {
        if hidden == false && node.childNodes.count == 0 {
            setup()
        }
    }
    // MARK: -
    static let primeCylinder : SCNCylinder = SceneAtom_t.Cylinder()
    static func Cylinder() -> SCNCylinder {
        let ellipsoidXMaterial = SCNMaterial()
        ellipsoidXMaterial.diffuse.contents = Color.white
        ellipsoidXMaterial.specular.contents = Color.black
        ellipsoidXMaterial.ambient.contents = Color.white
        ellipsoidXMaterial.emission.contents = Color(white: 0.125, alpha: 1.0)
        let cylinder = SCNCylinder(radius: 1.01, height: 0.1)
        cylinder.firstMaterial = ellipsoidXMaterial
        return cylinder
    }
    // MARK: -
    fileprivate func setup() {

        node.name = atom.siteLabel

        node.addChildNode(ellipsoidOrth)
        ellipsoidOrth.addChildNode(ellipsoidSize)
        ellipsoidSize.addChildNode(ellipsoid)

        node.position = SCNVector3(atom.cartn)
        ellipsoidSize.scale = SCNVector3( startRadius )

        #if false
            ellipsoid.geometry = sphere
        #elseif true
            // 標準のもの
            ellipsoid.geometry = sphere
            let xNode = SCNNode()
            let yNode = SCNNode()
            let zNode = SCNNode()
            xNode.geometry = SceneAtom_t.primeCylinder
            yNode.geometry = SceneAtom_t.primeCylinder
            zNode.geometry = SceneAtom_t.primeCylinder
            yNode.rotation = SCNVector4(1,0,0,M_PI_2)
            zNode.rotation = SCNVector4(0,0,1,M_PI_2)
            ellipsoidX.addChildNode(xNode)
            ellipsoidX.addChildNode(yNode)
            ellipsoidX.addChildNode(zNode)
        #else
            let text = SCNText(string: "\(atom.siteLabel)\n\(atom.siteSymmetry.string)", extrusionDepth: 0.01)
            text.font = UIFont.systemFont( ofSize: 1, weight: UIFontWeightThin )
            text.flatness = 0.1
            text.firstMaterial = SCNMaterial.black
            let textNode = SCNNode()
            textNode.geometry = text
            let (center,_) = textNode.boundingSphere
            textNode.position = SCNVector3(-1.0) * center
//            ellipsoid.geometry = text
            ellipsoid.addChildNode(textNode)
        #endif

        updateRange()
        if crystal?.isRadiiUpdated == true {
            updateSize()
        }
    }
    // MARK: -
    var needUpdateSize = false
    func updateSize() {
        if hidden { needUpdateSize = true; return }
        if let crystal = crystal {
            needUpdateSize = false
            if crystal.radiiType == .Ellipsoid {
                ellipsoid.addChildNode(ellipsoidX)

                let ellipsoidRatio = atom.primeAtom.aniso?.ratio ?? 1.0
                ellipsoidOrth.transform = atom.primeAtom.ellipsoidNode0Transform
                ellipsoidSize.scale = atom.primeAtom.ellipsoidNode1Scale
                    * SCNVector3( crystal.probabilityScale )
                    * SCNVector3( ellipsoidRatio )
                ellipsoidX.scale = SCNVector3(1.0)
            }
            else {
                let size = crystal.sphereSize( atomicSymbol, bondingCount: bondingCount )
                ellipsoidOrth.transform = SCNMatrix4Identity
                ellipsoidSize.scale = SCNVector3( size )
                ellipsoid.transform = SCNMatrix4Identity
                ellipsoidX.scale = SCNVector3(0.9)
                ellipsoidX.removeFromParentNode()
            }
        }
    }
    // MARK: -
    var hidden : Bool {
        var hidden = true
        if let mode = crystal?.bondingRangeMode {
            switch mode {
            case .Site:
                hidden = !atom.isIdentity
            case .UnitCell:
                hidden = atom.chainBondingStep != 0
            case .OneStep:
                hidden = atom.chainBondingStep > 1
            case .Grouping:
                hidden = !atom.isUniquePosition
            case .Limited:
                hidden = false
            default:
                break
            }
        }
        return hidden
    }
    // MARK: -
    func updateRange() {
        setupIfNeed()
        if needUpdateSize { updateSize() }
        if hidden {
            node.removeFromParentNode()
        }
        else if node.parent == nil {
            contentsNode?.addChildNode(node)
        }
    }

    func updateLabel(_ labelMode:SwiftCrystal.LabelMode) {
        switch labelMode {
        case .nothing:
            textLayer.string = ""
        case .atomicSymbol:
            textLayer.string = atomicSymbol.rawValue
            textLayer.fontSize = 18
        case .typeSymbol:
            textLayer.string = atom.primeAtom.site.typeSymbol
            textLayer.fontSize = 12
        case .siteLabel:
            textLayer.string = atom.siteLabel
            textLayer.fontSize = 8
        case .xyz:
            textLayer.string = NSString(format: "x=%5.3f\ny=%5.3f\nz=%5.3f", atom.primeAtom.site.fract.x,atom.primeAtom.site.fract.y,atom.primeAtom.site.fract.z)
            textLayer.fontSize = 6
        case .fract:
            textLayer.string = NSString(format: "x'=%5.3f\ny'=%5.3f\nz'=%5.3f", atom.fract.x,atom.fract.y,atom.fract.z)
            textLayer.fontSize = 6
        case .cartn:
            textLayer.string = NSString(format: "x''=%5.3f\ny''=%5.3f\nz''=%5.3f", atom.cartn.x,atom.cartn.y,atom.cartn.z)
            textLayer.fontSize = 6
        case .symmetryCode:
            let symmetry = atom.siteSymmetry.xyz == LatticeCoordZero
                ? (atom.siteSymmetry.n == nil
                    ? "?" : "\(atom.siteSymmetry.n!)") : atom.siteSymmetry.string
            textLayer.string = "\(atom.siteLabel)\n\(symmetry)"
            textLayer.fontSize = 8
        case .multiplicity:
            textLayer.string = NSString(format: "%d", atom.primeAtom.multiplicity)
            textLayer.fontSize = 12
        case .siteSymmetry:
            textLayer.string = atom.primeAtom.site.wyckoff?.siteSymmetry ?? "n/a"
            textLayer.fontSize = 12
        case .wyckoffLetter:
            textLayer.string = fromLetter(atom.primeAtom.site.wyckoff?.letter) ?? "n/a"
            textLayer.fontSize = 12
        case .occupancy:
            let group = atom.primeAtom.primeAtomOccupancyGroup
            textLayer.string = group?
                .atoms
                .map({ "\($0.site.label) - \($0.site.occupancy == nil ? "?" : "\($0.site.occupancy!)")"})
                .enumerated()
                .reduce(""){
                    (a,b) -> String in
                    if b.offset == 0 {
                        return b.element
                    } else {
                        return a + "\n" + b.element
                    }
                }
                ?? "n/a"
            textLayer.fontSize = 12
        default:
            break
        }

        let fontSize = textLayer.fontSize
        let size = __textLayerSize(textLayer)
        textLayer.bounds = CGRect( origin: CGPoint.zero, size: CGSize(width:size.width+4,height:size.height+4) )
        textLayer.font = UIFont.systemFont(ofSize: fontSize)
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.borderColor = ((atom.primeAtom.site.type?.scene?.material.diffuse.contents as? UIColor) ?? UIColor.black).cgColor
        textLayer.borderWidth = 2
        textLayer.alignmentMode = kCAAlignmentCenter
//        textLayer.shadowColor = UIColor.grayColor().CGColor
//        textLayer.shadowRadius = 3.0
//        textLayer.shadowOpacity = 1.0
//        textLayer.shadowOffset = CGSize(width:1.0,height:1.0)
//        textLayer.borderWidth = 1.0
//        textLayer.borderColor = UIColor.grayColor().CGColor
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.isHidden = labelMode == .nothing || labelMode == .bondDistance ? true :  hidden
    }
}

func __textLayerSize( _ textLayer: CATextLayer ) -> CGSize {
    let fontSize = textLayer.fontSize
    return (textLayer.string as? NSString)?.size(attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: fontSize)]) ?? CGSize.zero
}

// MARK: -

class SceneBond_t {
    weak var crystal : SwiftCrystal?
    let bond : ConcreteBond_t
    let node = SCNNode()
    var node0 = SCNNode()
    var node1 = SCNNode()
    let textLayer: CATextLayer = CATextLayer()
    var contentsNode : SCNNode? = nil {
        didSet {
            contentsNode?.addChildNode(node)
            setupIfNeed()
        }
    }

    init( crystal c: SwiftCrystal?, bond b: ConcreteBond_t ) {
        crystal = c
        bond = b
        textLayer.fontSize = 8
        textLayer.cornerRadius = 3
        textLayer.string = bond.primeBond.geomBond.distance?.source ?? "?"
        let fontSize = textLayer.fontSize
        let size = __textLayerSize(textLayer)
        textLayer.bounds = CGRect( origin: CGPoint.zero, size: CGSize(width:size.width+2,height:size.height+2) )
        textLayer.font = UIFont.systemFont(ofSize: fontSize)
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.borderColor = UIColor.black.cgColor
        textLayer.borderWidth = 1
        textLayer.alignmentMode = kCAAlignmentCenter
    }

    ///////////////////

    func setupIfNeed() {
        if hidden == false && node.childNodes.count == 0 {
            setup()
        }
    }

    func setup() {
        node1.name = "bondNode1"
        node0.name = "bondNode0"

        assert( node.childNodes.count == 0 )
        node.addChildNode(node0)
        node.addChildNode(node1)

        let center = ( bond.atom1.cartn + bond.atom2.cartn ) * 0.5
        _ = bonding( bond.atom1, toPosition: center, node: &node0 )
        _ = bonding( bond.atom2, toPosition: center, node: &node1 )

        updateRange()
        if crystal?.isRadiiUpdated == true {
            updateSize()
            updateRadii()
        }
    }

    func Cylinder( _ from: ConcreteAtom_t ) -> SCNCylinder? {
        return from.primeAtom.site.type?.scene?.cylinder.copy() as? SCNCylinder
    }

    func bonding( _ from: ConcreteAtom_t, toPosition: Vector3, node: inout SCNNode ) -> SCNNode {
        let to = toPosition - from.cartn
        let lengthTo = length(to)
        let node0 = SCNNode()
        let node1 = SCNNode()

        node0.position = SCNVector3(from.cartn)
        node0.orientation = SCNQuaternion( from: SCNVector3(0,1,0), to: SCNVector3(normalize(to)) )
        node1.position = SCNVector3( 0, length(to) * 0.5, 0 )
        node1.scale = SCNVector3( 0, 1.0, 0 )

        node0.addChildNode(node1)
        node.addChildNode(node0)

        node1.geometry = Cylinder( from )

        sizeProcs.append({
            [unowned self] in
            node1.scale = SCNVector3( self.bondDiameter, lengthTo, self.bondDiameter )
            })
        return node0
    }

    var needUpdateSize = false
    func updateSize() {
        if hidden { needUpdateSize = true; return }
        _ = sizeProcs.map{ $0() }
        needUpdateSize = false
    }

    var needUpdateRadii = false
    func updateRadii() {
        if hidden { needUpdateRadii = true; return }
        _ = radiiProcs.map{ $0() }
        needUpdateRadii = false
    }

    func updateRange() {
        setupIfNeed()
        if needUpdateSize { updateSize() }
        if needUpdateRadii { updateRadii() }
        if hidden {
            node.removeFromParentNode()
        }
        else if node.parent == nil {
            contentsNode?.addChildNode(node)
        }
    }

    var hidden : Bool {
        var hidden = true
        if let mode = crystal?.bondingRangeMode {
            switch mode {
            case .UnitCell:
                hidden = bond.chainBondingStep != 0
            case .OneStep:
                hidden = bond.chainBondingStep > 1
            case .Grouping:
                hidden = !bond.atom1.isUniquePosition || !bond.atom2.isUniquePosition
            case .Limited:
                hidden = false
            default:
                break
            }
        }
        return hidden
    }

    // MARK: -

    var sizeProcs : [()->Void] = []
    var radiiProcs : [()->Void] = []

    var bondDiameter : RadiiSizeType {
        return crystal?.bondDiameter ?? 0.0
    }

    // MARK: -

    func updateLabel(_ labelMode:SwiftCrystal.LabelMode) {
        textLayer.isHidden = labelMode != .bondDistance || hidden
        textLayer.setNeedsDisplay()
    }
}

class SceneLineBond_t {

    weak var crystal : SwiftCrystal?
    let rangeMode : SwiftCrystal.BondingRangeMode
    let node : SCNNode = SCNNode()
    var contentsNode : SCNNode? = nil {
        didSet {
            contentsNode?.addChildNode(node)
            setupIfNeed()
        }
    }

    init( crystal c: SwiftCrystal?, rangeMode r: SwiftCrystal.BondingRangeMode ) {
        crystal = c
        rangeMode = r
        assert(node.childNodes.count == 0)
    }

    func setupIfNeed() {
        if hidden == false && node.geometry == nil {
            setup()
        }
    }

    fileprivate func setup() {
        node.geometry = bondLines(rangeMode)
    }

    func bondColorVector( _ atom: ConcreteAtom_t ) -> SCNVector4 {
        return crystal?.colors.bondColorVector(atom) ?? SCNVector4Zero
    }

    func bondLines( _ bondingRangeMode: SwiftCrystal.BondingRangeMode ) -> SCNGeometry {

        var predicate : (ConcreteBond_t) -> Bool = { return $0.chainBondingStep == 0 }

        switch bondingRangeMode {
        case .OneStep:
            predicate = { return $0.chainBondingStep == 1 }
        case .Grouping:
            predicate = { return $0.atom1.isUniquePosition && $0.atom2.isUniquePosition }
        case .Limited:
            predicate = { return $0.chainBondingStep > 1 }
        default:
            break
        }

        var bondVertices : [float3] = []
        var bondColors : [float4] = []
        for bond in crystal?.concrete.bonds ?? [] {

            if !predicate(bond) {
                continue
            }

            let c1 = Vector4(bondColorVector(bond.atom1))
            let c2 = Vector4(bondColorVector(bond.atom2))
            bondVertices.append((bond.cartn1))
            bondColors.append(c1)
            bondVertices.append(((bond.cartn1 + bond.cartn2) * 0.5))
            bondColors.append(c1)
            bondVertices.append(((bond.cartn1 + bond.cartn2) * 0.5))
            bondColors.append(c2)
            bondVertices.append((bond.cartn2))
            bondColors.append(c2)
        }
        return SCNGeometry.lines(bondVertices, colors:bondColors)
    }

    // MARK: -
    var hidden : Bool {
        var hidden = true
        if let mode = crystal?.bondingRangeMode {
            switch mode {
            case .UnitCell:
                hidden = rangeMode != .UnitCell
            case .Grouping:
                hidden = rangeMode != .Grouping
            case .OneStep:
                hidden = rangeMode == .Limited || rangeMode == .Grouping
            case .Limited:
                hidden = rangeMode == .Grouping
            default:
                break
            }
        }
        return hidden
    }

    func updateRange() {
        setupIfNeed()
        if rangeMode == .Grouping && crystal?.bondingRangeMode == .Grouping {
            setup()
        }
        if hidden {
            node.removeFromParentNode()
        }
        else if node.parent == nil {
            contentsNode?.addChildNode(node)
        }
    }

}


private func LineTexture() -> SCNMaterial {
    CATransaction.begin()
    let layer = ScrollTextureLayer()
    let rect = CGRect(x: 0, y: 0, width: 32, height: 32)
    layer.prepare(rect)
    layer.start()
    CATransaction.commit()
    let material = SCNMaterial()
    material.emission.contents = layer
    material.emission.wrapS = .repeat
    material.emission.wrapT = .repeat
    material.emission.minificationFilter = .nearest
    material.emission.magnificationFilter = .nearest
    material.emission.mipFilter = .none
    material.emission.maxAnisotropy = 5.0
    material.diffuse.contents = Color.black
    material.specular.contents = Color.black
    return material
}

class SceneHydrogenBondLines_t {

    private static var __once: () = {
            SceneHydrogenBondLines_t.material = LineTexture()
        }()

    weak var crystal : SwiftCrystal?
    let rangeMode : SwiftCrystal.BondingRangeMode
    let node : SCNNode = SCNNode()
    var contentsNode : SCNNode? = nil {
        didSet {
            contentsNode?.addChildNode(node)
            setupIfNeed()
        }
    }

    static var initializeOnce : Int = 0
    static var material : SCNMaterial? = nil

    init( crystal c: SwiftCrystal?, rangeMode r: SwiftCrystal.BondingRangeMode ) {
        crystal = c
        rangeMode = r
        assert(node.childNodes.count == 0)
        _ = SceneHydrogenBondLines_t.__once

    }

    func setupIfNeed() {
        if hidden == false && node.geometry == nil {
            setup()
        }
    }

    fileprivate func setup() {
        let geometry = bondLines(rangeMode)
        CATransaction.begin()
        geometry.firstMaterial = SceneHydrogenBondLines_t.material
        CATransaction.commit()
        node.geometry = geometry
    }

    func bondColorVector( _ atom: ConcreteAtom_t ) -> SCNVector4 {
        return crystal?.colors.bondColorVector(atom) ?? SCNVector4Zero
    }

    func bondLines( _ bondingRangeMode: SwiftCrystal.BondingRangeMode ) -> SCNGeometry {

        var predicate : (Int) -> Bool = { return $0 == 0 }

        switch bondingRangeMode {
        case .OneStep:
            predicate = { return $0 == 1 }
        case .Limited:
            predicate = { return $0 > 1 }
        default:
            break
        }

        var bondVertices : [float3] = []
        var bondColors : [SCNVector4] = []
        var bondTexs : [float2] = []
        for hbond in crystal?.concrete.hbonds ?? [] {
            if !predicate(hbond.chainBondingStep) {
                continue
            }
            let d = hbond.donar
            let h = hbond.hydrogen
            let a = hbond.acceptor
            let donarColor = SCNVector4(vector4(Vector3(hex: "880000"),1))
            let acceptorColor = SCNVector4(vector4(Vector3(hex: "FFFFFF"),1))
            #if false
            if let d = d {
                bondVertices.append((d.cartn))
                bondColors.append(donarColor)
                bondTexs.append( float2() )
                bondVertices.append((h.cartn))
                bondColors.append(donarColor)
                bondTexs.append( float2() )
            }
            #endif
            if let a = a {
                bondVertices.append((h.cartn))
                bondColors.append(acceptorColor)
                bondTexs.append( float2() )
                bondVertices.append((a.cartn))
                bondColors.append(acceptorColor)
                bondTexs.append( float2( x: distance(h.cartn,a.cartn) * 5.0, y: 0.75 ) )
            }
        }
        return SCNGeometry.lines( bondVertices, texcoords: bondTexs )
//        return SCNGeometry.lines( bondVertices, colors:bondColors )
    }

    // MARK: -
    var hidden : Bool {
        var hidden = true
        if let mode = crystal?.bondingRangeMode {
            switch mode {
            case .UnitCell:
                hidden = rangeMode != .UnitCell
            case .OneStep:
                hidden = rangeMode == .Limited
            case .Limited:
                hidden = false
            default:
                break
            }
        }
        return hidden
    }

    func updateRange() {
        setupIfNeed()
        if hidden {
            node.removeFromParentNode()
        }
        else if node.parent == nil {
            contentsNode?.addChildNode(node)
        }
    }

}

















