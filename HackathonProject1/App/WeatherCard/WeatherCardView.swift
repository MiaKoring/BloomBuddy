//
//  WeatherCardView.swift
//  HackathonProject1
//
//  Created by Simon Zwicker on 14.07.24.
//

import SwiftUI
import Charts
import SwiftChameleon

struct WeatherCardView: View {
    @State var data: [HourlyWeatherData] = []
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Test")
                    .padding(.bottom, 1)
                    .foregroundStyle(.black.secondary)
                if let first = data.first {
                    Text("\(String(format: "%.1f", first.temp)) °C")
                        .font(.largeTitle)
                }
                else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
                ForecastView(data: $data)
            }
            .background(alignment: .topTrailing) {
                if let first = data.first {
                    if [WeatherType.sunny, WeatherType.cloudySunny].contains(first.weather) {
                        SunBackgroundView()
                         .offset(x: 80, y: -80)
                         .if(first.weather == .cloudySunny) { view in
                             view.overlay {
                                 Image(systemName: "cloud.fill")
                                     .resizable()
                                     .scaledToFit()
                                     .foregroundStyle(LinearGradient(colors: [.gray, .blue], startPoint: .top, endPoint: .bottom))
                                     .offset(x: 20, y: -30)
                             }
                         }
                    }
                }
                else {
                    SunBackgroundView()
                     .offset(x: 80, y: -80)
                }
            }
        }
        .padding(20)
        .background {
            if let first = data.first {
                switch first.weather {
                case .sunny:
                    LinearGradient(gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
                case .cloudySunny:
                    LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                case .cloudy:
                    LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                case .rain:
                    LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                case .snow:
                    LinearGradient(colors: [.white, .white, .gray], startPoint: .bottomLeading, endPoint: .topLeading)
                case .thunderstorm:
                    LinearGradient(gradient: Gradient(colors: [Color("Cloud1"), Color("Cloud2")]), startPoint: .bottomLeading, endPoint: .topTrailing)
                case .windy:
                    LinearGradient(colors: [.gray, .gray, .white], startPoint: .leading, endPoint: .trailing)
                }
            }
            else {
                LinearGradient(gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .task {
            do {
                let data = try await Network.request(Weather.self, environment: .weather, endpoint: WeatherAPI.forecast(48.8, 8.3333))
                print("\n\n\n\n\n\(data)\n\n\n\n\n")
                self.data = getNextFive(from: data)
            } catch {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    private func getNextFive(from data: Weather)-> [HourlyWeatherData] {
        var parsed: [HourlyWeatherData] = []
        
        let currentTimeString = Date().toString(with: "yyyy-MM-dd HH").replacingOccurrences(of: " ", with: "T").appending(":00")
        let temperatures = data.hourly.temperature_2m
        let firstIndex = data.hourly.time.firstIndex(where: {$0.starts(with: currentTimeString)}) ?? 0
        
        let relevant = Array(temperatures[firstIndex...firstIndex + 4])
        
        let currentTimestamp = Date().timeIntervalSince1970
        
        for i in 0..<5 {
            let hour = "\(Date(timeIntervalSince1970: currentTimestamp + 3600.0 * i.double).toString(with: "HH"))"
            parsed.append(HourlyWeatherData(hour: hour, temp: relevant[i], weather: .cloudySunny))
        }
        
        return parsed
    }
}

#Preview {
    WeatherCardView()
}
