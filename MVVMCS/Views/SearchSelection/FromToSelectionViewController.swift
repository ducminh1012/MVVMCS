////
////  FromToSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 7/1/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//class FromToSelectionViewController: SearchSelectionViewController {
//
//    @IBOutlet weak var tableView: UITableView!
//
//    private var selectedOption: Option?
//
//    @objc var isAnyEnabled = false
//    @objc var isFrom = false
//
//    // Computed properties
//    private var parameter: Parameter {
//        let parameterName = isFrom ? row.parameterNames?.first : row.parameterNames?[safe: 1]
//        return searchConfiguration.parameterNamed(parameterName)
//    }
//
//    private var availableOptions: [Option] {
//        let options = searchConfiguration.availableOptions(for: parameter)
//        return SearchConfiguration.sortedAvailableOptions(options, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        theming()
//
//        //load data
//        if searchConfiguration.hasSelectedOptions(for: parameter) {
//            let selectedOptions = searchConfiguration.selectedOptions(for: parameter)
//            selectedOption = selectedOptions?.first
//        }
//
//        //Update UI
//        navigationItem.title = title(for: row)
//        tableView.reloadData()
//
//        //Display the selected option
//        scrollTableToSeletedRow()
//
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.labelSearchTableView(parameter.name)
//    }
//
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
//        if let selected = selectedOption {
//            let selectedIndex = SearchConfiguration.index(of: selected, in: availableOptions)
//
//            if selectedIndex >= 0 && selectedIndex < availableOptions.count {
//                indexPath = IndexPath(row: selectedIndex, section: isAnyEnabled ? 1 : 0)
//
//                tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
//                tableView.applyNewContentOffset()
//            }
//        } else if isAnyEnabled {
//            tableView.selectRow(at: IndexPath.zero, animated: true, scrollPosition: .none)
//            tableView.scrollToFirstRow()
//        }
//    }
//
//    private func title(for row: SearchRow?) -> String? {
//        var label = parameter.localizedLabel() ?? ""
//        let posfix = isFrom ? localize("search.rowtitle.from") : localize("search.rowtitle.to")
//
//        if (row?.parameterNames?.first == kPayloadfrom) {
//            label = label.replacingOccurrences(of: posfix, with: "(kg) \(posfix)")
//        } else if (row?.parameterNames?.first == kTotwgtfrom) {
//            label = localize("vehicle.properties.weightTotal")
//            label = "\(label) (kg) \(posfix)"
//        }
//
//        return label
//    }
//
//    private func autoExchangeMinMax() {
//        let parameterFrom = searchConfiguration.parameterNamed(row.parameterNames?.first)
//        let parameterTo = searchConfiguration.parameterNamed(row.parameterNames?[safe: 1])
//
//        guard let optionFrom = searchConfiguration.selectedOptions(for: parameterFrom).first,
//            let optionTo = searchConfiguration.selectedOptions(for: parameterTo).first,
//            let fromValue = optionFrom.value.intValue,
//            let toValue = optionTo.value.intValue,
//            toValue < fromValue  else { return }
//
//        let optionFromId = optionFrom.id.replacingOccurrences(of: fromValue.stringValue, with: toValue.stringValue)
//        let optionToId = optionTo.id.replacingOccurrences(of: toValue.stringValue, with: fromValue.stringValue)
//
//        let newOptionFrom = searchConfiguration.option(withId: optionFromId)
//        let newOptionTo = searchConfiguration.option(withId: optionToId)
//
//        if let optionFrom = newOptionFrom, let optionTo = newOptionTo {
//            searchConfiguration.clearAndSelect(optionFrom)
//            searchConfiguration.clearAndSelect(optionTo)
//        }
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension FromToSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//       return isAnyEnabled ? 2 : 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if isAnyEnabled {
//            if section == 0 {
//                return 1
//            } else {
//                return availableOptions.count
//            }
//        }
//
//        return availableOptions.count
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
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: FromToSelectionCell.reuseIdentifier()) as? FromToSelectionCell else {
//            return UITableViewCell()
//        }
//
//        var option: Option?
//        var isSelected = false
//        let shouldHighlight = isAnyEnabled && indexPath.section == 0
//
//        // first row (all)
//        if !shouldHighlight {
//           option = availableOptions[safe: indexPath.row]
//        }
//
//        cell.setupViews(shouldHighlight: isAnyEnabled && indexPath.section == 0, for: option)
//
//        if option?.value == selectedOption?.value {
//            isSelected = true
//        }
//
//        //check mark or check box if needed
//        cell.selected(isSelected, isMultipleSelection: false)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if isAnyEnabled && indexPath.section == 0 {
//            searchConfiguration.clear(parameter)
//            searchParameterChangeDelegate?.rowChanged?(row, in: nil)
//        } else {
//            let option = availableOptions[indexPath.row]
//
//            if option != selectedOption {
//                searchConfiguration.clearAndSelect(option)
//                autoExchangeMinMax()
//                searchParameterChangeDelegate?.rowChanged?(row, in: nil)
//            }
//        }
//
//        tableView.reloadData()
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//    }
//}
