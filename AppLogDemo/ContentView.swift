// bomberfish
// ContentView.swift – AppLogDemo
// created on 2023-12-26

import FluidGradient
import SwiftUI

let fancyAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.2) // smoooooth operaaatooor

struct ContentView: View {
    @Binding var triggerRespring: Bool
    @State var logItems: [String] = []
    @State var progress: Double = 0.0
    @State var isRunning = false
    @State var finished = false
    @State var settings = false
    @State var color: Color = .accentColor
    @AppStorage("accent") var accentColor: String = updateCardColorInAppStorage(color: .accentColor)
    @AppStorage("swag") var swag = true
    @AppStorage("cr") var customReboot = true
    @AppStorage("verbose") var verboseBoot = false
    @AppStorage("unthreded") var untether = true
    @AppStorage("hide") var hide = false
    @State var reinstall = false
    @State var resetfs = false
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color(triggerRespring ? .black : UIColor.systemBackground)
                        .ignoresSafeArea(.all)
                    if swag && !triggerRespring {
                        FluidGradient(blobs: [color, color, color, color, color, color, color, color, color], speed: 0.4, blur: 0.7) // swag alert #420blazeit
                            .ignoresSafeArea(.all)
                    }
                    Rectangle()
                        .fill(.clear)
                        .background(triggerRespring ? .black : Color(UIColor.systemBackground).opacity(0.8))
                        .ignoresSafeArea(.all)
                    VStack {
                        Spacer()
                        if !isRunning && !finished {
                            Button("Jelbrek") {
                                UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 200)
                                withAnimation(fancyAnimation) {
                                    isRunning = true
                                }
                                funnyThing(true) { prog, log in
                                    withAnimation(fancyAnimation) {
                                        progress = prog
                                        logItems.append(log)
                                    }
                                }
                            }
                            .disabled(isRunning || finished)
                            .buttonStyle(.bordered)
                            .tint(color)
                            .controlSize(.large)
                            
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .blur(radius: 16)
                                    .background(Color(UIColor.secondarySystemGroupedBackground).opacity(0.5))
                                VStack {
                                    Toggle("Reinstall strap", isOn: $reinstall)
                                        .onChange(of: reinstall) { _ in
                                            if reinstall {
                                                withAnimation(fancyAnimation) {
                                                    resetfs = false
                                                }
                                            }
                                        }
                                    Divider()
                                    Toggle("Remove jailbreak", isOn: $resetfs)
                                        .onChange(of: resetfs) { _ in
                                            if resetfs {
                                                withAnimation(fancyAnimation) {
                                                    reinstall = false
                                                }
                                            }
                                        }
                                }
                                .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .frame(width: geo.size.width / 1.5, height: geo.size.height / 4.5)
                            
                            Text("This is a fake jailbreak.\nBy BomberFish. Released under the MIT Licence.")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        ZStack {
                            Rectangle()
                                .fill(.clear)
                                .blur(radius: 16)
                                .background(Color(UIColor.secondarySystemGroupedBackground).opacity(0.5))
                            ScrollView {
                                LazyVStack(alignment: .leading) {
                                    ScrollViewReader { value in
                                        ForEach(logItems, id: \.self) { log in // caveat: no two log messages can be the same. can be solved by custom struct with a uuid, but i cba to do that rn
                                            Text(log)
                                                .id(log)
                                                .multilineTextAlignment(.leading)
                                                .frame(width: geo.size.width - 50, alignment: .leading)
                                        }
                                        .font(.system(.body, design: .monospaced))
                                        .multilineTextAlignment(.leading)
                                        .onChange(of: logItems.count) { new in
                                            value.scrollTo(logItems[new - 1])
                                        }
                                    }
                                }
                                .padding(.bottom, 15)
                                .padding()
                            }
                        }
                        .frame(height: logItems.isEmpty ? 0 : geo.size.height / 1.5, alignment: .leading)
                        //                    .background(.ultraThinMaterial)
                        
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .onChange(of: progress) { p in
                            if p == 1.0 {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                                    withAnimation(fancyAnimation) {
                                        isRunning = false
                                        finished = true
                                    }
                                }
                            }
                        }
                        Group {
                            if isRunning {
                                ProgressView(value: progress)
                                    .tint(progress == 1.0 ? .green : color)
                                Text(progress == 1.0 ? "Complete" : "\(Int(progress * 100))%")
                                    .font(.caption)
                            }
                            if finished {
                                Button("Respring") {
//                                    exit(0)
                                    withAnimation(.easeInOut(duration: 0.1)) {
                                        triggerRespring = true
                                    }
                                }
                                .buttonStyle(.bordered)
                                .tint(color)
                                .controlSize(.large)
                            }
                        }
                        .padding(.top, 10)
                        Spacer()
                    }
                    .padding()
                }
                .navigationTitle("Jelbrek")
                .sheet(isPresented: $settings) {
                    SettingsView(col: $color)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { settings = true }) {
                            Image(systemName: "gear")
                        }
                    }
                }
            }
            .tint(color)
            .navigationViewStyle(.stack)
        }
        .onChange(of: color) { new in
            accentColor = updateCardColorInAppStorage(color: new)
        }
        .onAppear {
            withAnimation(fancyAnimation) {
                let rgbArray = accentColor.components(separatedBy: ",")
                if let red = Double(rgbArray[0]), let green = Double(rgbArray[1]), let blue = Double(rgbArray[2]), let alpha = Double(rgbArray[3]) { color = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha) }
            }
        }
    }
    func funnyThing(_ exampleArg: Bool, progress: @escaping ((Double, String)) -> ()) {
        let steps = [
            "[*] Getting Kernel R/W",
            "[*] Bypassing PPL",
            "[*] Bypassing KTRR",
            reinstall ? "[*] Reinstalling bootstrap" : "[*] Bootstrapping",
            untether ? "[*] Installing untether" : "",
            "[√] Done."
        ]
        progress((0.0, "[i] \(UIDevice.current.model), iOS \(UIDevice.current.systemVersion)"))
        for i in 0..<steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 2.0) {
                progress((Double(i)/Double(steps.count - 1), steps[i]))
            }
        }
    }

}

