//
//  View.swift
//  TextPaths
//
//  Created by Ahmed Khalaf on 2/16/20.
//  Copyright © 2020 io.github.ahmedkhalaf. All rights reserved.
//

import UIKit
import ARCGPathFromString

class View: UIView {
    private lazy var gradientLayer: CAGradientLayer = {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.orange, .yellow].map({ $0.cgColor })
        gradientLayer.startPoint = .init(x: 0, y: 0)
        gradientLayer.endPoint = .init(x: 1, y: 1)
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
        return gradientLayer
    }()
    
    private lazy var maskLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.black.cgColor
        shapeLayer.fillRule = .evenOdd
        shapeLayer.isGeometryFlipped = true
        return shapeLayer
    }()
    
    private var sign: CGFloat = -1
    private var widthFactor: CGFloat = 1 {
        didSet {
            if widthFactor < 0 {
                widthFactor = 0
                sign *= -1
            }
            if widthFactor > 1 {
                widthFactor = 1
                sign *= -1
            }
        }
    }
    
    @objc private func update() {
        widthFactor += 0.01 * sign
        setNeedsLayout()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        CADisplayLink(target: self, selector: #selector(update)).add(to: .main, forMode: .common)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        
        maskLayer.frame = bounds
        let path = UIBezierPath(rect: bounds)
        
        let width = bounds.width * widthFactor
        path.append(UIBezierPath(ovalIn: CGRect(x: (bounds.width - width) / 2, y: 0, width: width, height: bounds.height)))
        
        let attrStr = NSAttributedString(string: "Hello", attributes: [
            .font: UIFont.systemFont(ofSize: 80),
            .foregroundColor: UIColor.black
        ])
        
        let attrStrSize = attrStr.boundingRect(with: CGSize(width: CGFloat.greatestFiniteMagnitude, height: .greatestFiniteMagnitude), options: [], context: nil).size
        
        let stringPath = UIBezierPath(for: attrStr)
        stringPath.apply(.init(translationX: (bounds.width - attrStrSize.width) / 2, y: (bounds.height - attrStrSize.height) / 2))
        path.append(stringPath)
        maskLayer.path = path.cgPath
    }
}
