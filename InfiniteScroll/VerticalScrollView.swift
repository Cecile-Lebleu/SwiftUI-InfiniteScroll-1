//
//  ContentView.swift
//  InfiniteScroll
//
//  Created by Damiaan on 17/07/2021.
//

import SwiftUI

struct VerticalScrollView: View {
	var body: some View {
		InfiniteVerticalScrollView(content: longList)
	}

	var longList: some View {
		VStack(alignment: .leading) {
			ForEach(0..<50) { index in
				Text("Item \(index)")
			}
		}
	}
}

struct InfiniteVerticalScrollView<Content: View>: UIViewRepresentable {
	let content: Content

	func makeUIView(context: Context) -> InfiniteScrollViewRendererV {
		let contentWidth = CGFloat(100)
		let tiledContent = content
			.float(content, alignment: .top)
			.float(content, alignment: .bottom)
		let contentController = UIHostingController(rootView: tiledContent)
		let contentView = contentController.view!
		contentView.frame.size.height = contentView.intrinsicContentSize.height
		contentView.frame.size.width = contentWidth
		contentView.frame.origin.y = 100

		let scrollview = InfiniteScrollViewRendererV()
		scrollview.addSubview(contentView)
		scrollview.contentSize.height = contentView.intrinsicContentSize.height * 2
		scrollview.contentSize.width = contentWidth

		scrollview.contentOffset.y = 100

		return scrollview
	}

	func updateUIView(_ uiView: InfiniteScrollViewRendererV, context: Context) {}
}

class InfiniteScrollViewRendererV: UIScrollView {
	override func layoutSubviews() {
		super.layoutSubviews()

		let halfSize = contentSize.height / 2

		if contentOffset.y < 100 {
			contentOffset.y += halfSize
		} else if contentOffset.y > halfSize + 100 {
			contentOffset.y -= halfSize
		}
	}
}

#Preview {
	VerticalScrollView()
}
