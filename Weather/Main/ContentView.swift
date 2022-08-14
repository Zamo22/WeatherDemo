//
//  Created by Zaheer Moola on 2022/08/12.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = MainViewModel()

    var body: some View {
        Group {
            switch viewModel.viewState {
            case .loading:
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            case .locationError:
                Text("Error getting location")
            case .permissionDenied:
                Text("You have denied permissions")
            case .loaded(let currentLocation):
                WeatherView(pages: viewModel
                    .buildWeatherPages(with: currentLocation))
            }
        }.onAppear {
            viewModel.getCurrentLocation()
        }
    }
}

struct WeatherView: View {
    let pages: [Coordinate]

    var body: some View {
        TabView {
            ForEach(pages, id: \.self) { coordinate in
                let viewModel = WeatherViewModel(withLocation: coordinate)
                IndividualWeatherView(viewModel: viewModel)
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
