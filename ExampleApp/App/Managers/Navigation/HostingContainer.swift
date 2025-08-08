//
//  HostingContainer.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.12.2024.
//

import SwiftUI
import UIKit

final class HostingContainer<Content: View>: UIViewController {

    private var swiftUIView: Content

    init(swiftUIView: Content) {
        self.swiftUIView = swiftUIView
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a UIHostingController with your SwiftUI view
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = .clear

        // Add the UIHostingController as a child of your view controller
        addChild(hostingController)
        view.addSubview(hostingController.view)

        // Adjust the frame of the UIHostingController's view
        hostingController.view.frame = view.bounds

        // Notify the UIHostingController that it has been added as a child
        hostingController.didMove(toParent: self)
    }
}
