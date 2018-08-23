//
//  SelectionViewController.swift
//  Convert
//
//  Created by Ibrahim Idris on 22/08/2018.
//  Copyright © 2018 Ibrahim Idris. All rights reserved.
//

import UIKit

@objc protocol DidSelectOption {
    @objc optional func selected(quantity: Int)
    @objc optional func selected(unit: Int, whichUnit: String)
}

class SelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var data: [String]!
    var typeOfSelection: String!
    var whichUnit: String!
    var delegate: DidSelectOption!
    @IBOutlet weak var optionLabel: UILabel!
    @IBOutlet weak var visualFX: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        optionLabel.text = self.title
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    
}

extension SelectionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textColor = .white
        
        let bckView = UIView()
        let selColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1.0)
        bckView.backgroundColor = selColor
        cell.selectedBackgroundView = bckView
        
        return cell
    }
    
}

extension SelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if typeOfSelection == "quantity" {
            delegate.selected!(quantity: indexPath.row)
        } else {
            delegate.selected!(unit: indexPath.row, whichUnit: whichUnit)
        }
        self.dismiss(animated: true)
    }
    
}

