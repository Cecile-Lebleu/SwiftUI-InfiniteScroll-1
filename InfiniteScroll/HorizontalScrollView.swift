//
//  ContentView.swift
//  InfiniteScroll
//
//  Created by Damiaan on 17/07/2021.
//

import SwiftUI

struct HorizontalScrollView: View {
	var body: some View {
		InfiniteHorizontalScrollView {
			insideView
		}
	}
	
	var insideView: some View {
		HStack(alignment: .center, spacing: 0) {
			ForEach(0..<50) { index in
				Text("\(index)")
					.font(.largeTitle)
					.padding()
			}
		}
	}
}

struct InfiniteHorizontalScrollView<Content: View>: UIViewRepresentable {
	private var content: Content
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	func makeUIView(context: Context) -> InfiniteScrollViewRendererH {
		let contentHeight = CGFloat(100)
		let tiledContent = content
			.float(content, alignment: .leading)
			.float(content, alignment: .trailing)
		let contentController = UIHostingController(rootView: tiledContent)
		let hostedView = contentController.view!
		hostedView.frame.size.width = hostedView.intrinsicContentSize.width
		hostedView.frame.size.height = contentHeight
		hostedView.frame.origin.x = 0
		
		// Set up the ScrollView
		let scrollview = InfiniteScrollViewRendererH()
		scrollview.addSubview(hostedView)
		scrollview.contentSize.height = contentHeight
		scrollview.contentSize.width = hostedView.intrinsicContentSize.width * 2

		scrollview.contentOffset.x = 0

		return scrollview
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(
			hostingController: UIHostingController(rootView: self.content)
		)
	}

	func updateUIView(_ uiView: InfiniteScrollViewRendererH, context: Context) {
		context.coordinator.hostingController.rootView = self.content
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var hostingController: UIHostingController<Content>
		
		init(hostingController: UIHostingController<Content>) {
			self.hostingController = hostingController
		}
	}
}

class InfiniteScrollViewRendererH: UIScrollView {
	override func layoutSubviews() {
		super.layoutSubviews()

		let halfSize = contentSize.width / 2

		if contentOffset.x < 100 {
			contentOffset.x += halfSize
		} else if contentOffset.x > halfSize + 100 {
			contentOffset.x -= halfSize
		}
	}
}

#Preview {
	HorizontalScrollView()
}
