//
//  PractiseViewController.swift
//  enirve
//
//  Created by Aleix Martínez on 27/09/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//
//  https://github.com/gregttn/GTProgressBar
//

import UIKit
import GTProgressBar
import UICircularProgressRing
import SkyFloatingLabelTextField

enum ExerciseStatus: String {
    case DEFAULT
    case SUCCESS
    case ERROR
}

class PractiseViewController: UIViewController {

    @IBOutlet var progressbarView: UIView!
    @IBOutlet var progressbarContainer: UIView!

    @IBOutlet var circularProgressbarView: UIView!
    @IBOutlet var circularProgressbarContainer: UIView!

    @IBOutlet var resultsView: UIView!
    @IBOutlet var formView: UIView!

    @IBOutlet var verbLabel: UILabel!

    @IBOutlet var checkButton: UIButton!
    @IBOutlet var showTheResultsButton: UIButton!

    @IBOutlet var statusRepetitionsLabel: UILabel!
    @IBOutlet var successLabel: UILabel!
    @IBOutlet var errorsLabel: UILabel!

    @IBOutlet var pastSimpleBaselineSuccess: UIImageView!
    @IBOutlet var pastParticipleBaselineError: UIImageView!

    @IBOutlet var pastSimpleErrorContainer: UIView!
    @IBOutlet var pastSimpleErrorLabel: UILabel!

    @IBOutlet var pastParticipleErrorContainer: UIView!
    @IBOutlet var pastParticipleErrorLabel: UILabel!

    var durationType: DurationType!
    var durationValue: Int!
    var verbs: [Verb] = []

    var progressBar: GTProgressBar!
    var progressRing: UICircularProgressRingView!

    var leftTime: Int!

    var index = 0

    var isVerbChecked: Bool = false
    var isExerciseFinished: Bool = false

    var pastSimpleTextField: SkyFloatingLabelTextField!
    var pastParticipleTextField: SkyFloatingLabelTextField!

    var success = 0
    var errors = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.showTheResultsButton.isHidden = true

        self.successLabel.text = "Success: 0"
        self.errorsLabel.text = "Errors: 0"

        self.pastSimpleBaselineSuccess.isHidden = true
        self.pastParticipleBaselineError.isHidden = true

        self.pastSimpleErrorContainer.isHidden = true
        self.pastParticipleErrorContainer.isHidden = true

        print("Tipus de duració: \(self.durationType.rawValue)")

        print("Duració: \(self.durationValue!)")

        print("Número de verbs: \(self.verbs.count)")
        print(self.verbs)

        self.setupResultsView()

        self.setupTextFields()

        if self.durationType == DurationType.Repetitions {
            self.progressbarView.isHidden = false
            self.circularProgressbarView.isHidden = true
            self.createProgressbar()
        } else if self.durationType == DurationType.Time {
            self.progressbarView.isHidden = true
            self.circularProgressbarView.isHidden = false
            self.leftTime = self.getSeconds(minutes: self.durationValue)
            self.createCircularProgressbar()
            // crear circular progressbar
        }

        self.verbLabel.text = self.verbs[self.index % self.verbs.count].present!

        self.statusRepetitionsLabel.text = "Completed \(self.index) of \(self.getTotalNumberExercises())"

//        self.updateProgressbarRepetitions ()

        self.hideKeyboardWhenTappingAround()

        // Do any additional setup after loading the view.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setupTextFields() {
        //        let lightGreyColor = UIColor(red: 197/255, green: 205/255, blue: 205/255, alpha: 1.0)
        //        let overcastBlueColor = UIColor(red: 0, green: 187/255, blue: 204/255, alpha: 1.0)

        let formWidth = self.view.frame.size.width - 90

        self.pastSimpleTextField = SkyFloatingLabelTextField(frame: CGRect(x: 30, y: 45, width: formWidth, height: 45))
        self.pastSimpleTextField.autocorrectionType = .no

        self.setLabelTextField(textField: self.pastSimpleTextField, title: "Enter the past simple", placeholder: "Past simple")
        self.setColorTextField(textField: self.pastSimpleTextField, status: ExerciseStatus.DEFAULT)

