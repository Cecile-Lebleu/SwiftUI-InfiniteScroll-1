//
//  ZoomableViewq.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 2/1/24.
//https://stackoverflow.com/questions/74238414/is-there-an-easy-way-to-pinch-to-zoom-and-drag-any-view-in-swiftui

import SwiftUI

let maxAllowedScale = 4.0

struct ZoomableView: View {
	@State private var scale: CGFloat = 1.0
	
	var doubleTapGesture: some Gesture {
		TapGesture(count: 2).onEnded {
			if scale < maxAllowedScale / 2 {
				scale = maxAllowedScale
			} else {
				scale = 1.0
			}
		}
	}
	
	var body: some View {
			VStack(alignment: .center) {
				Spacer()
				ZoomableScrollView(scale: $scale) {
					insideView
				}
				.frame(width: 300, height: 300)
				.border(.black)
				.gesture(doubleTapGesture)
				Spacer()
				Text("Change the scale")
				Slider(value: $scale, in: 0.5...maxAllowedScale + 0.5)
				.padding(.horizontal)
				Spacer()
			}
	}
	
	var insideView: some View {
		HStack(alignment: .center, spacing: 0) {
			Image("photo")
				.resizable()
				.scaledToFit()
				.frame(width: 200, height: 200)
		}
	}
}

struct ZoomableScrollView<Content: View>: UIViewRepresentable {
	private var content: Content
	
	@Binding private var scale: CGFloat // I'll turn this into State instead of Binding

	init(scale: Binding<CGFloat>, @ViewBuilder content: () -> Content) {
		self._scale = scale // no need
		self.content = content()
	}

	func makeUIView(context: Context) -> UIScrollView {
		// Create a UIHostingController to hold our SwiftUI content
		let hostedView = context.coordinator.hostingController.view!
		hostedView.translatesAutoresizingMaskIntoConstraints = true
		hostedView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
		
		// set up the UIScrollView
		let scrollView = UIScrollView()
		scrollView.maximumZoomScale = maxAllowedScale
		scrollView.minimumZoomScale = 1
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bouncesZoom = true

		hostedView.frame = scrollView.bounds

		scrollView.delegate = context.coordinator  // for viewForZooming(in:)
		scrollView.addSubview(hostedView)

		return scrollView
	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(
			hostingController: UIHostingController(rootView: self.content),
			scale: $scale // no need .. right?
		)
	}

	func updateUIView(_ uiView: UIScrollView, context: Context) {
		// update the hosting controller's SwiftUI content
		context.coordinator.hostingController.rootView = self.content
		uiView.zoomScale = scale
		// IDK what this line does
//		assert(context.coordinator.hostingController.view.superview == uiView)
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var hostingController: UIHostingController<Content>
		@Binding var scale: CGFloat // no need.. right?

		init(
			hostingController: UIHostingController<Content>,
			scale: Binding<CGFloat> // no need, apparently
		) {
			self.hostingController = hostingController
			self._scale = scale
		}

		func viewForZooming(in scrollView: UIScrollView) -> UIView? {
			return hostingController.view
		}

		func scrollViewDidEndZooming(
			_ scrollView: UIScrollView,
			with view: UIView?,
			atScale scale: CGFloat
		) {
			self.scale = scale
		}
	}
}

#Preview {
    ZoomableView()
}
