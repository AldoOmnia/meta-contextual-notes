import Foundation

/// Meta Wearables DAT SDK — pairing, mic input, TTS output to glasses
/// TODO: Integrate Meta DAT SDK when available
@Observable
final class MetaDATService: MetaDATServiceProtocol {
    var isPaired: Bool = false
    var isConnected: Bool = false

    func startPairing() async {
        // Placeholder: Meta DAT pairing flow
        isPaired = true
        isConnected = true
    }

    func playTTS(_ text: String) async {
        // Placeholder: TTS playback on glasses via Meta DAT
        print("[MetaDAT] TTS: \(text)")
    }

    func startListening(phraseHandler: @escaping (String) -> Void) {
        // Placeholder: Voice capture from glasses mic
    }

    func stopListening() {
        // Placeholder
    }
}

protocol MetaDATServiceProtocol {
    var isPaired: Bool { get }
    var isConnected: Bool { get }
    func startPairing() async
    func playTTS(_ text: String) async
}
