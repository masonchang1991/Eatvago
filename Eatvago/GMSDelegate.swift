//
//  GMSDelegate.swift
//  Eatvago
//
//  Created by Ｍason Chang on 2017/8/7.
//  Copyright © 2017年 Ｍason Chang iOS#4. All rights reserved.
//

import UIKit
import GooglePlaces
// Handle the user's selection.
extension RandomGameViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWith place: GMSPlace) {
        searchController?.isActive = false
        // Do something with the selected place.
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        

        
        var location = Location(latitude: place.coordinate.latitude,
                     longitude: place.coordinate.longitude,
                     name: place.name,
                     id: "",
                     placeId: place.placeID,
                     types: place.types,
                     priceLevel: 0.0,
                     rating: Double(place.rating),
                     photoReference: "")
        
        location.formattedPhoneNumber = place.phoneNumber ?? ""
        
        print(place.website)
        print(place.website?.absoluteString)
        
        location.website = place.website?.absoluteString ?? ""
        

        
    }
    
    func resultsController(_ resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: Error){
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(forResultsController resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
