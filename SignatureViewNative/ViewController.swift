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

class Signature: UIView {
  
  
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
      label.isHidden = true
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
    

    toggle = false
    isToggle()
    setNeedsDisplay()
  }
  
}

var signature = Signature()
var label: UILabel!

class ViewController: UIViewController {
  
  
  @IBOutlet weak var signatureView: UIView!
  
  func displayPlaceholder(){
    label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
    label.center = CGPoint(x: 375, y: 408)
    label.textAlignment = .center
    label.text = "Sign here!"
    self.view.addSubview(label)
  }

  
  


  
  override func viewDidLoad() {
    super.viewDidLoad()
    


    
    
    view.addSubview(signature)
    signature.backgroundColor = .white
    signature.frame = signatureView.frame
    signature.layer.borderWidth = 6.0
    signature.layer.borderColor = UIColor.black.cgColor

        
    displayPlaceholder()
    //canvas.removeFromSuperview()
    

      

    
    
  }
  
  //helper function to help convert to png
  func getDocumentsDirectory() -> URL {
      let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
      return paths[0]
  }
  
  
  @IBAction func clearButton(_ sender: Any) {
    label.isHidden = false
    signature.clear()
  }

  @IBAction func submitButton(_ sender: Any) {
    if(signature.isEmpty() == true){
      let alert = UIAlertController(title: "No signature detected!",
        message: "",
        preferredStyle: .alert)
      let action = UIAlertAction(title: "OK", style: .default, handler: nil)
      
      alert.addAction(action)
      
      present(alert, animated: true, completion: nil)
    }
    else{

      //Convert to png
      
      //Helpful resources for conversion
      // https:www.hackingwithswift.com/example-code/media/how-to-save-a-uiimage-to-a-file-using-jpegdata-and-pngdata
      // http://www.mikitamanko.com/blog/2016/05/18/swift-how-to-render-a-uiview-to-a-uiimage/
      // https://stackoverflow.com/questions/31020608/convert-uiview-to-png-in-swift
      
      //The idea is to think of this with two approaches:
      //A.) Convert UIView --> PNG
      //B.) Convert UIView --> UIImage then UIImage --> PNG
      //The approach that was attempted in the following code is option B
         
         //Convert UIView to UIImage
         UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0)
         view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
      


         //Convert UIImage to PNG
         if let image2 = UIImage(named: "example.png") {
             if let data = image2.pngData() {
                 let filename = getDocumentsDirectory().appendingPathComponent("copy.png")
                 try? data.write(to: filename)
                 print("Converted to PNG")
             }
         }
   
      
      
      
      //segue to new screen
      performSegue(withIdentifier: "segue", sender: self)
    }
  }
  

}

