import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    let onSearch: () -> Void
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            TextField("Nhập tên thành phố...", text: $text)
                .textFieldStyle(.roundedBorder)
                .submitLabel(.search)
                .onSubmit {
                    onSearch()
                }

            Button(action: onSearch) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 18, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: onClear) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 44, height: 44)
                    .background(Color.gray.opacity(0.15))
                    .foregroundColor(.primary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }
}
