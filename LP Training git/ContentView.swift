//
//  ContentView.swift
//  LP Training
//
//  Created by Aiden Favish on 12/7/23.
//

import SwiftUI



struct ContentView: View {
    @State var newDisplay = false
    @State var address: String = ""
    var body: some View {
        if address == "" {
            HStack {
                Spacer()
                VStack {
                    Spacer()
                    Text("License Plate\nData Cleaning")
                        .multilineTextAlignment(.center)
                        .font(.largeTitle)
                        .padding()
                    Spacer()
                    Button(action: {
                        newDisplay = true
                    }, label: {
                        Label("New", systemImage: "plus.circle.fill")
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.vertical, 7)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                }
                
                Spacer()
            }
            .sheet(isPresented: $newDisplay, content: {
                vidSetup(address: $address)
            })
        } else {
            LPTrainingEnv(address: address)
        }
    }
}

#Preview {
    ContentView()
}




