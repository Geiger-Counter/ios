//
//  ARView.swift
//  GeigerCounter
//
//  Created by Marco Combosch on 09.10.20.
//

import Foundation
import ARKit
import SpriteKit
import SwiftUI

struct ARViewIndicator : UIViewControllerRepresentable {
    typealias UIViewControllerType = ARViewController
    
    func makeUIViewController(context: Context) -> ARViewController {
        return ARViewController()
    }
    
    func updateUIViewController(_ uiViewController: ARViewController, context: UIViewControllerRepresentableContext<ARViewIndicator>) {}
}

class ARViewController : UIViewController, ARSCNViewDelegate {
   
    var sceneView : ARSCNView {
        return self.view as! ARSCNView
    }
    
    override func loadView() {
        self.view = ARSCNView(frame: .zero)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.scene = SCNScene(named: "Particles.scn")!
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            guard let pointOfView = self.sceneView.pointOfView else { return }
            let transform = pointOfView.transform
            let orientation = SCNVector3(-transform.m31, -transform.m32, -transform.m33)
            let location = SCNVector3(transform.m41, transform.m42, transform.m43)
            let pos = SCNVector3(orientation.x + location.x, orientation.y + location.y, orientation.z + location.z)
            
            guard let particles = self.sceneView.scene.rootNode.childNode(withName: "particles", recursively: true) else { return }
            
            particles.position = pos
            
            guard let systems = particles.particleSystems else { return }
            let sys : SCNParticleSystem = systems[0]
            sys.birthRate = 5
        }
    }
    
    func sessionWasInterrupted(_ session: ARSession) {}
    
    func sessionInterruptionEnded(_ session: ARSession) {}
    
    func session(_ session : ARSession, didFailWithError error : Error) {}
    
    func session(_ session: ARSession, cameraDidChangeTrachingState camera : ARCamera) {}

}
