//
//  CubeView.swift
//  AnnotationTest
//
//  Created by Rahul on 2/13/24.
//

import SwiftUI
import UIKit
import RealityKit

class CubeARView: ARView {
    
    private var gestureRecognizer: UITapGestureRecognizer!
    private var didPlaceEntity = false
    
    var modelEntity: HeartEntity!
    var modelPath: URL?
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        
        gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didTap))
        self.addGestureRecognizer(gestureRecognizer)
        
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    private func createEntity() -> HeartEntity {
        let entity2 = HeartEntity(modelPath: modelPath!)
        return entity2!
    }
    
    private func place(_ entity: HeartEntity, at pos: SIMD3<Float>) {
        let anchor = AnchorEntity(world: pos)
        anchor.addChild(entity)
        
        self.scene.addAnchor(anchor)
    }
    
    private func addGestures(on obj: HeartEntity) {
        obj.generateCollisionShapes(recursive: true)
        
        self.installGestures([.rotation, .scale], for: obj)
    }
    
    private func placeEntity(_ pos: CGPoint) {
        let hitTestResult = self.hitTest(pos, types: [.estimatedHorizontalPlane])
        if let firstResult = hitTestResult.first {
            modelEntity = createEntity()
            addGestures(on: modelEntity)
            place(modelEntity, at: firstResult.worldTransform.translation)
            didPlaceEntity = true
            print("Placed Cube")
        }
        
        
    }
    
    @objc
    private func didTap(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let modelPath = modelPath else {
            print("did not select model")
            return
        }
        
        let pos = gestureRecognizer.location(in: self)
        print(pos)
        
        if !didPlaceEntity {
            placeEntity(pos)
            return
        }
        
        let entityHitTest = self.hitTest(pos)
        
        guard let firstResult = entityHitTest.first else { return }
        
        let entity = firstResult.entity
        print("Found entity: \(entity.name)")
        print("pos: \(firstResult.position)")
                
        let localPos = entity.convert(position: firstResult.position, from: nil)
        
        let material = SimpleMaterial(color: .black, isMetallic: false)
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.005), materials: [material])
        sphere.setPosition(localPos, relativeTo: nil)
        entity.addChild(sphere)
    }
}

struct CubeView: UIViewRepresentable {
    var modelPath: URL?
    
    func makeUIView(context: Context) -> CubeARView {
        return CubeARView(frame: .infinite)
    }
    
    func updateUIView(_ uiView: CubeARView, context: Context) {
        uiView.modelPath = modelPath
    }
}
