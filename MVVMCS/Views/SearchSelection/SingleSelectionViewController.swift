////
////  SingleSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 6/21/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//class SingleSelectionViewController: SearchSelectionViewController {
//    
//    // Outlets
//    @IBOutlet private var tableView: UITableView!
//
//    // Computed properties
//    private var availableOptions: [Option] {
//        guard var options = searchConfiguration.availableOptions(for: parameter) else { return [] }
//
//        guard let typeOption = searchConfiguration.vehicleTypeOption()?.value,
//            let typeOptionValue = Int(typeOption),
//            let vehicleType = VehicleType(rawValue: typeOptionValue) else { return [] }
//
//        if (parameter.name == kSort) {
//            options = SearchConfiguration.customSortOptions(options, withDistanse: false, vehicleType: vehicleType)
//        } else {
//            options = SearchConfiguration.sortedAvailableOptions(options, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically)
//        }
//
//        return options
//    }
//
//    private var parameter: Parameter {
//        return searchConfiguration.parameterNamed(row.parameterNames?.first)
//    }
//
//    private var selectedOption: Option?
//    @objc var isAnyEnabled = false
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        theming()
//
//        //Data
//        if let config = searchConfiguration, config.hasSelectedOptions(for: parameter) {
//            let selectedOptions = config.selectedOptions(for: parameter)
//            selectedOption = selectedOptions?.first
//        }
//
//        navigationItem.title = row.localizedLabel
//        tableView.reloadData()
//        scrollTableToSeletedRow()
//
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.searchTableView(parameter.name)
//    }
//
//    // MARK: - Theming
//    override func theming() {
//        super.theming()
//
//        //Table View
//        tableView.setup(withSeparator: true, accessibilityId: nil)
//        tableView.contentInset = UIEdgeInsets(top: CGFloat(kBasePadding), left: 0, bottom: 0, right: 0)
//    }
//
//    private func scrollTableToSeletedRow() {
//        var indexPath: IndexPath?
//
//        guard !availableOptions.isEmpty else {
//            return
//        }
//
//        if let option = selectedOption {
//            let rowIndex = SearchConfiguration.index(of: option, in: availableOptions)
//
//            if rowIndex >= 0 && rowIndex < availableOptions.count {
//                indexPath = IndexPath(row: rowIndex, section: isAnyEnabled ? 1 : 0)
//
//                tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
//                tableView.applyNewContentOffset()
//            }
//        } else if isAnyEnabled {
//                tableView.selectRow(at: IndexPath.zero, animated: false, scrollPosition: .none)
//            tableView.scrollToFirstRow()
//        }
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension SingleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return isAnyEnabled ? 2 : 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isAnyEnabled && section == 0 {
//            return 1
//        }
//
//        return availableOptions.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SingleSelectionCell.reuseIdentifier()) as? SingleSelectionCell else {
//            return UITableViewCell()
//        }
//
//        //set data
//        let option = availableOptions[indexPath.row]
//        let shouldHighlight = isAnyEnabled && indexPath.section == 0 // All option
//        var selected = false
//
//        if let selectedOption = selectedOption, option.value == selectedOption.value {
//            selected = true
//        }
//
//        //check mark if needed
//        cell.selected(selected, isMultipleSelection: false)
//        cell.setupViews(shouldHighlight: shouldHighlight, for: parameter.name, and: option)
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
//        if isAnyEnabled && indexPath.section == 0 {
//
//            // Has selected & select all options
//            if let _ = selectedOption {
//                searchConfiguration.clear(parameter)
//                searchParameterChangeDelegate?.rowChanged?(row, in: nil)
//            }
//        } else {
//            let option = availableOptions[indexPath.row]
//            if option != selectedOption {
//                searchConfiguration.clearAndSelect(option)
//                searchParameterChangeDelegate?.rowChanged?(row, in: nil)
//            }
//        }
//
//        tableView.reloadData()
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//    }
//}
