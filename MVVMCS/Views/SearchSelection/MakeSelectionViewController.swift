////
////  MakeSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 7/11/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//enum MakeSelectionSegmentType: Int {
//    case popular
//    case all
//}
//
//class MakeSelectionViewController: SearchSelectionViewController {
//    // Outlets
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var indexBar: S24IndexBar!
//    
//    //For Search mask
//    @objc var vehicleType = VehicleType.all
//    @objc var vehicleSearchSlot: VehicleSearchSlot!
//    
//    private var segmentedControlFilter: AS24SegmentedControl?
//    
//    //Data properties
//    private var parameter: Parameter {
//        return searchConfiguration.parameterNamed(row.parameterNames?.first)
//    }
//    
//    private var plainMakes: [Option] {
//        let makes = vehicleSearchSlot?.availableMakes() ?? []
//        return SearchConfiguration.sortedAvailableOptions(makes, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically)
//    }
//    
//    private var popularMakes = [Option]()
//    
//    private var allMakes = [[Option]]()
//    
//    private var sectionTitles: [String] {
//        var keys = Array(Set(plainMakes.map { String($0.localizedLabel.first!) })).sorted { $0 < $1 }
//        keys.insert("*", at: 0)
//        
//        return keys
//    }
//    
//    private var selectedSegmentIndex = MakeSelectionSegmentType.popular
//
//    private var hasPopularMakes: Bool {
//        return vehicleType == .car || vehicleType == .commercialVehicle
//    }
//    
//    private var hasDataChanges = false
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        theming()
//        
//        //Nav bar
//        setupNavigationBar()
//        
//        setupTableView()
//        
//        updateAllMakes()
//        setupIndexBar()
//        
//        // don't show popular makes for non-cars and non-commercial vehicles
//        // Prefer show in popular
//        if hasPopularMakes {
//            setupSegmentControl()
//            updatePopularMakes()
//            
//            if let make = vehicleSearchSlot.make, let _ = popularMakes.index(of: make) {
//                applySegmentIndex(MakeSelectionSegmentType.popular.rawValue)
//            } else {
//                applySegmentIndex(MakeSelectionSegmentType.all.rawValue)
//            }
//        } else {
//            applySegmentIndex(MakeSelectionSegmentType.all.rawValue)
//        }
//        
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.labelSearchTableView(parameter.name)
//    }
//    
//    private func updateAllMakes() {
//        let sortedMakes = plainMakes.sorted { $0.localizedLabel < $1.localizedLabel }
//        
//        var groupedMakes = sortedMakes.reduce([[Option]]()) { (result, value) in
//            var result = result
//            guard var lastGroup = result.last else { return [[value]] }
//            
//            if let firstOption = lastGroup.first, firstOption.localizedLabel.first == value.localizedLabel.first {
//                lastGroup.append(value)
//                result[result.count - 1] = lastGroup
//            } else {
//                result.append([value])
//            }
//            return result
//        }
//        
//        let firstOption = Option(value: localize("search.rowtitle.all"), parameterName: "all")!
//        groupedMakes.insert([firstOption], at: 0)
//        
//        allMakes = groupedMakes
//    }
//    
//    private func updatePopularMakes() {
//        var makeNames: String!
//        switch vehicleType {
//        case .car:
//            #if AMAG || ROC
//            makeNames = "AUDI,PORSCHE,SEAT,SKODA,VW"
//            #else
//            makeNames = "ALFA ROMEO,ASTON MARTIN,AUDI,BENTLEY,BMW,BMW-ALPINA,CADILLAC,CHEVROLET,CHRYSLER,CITROEN,DACIA,DAEWOO,DAIHATSU,DAIMLER,DODGE,DS AUTOMOBILES,FERRARI,FIAT,FORD,HONDA,HUMMER,HYUNDAI,INFINITI,JAGUAR,JEEP,KIA,LAMBORGHINI,LANCIA,LAND ROVER,LEXUS,LINCOLN,LOTUS,MASERATI,MAZDA,MERCEDES-BENZ,MG,MINI,MITSUBISHI,NISSAN,OPEL,PEUGEOT,PONTIAC,PORSCHE,RENAULT,ROLLS-ROYCE,ROVER,SAAB,SEAT,SKODA,SMART,SSANG YONG,SUBARU,SUZUKI,TESLA,TOYOTA,TRIUMPH,VOLVO,VW"
//            #endif
//            
//        case .commercialVehicle:
//            makeNames = "CITROEN,DACIA,FIAT,FORD,HYUNDAI,IVECO,MERCEDES-BENZ,NISSAN,OPEL,PEUGEOT,PIAGGIO,RENAULT,TOYOTA,VW"
//        case .moto:
//            makeNames = "APRILIA,ARCTIC CAT,BMW,BUELL,CAN-AM,DUCATI,GILERA,HARLEY-DAVIDSON,HONDA,HYOSUNG,KAWASAKI,KTM,KYMCO,LML,MOTO GUZZI,MV AGUSTA,PEUGEOT,PIAGGIO,POLARIS,SMC (SM),SUZUKI,SYM (SANYANG),TRIUMPH,YAMAHA"
//        default:
//            break
//        }
//        
//        //Filtering popular makes
//        var popularMakes = plainMakes.filter({ (make) -> Bool in
//            return makeNames
//                .components(separatedBy: ",")
//                .contains(make.labels.de)
//        })
//        
//        //Adding all row and select all makes row
//        if !popularMakes.isEmpty {
//            //add all group
//            let firstOption = Option(value: localize("search.rowtitle.all"), parameterName: "all")!
//            popularMakes.insert(firstOption, at: 0)
//            
//            let selectAllMakes = Option(value: localize("search.makes.selectallmakes"), parameterName: "selectAll")!
//            popularMakes.append(selectAllMakes)
//        }
//        
//        self.popularMakes = popularMakes
//    }
//    
//    @objc func navigationShouldPopOnBackButton() -> Bool {
//        if !hasDataChanges {
//            //remove new slot if user hasn't chosen make
//            if searchConfiguration.vehicleSearchSlots.count > 1 && !vehicleSearchSlot.hasSelectedMake() {
//                searchParameterChangeDelegate?.rowChanged?(row, in: vehicleSearchSlot)
//            }
//        }
//        
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//        return false
//    }
//
//    private func setupIndexBar() {
//        //Index Bar
//        S24IndexBar.appearance().textFont = FontManager.shared().mediumFont(withSize: 11)
//        if Constants.isPad() {
//            S24IndexBar.appearance().barBackgroundWidth = 32
//            S24IndexBar.appearance().textOffset = UIOffset(horizontal: 10, vertical: 0)
//        }
//        
//        if Constants.isPad() || Constants.isIPhone6P() {
//            S24IndexBar.appearance().textSpacing = padding
//        } else if Constants.isIPhone6() {
//            S24IndexBar.appearance().textSpacing = CGFloat(kBaseDistance)
//        }
//        
//        indexBar.delegate = self
//        indexBar.tableView = tableView
//        
//        if hasPopularMakes {
//            indexBar.adjustedHeight = 2 * padding + kButtonHeight // Update frame when has segment control
//        }
//    }
//    
//    private func setupNavigationBar() {
//        navigationItem.title = localize("search.criteria.make")
//        addBackButton()
//    }
//    
//    private func setupTableView() {
//        //Table
//        tableView.setup(withSeparator: true, accessibilityId: nil)
//        tableView.delegate = self
//        tableView.dataSource = self
//    }
//    
//    private func setupSegmentControl() {
//        let width = UIScreen.main.bounds.width
//        let height: CGFloat = hasPopularMakes ? (2 * padding + kButtonHeight) : padding
//        
//        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        tableHeaderView.backgroundColor = .clear
//        
//        let togglePopularMakesTitle = localize("search.makes.popularmakes")
//        let toggleAllMakesTitle = localize("search.makes.allmakes")
//        //for QA test
//        togglePopularMakesTitle.accessibilityLabel = AccessibilityIdentifiers.labelMakesSegmentedControlPopularMakes
//        toggleAllMakesTitle.accessibilityLabel = AccessibilityIdentifiers.labelMakesSegmentedControlAllMakes
//        
//        segmentedControlFilter = AS24SegmentedControl(items: [togglePopularMakesTitle, toggleAllMakesTitle])
//        segmentedControlFilter?.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
//        segmentedControlFilter?.accessibilityIdentifier = AccessibilityIdentifiers.labelMakesSegmentedControl
//        tableHeaderView.addSubview(segmentedControlFilter!)
//        
//        // Layout
//        segmentedControlFilter?.autoPinEdge(toSuperviewEdge: .top, withInset: padding)
//        segmentedControlFilter?.autoPinEdge(toSuperviewEdge: .leading, withInset: padding)
//        segmentedControlFilter?.autoPinEdge(toSuperviewEdge: .trailing, withInset: padding)
//        segmentedControlFilter?.autoSetDimension(.height, toSize: kButtonHeight)
//
//        
//        tableView.tableHeaderView = tableHeaderView
//    }
//    
//    private func scrollToSelectedMake() {
//        var indexPath = IndexPath.zero
//        
//        if !vehicleSearchSlot.hasSelectedMake() {
//            guard indexPath.row < tableView(tableView, numberOfRowsInSection: 0) else { return }
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
//        } else {
//            
//            guard let indexPath = selectedIndexPath() else { return }
//            
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
//            tableView.applyNewContentOffset()
//        }
//    }
//    
//    private func selectedIndexPath() -> IndexPath? {
//        guard let make = vehicleSearchSlot?.make else { return nil }
//        
//        if selectedSegmentIndex == .all {
//            for sectionIndex in 0..<allMakes.count {
//                let section = allMakes[sectionIndex]
//                if section.contains(make) {
//                    guard let rowIndex = section.index(of: make) else { return nil }
//                    return IndexPath(row: rowIndex, section: sectionIndex)
//                }
//            }
//            
//            return nil
//        } else {
//            guard let rowIndex = popularMakes.index(of: make) else { return nil }
//            return IndexPath(row: rowIndex, section: 0)
//        }
//    }
//    
//    @objc private func segmentedControlValueChanged(_ sender: AS24SegmentedControl?) {
//        guard let segmentControl = segmentedControlFilter else { return }
//        applySegmentIndex(segmentControl.selectedSegmentIndex)
//    }
//    
//    private func applySegmentIndex(_ index: Int) {
//        //save selected index
//        segmentedControlFilter?.selectedSegmentIndex = index
//        selectedSegmentIndex = MakeSelectionSegmentType(rawValue: index) ?? MakeSelectionSegmentType.all
//        
//        //scroll to top
//        tableView.contentOffset = .zero
//        tableView.scrollsToTop = true
//        
//        //Index bar
//        indexBar.isHidden = selectedSegmentIndex == .popular
//        indexBar.reload()
//        
//        //reload data
//        tableView.reloadData(completion: {
//            self.scrollToSelectedMake()
//        })
//    }
//    
//    private func showAllModels(for modelRow: SearchRow?, availableModels: [Option]?) {
//        //Dont try to pushViewController during an existing transition.
//        if transitioning {
//            return
//        }
//        
//        transitioning = true
//        
//        let controller = storyboard?.instantiateViewController(withIdentifier: SubSingleSelectionViewController.layoutIdentifier()) as? SubSingleSelectionViewController
//        controller?.isOpennedFromDealerMakes = false
//        controller?.searchParameterChangeDelegate = searchParameterChangeDelegate
//        controller?.searchConfiguration = searchConfiguration
//        controller?.vehicleSearchSlot = vehicleSearchSlot
//        controller?.row = modelRow
//        //    controller.availableOptions = availableModels;
//        UIApplication.shared.beginIgnoringInteractionEvents()
//        navigationController?.pushViewController(controller, animated: true, onCompletion: {
//            UIApplication.shared.endIgnoringInteractionEvents()
//            self.transitioning = false
//        })
//    }
//}
//
//// MARK: GDIIndexBarDelegate
//extension MakeSelectionViewController: GDIIndexBarDelegate {
//    func numberOfIndexes(for indexBar: GDIIndexBar!) -> UInt {
//        if selectedSegmentIndex == .all {
//            return UInt(sectionTitles.count)
//        }
//        
//        return 0
//    }
//    
//    func string(for index: UInt) -> String! {
//        if selectedSegmentIndex == .all {
//            return sectionTitles[Int(index)]
//        }
//        
//        return nil
//    }
//    
//    func indexBar(_ indexBar: GDIIndexBar!, didSelect index: UInt) {
//        if selectedSegmentIndex == .all {
//            tableView.scrollToRow(at: IndexPath(row: 0, section: Int(index)), at: .top, animated: false)
//        }
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension MakeSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        if selectedSegmentIndex == .popular {
//            return 1
//        }
//        
//        return allMakes.count
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if selectedSegmentIndex == .popular {
//            return popularMakes.count
//        }
//        
//        return allMakes[section].count
//        
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchMakeSelectionCell.reuseIdentifier()) as? SearchMakeSelectionCell else { return SearchMakeSelectionCell() }
//        
//        var textFont = currentTheme.regularLightFont()
//        
//        var option: Option?
//        var localizedLabel: String?
//        var selected = false
//        var hasMakeLogo = false
//        var shouldAdjustAccessoryViewFrame = false
//        
//        switch selectedSegmentIndex {
//        case .popular:
//            let isAllRow = (indexPath.row == 0)
//            let isSelectAllMakesRow = (indexPath.row == popularMakes.count - 1)
//            
//            if isAllRow || isSelectAllMakesRow {
//                textFont = currentTheme.regularMediumFont()
//                localizedLabel = popularMakes[indexPath.row].localizedLabel
//            } else {
//                option = popularMakes[indexPath.row]
//                localizedLabel = option?.localizedLabel
//            }
//            
//            selected = (!isSelectAllMakesRow && option == vehicleSearchSlot.make)
//            hasMakeLogo = (!isAllRow && !isSelectAllMakesRow && vehicleType != .moto)
//            
//        case .all:
//            if indexPath.section == 0 && indexPath.row == 0 {
//                textFont = currentTheme.regularMediumFont()
//                localizedLabel = allMakes[indexPath.section][indexPath.row].localizedLabel
//            } else {
//                option = allMakes[indexPath.section][indexPath.row]
//                localizedLabel = option?.localizedLabel
//            }
//            
//            selected = (option == vehicleSearchSlot.make)
//            shouldAdjustAccessoryViewFrame = selected
//        }
//        
//        cell.textLabel?.font = textFont
//        cell.textLabel?.text = localizedLabel
//        if hasMakeLogo {
//            cell.showLogo(withImageName: option?.makeLogoName)
//        } else {
//            cell.selected(selected, isMultipleSelection: false)
//        }
//        cell.showMakeLogo = hasMakeLogo
//        cell.shouldAdjustAccessoryViewFrame = shouldAdjustAccessoryViewFrame
//        
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.updateDisplay(cell, forRowAt: indexPath)
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let width = tableView.bounds.width - 2 * kCellContentPadding
//        let height = self.tableView(tableView, heightForHeaderInSection: section)
//        
//        let frame = CGRect(x: 0, y: 0, width: width, height: height)
//        let sectionTitle = sectionTitles[section]
//        
//        if selectedSegmentIndex == .popular {
//            return nil
//        }
//        
//        if sectionTitle.isEmpty || sectionTitle == "*" {
//            return nil
//        }
//        
//        let header = SearchHeaderView(frame: frame)
//        header.title = sectionTitle
//
//        return header
//        
//    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        var height: CGFloat = 0 //default
//        
//        if selectedSegmentIndex == .all {
//            let sectionTitle = sectionTitles[section]
//            
//            if !sectionTitle.isEmpty && sectionTitle != "*" {
//                let lineHeight = Float(currentTheme.regularMediumFont().lineHeight)
//                height = CGFloat(ceilf(lineHeight))
//            }
//        }
//        
//        return height
//    }
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == numberOfSections(in: tableView) - 1 {
//            return padding
//        }
//        
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return kTableCellHeight
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        hasDataChanges = true
//        
//        // special case for *all*
//        if indexPath.section == 0 && indexPath.row == 0 {
//            vehicleSearchSlot.clearAll()
//            searchParameterChangeDelegate?.rowChanged?(row, in: vehicleSearchSlot)
//            searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//            return
//        }
//        
//        // special case for *all makes*
//        if selectedSegmentIndex == .popular && indexPath.row == popularMakes.count - 1 {
//            applySegmentIndex(MakeSelectionSegmentType.all.rawValue)
//            return
//        }
//        
//        // make selection
//        var option: Option?
//        if selectedSegmentIndex == .popular {
//            option = popularMakes[indexPath.row]
//        } else {
//            option = allMakes[indexPath.section][indexPath.row]
//        }
//        
//        if option != vehicleSearchSlot.make {
//            vehicleSearchSlot.clearAll()
//            vehicleSearchSlot.selectMake(option)
//            
//            searchParameterChangeDelegate?.rowChanged?(row, in: vehicleSearchSlot)
//        }
//        
//        var models = vehicleSearchSlot.availableModels() ?? []
//        if !models.isEmpty {
//            tableView.reloadData()
//            let modelRow = SearchRow(type: .single, paramNames: [kModel], alwaysVisible: false)
//            //order options
//            models = SearchConfiguration.sortedAvailableOptions(models, ascending: modelRow.isSortAscending, isSortNumerically: modelRow.isSortNumerically)
//            
//            showAllModels(for: modelRow, availableModels: models)
//        } else {
//            searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//        }
//    }
//}