        self.pastSimpleTextField.lineHeight = 1.0 // bottom line height in points
        self.pastSimpleTextField.selectedLineHeight = 2.0

        self.pastSimpleTextField.delegate = self

        self.formView.addSubview(pastSimpleTextField)

        self.pastParticipleTextField = SkyFloatingLabelTextField(frame: CGRect(x: 30, y: 135, width: formWidth, height: 45))
        self.pastParticipleTextField.autocorrectionType = .no
        
        self.setLabelTextField(textField: self.pastParticipleTextField, title: "Enter the past participle", placeholder: "Past participle")
        self.setColorTextField(textField: self.pastParticipleTextField, status: ExerciseStatus.DEFAULT)

        self.pastParticipleTextField.lineHeight = 1.0 // bottom line height in points
        self.pastParticipleTextField.selectedLineHeight = 2.0

        self.pastParticipleTextField.delegate = self

        self.formView.addSubview(pastParticipleTextField)
    }

    func setLabelTextField(textField: SkyFloatingLabelTextField, title: String, placeholder: String) {
        textField.placeholder = title
        textField.title = placeholder
    }

    func setColorTextField(textField: SkyFloatingLabelTextField, status: ExerciseStatus) {
        if status == ExerciseStatus.DEFAULT {
            textField.tintColor = secondaryColor // the color of the blinking cursor
            textField.textColor = UIColor.black
            textField.lineColor = secondaryLightColor
            textField.selectedTitleColor = secondaryDarkColor
            textField.selectedLineColor = secondaryColor
        } else if status == ExerciseStatus.SUCCESS {
            textField.tintColor = primaryGreen // the color of the blinking cursor
            textField.textColor = primaryGreen
            textField.lineColor = primaryGreen
            textField.selectedTitleColor = primaryGreen
            textField.selectedLineColor = primaryGreen
        } else if status == ExerciseStatus.ERROR {
            textField.tintColor = primaryRed // the color of the blinking cursor
            textField.textColor = primaryRed
            textField.lineColor = primaryRed
            textField.selectedTitleColor = primaryRed
            textField.selectedLineColor = primaryRed
        }
    }

    func setupResultsView() {

        var relativeView: UIView?
        var distance: CGFloat = 0

        if self.durationType == DurationType.Time {
            relativeView = self.circularProgressbarView
            distance = 45
        } else if self.durationType == DurationType.Repetitions {
            relativeView = self.progressbarView
        }

        if let relativeView = relativeView {
            NSLayoutConstraint(item: self.resultsView, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: relativeView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: distance).isActive = true
        }

        self.resultsView.layer.shadowColor = UIColor.black.cgColor
        self.resultsView.layer.shadowOpacity = 0.5
        self.resultsView.layer.shadowOffset = CGSize.zero
        self.resultsView.layer.shadowRadius = 6


        self.formView.layer.shadowColor = UIColor.black.cgColor
        self.formView.layer.shadowOpacity = 0.5
        self.formView.layer.shadowOffset = CGSize.zero
        self.formView.layer.shadowRadius = 6
    }

    func createProgressbar() {
        self.progressBar = GTProgressBar(frame: CGRect(x: 0, y: 0, width: 300, height: 60))
        self.progressBar.progress = 0.0
        self.progressBar.barBorderColor = secondaryDarkColor
        self.progressBar.barFillColor = secondaryLightColor
        self.progressBar.barBackgroundColor = UIColor.white
        self.progressBar.barBorderWidth = 1
        self.progressBar.barFillInset = 0
        self.progressBar.labelTextColor = UIColor.black
        self.progressBar.progressLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.progressBar.font = UIFont.boldSystemFont(ofSize: 18)
        self.progressBar.labelPosition = GTProgressBarLabelPosition.bottom
        self.progressBar.displayLabel = false
        self.progressBar.barMaxHeight = 30
        self.progressBar.cornerRadius = 15.0
        self.progressBar.direction = GTProgressBarDirection.clockwise

        self.progressbarContainer.addSubview(progressBar)
    }

    func createCircularProgressbar() {
        self.progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // Change any of the properties you'd like
        //self.progressRing.value = 25.0
        self.progressRing.maxValue = CGFloat(self.getSeconds(minutes: self.durationValue))
        self.progressRing.innerRingColor = UIColor.blue
        self.progressRing.value = CGFloat(self.getSeconds(minutes: self.durationValue))
        self.progressRing.backgroundColor = UIColor.white
        self.progressRing.outerRingColor = secondaryColor
        self.progressRing.innerRingColor = UIColor.white
        self.progressRing.outerRingWidth = 10
        self.progressRing.innerRingWidth = 6
        self.progressRing.ringStyle = .ontop
        self.progressRing.startAngle = 270

        if let font = UIFont(name: "Avenir Next Medium", size: 20) {
            self.progressRing.font = font
        }

        //        self.progressRing.font = UIFont.boldSystemFont(ofSize: 40)

        self.progressRing.delegate = self

        self.circularProgressbarContainer.addSubview(progressRing)

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (timer) in

            self.progressRing.value = CGFloat(self.leftTime)

            self.leftTime -= 1

            if self.leftTime < 0 {
                timer.invalidate()
            }
        }

    }

    func getSeconds(minutes: Int) -> Int {
        return Int(TimeInterval(minutes * 60))
    }


    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    //    @IBAction func buttonClic(_ sender: UIButton) {
    //        if self.durationType == DurationType.Repetitions {
    //            self.progressBar.animateTo(progress: 0.9)
    //        } else if self.durationType == DurationType.Time {
    //
    //
    //
    //        }
    //    }

    @IBAction func checkVerb(_ sender: UIButton) {

        if self.isExerciseFinished {
//            print ("canvi de pantalla")
//            let sampleStoryBoard : UIStoryboard = UIStoryboard.(withIdentifier: "Main", bundle:nil)
//            let resultVC  = sampleStoryBoard.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
//            self.navigationController?.present(resultVC, animated: true)
        } else {

            if self.isLast() {
                self.verifyVerb()
//                self.checkButton.setTitle("Show the result", for: .normal)
                self.showTheResultsButton.isHidden = false
                self.checkButton.isHidden = true
                self.isExerciseFinished = true
            } else {
                if !self.isVerbChecked {
                    self.verifyVerb()
                    self.checkButton.setTitle("Next verb", for: .normal)
                    self.isVerbChecked = true
                } else {
                    self.nextVerb()
                    self.isVerbChecked = false
                }
            }

        }

    }

    func verifyVerb() {
        let verb = self.verbs[self.index % self.verbs.count]

        let pastSimpleValue: String = (self.pastSimpleTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))!
        let pastParticipleValue: String = (self.pastParticipleTextField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))!
        
        var pastSimpleOk = false
        var pastParticipleOk = false
        
        var aux = verb.simple.split(separator: "/")
        if aux.count > 1 {
            pastSimpleOk = aux.contains { text in
                return text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == pastSimpleValue
            }
        } else {
            pastSimpleOk = pastSimpleValue == verb.simple
        }
        
        
        aux = verb.participle.split(separator: "/")
        if aux.count > 1 {
            pastParticipleOk = aux.contains { text in
                return text.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == pastParticipleValue
            }
        } else {
            pastParticipleOk = pastParticipleValue == verb.participle
        }

        let exerciseOk = pastSimpleOk && pastParticipleOk

        if exerciseOk {
            self.success += 1
            self.successLabel.text = "Success: \(self.success)"
        } else {
            self.errors += 1
            self.errorsLabel.text = "Errors: \(self.errors)"
        }

        if pastSimpleOk {
            self.setColorTextField(textField: self.pastSimpleTextField, status: ExerciseStatus.SUCCESS)
            self.pastSimpleBaselineSuccess.isHidden = false
            self.pastSimpleErrorContainer.isHidden = true
        } else {
            self.setColorTextField(textField: self.pastSimpleTextField, status: ExerciseStatus.ERROR)
            self.pastSimpleBaselineSuccess.isHidden = true
            self.pastSimpleErrorContainer.isHidden = false
            self.pastSimpleErrorLabel.text = verb.simple
        }

        if pastParticipleOk {
            self.setColorTextField(textField: self.pastParticipleTextField, status: ExerciseStatus.SUCCESS)
            self.pastParticipleBaselineError.isHidden = false
            self.pastParticipleErrorContainer.isHidden = true
        } else {
            self.setColorTextField(textField: self.pastParticipleTextField, status: ExerciseStatus.ERROR)
            self.pastParticipleBaselineError.isHidden = true
            self.pastParticipleErrorContainer.isHidden = false
            self.pastParticipleErrorLabel.text = verb.participle
        }

        self.updateProgressbarRepetitions()
    }

    func nextVerb() {
        self.index += 1

        self.pastSimpleTextField.text = ""
        self.pastParticipleTextField.text = ""

        self.setColorTextField(textField: self.pastSimpleTextField, status: ExerciseStatus.DEFAULT)
        self.setColorTextField(textField: self.pastParticipleTextField, status: ExerciseStatus.DEFAULT)

        self.pastSimpleBaselineSuccess.isHidden = true
        self.pastParticipleBaselineError.isHidden = true

        self.pastSimpleErrorContainer.isHidden = true
        self.pastParticipleErrorContainer.isHidden = true

        print("index = \(self.index)")
        print("duration value = \(self.durationValue!)")
        print("verbs count = \(self.verbs.count)")

        print("verb actual = \(self.verbs[self.index % self.verbs.count].present!)")

        print("---------------------------")
        print("---------------------------")

        self.verbLabel.text = self.verbs[self.index % self.verbs.count].present!

        self.checkButton.setTitle("Check", for: .normal)
    }

    func updateProgressbarRepetitions() {
        if self.durationType == DurationType.Repetitions {
            self.progressBar.animateTo(progress: self.getExercisePercentageCompleted())
            self.statusRepetitionsLabel.text = "Completed \(self.index + 1) of \(self.getTotalNumberExercises())"
        }

    }

    func getExercisePercentageCompleted() -> CGFloat {
//        if self.index == 0 {
//            return 0
//        }

        let index = CGFloat.init(self.index) + 1
        let max = CGFloat.init(self.getTotalNumberExercises())

        let percentage = index / max

        print("percentage = \(percentage)")

        return percentage
    }

    func isLast() -> Bool {
        if self.durationType == DurationType.Time {
            return self.leftTime == -1
        } else {
            return self.index == ((self.durationValue * self.verbs.count) - 1)
        }
    }

    func getTotalNumberExercises() -> Int {
        if self.durationType == DurationType.Repetitions {
            return self.durationValue * self.verbs.count
        } else {
            return self.durationValue
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToResult" {
            let vc: ResultViewController = segue.destination as! ResultViewController

            vc.hidesBottomBarWhenPushed = false

            vc.durationType = self.durationType
            vc.durationValue = self.durationValue
            vc.verbs = self.verbs
            vc.success = CGFloat(self.success)
            vc.errors = CGFloat(self.errors)
        }

    }

}

