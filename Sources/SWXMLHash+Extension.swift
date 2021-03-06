//
//  SWXMLHash+Extension.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/14.
//

import SWXMLHash
import Foundation

protocol XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self
}

protocol XMLDecodable {

    static func decode(_ xml: XMLIndexer) throws -> Self
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) throws -> T {
    return try T.decode(xml)
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) -> T? {
    return try? T.decode(xml)
}

extension XMLIndexer {

    func attributeValue<T: XMLAttributeDecodable>(of attr: String) -> T? {
        return try? attributeValue(of: attr)
    }

    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T {
        switch self {
        case .element(let element):
            guard let attr = element.attribute(by: attr) else { throw XMLDeserializationError.nodeHasNoValue }
            return try T.decode(attr)
        default: throw XMLDeserializationError.implementationIsMissing(method: "attributeValue for stream case")
        }
    }

    public func byKey(_ key: String) -> XMLIndexer? {
        return try? byKey(key)
    }
}

extension XMLAttributeDeserializable where Self: XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self {
        return try deserialize(attribute)
    }
}

extension String: XMLAttributeDecodable {}
extension Int: XMLAttributeDecodable {}
extension Float: XMLAttributeDecodable {}
extension Bool: XMLAttributeDecodable {}

