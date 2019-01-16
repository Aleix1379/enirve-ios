//
//  HomeViewController.swift
//  enirve
//
//  Created by Aleix Martínez on 24/09/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//

import UIKit

public enum DurationType: String {
    case Repetitions
    case Time
}

class HomeViewController: UIViewController {


    @IBOutlet var durationTypeSegmentedControl: UISegmentedControl!

    @IBOutlet var durationTypeExplanationLabel: UILabel!

    @IBOutlet var durationTypeValueLabel: UILabel!

    @IBOutlet var durationTypeValueView: UIView!

    @IBOutlet var durationValueLabel: UILabel!

    let durationTypeRepetitions = "With this option you choose how many times you want to practise each verb, for example if you want to do each verb 2 times this is your choose"

    let durationTypeTime = "With this option you choose how long is the exercise in minutes, for example if you want to practise for 5 minutes this is your choose"

    let durationTypeValueRepetitions = "Select the number of repetitions"

    let durationTypeValueTime = "Select the minutes"

    var isDurationValueChanged = false

    fileprivate func setTextDurationTypeExplanation() {
        if self.durationTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.durationTypeExplanationLabel.text = durationTypeTime
            self.durationTypeValueLabel.text = self.durationTypeValueTime
        } else {
            self.durationTypeExplanationLabel.text = durationTypeRepetitions
            self.durationTypeValueLabel.text = self.durationTypeValueRepetitions
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareStatusBar()

        self.durationTypeValueView.layer.borderColor = secondaryColor.cgColor;
        self.durationTypeValueView.layer.borderWidth = CGFloat(integerLiteral: 2)

        setTextDurationTypeExplanation()


        // Do any additional setup after loading the view.
    }

    func prepareStatusBar() {
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    @IBAction func durationTypeSwitched(_ sender: UISegmentedControl) {
        var value = ""

        if (sender.selectedSegmentIndex == 0) {
            value = "5"
        } else if sender.selectedSegmentIndex == 1 {
            value = "1"
        }

        if !self.isDurationValueChanged {
            self.durationValueLabel.text = value
        }

        setTextDurationTypeExplanation()
    }

    @IBAction func addDuration(_ sender: UIButton) {
        if var value: Int = Int(self.durationValueLabel.text!) {
            value += 1
            self.isDurationValueChanged = true
            self.setDurationValue(newValue: String(value))
        }
    }


    @IBAction func minusDuration(_ sender: UIButton) {
        if var value: Int = Int(self.durationValueLabel.text!) {
            if value > 1 {
                value -= 1
                self.isDurationValueChanged = true
                self.setDurationValue(newValue: String(value))
            }
        }
    }

    func setDurationValue(newValue: String) {
        self.durationValueLabel.text = newValue
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSelectionVerbs" {
            let vc: SelectionVerbsViewController = segue.destination as! SelectionVerbsViewController

            if self.durationTypeSegmentedControl.selectedSegmentIndex == 0 {
                vc.durationType = DurationType.Time
            } else {
                vc.durationType = DurationType.Repetitions
            }

            vc.durationValue = Int(self.durationValueLabel.text!)
        }
    }

    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {

    }

//    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
//        print ("prepareForUnwind: he tornat al home 😀")
//    }


    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}
