//
//  SelectionVerbsViewController.swift
//  enirve
//
//  Created by Aleix Martínez on 26/09/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//

import UIKit

class SelectionVerbsViewController: UIViewController {

    enum ModeChooseDescription: String {
        case Manual = "Manually choose the verbs that you want to practice"

        case Random = "The verbs are selected random, you just need to enter the number of verbs to practise"

        case All = "You will practise with all verbs of the app"
    }

    @IBOutlet var modeChooseVerbsSegmentedControl: UISegmentedControl!

    @IBOutlet var modeChooseVerbsDescription: UILabel!
    @IBOutlet var contentRandomView: UIView!

    @IBOutlet var durationTypeValueView: UIView!
    @IBOutlet var durationValueLabel: UILabel!

    @IBOutlet var contentManualView: UIView!

    @IBOutlet var verbsSelectedView: UIScrollView!

    @IBOutlet var verbsSelectedLabel: UILabel!

    var durationType: DurationType!
    var durationValue: Int!

    var verbs: [Verb] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.durationTypeValueView.layer.borderColor = secondaryColor.cgColor;
        self.durationTypeValueView.layer.borderWidth = CGFloat(integerLiteral: 2)

        self.setTextModeChooseDescription()
        self.setVisibilityContent()

//        self.verbsSelectedView.isHidden = true

        self.setUpVerbsSelectionViewPosition()

        self.verbsSelectedLabel.lineBreakMode = .byWordWrapping // notice the 'b' instead of 'B'
        self.verbsSelectedLabel.numberOfLines = 0
        self.verbsSelectedLabel.text = self.formatTextVerbsSelected(verbs: self.verbs)

        self.verbsSelectedView.layer.shadowColor = UIColor.black.cgColor
        self.verbsSelectedView.layer.shadowOpacity = 0.5
        self.verbsSelectedView.layer.shadowOffset = CGSize.zero
        self.verbsSelectedView.layer.shadowRadius = 6

        // Do any additional setup after loading the view.
    }

    private func setUpVerbsSelectionViewPosition() {
        let idConstraint = "verbsSelectedViewTopConstraint"

        var distance: CGFloat = 0

        switch self.modeChooseVerbsSegmentedControl.selectedSegmentIndex {
        case 0:
            distance = 150
            break
        case 1:
            distance = 300
            break
        case 2:
            distance = 200
            break
        default:
            print("Mode incorrecte: \(self.modeChooseVerbsSegmentedControl.selectedSegmentIndex)")
        }

        for constraint in self.view.constraints {
            if constraint.identifier == idConstraint {
                constraint.constant = distance
            }
        }
        self.verbsSelectedView.layoutIfNeeded()

    }

    fileprivate func setTextModeChooseDescription() {
        if self.modeChooseVerbsSegmentedControl.selectedSegmentIndex == 0 {
            self.modeChooseVerbsDescription.text = ModeChooseDescription.Manual.rawValue
        }

        switch self.modeChooseVerbsSegmentedControl.selectedSegmentIndex {
        case 0:
            self.modeChooseVerbsDescription.text = ModeChooseDescription.All.rawValue
            self.verbs = VerbService.getVerbs();
            break
        case 1:
            self.modeChooseVerbsDescription.text = ModeChooseDescription.Random.rawValue
            self.verbs = VerbService.getRandomVerbs(numVerbs: Int(self.durationValueLabel.text!)!)
            break
        case 2:
            self.modeChooseVerbsDescription.text = ModeChooseDescription.Manual.rawValue
        default:
            self.modeChooseVerbsDescription.text = "Error mode to choose the verbs"
        }

        self.verbsSelectedLabel.text = self.formatTextVerbsSelected(verbs: self.verbs)
    }

    fileprivate func setVisibilityContent() {
        if self.modeChooseVerbsSegmentedControl.selectedSegmentIndex == 1 {
            self.contentRandomView.isHidden = false
            self.contentManualView.isHidden = true
        } else if self.modeChooseVerbsSegmentedControl.selectedSegmentIndex == 2 {
            self.contentRandomView.isHidden = true
            self.contentManualView.isHidden = false
        } else {
            self.contentRandomView.isHidden = true
            self.contentManualView.isHidden = true
        }
    }

    @IBAction func modeChooseVerbSwitched(_ sender: UISegmentedControl) {
        self.setTextModeChooseDescription()
        self.setVisibilityContent()
        self.setUpVerbsSelectionViewPosition()
    }

    @IBAction func addDuration(_ sender: UIButton) {
        if var value: Int = Int(self.durationValueLabel.text!) {
            value += 1
            self.setDurationValue(newValue: value)
        }
    }


    @IBAction func minusDuration(_ sender: UIButton) {
        if var value: Int = Int(self.durationValueLabel.text!) {
            if value > 1 {
                value -= 1
                self.setDurationValue(newValue: value)
            }
        }
    }

    func setDurationValue(newValue: Int) {
        self.durationValueLabel.text = String(newValue)
        self.verbs = VerbService.getRandomVerbs(numVerbs: Int(self.durationValueLabel.text!)!)
        self.verbsSelectedLabel.text = self.formatTextVerbsSelected(verbs: self.verbs)
//        self.durationValue = newValue

    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

    @IBAction func unwindToSelectionVerbs(for segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToSelectionVerbs" {
            if let selectionVerbsVC = segue.source as? ModalVerbsViewController {
                self.verbs = selectionVerbsVC.verbsSelected
                self.verbsSelectedLabel.text = self.formatTextVerbsSelected(verbs: self.verbs)
                print("Verbs seleccionats\n")
                print(self.verbs)
            }
        }
        // Use data from the view controller which initiated the unwind segue
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToPractise" {
            let vc: PractiseViewController = segue.destination as! PractiseViewController
            vc.hidesBottomBarWhenPushed = true

            vc.durationType = self.durationType
            vc.durationValue = self.durationValue
            vc.verbs = self.verbs
        } else if segue.identifier == "segueToSelectionVerbsCollection" {
            let vc: ModalVerbsViewController = segue.destination as! ModalVerbsViewController
            
            vc.hidesBottomBarWhenPushed = true
            vc.verbsSelected = self.verbs
            vc.originalVerbsSelected = self.verbs
            
        }

    }


    func formatTextVerbsSelected(verbs: [Verb]) -> String {
        var text: String = ""
        let last = verbs.count - 1

        if verbs.count == 0 {
            text = "You have not selected any verb"
        }

        for i in 0..<verbs.count {
            text += "\(verbs[i].present!)"
            if i < last {
                text += ", "
            }
        }

        return text
    }


}
