/*
 EditStampView.swift
StampRecord

 Created by Takuto Nakamura on 2023/09/13.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import EmojiPalette

struct EditStampView<EVM: EditStampViewModel>: View {
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedField: FocusedField?
    @StateObject var viewModel: EVM

    var body: some View {
        VStack(spacing: 0) {
            HeaderHStack {
                Button("cancel") {
                    dismiss()
                }
                Text("editStamp")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                Button("done") {
                    viewModel.updateStamp {
                        dismiss()
                    }
                }
                .disabled(viewModel.disabledDone)
                .accessibilityIdentifier("EditStamp_DoneButton")
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.toolbarBackground)
            VStack(spacing: 48) {
                VStack(spacing: 24) {
                    Button {
                        viewModel.showEmojiPicker = true
                    } label: {
                        Text(viewModel.emoji)
                    }
                    .buttonStyle(SelectEmojiButtonStyle(transform: { label in
                        label.emojiPalette(selectedEmoji: $viewModel.emoji,
                                           isPresented: $viewModel.showEmojiPicker)
                    }))
                    .accessibilityIdentifier("EditStamp_EmojiButton")
                    VStack(alignment: .leading, spacing: 16) {
                        Text("summary")
                            .font(.headline)
                        TextField("inputSummary", text: $viewModel.summary)
                            .textFieldStyle(.summary)
                            .focused($focusedField, equals: .title)
                            .accessibilityIdentifier("EditStamp_SummaryTextField")
                    }
                }
                Button(role: .destructive) {
                    viewModel.showDeleteConfirmation = true
                } label: {
                    Label {
                        Text("deleteStamp")
                    } icon: {
                        Image(.stampFillXmark)
                    }
                }
                .buttonStyle(.delete)
                .accessibilityIdentifier("EditStamp_DeleteButton")
                .confirmationDialog(
                    "deleteMessage",
                    isPresented: $viewModel.showDeleteConfirmation,
                    titleVisibility: .visible,
                    actions: {
                        Button(role: .destructive) {
                            viewModel.deleteStamp {
                                dismiss()
                            }
                        } label: {
                            Text("deleteStamp")
                        }
                        .accessibilityIdentifier("EditStamp_ConfirmButton")
                    }
                )
                Spacer()
            }
            .padding(24)
        }
        .background(Color.cellBackground)
        .presentationDetents([.medium])
        .onTapGesture {
            focusedField = nil
        }
        .alertSRError(isPresented: $viewModel.showErrorAlert,
                      srError: viewModel.srError)
    }
}

#Preview {
    EditStampView(viewModel: PreviewMock.EditStampViewModelMock())
}
