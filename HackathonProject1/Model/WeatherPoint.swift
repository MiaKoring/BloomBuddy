import Foundation

class WeatherPoint: Identifiable {
    var id: UUID = UUID()
    var weather: Weather.RawValue
    var temperature: Int
    var timestamp: Int
    
    //init() {}
    
    init(weather: Weather, temperature: Int, at timestamp: Int) {
        self.weather = weather.rawValue
        self.temperature = temperature
        self.timestamp = timestamp
    }
}