func updateCardColorInAppStorage(color: Color) -> String {
    let uiColor = UIColor(color)
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return "\(red),\(green),\(blue),\(alpha)"
}

struct SettingsView: View {
    @AppStorage("accent") var accentColor: String = updateCardColorInAppStorage(color: .accentColor)
    @Binding var col: Color
    @AppStorage("swag") var swag = true
    
    @AppStorage("cr") var customReboot = true
    @AppStorage("verbose") var verboseBoot = false
    @AppStorage("unthreded") var untether = true
    @AppStorage("hide") var hide = false
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            List {
                Section("Jelbrek") {
                    Toggle("Custom Reboot Logo", isOn: $customReboot)
                    Toggle("Verbose Boot", isOn: $verboseBoot)
                    Toggle("Enable untether", isOn: $untether)
                    Toggle("Hide environment", isOn: $hide)
                }
                Section(content: {
                    HStack {
                        Text("Accent Color")
                        Spacer()
                        ColorPicker("Accent Color", selection: $col)
                            .labelsHidden()
                        Button("", systemImage: "arrow.counterclockwise") {
                            withAnimation(fancyAnimation) {
                                col = .accentColor
                            }
                        }
                        .tint(col)
                        .foregroundColor(col)
                    }
                    HStack {
                        Toggle("Swag Mode", isOn: $swag)
                    }
                }, header: {Text("UI")}, footer: {
                    Label("Turn off swag mode if the main menu feels sluggish.", systemImage: "info.circle")
                })
            }
            .listStyle(.automatic)
            .tint(col)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark") {
                        dismiss()
                    }
                    .font(.caption)
                    .tint(Color(UIColor.label))
//                    .background(Color(UIColor.secondarySystemBackground).padding())
                }
            }
        }
    }
}

#Preview {
    ContentView(triggerRespring: .constant(false))
}
