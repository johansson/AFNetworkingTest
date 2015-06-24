//
//  ViewController.swift
//  AFNetworkingTest
//
//  Created by Will Johansson on 2015-06-24.
//  Copyright © 2015 Johansson. All rights reserved.
//

import UIKit

class FooResponse {
    var data : AnyObject
    
    init(data: AnyObject) {
        self.data = data
    }
}

class FooSerializer: AFHTTPResponseSerializer {
    override func responseObjectForResponse(response: NSURLResponse!, data: NSData!) throws -> AnyObject {
        let response = try super.responseObjectForResponse(response, data: data)
        return FooResponse(data: response)
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let s = FooSerializer()
        let r_200 = NSURLRequest(URL: NSURL(string: "http://localhost:8080/200")!)
        let r_401 = NSURLRequest(URL: NSURL(string: "http://localhost:8080/401")!)
        
        let o1 = AFHTTPRequestOperation(request: r_200)
        
        o1.responseSerializer = s
        o1.setCompletionBlockWithSuccess({
            (operation, result) -> Void in
                NSLog("o1 success - EXPECTED")
        }) {
            (request, error) -> Void in
                NSLog("o1 failure - NOT EXPECTED")
        }

        let o2 = AFHTTPRequestOperation(request: r_401)
        o2.responseSerializer = s
        o2.setCompletionBlockWithSuccess({
            (operation, result) -> Void in
                NSLog("o2 success - NOT EXPECTED")
        }) {
            (request, error) -> Void in
                NSLog("o2 failure - EXPECTED")
        }
        
        let o3 = AFHTTPRequestOperation(request: r_401)
        o3.responseSerializer = AFHTTPResponseSerializer()
        o3.setCompletionBlockWithSuccess({
            (operation, result) -> Void in
                NSLog("o3 success - NOT EXPECTED")
        }) {
            (request, error) -> Void in
                NSLog("o3 failure - EXPECTED")
        }

        o1.start()
        o2.start()
        o3.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

