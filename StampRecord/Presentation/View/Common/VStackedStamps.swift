/*
 VStackedStamps.swift
 StampRecord

 Created by Takuto Nakamura on 2023/10/10.
 Copyright © 2023 Studio Kyome. All rights reserved.
*/

import SwiftUI
import FlexibleStack

struct VStackedStamps: View {
    @State var showErrorAlert: Bool = false
    @State var srError: SRError? = nil
    let alignment: BoxAlignment
    let stamps: [LoggedStamp]
    let removeStampHandler: (LoggedStamp) throws -> Void

    var body: some View {
        FlexibleVStack(alignment: alignment, spacing: 4) {
            ForEach(stamps) { stamp in
                if stamp.isIncluded {
                    Text(stamp.emoji)
                        .font(.system(size: 100))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.01)
                        .aspectRatio(1.0, contentMode: .fit)
                }
            }
        }
        .padding(4)
        .contextMenu {
            Section("removeStamp") {
                ForEach(stamps) { stamp in
                    if stamp.isIncluded {
                        Button(role: .destructive) {
                            do {
                                try removeStampHandler(stamp)
                            } catch let error as SRError {
                                srError = error
                                showErrorAlert = true
                            } catch {}
                        } label: {
                            Label {
                                Text(verbatim: "\(stamp.emoji) \(stamp.summary)")
                            } icon: {
                                Image(.stampFillMinus)
                            }
                        }
                        .accessibilityIdentifier("VStackedStamps_RemoveButton_\(stamp.summary)")
                    }
                }
            }
        }
        .alert(
            srError?.title ?? "",
            isPresented: $showErrorAlert,
            presenting: srError,
            actions: { _ in },
            message: { error in
                Text(error.errorDescription ?? "")
            }
        )
    }
}

#Preview {
    VStackedStamps(alignment: .center, stamps: [], removeStampHandler: { _ in })
}
