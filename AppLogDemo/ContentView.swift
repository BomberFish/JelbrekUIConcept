// bomberfish
// ContentView.swift – AppLogDemo
// created on 2023-12-26

import FluidGradient
import SwiftUI

let fancyAnimation: Animation = .snappy(duration: 0.35, extraBounce: 0.085) // smoooooth operaaatooor

struct ContentView: View {
    @Binding var triggerRespring: Bool // dont use this when porting this ui to your jailbreak (unless you respring in the same way)
    @State var logItems: [String] = []
    @State var progress: Double = 0.0
    @State var isRunning = false
    @State var finished = false
    @State var settingsOpen = false
    @State var color: Color = .accentColor
    @AppStorage("accent") var accentColor: String = updateCardColorInAppStorage(color: .accentColor)
    @AppStorage("swag") var swag = true
    @State var showingGradient = false
    @State var blurScreen = false
    @AppStorage("cr") var customReboot = true
    @AppStorage("verbose") var verboseBoot = false
    @AppStorage("unthreded") var untether = true
    @AppStorage("hide") var hide = false
    @AppStorage("loadd") var loadLaunch = false
    @State var reinstall = false
    @State var resetfs = false

    @ViewBuilder
    var settings: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Label("Jailbreak", systemImage: "terminal")
                        .padding(.leading, 17.5)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    VStack {
                        VStack {
                            Toggle("Custom Reboot Logo", isOn: $customReboot)
                            Toggle("Load Launch Daemons", isOn: $loadLaunch)
                            Toggle("Verbose Boot", isOn: $verboseBoot)
                            Toggle("Enable untether", isOn: $untether)
                            Toggle("Hide environment", isOn: $hide)
                        }
                        .padding(15)
                        .background(.regularMaterial)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .disabled(isRunning || finished)
                    Divider()
                        .padding(.vertical, 8)
                    Label("Appearance", systemImage: "paintpalette")
                        .padding(.leading, 17.5)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    VStack {
                        VStack {
                            HStack {
                                Text("Accent Color")
                                Spacer()
                                ColorPicker("Accent Color", selection: $color)
                                    .labelsHidden()
                                Button("", systemImage: "arrow.counterclockwise") {
                                    withAnimation(fancyAnimation) {
                                        color = .accentColor
                                    }
                                }
                                .tint(color)
                                .foregroundColor(color)
                            }
                            HStack {
                                Toggle("Swag Mode", isOn: $swag)
                            }
                        }
                        .padding(15)

                        .background(.regularMaterial)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    Label("Disable Swag Mode if the app seems sluggish.", systemImage: "info.circle")
                        .padding(.leading, 17.5)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(20)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("", systemImage: "xmark") {
                        settingsOpen = false
                        withAnimation(fancyAnimation) {
                            blurScreen = false
                        }
                    }
                    .font(.system(size: 15))
                    .tint(Color(UIColor.label))
                }
            }
        }
    }

    @ViewBuilder
    var body: some View {
        GeometryReader { geo in
            NavigationView {
                ZStack {
                    Color.black
                        .ignoresSafeArea(.all)
                    if showingGradient {
                        FluidGradient(blobs: [color, color, color, color, color, color, color, color, color], speed: 0.35, blur: 0.7) // swag alert #420blazeit
                            .ignoresSafeArea(.all)
                    }
                    Rectangle()
                        .fill(.clear)
                        .background(.black.opacity(0.8))
                        .ignoresSafeArea(.all)
                    VStack {
                        VStack(alignment: .leading) {
                            Text("Jelbrek") // apex?????
                                .multilineTextAlignment(.leading)
                                .font(.system(.largeTitle, design: .rounded).weight(.bold))
                            Text("Semi-jailbreak for iOS 15.0–17.0.0")
                        }
                        .padding(.top, 30)
                        .padding(.leading, 5)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        Spacer()
                        if !isRunning && !finished {
                            ZStack {
                                Rectangle()
                                    .fill(.clear)
                                    .blur(radius: 16)
                                    .background(Color(UIColor.secondarySystemGroupedBackground).opacity(0.5))
                                VStack {
                                    Toggle("Reinstall bootstrap", isOn: $reinstall)
                                        .onChange(of: reinstall) { _ in
                                            if reinstall {
                                                withAnimation(fancyAnimation) {
                                                    resetfs = false
                                                }
                                            }
                                        }
                                    Divider()
                                    Toggle("Restore system", isOn: $resetfs)
                                        .onChange(of: resetfs) { _ in
                                            if resetfs {
                                                withAnimation(fancyAnimation) {
                                                    reinstall = false
                                                }
                                            }
                                        }
                                    Divider()
                                    Button("More Settings", systemImage: "gear") {
                                        UIImpactFeedbackGenerator(style: .medium).impactOccurred(intensity: 200)
                                        settingsOpen.toggle()
                                        withAnimation(fancyAnimation) {
                                            blurScreen = true
                                        }
                                    }
                                    .padding(.top, 5)
                                }
                                .padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                            .frame(width: geo.size.width / 1.5, height: geo.size.height / 6.5)
                            .padding(.vertical)
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
                        .frame(height: logItems.isEmpty ? 0 : geo.size.height / 2.5, alignment: .leading)
                        //                    .background(.ultraThinMaterial)

                        .clipShape(RoundedRectangle(cornerRadius: 14))
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
                        }
                        .padding(.top, 10)

                        Button(action: {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 200)
                            if finished {
                                triggerRespring = true // change this when porting this ui to your jailbreak
                            } else {
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
                        }, label: {
                            if isRunning {
                                Label("Jelbreking", systemImage: "lock.open")
                                    .frame(width: geo.size.width / 2.5)
                            } else if finished {
                                Label("Userspace Reboot", systemImage: "arrow.clockwise")
                                    .frame(width: geo.size.width / 1.75)
                            } else {
                                Label("Jelbrek", systemImage: "lock")
                                    .frame(width: geo.size.width / 1.75)
                            }
                        })
                        .disabled(isRunning)
                        .buttonStyle(.bordered)
                        .tint(finished ? .green : color)
                        .controlSize(.large)
                        .padding(.vertical, 4)
                        if !isRunning && !finished {
                            Text("This is a fake jailbreak.\nBy BomberFish. Released under the MIT Licence.")
                                .multilineTextAlignment(.center)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                }
                .blur(radius: swag && blurScreen ? 3 : 0)
                .overlay {
                    if blurScreen {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea(.all)
                    }
                }
                .sheet(isPresented: $settingsOpen, onDismiss: {
                    withAnimation(fancyAnimation) {
                        blurScreen = false
                    }
                }, content: {
                    if #available(iOS 16.0, *) {
                        if #available(iOS 16.4, *) {
                            settings
                                .presentationDetents([.medium])
                                .presentationBackground(.regularMaterial)
                        } else {
                            settings
                                .presentationDetents([.medium])
                                .background(.regularMaterial)
                        }
                    } else {
                        settings
                            .background(.regularMaterial)
                    }
                })
            }
            .tint(color)
            .navigationViewStyle(.stack)
        }
        .onChange(of: color) { new in
            accentColor = updateCardColorInAppStorage(color: new)
        }
        .onAppear {
            showingGradient = swag
            withAnimation(fancyAnimation) {
                let rgbArray = accentColor.components(separatedBy: ",")
                if let red = Double(rgbArray[0]), let green = Double(rgbArray[1]), let blue = Double(rgbArray[2]), let alpha = Double(rgbArray[3]) { color = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha) }
            }
        }
        .onChange(of: swag) { new in
            withAnimation(fancyAnimation) {
                showingGradient = new
            }
        }
    }

    func funnyThing(_ exampleArg: Bool, progress: @escaping ((Double, String)) -> ()) {
        let steps = [
            "[*] Getting Kernel R/W",
            "[*] Bypassing PPL",
            "[*] Bypassing KTRR",
            reinstall ? "[*] Reinstalling bootstrap" : "[*] Bootstrapping",
            untether ? "[*] Installing untether\n" : "",
            "[✓] Done."
        ]
        progress((0.0, "[i] \(UIDevice.current.localizedModel), iOS \(UIDevice.current.systemVersion)"))
        for i in 0 ..< steps.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 2.0) {
                progress((Double(i) / Double(steps.count - 1), steps[i]))
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

#Preview {
    ContentView(triggerRespring: .constant(false))
}
