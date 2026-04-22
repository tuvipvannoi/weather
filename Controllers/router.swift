import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published var lastSearchedCity: String = ""
}
