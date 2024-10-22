//
//  SensorConfigView.swift
//  BloomBuddy
//
//  Created by Mia Koring on 15.10.24.
//

import SwiftUI
import AccessorySetupKit
import CoreBluetooth
import SwiftChameleon

@available(iOS 18.0, *)
struct SensorConfig: View {
    let sensor: SensorIdentifier
    @State private var session = ASAccessorySession()
    @StateObject var btManager: BluetoothManager = BluetoothManager()
    @State var pickedAccessory: ASAccessory?
    @State var connectedPeripheral: CBPeripheral?
    @State var connectedAccessoryServiceUUID: CBUUID?
    @State var page: Int = 0 //TODO: Change to enum
    @State var showFailedConnectionAlert: Bool = false
    @State var state: ConfigStage = .instructions
    @State var ssidInput: String = ""
    @State var passwordInput: String = ""
    @State var showLogin: Bool = false
    @State var storeWifiLogin: Bool = true
    @State var showMeasuringErrorAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    @State var isLoading = false
    
    var body: some View {
        VStack {
            switch state {
            case .instructions:
                VStack {
                    Image("plantBg")
                        .resizable()
                    Text("Drücke den grünen Button am Gehäuse des Sensor-Controllers, danach tippe unten auf Fortfahren. Stelle sicher, dass nur ein Sensor zur Zeit Bluetooth an hat (bei aktiviertem Bluetooth leuchtet die LED im Gehäuse statisch blau).")
                        .task {
                            session.activate(on: DispatchQueue.main, eventHandler: handleSessionEvent)
                        }
                    Text("Fortfahren")
                        .bigButton {
                            Task {
                                await showASKSheet()
                            }
                        }
                        .onChange(of: btManager.failedToConnect) { showFailedConnectionAlert = true }
                        .alert("Ein Verbindungsfehler ist aufgetreten.", isPresented: $showFailedConnectionAlert) {
                            Button {
                                Task {
                                    await showASKSheet()
                                }
                            } label: {
                                Text("Erneut versuchen")
                            }
                        } message: {
                            Text("\(btManager.failedToConnect?.error?.localizedDescription ?? "Keine Fehlerinformationen verfügbar")")
                        }
                }
            case .wifi:
                VStack(alignment: .leading) {
                    Text("Gib deine WLAN-Zugangsdaten ein")
                        .font(.title2)
                    Spacer()
                    BBTextField("WLAN-Name", text: $ssidInput)
                    BBTextField("Passwort", text: $passwordInput)
                        .padding(.bottom, 10)
                    DetailView(title: Text("Wo finde ich die Zugangsdaten?")) {
                        ScrollView {
                            Text("Wenn du gerade mit dem Netzwerk verbunden bist oder schon einmal warst, gehe in den Einstellungen zu WiFi/WLAN, drücke beim gewünschten Netzwerk auf ")+Text(Image(systemName: "info.circle")).foregroundStyle(.blue)+Text(", der Name, der jetzt oben steht, muss unter \"WLAN-Name\" eingetragen werden. Das Passwort kannst du sehen und kopieren, indem du auf das zensierte Passwort klickst. \n\n Ansonsten findest du die Daten, falls sie nicht geändert wurden, auf der Rück-/Unterseite deines Routers.")
                            Text("Jetzt Einstellungen öffnen")
                                .bigButton {
                                    let url = URL(string: "App-Prefs:root=WIFI")
                                    UIApplication.shared.open(url!)
                                }
                        }
                    }
                    DetailView(title: Text("Information zur Nutzung")) {
                        VStack(alignment: .leading) {
                            Text("Der Sensor verbindet sich über dein WLAN-Netzwerk mit dem Server, um die Feuchtigkeitswerte zu senden.")
                                .font(.footnote)
                            Text("Die Zugangsdaten werden nicht an uns gesendet und bleiben auf dem Sensor.")
                                .font(.footnote)
                        }
                    }
                    Divider()
                    Toggle("Lokal speichern", isOn: $storeWifiLogin)
                        .font(.title3)
                    
                    Spacer()
                }
            case .air:
                VStack(alignment: .leading) {
                    Text("Kalibrierung an der Luft")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.plantGreen.darker(by: 0.3))
                    Spacer()
                    Image("sensorPreassembledV1marked")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    Spacer()
                    Text("Schritt 1:")
                        .font(.headline)
                    Text("Verbinde den Sensor, falls noch nicht geschehen mit dem Controller.")
                    Text("Schritt 2:")
                        .font(.headline)
                    Text("Halte den Sensor während er trocken und sauber ist einfach an die Luft und drücke wenn du soweit bist auf \"Messen und weiter\"")
                        .padding(.bottom)
                    Text("Du kannst die Kalibrierung jederzeit wiederholen.")
                    Text("Messen und weiter")
                        .bigButton {
                            Task {
                                await measure("air")
                            }
                        }
                        .padding(.bottom)
                }
            case .water:
                VStack(alignment: .leading) {
                    Text("Kalibrierung im Wasser")
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.plantGreen.darker(by: 0.3))
                    Spacer()
                    Image("sensorPreassembledV1marked")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .overlay {
                           //TODO: replace image with image with water
                        }
                    Spacer()
                    Text("Schritt 1:")
                        .font(.headline)
                    Text("Verbinde den Sensor, falls noch nicht geschehen mit dem Controller.")
                    Text("Schritt 2:")
                        .font(.headline)
                    Text("Tauche die Sensorspitze bis etwa zur im Bild gezeigten Linie ins Wasser und drücke dann auf \"Messen und abschließen\" während er sich noch im Wasser befindet.")
                        .padding(.bottom)
                    Text("Messen und abschließen")
                        .bigButton {
                            Task {
                                await measure("water")
                                if !showMeasuringErrorAlert && !showFailedConnectionAlert {
                                    dismiss()
                                }
                            }
                        }
                        .padding(.bottom)
                }
            }
            if (1...3).contains(state.rawValue) {
                HStack {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Zurück")
                    }
                    .button {
                        Task {
                            state = state.previous
                        }
                    }
                    Spacer()
                    HStack {
                        Text(state == .water ? "Beenden": "Überspringen")
                    }
                    .button {
                        Task {
                            if state.rawValue < ConfigStage.allCases.count - 1 {
                                state = state.next
                            } else {
                                dismiss()
                            }
                        }
                    }
                    Spacer()
                    HStack {
                        Text("Weiter")
                        Image(systemName: "chevron.right")
                    }
                    .button {
                        Task {
                            isLoading = true
                            await sendConnectionData()
                            state = state.next
                            isLoading = false
                        }
                    }
                    .if( state == .air || state == .water){ view in
                        view.hidden()
                    }
                
                }
            }
        }
        .disabled(isLoading)
        .overlay {
            if isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
                    .padding()
                    .background() {
                        RoundedRectangle(cornerRadius: 15)
                            .fill(.plantGreen.opacity(0.6))
                    }
            }
        }
        .sheet(isPresented: $showLogin) {
            LoginView() { dismiss in
                dismiss()
            }
            .interactiveDismissDisabled()
        }
        .alert("Beim Messen ist ein Fehler aufgetreten", isPresented: $showMeasuringErrorAlert) {
            Button("Erneut versuchen") {
                Task {
                    await measure(state.stringValue)
                    if !showMeasuringErrorAlert && !showFailedConnectionAlert {
                        state = state.next
                    }
                }
            }
        } message: {
            Text("Bitte prüfe die verbindung vom Sensor zum Controller und versuche es erneut")
        }
        .padding()
        .if(state == .water) { view in
            view
            .background(Color.blue.tertiary)
        }
    }
    
    func measure(_ toMeasure: String) async {
        isLoading = true
        guard let data = toMeasure.data(using: .utf8) else {
            print("data conversion failed")
            isLoading = false
            return
        }
        guard let connectedPeripheral, let connectedAccessoryServiceUUID else {
            print("peripheral or accessoryUUID are nil")
            isLoading = false
            return
        }
        let response = await btManager.writeValueWithResponse(to: connectedPeripheral, serviceUUID: connectedAccessoryServiceUUID, value: data)
        guard let response, let strResponse = String(data: response, encoding: .utf8) else {
            print("response is nil")
            isLoading = false
            return
        }
        print(strResponse)
        if strResponse.contains("Good") {
            isLoading = false
            if toMeasure == "air" {
                state = state.next
            }
            return
        } else if strResponse.contains("Bad") {
            isLoading = false
            showMeasuringErrorAlert = true
        }
    }
    
    func sendConnectionData() async {
        guard let connectedPeripheral, let connectedAccessoryServiceUUID else { return }
        let basic = KeyChainManager.getValue(for: .jwtAuth)
        guard let payload = basic?.split(separator: ".") else {
            showLogin = true
            return
        }
        print(payload[1])
        guard let data = Data(base64URLEncoded: payload[1]) else {
            print("Could not base64decode JWT")
            return //TODO: add error handling
        }
        print(String(data: data, encoding: .utf8))
        guard let jwt = try? JSONDecoder().decode(JWT.self, from: data) else {
            print("could not decode JWT")
            return //TODO: add error handling
        }
        guard let data = try? JSONEncoder().encode(SensorSetupData(basic: "\(sensor.id.uuidString.lowercased()):\(jwt.subject.lowercased())".data(using: .utf8)?.base64EncodedString() ?? Data().base64EncodedString(), ssid: ssidInput, password: passwordInput)) else {
            print("couldn't encode data")
            return //TODO: add error handling
        }
        let response = await btManager.writeValueWithResponse(to: connectedPeripheral, serviceUUID: connectedAccessoryServiceUUID, value: data)
        //TODO: errorhandling
    }
    
    func showASKSheet() async {
        await removeAllAccessoryConnections()
        session.showPicker(for: AccessoryData.allDisplayItems) { error in
            if let error {
                print("Error: \(error)")
                return
            }
            isLoading = true
        }
    }
    
    func handleSessionEvent(_ event: ASAccessoryEvent) {
        switch event.eventType {
        case .activated:
            print("Session is activated")
            print(session.accessories)
        case .accessoryAdded:
            print("Accessory Connected")
            guard let accessory = event.accessory else {
                print("Accessory is nil")
                return
            }
            self.pickedAccessory = accessory
        case .pickerDidDismiss:
            guard let accessory = pickedAccessory else {
                return
            }
            self.pickedAccessory = nil
            Task {
                self.connectedPeripheral = await self.handleAccessoryAdded(accessory)
                self.state = .wifi
                isLoading = false
            }
        default:
            print("Recieved event type: \(event.description)")
        }
    }
    
    func handleAccessoryAdded(_ accessory: ASAccessory) async -> CBPeripheral? {
        guard let btIdentifier = accessory.bluetoothIdentifier else {
            print("accessory has no bluetooth identifier")
            return nil
        }
        guard let wrapper = btManager.discoveredPeripherals.first(where: {$0.value.identifier == btIdentifier}) else {
            print("Not found")
            return nil
        }
        let peripheral = await btManager.connectToPeripheral(wrapper.value)
        connectedAccessoryServiceUUID = accessory.descriptor.bluetoothServiceUUID
        
        return peripheral
    }
    
    func removeAllAccessoryConnections() async {
        for accessory in session.accessories {
            do {
                try await session.removeAccessory(accessory)
            } catch {
                print("Error removing accessory: \(error)")
            }
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        Text("")
            .sheet(isPresented: .constant(true)) {
                SensorConfig(sensor: SensorIdentifier(id: UUID(), name: "lol"), state: .water)
                    .interactiveDismissDisabled()
            }
    } else {
        Text("Unavailable on iOS 17.")
    }
}
