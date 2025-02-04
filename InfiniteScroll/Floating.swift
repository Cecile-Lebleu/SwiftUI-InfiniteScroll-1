//
//  Floating.swift
//  DateTest
//
//  Created by Damiaan on 19/07/2020.
//

import SwiftUI

extension View {
	func float<Content: View>(_ content: Content, alignment: Opposable<HorizontalAlignment>) -> some View {
		overlay(
			content.alignmentGuide(alignment.content) { $0[alignment.opposite] },
			alignment: .init(horizontal: alignment.content, vertical: .center)
		)
	}
}

extension View {
	func float<Content: View>(_ content: Content, alignment: Opposable<VerticalAlignment>) -> some View {
		overlay(
			content.alignmentGuide(alignment.content) { $0[alignment.opposite] },
			alignment: .init(horizontal: .center, vertical: alignment.content)
		)
	}
}

struct Opposable<Content> {
	let content: Content
	let opposite: Content
	init(_ value: Content, opposite oppositeValue: Content) { (content, opposite) = (value, oppositeValue) }
}

extension Opposable where Content == VerticalAlignment {
	static let top = Opposable(.top, opposite: .bottom)
	static let bottom = Opposable(.bottom, opposite: .top)
}

extension Opposable where Content == HorizontalAlignment {
	static let leading = Opposable(.leading, opposite: .trailing)
	static let trailing = Opposable(.trailing, opposite: .leading)
}

struct Floating_Previews: PreviewProvider {
	static var previews: some View {
		VStack {
			Spacer()
			
			HStack {
				Text("Block 1").float(TextBox(content: "This floats above 1"), alignment: .top)
				Divider()
				Text("Block 2")
				Divider()
				Text("Block 3").float(TextBox(content: "This floats below 3"), alignment: .bottom)
			}.fixedSize()
			
			Spacer()
			
			VStack {
				Text("Block 1").float(TextBox(content: "This floats before 1"), alignment: .leading)
				Divider()
				Text("Block 2")
				Divider()
				Text("Block 3").float(TextBox(content: "This floats after 3"), alignment: .trailing)
			}.fixedSize()
			
			Spacer()
		}
	}

	struct TextBox: View {
		let content: String

		var body: some View {
			Text(content)
				.padding(3)
				.background(Color.gray.opacity(0.6))
				.cornerRadius(3)
				.frame(width: 100)
				.fixedSize()
				.foregroundColor(.white)
				.padding()
		}
	}
}
