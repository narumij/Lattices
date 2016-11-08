//
//  CrystalCollada.swift
//  CIFCommand
//
//  Created by Jun Narumi on 2016/05/24.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

class CrystalCollada {

    var index: Int = 0
    var materials: [String] = []
    var effects: [String] = []
    var geometries: [String] = []
    var nodes: [String] = []

    init() {
    }

    func url(_ name:String) -> URL? {
        let bundle = Bundle.init(for: CrystalCollada.self )
        return bundle.url(forResource: name, withExtension: "xml");
    }

    func template(_ name:String) -> String? {
        var str:String?
        do {
            str = try NSString.init(contentsOf: url(name)!, encoding: String.Encoding.utf8.rawValue) as String
        } catch {
        }
        return str
    }

    func generateId(_ name:String) -> String {
        let id = name+index.description
        index = index + 1
        return id
    }

    func replace(_ template:String,_ pairs:[(String,String)]) -> String {
        return pairs.count == 0
            ? template
            : pairs.reduce(template, { (str:String, pair) -> String in
                return str.replacingOccurrences(of: pair.0, with: pair.1)
            })
    }

    func material(_ id:String,effectId:String) -> String {
        let p = [("__INSTANCE_EFFECT_URL__",effectId),
                 ("__MATRIAL_ID__",id)]
        return replace( template("Material") ?? "", p )
    }

    func floatArrayStr(_ v:SCNVector3) -> String {
        return v.x.description+" "+v.y.description+" "+v.z.description+" "
    }

    func floatArrayStr(_ v:SCNVector4) -> String {
        return v.x.description+" "+v.y.description+" "+v.z.description+" "+v.w.description+" "
    }

    func floatArrayStr(_ m:SCNMatrix4) -> String {
        return floatArrayStr(m.col1)+floatArrayStr(m.col2)+floatArrayStr(m.col3)+floatArrayStr(m.col4)
    }

    func effect(_ id:String,emission:SCNVector4,diffuse:SCNVector4) -> String {
        let p = [("__INSTANCE_EFFECT_URL__",id),
                 ("__EMISSION__",floatArrayStr(emission)),
                 ("__DIFFUSE__",floatArrayStr(diffuse))]
        return replace( template("Effect") ?? "", p )
    }

    func geometryLines(_ vertices:[SCNVector3],id:String,materialSymbol:String) -> String {
        if vertices.count == 0 {
            return ""
        }
        func geometrySourceId() -> String {
            return generateId("swiftGeometrySource")
        }
        func floatArrayId() -> String {
            return generateId("swiftFloatarray")
        }
        func verticesId() -> String {
            return generateId("swiftVertices")
        }
        func floatArray(_ vertices:[SCNVector3]) -> String {
            var str = ""
            for vert in vertices {
                str = str + floatArrayStr(vert)
            }
            return str
        }
        func indexArray(_ vertices:[SCNVector3]) -> String {
            var str = ""
            for i in 0..<(vertices.count*3) {
                str = str + i.description + " "
            }
            return str
        }
        let p = [("__FLOAT_COUNT__",(vertices.count * 3).description),
                 ("__VERTEX_COUNT__",vertices.count.description),
                 ("__LINE_COUNT__",(vertices.count / 2).description),
                 ("__GEOMETRY_ID__",id),
                 ("__GEOMETRY_SOURCE_ID__",geometrySourceId()),
                 ("__FLOAT_ARRAY_ID__",floatArrayId()),
                 ("__VERTICES_ID__",verticesId()),
                 ("__MATERIAL_SYMBOL__",materialSymbol),
                 ("__FLOAT_ARRAY__",floatArray(vertices)),
                 ("__INDEX_ARRAY__",indexArray(vertices))
        ]
        return replace( template("Lines") ?? "", p )
    }

    func instanceGeometry(_ geometryId:String,materialSymbol:String,materialId:String) -> String {
        let p = [("__GEOMETRY_ID__",geometryId),
                 ("__MATERIAL_SYMBOL__",materialSymbol),
                 ("__MATRIAL_ID__",materialId)
        ]
        return replace( template("InstanceGeometry") ?? "", p )
    }

    func planeNode(_ nodeId:String,contents:String) -> String {
        let p = [("__NODE_ID__",nodeId),("__CONTENTS__",contents)
        ]
        return replace( template("PlaneNode") ?? "", p )
    }

    func node(_ nodeId:String,matrix:SCNMatrix4,contents:String) -> String {
        let p = [("__NODE_ID__",nodeId),
                 ("__MATRIX__",floatArrayStr(matrix)),
                 ("__CONTENTS__",contents)
        ]
        return replace( template("Node") ?? "", p )
    }

    var collada: String {
        func materialsContents() -> String {
            return materials.joined(separator: "")
        }
        func effectsContents() -> String {
            return effects.joined(separator: "")
        }
        func geometriesContents() -> String {
            return geometries.joined(separator: "")
        }
        func nodeContents() -> String {
            return planeNode(generateId("world"), contents: nodes.joined(separator: ""))
        }
        let p = [("__DATE__",Date().description),
                 ("__MATERIALS__",materialsContents()),
                 ("__EFFECTS__",effectsContents()),
                 ("__GEOMETRIES__",geometriesContents()),
                 ("__NODE_TREE__",nodeContents())

        ]
        return replace( template("Collada") ?? "", p )
    }

    func test() {
//        print("Hello, Test!")
//        print(collada)
    }

    func addLines(_ vertices:[SCNVector3],emission:SCNVector4,diffuse:SCNVector4) {
        let materialId = generateId("material")
        let effectId = generateId("effect")
        let geometryId = generateId("geometry")
        let materialSymbol = generateId("materialSymbol")
        let nodeId = generateId("node")
        materials.append(material(materialId, effectId: effectId))
        effects.append( effect( effectId, emission: emission, diffuse: diffuse ) )
        geometries.append(geometryLines(vertices, id: geometryId, materialSymbol: materialSymbol))
        nodes.append(planeNode(nodeId, contents: instanceGeometry(geometryId, materialSymbol: materialSymbol, materialId: materialId)))
    }

    var sphereFlag: Bool = false
    func addSphere(_ size:RadiiSizeType,pos:SCNVector3,color:SCNVector4) {
        if sphereFlag == false {
            geometries.append(template("Sphere") ?? "")
            sphereFlag = true
        }
        let geometryId = "sphereMesh"
        let materialSymbol = "sphereElementSymbol"

        let materialId = generateId("material")
        let effectId = generateId("effect")
        let nodeId = generateId("node")
        let nodeId2 = generateId("node")

        let m = SCNMatrix4MakeTranslation(pos.x, pos.y, pos.z)
        let s = SCNMatrix4MakeScale(size, size, size)

        materials.append(material(materialId, effectId: effectId))
        effects.append( effect( effectId, emission: SCNVector4(0,0,0,1), diffuse: color ) )
        nodes.append(
            node(nodeId,
                matrix: m,
                contents:
                node(nodeId2,
                    matrix:s,
                    contents: instanceGeometry(geometryId, materialSymbol: materialSymbol, materialId: materialId))
            ))
    }
}










