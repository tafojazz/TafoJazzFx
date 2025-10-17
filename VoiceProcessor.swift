import Foundation
import AudioKit
import SoundpipeAudioKit
import AVFoundation

class VoiceProcessor: ObservableObject {
    let engine = AudioEngine()
    var mic: AudioEngine.InputNode!
    var reverb: CostelloReverb!
    var delay: Delay!
    var pitchShift: PitchShifter!
    var mixer: Mixer!

    @Published var reverbAmount: AUValue = 0.5 {
        didSet { reverb.feedback = reverbAmount }
    }
    @Published var delayTime: AUValue = 0.25 {
        didSet { delay.time = delayTime }
    }
    @Published var pitch: AUValue = 0.0 {
        didSet { pitchShift.shift = pitch }
    }

    init() {
        mic = engine.input
        // pitch shifter (used as pitch FX)
        pitchShift = PitchShifter(mic)
        pitchShift.shift = 0.0
        // reverb on the mixed signal
        reverb = CostelloReverb(pitchShift)
        reverb.feedback = 0.5
        // delay after reverb
        delay = Delay(reverb)
        delay.time = 0.25
        delay.feedback = 0.2

        mixer = Mixer(delay)
        engine.output = mixer
    }

    func start() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }

    func stop() {
        engine.stop()
        try? AVAudioSession.sharedInstance().setActive(false)
    }
}
