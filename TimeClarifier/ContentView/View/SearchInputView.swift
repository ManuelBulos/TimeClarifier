//
//  SearchInputView.swift
//  TimeClarifier
//
//  Created by Main on 18/05/24.
//

import SwiftUI

struct SearchInputView: View {
    @Binding var inputTime: String
    @FocusState var isInputFieldFocused: Bool

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)

            TextField("Enter time (e.g., 2pm CT)", text: $inputTime)
                .textFieldStyle(PlainTextFieldStyle())
                .padding(10)
                .background(.background)
                .cornerRadius(8)
                .focused($isInputFieldFocused)
        }
    }
}
