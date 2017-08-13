//: [Previous](@previous)

/*:
 
 #Sample Protocol
 
 A map like protocl that is more similar to a table view-ish . renders the landmark as its own view
 
 */

//make more like table view and table view cell

import Foundation
import UIKit
import PlaygroundSupport



/**
 
 Delegate for handing laying out fictional map landmarks
 
 */


protocol MapDataSource: class {
    func mapLandmarkCount(_ map: Map) -> Int
    func mapLandmark(_ map: Map, for index: Int) -> LandmarkView
}

protocol MapDelegate: class {
    func mapLandmarkSize(_ map: Map, for index: Int) -> CGFloat
    func mapLandmarkLocation(_ map: Map, for index: Int) -> CGPoint
}

extension MapDelegate {
    func mapLandmarkSize(_ map: Map, for index: Int) -> CGFloat {
        return 20
    }
    
    func mapLandmarkLocation(_ map: Map, for index: Int) -> CGPoint {
        return CGPoint.zero
    }
    func mapLandmarkView(_: Map, for index: Int) -> LandmarkView? {
        return nil
    }
    
}

//the view of the landmark
class LandmarkView: UIView {
    
    var reuseIdentifier: String?
    
    init(frame: CGRect, reuseIdentifier: String) {
        super.init(frame: frame)
        self.reuseIdentifier = reuseIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setFillColor(UIColor.red.cgColor)
        context.fillEllipse(in: rect)
    }
    
    func prepareForReuse() {
        
    }
    
}

// renders the landmarks as a uiview
class Map: UIView {
    weak var delegate: MapDelegate?
    weak var dataSource: MapDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        guard let dataSource = dataSource else {
            return
        }
        
        let count = dataSource.mapLandmarkCount(self)
        
        for index in 0 ..< count {
            let landmarkView = dataSource.mapLandmark(self, for: index)
            addSubview(landmarkView)
        }
    }
    
    
    func dequeueReusableLandmarkView(withIdentifier identifier: String, for index: Int) -> LandmarkView {
        guard let delegate = delegate else {
            return LandmarkView(frame: CGRect.init(), reuseIdentifier: "")
        }
        
        let size = delegate.mapLandmarkSize(self, for: index)
        let position = CGPoint(x: frame.width/2  , y: CGFloat(10 * index) + size)
        let rect = CGRect(origin: position, size: .zero).insetBy(dx: -size, dy: -size)
        
        let landmarkView = LandmarkView(frame: rect, reuseIdentifier: identifier)
        
        
        return landmarkView
    }
    
    
}

//actual implementation below

struct Landmark {
    var title: String
    var position: CGPoint?
}

class LandmarkPinView: LandmarkView {
    var title: String!
    var subTitle: String?
    
    
    override func layoutSubviews() {
        createLabel(frame: frame, text: title)
    }
    
    private func createLabel(frame: CGRect, text: String) {
        let label = UILabel(frame: frame)
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.3
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
    }
}

class MapViewController: MapDelegate, MapDataSource {
    
    
    var map: Map
    
    var landmarks: [Landmark] = [Landmark(title: "usa",
                                          position: CGPoint(x: 100, y:  100)),
                                 Landmark(title: "china",
                                          position: CGPoint(x: 200, y: 200)),
                                 Landmark(title: "mexico",
                                          position: CGPoint(x: 300, y: 100)),
                                 Landmark(title: "canada",
                                          position: CGPoint(x: 250, y: 300))]
    
    init() {
        map = Map(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        map.backgroundColor = .black
        map.delegate = self
        map.dataSource = self
        
    }
    
    func mapLandmarkCount(_ map: Map) -> Int {
        return landmarks.count
    }
    
    func mapLandmark(_ map: Map, for index: Int) -> LandmarkView {
        
        
        let landmarkView = map.dequeueReusableLandmarkView(withIdentifier: "landmark", for: index) as! LandmarkPinView
        
        landmarkView.title = landmarks[index].title
        
        return landmarkView
    }
    
    
}


let mvc = MapViewController()
mvc.map

PlaygroundPage.current.liveView = mvc.map

//: [Next](@next)
