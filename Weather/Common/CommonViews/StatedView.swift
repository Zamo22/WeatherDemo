//
//  Created by Zaheer Moola on 2022/08/16.
//

import SwiftUI

// Tightly coupled to the ViewState enum which is used throughout the app to switch between loading, loaded and erorr cases
// Handles loading and error states in a common way and abstracts the `loaded` state out to be handled by a closure
struct StatedView<Content: View, LoadedModelType>: View {
    private let state: ViewState
    private let loadedView: (LoadedModelType) -> Content

    init(state: ViewState, @ViewBuilder loadedView: @escaping (LoadedModelType) -> Content) {
        self.loadedView = loadedView
        self.state = state
    }

    var body: some View {
        switch state {
        case .error(let error):
            Text(error.description)
        case .loading:
            LoadingView()
        case .loaded(let data):
            loadedView(data as! LoadedModelType)
        }
    }
}
