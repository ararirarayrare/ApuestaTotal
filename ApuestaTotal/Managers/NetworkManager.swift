import Foundation
import Combine

enum NetworkError: Error {
    case url
    case response
    case jsonDecoding
}

class NetworkManager {
    
    let urlAssembler: URLAssembler
    
    init(urlAssembler: URLAssembler) {
        self.urlAssembler = urlAssembler
    }
    
    func requestScheduledEvents(sport: String) -> Future<[ScheduleJSON], NetworkError> {
        return Future<[ScheduleJSON], NetworkError> { [weak self] promise in
            
            guard let url = self?.urlAssembler.eventsScheduleURL(sport: sport) else {
                promise(.failure(.url))
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data, error == nil else {
                    promise(.failure(.response))
                    return
                }
                
                guard let result = try? JSONDecoder().decode(ScheduleResponse.self, from: data) else {
                    promise(.failure(.jsonDecoding))
                    return
                }
                
                promise(.success(result.events ?? []))
            }.resume()
            
        }
    }
}

struct URLAssembler {
    private let v1 = "https://www.thesportsdb.com/api/v1/json/"
    private let v2 = "https://www.thesportsdb.com/api/v2/json/"
    
    let apiKey = "50130162"
    
    func eventsScheduleURL(sport: String?) -> URL? {
        var stringURL = v1 + apiKey + "/eventsday.php?" + "d=\(String(fromDate: Date()))"
        if let sport = sport?.replacingOccurrences(of: " ", with: "%20") {
            stringURL += "&s=\(sport)"
        }
        
        return URL(string: stringURL)
    }
    
}
