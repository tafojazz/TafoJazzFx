import AudioKit
import AVFoundation
import SoundpipeAudioKit

class VoiceProcessor: ObservableObject {
    private let engine = AudioEngine()
    private var mic: AudioEngine.InputNode?
    private var booster: Fader?
    private var mixer: Mixer?

    init() {
        Settings.audioInputEnabled = true

        guard let input = engine.input else {
            print("❌ No se pudo acceder al micrófono.")
            return
        }

        mic = input
        booster = Fader(mic!, gain: 1.0)
        mixer = Mixer(booster!)
        engine.output = mixer
    }

    func start() {
        do {
            try engine.start()
            print("✅ Motor de audio iniciado")
        } catch {
            print("❌ Error al iniciar el motor de audio: \(error)")
        }
    }

    func stop() {
        engine.stop()
        print("🛑 Motor de audio detenido")
    }

    func setGain(_ value: AUValue) {
        booster?.gain = value
        print("🎚️ Ganancia ajustada a \(value)")
    }
}

