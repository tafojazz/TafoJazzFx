import AudioKit
import AVFoundation
import SoundpipeAudioKit

class VoiceProcessor: ObservableObject {
    private let engine = AudioEngine()
    private var mic: AudioEngine.InputNode?

    private var pitchShifter: PitchShifter!
    private var reverb: CostelloReverb!
    private var delay: Delay!
    private var mixer: Mixer!

    @Published var pitch: AUValue = 0.0 {
        didSet { pitchShifter.shift = pitch }
    }

    @Published var reverbAmount: AUValue = 0.5 {
        didSet { reverb.feedback = reverbAmount }
    }

    @Published var delayTime: AUValue = 0.2 {
        didSet { delay.time = delayTime }
    }

    init() {
        Settings.audioInputEnabled = true

        guard let input = engine.input else {
            print("❌ No se pudo acceder al micrófono.")
            return
        }

        mic = input

        pitchShifter = PitchShifter(mic!)
        reverb = CostelloReverb(pitchShifter)
        delay = Delay(reverb)

        pitchShifter.shift = pitch
        reverb.feedback = reverbAmount
        delay.time = delayTime

        mixer = Mixer(delay)
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
}


