//
//  TimerTaskCell.swift
//  MultiTimerTest
//
//  Created by Zhansaya Ayazbayeva on 2021-07-15.
//

import UIKit

class TimerTaskCell: UITableViewCell {
    
    static let identifier = "TimerTaskCell"

    var timerTask: TimerTask? {
        didSet {
            nameLabel.text = timerTask?.name
            timerLabel.text = formatSec(timerTask?.secondsLeft ?? 0)
            
            timerTask?.onUpdate = { [weak self] (newSecondsLeft) in
                self?.timerLabel.text = self?.formatSec(newSecondsLeft)
            }
            timerTask?.pause = { [weak self] (pause) in
                if pause {
                    self?.overlayView.isHidden = false
                } else {
                    self?.overlayView.isHidden = true
                }
            }
        }
    }
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private var overlayView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Resume"
        label.textColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        label.font = UIFont(name: "Arial", size: 18)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.alpha = 0.5
        label.isHidden = true
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(nameLabel)
        addSubview(timerLabel)
        addSubview(overlayView)
        
        NSLayoutConstraint.activate([
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: contentView.frame.size.width * 0.75),
            
            timerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            timerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            timerLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            overlayView.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            overlayView.heightAnchor.constraint(equalTo: contentView.heightAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            contentView.backgroundColor = .clear
        }
    }
    
    private func formatSec(_ seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
