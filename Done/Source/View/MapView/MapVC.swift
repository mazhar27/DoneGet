//
//  MapVC.swift
//  Done
//
//  Created by Mazhar Hussain on 09/06/2022.
//

import UIKit
import GoogleMaps
import GooglePlaces
import Localize_Swift
import Alamofire
import SVProgressHUD
class MapVC: BaseViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var mapVu: UIView!
    
    //MARK: - Variables
    private var mapView = GMSMapView()
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var searchController: UISearchController?
    var selectedLocation: CLLocationCoordinate2D?
    private var selectedAddress : String?
    var isAddressEditing = false
    var addressId = 0
    var currentAddress : CustomerAddress?
    var isLocationAddedClousure:((_ isDismesed: Bool)->Void)?
    var marker = GMSMarker()
    
    private lazy var sourceMarker:GMSMarker = {
        let marker = GMSMarker()
        marker.icon = GMSMarker.markerImage(with: UIColor.blueThemeColor)
        marker.iconView?.shadowRadius = 5
        marker.iconView?.shadowOpacity = 0.6
        marker.iconView?.shadowColor = UIColor.blueThemeColor
        return marker
    }()
    
    //MARK: - UIViewController life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLocationBtn.setTitle("Add location".localized(), for: .normal)
        //        just commenting it to check
        //        LocationManager.sharedInstance.delegate = self
        addLeftBarButtonItem()
        //        getCurrentAddress()
        getAddressFromGoogleAPI(coords:  CLLocation(latitude: selectedLocation?.latitude ?? 0.0, longitude: selectedLocation?.longitude ?? 0.0))
        //        setUpGoogleMaps(lat: -33.86, long: 151.20)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //        setUpGoogleMaps()
        //        getCurrentAddress()
    }
  
    override func viewDidDisappear(_ animated: Bool) {
        self.mapView.clear()
        self.mapView.removeFromSuperview()
    }
    private func setUpGoogleMaps(lat: Double,long: Double){
        //        self.mapVu.addSubview(mapVu)
        
        let camera = GMSCameraPosition.camera(withLatitude: (lat), longitude: (long) , zoom: 16.0)
        mapView = GMSMapView.map(withFrame: mapVu.frame, camera: camera)
        mapView.frame = CGRect(x: 0, y: 0, width: mapView.frame.width, height: mapView.frame.height)
        mapVu.addSubview(mapView)
        
        // Creates a marker in the center of the map.
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        mapView.selectedMarker = marker1
        marker1.map = mapView
        
        self.mapView.delegate = self
        
        
    }
    
    private func addResultViewController() {
        if (resultsViewController == nil) {
            resultsViewController = GMSAutocompleteResultsViewController()
        }
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.formattedAddress.rawValue) |
                                                  UInt(GMSPlaceField.coordinate.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        resultsViewController?.placeFields = fields
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        searchController?.searchBar.delegate = self
        
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.placeholder = "Search".localized()
        
        searchController?.searchBar.setValue("Cancel".localized(), forKey: "cancelButtonText")
        
        if Localize.currentLanguage() == "ar" {
            searchController?.searchBar.semanticContentAttribute = .forceRightToLeft
        }else{
            searchController?.searchBar.semanticContentAttribute = .forceLeftToRight
        }
        navigationItem.titleView?.removeFromSuperview()
        navigationItem.titleView = searchController?.searchBar
        definesPresentationContext = true
        
        searchController?.hidesNavigationBarDuringPresentation = false
        guard let googleSearchVc =  searchController else {
            return
        }
        present(googleSearchVc, animated: true, completion: nil)
    }
    
    
    //MARK: - set Camera Position
    private func setCameraPosition(location: CLLocationCoordinate2D, placeName: String) {
        let camera = GMSCameraPosition(target: location, zoom: 13)
        mapView.animate(to: camera)
        sourceMarker.position = location
        sourceMarker.map = mapView
        
        
    }
    
    private func getCurrentAddress() {
        LocationManager.sharedInstance.getCurrentAddress { [weak self] place in
            if let place = place {
                self?.selectedLocation = place.coordinate
                self?.selectedAddress  = place.formattedAddress
                self?.addUnderLineTitle(title: place.formattedAddress ?? "", enableTap: true)
                self?.setCameraPosition(location: place.coordinate, placeName: place.name ?? "")
                self?.setUpGoogleMaps(lat: place.coordinate.latitude, long: place.coordinate.longitude)
            } else {
                self?.addUnderLineTitle(title: "", enableTap: true)
            }
        }
    }
    
    override func navigationTitleTapped() {
        addResultViewController()
    }
    
    //MARK: - IBActions
    @IBAction func addLocationBtnTpd(_ sender: Any) {
        let storyboard = getMainStoryboard()
        guard let vc = storyboard.instantiateViewController(AddLocationVC.self) else {
            return
        }
        if let loc = selectedLocation{
            vc.selectedLocation = loc
        }
        vc.address = selectedAddress ?? ""
        vc.modalPresentationStyle = .overFullScreen
        vc.dataPassClousure = {[weak self] (isDismesed) -> Void in
            //            self?.isLocationAddedClousure?(true)
            self?.navigationController?.popToRootViewController(animated: false)
        }
        vc.isAddressEditing = isAddressEditing
        vc.addressId = addressId
        if let address = currentAddress{
            vc.currentAddress = address
        }
        self.present(vc, animated: true)
        
    }
    private func removeSearchController(_ placeName: String) {
        searchController?.isActive = false
        navigationItem.titleView?.removeFromSuperview()
        addUnderLineTitle(title: placeName, enableTap: true)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -  GMSAutocompleteResults ViewController Delegate
extension MapVC: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        self.selectedLocation = place.coordinate
        self.selectedAddress  = place.formattedAddress
        setCameraPosition(location: place.coordinate, placeName: place.name ?? "")
        removeSearchController(place.formattedAddress ?? "")
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
}

