//
//  GooglePlacesManager.swift
//  Done
//
//  Created by Mazhar Hussain on 6/7/22.
//

import Foundation
import GooglePlaces

struct Place {
    
    let name: String
    let identifier: String
}


enum PlacesError: Error {
    case failedToFind
    case failedToGetCoordinates
    case faildToGetLocationFromCoordinate
}

final class GooglePlacesManager {
   
    static  let shared = GooglePlacesManager()
    private let client = GMSPlacesClient.shared()
    
    private init(){}
    
    // Get Places against a query
    public func findPlaces(query: String, completion: @escaping(Result<[Place], Error>) -> Void) {
     
        let filter = GMSAutocompleteFilter()
        filter.type = .noFilter
        
        client.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: nil) { results, error in
            guard let results = results, error == nil else {
                completion(.failure(PlacesError.failedToFind))
                return
            }
            let places: [Place] = results.compactMap({
                Place(name: $0.attributedFullText.string,
                      identifier: $0.placeID)
            })
            
            completion(.success(places))
        }
    }
    
    // Get coordinate from place
    public func resolveLocation(for place: Place, completion: @escaping(Result<CLLocationCoordinate2D, Error>) -> Void) {
        client.fetchPlace(fromPlaceID: place.identifier, placeFields: .coordinate, sessionToken: nil) { googlePlace, error in
            guard let googlePlace = googlePlace, error == nil else {
                completion(.failure(PlacesError.failedToGetCoordinates))
                return
            }
            
            let coordinate = CLLocationCoordinate2D(
                latitude: googlePlace.coordinate.latitude,
                longitude: googlePlace.coordinate.longitude)
            
            completion(.success(coordinate))
        }
    }
    
    public func findPlaceFromCurrentLocation(completion:
                                             @escaping(Result<String, Error>) -> Void) {
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) |
                                                  UInt(GMSPlaceField.placeID.rawValue))
        client.findPlaceLikelihoodsFromCurrentLocation(withPlaceFields: fields, callback: {
          (placeLikelihoodList: Array<GMSPlaceLikelihood>?, error: Error?) in
          if let error = error {
            print("An error occurred: \(error.localizedDescription)")
            completion(.failure(PlacesError.faildToGetLocationFromCoordinate))
            return
          }

          if let placeLikelihoodList = placeLikelihoodList {
            for likelihood in placeLikelihoodList {
              let place = likelihood.place
              print("Current Place name \(String(describing: place.name)) at likelihood \(likelihood.likelihood)")
              print("Current PlaceID \(String(describing: place.placeID))")
                completion(.success(place.name ?? ""))
                return
            }
          }
        })
    }
}

