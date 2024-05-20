//
//  TimeZoneDisplayView.swift
//  TimeClarifier
//
//  Created by Main on 18/05/24.
//

import SwiftUI

struct TimeZoneDisplayView: View {
    @Binding var inputLocalTimeZoneAbbreviation: String
    @Binding var localTime: String

    var body: some View {
        HStack {
            Text("Local time:")
                .foregroundColor(.secondary)

            TextField("", text: $inputLocalTimeZoneAbbreviation)
                .frame(width: 60)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(5)
                .background(.background)
                .cornerRadius(8)

            Text(localTime)
                .bold()
        }
        .padding(.horizontal)
    }
}
