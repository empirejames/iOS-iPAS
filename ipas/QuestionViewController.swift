//
//  QuestionViewController.swift
//  ipas
//
//  Created by 韋儒朱 on 2018/12/5.
//  Copyright © 2018年 韋儒朱. All rights reserved.
//

import UIKit
 import Firebase

class QuestionViewController: UIViewController {
    var selectSubject: String?
    var selectCount: String?
    var numberOfSelect:Int?
    var ref: DatabaseReference!
    var dataBaseHandler : DatabaseHandle!
    var examItems: [examItemModel] = []
    var array = [examItemModel]()
    var previousNumber: UInt32?
    var randNum : Int?;
    var array_Number = [Int]();
    var page : Int = 0
    var answer : Int?
    var getAnser :Int = 0
    var countResult :Int = 0
    var countTimers : String?
    var label_txt: String?
    var timer :Timer?
    var speedSeconds :Int = 0
    let colors = Colors()
    
    @IBOutlet weak var btn_nextPage: UIButton!
    @IBOutlet weak var btn_upPage: UIButton!
    @IBOutlet weak var countItme: UILabel!
    
    @IBOutlet weak var btn_A: UIButton!
    @IBOutlet weak var btn_B: UIButton!
    @IBOutlet weak var btn_C: UIButton!
    @IBOutlet weak var btn_D: UIButton!
    @IBOutlet weak var time_display: UILabel!
    
    @IBOutlet weak var exam_topic: UILabel!
    @IBOutlet var btn_answers: [UIButton]!
    
