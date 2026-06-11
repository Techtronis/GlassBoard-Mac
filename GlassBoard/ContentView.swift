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
    @State private var battery = ""
    @State private var os = ""
    @State private var firmware = ""
    @State private var terminalOutput = ""
    
    private let defaults = UserDefaults.standard
    
    var body: some View {
        VStack(){
            ZStack {
                VStack() {
                    HStack(spacing:250) {
                        Text("Battery Level: \(battery) \nOS: \(os)")
                        Spacer()
                    }
                }
                VStack() {
                    Text("Installed APKs")
                    Button(action: {
                        drivers = defaults.string(forKey: "drivers") ?? ""
                        packages = getInstalledPackages("\(drivers)/adb shell pm list packages")
                        battery = shell("\(drivers)/adb shell dumpsys battery | grep level: | awk '{print $2}'")
                        os = shell("\(drivers)/adb shell getprop ro.build.version.glass")
                        terminalOutput = ""
                    }) {
                        Text("Refresh")
                    }
                }.padding(.trailing, 5)
            }
            
            List(packages, id: \.self, selection:$selected) { package in
                Text(package)
            }.frame(maxWidth: 500)
            HStack {
                Button(action: {
                    openFilePicker()
                    print(selectedFile)
                    terminalOutput = shell("\(drivers)/adb install \(selectedFile)")
                    packages = getInstalledPackages("\(drivers)/adb shell pm list packages")
                }) {
                    Text("Install from file")
                }
                Button(action: {
                    terminalOutput = shell("\(drivers)/adb uninstall \(selected)")
                    packages = getInstalledPackages("\(drivers)/adb shell pm list packages")
                }){
                    Text("Uninstall selected")
                }
                
                Button(action: {
                    terminalOutput = shell("\(drivers)/adb reboot")
                }) {
                    Text("Reboot")
                }
                Button(action: {
                    openFilePicker()
                    print(selectedFile)
                    drivers = selectedFile
                    defaults.set(drivers, forKey: "drivers")
                    
                }) {
                    Text("Select Drivers")
                }
                Button(action: {
                    openFilePicker()
                    firmware = selectedFile
                    terminalOutput = shell("\(drivers)/fastboot oem unlock")
                    terminalOutput = shell("\(drivers)/fastboot flash:raw boot \(firmware)/boot.img")
                    terminalOutput = shell("\(drivers)/fastboot flash system \(firmware)/system.img")
                    terminalOutput = shell("\(drivers)/fastboot flash recovery \(firmware)/recovery.img")
                    terminalOutput = shell("\(drivers)/fastboot erase cache")
                    terminalOutput = shell("\(drivers)/fastboot erase userdata")
                    
                }) {
                    Text("Install Firmware")
                }
                
            }
            Text("⚠️ Installing Firmware will RESET the device ⚠️")
            Text("Selected drivers: \(drivers)")
            Text("\(terminalOutput)")
            
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
