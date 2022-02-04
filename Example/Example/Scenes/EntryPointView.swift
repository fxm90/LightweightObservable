//
//  EntryPointView.swift
//  Example
//
//  Created by Felix Mau on 05.02.22.
//  Copyright © 2022 Felix Mau. All rights reserved.
//

import SwiftUI

struct EntryPointView: View {
    // MARK: - Private properties

    @State
    private var isWebViewExampleVisible = false

    // MARK: - Render

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Example Application")) {
                    NavigationLink(destination: UIKitExampleView()) {
                        TitleSubtitleView(title: "🏡 UIKit Example",
                                          subtitle: "Example for an MVVM implementation.")
                    }

                    NavigationLink(destination: SwiftUIExampleView()) {
                        TitleSubtitleView(title: "🚀 SwiftUI Example",
                                          subtitle: "Example for the `Combine` wrapper.")
                    }
                }
            }
            // Unfortunately setting the title here results in constraint warnings.
            // I couldn't find a possible fix yet, even `.navigationViewStyle(.stack)` doesn't seem to work.
            // https://stackoverflow.com/q/65316497
            .navigationTitle("📬 Lightweight Observable")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Subviews

private struct TitleSubtitleView: View {
    let title: LocalizedStringKey
    let subtitle: LocalizedStringKey

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
            Text(subtitle)
                .font(.subheadline)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Preview

struct EntryPointView_Previews: PreviewProvider {
    static var previews: some View {
        EntryPointView()
    }
}
