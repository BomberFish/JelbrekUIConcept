// bomberfish
// ContentView.swift – AppLogDemo
// created on 2023-12-26

import FluidGradient
import SwiftUI

struct ContentView: View {
    var pipe = Pipe()
    @State var logItems: [String] = []
    public func openConsolePipe () {
        setvbuf(stdout, nil, _IONBF, 0)
        dup2(pipe.fileHandleForWriting.fileDescriptor,
             STDOUT_FILENO)
        // listening on the readabilityHandler
        pipe.fileHandleForReading.readabilityHandler = { handle in
            let data = handle.availableData
            let str = String(data: data, encoding: .ascii) ?? "<Non-ascii data of size\(data.count)>\n"
            DispatchQueue.main.async {
                withAnimation(fancyAnimation) {
                    logItems.append(str)
                }
            }
        }
    }
    @State var progress: Double = 0.0
    @State var isRunning = false
    @State var finished = false
    @State var settings = false
    @State var color: Color = .accentColor
    @AppStorage("accent") var accentColor: String = updateCardColorInAppStorage(color: .accentColor)
    @AppStorage("swag") var swag = true
    @AppStorage("showStdout") var showStdout = true
    let fancyAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.2) // smoooooth operaaatooor
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.systemBackground)
                    .ignoresSafeArea(.all)
                if swag {
                    FluidGradient(blobs: [color, color, color, color, color, color, color, color, color], speed: 0.4, blur: 0.7) // swag alert #420blazeit
                        .ignoresSafeArea(.all)
                }
                Rectangle()
                    .fill(.clear)
                    .background(Color(UIColor.systemBackground).opacity(0.8))
                    .ignoresSafeArea(.all)
                VStack {
                    if !isRunning && !finished {
                        Button("Do the thing") {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred(intensity: 200)
                            withAnimation(fancyAnimation) {
                                isRunning = true
                            }
                            if showStdout {
                                withAnimation(fancyAnimation) {
                                    print("Hello from stdout!")
                                }
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
                    }
                    ZStack {
                        Rectangle()
                            .fill(.clear)
                            .blur(radius: 16)
                            .background(Color(UIColor.secondarySystemGroupedBackground).opacity(0.3))
                        ScrollView {
                            LazyVStack(alignment: .leading) {
                                ScrollViewReader { value in
                                    ForEach(logItems, id: \.self) { log in // caveat: no two log messages can be the same. can be solved by custom struct with a uuid, but i cba to do that rn
                                        Text(log)
                                            .id(log)
                                            .multilineTextAlignment(.leading)
                                            .frame(width: 350, alignment: .leading)
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
                    .frame(height: logItems.isEmpty ? 0 : 400, alignment: .leading)
//                    .background(.ultraThinMaterial)

                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .onChange(of: progress) { p in
                        if p == 1.0 {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                withAnimation(fancyAnimation) {
                                    isRunning = false
                                    finished = true
                                }
                            }
                        }
                    }
                    
                    .onAppear {
                        if showStdout {
                            openConsolePipe()
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
                            Button("Exit app") {
                                exit(0)
                            }
                            .buttonStyle(.bordered)
                            .tint(color)
                            .controlSize(.large)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationTitle("AppLogDemo")
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
        .onChange(of: color) { new in
            accentColor = updateCardColorInAppStorage(color: new)
        }
        .onAppear {
            let rgbArray = accentColor.components(separatedBy: ",")
            if let red = Double(rgbArray[0]), let green = Double(rgbArray[1]), let blue = Double(rgbArray[2]), let alpha = Double(rgbArray[3]) { color = Color(.sRGB, red: red, green: green, blue: blue, opacity: alpha) }
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
    @AppStorage("showStdout") var showStdout = true
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Accent Color")
                    Spacer()
                    ColorPicker("Accent Color", selection: $col)
                        .labelsHidden()
                    Button("", systemImage: "arrow.counterclockwise") {
                        col = .accentColor
                    }
                }
                HStack {
                    Text("Swag Mode")
                    Spacer()
                    Toggle("Swag Mode", isOn: $swag)
                        .tint(col)
                        .labelsHidden()
                }
                HStack {
                    Text("Show stdout")
                    Spacer()
                    Toggle("Show stdout", isOn: $showStdout)
                        .tint(col)
                        .labelsHidden()
                }
            }
            .tint(col)
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

func funnyThing(_ exampleArg: Bool, progress: @escaping ((Double, String)) -> ()) {
    for i in 0 ... 100 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(i)) {
            if i % 5 == 1, i % 3 == 1 {
                progress((Double(i)/100.0, "[\(i)] rizzbuzz"))
            } else if i % 5 == 0 {
                progress((Double(i)/100.0, "[\(i)] rizz"))
            } else if i % 3 == 0 {
                progress((Double(i)/100.0, "[\(i)] buzz"))
            } else {
                progress((Double(i)/100.0, "[*] \(i)"))
            }
        }
    }
}

#Preview {
    ContentView()
}
