import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class DemoScreenAndr extends StatefulWidget {
  DemoScreenAndr({Key key}) : super(key: key);

  @override
  _DemoScreenAndrState createState() => _DemoScreenAndrState();
}

class _DemoScreenAndrState extends State<DemoScreenAndr> {
  ArCoreController _controller;
  ArCoreNode cubeNode;
  ArCoreReferenceNode model3d;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    cubeNode?.rotation?.value?.x += 0.001;

    return Container(
      child: ArCoreView(
        type: ArCoreViewType.STANDARDVIEW,
        onArCoreViewCreated: _onArCoreCreated,
        enableTapRecognizer: true,
        enableUpdateListener: true,
      ),
    );
  }

  _onArCoreCreated(ArCoreController controller) {
    _controller = controller;

    // _addSphere(_controller);
    // _addCylindre(_controller);

    controller.onNodeTap = _onNodeTapped;
    controller.onPlaneDetected = _onPlaneDetected;
  }

  void _addSphere(ArCoreController controller) {
    final material = ArCoreMaterial(color: Color.fromARGB(120, 66, 134, 244));
    final sphere = ArCoreSphere(
      materials: [material],
      radius: 0.1,
    );
    final node = ArCoreNode(
      shape: sphere,
      position: vector.Vector3(0, 0, -1.5),
    );
    controller.addArCoreNode(node);
  }

  void _addCylindre(ArCoreController controller) {
    final material = ArCoreMaterial(
      color: Colors.red,
      reflectance: 1.0,
    );
    final cylindre = ArCoreCylinder(
      materials: [material],
      radius: 0.5,
      height: 0.3,
    );
    final node = ArCoreNode(
      shape: cylindre,
      position: vector.Vector3(0.0, -0.5, -2.0),
    );
    controller.addArCoreNode(node);
  }

  void _addCube(ArCoreController controller, {position}) {
    if (cubeNode != null) {
      controller.removeNode(nodeName: cubeNode.name);
    }
    final material = ArCoreMaterial(
      color: Color.fromARGB(120, 66, 134, 244),
      metallic: 1.0,
    );

    final cube = ArCoreCube(
      materials: [material],
      // size: vector.Vector3(0.4, 0.4, 0.05),
      size: vector.Vector3(0.4, 0.4, 0.4),
    );
    cubeNode = ArCoreNode(
      shape: cube,
      position: position ?? vector.Vector3(-0.5, 0.5, -3.5),
    );

    controller.addArCoreNode(cubeNode);
  }

  void _add3dObject(ArCoreController controller, {position}) {
    if (model3d != null) {
      return;
    }

    model3d = ArCoreReferenceNode(
      name: 'object3d',
      object3DFileName: 'artic_fox.sfb',
      // for artic_fox
      scale: vector.Vector3(0.25, 0.25, 0.25),
      position: position ?? vector.Vector3(-0.5, 0.5, -3.5),
    );

    controller.addArCoreNodeWithAnchor(model3d);
  }

  _onNodeTapped(String nodeName) {
    print('hey, you tapped this node $nodeName');
  }

  _onPlaneDetected(ArCorePlane plane) {
    print('hey yo, there is a plane $plane');
    // plane.centerPose.translation;
    // plane.centerPose.rotation;

    // _addCube(_controller, position: plane.centerPose.translation);
    _add3dObject(_controller, position: plane.centerPose.translation);
  }
}
