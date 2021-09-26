//
//  ViewController.swift
//  Surfases
//
//  Created by Николай Никитин on 25.09.2021.
//

import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

  @IBOutlet var sceneView: ARSCNView!

  func loadShip() -> SCNNode {

    let scene = SCNScene(named: "art.scnassets/ship.scn")!
    let shipNode = scene.rootNode.clone()
    return shipNode
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    sceneView.autoenablesDefaultLighting = true
    // Set the view's delegate
    sceneView.delegate = self

    // Show statistics such as fps and timing information
    sceneView.showsStatistics = true

  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    // Create a session configuration
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    sceneView.session.run(configuration)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    // Pause the view's session
    sceneView.session.pause()
  }

  // MARK: - ARSCNViewDelegate
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor {
      print(#line, #function, "Fount horizontal plane!")
      // set sizes
      let extend = planeAnchor.extent
      let width = CGFloat(extend.x)
      let height = CGFloat(extend.z)

      //create geometry
      let plane = SCNPlane(width: width, height: height)
      plane.firstMaterial?.diffuse.contents = UIColor.green
      // create node
      let planeNode = SCNNode.init(geometry: plane)
      planeNode.eulerAngles.x = -.pi / 2
      planeNode.opacity = 0.5

      // add node to detected surfase
      node.addChildNode(planeNode)
      node.addChildNode(loadShip())
    }
  }
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    if let planeAnchor = anchor as? ARPlaneAnchor, planeAnchor.alignment == .horizontal {
      for childNode in node.childNodes {
        childNode.simdPosition = planeAnchor.center

        if let plane = childNode.geometry as? SCNPlane {
          plane.width = CGFloat(planeAnchor.extent.x)
          plane.height = CGFloat(planeAnchor.extent.z)
        }
      }
    }
  }
}
