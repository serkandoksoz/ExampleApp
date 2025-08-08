//
//  SplashView.swift
//  ExampleApp
//
//  Created by Serkan Doksöz on 2.01.2025.
//

import SwiftUI

struct SplashScreen: Route {}

struct SplashView: View {
    @ObservedObject var viewModel: SplashViewModel

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Image(systemName: "pencil")
                .resizable()
                .scaledToFit()
                .frame(width: 240, height: 128)
                .padding(.bottom, 28)
        }
        .onAppear {
           
        }
    }
}

#Preview {
    SplashView(viewModel: .init())
}
