import Foundation
import MWDATCore

/// Meta Wearables DAT SDK — pairing, mic input, TTS output to glasses
@Observable
final class MetaDATService: MetaDATServiceProtocol {
    var isPaired: Bool = false
    var isConnected: Bool = false

    private var registrationTask: Task<Void, Never>?
    private var devicesTask: Task<Void, Never>?

    init() {
        configureSDK()
        startObservingStreams()
    }

    private func configureSDK() {
        do {
            try Wearables.configure()
        } catch {
            print("[MetaDAT] Failed to configure: \(error)")
        }
    }

    private func startObservingStreams() {
        let wearables = Wearables.shared

        registrationTask = Task { @MainActor in
            for await state in wearables.registrationStateStream() {
                isPaired = (state == .registered)
            }
        }

        devicesTask = Task { @MainActor in
            for await devices in wearables.devicesStream() {
                isConnected = !devices.isEmpty
            }
        }
    }

    func startPairing() async {
        do {
            try await Wearables.shared.startRegistration()
        } catch {
            print("[MetaDAT] startRegistration failed: \(error)")
        }
    }

    func handleURL(_ url: URL) async {
        do {
            _ = try await Wearables.shared.handleUrl(url)
        } catch {
            print("[MetaDAT] handleUrl failed: \(error)")
        }
    }

    func playTTS(_ text: String) async {
        // TODO: Wire to glasses TTS when available
        print("[MetaDAT] TTS: \(text)")
    }

    func startListening(phraseHandler: @escaping (String) -> Void) {
        // TODO: Wire to glasses mic when available
    }

    func stopListening() {
        // TODO
    }
}

protocol MetaDATServiceProtocol {
    var isPaired: Bool { get }
    var isConnected: Bool { get }
    func startPairing() async
    func playTTS(_ text: String) async
}