    @IBAction func answer_pressed(_ sender: UIButton) {
        resetBtnBackground()
        switch sender.tag {
        case 0:
            //print("A")
            answer = 0
            btn_A.backgroundColor = UIColor(red: 226/255, green: 47/255, blue: 55/255, alpha: 0.5)
            resetBtnTextColor()
        case 1:
            //print("B")
            answer = 1
            btn_B.backgroundColor = UIColor(red: 226/255, green: 47/255, blue: 55/255, alpha: 0.5)
            resetBtnTextColor()
        case 2:
            //print("C")
            answer = 2
            btn_C.backgroundColor = UIColor(red: 226/255, green: 47/255, blue: 55/255, alpha: 0.5)
            resetBtnTextColor()
        case 3:
            //print("D")
            answer = 3
            btn_D.backgroundColor = UIColor(red: 226/255, green: 47/255, blue: 55/255, alpha: 0.5)
            resetBtnTextColor()
        case 4:
            //print("countResult  \(countResult) : answer : \(answer) page : \(page)")
             //print("page  \(page) : numberOfSelect : \(numberOfSelect!-1)" )
            if(self.page < self.numberOfSelect!-1){
            
                if getAnser != answer{
                    showAnswer()
                }else{
                    page+=1
                    self.updateView(numPage: page)
                }
            }else{
                if getAnser != answer{
                    showAnswer()
                }else{
                    let result : Int = numberOfSelect! - countResult
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "mainStory") as! ViewController
                    vc.dataString = String(result) + " / " + String(numberOfSelect!)
                    vc.timeString = countTimers
                    //self.present(vc, animated: true, completion: nil)
                    navigationController?.pushViewController(vc, animated: true)
                }
                
            }
        case 5:
            print("Up Page \(page)")
            if(self.page > 0){
                if(self.page <= self.numberOfSelect!-1){
                    page-=1
                    self.updateView(numPage: page)
                }
            }

            
            
        default:
            print("default")
        }
        
    }
    
    func refresh() {
        view.backgroundColor = UIColor.clear
        let backgroundLayer = colors.gl
        backgroundLayer.frame = view.frame
        view.layer.insertSublayer(backgroundLayer, at: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = selectSubject
        let backButton = UIBarButtonItem()
        backButton.title = "上一頁"
        self.navigationController!.navigationBar.topItem!.backBarButtonItem = backButton
        
        
        refresh()
        timer = Timer.scheduledTimer(timeInterval: 1.0,target: self,selector: #selector(QuestionViewController.updateTime) ,userInfo: nil, repeats: true)
        numberOfSelect = (selectCount as! NSString).integerValue
        if(selectSubject == "行動裝置概論"){
            selectSubject = "mobile_intruduction"
            randNum = 250
        }else if(selectSubject == "Android程式設計"){
            selectSubject = "mobile_android"
            randNum = 50
        }else if (selectSubject == "iOS程式設計"){
            selectSubject = "mobile_ios"
            randNum = 50
        }
         randomNumber(max_number: randNum!, numberOfSelect: numberOfSelect!)
        
         //print("\(numberOfSelect) + : +\(selectSubject!)")
        ref = Database.database().reference().child(selectSubject!)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            print("observe \(snapshot.childrenCount)")
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshots{
                    let tempData = snap.value as? NSDictionary
                    
                    if let userDict = snap.value as? [String:Any] {
                        //Do not cast print it directly may be score is Int not string
                        //print(userDict["topic"])
                    }
                    
                    let topic : String = tempData?["topic"] as? String ?? ""
                    let answer : String = tempData?["answer"] as? String ?? ""
                    let itemA : String = tempData?["item_A"] as? String ?? ""
                    let itemB : String = tempData?["item_B"] as? String ?? ""
                    let itemC : String = tempData?["item_C"] as? String ?? ""
                    let itemD : String = tempData?["item_D"] as? String ?? ""
                    
                    let arrays = examItemModel(topic: topic, answer: answer , item_A: itemA, item_B: itemB, item_C: itemC, item_D: itemD)
                    self.array.append(arrays)
                    
                }
            }
            //print(self.array[self.array_Number[0]].topic)
            self.updateView(numPage: self.page)
            
            
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        if timer != nil {
            timer?.invalidate()
        }
    }

    @objc func updateTime(){
        let showMinutes = String(format: "%02d", speedSeconds / 60)
        let ShowSeconds = String(format: "%02d", speedSeconds % 60)
        countTimers = showMinutes + " : " + ShowSeconds
        self.time_display.text = countTimers // 更新計時器
        speedSeconds += 1
    }
    
    func showAnswer(){
        countResult+=1
        if getAnser == 0 {
             btn_A.setTitleColor(.red, for: .normal)
        } else if getAnser == 1 {
             btn_B.setTitleColor(.red, for: .normal)
        } else if getAnser == 2 {
             btn_C.setTitleColor(.red, for: .normal)
        } else if getAnser == 3 {
             btn_D.setTitleColor(.red, for: .normal)
        }
    }
    
    func resetBtnBackground(){
        btn_A.backgroundColor = UIColor(red: 113/255, green: 140/255, blue: 189/255, alpha: 0.5)
        btn_A.layer.cornerRadius = 20.0
        btn_B.backgroundColor = UIColor(red: 113/255, green: 140/255, blue: 189/255, alpha: 0.5)
        btn_B.layer.cornerRadius = 20.0
        btn_C.backgroundColor = UIColor(red: 113/255, green: 140/255, blue: 189/255, alpha: 0.5)
        btn_C.layer.cornerRadius = 20.0
        btn_D.backgroundColor = UIColor(red: 113/255, green: 140/255, blue: 189/255, alpha: 0.5)
        btn_D.layer.cornerRadius = 20.0
    }
    func resetBtnTextColor(){
        btn_A.setTitleColor(.white, for: .normal)
        btn_A.contentHorizontalAlignment = .left //align left
        btn_A.titleLabel?.numberOfLines = 0  // \n
        btn_A.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn_A.titleLabel?.font =  .systemFont(ofSize: 18)
        
        btn_B.setTitleColor(.white, for: .normal)
        btn_B.contentHorizontalAlignment = .left
        btn_B.titleLabel?.numberOfLines = 0
        btn_B.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn_B.titleLabel?.font =  .systemFont(ofSize: 18)
        
        btn_C.setTitleColor(.white, for: .normal)
        btn_C.contentHorizontalAlignment = .left
        btn_C.titleLabel?.numberOfLines = 0
        btn_C.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn_C.titleLabel?.font =  .systemFont(ofSize: 18)
        
        btn_D.setTitleColor(.white, for: .normal)
        btn_D.contentHorizontalAlignment = .left
        btn_D.titleLabel?.numberOfLines = 0
        btn_D.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        btn_D.titleLabel?.font =  .systemFont(ofSize: 18)
    }
    func updateView(numPage : Int){
        resetBtnBackground()
        resetBtnTextColor()
        let result :Int = page + 1
        let total_result :Int = numberOfSelect ?? 0
        self.exam_topic.text = self.array[self.array_Number[numPage]].topic
        self.exam_topic.adjustsFontSizeToFitWidth = true
        
        self.btn_A.setTitle(self.array[self.array_Number[numPage]].item_A , for: .normal)
        self.btn_B.setTitle(self.array[self.array_Number[numPage]].item_B , for: .normal)
        self.btn_C.setTitle(self.array[self.array_Number[numPage]].item_C , for: .normal)
        self.btn_D.setTitle(self.array[self.array_Number[numPage]].item_D , for: .normal)
        self.countItme.text =  String(result) + " / " + String(total_result)
        
        
        
        if self.array[self.array_Number[page]].answer == "item_A"{
            getAnser = 0
        }else if self.array[self.array_Number[page]].answer == "item_B"{
            getAnser = 1
        }else if self.array[self.array_Number[page]].answer == "item_C"{
            getAnser = 2
        }else if self.array[self.array_Number[page]].answer == "item_D"{
            getAnser = 3
        }
    }

    func randomNumber(max_number: Int, numberOfSelect: Int)  {
        var result : Int
        result = max_number - numberOfSelect
        for i in 0...max_number{
            array_Number.append(i)
        }
        
        for j in 0...result{
            let index = Int(arc4random_uniform(UInt32(array_Number.count)))
            array_Number.remove(at: index)
        }

    }

}
