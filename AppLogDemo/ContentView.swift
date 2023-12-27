// bomberfish
// ContentView.swift – AppLogDemo
// created on 2023-12-26

import SwiftUI

struct ContentView: View {
    @State var logItems: [String] = []
    @State var progress: Double = 0.0
    @State var isRunning = false
    @State var finished = false
    let fancyAnimation: Animation = .snappy(duration: 0.3, extraBounce: 0.2) // smoooooth operaaatooor
    var body: some View {
        // you can add a cool fluid gradient effect behind the view for extra swag points
        NavigationView {
            VStack {
                Button("Do the thing") {
                    
                    withAnimation(fancyAnimation) {
                        isRunning = true
                    }
                    funnyThing(true) {prog, log in
                        withAnimation(fancyAnimation) {
                            progress = prog
                            logItems.append(log)
                        }
                    }
                }
                .disabled(isRunning || finished)
                .buttonStyle(.bordered)
                .tint(.accentColor)
                .controlSize(.large)
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
                            .onChange(of: logItems.count) {new in
                                value.scrollTo(logItems[new - 1])
                            }
                        }
                    }
                    .padding(.bottom, 15)
                    .padding()
                }
                .frame(height: logItems.isEmpty ? 0 : 400, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .onChange(of: progress) {p in
                    if p == 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
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
                            .tint(progress == 1.0 ? .green : .accentColor)
                        Text(progress == 1.0 ? "Complete" : "\(Int(progress * 100))%")
                            .font(.caption)
                    }
                    if finished {
                        Button("Exit app") {
                            exit(0)
                        }
                        .buttonStyle(.bordered)
                        .tint(.accentColor)
                        .controlSize(.large)
                    }
                }
                .padding(.top, 10)
            }
            .padding()
            .navigationTitle("App Name")
        }
        .navigationViewStyle(.stack)
    }
}


func funnyThing(_ exampleArg: Bool, progress: @escaping ((Double,String)) -> ()) {
    for i in 0...100 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2 * Double(i)) {
            if i % 5 == 1 && i % 3 == 1 {
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
