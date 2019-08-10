////
////  SubSingleSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 7/1/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//class SubSingleSelectionViewController: SearchSelectionViewController {
//
//    // Outlets
//    @IBOutlet weak var tableView: UITableView!
//
//    private var selectedOption: Option?
//    private var shouldHighlightParent = false // enable when 1 option has childs.
//
//    @objc var vehicleSearchSlot: VehicleSearchSlot!
//    @objc var isOpennedFromDealerMakes = false
//
//    // Computed properties
//    private var parameter: Parameter {
//        return searchConfiguration.parameterNamed(row.parameterNames?.first)
//    }
//
//    @objc private var availableOptions: [Option] {
//        var options = [Option]()
//        if row.isModel {
//            options = vehicleSearchSlot?.availableModels() ?? []
//        } else {
//            options = searchConfiguration.availableOptions(for: parameter)
//        }
//
//        options = SearchConfiguration.sortedAvailableOptions(options, ascending: row.isSortAscending, isSortNumerically: row.isSortNumerically)
//
//        return options
//    }
//
//    private var sections = [[Option]]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //UI setup
//        theming()
//        setupSections()
//
//        //get data
//        if row.isModel {
//            selectedOption = vehicleSearchSlot?.model
//        } else {
//            if searchConfiguration.hasSelectedOptions(for: parameter) {
//                let selectedOptions = searchConfiguration.selectedOptions(for: parameter)
//                selectedOption = selectedOptions?.first
//            }
//        }
//
//        //update UI
//        navigationItem.title = title(for: row)
//        if row.isModel {
//            tableView.contentInset = .zero
//            setupTableHeaderView()
//        }
//        tableView.reloadData()
//        scrollTableToSeletedRow()
//
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.labelSearchTableView(parameter.name)
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
//    private func setupTableHeaderView() {
//        let makeLabel = vehicleSearchSlot?.make.localizedLabel
//
//        let width = tableView.frame.width
//        let height = SearchChooseModelHeaderView.height(forMakeLabel: makeLabel, parentWidth: width)
//
//        let headerView = SearchChooseModelHeaderView(frame: CGRect(x: 0, y: 0, width: width, height: height))
//        headerView.makeLabel = makeLabel
//
//        tableView.tableHeaderView = headerView
//    }
//
//    @objc func navigationShouldPopOnBackButton() -> Bool {
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//        return false
//    }
//
//    private func setupSections() {
//        var tmpSections = [[Option]]()
//        let options = availableOptions
//        if isOpennedFromDealerMakes {
//            //Can not detach parents/children --> display all options with the same level
//            for option in options {
//                tmpSections.append([option])
//            }
//        } else {
//            let parentOptions = options.filter({ $0.isParent })
//
//            for parentOption in parentOptions {
//                var optionsForGroup = [Option]()
//
//                //childen
//                let children = searchConfiguration.childOptions(forGroupId: parentOption.groupId, options: options) ?? []
//                if !children.isEmpty {
//                    optionsForGroup.append(contentsOf: children)
//                    shouldHighlightParent = true
//                }
//
//                //parent option
//                optionsForGroup.insert(parentOption, at: 0)
//
//                //add children to group
//                tmpSections.append(optionsForGroup)
//            }
//
//        }
//
//        //add all group
//        let firstOption = Option(value: localize("search.rowtitle.all"), parameterName: "all")!
//        tmpSections.insert([firstOption], at: 0)
//
//        sections = tmpSections
//    }
//
//    private func scrollTableToSeletedRow() {
//        let indexPath = self.indexPath(for: selectedOption)
//
//        if let indexPath = indexPath {
//            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .middle)
//            tableView.applyNewContentOffset()
//        } else {
//            //All row
//            tableView.selectRow(at: IndexPath.zero, animated: false, scrollPosition: .none)
//            tableView.scrollToFirstRow()
//        }
//    }
//
//    private func title(for row: SearchRow?) -> String? {
//        var title: String? = nil
//        if row?.isModel != nil {
//            title = localize("models.navbartitle")
//        } else {
//            title = self.row.localizedLabel
//        }
//
//        return title
//    }
//
//    private func indexPath(for option: Option?) -> IndexPath? {
//        if option == nil {
//            return nil
//        }
//
//        for s in 1..<sections.count {
//            let section = sections[s]
//            if let option = option, let index = section.index(of: option) {
//                return IndexPath(row: index, section: s)
//            }
//        }
//
//        return nil
//    }
//
//    private func options(inSection section: Int) -> [Option]? {
//        return sections[section]
//    }
//
//    private func option(at indexPath: IndexPath) -> Option? {
//        let options = self.options(inSection: indexPath.section)
//        return options?[indexPath.row]
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension SubSingleSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sections.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return section == 0 ? 1 : sections[section].count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: SubSingleSelectionCell.reuseIdentifier()) as? SubSingleSelectionCell else {
//            return UITableViewCell()
//        }
//
//        let option = self.option(at: indexPath)
//        var font = currentTheme.regularMediumFont()
//        var title = option?.localizedLabel
//
//        if indexPath.section == 0 {
//            title = sections[indexPath.section].first?.value
//        } else {
//            if !isOpennedFromDealerMakes {
//                if (shouldHighlightParent) {
//                    guard let option = option else { return cell }
//                    if !option.isParent {
//                        font = currentTheme.regularLightFont()
//                        title = "    \(option.localizedLabel)"
//                    }
//                } else {
//                    font = currentTheme.regularLightFont()
//                }
//            }
//        }
//
//        cell.textLabel?.font = font
//        cell.textLabel?.text = title
//
//
//        let selected = (option == selectedOption) ? true : false
//        cell.selected(selected, isMultipleSelection: false)
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.updateDisplay(cell, forRowAt: indexPath)
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
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return kTableCellHeight
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if indexPath.section == 0 {
//            if row.isModel {
//                vehicleSearchSlot?.clearModel()
//            } else {
//                searchConfiguration.clear(parameter)
//            }
//            searchParameterChangeDelegate?.rowChanged?(row, in: vehicleSearchSlot)
//        } else {
//            let option = self.option(at: indexPath)
//
//            if option != selectedOption {
//                if row.isModel {
//                    vehicleSearchSlot?.selectModel(option)
//                } else {
//                    searchConfiguration.clearAndSelect(option)
//                }
//                searchParameterChangeDelegate?.rowChanged?(row, in: vehicleSearchSlot)
//            }
//        }
//
//        searchParameterChangeDelegate?.selectionViewControllerDidEnd?(self, animated: true)
//    }
//}
