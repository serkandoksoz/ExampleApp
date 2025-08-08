//
//  View+Extension.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 31.03.2025.
//


import SwiftUI

extension View {
    @ViewBuilder
    func createNavigationBarWithLogo(dismiss: DismissAction, title: String) -> some View {
        self
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack {
                        Spacer()
                        Text(title)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .semibold))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
    }
}

extension View {
    func showTabbar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController {
            DispatchQueue.main.async {
                tabBarController.tabBar.isHidden = false
            }
        }
    }
    
    func hideTabBar() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = scene.windows.first,
           let tabBarController = window.rootViewController as? UITabBarController {
            DispatchQueue.main.async {
                tabBarController.tabBar.isHidden = true
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

extension View {
    func onBackSwipe(perform action: @escaping () -> Void) -> some View {
        gesture(
            DragGesture()
                .onEnded({ value in
                    if value.startLocation.x < 50 && value.translation.width > 80 {
                        action()
                    }
                })
        )
    }
}
