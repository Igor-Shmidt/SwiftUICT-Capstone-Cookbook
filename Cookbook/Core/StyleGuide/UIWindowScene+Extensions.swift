//
//  UIWindowScene+Extensions.swift
//  SwiftUICT-Capstone-Cookbook
//
//  Created by Igor Shmidt on 12.08.2026.
//

import Foundation
import UIKit

extension UIWindowScene {
    static var current: UIWindowScene? {
        UIApplication.shared.connectedScenes
            .first {
                $0 is UIWindowScene && [.foregroundActive, .foregroundInactive].contains($0.activationState)
            } as? UIWindowScene
    }

    static var currentScreenSize: CGSize {
        current?.screen.bounds.size ?? .zero
    }
}
