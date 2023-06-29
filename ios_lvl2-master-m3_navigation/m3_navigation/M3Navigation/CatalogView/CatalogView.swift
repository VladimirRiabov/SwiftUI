//
//  CatalogView.swift
//  M3Navigation
//
//  Created by Владимир on 29.06.23.
//

import SwiftUI

struct CatalogView: View {
    let text: String
    var body: some View {
        Text(text)
    }
}

struct CatalogView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogView(text: "Catalog")
    }
}
