//
//  GameViewController.swift
//  Numeron
//
//  Created by Itikawa Tatsuya on 2021/01/29.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet var leftNumLabel: UILabel!
    @IBOutlet var centerNumLabel: UILabel!
    @IBOutlet var rightNumLabel: UILabel!
    
    @IBOutlet var myScoreLabels : [UILabel]!
    @IBOutlet var myHitLabels : [UILabel]!
    @IBOutlet var myBlowLabels : [UILabel]!
    @IBOutlet var rivalScoreLabels: [UILabel]!
    @IBOutlet var rivalHitLabels: [UILabel]!
    @IBOutlet var rivalBlowLabels: [UILabel]!
    
    @IBOutlet var numButtons: [UIButton]!
    @IBOutlet var numLabels: [UILabel]!
    
    @IBOutlet var inputModeButton: UIButton!
    
    var leftOutputLabel: String?
    var centerOutputLabel: String?
    var rightOutputLabel: String?
    
    var rivalNumber: [Int] = []
    
    var myIndex = 0
    var rivalIndex = 0
    
    var inputNumIndex = 0
    var isMyTurn = true
    
    var my = 0
    var rival = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        Initialize()
        
    }
    
    func Initialize() {
        InitLabelsText(Labels: myScoreLabels, str: "・・・")
        InitLabelsText(Labels: myHitLabels, str: "")
        InitLabelsText(Labels: myBlowLabels, str: "")
        InitLabelsText(Labels: rivalScoreLabels, str: "・・・")
        InitLabelsText(Labels: rivalHitLabels, str: "")
        InitLabelsText(Labels: rivalBlowLabels, str: "")
        
        setMyNumber()
        setRivalNumber()
        notActiveInputMode(flag: true)
        inputNumIndex = 0
        isMyTurn = true
    }
    
    func InitLabelsText(Labels: [UILabel], str: String) {
        for label in Labels {
            label.text = str
        }
    }
    

    func setMyNumber() {
        myIndex = 0
        leftNumLabel.text = leftOutputLabel
        centerNumLabel.text = centerOutputLabel
        rightNumLabel.text = rightOutputLabel
        print("setMyNumber! \(String(describing: leftNumLabel.text))\(String(describing: centerNumLabel.text))\(String(describing: rightNumLabel.text))")
    }
    
    func setRivalNumber() {
        rivalIndex = 0
        let r = Int(arc4random_uniform(10))
        rivalNumber.append(r)
        var r1 = Int(arc4random_uniform(10))
        while r == r1 {
            r1 = Int(arc4random_uniform(10))
        }
        rivalNumber.append(r1)
        var r2 = Int(arc4random_uniform(10))
        while r == r2 || r1 == r2 {
            r2 = Int(arc4random_uniform(10))
        }
        rivalNumber.append(r2)
        print("rivalNum: \(rivalNumber[0])\(rivalNumber[1])\(rivalNumber[2])")
    }
    
    func notActiveInputMode(flag: Bool) {
        for button in numButtons {
            button.isHidden = flag
        }
        for label in numLabels {
            label.isHidden = flag
        }
        print("notActiveMode: \(flag)")
    }
    
    @IBAction func inputNumTapped(sender: UIButton) {
        sender.isEnabled = false
        notActiveInputMode(flag: false)
    }
    
    @IBAction func numTapped(sender: UIButton) {
        switch inputNumIndex {
        case 0:
            numLabels[0].text = "\(sender.tag)"
        case 1:
            numLabels[1].text = "\(sender.tag)"
        case 2:
            numLabels[2].text = "\(sender.tag)"
        default:
            print("numTappedFULL!: \(inputNumIndex)")
        }
        
        if inputNumIndex < 3 {
            inputNumIndex += 1
        }
    }
    
    @IBAction func backTapped(sender: UIButton) {
        switch inputNumIndex {
        case 1:
            numLabels[0].text = "-"
        case 2:
            numLabels[1].text = "-"
        case 3:
            numLabels[2].text = "-"
        default:
            print("backTappedError!: \(inputNumIndex)")
        }
        if inputNumIndex > 0 {
            inputNumIndex -= 1
        }
    }
    
    @IBAction func decideTapped(sender: UIButton) {
        if inputNumIndex == 3 && myIndex < 10 {
            // 自分の結果更新
            let strs = convertLabelToStrings(Labels: numLabels)
            let hitBlow = checkHitBlow(numStr: strs, rival: rivalNumber)
            let str = CombineLabelsText(Labels: numLabels)
            myScoreLabels[myIndex].text = str
            myHitLabels[myIndex].text = hitBlow[0]
            myBlowLabels[myIndex].text = hitBlow[1]
            myIndex += 1
            
            //相手の更新
            let rivalHit = rivalInfoUpdate(mystrs: strs)
            
            inputModeButton.isEnabled = true
            notActiveInputMode(flag: true)
            InitLabelsText(Labels: numLabels, str: "-")
            inputNumIndex = 0
            
            //勝敗チェック
            checkWin(myHit: hitBlow[0], rivalHit: rivalHit)
        } else {
            print("NeedPutNumber!: \(inputNumIndex)")
        }
    }
    
    func checkWin(myHit: String, rivalHit: String) {
        my = Int(myHit)!
        rival = Int(rivalHit)!
        if my == 3 && rival == 3{
            performSegue(withIdentifier: "toResult", sender: nil)
            print("draw")
        } else if my == 3 {
            performSegue(withIdentifier: "toResult", sender: nil)
            print("win")
        } else if rival == 3 {
            performSegue(withIdentifier: "toResult", sender: nil)
            print("lose")
        } else if rivalIndex == 9 {
            performSegue(withIdentifier: "toResult", sender: nil)
            print("draw")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toResult" {
            let next = segue.destination as? ResultViewController
            if my == 3 && rival == 3{
                next?.str = "draw"
                print("draw")
            } else if my == 3 {
                next?.str = "win"
                print("win")
            } else if rival == 3 {
                next?.str = "lose"
                print("lose")
            } else if rivalIndex == 9 {
                next?.str = "draw"
                print("draw")
            }
        }
    }
    
    func rivalInfoUpdate(mystrs: [String]) -> String {
        // 相手の入力
        var rivalInputNums: [Int] = []
        let r = Int(arc4random_uniform(10))
        rivalInputNums.append(r)
        var r1 = Int(arc4random_uniform(10))
        while r == r1 {
            r1 = Int(arc4random_uniform(10))
        }
        rivalInputNums.append(r1)
        var r2 = Int(arc4random_uniform(10))
        while r == r2 || r1 == r2 {
            r2 = Int(arc4random_uniform(10))
        }
        rivalInputNums.append(r2)
        
        // 入力に対するhitblow
        let rivalstrs = convertIntsToStrings(rivalNum: rivalInputNums)
        let hitBlow = checkHitBlow(numStr: rivalstrs, rival: convertStringsToInt(strs: mystrs))
        let rivalLavel = rivalstrs[0] + rivalstrs[1] + rivalstrs[2]
        
        //書き込み
        rivalScoreLabels[rivalIndex].text = rivalLavel
        rivalHitLabels[rivalIndex].text = hitBlow[0]
        rivalBlowLabels[rivalIndex].text = hitBlow[1]
        
        //更新
        rivalIndex += 1
        
        return hitBlow[0]
    }
    
    func checkHitBlow(numStr: [String], rival: [Int]) -> [String] {
        var hit = 0
        var blow = 0
        var scnt = 0
        var rcnt = 0
        let rivalNums = convertIntsToStrings(rivalNum: rival)
        for s in numStr {
            rcnt = 0
            for r in rivalNums {
                if s == r && scnt == rcnt {
                    hit += 1
                }
                if s == r {
                    blow += 1
                }
                rcnt += 1
            }
            scnt += 1
        }
        blow -= hit
        
        return ["\(hit)", "\(blow)"]
    }
    
    func convertIntsToStrings(rivalNum: [Int]) -> [String] {
        var str: [String] = []
        str.append(String(rivalNum[0]))
        str.append(String(rivalNum[1]))
        str.append(String(rivalNum[2]))
        
        return str
    }
    
    func convertStringsToInt(strs: [String]) -> [Int] {
        var nums: [Int] = []
        nums.append(Int(strs[0])!)
        nums.append(Int(strs[1])!)
        nums.append(Int(strs[2])!)
        
        return nums
    }
    
    func convertLabelToStrings(Labels: [UILabel]) -> [String] {
        var strs: [String] = []
        if let str = Labels[0].text {
            strs.append(str)
        }
        if let str = Labels[1].text {
            strs.append(str)
        }
        if let str = Labels[2].text {
            strs.append(str)
        }
        
        return strs
    }
    
    func CombineLabelsText(Labels: [UILabel]) -> String? {
        var s = ""
        if let str = Labels[0].text {
            s = str
        }
        if let str = Labels[1].text {
            s += str
        }
        if let str = Labels[2].text {
            s += str
        }
        return s
    }
}
