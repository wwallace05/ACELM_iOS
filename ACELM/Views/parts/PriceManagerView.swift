//
//  PriceManagerView.swift
//  ACELM
//
//  Created by Will Wallace on 11/22/22.
//

import SwiftUI
import Combine

class ViewModel: ObservableObject{
    @Published var myProvider: ProviderData = ProviderData()

    
    func makeCallURL(lat: Double, lon: Double) -> String{
        var callURL: String
        let first = "https://developer.nrel.gov/api/utility_rates/v3.json?api_key=vF2cE7Yqpb77CKJThjNUJYO64GqByZtLnLiGmVTz"
        
        callURL = first + "&lat=\(lat)&lon=\(lon)"
        
        return callURL
    }
    
    func fetch(lat: Double, lon: Double){
        let url = makeCallURL(lat: lat, lon: lon)
        
        guard let url = URL(string: url) else{
            print("\n\n\n\nnot a good URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("\n\n\n\nbad data")
                return
            }
            
            // converting to JSON
            do {
                
                let provider: ProviderData = try JSONDecoder().decode(ProviderData.self, from: data)
                DispatchQueue.main.async {
                    self?.myProvider = provider
                    //print("\(provider)")
                }
            }
            catch{
                print("error here")
                print(error)
            }
        }
        task.resume()
    }
    
}

struct PriceManagerView: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    @StateObject var viewModel = ViewModel()
    
    @Binding var rate: Double
    
    var body: some View {

        Section(header: Text("Energy Provider")){
            Text("Provider: \(viewModel.myProvider.outputs.utility_name)")
            Text("Rate ($/kWh): \(viewModel.myProvider.outputs.residential)")
        }.onAppear{
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
    }

    func passRate(){
        rate = viewModel.myProvider.outputs.residential
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                
                viewModel.fetch(lat: coordinates.latitude, lon: coordinates.longitude)
                passRate()
                return
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("alert.")
            }
            .store(in: &tokens)
    }
}

struct PriceManagerView_Previews: PreviewProvider {
    @State static var rate = 0.0
    
    static var previews: some View {
        PriceManagerView(rate: $rate)
    }
}
