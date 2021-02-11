//
//  ShapeView.swift
//  Game_SET
//
//  Created by Алексей Сергеев on 03.02.2021.
//  Copyright © 2021 Алексей Сергеев. All rights reserved.
//

import UIKit

class ShapeView: UIView {
    
    enum Shapes {
        case diamond, squiggle, oval
    }
    
    enum Fillings {
        case full, semi, non
    }
    
    init(frame: CGRect, shape: Shapes, color: UIColor, filling: Fillings) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        
        chosenShape = shape
        self.color = color
        self.filling = filling
    }
    
    required init?(coder: NSCoder) {
        fatalError("ShapeView! init(coder:) has not been implemented")
    }
    
    private(set) var chosenShape: Shapes?
    private(set) var color: UIColor?
    private(set) var filling: Fillings?
    
    // It takes a shape and puts it in a drawning's holder (drawThisShape)
    var drawThisShape: UIBezierPath? {
        get {
            switch self.chosenShape {
                case .diamond:
                    return drawDiamondShape(in: bounds)
                case .oval:
                    return drawOvalShape(in: bounds)
                case .squiggle:
                    return drawSquiggleSape(in: bounds)
                default:
                    return drawDiamondShape(in: bounds)
            }
        }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        switch filling {
        case .full:
            color?.setFill()
            color?.setStroke()
        case .semi:
            color?.withAlphaComponent(0.5).setStroke()
            color?.withAlphaComponent(0.5).setFill()
        case .non:
            #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0).setFill()
            color?.setStroke()
        default:
            color?.setFill()
            color?.setStroke()
        }
        
        drawThisShape?.stroke()
        drawThisShape?.fill()
    }
    
    // create an diamond shape and fit it in the rectangle
    private func drawDiamondShape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 1.8, y: 13.0))
        path.addLine(to: CGPoint(x: 21.8, y: 3.0))
        path.addLine(to: CGPoint(x: 41.8, y: 13.0))
        path.addLine(to: CGPoint(x: 21.8, y: 23.0))
        path.addLine(to: CGPoint(x: 1.8, y: 13.0))
        path.close()
        
        let scale: CGFloat = rect.width / (1.1 * path.bounds.width)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path.apply(transform)
        path.lineWidth = 11.0
        
        return path
    }
    
    // create a squilgle shape and fit it in the rectangle
    private func drawSquiggleSape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()

        path.move(to: CGPoint(x: 104.0, y: 15.0))
        path.addCurve(to: CGPoint(x: 63.0, y: 54.0),
                      controlPoint1: CGPoint(x: 112.4, y: 36.9),
                      controlPoint2: CGPoint(x: 89.7, y: 60.8))
        path.addCurve(to: CGPoint(x: 27.0, y: 53.0),
                      controlPoint1: CGPoint(x: 52.3, y: 51.3),
                      controlPoint2: CGPoint(x: 42.2, y: 42.0))
        path.addCurve(to: CGPoint(x: 5.0, y: 40.0),
                      controlPoint1: CGPoint(x: 9.6, y: 65.6),
                      controlPoint2: CGPoint(x: 5.4, y: 58.3))
        path.addCurve(to: CGPoint(x: 36.0, y: 12.0),
                      controlPoint1: CGPoint(x: 4.6, y: 22.0),
                      controlPoint2: CGPoint(x: 19.1, y: 9.7))
        path.addCurve(to: CGPoint(x: 89.0, y: 14.0),
                      controlPoint1: CGPoint(x: 59.2, y: 15.2),
                      controlPoint2: CGPoint(x: 61.9, y: 31.5))
        path.addCurve(to: CGPoint(x: 104.0, y: 15.0),
                      controlPoint1: CGPoint(x: 95.3, y: 10.0),
                      controlPoint2: CGPoint(x: 100.9, y: 6.9))
        path.close()
                
        let scale: CGFloat = rect.width / (1.1 * path.bounds.width)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path.apply(transform)
        path.lineWidth = 11.0
        
        return path
    }
    
    // create an oval shape and fit it in the rectangle
    private func drawOvalShape(in rect: CGRect) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.addArc(withCenter: CGPoint(x: 16.8, y: 15.8),
                    radius: 14.0, startAngle: .pi * 3 / 2,
                    endAngle: .pi/2,
                    clockwise: false)
        path.move(to: CGPoint(x: 16.8, y: 1.8))
        path.addLine(to: CGPoint(x: 46.8, y: 1.8))
        path.addArc(withCenter: CGPoint(x: 46.8, y: 15.8),
                    radius: 14.0, startAngle: .pi * 3 / 2,
                    endAngle: .pi/2,
                    clockwise: true)
        path.addLine(to: CGPoint(x: 16.8, y: 29.8))
        path.close()
        
        
        let scale: CGFloat = rect.width / (1.09 * path.bounds.width)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        path.apply(transform)
        path.lineWidth = 11.0
        
        return path
    }
}
