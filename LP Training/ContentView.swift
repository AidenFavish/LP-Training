//
//  ContentView.swift
//  LP Training
//
//  Created by Aiden Favish on 12/7/23.
//

import SwiftUI

enum selectorFocus {
    case CENTER, RADIUS, TURN
}

struct ContentView: View {
    var img: NSImage = NSImage(contentsOfFile: "/Users/aidenfavish/Downloads/carl.png")!
    @State var center = (-1, -1)
    @State var radius = -1
    @State var turn = 0.0
    @State var focus: selectorFocus = selectorFocus.CENTER
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                Label("Center", systemImage: "1.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title)
                    .bold(focus == selectorFocus.CENTER)
                Text(center.0 == -1 ? "X: --     Y: --" : "x: \(center.0)     Y: \(center.1)")
                    .foregroundStyle(.blue)
                    .padding(.bottom)
                    .font(.title3)
                
                
                Label("Radius", systemImage: "2.circle.fill")
                    .foregroundStyle(radius == -1 ? .gray : .blue)
                    .font(.title)
                    .bold(focus == selectorFocus.RADIUS)
                Text(radius == -1 ? "R: --" : "r: \(radius)")
                    .foregroundStyle(radius == -1 ? .gray : .blue)
                    .padding(.bottom)
                    .font(.title3)
                
                
                
                Label("Turn", systemImage: "3.circle.fill")
                    .foregroundStyle(focus != selectorFocus.TURN ? .gray : .blue)
                    .font(.title)
                    .bold(focus == selectorFocus.TURN)
                Slider(value: $turn, in: -45...45)
                    .frame(width: 200)
                    .disabled(focus != selectorFocus.TURN)
                Text(focus != selectorFocus.TURN ? "T: --" : "turn: \(turn)")
                    .foregroundStyle(focus != selectorFocus.TURN ? .gray : .blue)
                    .font(.title3)
                Spacer()
                
                Text("File: \(0)")
                    .font(.title3)
                    .foregroundStyle(.primary)
                Text("Timestamp: \(0)")
                    .font(.title3)
                    .foregroundStyle(.primary)
                Spacer()
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text(" Back")
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(Color(NSColor(calibratedRed: 0.25, green: 0.25, blue: 0.25, alpha: 1)))
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Button(action: {
                        
                    }, label: {
                        Text(" Next")
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                            
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    
                }
                
                
                
                
            }
            .padding()
            
            Spacer()
            
            GeometryReader { geo in
                Image(nsImage: img)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onTapGesture { click in
                        if focus == .CENTER {
                            center = (Int(click.x / (geo.size.width - 30) * 2160), Int(click.y / (geo.size.height - 30) * 2160))
                            focus = .RADIUS
                        } else if focus == selectorFocus.RADIUS {
                            radius = Int(sqrt(pow(CGFloat(center.0) - click.x / (geo.size.width - 30) * 2160, 2) + pow(CGFloat(center.1) - click.x / (geo.size.width - 30) * 2160, 2)))
                            focus = .TURN
                        }
                        
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .onHover(perform: { hovering in
                        if hovering && true {
                            NSCursor.crosshair.push()
                        } else {
                            NSCursor.pop()
                        }
                    })
                    .padding(15)
            }.background(Color.clear)
            .aspectRatio(contentMode: .fit)
            
        }
    }
}

#Preview {
    ContentView()
}


