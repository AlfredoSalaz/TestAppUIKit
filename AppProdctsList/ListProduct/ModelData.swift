//
//  ModelData.swift
//  AppProdctsList
//
//  Created by Alfredo Salazar on 06/06/22.
//

import Foundation

struct Productos: Decodable{
    var codigo: String?
    var resultado: Resultado?
}

struct Resultado: Decodable{
    var categoria: String?
    var productos: [Producto]?
}

class Producto: Decodable{
    static let shared = Producto()
    init() {
        
    }
    var id: String?
    var nombre: String?
    var urlImagenes: [String]?
    var precioFinal: Double?
    var categoria: String?
    var codigoCategoria: String?
}
