//: [Previous](@previous)

/*:
 
 #Sample Protocol
 
 A map like protocl that is more similar to a table view-ish . renders the landmark as its own view
 
 */



import Foundation
import UIKit
import PlaygroundSupport


///The Landmark object
protocol Landmark {
    var title: String? { get }
    var subTitle: String? { get  }
    var position: CGPoint? { get }
}

extension Landmark {
    var subTitle: String? {
        return ""
    }
    var title: String? {
        return ""
    }
}



/**
 
 Delegate for handing laying out fictional map landmarks
 
 */


protocol MapDataSource: class {
    func mapLandmarkCount(_ map: Map) -> Int
    func mapLandmark(_ map: Map, for index: Int) -> Landmark
}

protocol MapDelegate: class {
    func mapLandmarkSize(_ map: Map, for index: Int) -> CGFloat
    func mapLandmarkLocation(_ map: Map, for index: Int) -> CGPoint
    func mapLandmarkView(_: Map, for index: Int) -> LandmarkView?
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
    
    var landmark: Landmark?
    var reuseIdentifier: String?
    
    init(frame: CGRect, landmark: Landmark?, reuseIdentifier: String) {
        super.init(frame: frame)
        self.reuseIdentifier = reuseIdentifier
        self.landmark = landmark
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
        createLabel(frame: rect, text: landmark?.title ?? "")
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched", "\(landmark?.title ?? "empty")")
    }
}

// renders the landmarks as a uiview
class Map: UIView {
    weak var delegate: MapDelegate?
    weak var dataSource: MapDataSource?
    
    var landmarks: [Landmark]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.landmarks = []
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func dequeueReusableLandmarkView(withIdentifier identifier: String, for index: Int) -> LandmarkView? {
        guard let delegate = delegate,
            let dataSource = dataSource else {
                return nil
        }
        
        let landmark = dataSource.mapLandmark(self, for: index)
        let size = delegate.mapLandmarkSize(self, for: index)
        let position = landmark.position ?? CGPoint(x: 0, y: 0)
        let rect = CGRect(origin: position, size: .zero).insetBy(dx: -size, dy: -size)
        
        let landmarkView = LandmarkView(frame: rect, landmark: landmark, reuseIdentifier: identifier)
        
        return landmarkView
    }
    
    ///adds model landmark and converts to a view
    func addLandmarks(_ landmarks: [Landmark]) {
        guard let delegate = delegate else {
            return
        }
        
        
        var landmarkView: LandmarkView?
        
        var index = 0
        for landmark in landmarks {
            landmarkView = delegate.mapLandmarkView(self, for: index)
            self.addSubview(landmarkView!)
            
            self.landmarks?.append(landmark)
            index += 1
        }
    }
}

//below is actual impementation
///landmark model "pin"
class LandmarkPin: Landmark {
    var title: String?
    var subTitle: String?
    var position: CGPoint?
    
    init(title: String, subTitle: String? = nil, position: CGPoint) {
        self.title = title
        self.subTitle = subTitle
        self.position = position
    }
}

class MapViewController: MapDelegate, MapDataSource {
    
    
    var map: Map
    
    
    var landmarks: [LandmarkPin] = [LandmarkPin(title: "usa",
                                                position: CGPoint(x: 100, y:  100)),
                                    LandmarkPin(title: "china",
                                                position: CGPoint(x: 200, y: 200)),
                                    LandmarkPin(title: "mexico",
                                                position: CGPoint(x: 300, y: 100)),
                                    LandmarkPin(title: "canada",
                                                position: CGPoint(x: 250, y: 300))]
    
    init() {
        map = Map(frame: CGRect(origin: .zero, size: CGSize(width: 400, height: 400)))
        map.backgroundColor = .black
        map.delegate = self
        map.dataSource = self
        
        map.addLandmarks(landmarks)
    }
    
    func mapLandmarkCount(_ map: Map) -> Int {
        return landmarks.count
    }
    
    func mapLandmark(_ map: Map, for index: Int) -> Landmark {
        return landmarks[index]
    }
    
    func mapLandmarkView(_ map: Map, for index: Int) -> LandmarkView? {
        
        let landmarkView = map.dequeueReusableLandmarkView(withIdentifier: "landmark", for: index)
        
        return landmarkView
    }
    
}


let mvc = MapViewController()
mvc.map
mvc.map.landmarks![1].title

PlaygroundPage.current.liveView = mvc.map

//: [Next](@next)
