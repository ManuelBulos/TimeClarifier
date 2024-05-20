//
//  AppDelegateTests.swift
//  TimeClarifierTests
//
//  Created by Main on 18/05/24.
//

import XCTest
@testable import TimeClarifier
import SwiftUI

class AppDelegateTests: XCTestCase {

    var appDelegate: AppDelegate!
    fileprivate var mockWindow: MockNSWindow!

    override func setUp() {
        super.setUp()
        appDelegate = AppDelegate()
        mockWindow = MockNSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 400),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered, defer: false)
        appDelegate.mainWindow = mockWindow
    }

    override func tearDown() {
        appDelegate = nil
        mockWindow = nil
        super.tearDown()
    }

    func testApplicationDidFinishLaunching() {
        // Given
        let notification = Notification(name: Notification.Name("TestNotification"))

        // When
        appDelegate.applicationDidFinishLaunching(notification)

        // Then
        XCTAssertNotNil(appDelegate.mainWindow)
        XCTAssertTrue(mockWindow.isMakeKeyAndOrderFrontCalled || appDelegate.mainWindow!.isVisible)
    }

    func testApplicationOpenURL() {
        // Given
        let url = URL(string: "timeclarifier://open")!

        // When
        appDelegate.application(NSApplication.shared, open: [url])

        // Then
        XCTAssertNotNil(appDelegate.mainWindow)
        XCTAssertTrue(mockWindow.isMakeKeyAndOrderFrontCalled || appDelegate.mainWindow!.isVisible)
    }

    func testRequestAccessibilityPermissions() {
        // When
        appDelegate.requestAccessibilityPermissions()

        // Then
        XCTAssertTrue(AXIsProcessTrusted())
    }

    func testShowMainWindowWhenNotVisible() {
        // Given
        mockWindow._isVisible = false
        appDelegate.mainWindow = mockWindow

        // When
        appDelegate.showMainWindow()

        // Then
        XCTAssertTrue(mockWindow.isMakeKeyAndOrderFrontCalled)
        XCTAssertTrue(mockWindow._isVisible)
    }

    func testShowMainWindowWhenVisible() {
        // Given
        mockWindow._isVisible = true
        appDelegate.mainWindow = mockWindow

        // When
        appDelegate.showMainWindow()

        // Then
        XCTAssertTrue(mockWindow.isMakeKeyAndOrderFrontCalled)
        XCTAssertTrue(mockWindow._isVisible)
    }
}

import Cocoa

fileprivate class MockNSWindow: NSWindow {
    var isMakeKeyAndOrderFrontCalled = false
    var isOrderOutCalled = false
    var _isVisible: Bool = false

    override var isVisible: Bool {
        return _isVisible
    }

    override func makeKeyAndOrderFront(_ sender: Any?) {
        isMakeKeyAndOrderFrontCalled = true
        _isVisible = true
    }

    override func orderOut(_ sender: Any?) {
        isOrderOutCalled = true
        _isVisible = false
    }
}
