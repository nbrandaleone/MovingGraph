//
//  graphView.swift
//  MovingGraph
//
//  Created by Nick Brandaleone on 5/20/15.
//  Copyright (c) 2015 Nick Brandaleone. All rights reserved.
//

import UIKit

class GraphView: UIView {

    // iphone 6 has 375 points in x direction; 667 pts in y direction.
    
    // the properties for the gradient
    @IBInspectable var startColor: UIColor = UIColor.redColor()
    @IBInspectable var endColor: UIColor = UIColor.greenColor()
    
    var graphPoints = [Int]()
    
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height

        let kXScale = 20    // how many discrete points do we want plotted before we start to scroll
        
        if self.graphPoints.count == 0 { return }
        
        // get the current context
        let context = UIGraphicsGetCurrentContext()
        let colors = [startColor.CGColor, endColor.CGColor]

        // set up the color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // set up the color stops
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        // create the gradient
        let gradient = CGGradientCreateWithColors(colorSpace, colors, colorLocations)
        
        // draw the gradient
        var startPoint = CGPoint.zeroPoint
        var endPoint = CGPoint(x: 0, y: self.bounds.height)
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0)
        
        // Remove data from beginning of range, so that we only focus on range of data that can appear in window
        if (self.graphPoints.count > Int(kXScale)) {
            self.graphPoints.removeRange(0..<(self.graphPoints.count - Int(kXScale)))
        }
        
        // calculate the x point
        let margin: CGFloat = 20.0
        let columnXPoint = {(column: Int) -> CGFloat in
            // Calculate the gap between points
            let spacer = (width - margin*2 - 4) / CGFloat(kXScale)
                //CGFloat((self.graphPoints.count - 1))
            var x: CGFloat = CGFloat(column) * spacer
            x += margin + 2
            return x
        }

        // Calculate the Y point
        let topBorder: CGFloat = 60
        let bottomBorder: CGFloat = 50
        let graphHeight = height - topBorder - bottomBorder
        let maxValue = 100 //maxElement(graphPoints)
        let columnYPoint = { (graphPoint: Int) -> CGFloat in
            var y: CGFloat = CGFloat(graphPoint) / CGFloat(maxValue) * graphHeight
            y = graphHeight + topBorder - y // Flip the graph
            return y
        }

        // draw the line graph
        UIColor.whiteColor().setFill()
        UIColor.whiteColor().setStroke()
        
        // set up the points line
        var graphPath = UIBezierPath()
        // go to start of line
        graphPath.moveToPoint(CGPoint(x: columnXPoint(0), y: columnYPoint(graphPoints[0])))
        
        // add points for each item in the graphPoints array
        for i in 1..<graphPoints.count {
            let nextPoint = CGPoint(x: columnXPoint(i), y: columnYPoint(graphPoints[i]))
            graphPath.addLineToPoint(nextPoint)
        }

        // draw the line on top of the clipped gradient
        graphPath.lineWidth = 2.0 // Perhaps lineWidth = 5.0
        graphPath.lineJoinStyle = kCGLineJoinRound
        graphPath.stroke()
        
        CGContextSaveGState(context)

        // draw the circles on top of graph stroke
        for i in 0..<graphPoints.count {
            var point = CGPoint(x:columnXPoint(i), y:columnYPoint(graphPoints[i]))
            point.x -= 5.0/2
            point.y -= 5.0/2
            
            let circle = UIBezierPath(ovalInRect: CGRect(origin: point, size: CGSize(width: 5.0, height: 5.0)))
            circle.fill()
        }
        
        // Draw horizontal graph lines on the top of everything
        var linePath = UIBezierPath()
        
        // top line
        linePath.moveToPoint(CGPoint(x: margin, y: topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: topBorder))
        
        // center line
        linePath.moveToPoint(CGPoint(x: margin, y: graphHeight/2 + topBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: graphHeight/2 + topBorder))
        
        // bottom line
        linePath.moveToPoint(CGPoint(x: margin, y: height - bottomBorder))
        linePath.addLineToPoint(CGPoint(x: width - margin, y: height - bottomBorder))
        let color = UIColor(white: 1.0, alpha: 0.3)
        color.setStroke()
        
        linePath.lineWidth = 1.0
        linePath.stroke()

        // Since we continually move the array of points into the window
        // we create an illusion of movement.  It is also possible to
        // use "translation" transforms to move the graphPath as well.
        //var transform = CGAffineTransformIdentity
        //transform = CGAffineTransformTranslate(transform, width/CGFloat(kXScale), 0)
        //graphPath.applyTransform(transform)
        
    }   // drawRect
}       // class
