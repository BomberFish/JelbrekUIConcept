// bomberfish
// AppLogDemoApp.swift – AppLogDemo
// created on 2023-12-26

import SwiftUI

@main
struct AppLogDemoApp: App {
    @State var triggerRespring = false
    var body: some Scene {
        WindowGroup {
            ContentView(triggerRespring: $triggerRespring)
                .preferredColorScheme(triggerRespring ? .dark : .none)
                .background(Color(triggerRespring ? .black : UIColor.systemBackground))
                .scaleEffect(triggerRespring ? 0.95 : 1)
                .brightness(triggerRespring ? -2 : 0)
                .statusBarHidden(triggerRespring)
                .onChange(of: triggerRespring) { _ in
                    if triggerRespring == true {
                        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in

                            // TY amy for respring bug
                            guard let window = UIApplication.shared.windows.first else { return }
                            while true {
                                window.snapshotView(afterScreenUpdates: false)
                            }
                        }
                    }
                }
        }
    }
}
