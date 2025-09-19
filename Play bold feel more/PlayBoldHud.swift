import Foundation
import SwiftUI

struct PlayBoldEntryScreen: View {
    @StateObject private var loader: PlayBoldWebLoader

    init(loader: PlayBoldWebLoader) {
        _loader = StateObject(wrappedValue: loader)
    }

    var body: some View {
        ZStack {
            PlayBoldWebViewBox(loader: loader)
                .opacity(loader.state == .finished ? 1 : 0.5)
            switch loader.state {
            case .progressing(let percent):
                PlayBoldProgressIndicator(value: percent)
            case .failure(let err):
                PlayBoldErrorIndicator(err: err)
            case .noConnection:
                PlayBoldOfflineIndicator()
            default:
                EmptyView()
            }
        }
    }
}

private struct PlayBoldProgressIndicator: View {
    let value: Double
    var body: some View {
        GeometryReader { geo in
            PlayBoldLoadingOverlay(progress: value)
                .frame(width: geo.size.width, height: geo.size.height)
                .background(Color.black)
        }
    }
}

private struct PlayBoldErrorIndicator: View {
    let err: String
    var body: some View {
        Text("Ошибка: \(err)").foregroundColor(.red)
    }
}

private struct PlayBoldOfflineIndicator: View {
    var body: some View {
        Text("Нет соединения").foregroundColor(.gray)
    }
}
