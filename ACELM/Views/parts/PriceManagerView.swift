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

    var madeCall = false
    
    // Create String for call to nrel.gov
    func makeCallURL(lat: Double, lon: Double) -> String{
        var callURL: String
        let first = "https://developer.nrel.gov/api/utility_rates/v3.json?api_key=vF2cE7Yqpb77CKJThjNUJYO64GqByZtLnLiGmVTz"
        
        callURL = first + "&lat=\(lat)&lon=\(lon)"
        
        return callURL
    }
    
    // Once coordinates are acquired, calls makeCallURL along with error checking
    // makes call to API, decodes response
    func fetch(lat: Double, lon: Double){
        let url = makeCallURL(lat: lat, lon: lon)
        
        guard let url = URL(string: url) else{
            print("\n\n\n\nnot a good URL")
            return
        }
        
        //print(url)
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                print("\n\n\n\nbad data")
                return
            }
            //print(String(data: data, encoding: .utf8)!)
            print(">>>> API called")
            // converting to JSON
            do {
                let provider: ProviderData = try JSONDecoder().decode(ProviderData.self, from: data)
                DispatchQueue.main.async {
                    self?.myProvider = provider
                    self?.madeCall = true
                    print(">>>> \tProvider set. Made call [\(self!.madeCall)]")
                    //self?.setRateAndProvider(rate: &rate, sProvider: &sProvider, providerObj: provider)
                }

            }
            catch{
                print("error here")
                print(error)
            }
        }
        
        task.resume()
    }
    
    // Sets local rate and provider variables upon successful API call to nrel.gov
    func setRateAndProvider(rate: inout Double, sProvider: inout String, providerObj: ProviderData){
        
        print(">>>> Atempting to set provider/rate vars")
        rate = providerObj.outputs.residential
        sProvider = providerObj.outputs.utility_name
        print(">>>> \tProvider set [\(sProvider)]")
        print(">>>> \tRate set [\(rate)]")
    }
    
}

struct PriceManagerView: View {
    
    @StateObject var deviceLocationService = DeviceLocationService.shared
    
    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    @Binding var rate: Double
    @Binding var provider: String
    
    @Binding var SavedRate: Double
    @Binding var SavedProvider: String

    
    @StateObject var viewModel = ViewModel()
    @State var showingAlert = false
    
    // View that displays acquired provider and rate based on user coordinates
    // Saves any changes in local provider and rate variables to local storage
    var body: some View {

        Section(header: Text("Energy Provider")){
            
            Text("Provider: \(provider)")
                .onChange(of: viewModel.myProvider.outputs.utility_name) { newValue in
                    viewModel.setRateAndProvider(rate: &rate, sProvider: &provider, providerObj: viewModel.myProvider)
                    SavedRate = rate
                    SavedProvider = provider
                    print(">>>> Saved Rate and Provider name [\(SavedProvider), \(SavedRate)]")
                }
            Text("Rate ($/kWh): \(String(format: "%.2f", rate))")
            Button("Update to current location") {
                self.showingAlert = true
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Update Location"), message: Text("Are you sure you want to update to current location?"), primaryButton: .default(Text("Update"), action: {
                    print(">>>> Updating to current location")
                    SavedProvider = "None"
                    SavedRate = 0.0
                    providerInfoCheck()
                    //print("Updated [\(SavedProvider) , \(SavedRate)")
                    
                }), secondaryButton: .cancel())
            }
        }.onAppear{
            providerInfoCheck()
        }
    }
    
    // check if we have rate and provider saved, if we dont, get coordinates and make API call
    func providerInfoCheck(){
        if (SavedProvider != "None" && SavedRate != 0.0){
            // we have the provider name and rate saved
            print(">>>> Loading saved Provider info: [\(SavedProvider) , \(SavedRate)]")
            provider = SavedProvider
            rate = SavedRate
            print(">>>> Loaded. [\(provider) , \(rate)]")
        } else {
            print(">>>> Getting Coordinates and Provider Info")
            observeCoordinateUpdates()
            observeDeniedLocationAccess()
            deviceLocationService.requestLocationUpdates()
        }
    }

    // UNUSED
    func passRate(){
        rate = viewModel.myProvider.outputs.residential
        deviceLocationService.stopLocationUpdates()
        print(">>>> Got rate: [\(rate)]")
    }
    
    // Observes coordinate updates when requested by user
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
                print(">>>> Got Coordinates: [\(coordinates.latitude) , \(coordinates.longitude)]")
                viewModel.fetch(lat: coordinates.latitude, lon: coordinates.longitude)
                deviceLocationService.stopLocationUpdates()
                
                return
            }
            .store(in: &tokens)
    }

    // Observes denied user location 
    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                //print("alert.")
            }
            .store(in: &tokens)
    }
}

struct PriceManagerView_Previews: PreviewProvider {
    @State static var rate = 0.0
    @State static var provider = ""
    
    @State static var SavedRate = 0.0
    @State static var SavedProvider = ""
    
    static var previews: some View {
        PriceManagerView(rate: $rate, provider: $provider, SavedRate: $SavedRate, SavedProvider: $SavedProvider)
    }
}
