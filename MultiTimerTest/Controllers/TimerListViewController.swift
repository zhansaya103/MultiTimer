//
//  TimerListViewController.swift
//  MultiTimerTest
//
//  Created by Zhansaya Ayazbayeva on 2021-07-15.
//

import UIKit

class TimerListViewController: UIViewController {

    private var addTimerButton: UIButton!
    private var mainDescriptionLabel: UILabel!
    private var timerName: UITextField!
    private var timerSeconds: UITextField!
    private let tableView = UITableView()
    private var descriptionContainer: UIView!
    private var warningLabel: UILabel!
    
    var activeTimers: [TimerTask] = []
    
    var timer: Timer? = nil
    var counter = 0
    
    // Генератор случайных названий, для удобства тестирования
    var generateRandomName: UIButton!
    let randomNameFirstPart = ["Игра", "Раунд", "Отпуск", "Праздник", "Турнир", "Тест", "Урок", "Фильм"]
    let randomNameSecondPart = ["начнется через", "будет через", "закончится через"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.title = "Мульти таймер"
        
        generateRandomName = UIButton(type: .roundedRect)
        generateRandomName.translatesAutoresizingMaskIntoConstraints = false
        generateRandomName.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        generateRandomName.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        view.addSubview(generateRandomName)
        
        generateRandomName.addTarget(self, action: #selector(createRandomName), for: .touchUpInside)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 55
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.register(TimerTaskCell.self, forCellReuseIdentifier: "TimerTaskCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        addTimerButton = UIButton(type: .roundedRect)
        addTimerButton.translatesAutoresizingMaskIntoConstraints = false
        addTimerButton.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        addTimerButton.tintColor = #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        addTimerButton.layer.cornerRadius = 10
        addTimerButton.clipsToBounds = true
        addTimerButton.setTitle("Добавить", for: .normal)
        addTimerButton.titleLabel?.font = UIFont(name: "Arial", size: 18)
        view.addSubview(addTimerButton)
        
        addTimerButton.addTarget(self, action: #selector(handleAddButtonTouchUpInside), for: .touchUpInside)
        
        timerName = UITextField(frame: .zero)
        timerName.placeholder = "Название таймера"
        timerName.borderStyle = .roundedRect
        timerName.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        timerName.translatesAutoresizingMaskIntoConstraints = false
        timerName.delegate = self
        view.addSubview(timerName)
        
        timerSeconds = UITextField(frame: .zero)
        timerSeconds.placeholder = "Время в секундах"
        timerSeconds.borderStyle = .roundedRect
        timerSeconds.keyboardType = .numberPad
        timerSeconds.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        timerSeconds.translatesAutoresizingMaskIntoConstraints = false
        timerSeconds.delegate = self
        view.addSubview(timerSeconds)
        
        
        descriptionContainer = UIView(frame: .zero)
        descriptionContainer.translatesAutoresizingMaskIntoConstraints = false
        descriptionContainer.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        view.addSubview(descriptionContainer)
        mainDescriptionLabel = UILabel(frame: .zero)
        mainDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        mainDescriptionLabel.attributedText = NSAttributedString(string: "Добавление таймеров")
        descriptionContainer.addSubview(mainDescriptionLabel)
        
        warningLabel = UILabel(frame: .zero)
        warningLabel.translatesAutoresizingMaskIntoConstraints = false
        warningLabel.textColor = .red
        warningLabel.textAlignment = .center
        warningLabel.font = UIFont.init(name: "Arial", size: 13)
        view.addSubview(warningLabel)
        
        constraintsInit()
    }

    func constraintsInit() {
        NSLayoutConstraint.activate([
            addTimerButton.topAnchor.constraint(equalTo: timerSeconds.bottomAnchor, constant: 30),
            
            addTimerButton.heightAnchor.constraint(equalToConstant: 50),
            addTimerButton.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            addTimerButton.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            
            timerSeconds.topAnchor.constraint(equalTo: timerName.bottomAnchor, constant: 20),
            timerSeconds.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            timerSeconds.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -20),
            
            timerName.topAnchor.constraint(equalTo: descriptionContainer.bottomAnchor, constant: 40),
            timerName.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor, constant: 20),
            
            generateRandomName.bottomAnchor.constraint(equalTo: timerSeconds.topAnchor, constant: -20),
            generateRandomName.leadingAnchor.constraint(equalTo: timerName.trailingAnchor, constant: 10),
            generateRandomName.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor, constant: -10),
            generateRandomName.heightAnchor.constraint(equalToConstant: 35),
            generateRandomName.widthAnchor.constraint(equalToConstant: 35),
            
            descriptionContainer.topAnchor.constraint(equalTo: view.readableContentGuide.topAnchor),
            descriptionContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            descriptionContainer.heightAnchor.constraint(equalToConstant: 60),
            mainDescriptionLabel.topAnchor.constraint(equalTo: descriptionContainer.topAnchor, constant: 20),
            mainDescriptionLabel.leadingAnchor.constraint(equalTo: descriptionContainer.leadingAnchor, constant: 20),
            mainDescriptionLabel.trailingAnchor.constraint(equalTo: descriptionContainer.trailingAnchor, constant: 20),
            
            tableView.topAnchor.constraint(equalTo: addTimerButton.bottomAnchor, constant: 20),
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            
            warningLabel.bottomAnchor.constraint(equalTo: timerName.topAnchor, constant: -10),
            warningLabel.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
            warningLabel.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
            warningLabel.heightAnchor.constraint(equalToConstant: 15)
        ])
    }
    
