/*:
 
 #Sample Protocol
 
 A map like protocol that uses delegates and datasoources like a table view, but uses a struct as a model. Also renders the landmark on the map directly
 
 */



import Foundation
import UIKit
import PlaygroundSupport


struct LandmarkTemp {
    var title: String?
    var position: CGPoint?
}


/**
 
 Delegate for handing laying out fictional map landmarks
 
 */


protocol MapDataSource: class {
    func mapLandmarkCount(_ map: Map) -> Int
    func mapLandmark(_ map: Map, for index: Int) -> LandmarkTemp
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
    
    override func draw(_ rect: CGRect) {
        
        
        guard let delegate = delegate,
            let dataSource = dataSource else {
                return
        }
        let count = dataSource.mapLandmarkCount(self)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        for index in 0 ..< count {
            //add uisuview circles that are touchable. via protocols
            context.setFillColor(UIColor.red.cgColor)
            let landmark = dataSource.mapLandmark(self, for: index)
            let size = delegate.mapLandmarkSize(self, for: index)
            let position = landmark.position ?? CGPoint(x: 0, y: 0)
            let rect = CGRect(origin: position, size: .zero).insetBy(dx: -size, dy: -size)
            context.fillEllipse(in: rect)
            // draw landmark
            
            createLabel(frame: rect, text: landmark.title ?? "")
        }
    }
    
    
    func landmark(forIndexAt index: Int) -> LandmarkTemp? {
        guard let dataSource = dataSource else {
            return nil
        }
        
        let landmark = dataSource.mapLandmark(self, for: index)
        return landmark
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
    
    var landmarks: [LandmarkTemp] = [LandmarkTemp(title: "usa",
                                                  position: CGPoint(x: 100, y:  100)),
                                     LandmarkTemp(title: "china",
                                                  position: CGPoint(x: 200, y: 200)),
                                     LandmarkTemp(title: "mexico",
                                                  position: CGPoint(x: 300, y: 100)),
                                     LandmarkTemp(title: "canada",
                                                  position: CGPoint(x: 250, y: 300))]
    
    
    init() {
        map = Map(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        map.delegate = self
        map.dataSource = self
    }
    
    func mapLandmarkCount(_ map: Map) -> Int {
        return landmarks.count
    }
    
    func mapLandmark(_ map: Map, for index: Int) -> LandmarkTemp {
        return landmarks[index]
    }
    
    
}


let mvc = MapViewController()
mvc.map.landmark(forIndexAt: 0)?.title
mvc.map

PlaygroundPage.current.liveView = mvc.map




//: [Next](@next)
