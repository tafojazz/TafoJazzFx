# TafoJazz FX - Sax Edition (CodeMagic-ready package)

Contenido:
- Swift source files: TafoJazzFXApp.swift, ContentView.swift, VoiceProcessor.swift
- Info.plist
- project.yml (XcodeGen)
- TafoLogo.jpeg (logo provided by user)

## Instrucciones para compilar en CodeMagic (sin Mac)

1. Subir este repositorio/ZIP a CodeMagic (conectar a GitHub o subir ZIP).
2. Antes de la build, ejecutar un script de pre-build para instalar XcodeGen y generar el .xcodeproj:
   - Pre-build script (bash):
     ```
     brew install xcodegen || true
     xcodegen generate
     ```
3. En CodeMagic, configura:
   - Platform: iOS
   - Xcode version: la más reciente disponible (por ejemplo Xcode 15+)
   - Signing: configura tu Apple ID / certificado (o usa tu Apple Developer Team para TestFlight)
4. Start build.
5. CodeMagic descargará las dependencias Swift Packages (AudioKit) y generará el .ipa.
6. Descarga el .ipa y usa TestFlight / AltStore / iMazing para instalar en el iPhone.

Notas:
- Si XcodeGen no está disponible en el runner, instalar con Homebrew (como en el script).
- Si prefieres, puedes abrir el proyecto en Xcode (mac) y revisar/ajustar el Asset Catalog para el logo.
- Este proyecto usa AudioKit y SoundpipeAudioKit como Swift Packages.

Si quieres, también puedo:
- Generar la versión con AppIcon y un Asset catalog completo.
- Ajustar los presets o el comportamiento de guardado automático.
