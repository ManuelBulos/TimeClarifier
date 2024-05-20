import SwiftUI

struct ContentView: View {
    @ObservedObject private var viewModel = ContentViewModel(userSettings: UserSettings())
    @FocusState public var isInputFieldFocused: Bool

    var body: some View {
        VStack {
            SearchInputView(inputTime: $viewModel.state.inputTime, 
                            isInputFieldFocused: _isInputFieldFocused)
            .padding()

            TimeZoneDisplayView(inputLocalTimeZoneAbbreviation: $viewModel.state.inputLocalTimeZoneAbbreviation, 
                                localTime: $viewModel.state.localTime)

            TimeZoneListView(timeZones: $viewModel.state.allTimeZonesAndTimes)
                .padding()
                .cornerRadius(8)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                isInputFieldFocused = true
            }
        }
    }
}