extension PractiseViewController: UICircularProgressRingDelegate {

    func willDisplayLabel(for ring: UICircularProgressRingView, _ label: UILabel) {
        label.text = self.secondsToTime(time: Int(ring.value))
    }

    //    func percentageToSeconds(percentage: Int) -> Int {
    //        return percentage
    //        return percentage * Int(self.getSeconds(from: self.durationValue)) / 100
    //    }

    func secondsToTime(time: Int) -> String {

        let hours = time / 3600
        let minutes = (time - hours * 3600) / 60
        let seconds = time - hours * 3600 - minutes * 60

        var strHours = hours.description
        var strMinutes = minutes.description
        var strSeconds = seconds.description

        if (hours < 10) {
            strHours = "0" + hours.description;
        }
        if (minutes < 10) {
            strMinutes = "0" + minutes.description;
        }
        if (seconds < 10) {
            strSeconds = "0" + seconds.description;
        } else if (seconds == 0) {
            strSeconds = "0";
        }

        if (time < 60) {
            return strSeconds;
        } else if (time < 3600) {
            return strMinutes + ":" + strSeconds;
        }
    
        return strHours + ":" + strMinutes + ":" + strSeconds;
    }


}

extension PractiseViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}

extension PractiseViewController {

    func hideKeyboardWhenTappingAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PractiseViewController.dismissKeyboard))

        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

