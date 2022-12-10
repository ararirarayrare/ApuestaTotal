//
//  EventModel.swift
//  Bet3
//
//  Created by mac on 28.10.2022.
//

import UIKit

enum Team: Int, Codable {
    case home = 0
    case away = 1
    
    var string: String {
        switch self {
        case .home:
            return "Home"
        case .away:
            return "Away"
        }
    }
}

class EventModel: Codable, Hashable {
    let event: String
    
    let sport: String
    
    let league: String?
    
    let homeTeam: String
    
    let awayTeam: String
    
    let homeScore: String?
    
    let awayScore: String?
    
    let eventTime: String?
    
    let homeOdd: String?
    
    let awayOdd: String?
    
    init(event: String,
         sport: String,
         league: String?,
         homeTeam: String,
         awayTeam: String,
         homeScore: String?,
         awayScore: String?,
         eventTime: String?,
         homeOdd: String?,
         awayOdd: String?) {
        
        self.event = event
        self.sport = sport
        self.league = league
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.homeScore = homeScore
        self.awayScore = awayScore
        self.eventTime = eventTime
        self.homeOdd = homeOdd
        self.awayOdd = awayOdd
    }
    
    convenience init(scheduleJSON json: ScheduleJSON) {
        let homeOdd = Double.random(in: 1.1...1.9)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        self.init(event: json.strEvent ?? "Home vs Away",
                  sport: json.strSport ?? "Sport",
                  league: json.strLeague,
                  homeTeam: json.strHomeTeam ?? "Home",
                  awayTeam: json.strAwayTeam ?? "Away",
                  homeScore: nil,
                  awayScore: nil,
                  eventTime: json.strTime?.asTime() ?? "Today",
                  homeOdd: formatter.string(from: homeOdd as NSNumber) ?? "1.75",
                  awayOdd: formatter.string(from: Double.random(in: 2.1...2.5) / homeOdd as NSNumber) ?? "1.42")
    }
    
    static func == (lhs: EventModel, rhs: EventModel) -> Bool {
        lhs.homeTeam == rhs.homeTeam &&
        lhs.awayTeam == rhs.awayTeam &&
        lhs.eventTime == rhs.eventTime
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}

class SavedEventModel: EventModel {
    let betAmount: Double
    let betTeam: Team
    
    init(event: EventModel, betAmount: Double, team: Team) {
        self.betTeam = team
        self.betAmount = betAmount
        
        super.init(event: event.event,
                   sport: event.sport,
                   league: event.league,
                   homeTeam: event.homeTeam,
                   awayTeam: event.awayTeam,
                   homeScore: event.homeScore,
                   awayScore: event.awayScore,
                   eventTime: event.eventTime,
                   homeOdd: event.homeOdd,
                   awayOdd: event.awayOdd)
    }
    
    private enum CodingKeys: String, CodingKey {
        case betAmount = "betAmount"
        case betTeam = "betTeam"
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(betAmount, forKey: .betAmount)
        try container.encode(betTeam, forKey: .betTeam)
        
        let superEncoder = container.superEncoder()
        try super.encode(to: superEncoder)
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            betAmount = try container.decode(Double.self, forKey: .betAmount)
        } catch {
            throw error
        }
        betTeam = try container.decode(Team.self, forKey: .betTeam)
        
        let superDecoder = try container.superDecoder()
        try super.init(from: superDecoder)
    }
}
