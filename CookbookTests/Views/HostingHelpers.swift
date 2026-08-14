//
//  HostingHelpers.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//

internal import class       Foundation.RunLoop
internal import struct      Foundation.Date
internal import typealias   Foundation.TimeInterval
@testable import SwiftUICT_Capstone_Cookbook // import whole module due to extension helper
internal import class       SwiftUI.UIHostingController
internal import protocol    SwiftUI.View
internal import class UIKit.UIWindow
internal import class UIKit.UIWindowScene

@MainActor
func hostInWindow<V: View>(_ view: V) -> (UIWindow, UIHostingController<V>) {
    let window = UIWindowScene.current.map(UIWindow.init(windowScene:))!
    let hosting = UIHostingController(rootView: view)
    window.rootViewController = hosting
    window.makeKeyAndVisible()
    return (window, hosting)
}

@MainActor
func pumpRunLoop(for seconds: TimeInterval = 0.05) {
    RunLoop.main.run(until: Date().addingTimeInterval(seconds))
}
