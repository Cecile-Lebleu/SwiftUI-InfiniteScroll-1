//
//  InfiniteHorizontalZoomView.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 3/1/24.
//

import SwiftUI

struct InfiniteHorizontalZoomView: View {
	var body: some View {
		Magic {
			insideView
				.float(insideView, alignment: .trailing)
				.float(insideView, alignment: .leading)
		}
	}
	
	var insideView: some View {
		HStack(alignment: .center) {
			ForEach(0..<50) { index in
				Text("\(index)")
			}
			Image("photo")
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
		}
	}
}

struct Magic<Content: View>: UIViewRepresentable {
	private var content: Content
	
	@State private var scale: CGFloat = 1.0
	
	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	func makeUIView(context: Context) -> InfiniteScrollViewRendererH {
		// Create UIHostingController
		let hostedView = context.coordinator.hostingController.view!
		hostedView.translatesAutoresizingMaskIntoConstraints = true
		hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		hostedView.frame.size.height = hostedView.intrinsicContentSize.height
		hostedView.frame.size.width = hostedView.intrinsicContentSize.width
		hostedView.frame.origin.x = 0

		// Set up the ScrollView
		let scrollView = InfiniteScrollViewRendererH()
		scrollView.delegate = context.coordinator // for viewForZooming(in:)
		scrollView.maximumZoomScale = maxAllowedScale
		scrollView.minimumZoomScale = 1
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bouncesZoom = true
				
		scrollView.addSubview(hostedView)
		
		scrollView.contentSize.height = hostedView.intrinsicContentSize.height
		scrollView.contentSize.width = hostedView.intrinsicContentSize.width * 2

		scrollView.contentOffset.x = 0

		return scrollView
	}
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(
			hostingController: UIHostingController(rootView: self.content)
		)
	}

	func updateUIView(_ uiView: InfiniteScrollViewRendererH, context: Context) {
//		let tiledContent: Content = self.content
//			.float(content, alignment: .trailing)
//			.float(content, alignment: .leading)
		context.coordinator.hostingController.rootView = self.content
		uiView.zoomScale = scale
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var hostingController: UIHostingController<Content>
		
		init(hostingController: UIHostingController<Content>) {
			self.hostingController = hostingController
		}
		
		func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			return hostingController.view
		}
	}
}

#Preview {
	InfiniteHorizontalZoomView()
}
