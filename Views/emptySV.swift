import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "cloud.sun")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
                .foregroundColor(.blue.opacity(0.7))

            Text("Weather App")
                .font(.title.bold())

            Text("Hãy nhập tên thành phố để lấy dữ liệu thời tiết thật từ Weather API.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.top, 40)
        .padding(.horizontal, 24)
    }
}
