//
//  HambergerMenuViewController.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/06/17.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class MenuViewController: UIViewController {

    weak var document: Document?

    private lazy var __once: () = {
            UIApplication.shared
                .sendAction(#selector(AppDelegate.dismissHambergerMenu),
                            to: nil,
                            from: self,
                            for: nil)
        }()

    var crystal : SwiftCrystal? {
        return document?.crystal
    }

    @IBOutlet weak var mainStackView: UIStackView!

    @IBOutlet weak var bondDiaLabel: UILabel!
    @IBOutlet weak var bondDiaSlider: UISlider!
    @IBOutlet weak var bondDiaBackground : UIView!
    @IBOutlet weak var bondDiaSpacer : UIView!

    @IBOutlet weak var radiiSizeSlider: UISlider!
    @IBOutlet weak var radiiSizeLabel : UILabel!

//    @IBOutlet weak var infoSeparatorView: UIView!
    @IBOutlet weak var infoView: UIStackView!
    @IBOutlet weak var typesView : UIStackView!
    @IBOutlet weak var radiiView : UIStackView!

    var bondView : UIStackView = UIStackView()
    var preset : UIStackView = UIStackView()
    var cellParameters : UIStackView = UIStackView()
    var symmetry : UIStackView = UIStackView()
    var groups : UIStackView = UIStackView()
    var cameras : UIStackView = UIStackView()
//    var labels : UIStackView = UIStackView()
    var fileMenu: UIStackView = UIStackView()

    var bondItems : [(SwiftCrystal.BondingRangeMode,ItemView)] = []
    var cameraItems : [ItemView] = []
//    var labelItems: [(SwiftCrystal.LabelMode,ItemView)] = []
    var fileMenuItems: [ItemView] = []

    @IBOutlet weak var backgroundView : UIView!

    @IBOutlet weak var widthConstraint : NSLayoutConstraint!

    var radiiTitleView : TitleView! = TitleView.init( frame: CGRect(x: 0, y: 0, width: 200, height: 66) )

    var radiiItem0 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
    var radiiItem1 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
//    var radiiItem2 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
    var radiiItem3 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
    var radiiItem4 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
    var radiiItem5 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )

    var infoItem0 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
    var infoItem1 : ItemView! = ItemView(frame: CGRect(x: 0, y: 0, width: 200, height: 66) )


    // MARK: - Action

    func updateContentsWithAnimation( duration d: CFAbsoluteTime,  proc : () -> Void ) {

        if SharedAppDelegate().workProgressController.working {

            backgroundView.isUserInteractionEnabled = false
            SCNTransaction.begin()
            SCNTransaction.animationDuration = 0.0
            proc()
            SCNTransaction.commit()
            backgroundView.isUserInteractionEnabled = true

            return
        }
        else {

            backgroundView.isUserInteractionEnabled = false
            SCNTransaction.begin()
            SCNTransaction.animationDuration = d
            proc()
            SCNTransaction.commit()
            updateUI()
            backgroundView.isUserInteractionEnabled = true
        }
    }

    @IBAction func bondSizeAction(_ sender: UISlider) {
        updateContentsWithAnimation(duration:0.0){
            crystal?.bondSize = RadiiSizeType(sender.value)
            document?.updateChangeCount(.done)
        }
    }

    @IBAction func radiiSizeAction(_ sender: UISlider) {
        updateContentsWithAnimation(duration:0.0){
            crystal?.radiiSize = RadiiSizeType(sender.value)
            document?.updateChangeCount(.done)
        }
    }

    @IBAction func updateUI() {
        assert( Thread.isMainThread )
        updateItems()
        updateRadiiView()
        updateBondView()
        updatePresets()
        updateCameras()
        updateFileMenus()
        updateGroupView()
        #if false
            updateLabels()
        #endif
        document?.updateChangeCount(.done)
    }

    var shortSize : Bool {
        let bounds = UIScreen.main.bounds
        return min( bounds.size.width, bounds.size.height ) <= 320
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        widthConstraint.constant = 207

        var alpha: Float = 0.85
        if UIDevice.current.userInterfaceIdiom == .pad {
            alpha = 1.0
        }

        backgroundView.backgroundColor = UIColor(rgb: Vector3(hex:"DBDBDB"), alpha: alpha )

        radiiSizeLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFontWeightThin)
        bondDiaLabel.font = UIFont.monospacedDigitSystemFont(ofSize: 16, weight: UIFontWeightThin)

        prepareInfoView()
        prepareTypesView()
        prepareRadiiView()
        preparePresetMode()
        prepareBondView()
        prepareCellParameters()
        prepareSymmetry()
        prepareCameras()
        prepareFileMenus()
        prepareGroups()
        #if false
            prepareLabels()
        #endif
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    var dismissed : Int = 0
    @IBAction func dismiss( _ sender : AnyObject? ) {
//        debugPrint("dismiss \(sender)")
        _ = self.__once
    }

    @IBAction func unwindToRootAction( _ sender : AnyObject? ) {
        dismiss(sender)
        SharedAppDelegate().unwindToRootAction(sender)
    }

    @IBAction func openActivitySheet(_ sender:UIButton?) {

        backgroundView.isUserInteractionEnabled = false
        sender?.isEnabled = false
        RunLoop.current.run( until: Date(timeIntervalSinceNow: 0.01) )

        let url = document?.fileURL
        let activityController = UIActivityViewController(activityItems: [url!], applicationActivities: nil)
        switch UIDevice.current.userInterfaceIdiom {

        case .phone:
            present( activityController, animated: true, completion: {
                [weak self] in
                sender?.isEnabled = true
                self?.backgroundView.isUserInteractionEnabled = true
            })

        case .pad:
            activityController.modalPresentationStyle = .popover
            let popover = activityController.popoverPresentationController
            popover?.permittedArrowDirections = .any
            popover?.sourceView = backgroundView
            popover?.sourceRect = sender?.frame ?? CGRect.zero
            present( activityController, animated: true, completion: {
                [weak self] in
                sender?.isEnabled = true
                self?.backgroundView.isUserInteractionEnabled = true
            } )

        default:
            break

        }
    }


    var types : [CrystalAtomType_t] {
        get {
            if let result = document?.crystal.info.types {
                return result
            }
            return []
        }
    }

