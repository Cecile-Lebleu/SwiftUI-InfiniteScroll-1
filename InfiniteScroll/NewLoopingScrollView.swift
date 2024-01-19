//
//  NewLoopingScrollView.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 4/1/24.
//

import SwiftUI

// Goal: Make it work with VStacks of clusters as children

struct Tile: Identifiable {
	var id: UUID = .init()
	var name: String
}

struct NewLoopingScrollView: View {
	let clusters = [
		// Let's pretend that each string below is a cluster
		["A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10"],
		["B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10"],
		["C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10"],
		["D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10"],
		["E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10"],
	]
	var body: some View {
		VStack {
			LoopingClusterView {
				Text(clusters[0][0])
			}
		}
	}
}

struct LoopingClusterView<Content: View>: View {
	@ViewBuilder var content: Content
	var body: some View {
		Text("LoopingClusterView")
		content
	}
}

#Preview {
	NewLoopingScrollView()
}
