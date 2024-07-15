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
    @Binding var weather: Weather?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 25.0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
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
                    }

                    Spacer()
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
                } else {
                    SunBackgroundView()
                        .offset(x: 80, y: -80)
                }
            }
        }
        .padding()
        .background {
            if let first = data.first {
                first.weather.gradient
            }
        }
        .onChange(of: weather) {
            guard let weather else { return }
            self.data = getNextFive(from: weather)
        }
    }

    private func getNextFive(from data: Weather)-> [HourlyWeatherData] {
        var parsed: [HourlyWeatherData] = []
        
        let currentTimeString = Date().toString(with: "yyyy-MM-dd HH").replacingOccurrences(of: " ", with: "T").appending(":00")
        let temperatures = data.hourly.temperature2M
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
