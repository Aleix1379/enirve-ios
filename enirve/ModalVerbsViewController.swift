//
//  ModalVerbsViewController.swift
//  enirve
//
//  Created by Aleix Martínez on 03/10/2018.
//  Copyright © 2018 Aleix Martínez. All rights reserved.
//

import UIKit

class ModalVerbsViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let reuseIdentifier = "verbCell"
    
    var verbs: [Verb] = []
    var verbsSelected: [Verb] = []
    var verbsFiltered: [Verb] = []
    
    var originalVerbsSelected: [Verb] = []
    
    @IBOutlet var verbsCollectionView: UICollectionView!
    @IBOutlet var searchBarVerbs: UISearchBar!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.verbs = VerbService.getVerbs();
        self.verbsFiltered = self.verbs
        self.setMatchSelectedVerbs()
        
//        self.hideKeyboardWhenTappingAround()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setMatchSelectedVerbs() {
        var verb: Verb!
        
        for i in 0..<verbsFiltered.count {
            verb = self.verbsFiltered[i]
            
            if let index = self.verbsSelected.index(where: { (item: Verb) -> Bool in return item.id == verb.id }) {
                print (index)
                verb.matched = true
            } else {
                verb.matched = false
            }
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        print ("self.verbsFiltered.count: \(self.verbsFiltered.count)")
        
        return self.verbsFiltered.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "verbCell", for: indexPath) as! VerbCollectionViewCell
        
        cell.verbLabel.text = self.verbsFiltered[indexPath.row].present
        
        if self.verbsFiltered[indexPath.row].matched {
            cell.verbLabel.backgroundColor = primaryColor
            cell.verbLabel.textColor = UIColor.white
        } else {
            cell.verbLabel.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            cell.verbLabel.textColor = UIColor.black
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let verb = self.verbsFiltered[indexPath.row]
        
        verb.matched = !verb.matched
        collectionView.reloadItems(at: [indexPath])
        
        if let index = self.verbsSelected.index(where: { (item: Verb) -> Bool in return item.id == verb.id }) {
            self.verbsSelected.remove(at: index)
        } else {
            self.verbsSelected.append(verb)
        }
    }
    
    @IBAction func saveVerbs(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "unwindToSelectionVerbs", sender: sender);
    }
    
    @IBAction func cancelVerbs(_ sender: UIBarButtonItem) {
        self.verbsSelected = self.originalVerbsSelected;
        performSegue(withIdentifier: "unwindToSelectionVerbs", sender: sender);
    }

    @IBAction func selectAllVerbs(_ sender: UIButton) {
        self.changeAllVerbs(select: true) 
    }
    
    @IBAction func deselectAllVerbs(_ sender: UIButton) {
        self.changeAllVerbs(select: false)
    }
    
    func changeAllVerbs(select: Bool) {
        var verb: Verb!
        self.verbsSelected = []
        
        for i in 0..<self.verbsFiltered.count {
            verb = self.verbsFiltered[i]
            verb.matched = select
            if select {
                self.verbsSelected.append(verb)
            }
        }
        self.verbsCollectionView.reloadData()
    }
    
}

extension ModalVerbsViewController: UISearchBarDelegate {
    
    //MARK: - SEARCH
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if(!(searchBar.text?.isEmpty)!){
            //reload your data source if necessary
            self.verbsFiltered = self.filterVerbs(searchText: searchBar.text!)
        } else {
            self.verbsFiltered = self.verbs
        }
        self.view.endEditing(true)
        self.verbsCollectionView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText.isEmpty){
            //reload your data source if necessary
            self.verbsFiltered = self.verbs
            self.verbsCollectionView?.reloadData()
        }
    }
    
    func filterVerbs(searchText: String) -> [Verb] {
        return self.verbs.filter({ (verb) -> Bool in
            return verb.present.lowercased().contains(searchText.lowercased())
        })
    }
    
    
    
}

extension ModalVerbsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//extension ModalVerbsViewController {
//
//    func hideKeyboardWhenTappingAround() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PractiseViewController.dismissKeyboard))
//
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//
//    }
//
//}
