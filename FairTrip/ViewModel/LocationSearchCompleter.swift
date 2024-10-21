//
//  LocationSearchCompleter.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 21/10/24.
//

import Foundation
import CoreLocation
import MapKit

class LocationSearchCompleter: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = "" {
        didSet {
            completer.queryFragment = searchQuery
            print("Search query updated: \(searchQuery)")
        }
    }
    @Published var suggestions: [MKLocalSearchCompletion] = []
    
    private var completer = MKLocalSearchCompleter()
    
    override init() {
        super.init()
        completer.delegate = self
        print("Completer delegate set")
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        suggestions = completer.results
        print("Fetched \(suggestions.count) suggestions")
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error fetching location suggestions: \(error)")
    }
}
