//
//  SwiftUILoopScroll.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 3/1/24.
// Not working

import SwiftUI

struct SwiftUILoopScroll: View {
	var body: some View {
		LoopyLoop(width: 50*50) {
			HStack {
				ForEach(0..<50) { index in
					Text("\(index)")
						.frame(width: 50)
				}
			}
		}
	}
}

struct LoopyLoop<Content: View>: View {
	var width: CGFloat
	
	@ViewBuilder let content: Content
	
	var body: some View {
		ScrollView(.horizontal) {
			LazyHStack(spacing: 0) {
				content
				content
			}
			.background {
				ScrollViewHelper(
					width: width
				)
			}
		}
	}
}

struct ScrollViewHelper: UIViewRepresentable {
	var width: CGFloat
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(
			width: width
		)
	}
	
	func makeUIView(context: Context) -> some UIView {
		return .init()
	}
	
	func updateUIView(_ uiView: UIViewType, context: Context) {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.06) {
			if let scrollView = uiView.superview?.superview?.superview as? UIScrollView, !context.coordinator.isAdded {
				scrollView.delegate = context.coordinator
				context.coordinator.isAdded = true
			}
		}
	}
	
	class Coordinator: NSObject, UIScrollViewDelegate {
		var width: CGFloat
		
		init(width: CGFloat) {
			self.width = width
		}
		
		var isAdded: Bool = false
		
		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let minX = scrollView.contentOffset.x
			
			if minX > (width) {
				scrollView.contentOffset.x -= width
			}
			
			if minX < 0 {
				scrollView.contentOffset.x += width
			}
		}
	}
}


#Preview {
	SwiftUILoopScroll()
}
