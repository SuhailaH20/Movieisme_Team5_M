import SwiftUI

struct BackYellowButton: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        Button {
            dismiss()
        } label: {
            HStack(spacing: 6) {
                Image(systemName: "chevron.left")
                Text("Back")
            }
            .foregroundStyle(.yellow)
            .font(.system(size: 16, weight: .semibold))
        }
    }
}
