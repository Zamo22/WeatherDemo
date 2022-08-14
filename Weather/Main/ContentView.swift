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
                Text("Loading")
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
                TestView1()
            }
        }
        .tabViewStyle(PageTabViewStyle())
    }
}

struct TestView1: View {
    @StateObject var viewModel = WeatherViewModel()

    var body: some View {
        Text("\(viewModel.currentWeather?.temperatures.temp ?? 0)")
            .onAppear {

                viewModel.getWeather()
            }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
