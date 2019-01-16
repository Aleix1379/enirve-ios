//
//  ResultViewController.swift
//  enirve
//
//  Created by Aleix Martínez on 29/09/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//
/*
 https://stackoverflow.com/questions/30052587/how-can-i-go-back-to-the-initial-view-controller-in-swift
 */

import UIKit
import UICircularProgressRing

class ResultViewController: UIViewController {

    @IBOutlet var circularProgressbarContainer: UIView!
    @IBOutlet var resultsView: UIView!
    @IBOutlet var shareResultsView: UIView!
    
    @IBOutlet var successLabel: UILabel!
    @IBOutlet var errorsLabel: UILabel!

    var durationType: DurationType!
    var durationValue: Int!
    var verbs: [Verb] = []

    var success: CGFloat = 0
    var errors: CGFloat = 0

    var progressRing: UICircularProgressRingView!
    var percentageOfSuccess: Float = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setResults()
        self.setupContainerView(view: self.resultsView)
        self.setupContainerView(view: self.shareResultsView)

        self.createCircularProgressbar()


        // Do any additional setup after loading the view.
    }

    func createCircularProgressbar() {
        self.progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        // Change any of the properties you'd like
        //self.progressRing.value = 25.0
//        self.progressRing.maxValue = 100
        self.progressRing.innerRingColor = UIColor.blue
//        self.progressRing.value = 0
        self.progressRing.backgroundColor = UIColor.white
        self.progressRing.outerRingColor = secondaryLightColor
        self.progressRing.innerRingColor = secondaryColor
        self.progressRing.outerRingWidth = 10
        self.progressRing.innerRingWidth = 6
        self.progressRing.ringStyle = .ontop
        self.progressRing.startAngle = 270

        if let font = UIFont(name: "Avenir Next Medium", size: 20) {
            self.progressRing.font = font
        }

        //        self.progressRing.font = UIFont.boldSystemFont(ofSize: 40)

//        self.progressRing.delegate = self

        self.circularProgressbarContainer.addSubview(progressRing)

        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            let percentage = (self.success * 100) / (self.success + self.errors)
            self.progressRing.setProgress(to: percentage, duration: 1)
        }

    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setResults() {
        self.successLabel.text = "Success: \(Int(self.success).description)"
        self.errorsLabel.text = "Errors: \(Int(self.errors).description)"
    }

    func setupContainerView(view: UIView) {
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 6
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "segueToHome" {
            let vc: HomeViewController = segue.destination as! HomeViewController
            vc.hidesBottomBarWhenPushed = false
        } else if segue.identifier == "segueResultToPractise" {
            let vc: PractiseViewController = segue.destination as! PractiseViewController
            vc.durationType = self.durationType
            vc.durationValue = self.durationValue
            vc.verbs = self.verbs

            self.navigationController?.popToViewController(vc, animated: true)
        }

    }

    @IBAction func goToHome(_ sender: UIButton) {
        self.performSegue(withIdentifier: "unwindToHomeViewController", sender: self)
    }

    @IBAction func shareOnFacebook(_ sender: UIButton) {
        let tweetText = "I have practiced the irregular verbs in English with Enirve 🤓, download on the App Store"
        let appStoreUrl = "https://itunes.apple.com/gb/app/enirve/id1375091827?mt=8"
        let googlePlayUrl = "https://play.google.com/store/apps/details?id=com.aleixmp.eiv"
        
        let shareString = "https://fb/intent/tweet?text=\(tweetText) \(appStoreUrl) and Google Play \(googlePlayUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    @IBAction func shareOnTwitter(_ sender: UIButton) {
        let tweetText = "I have practiced the irregular verbs in English with Enirve 🤓, download on the App Store"
        let appStoreUrl = "https://itunes.apple.com/gb/app/enirve/id1375091827?mt=8"
        let googlePlayUrl = "https://play.google.com/store/apps/details?id=com.aleixmp.eiv"
        
        let shareString = "https://twitter.com/intent/tweet?text=\(tweetText) \(appStoreUrl) and Google Play \(googlePlayUrl)"
        
        // encode a space to %20 for example
        let escapedShareString = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        // cast to an url
        let url = URL(string: escapedShareString)
        
        // open in safari
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
//    func getMessatgeSocialNetworks() -> String {
//        return ", of \(self.success + self.errors) verbs I have made \(self.errors) correct "
//    }
    
    
    /*
    @IBAction func goToPractise(_ sender: UIButton) {
//        self.performSegue(withIdentifier: "segueToRepeatExercise", sender: self)
        let vc: PractiseViewController = segue.destination as! PractiseViewController
        vc.durationType = self.durationType
        vc.durationValue = self.durationValue
        vc.verbs = self.verbs

        self.navigationController?.popToViewController(vc, animated: true)
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
