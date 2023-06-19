//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Rishav Gupta on 18/06/23.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.orders.name)
                TextField("Street Address", text: $order.orders.streetAddress)
                TextField("City", text: $order.orders.city)
                TextField("Zip", text: $order.orders.zip)
            }
            
            Section {
                NavigationLink {
                    CheckoutView(order: order)
                } label: {
                    Text("Check out")
                }
            }
            .disabled(order.orders.hasValidAddress == false || order.orders.hasValidEntry == false)
        }
        .navigationTitle("Delivery Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AddressView(order: Order())
        }
    }
}
