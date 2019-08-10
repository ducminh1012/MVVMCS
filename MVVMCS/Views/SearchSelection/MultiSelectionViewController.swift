////
////  MultiSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 6/24/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//class MultiSelectionViewController: SearchSelectionViewController {
//    @IBOutlet weak var tableView: UITableView!
//
//    private var paramInverseProperties: Parameter?
//    private var paramHasWarranty: Parameter?
//    private var hasDataChanges = false
//
//    // Computed properties
//    private var parameter: Parameter {
//        return searchConfiguration.parameterNamed(row.parameterNames?.first)
//    }
//
//    private var shouldSelectAllRow: Bool {
//        var shouldSelectFirstRow = false
//        if !searchConfiguration.hasSelectedOptions(for: parameter) {
//            shouldSelectFirstRow = true
//
//            if let paramInverseProps = paramInverseProperties, searchConfiguration.hasSelectedOptions(for: paramInverseProps) {
//                shouldSelectFirstRow = false
//            }
//
//            if let paramWarranty = paramHasWarranty, searchConfiguration.hasSelectedOptions(for: paramWarranty) {
//                shouldSelectFirstRow = false
//            }
//        }
//
//        return shouldSelectFirstRow
//    }
//
//    private var availableOptions: [Option] {
//        var options = [Option]()
//
//        let unSortedOptions = searchConfiguration.availableOptions(for: parameter)
//        let sortedOptions = SearchConfiguration.sortedAvailableOptions(unSortedOptions, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically)
//
//        if let sortedOptions = sortedOptions {
//            options = sortedOptions
//        }
//
//        //Properties row only
//        guard parameter.name != kProp else {
//            //add un - properties option
//            paramInverseProperties = searchConfiguration.parameterNamed(kUprop)
//
//            if let inverseOptions = searchConfiguration.availableOptions(for: paramInverseProperties)?.first {
//                options.append(inverseOptions)
//            }
//
//            guard let vehicleTypeOption = searchConfiguration.vehicleTypeOption(),
//                let vehicleType = VehicleType(rawValue: Int(vehicleTypeOption.value) ?? 0) else { return options }
//
//            //add has Warranty option
//            if vehicleType == .car || vehicleType == .commercialVehicle {
//                paramHasWarranty = searchConfiguration.parameterNamed(kHw)
//                paramHasWarranty?.options = [searchConfiguration.hasWarrantyOption()]
//                if let hasWarrantyOption = paramHasWarranty?.options.first as? Option {
//                    options.append(hasWarrantyOption)
//                }
//            }
//
//            return options
//        }
//
//        return options
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        theming()
//
//        //set title
//        navigationItem.title = row.localizedLabel
//
//        //reload table
//        tableView.reloadData()
//        scrollTableToSeletedRow()
//
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.searchTableView(parameter.name)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        if hasDataChanges {
//            commitDataChanged()
//        }
//        super.viewWillDisappear(animated)
//    }
//
//    override func theming() {
//        super.theming()
//
//        //Nav bar
//        setupNavigationBar()
//
//        //Table View
//        tableView.setup(withSeparator: true, accessibilityId: nil)
//        tableView.contentInset = UIEdgeInsets(top: CGFloat(kBasePadding), left: 0, bottom: 0, right: 0)
//    }
//
//    private func setupNavigationBar() {
//        addRightBarButtonItem(withTitle: localize("general.buttontitle.done"), target: self, action: #selector(onBackButton(_:)), isLessPadding: false)
//    }
//
//    private func scrollTableToSeletedRow() {
//        var indexPath: IndexPath?
//
//        guard searchConfiguration.hasSelectedOptions(for: parameter) else { return }
//
//        if let selectedOptions = searchConfiguration.sortedSelectedOptions(for: parameter, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically),
//            let firstOption = selectedOptions.first,
//            let selectedIndex = availableOptions.index(of: firstOption) {
//
//            if selectedIndex >= 0 && selectedIndex < availableOptions.count {
//                indexPath = IndexPath(row: selectedIndex, section: 1)
//            }
//        }
//
//        if let indexPath = indexPath {
//            tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
//            tableView.applyNewContentOffset()
//        } else {
//            tableView.selectRow(at: IndexPath.zero, animated: false, scrollPosition: .none)
//            tableView.scrollToFirstRow()
//        }
//    }
//
//    @objc
//    private func onBackButton(_ sender: Any?) {
//        if hasDataChanges {
//            commitDataChanged()
//        }
//
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//    }
//
//    override func commitDataChanged() {
//        searchParameterChangeDelegate?.rowChanged?(row, in: nil)
//        hasDataChanges = false
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension MultiSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 1 : availableOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: MultiSelectionCell.reuseIdentifier()) as? MultiSelectionCell else {
//            return UITableViewCell()
//        }
//
//        var localizedLabel = ""
//        var isSelected = false
//        var isMultipleSelection = true
//
//        // All option
//        if indexPath.section == 0 {
//            localizedLabel = localize("search.rowtitle.all")
//
//            isMultipleSelection = false
//            isSelected = shouldSelectAllRow
//        } else {
//            let option = availableOptions[safe: indexPath.row]
//
//            localizedLabel = option?.localizedLabel ?? ""
//            if (option?.parameterName == kHw) {
//                isSelected = searchConfiguration.hasSelectedOptions(for: paramHasWarranty)
//            } else {
//                isSelected = searchConfiguration.isOptionSelected(option)
//            }
//        }
//
//        //update cell
//        cell.setupViews(shouldHighlight: indexPath.section == 0, and: localizedLabel)
//        cell.selected(isSelected, isMultipleSelection: isMultipleSelection)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.updateDisplay(cell, forRowAt: indexPath)
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return kTableCellHeight
//    }
//
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if section == numberOfSections(in: tableView) - 1 {
//            return CGFloat(kBasePadding)
//        }
//
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        hasDataChanges = true
//
//        if indexPath.section == 0 {
//            searchConfiguration.clear(parameter)
//            if let paramInverseProps = paramInverseProperties {
//                searchConfiguration.clear(paramInverseProps)
//            }
//            if let paramWarranty = paramHasWarranty {
//                searchConfiguration.clear(paramWarranty)
//            }
//        } else {
//            let option = availableOptions[safe: indexPath.row]
//
//            if searchConfiguration.isOptionSelected(option) {
//                searchConfiguration.deselect(option)
//            } else if (option?.parameterName == kHw) && searchConfiguration.hasSelectedOptions(for: paramHasWarranty) {
//                searchConfiguration.clear(paramHasWarranty)
//            } else {
//                searchConfiguration.select(option)
//            }
//        }
//
//        tableView.reloadData()
//
//        if shouldSelectAllRow {
//            //Select the first row if no selected options
//            tableView.selectRow(at: IndexPath.zero, animated: false, scrollPosition: .none)
//        }
//
//    }
//}
