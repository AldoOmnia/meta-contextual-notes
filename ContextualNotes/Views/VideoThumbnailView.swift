import SwiftUI
import AVFoundation

/// Shows video thumbnail when available, or placeholder for video recordings
struct VideoThumbnailView: View {
    let videoURL: String?
    let hasVideo: Bool
    let aspectRatio: CGFloat

    init(videoURL: String? = nil, hasVideo: Bool, aspectRatio: CGFloat = 16/9) {
        self.videoURL = videoURL
        self.hasVideo = hasVideo
        self.aspectRatio = aspectRatio
    }

    private var videoPlaceholder: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(aspectRatio, contentMode: .fit)
            Image(systemName: "video.fill")
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }

    var body: some View {
        Group {
            if hasVideo {
                if let url = videoURL.flatMap({ s in s.hasPrefix("/") ? Optional(URL(fileURLWithPath: s)) : URL(string: s) }),
                   FileManager.default.fileExists(atPath: url.path) {
                    VideoThumbnailImage(url: url, aspectRatio: aspectRatio)
                } else {
                    videoPlaceholder
                }
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .aspectRatio(aspectRatio, contentMode: .fit)
                    Image(systemName: "waveform")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct VideoThumbnailImage: View {
    let url: URL
    let aspectRatio: CGFloat
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
            }
        }
        .aspectRatio(aspectRatio, contentMode: .fit)
        .task {
            image = await extractThumbnail(from: url)
        }
    }

    private func extractThumbnail(from url: URL) async -> UIImage? {
        await Task.detached(priority: .userInitiated) {
            let asset = AVAsset(url: url)
            let generator = AVAssetImageGenerator(asset: asset)
            generator.appliesPreferredTrackTransform = true
            generator.maximumSize = CGSize(width: 400, height: 400)
            do {
                let result = try generator.copyCGImage(at: .zero, actualTime: nil)
                return UIImage(cgImage: result)
            } catch {
                return nil
            }
        }.value
    }
}
