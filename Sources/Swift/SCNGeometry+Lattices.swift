//
//  SCNGeometry.swift
//  SwiftCrystal
//
//  Created by Jun Narumi on 2016/09/04.
//  Copyright © 2016年 zenithgear. All rights reserved.
//

import SceneKit

extension SCNGeometrySource {

    convenience init( colors: UnsafeRawPointer,
                      count: Int)
    {
        let data = Data( bytes: colors, count: MemoryLayout<float4>.size*count )
        self.init( data: data,
                   semantic: SCNGeometrySource.Semantic.color,
                   vectorCount: count,
                   usesFloatComponents: true,
                   componentsPerVector: 4,
                   bytesPerComponent: MemoryLayout<Float>.size,
                   dataOffset: 0,
                   dataStride: MemoryLayout<float4>.size )
    }

    convenience init( positions: UnsafeRawPointer, count: Int ) {
        let data = Data( bytes: positions, count: MemoryLayout<float3>.size*count )
        self.init( data: data,
                   semantic: SCNGeometrySource.Semantic.vertex,
                   vectorCount: count,
                   usesFloatComponents: true,
                   componentsPerVector: 3,
                   bytesPerComponent: MemoryLayout<Float>.size,
                   dataOffset: 0,
                   dataStride: MemoryLayout<float3>.size )
    }

    convenience init( texcoords: UnsafeRawPointer, count: Int ) {
        let data = Data( bytes: texcoords, count: MemoryLayout<float2>.size*count )
        self.init( data: data,
                   semantic: SCNGeometrySource.Semantic.texcoord,
                   vectorCount: count,
                   usesFloatComponents: true,
                   componentsPerVector: 2,
                   bytesPerComponent: MemoryLayout<Float>.size,
                   dataOffset: 0,
                   dataStride: MemoryLayout<float2>.size )
    }

}

extension SCNGeometry {

    static func points( _ positions: [float3] ) -> SCNGeometry {
        let source = SCNGeometrySource(positions: positions, count: positions.count )
        let element = SCNGeometryElement(indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .point )
        return SCNGeometry( sources: [source], elements: [element] )
    }

    static func points( _ positions: [float3], colors: [float4] ) -> SCNGeometry {
        let vert = SCNGeometrySource(positions: positions, count: positions.count )
        let colr = SCNGeometrySource(colors: colors, count: colors.count )
        let element = SCNGeometryElement( indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .point )
        return SCNGeometry( sources: [vert,colr], elements: [element] )
    }

    static func lines( _ positions: [float3] ) -> SCNGeometry {
        let source = SCNGeometrySource(positions: positions, count: positions.count )
        let element = SCNGeometryElement(indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .line )
        return SCNGeometry( sources: [source], elements: [element] )
    }

    static func lines( _ positions: [float3], colors: [float4] ) -> SCNGeometry {
        let vert = SCNGeometrySource(positions: positions, count: positions.count )
        let colr = SCNGeometrySource(colors: colors, count: colors.count )
        let element = SCNGeometryElement( indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .line )
        return SCNGeometry( sources: [vert,colr], elements: [element] )
    }

    static func lines( _ positions: [float3], texcoords: [float2] ) -> SCNGeometry {
        let vrt = SCNGeometrySource(positions: positions, count: positions.count )
        let tex = SCNGeometrySource(texcoords: texcoords, count: texcoords.count )
        let element = SCNGeometryElement( indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .line )
        return SCNGeometry( sources: [vrt,tex], elements: [element] )
    }

    static func lines( _ positions: [float3], colors: [float4], texcoords: [float2] ) -> SCNGeometry {
        let vrt = SCNGeometrySource(positions: positions, count: positions.count )
        let clr = SCNGeometrySource(colors: colors, count: colors.count )
        let tex = SCNGeometrySource(texcoords: texcoords, count: texcoords.count )
        let element = SCNGeometryElement( indices: ( 0..<positions.count ).map{ UInt16( $0 ) }, primitiveType: .line )
        return SCNGeometry( sources: [vrt,clr,tex], elements: [element] )
    }

}

extension SCNGeometry {
    static func lines( _ vertices: [SCNVector3], textureCoordinates: [CGPoint] ) -> SCNGeometry {
        assert(false, "使うな！危険！")
        let vrt = SCNGeometrySource( vertices: vertices, count: vertices.count )
        let tex = SCNGeometrySource( textureCoordinates: textureCoordinates, count: textureCoordinates.count )
        let element = SCNGeometryElement( indices: ( 0..<vertices.count ).map{ UInt16( $0 ) }, primitiveType: .line )
        return SCNGeometry( sources: [vrt,tex], elements: [element] )
    }
}
