import Foundation

struct ScheduleResponse : Codable {
    let events : [ScheduleJSON]?

    enum CodingKeys: String, CodingKey {
        case events = "events"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        events = try values.decodeIfPresent([ScheduleJSON].self, forKey: .events)
    }
}

struct ScheduleJSON : Codable {

    let strEvent : String?
    let strSport : String?
    let idLeague : String?
    let strLeague : String?
    let strSeason : String?
    let strHomeTeam : String?
    let strAwayTeam : String?
    let strTimestamp : String?
    let dateEvent : String?
    let strTime : String?
    let strStatus : String?
    let strThumb: String?

    enum CodingKeys: String, CodingKey {
        case strEvent = "strEvent"
        case strSport = "strSport"
        case idLeague = "idLeague"
        case strLeague = "strLeague"
        case strSeason = "strSeason"
        case strHomeTeam = "strHomeTeam"
        case strAwayTeam = "strAwayTeam"
        case strTimestamp = "strTimestamp"
        case dateEvent = "dateEvent"
        case strTime = "strTime"
        case strStatus = "strStatus"
        case strThumb = "strThumb"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        strEvent = try values.decodeIfPresent(String.self, forKey: .strEvent)
        strSport = try values.decodeIfPresent(String.self, forKey: .strSport)
        idLeague = try values.decodeIfPresent(String.self, forKey: .idLeague)
        strLeague = try values.decodeIfPresent(String.self, forKey: .strLeague)
        strSeason = try values.decodeIfPresent(String.self, forKey: .strSeason)
        strHomeTeam = try values.decodeIfPresent(String.self, forKey: .strHomeTeam)
        strAwayTeam = try values.decodeIfPresent(String.self, forKey: .strAwayTeam)
        strTimestamp = try values.decodeIfPresent(String.self, forKey: .strTimestamp)
        dateEvent = try values.decodeIfPresent(String.self, forKey: .dateEvent)
        strTime = try values.decodeIfPresent(String.self, forKey: .strTime)
        strStatus = try values.decodeIfPresent(String.self, forKey: .strStatus)
        strThumb = try values.decodeIfPresent(String.self, forKey: .strThumb)
    }

}

//extension EventModel {
//    convenience init(scheduleJSON json: ScheduleJSON) {
//        let homeOdd = Double.random(in: 1.1...1.9)
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .decimal
//        formatter.maximumFractionDigits = 2
//        
//        self.init(event: json.strEvent ?? "Home vs Away",
//                  sport: json.strSport ?? "Sport",
//                  league: json.strLeague,
//                  homeTeam: json.strHomeTeam ?? "Home",
//                  awayTeam: json.strAwayTeam ?? "Away",
//                  homeScore: nil,
//                  awayScore: nil,
//                  eventTime: json.strTime?.asTime() ?? "Today",
//                  homeOdd: formatter.string(from: homeOdd as NSNumber) ?? "1.75",
//                  awayOdd: formatter.string(from: Double.random(in: 2.1...2.5) / homeOdd as NSNumber) ?? "1.42")
//    }
//}
