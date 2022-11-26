//
//  location_test.swift
//  ACELM
//
//  Created by Will Wallace on 11/21/22.
//

import SwiftUI
import Combine

struct location_test: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    var body: some View {
        VStack {
            Text("Latitude: \(coordinates.lat)")
                .font(.largeTitle)
            Text("Longitude: \(coordinates.lon)")
                .font(.largeTitle)
        }.onAppear{
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
}

struct location_test_Previews: PreviewProvider {
    static var previews: some View {
        location_test()
    }
}
