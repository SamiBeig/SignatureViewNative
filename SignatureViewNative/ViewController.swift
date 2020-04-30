//
//  ViewController.swift
//  SignatureViewNative
//
//  Created by Sami Beig on 3/25/20.
//  Copyright © 2020 Sami Beig. All rights reserved.
//

import UIKit

//Toggle used to display placeholder, true = display, false = hide
var toggle = true

class Canvas: UIView {
  
  
  func clear(){
    lines.removeAll()
    toggle = true
    setNeedsDisplay()
  }
  
  func isEmpty() -> Bool{
    if (lines.count == 0) {
      return true
    }
    else{
      return false
    }
  }
  
  //function used to remove the label from the superview
  func isToggle(){
    if toggle == false{
      canvas.removeFromSuperview()
    }
  }
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    context.setStrokeColor(UIColor.black.cgColor)
    context.setLineWidth(10)
    context.setLineCap(.butt)
    
    lines.forEach { (line) in
      for (i, p) in line.enumerated() {
        if i == 0 {
          context.move(to: p)
        } else {
          context.addLine(to: p)
        }
      }
    }
    
    context.strokePath()
    
  }
  
  var lines = [[CGPoint]]()
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    lines.append([CGPoint]())

  }
  
  // track the finger as we move across screen
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let point = touches.first?.location(in: self) else { return }
    
    guard var lastLine = lines.popLast() else { return }
    lastLine.append(point)
    lines.append(lastLine)
    
    //Adding these two statements below makes the canvas turn grey instead
    //of adding lines
    
    //toggle = false
    //isToggle()
    setNeedsDisplay()
  }
  
}

var canvas = Canvas()

class ViewController: UIViewController {
  
  
  @IBOutlet weak var signatureView: UIView!
  
  func displayPlaceholder(){
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    label.center = CGPoint(x: 375, y: 408)
    label.textAlignment = .center
    label.text = "Sign here!"
    self.view.addSubview(label)
  }

  
  


  
  override func viewDidLoad() {
    super.viewDidLoad()
    


    
    
    view.addSubview(canvas)
    canvas.backgroundColor = .white
    canvas.frame = signatureView.frame
    canvas.layer.borderWidth = 6.0
    canvas.layer.borderColor = UIColor.black.cgColor

        
    displayPlaceholder()
    //canvas.removeFromSuperview()
    

      

    
    
  }
  
  
  @IBAction func clearButton(_ sender: Any) {
    canvas.clear()
  }

  @IBAction func submitButton(_ sender: Any) {
    if(canvas.isEmpty() == true){
      let alert = UIAlertController(title: "No signature detected!",
        message: "",
        preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
    }
    else{
      //Convert to png
   
      
      
      
      //segue to new screen
      performSegue(withIdentifier: "segue", sender: self)
    }
  }
  

}

