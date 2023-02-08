//
//  GraphingView.swift
//  ACELM
//
//  Created by Will Wallace on 10/25/22.
//

import SwiftUI
//import SwiftCharts


struct GraphingView: View {
    let data: [(Double, Double)] = [(0, 0), (0.25, 0.5), (0.5, 0.8), (0.75, 0.3), (1, 0)]

        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color(.lightGray))
                    .frame(width: 250, height: 200)
                    .cornerRadius(10)
                    .shadow(radius: 10)
                
                GeometryReader { geometry in
                    Path { path in
                        let width = min(geometry.size.width, geometry.size.height)
                        let height = width
                        let middle = height / 2
                        path.move(to: CGPoint(x: 0, y: middle))
                        for (x, y) in self.data {
                            path.addLine(to: CGPoint(x: x * width, y: middle - y * height))
                        }
                    }
                    .stroke(Color.blue, lineWidth: 2)
                }
                .frame(width: 250, height: 200, alignment: .center)
                .aspectRatio(1, contentMode: .fit)
            }
        }
}

struct GraphingView_Previews: PreviewProvider {
    static var previews: some View {
        GraphingView()
    }
}
