//
//  PlayingCardView.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 23.12.2020.
//  Copyright © 2020 Алексей Сергеев. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView {
    
    // creates a new view for stack
    private func pasteShapeView(in rect: CGRect) -> UIView {
        let view = ShapeView(frame: rect, shape: self.shape ?? .diamond,
                             color: self.color ?? .black,
                             filling: self.filling ?? .full)
        return view
    }
    
    var shape: ShapeView.Shapes? { didSet { setNeedsDisplay() } }
    var color: UIColor? { didSet { setNeedsDisplay() } }
    var filling: ShapeView.Fillings? { didSet { setNeedsDisplay() } }
    var amountOfShapes = 3 {
        didSet {
            if self.amountOfShapes > 3 {
                self.amountOfShapes = 3
            } else if self.amountOfShapes < 0 {
                self.amountOfShapes = 0
            }
            setNeedsDisplay()
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
    }
    
    convenience init(frame: CGRect, shape: ShapeView.Shapes, color: UIColor, filiing: ShapeView.Fillings, amount: Int) {
        self.init(frame: frame)
        self.shape = shape
        self.color = color
        self.filling = filling
        self.amountOfShapes = amount
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("PlayingCardView's init(coder:) has not been implemented")
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // draw the playing card
//        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        let rRect = CGRect(x: self.bounds.minX, y: self.bounds.minY, width: centeredDrawningsWidth, height: centeredDrawningsHight)
        let roundedRect = UIBezierPath(roundedRect: rRect, cornerRadius: cornerRadius)
        roundedRect.addClip()
        #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).setFill()
        roundedRect.fill()
        
        let box = roundedRect.cgPath.boundingBoxOfPath
        box.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        
        let stackView = createStackWithViews(amount: amountOfShapes,
                                             in: box)
        self.addSubview(stackView)
    }
    
    func createStackWithViews(amount: Int, in rect: CGRect) -> UIStackView {
        let stackView = UIStackView() // create a stack view
        
        // Config the stackView
        stackView.axis = .vertical // lay out views vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.contentMode = .scaleToFill
//        stackView.spacing = 10
        
        var stackFrame = CGRect(x: rect.minX, y: rect.minY,
                            width: rect.width,
                            height: (rect.height / 3.0) * CGFloat(amount)) //adjust stack to amount of views
        stackFrame = stackFrame.insetBy(dx: 50, dy: 50) // do stack smaller
        stackView.frame = stackFrame
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.center = CGPoint(x: rect.midX, y: rect.midY)
        
        // add few views
        for i in 0 ..< amount {
            
            let newRect = CGRect(x: stackFrame.origin.x, y: stackFrame.height/CGFloat(amount) * CGFloat(i), width: stackFrame.width, height: stackFrame.height/CGFloat(amount)) // create new bounds
            
            stackView.addArrangedSubview(pasteShapeView(in: newRect)) // add subview
        }
        return stackView
    }
    
}



extension PlayingCardView {
    private struct SizeRatio {
        static let cornerRadiusToBoundsHeight: CGFloat = 0.06
        static let centeredDrawningRatio: CGFloat = 0.75
    }
    private var cornerRadius: CGFloat {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundsHeight
    }
    
    private var centeredDrawningsHight: CGFloat {
        return bounds.size.height * SizeRatio.centeredDrawningRatio
    }
    
    private var centeredDrawningsWidth: CGFloat {
        return bounds.size.width * SizeRatio.centeredDrawningRatio
    }
}


