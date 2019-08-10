////
////  LocationSelectionViewController.swift
////  AutoScout24
////
////  Created by Duc Le on 7/15/19.
////  Copyright © 2019 Scout24.ch. All rights reserved.
////
//
//import UIKit
//
//class LocationSelectionViewController: SearchSelectionViewController {
//    // Outlets
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeightLayoutConstraint: NSLayoutConstraint!
//
//    private var searchBar: LocationSearchBar!
//
//    //Data properties
//    private var selectedLocation: Location?
//    private var locations = [Location]()
//    private var locationHistory = [Location]()
//    private var getLocationsOperation: Operation?
//    private var showHistory = true
//    private var didSelectLocation = false // Tracking only
//
//    // Computed properties
//    private var parameter: Parameter {
//        return searchConfiguration.parameterNamed(row.parameterNames?.first)
//    }
//
//    // MARK: Actions
//    private func onDoneButton(_ sender: Any?) {
//        dismissKeyboard()
//        CurrentLocationController.shared().cancelLocationRequest()
//
//        // GTM
//        AnalyticsTrackerService.sharedTracker().trackEvent(kCategorySearch, action: (didSelectLocation ? kActionAutocompleteSuccess : kActionAutocompleteCancel), optional: nil)
//
//        dismiss(animated: true)
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        setupSearchBar()
//        setupTableView()
//        registerKeyboardNotifications()
//        presentKeyboard()
//        requestUserLocation()
//
//        // Load data
//        setupData()
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        //clear data
//        CurrentLocationController.shared().cancelLocationRequest()
//    }
//
//    override func theming() {
//        view.backgroundColor = .white
//    }
//
//    private func setupData() {
//        // Load history from cache
//        locationHistory = LocationService.shared().historyLocations
//
//        //Load selected location from cache
//        if let selectedOptions = searchConfiguration.selectedOptions(for: parameter) {
//            let firstPlace = selectedOptions.first?.localizedLabel ?? ""
//
//            if !firstPlace.isEmpty {
//                selectedLocation = Location(place: firstPlace)
//            }
//        }
//
//        //Add the current to history if needed
//        if let location = selectedLocation, !LocationService.shared().isHistoryLocation(location) {
//            LocationService.shared().pushHistoryLocation(location)
//        }
//
//        //Insert current location
//        locationHistory.insert(Location.forCurrent(), at: 0)
//    }
//
//    private func setupTableView() {
//        //Table View
//        tableView.setup(withSeparator: true, accessibilityId: nil)
//        //for QA test
//        tableView.accessibilityIdentifier = AccessibilityIdentifiers.labelSearchTableView(parameter.name)
//    }
//
//    private func requestUserLocation() {
//        CurrentLocationController.shared().askUserForLocationAccessOnlyIfItIsTheFirstTime()
//    }
//
//    private func setupSearchBar() {
//        searchBar = LocationSearchBar(frame: CGRect(x: 0, y: 0, width: Constants.screenWidth(), height: kNavigationBarHeight))
//        searchBar.delegate = self
//        navigationItem.titleView = searchBar
//    }
//}
//
//// MARK: UISearchBarDelegate
//extension LocationSelectionViewController: UISearchBarDelegate {
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//
//        let trimmedText = searchText.removingNewLinesAndWhitespace() ?? ""
//        guard !trimmedText.isEmpty else {
//            showHistory = true
//            tableView.reloadData()
//            return
//        }
//
//        showHistory = false
//        search(by: trimmedText)
//    }
//
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        onDoneButton(searchBar)
//    }
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        if !locations.isEmpty {
//            tableView(tableView, didSelectRowAt: IndexPath.zero)
//        } else {
//            onDoneButton(searchBar)
//        }
//
//        searchBar.text = ""
//        dismissKeyboard()
//    }
//}
//
//// MARK: UITableViewDelegate, UITableViewDataSource
//extension LocationSelectionViewController: UITableViewDelegate, UITableViewDataSource {
//    // Return the number of rows in the section.
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var numberOfRows = 0
//
//        if showHistory {
//            numberOfRows = locationHistory.count
//        } else {
//            numberOfRows = (locations.count > 0) ? locations.count : 1
//        }
//
//        return numberOfRows
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        var location: Location!
//
//        if showHistory {
//            location = locationHistory[indexPath.row]
//
//            let isUsingCoordinate = location?.isUsingCoordinates ?? false
//            if isUsingCoordinate {
//                if let cell = tableView.dequeueReusableCell(withIdentifier: CurrentLocationCell.reuseIdentifier()) as? CurrentLocationCell {
//                    cell.location = location
//                    return cell
//                }
//            } else {
//                if let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier()) as? LocationCell {
//                    cell.location = location
//                    return cell
//                }
//            }
//        } else {
//            if !locations.isEmpty {
//                location = locations[indexPath.row]
//                if let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier()) as? LocationCell {
//                    cell.location = location
//                    return cell
//                }
//            } else {
//                if let cell = tableView.dequeueReusableCell(withIdentifier: NoLocationCell.reuseIdentifier()) as? NoLocationCell {
//                    return cell
//                }
//            }
//        }
//
//        return UITableViewCell()
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        tableView.updateDisplay(cell, forRowAt: indexPath)
//
//        guard let cell = cell as? LocationCell, !showHistory else { return }
//        cell.updateKeywordText()
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        var height = kTableCellHeight
//        let width = Constants.screenWidth()
//        var location: Location?
//
//        if showHistory {
//            location = locationHistory[indexPath.row]
//
//            if let isUsingCoordinates = location?.isUsingCoordinates, isUsingCoordinates {
//                height = LocationCell.height(for: location, parentWidth: width)
//            }
//        } else {
//            if !locations.isEmpty {
//                location = locations[indexPath.row]
//                height = LocationCell.height(for: location, parentWidth: width)
//            }
//        }
//
//        return height
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if showHistory {
//            if indexPath.row == 0 { // Current location
//                handleSelectCurrentLocation()
//            } else {
//                handleSelectHistoryLocation(at: indexPath.row)
//            }
//        } else {
//            guard !locations.isEmpty else {
//                return
//            }
//
//            handleSelect(newLocation: locations[indexPath.row])
//        }
//
//        tableView.deselectRow(at: indexPath, animated: true)
//    }
//}
//
//// MARK: Keyboard notification
//extension LocationSelectionViewController {
//    private func registerKeyboardNotifications() {
//        // Show keyboard
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { [weak self] (notification) in
//            guard let self = self else { return }
//
//            // get keyboard size and loctaion
//            guard let keyboardRect = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
//            var keyboardFrame = keyboardRect.cgRectValue
//
//            // Need to translate the bounds to account for rotation.
//            keyboardFrame = self.view.convert(keyboardFrame, to: nil)
//
//            // get a rect for the textView frame
//            self.tableViewHeightLayoutConstraint.constant = self.view.bounds.height - self.tableView.frame.minY - keyboardFrame.height
//        }
//
//        // Hide keyboard
//        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { [weak self] (notification) in
//            guard let self = self else { return }
//
//            self.tableViewHeightLayoutConstraint.constant = self.view.bounds.height - self.tableView.frame.minY
//        }
//    }
//
//    private func dismissKeyboard() {
//        if searchBar.canResignFirstResponder {
//            searchBar.resignFirstResponder()
//        }
//    }
//
//    private func presentKeyboard() {
//        if searchBar.canBecomeFirstResponder {
//            searchBar.becomeFirstResponder()
//        }
//    }
//}
//
//// MARK: Request search
//extension LocationSelectionViewController {
//    private func search(by text: String) {
//        //cancel the previous request
//        cancelFetchRequest()
//
//        // First fetch locations from text
//        getLocationsOperation = LocationService.shared().asyncGetLocations(text, success: { [weak self] in
//            // success
//            SVProgressHUD.dismiss()
//            let result = LocationService.shared().matchingLocations ?? []
//
//            guard let self = self else { return }
//
//            //update data
//            self.locations = result
//
//            //Current location
//            if result.count == 1 {
//                // only 1 place, choose it automatically
//                guard let selectedLocation = result.first else { return }
//                self.handleSelect(newLocation: selectedLocation)
//            } else {
//                //Update UI
//                self.tableView.reloadData()
//            }
//            },
//
//        failure: { (error: Swift.Error?) in
//            self.handleRequestError(error!)
//        },
//        cancellation: {
//            SVProgressHUD.dismiss()
//        })
//    }
//
//    private func handleSelectHistoryLocation(at index: Int) {
//        handleSelect(newLocation: locationHistory[index])
//    }
//
//    private func handleSelect(newLocation: Location) {
//        didSelectLocation = true
//
//        if !newLocation.isEqualLocation(selectedLocation) {
//            //Save history
//            if !newLocation.isCurrentLocation() {
//                LocationService.shared().pushHistoryLocation(newLocation)
//            }
//
//            //Set selected place
//            searchParameterChangeDelegate?.rowChanged?(row, overrideText: newLocation.label, in: nil)
//        }
//
//        onDoneButton(searchBar)
//    }
//
//    private func handleSelectCurrentLocation() {
//        showHistory = false
//
//        let currentLocation = locationHistory.first!
//
//        CurrentLocationController.shared().updateLocation(currentLocation, performInBackground: true, success: { [weak self] (updatedLocation: Location?) in
//            guard let self = self else { return }
//            guard let newLocation = updatedLocation else { return }
//            //show text on search bar
//            self.searchBar.text = newLocation.label
//
//            guard newLocation.isValid else {
//                // The location finder failed to determine the current coordinates, show
//                // a message to the user and allow him to immediately retry to determine the current coordinates
//                self.locations.removeAll()
//
//                //Update UI
//                self.tableView.reloadData()
//
//                return
//            }
//
//            //Provide a max distance from the point in km
//            let queryString = "\(newLocation.latitude);\(newLocation.longitude);\(Global.maxDistanceFromUserLocation)"
//            self.search(by: queryString)
//
//            }, failure: { (error) in
//                //Reset data
//                self.locations.removeAll()
//
//                //Update UI
//                self.tableView.reloadData()
//
//        }, cancellation: nil)
//    }
//
//    private func handleRequestError(_ error: Swift.Error) {
//        //cancel current request
//        cancelFetchRequest()
//
//        //show hud error
//        let status = MessageService.shared().statusCode(fromError: error)
//        if status != .codeNotModified && status != .codeNotFound {
//            MessageService.showError(withStatus: status)
//        } else {
//            SVProgressHUD.dismiss()
//        }
//
//        tableView.reloadData()
//    }
//
//    private func cancelFetchRequest() {
//        if let operation = getLocationsOperation, !operation.isCancelled {
//            operation.cancel()
//        }
//        getLocationsOperation = nil
//    }
//}
