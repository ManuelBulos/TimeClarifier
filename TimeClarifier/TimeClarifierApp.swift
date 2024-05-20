import SwiftUI

@main
struct TimeClarifierApp: App {

    #if os(macOS)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    #endif

    #if os(macOS)
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
    #else
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    #endif
}
