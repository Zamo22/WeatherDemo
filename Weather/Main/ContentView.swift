//
//  Created by Zaheer Moola on 2022/08/12.
//

import SwiftUI

struct ContentView: View {
    // This should be injected into the view, example of this is done in `IndividualWeatherView`. Keeping it like this for now for simplicity purposes
    @StateObject private var mainViewModel = MainViewModel()

    var body: some View {
        StatedView<WeatherView, Any>(state: mainViewModel.viewState, loadedView: { _ in
            WeatherView(mainViewModel: mainViewModel)
        })
        .onAppear {
            mainViewModel.getCurrentLocation()
        }
    }
}

struct WeatherView: View {
    @ObservedObject var mainViewModel: MainViewModel
    @State private var showSettings = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView {
                ForEach(Array(mainViewModel.pages.enumerated()), id: \.element) { index, coordinate in
                    /* Intentionally initiliazing the view model here, this will call the API on initialisation and results in a better user interface since the other Weather pages will already be loaded. Will not run on appear only */
                    let viewModel = WeatherViewModel(withLocation: coordinate, isCurrentLocation: index == 0)
                    IndividualWeatherView(viewModel: viewModel)
                }
            }
            .tabViewStyle(PageTabViewStyle())

            Button(action: settingsButtonTapped) {
                Image(systemName: "ellipsis")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding([.top, .trailing])
            }
        }
        .sheet(isPresented: $showSettings, onDismiss: {
            mainViewModel.refreshIfNeeded()
        }) {
            SettingsView()
        }
    }

    func settingsButtonTapped() {
        showSettings.toggle()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
