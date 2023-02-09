//
//  ResultViewController.swift
//  Numeron
//
//  Created by Itikawa Tatsuya on 2021/01/30.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet var resultLable: UILabel!
    
    var str: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultLable.text = str
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
