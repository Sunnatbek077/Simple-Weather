//
//  BlurView.swift
//  Simple-Weather
//
//  Created by Sunnatbek on 15/01/25.
//

import Foundation
import SwiftUI

// link https://gstvdfnbch.medium.com/two-ways-to-do-glassmophisms-in-swiftui-swiftui-uikit-uiblureffect-7b63da1a9292

// Define a new struct named BlurView, which conforms to UIViewRepresentable. This allows SwiftUI to use UIViews.
struct BlurView: UIViewRepresentable {
    
    // Declare a property 'style' of type UIBlurEffect.Style to store the blur effect style.
    let style: UIBlurEffect.Style
    
    // Initializer for the BlurView, taking a UIBlurEffect.Style as a parameter and setting it to the 'style' property.
    init(style: UIBlurEffect.Style) {
        self.style = style
    }
    
    // Required method of UIViewRepresentable protocol. It creates and returns the UIVisualEffectView.
    func makeUIView(context: Context) -> UIVisualEffectView {
        // Create a UIBlurEffect with the specified 'style'.
        let blurEffect = UIBlurEffect(style: style)
        // Initialize a UIVisualEffectView with the blurEffect.
        let blurView = UIVisualEffectView(effect: blurEffect)
        // Return the configured blurView.
        return blurView
    }
    
    // Required method of UIViewRepresentable protocol. Here, it's empty as we don't need to update the view after creation.
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}   
