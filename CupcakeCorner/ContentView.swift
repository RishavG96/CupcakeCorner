//
//  ContentView.swift
//  CupcakeCorner
//
//  Created by Rishav Gupta on 18/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var order = Order() // this is the only place where Order would be created using @StateObject. Other places it would be used with @ObservedObject
    
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select your cake type", selection: $order.orders.type) {
                        ForEach(OrderItem.types.indices) { index in
                            Text(OrderItem.types[index])
                        }
                    }
                    
                    Stepper("No. of cakes: \(order.orders.quantity)", value: $order.orders.quantity, in: 3...20)
                }
                
                Section {
                    Toggle("Any special requests?", isOn: $order.orders.specialRequestEnabled.animation())
                    
                    if order.orders.specialRequestEnabled {
                        Toggle("Add extra frosting", isOn: $order.orders.extraFrosting)
                        Toggle("Add extra sprinkles", isOn: $order.orders.addSprinkles)
                    }
                }
                
                Section {
                    NavigationLink {
                        AddressView(order: order)
                    } label: {
                        Text("Delivery Details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
