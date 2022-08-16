//
//  Created by Zaheer Moola on 2022/08/15.
//

import SwiftUI

struct SettingsView: View {
    // This should be injected into the view, example of this is done in `IndividualWeatherView`. Keeping it like this for now for simplicity purposes
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        ScrollView {
            SettingsPickerView(viewModel: viewModel)
            SavedLocationsView(viewModel: viewModel)
        }
        Spacer()
    }
}

struct SettingsPickerView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            // Localization has been ignored for this demo for simplicty purposes
            Text("Display weather in:")
            Picker("Display weather in:", selection: $viewModel.unitOfMeasurement) {
                ForEach(UnitMeasurement.allCases) {
                    Text($0.commonName)
                }
            }
            .pickerStyle(.segmented)

        }
        .padding()
    }
}

struct SavedLocationsView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.savedLocations, id: \.self) { location in
                SavedLocationView(savedLocation: location, onDelete: {
                    viewModel.removeSavedLocation(location)
                })
            }
        }
        .padding([.leading, .trailing])
    }

    struct SavedLocationView: View {
        let savedLocation: SavedLocation
        let onDelete: () -> ()

        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.cyan.opacity(10))
                    .frame(height: 48)
                HStack {
                    Text(savedLocation.name ?? "")
                        .foregroundColor(.white)
                        .padding(.leading)
                    Spacer()
                    Button(action: onDelete) {
                        Image(systemName: "minus.circle.fill")
                            .foregroundColor(.white)
                            .font(.body)
                            .padding(.trailing)
                    }
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
