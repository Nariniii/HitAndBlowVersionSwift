//
//  InputViewController.swift
//  Numeron
//
//  Created by Itikawa Tatsuya on 2021/01/28.
//

import UIKit

class InputViewController: UIViewController {
    
    var inputIndex = 0
    
    @IBOutlet var leftNumLabel: UILabel!
    @IBOutlet var centerNumLabel: UILabel!
    @IBOutlet var rightNumLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        inputIndex = 0
        labelInit()
    }
    
    func labelInit() {
        leftNumLabel.text = "-"
        centerNumLabel.text = "-"
        rightNumLabel.text = "-"
        
    }
    
    @IBAction func numTapped(sender: UIButton) {
        switch inputIndex {
        case 0:
            leftNumLabel.text = "\(sender.tag)"
        case 1:
            centerNumLabel.text = "\(sender.tag)"
        case 2:
            rightNumLabel.text = "\(sender.tag)"
        default:
            print("numTappedFULL!: \(inputIndex)")
        }
        
        if inputIndex < 3 {
            inputIndex += 1
        }
    }
    
    @IBAction func backTapped(sender: UIButton) {
        switch inputIndex {
        case 1:
            leftNumLabel.text = "-"
        case 2:
            centerNumLabel.text = "-"
        case 3:
            rightNumLabel.text = "-"
        default:
            print("backTappedError!: \(inputIndex)")
        }
        if inputIndex > 0 {
            inputIndex -= 1
        }
    }
    
    @IBAction func decideTapped(sender: UIButton) {
        if inputIndex == 3 {
            performSegue(withIdentifier: "GameMode", sender: nil)
        } else {
            print("NeedPutNumber!: \(inputIndex)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GameMode" {
            let next = segue.destination as? GameViewController
            next?.leftOutputLabel = self.leftNumLabel.text
            next?.centerOutputLabel = self.centerNumLabel.text
            next?.rightOutputLabel = self.rightNumLabel.text
        }
    }
    
    @IBAction func backToInputView(sender: UIStoryboardSegue) {
        
    }

}
