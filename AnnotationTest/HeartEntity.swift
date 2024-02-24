//
//  HeartEntity.swift
//  AnnotationTest
//
//  Created by Rahul on 2/23/24.
//

import ARKit
import RealityKit
import UIKit

class HeartEntity: Entity, HasModel, HasAnchoring, HasCollision {
    var modelPath: URL
        
    required init?(modelPath: URL) {
        self.modelPath = modelPath

        super.init()
        guard let modelEntity = try? ModelEntity.loadModel(contentsOf: modelPath) else { return nil }
        self.components[ModelComponent.self] = modelEntity.model
    }
    
    @MainActor required init() {
        fatalError("init() has not been implemented")
    }
}

class HeartAnchor: ARAnchor {
    let modelData: Data
    
    init(transform: simd_float4x4, data: Data) {
        self.modelData = data
        
        super.init(transform: transform)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    required init(anchor: ARAnchor) {
        fatalError("init(anchor:) has not been implemented")
    }
}
