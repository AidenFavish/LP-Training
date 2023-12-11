//
//  LPTrainingEnv.swift
//  LP Training
//
//  Created by Aiden Favish on 12/9/23.
//

import SwiftUI

enum selectorFocus {
    case CENTER, RADIUS, TURN
}

struct LPTrainingEnv: View {
    // Parameters
    @State var address: String
    
    // Local
    @State var center = (-1, -1)
    @State var radius = -1
    @State var turn = 0.0
    @State var focus: selectorFocus = selectorFocus.CENTER
    @State var frameNum = 0
    var body: some View {
        HStack {
            Spacer()
            
            VStack {
                Spacer()
                Label("Center", systemImage: "1.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.title)
                    .bold(focus == selectorFocus.CENTER)
                    .onTapGesture {
                        focus = .CENTER
                        center = (-1, -1)
                        radius = -1
                        turn = 0.0
                    }
                Text(center.0 == -1 ? "X: --     Y: --" : "x: \(center.0)     Y: \(center.1)")
                    .foregroundStyle(.blue)
                    .padding(.bottom)
                    .font(.title3)
                    
                
                
                Label("Radius", systemImage: "2.circle.fill")
                    .foregroundStyle(radius == -1 ? .gray : .blue)
                    .font(.title)
                    .bold(focus == selectorFocus.RADIUS)
                    .onTapGesture {
                        if focus == selectorFocus.TURN {
                            focus = .RADIUS
                            radius = -1
                            turn = 0.0
                        }
                    }
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
                
                Text("File: \(frameNum)")
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
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    Button(action: {
                        // Save
                        frameNum += 1
                    }, label: {
                        Text(" Next")
                            .font(.title3)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                    })
                    .buttonStyle(PlainButtonStyle())
                    .padding()
                    
                    
                }
                
                
                
                
            }
            .padding()
            
            Spacer()
            
            GeometryReader { geo in
                Image(nsImage: NSImage(contentsOfFile: address.replacingOccurrences(of: "%20", with: " ") + "frame\(frameNum).0.jpg")!)
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


