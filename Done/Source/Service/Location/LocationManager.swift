//
//  LocationManager.swift
//  Done
//
//  Created by Mazhar Hussain on 6/9/22.
//

import Foundation
import CoreLocation
import GooglePlaces

protocol LocationServiceDelegate: AnyObject {
    func tracingLocation(currentLocation: CLLocation)
    func tracingLocationDidFailWithError(error: NSError)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    private var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    weak var delegate: LocationServiceDelegate?
    
    private override init() {
        
        super.init()
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager?.stopUpdatingLocation()
    }
    
    //MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else {
            return
        }

        self.lastLocation = location
        updateLocation(currentLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse,.authorizedAlways:
            self.locationManager?.startUpdatingLocation()
        case .denied, .restricted:
            print("Location service restricted")
        case .notDetermined:
            self.locationManager?.requestAlwaysAuthorization()
        @unknown default:
            print("Unknown location service")
        }
    }
    
    
    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        updateLocationDidFailWithError(error: error)
    }
    
    // Private function
    private func updateLocation(currentLocation: CLLocation){
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocation(currentLocation: currentLocation)
    }
    
    private func updateLocationDidFailWithError(error: NSError) {
        
        guard let delegate = self.delegate else {
            return
        }
        
        delegate.tracingLocationDidFailWithError(error: error)
    }
    
    private func fetchCurrentAddress(currentLocation: CLLocation) {
//
//        guard let delegate = self.delegate else {
//            return
//        }
//
//        CLGeocoder().reverseGeocodeLocation(currentLocation) {[weak self] (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let completeAddress = self?.getCompleteAddress(placemarks: placemarks)
//            delegate.trackingCurrentAddress(address: completeAddress ?? "")
//        }
    }
    
    
    private func getCompleteAddress(placemarks: [CLPlacemark]?) -> String {
        
        guard let placemarks = placemarks else {
            return ""
        }
        guard let placemark = placemarks.first, !placemarks.isEmpty else {return ""}
        let outputString = [placemark.name,
                            placemark.thoroughfare,
                            placemark.subThoroughfare,
                            placemark.locality,
                            placemark.postalCode,
                            placemark.subAdministrativeArea,
                            placemark.country].compactMap{$0}.joined(separator: ", ")
        return outputString
    }
    
    func getCurrentAddress(completion: @escaping (_ place: GMSPlace?) -> Void) {
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.formattedAddress.rawValue | GMSPlaceField.coordinate.rawValue))
        GMSPlacesClient().findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
            (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
            if let error = error {
                print("An error occurred: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                if placeLikelihoodList.count > 0 {
                    let likelihood = placeLikelihoodList[0]
                    let place = likelihood.place
                    print("Current address: ", String(describing: place.formattedAddress))
                    completion(place)
                }
            }
        })
    }
}
