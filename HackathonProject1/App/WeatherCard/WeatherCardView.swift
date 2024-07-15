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

    @Environment(LocationManager.self) private var locationManager
    @State var data: [HourlyWeatherData] = []
    @Binding var weather: Weather?

    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 25.0) {
                HStack {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(locationManager.city), \(locationManager.country)")
                            .padding(.bottom, 1)
                            .foregroundStyle(.black.secondary)
                        if let temp = weather?.current.temperature2M {
                            Text("\(String(format: "%.1f", temp)) °C")
                                .font(.largeTitle)
                        }
                        else {
                            Text("?")
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
            LinearGradient(
                gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]),
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )
        }
        .onChange(of: weather) {
            guard let weather else { return }
            self.data = getNextFive(from: weather)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }

    private func getNextFive(from data: Weather)-> [HourlyWeatherData] {
        var parsed: [HourlyWeatherData] = []
        
        let currentTimeString = Date().toString(with: "yyyy-MM-dd HH").replacingOccurrences(of: " ", with: "T").appending(":00")
        let temperatures = data.hourly.temperature2M
        let weatherCodes = data.hourly.weatherCode
        let firstIndex = data.hourly.time.firstIndex(where: {$0.starts(with: currentTimeString)}) ?? 0
        
        let relevant = Array(temperatures[firstIndex...firstIndex + 4])
        let relevantWeatherCodes = Array(weatherCodes[firstIndex...firstIndex + 4])
        
        let currentTimestamp = Date().timeIntervalSince1970
        
        for i in 0..<5 {
            let hour = "\(Date(timeIntervalSince1970: currentTimestamp + 3600.0 * i.double).toString(with: "HH"))"
            let weather: WeatherType = {
                switch Int(relevantWeatherCodes[i]) {
                case 0, 1, 2, 3, 45, 48 :
                        .sunny
                case 51, 43, 55:
                        .cloudy
                case 61, 63, 65, 66, 67, 80, 81, 82:
                        .rain
                case 71, 73, 75, 77, 85, 86:
                        .snow
                case 95, 96, 99:
                        .thunderstorm
                default:
                        .sunny
                }
            }()
            parsed.append(HourlyWeatherData(hour: hour, temp: relevant[i], weather: weather))
        }
        
        return parsed
    }
}

