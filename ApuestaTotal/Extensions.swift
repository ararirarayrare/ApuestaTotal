//
//  Extensions.swift
//  Bet3
//
//  Created by mac on 02.11.2022.
//

import UIKit

extension Date {
    init(_ dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let date = dateStringFormatter.date(from: dateString)!
        self.init(timeInterval:0, since:date)
    }
}

extension UIView {
    
    func fillSuperView() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
        ])
    }
    
    func ancherToSuperviewsCenter() {
        guard let superview = self.superview else { return }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
        ])
    }
}


extension String {
    init(fromDate date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let string = dateFormatter.string(from: date)
        
        self = string
    }
    
    func asTime() -> Self? {
        return String(describing: dropLast( (count - 5) > 0 ? (count - 5) : 0 ))
    }
}

extension UIColor {
    static let clay = UIColor(red: 34/255, green: 31/255, blue: 32/255, alpha: 1.0)
    static let customDarkYellow = UIColor(red: 202/255, green: 160/255, blue: 69/255, alpha: 1.0)
//    static let customYellow = UIColor(red: 224/255, green: 178/255, blue: 84/255, alpha: 1.0)
    
    static let customGreen = UIColor(red: 0, green: 113/255, blue: 0, alpha: 1.0)
    static let lightRed = UIColor(red: 249/255, green: 107/255, blue: 112/255, alpha: 1.0)
    
}

extension UIImage {
    static var chevronRight: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        return UIImage(systemName: "chevron.right", withConfiguration: imageConfig)
    }
    
    static var share: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        return UIImage(systemName: "arrowshape.turn.up.right.fill", withConfiguration: imageConfig)
    }
    
    static var trash: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        return UIImage(systemName: "trash.fill", withConfiguration: imageConfig)
    }
    
    static var back: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        return UIImage(systemName: "chevron.left",
                               withConfiguration: imageConfig)
    }
    
    static var close: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 22)
        return UIImage(systemName: "xmark",
                       withConfiguration: imageConfig)
    }

    static var person: UIImage? {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 24)
        return UIImage(systemName: "person.crop.circle",
                       withConfiguration: imageConfig)
    }
    
}
