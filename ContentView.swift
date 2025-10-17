import SwiftUI

struct Preset: Identifiable, Codable {
    var id = UUID()
    var name: String
    var pitch: Float
    var reverb: Float
    var delay: Float
}

class PresetStore {
    static let key = "TafoJazzFX.LastPreset"

    static let defaultPresets: [Preset] = [
        Preset(name: "Soprano", pitch: 0.0, reverb: 0.35, delay: 0.12),
        Preset(name: "Alto", pitch: 0.0, reverb: 0.45, delay: 0.22),
        Preset(name: "Tenor", pitch: 0.0, reverb: 0.55, delay: 0.35),
        Preset(name: "Baritone", pitch: 0.0, reverb: 0.65, delay: 0.45)
    ]

    static func save(preset: Preset) {
        if let data = try? JSONEncoder().encode(preset) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    static func load() -> Preset? {
        if let data = UserDefaults.standard.data(forKey: key),
           let p = try? JSONDecoder().decode(Preset.self, from: data) {
            return p
        }
        return nil
    }
}

struct ContentView: View {
    @StateObject var processor = VoiceProcessor()
    @State private var isOn = false
    @State private var selectedPresetIndex = 0
    @State private var presets = PresetStore.defaultPresets

    var body: some View {
        VStack(spacing: 18) {
            // Logo
            if let uiImage = UIImage(named: "TafoLogo") {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 90)
                    .padding(.top, 8)
            } else {
                Text("TafoJazz FX")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 16)
            }

            Spacer()

            // On/Off button
            Button(action: {
                isOn.toggle()
                if isOn { processor.start() }
                else { processor.stop() }
            }) {
                Text(isOn ? "🔴 OFF" : "🟢 ON")
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isOn ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }.padding(.horizontal)

            // Preset picker
            Picker("Preset", selection: $selectedPresetIndex) {
                ForEach(Array(presets.enumerated()), id: \.(offset)) { idx, p in
                    Text(p.name).tag(idx)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .onChange(of: selectedPresetIndex) { newIndex in
                let p = presets[newIndex]
                processor.pitch = AUValue(p.pitch)
                processor.reverbAmount = AUValue(p.reverb)
                processor.delayTime = AUValue(p.delay)
                PresetStore.save(preset: p)
            }
            .padding(.horizontal)

            // Sliders
            VStack(alignment: .leading, spacing: 12) {
                Text("Pitch (semitones): \(String(format: "%.1f", processor.pitch))")
                Slider(value: Binding(get: { Double(processor.pitch) }, set: { processor.pitch = AUValue($0) }), in: -12...12, step: 0.1)

                Text("Reverb: \(String(format: "%.2f", processor.reverbAmount))")
                Slider(value: Binding(get: { Double(processor.reverbAmount) }, set: { processor.reverbAmount = AUValue($0) }), in: 0...1)

                Text("Delay time (s): \(String(format: "%.2f", processor.delayTime))")
                Slider(value: Binding(get: { Double(processor.delayTime) }, set: { processor.delayTime = AUValue($0) }), in: 0...1)
            }
            .padding(.horizontal)

            Spacer()
            Text("Diseño tipo pedal — fondo negro mate, acentos azul eléctrico y dorado.")
                .font(.footnote)
                .foregroundColor(.gray)
                .padding(.bottom, 12)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .foregroundColor(.white)
        .onAppear {
            // load last preset if exists
            if let last = PresetStore.load(),
               let idx = presets.firstIndex(where: { $0.name == last.name }) {
                selectedPresetIndex = idx
                let p = presets[idx]
                processor.pitch = AUValue(p.pitch)
                processor.reverbAmount = AUValue(p.reverb)
                processor.delayTime = AUValue(p.delay)
            }
        }
    }
}
