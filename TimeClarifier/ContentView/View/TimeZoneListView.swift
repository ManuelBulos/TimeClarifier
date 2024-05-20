//
//  TimeZoneListView.swift
//  TimeClarifier
//
//  Created by Main on 18/05/24.
//

import SwiftUI

struct TimeZoneListView: View {
    @Binding var timeZones: [String: String]

    var body: some View {
        List(timeZones.sorted(by: { $0.key < $1.key }), id: \.key) { timeZone, time in
            HStack {
                Text(timeZone)
                    .foregroundColor(.secondary)
                Spacer()
                Text(time)
                    .bold()
            }
            .font(.title3)
            .padding(.vertical, 2)
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
