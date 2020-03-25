//
//  ViewController.swift
//  SignatureViewNative
//
//  Created by Sami Beig on 3/25/20.
//  Copyright © 2020 Sami Beig. All rights reserved.
//

import UIKit


class Canvas: UIView {
  
  
  func clear(){
    lines.removeAll()
    setNeedsDisplay()
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
    setNeedsDisplay()
  }
  
}

var canvas = Canvas()

class ViewController: UIViewController {
  
  
  @IBOutlet weak var signatureView: UIView!
  


  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    view.addSubview(canvas)
    canvas.backgroundColor = .gray
    canvas.frame = signatureView.frame
    
  }
  
  @IBAction func clearButton(_ sender: Any) {
    canvas.clear()
  }

  @IBAction func submitButton(_ sender: Any) {
    performSegue(withIdentifier: "segue", sender: self)
  }
}

