//
//  ContentView.swift
//  GlassBoard
//
//  Created by Alexis Jost on 10.06.2026.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedFile = ""
    @State private var packages: [String] = []
    @State private var selected = ""
    @State private var drivers = ""
    var body: some View {
        HStack {
            VStack(){
                Text("Installed APKs")
                Button(action: {packages = getInstalledPackages("\(drivers)/adb shell pm list packages")}) {
                    Text("Refresh")
                }
                
                List(packages, id: \.self, selection:$selected) { package in
                    Text(package)
                }.frame(maxWidth: 500)
                HStack {
                    Button(action: {
                        openFilePicker()
                        print(selectedFile)
                        print(shell("\(drivers)/adb install \(selectedFile)"))
                    }) {
                        Text("Install from file")
                    }
                    Button(action: {
                        print(shell("\(drivers)/adb uninstall \(selected)"))
                        packages = getInstalledPackages("\(drivers)/adb shell pm list packages")
                    }){
                        Text("Uninstall selected")
                    }
                    
                        Button(action: {
                            print(shell("\(drivers)/adb reboot"))
                        }) {
                            Text("Reboot")
                        }
                    Button(action: {
                        openFilePicker()
                        print(selectedFile)
                        drivers = selectedFile
                        
                    }) {
                        Text("Select Drivers")
                    }
                    
                }
            }
        }
        .padding()
    }
    
    func openFilePicker() {
            let panel = NSOpenPanel()

            panel.canChooseFiles = true
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false

            if panel.runModal() == .OK {
                if let url = panel.url {
                    selectedFile = url.path
                }
            }
        }
}

#Preview {
    ContentView()
}