//    var crystal : SwiftCrystal? {
//        return SharedAppDelegate().currentDocument?.crystal
//    }

    var lineHeight : CGFloat {
        return 1.0 / UIScreen.main.scale
    }

    var lineSpace : CGFloat {
        return 1.0 - lineHeight
    }

    func color( _ atomicSymbol : AtomicSymbol ) -> UIColor {
        if let crystal = document?.crystal {
            return crystal.colors.color( atomicSymbol )
        }
        return UIColor.purple
    }

    func titleView( _ text: String ) -> UIView {
        let title = TitleView( frame: CGRect.zero )
        title.text = text
        return title
    }

    func lineView() -> UIView {
        let line = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 310, height: lineHeight) ) )
        line.backgroundColor = UIColor.black
        let constraint = NSLayoutConstraint.init( item: line, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: lineHeight)
        line.addConstraint( constraint  )
        return line
    }

    func spaceView(_ height:CGFloat) -> UIView {
        #if false
            let space = SpaceView.init(frame: CGRect(x: 0, y: 0, width: 200, height: height) )
            return space
        #else
            let space = UIView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 310, height: 1) ) )
            space.backgroundColor = UIColor.clear
            let constraint = NSLayoutConstraint.init( item: space, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height)
            space.addConstraint( constraint  )
            return space
        #endif
    }

    func prepareInfoView() {
        (infoView.superview as! UIStackView).removeArrangedSubview(infoView)

        #if false
            let titleView = TitleView.init( frame: CGRect(x: 0, y: 0, width: 200, height: 66) )
            titleView.text = "Info"
            infoView.addArrangedSubview(titleView)

            var count = 0

            if count == 0 {
                (infoSeparatorView.superview as! UIStackView).removeArrangedSubview(infoSeparatorView)
                (infoView.superview as! UIStackView).removeArrangedSubview(infoView)
            }
        #endif
    }

    func prepareTypesView() {

        for view in typesView.arrangedSubviews {
            typesView.removeArrangedSubview(view)
        }

        typesView.addArrangedSubview( lineView() )
        typesView.addArrangedSubview( titleView("Types") )

        for type in types {
            let view = TypeView.init( frame: CGRect( x: 0, y: 0, width: 200, height: 66 ) )
            var name = type.localizedName
            name = name == nil ? "" : name
            view.text = "\(type.symbol)  -  \(name!) "
            view.color = color( type.atomicSymbol )
            typesView.addArrangedSubview( view )
        }
        typesView.addArrangedSubview(spaceView(12))
    }

    func itemView( _ text: String ) -> ItemView {
        let item = ItemView( frame: CGRect.zero )
        item.text = text
        return item
    }

    func itemView( _ text: String, action: Selector ) -> ItemView {
        let item = itemView( text )
        item.action = action
        return item
    }

    func itemView( _ text: String, action: Selector, tag: Int ) -> ItemView {
        let item = itemView( text, action: action )
        item.tag = tag
        return item
    }

    @IBAction func latticeHidden( _ sender: AnyObject? ) {
        if let flag = document?.crystal.latticeHidden {
            document?.crystal.latticeHidden = !flag
        }
        updateUI()
    }

    var latticeHiddenItem: ItemView? = nil

    func prepareCellParameters() {

        cellParameters.axis = .vertical
        mainStackView.addArrangedSubview(cellParameters)

        cellParameters.addArrangedSubview( lineView() )
        cellParameters.addArrangedSubview( spaceView(lineSpace) )
        cellParameters.addArrangedSubview( titleView("Unit Cell") )

        let hoge = [
            (["_symmetry_cell_setting"],"%@"),
            (["_cell_length_a"],"a = %@Å"),
            (["_cell_length_b"],"b = %@Å"),
            (["_cell_length_c"],"c = %@Å"),
            (["_cell_angle_alpha"],"α = %@°"),
            (["_cell_angle_beta"],"β = %@°"),
            (["_cell_angle_gamma"],"γ = %@°")
        ]

        _ = hoge.map({ (keys,format) -> Void in
            if let str = document?.cifString(keys) {
                let text = NSString(format: format as NSString, str) as String
                cellParameters.addArrangedSubview(itemView(text))
            }})

        latticeHiddenItem = itemView( "Hide Lattice", action: #selector(latticeHidden) )
        cellParameters.addArrangedSubview( latticeHiddenItem! )
        cellParameters.addArrangedSubview( spaceView(12) )
    }

    func prepareSymmetry() {

        let keys = [
            "_symmetry_space_group_name_H-M",
            "_space_group_name_H-M_alt",
            "_space_group_name_Hall",
            "_symmetry_space_group_name_Hall",
            "_space_group_name_Hall"
        ]

        if let str = document?.cifString(keys) {
            symmetry.axis = .vertical
            mainStackView.addArrangedSubview(symmetry)

            symmetry.addArrangedSubview(lineView())
            symmetry.addArrangedSubview( spaceView(lineSpace) )
            symmetry.addArrangedSubview(titleView("Symmetry"))
            symmetry.addArrangedSubview(itemView(str))
            symmetry.addArrangedSubview(spaceView(12))
        }
    }

    var updatePresetProcs : [()->Void] = []
    var groupItemViews : [ItemView] = []

    var radiiLabel : String {
        if let radiiType = crystal?.radiiType {
            switch radiiType {
            case .Calculated:
                return "Calculated"
            case .Covalent:
                return "Covalent"
            case .Van_der_Waals:
                return "Van der Waals"
            case .Unit:
                return "Unit"
//            case .Ellipsoid:
//                return "Probability"
            default:
                break
            }
        }
        return "?"
    }

    func updateItems() {
        if let crystal = document?.crystal {
            func radiiText() -> String {
                if crystal.radiiType == .Van_der_Waals {
                    return "R = \(Int( round(100*crystal.radiiSize)))% of \(radiiLabel)"
                }
                if crystal.radiiType == .Unit {
                    return "Radii = \(NSString(format: "%5.3f",crystal.radiiSize))Å"
                }
                if crystal.radiiType == .Ellipsoid {
                    return "Probability = \(NSString(format: "%7.5f",100*crystal.probability))%"
                }
                return "Radii = \(Int( round(100*crystal.radiiSize)))% of \(radiiLabel)"
            }
            #if false
                let anim = CATransition()
                anim.type = kCATransitionFade
                anim.subtype = kCATransitionFade
                anim.duration = 0.3
                radiiSizeLabel.layer.addAnimation(anim, forKey: nil)
                bondDiaLabel.layer.addAnimation(anim, forKey: nil)
            #endif
            radiiSizeLabel.text = radiiText()
            bondDiaLabel.text = "Bond diameter = \(NSString(format:"%.2f",crystal.bondDiameter*2.0))Å"

            #if false
                radiiSizeSlider.setValue( Float( crystal.radiiSize ?? 0.5), animated: true )
                bondDiaSlider.setValue( Float( crystal.bondSize ?? 0.5 ), animated: true )
            #else
            UIView.animate(withDuration: 0.3, animations: {
                [weak self] in
                self?.radiiSizeSlider.setValue( Float( crystal.radiiSize ), animated: true )
                self?.bondDiaSlider.setValue( Float( crystal.bondSize ), animated: true )
                })
            #endif

            let flag = document?.crystal.latticeHidden ?? false
            latticeHiddenItem?.selected = true
            latticeHiddenItem?.text = flag ? "Show Lattice" : "Hide Lattice"
        }
    }

}




