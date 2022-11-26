//
//  JSON_test.swift
//  ACELM
//
//  Created by Will Wallace on 11/22/22.
//

import SwiftUI

class ThisViewModel: ObservableObject{
    @Published var myProvider: ProviderData = ProviderData()

    
    func makeCallURL(lat: Double, lon: Double) -> String{
        var callURL: String
        let first = "https://developer.nrel.gov/api/utility_rates/v3.json?api_key=vF2cE7Yqpb77CKJThjNUJYO64GqByZtLnLiGmVTz"
        
        callURL = first + "&lat=\(lat)&lon=\(lon)"
        
        //confirmed
        return callURL
    }
    
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

struct JSON_test: View {
    
    @StateObject var viewModel = ThisViewModel()
    
    var body: some View {
        Form{
            Section{
                
                Text("Provider is not empty")
                Text("Your Provider is: \(viewModel.myProvider.outputs.utility_name)")
            }
        }.onAppear{
            viewModel.fetch(lat: 35.45, lon: -82.98)
        }
    }
}

struct JSON_test_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            JSON_test()
            //JSON_test()
        }
    }
}
