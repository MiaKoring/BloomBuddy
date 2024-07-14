import SwiftUI
import Charts
import SwiftChameleon
import Foundation

struct LocalWeatherCard: View {
   let data: [WeatherPoint] = [WeatherPoint(weather: .sunny, temperature: 25, at:
                        1720958400),
        WeatherPoint(weather: .cloudySunny, temperature: 12, at: 1720962000),
        WeatherPoint(weather: .rain, temperature: 11, at: 1720965600),
        WeatherPoint(weather: .sunny, temperature: 5, at: 1720969200),
        WeatherPoint(weather: .cloudy, temperature: 5, at: 1720972800)]
    let location: String = "Husum"
    //let data: [WeatherPoint] = []
    var body: some View {
        VStack {
            if data.count >= 5 {
                VStack(alignment: .leading) {
                    Text(location)
                        .padding(.bottom, 1)
                        .foregroundStyle(.black.secondary)
                    Text("\(data[0].temperature > 0 ? "+" : "")\(data[0].temperature)°")
                        .font(.largeTitle)
                    CardForecast(data: data)
                }
                .background(alignment: .topTrailing) {
                    SunDecoration()
                        .offset(x: 80, y: -80)
                }
            }
            else {
                ContentUnavailableView("Data unavailable", systemImage: "exclamationmark.triangle")
            }
        }
        .padding(20)
        .background {
            LinearGradient(gradient: Gradient(colors: [Color("Sun"), Color.white, Color.white]), startPoint: .bottomLeading, endPoint: .topTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
}

struct CardForecast: View {
    let data: [WeatherPoint]
    var body: some View {
        HStack {
            ForEach(0..<5) { index in
                VStack {
                    Image(systemName: data[index].weather)
                        .font(.title2)
                    Text("\(data[index].temperature > 0 ? "+" : "")\(data[index].temperature)°")
                    Text(Date(timeIntervalSince1970: data[index].timestamp.double).toString(with: "HH:mm"))
                        .font(.caption2)
                        .foregroundStyle(.black.tertiary)
                }
                .frame(width: 38)
                if index < 4 {
                    RoundedRectangle(cornerRadius: 5)
                        .frame(height: 3)
                        .rotationEffect(.degrees(data[index].temperature - data[index + 1].temperature > 0 ? 5 : data[index].temperature - data[index + 1].temperature < 0 ? -5 : 0))
                }
            }
        }
    }
}

struct SunDecoration: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(RadialGradient(colors: [Color("Sun").opacity(0.6), .white], center: .center, startRadius: 85, endRadius: 60))
                .frame(width: 170)
            Circle()
                .fill(RadialGradient(colors: [Color("Sun").opacity(0.8), .white], center: .center, startRadius: 60, endRadius: 40))
                .frame(width: 120)
            Circle()
                .fill(.yellow.secondary)
                .frame(width: 70)
        }
    }
}

#Preview {
    SunDecoration()
}

#Preview {
    VStack {
        Spacer()
        LocalWeatherCard()
            .padding(.horizontal, 20)
        Spacer()
    }
    
}
