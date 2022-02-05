//
//  SwiftUIExampleView.swift
//  Example
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

struct SwiftUIExampleView: View {
    // MARK: - Private properties

    private let viewModel = SwiftUIExampleViewModel()

    @State
    private var formattedDate = ""

    // MARK: - Render

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Current Date & Time ⏰")
                .font(.headline)

            Text(formattedDate)

            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Image("ItsAlwaysWineOClock")
                .resizable()
                .scaledToFit()
                .opacity(0.05)
                .rotationEffect(.radians(0.2))
        )
        .onReceive(viewModel.formattedDate) { formattedDate in
            self.formattedDate = formattedDate
        }
        .navigationTitle("🚀 SwiftUI Example")
        .navigationBarTitleDisplayMode(.large)
    }
}

// MARK: - Preview

struct SwiftUIExampleView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIExampleView()
    }
}
