//
//  ContentView.swift
//  ObservableProduct
//
//  Created by Daniel Watson on 10/01/2021.
//

import SwiftUI

//MODEL
struct Product: Hashable, Identifiable {
    var id: Int
    var name : String
    var image : String {name.lowercased()}
    var isFave = false
}
//DATASOURCE
var productsArray : [Product] = [
        Product(id: 1, name: "Glasses"),
        Product(id: 2, name: "Gloves"),
        Product(id: 3, name: "Cape")
    ]

//CONTENT VIEW
struct ContentView: View {
    @StateObject var vM = ContentView.ViewModel(products: productsArray)
    var body: some View {
        NavigationView {
            List(vM.products) { product in
                ProductRow(vM: ProductRow.ViewModel.init(product: product))
                    }
                }
            }
        }
//CONTENTVIEW MODEL
extension ContentView {
    class ViewModel : ObservableObject {
        @Published var products = [Product]()
        init(products: [Product]) {
            self.products = products
        }
        
    }
}
//PRODUCT ROW VIEW
struct ProductRow: View {
    @ObservedObject var vM : ProductRow.ViewModel
    var body: some View {
        NavigationLink(destination: DetailScreen(vM: vM)) {
        HStack {
            Text(vM.product.name)
            Spacer()
            Image(systemName: vM.product.isFave ? "heart.fill" : "heart")
            }
        }
    }
}
//PRODUCT ROW VIEW MODEL
extension ProductRow {
    class ViewModel : ObservableObject {
        @Published var product: Product
        init(product: Product) {
            self.product = product
        }
    }
}
//DETAIL SCREEN VIEW
struct DetailScreen: View {
    @ObservedObject var vM : ProductRow.ViewModel
    var body: some View {
        Text(vM.product.name)
        Image(vM.product.image)
            .resizable()
        Image(systemName: vM.product.isFave ? "heart.fill" : "heart")
            .onTapGesture {
                vM.product.isFave.toggle()
        }
    }
}
//PREVIEWS
struct ContentView_Previews: PreviewProvider {
    static let product = Product(id: 1, name: "Coat")
    static let vM = ProductRow.ViewModel(product: product)
    static var previews: some View {
        ProductRow(vM: vM)
        DetailScreen(vM: vM)
        ContentView()
    }
}
