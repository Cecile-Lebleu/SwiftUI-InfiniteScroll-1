//
//  Newnew.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 4/1/24.
//

import SwiftUI

struct ClusterGroup: Identifiable {
	var id: UUID = .init()
	var index: Int
}

struct TestText: View {
	@State private var tapped = false
	
	var body: some View {
		Text("Hello")
			.padding()
			.onTapGesture {
				tapped.toggle()
			}
			.font(.largeTitle)
			.background(tapped ? .teal : .yellow)
	}
}

struct Newnew: View {
	@State private var clusterGroups: [ClusterGroup] = [0]
		.compactMap { return .init(index: $0) }
	
    var body: some View {
		Newnewnew(width: 600, clusterGroups: clusterGroups) { _ in
			TestText()
		}
    }
}

struct Newnewnew<Content: View, ClusterGroup: RandomAccessCollection>: View where ClusterGroup.Element: Identifiable {
	
	var width: CGFloat
	var clusterGroups: ClusterGroup
	@ViewBuilder var content: (ClusterGroup.Element) -> Content
	
	var body: some View {
		GeometryReader {
			let size = $0.size
			let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
			
			ScrollView(.horizontal) {
				LazyHStack(spacing: 0) {
					ForEach(clusterGroups) { clusterGroup in
						content(clusterGroup)
							.frame(width: width)
							.border(.black)
					}
					
					ForEach(0..<repeatingCount, id: \.self) { index in
						let clusterGroup = Array(clusterGroups)[index % clusterGroups.count]
						
						content(clusterGroup)
							.frame(width: width)
							.border(.black)
					}
				}
				.background {
					ScrollViewHelper1(
						width: width, spacing: 0,
						itemsCount: clusterGroups.count,
						repeatingCount: repeatingCount
					)
				}
			}
		}
	}
}

#Preview {
    Newnew()
}
