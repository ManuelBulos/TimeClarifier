//
//  AppDelegate.swift
//  TimeClarifier
//
//  Created by Main on 18/05/24.
//

#if os(macOS)
import SwiftUI
import Carbon

class AppDelegate: NSObject, NSApplicationDelegate {

    public var mainWindow: NSWindow?

    func applicationDidFinishLaunching(_ notification: Notification) {
        requestAccessibilityPermissions()
        NSApplication.setupHotKey()
        showMainWindow()  // Open the main window when the app launches
    }

    func application(_ application: NSApplication, open urls: [URL]) {
        for url in urls {
            if url.absoluteString == "timeclarifier://open" {
                showMainWindow()
            }
        }
    }
}

// MARK: - Window Management

extension AppDelegate {
    public func requestAccessibilityPermissions() {
        let options: [String: Bool] = [kAXTrustedCheckOptionPrompt.takeRetainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)

        if !accessEnabled {
            print("Access not enabled. Requesting accessibility permissions.")
        }
    }

    public func showMainWindow() {
        if let window = mainWindow, window.isVisible {
            window.makeKeyAndOrderFront(nil)
        } else {
            if let window = mainWindow {
                window.makeKeyAndOrderFront(nil)
            } else {
                let contentView = ContentView()
                let window = NSWindow(
                    contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
                    styleMask: [.titled, .closable, .resizable],
                    backing: .buffered, defer: false)
                window.center()
                window.setFrameAutosaveName("Main Window")
                window.contentView = NSHostingView(rootView: contentView)
                window.makeKeyAndOrderFront(nil)
                self.mainWindow = window
            }
        }
        NSApp.activate(ignoringOtherApps: true)
    }
}

// MARK: - NSApplication NSEvent Global Monitoring

fileprivate extension NSApplication {
    static func setupHotKey() {
        let opts: NSEvent.EventTypeMask = [.keyDown]
        NSEvent.addGlobalMonitorForEvents(matching: opts) { event in
            if event.modifierFlags.contains(.control) && event.keyCode == kVK_Space {
                print("Control+Spacebar pressed")
                if let url = URL(string: "timeclarifier://open") {
                    NSWorkspace.shared.open(url)
                }
            }
        }
    }
}
#endif
