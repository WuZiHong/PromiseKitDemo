//
//  ViewController.swift
//  PromiseKitDemo
//
//  Created by 吴子鸿 on 2017/5/9.
//  Copyright © 2017年 吴子鸿. All rights reserved.
//

import UIKit
import PromiseKit

enum MyErrors:Error {
    case DEFAULT
    case OUT_OF_RANGE
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:1 race
    
    func rabbit() -> Promise<String>{
        print("rabbit begin")
        return Promise{
            success,_ in    //_应该是失败回调，不过这里不会失败所以就。。。
            //后台线程跑，跑完回调
            DispatchQueue.global().async {
                var a = 0
                for i in 0..<100000000
                {
                    a = i
                }
                print(a)
                success("rabbit")
            }
        }
    }
    func turtle() -> Promise<String>{
        print("turtle begin")
        return Promise(value: "turtle")
    }
    
    @IBAction func raceButtonClick(_ sender: UIButton) {
        _ = race(rabbit(), turtle()).then { winner in
            // whoever fulfills first, wins!
            print("winner is \(winner)")        //结果成功的是turtle
        }
        
        print(PromiseKitVersionNumber)
        
    }
    
    //MARK:2 alertShow

    @IBAction func alertButtonClick(_ sender: UIButton) {
        let alert = PMKAlertController(title: "test", message: "aha", preferredStyle: .alert)
        let okbutton =  alert.addActionWithTitle(title: "好")
        let cancelbutton = alert.addActionWithTitle(title: "取消")
        _ = alert.addActionWithTitle(title: "缺省")
        _ = promise(alert).then { (action) -> Promise<Int> in
            switch action {
            case okbutton:
                return Promise(value:10)
            case cancelbutton:
                return Promise(value:20)
            default :
                throw MyErrors.DEFAULT
            }
            }
            .then {num in
                print("num is \(num)")
            }.catch { (e) in
                print(e)
        }
    }
    
    //MARK:3 login
    
    func login() -> Promise<NSDictionary> {     //或者 Promise<[String:String]>
        return Promise { fulfill, reject in     //fulfill：成功后回调函数，参数类型与Promise<T>中的T类型相同
                                                //reject: 失败后回调函数，参数为Error
//            fulfill([
//                "name":"wuzihong",
//                "age":"21"
//                ])
            reject(MyErrors.DEFAULT)
            
        }
    }
    
    @IBAction func selfButtonClick(_ sender: UIButton) {
        _ = login().then{ result in
            print(result)
        }.catch(execute: { (e) in
            print(e)
        })
    }

}

