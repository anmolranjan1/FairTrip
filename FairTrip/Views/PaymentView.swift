//
//  PaymentView.swift
//  FairTrip
//
//  Created by Anmol Ranjan on 20/10/24.
//

import SwiftUI

struct PaymentView: View {
    @ObservedObject var viewModel: RideViewModel
    
    var body: some View {
        VStack {
            Text("Payment")
                .font(.largeTitle)
                .padding()
            
            Text("Fare: \(viewModel.fare, specifier: "%.2f")")
                .font(.title2)
                .padding()

            Button(action: {
                // Handle payment logic here
            }) {
                Text("Confirm Payment")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
    }
}

