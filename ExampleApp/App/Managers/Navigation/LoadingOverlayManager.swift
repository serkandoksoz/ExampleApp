//
//  LoadingOverlayManager.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.01.2025.
//

import UIKit

struct LoadingOverlay: Route {
    let show: Bool
}

class LoadingOverlayManager {
    private static let progressViewTag: Int = 1412

    static func setLoadingOverlay(visible: Bool) {
        DispatchQueue.main.async {
            if visible {
                showLoadingOverlay()
            } else {
                hideLoadingOverlay()
            }
        }
    }

    private static func showLoadingOverlay() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        /// Skip creating overlay if it already exists
        if window.subviews.first(where: { $0.tag == progressViewTag }) != nil {
            hideLoadingOverlay()
            showLoadingOverlay()
            return
        }
        
        /// Create a container view for the loading overlay
        let overlayView = UIView(frame: window.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        overlayView.tag = progressViewTag

        /// Add a loading indicator
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        overlayView.addSubview(activityIndicator)

        /// Center the activity indicator
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: overlayView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: overlayView.centerYAnchor)
        ])
        
        window.addSubview(overlayView)
    }

    private static func hideLoadingOverlay() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        if let overlayView = window.subviews.first(where: { $0.tag == progressViewTag }) {
            overlayView.removeFromSuperview()
        }
    }
}
