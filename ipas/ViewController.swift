//
//  ViewController.swift
//  ipas
//
//  Created by 韋儒朱 on 2018/12/5.
//  Copyright © 2018年 韋儒朱. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    
    @IBOutlet weak var pre_count: UILabel!
    @IBOutlet weak var pre_count_value: UILabel!
    
    @IBOutlet weak var pre_spendTime: UILabel!
    @IBOutlet weak var pre_spendTime_value: UILabel!
    let colors = Colors()
    
    
    @IBOutlet weak var btn_select: UIButton!
    @IBOutlet weak var btn_count: UIButton!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var number_buttons: [UIButton]!
    var dataString: String?
    var timeString: String?
    @IBAction func optionSelect(_ sender: UIButton) {
        for option in buttons{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
        btn_count.isHidden = !btn_count.isHidden
    }
    @IBAction func optionPressed(_ sender: UIButton) {
        let selectItem = sender.currentTitle ?? ""
        btn_select.setTitle(selectItem, for:.normal)
        btn_count.isHidden = !btn_count.isHidden
        for option in buttons{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func num_select(_ sender: UIButton) {
        for option in number_buttons{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func numberPressed(_ sender: UIButton) {
        let selectItem = sender.currentTitle ?? ""
        btn_count.setTitle(selectItem, for:.normal)
        for option in number_buttons{
            UIView.animate(withDuration: 0.3, animations: {
                option.isHidden = !option.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is QuestionViewController
        {
            let vc = segue.destination as? QuestionViewController
            //vc?.username = "Arthur Dent"
            vc?.selectSubject = btn_select.titleLabel?.text
            vc?.selectCount = btn_count.titleLabel?.text
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
        refresh()
        if(dataString != nil){
             pre_count_value.text = dataString
            pre_spendTime_value.text = timeString
        }else{
            pre_count.isHidden = true
            pre_count_value.isHidden = true
            pre_spendTime.isHidden = true
            pre_spendTime_value.isHidden = true
        }
    }

}