//MARK: -  GMSMapViewDelegate
extension MapVC: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        sourceMarker.position = position.target
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        self.mapView.clear()
        self.mapView.removeFromSuperview()
        self.selectedLocation = coordinate
        getAddressFromGoogleAPI(coords: CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude))
    }
}

//MARK: -  UISearchBarDelegate
extension MapVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeSearchController(self.selectedAddress ?? "")
    }
}

extension MapVC: LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocation) {
        
        let location = CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude,
                                              longitude: currentLocation.coordinate.longitude)
        selectedLocation = location
        //setCameraPosition(location: location , placeName: "")
        LocationManager.sharedInstance.stopUpdatingLocation()
        
    }
    
    func tracingLocationDidFailWithError(error: NSError) {
        print(error.localizedDescription)
    }
    
}
extension MapVC{
    func getAddressFromGoogleAPI(coords: CLLocation) {
        
        let lat = String(coords.coordinate.latitude)
        let long = String(coords.coordinate.longitude)
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=\(Constants.Keys.GoogleMapsGeocodeKey)"
        print(url)
        SVProgressHUD.show()
        AF.request(url).validate().responseData {[weak self] response in
            
            switch response.result {
                
            case .success(let data):
                SVProgressHUD.dismiss()
                do {
                    let asJSON = try JSONSerialization.jsonObject(with: data)
                    print(asJSON)
                    
                    if let results = (asJSON as AnyObject).object(forKey: "results")! as? [NSDictionary] {
                        if results.count > 0 {
                            if let str = results[0]["formatted_address"] as? String {
                                print(str)
                                
                                self?.selectedAddress  = str
                                self?.addUnderLineTitle(title: str , enableTap: true)
                                if let loc = self?.selectedLocation{
                                    self?.setUpGoogleMaps(lat: loc.latitude, long: loc.longitude)
                                }
                                //                                        self.selectedAddressString = str
                                //                                        self.setMap(lat: coords.coordinate.latitude, long: coords.coordinate.longitude, placeName: self.selectedAddressString)
                            }
                        }
                    }
                    // Handle as previously success
                } catch {
                    // Here, I like to keep a track of error if it occurs, and also print the response data if possible into String with UTF8 encoding
                    // I can't imagine the number of questions on SO where the error is because the API response simply not being a JSON and we end up asking for that "print", so be sure of it
                    SVProgressHUD.dismiss()
                    print("error")
                }
                
            case .failure(let error):
                SVProgressHUD.dismiss()
                print(error.localizedDescription)
                // Handle as previously error
            }
        }
    }
}
