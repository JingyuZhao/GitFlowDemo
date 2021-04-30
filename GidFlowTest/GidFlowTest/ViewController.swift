//
//  ViewController.swift
//  GidFlowTest
//
//  Created by jory on 2021/3/10.
//

import UIKit
typealias InterceptBlock = () -> Bool

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        test(num: 1)
        test(num: 4)
        let intercept1 = ErrorIntercept.init(interceptCode: 200) {
            print("interface")
            for i in 0...100000 {
                print(i)
            }
            return false
        }

        let intercept2 = ErrorIntercept.init(interceptCode: 405) {
            print("interface2")
            return false
        }

        let adpat = InterceptAdapt.init(intercepts: [intercept1, intercept2])
        adpat.intercept(405)

    }

}
extension ViewController {
    func test(num:Int) {
        var score = num + 1
        let block = {[score] in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2) {
                print("***********")
                print(score)
            }
        }
        score = 4
        block()
    }
}
struct ErrorIntercept {

    var interceptCode = 0
    var interceptBlock: InterceptBlock = { return false }

    init(interceptCode: NSInteger, interceptAction: @escaping InterceptBlock) {
        self.interceptCode = interceptCode
        self.interceptBlock = interceptAction
    }
}
struct InterceptAdapt {
    private var intercepts: [ErrorIntercept]?
    init(intercepts: [ErrorIntercept]?) {
        self.intercepts = intercepts
    }
    func intercept(_ errorCode:NSInteger) {
        guard let interceptArr = intercepts else { return }
        for intercept in interceptArr {
            if errorCode == intercept.interceptCode {
                if intercept.interceptBlock() { return }
            }
        }
    }
}
