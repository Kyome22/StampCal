/*
 AddNewStampView.swift
 StampRecord

 Created by Takuto Nakamura on 2023/09/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct AddNewStampView<AVM: AddNewStampViewModel>: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    @StateObject var viewModel: AVM

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button("cancel") {
                    dismiss()
                }
                .accessibilityIdentifier("AddNewStamp_CancelButton")
                Text("newStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button("add") {
                    viewModel.addNewStamp {
                        dismiss()
                    }
                }
                .accessibilityIdentifier("AddNewStamp_AddButton")
                .disabled(viewModel.emoji.isEmpty || viewModel.summary.isEmpty)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.toolbarBackground)
            VStack(spacing: 24) {
                Button {
                    viewModel.showEmojiPicker = true
                } label: {
                    Text(viewModel.emoji)
                }
                .buttonStyle(.selectEmojiButton(transform: { label in
                    label.emojiPalette(selectedEmoji: $viewModel.emoji,
                                       isPresented: $viewModel.showEmojiPicker)
                }))
                .accessibilityIdentifier("AddNewStamp_EmojiButton")
                VStack(alignment: .leading, spacing: 16) {
                    Text("summary")
                        .font(.headline)
                    TextField("inputSummary", text: $viewModel.summary)
                        .textFieldStyle(.summary)
                        .accessibilityIdentifier("AddNewStamp_SummaryTextField")
                        .focused($focusedField, equals: .title)
                }
                Spacer()
            }
            .padding(24)
        }
        .background(Color.cellBackground)
        .presentationDetents([.medium])
        .onTapGesture {
            focusedField = nil
        }
        .alert(
            viewModel.srError?.title ?? "",
            isPresented: $viewModel.showErrorAlert,
            presenting: viewModel.srError,
            actions: { _ in },
            message: { error in
                Text(error.errorDescription ?? "")
            }
        )
    }
}

#Preview {
    AddNewStampView(viewModel: PreviewMock.AddNewStampViewModelMock())
}