    @objc func createRandomName() {
        let firstPartIndex = Int.random(in: 0..<randomNameFirstPart.count)
        let secondPartIndex = Int.random(in: 0..<randomNameSecondPart.count)
        
        let randomName = randomNameFirstPart[firstPartIndex] + " " + randomNameSecondPart[secondPartIndex] + ": "
        self.timerName.text = randomName
    }
    
    @objc func handleAddButtonTouchUpInside() {
        print("Add new timer has been tapped")
        
        setTimer()
        
        if timerName.isFirstResponder {
            timerName.resignFirstResponder()
        }
        if timerSeconds.isFirstResponder {
            timerSeconds.resignFirstResponder()
        }
        
        guard let timerNameText = timerName.text,
              let secondsText = timerSeconds.text,
              !timerNameText.isEmpty,
              !secondsText.isEmpty
        else {
            warningLabel.text = WarningText.emptyField.rawValue
            return
        }
        
        guard let seconds = Int(secondsText),
              seconds > 0
        else {
            warningLabel.text = WarningText.incorrect.rawValue
            timerSeconds.textColor = .red
            return
        }
        
        let newTimerTask = TimerTask(name: timerNameText, secondsLeft: seconds)
        timerName.text = nil
        timerSeconds.text = nil
        
        activeTimers.append(newTimerTask)
        activeTimers.sort(by: { $0.secondsLeft > $1.secondsLeft })
        let newIndex = activeTimers.firstIndex(where: { $0.id == newTimerTask.id })!
        
        let indexPath = IndexPath(row: newIndex, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .top)
        tableView.endUpdates()
    }

    func setTimer() {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countSeconds), userInfo: nil, repeats: true)
            timer?.fire()
        }
    }
    
    @objc func countSeconds() {
        activeTimers.filter({ !$0.onPause }).forEach{ $0.countTick() }
        guard activeTimers.contains(where: { $0.isComplete == true }),
              let completedTimerIndex = activeTimers.firstIndex(where: { $0.isComplete == true })
        else {
            return
        }
        let indexPath = IndexPath(row: completedTimerIndex, section: 0)
        activeTimers.remove(at: completedTimerIndex)
        tableView.deleteRows(at: [indexPath], with: .top)
    }
}

extension TimerListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activeTimers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TimerTaskCell.identifier, for: indexPath)
        if let taskCell = cell as? TimerTaskCell {
            taskCell.timerTask = activeTimers[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTimer = activeTimers[indexPath.row]
        selectedTimer.setOnPause()
    }
}

extension TimerListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == timerName || textField == timerSeconds {
            warningLabel.text = ""
            timerSeconds.textColor = .black
            timerName.textColor = .black
        }
    }
}

enum WarningText: String {
    case emptyField = "Заполните все обязательные поля."
    case incorrect = "Поле заполнено неправильно."
}
