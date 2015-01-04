//
//  ViewController.swift
//  stripeexample
//
//  Created by MEGHA GULATI on 1/3/15.
//  Copyright (c) 2015 MEGHA GULATI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var email: UITextField!
    @IBOutlet var cardNum: UITextField!
    @IBOutlet var exp: UITextField!
    @IBOutlet var cvc: UITextField!
    @IBOutlet var payButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStripeToken(sender: AnyObject){
        let creditCard = STPCard()
        creditCard.number = cardNum.text
        creditCard.cvc = cvc.text
        
        if (!exp.text.isEmpty){
            let expArr = exp.text.componentsSeparatedByString("/")
            if (expArr.count > 1)
            {
                var expMonth: NSNumber = expArr[0].toInt()!
                var expYear: NSNumber = expArr[1].toInt()!
                
                creditCard.expMonth = expMonth.unsignedLongValue
                creditCard.expYear = expYear.unsignedLongValue
            }
        }
        
        var error: NSError?
        if (creditCard.validateCardReturningError(&error)){
            var stripeError: NSError!
            Stripe.createTokenWithCard(creditCard, completion: { (token, stripeError) -> Void in
                if (stripeError != nil){
                    println("there is error");
                }
                else{
                    self.cardNum.text = ""
                    self.exp.text = ""
                    self.cvc.text = ""
                    self.email.text = ""
                    
                    var alert = UIAlertController(title: "Your stripe token is: " + token.tokenId, message: "", preferredStyle: UIAlertControllerStyle.Alert)
                    var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(defaultAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            })
        }else{
            
            var alert = UIAlertController(title: "Please enter valid credit card details", message: "", preferredStyle: UIAlertControllerStyle.Alert)
            var defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(defaultAction)
            self.presentViewController(alert, animated: true, completion: nil)
            
        }

        
    }


}


