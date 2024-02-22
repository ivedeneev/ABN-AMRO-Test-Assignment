//
//  NoAppView.swift
//  ABNLocationPicker
//
//  Created by Igor Vedeneev on 21/02/2024.
//

import SwiftUI

struct NoAppView: View {
    var body: some View {
        Label("NoAppOverlay.Title", systemImage: "exclamationmark.circle.fill")
            .font(.body)
            .bold()
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .listRowInsets(EdgeInsets())
            .listRowBackground(EmptyView())
            .padding(.horizontal)
            .padding(.vertical, 12)
            .frame(minHeight: 50.667) // Dirty hack to make height of the view equal to the one in the ListView
            .background(Color.indigo)
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.cornerRadius))
    }
}
