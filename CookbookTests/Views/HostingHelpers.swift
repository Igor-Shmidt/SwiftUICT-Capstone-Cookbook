//
//  HostingHelpers.swift
//  Cookbook
//
//  Created by Igor Shmidt on 13.08.2026.
//

@testable import SwiftUICT_Capstone_Cookbook
internal import SwiftUI
import UIKit

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
