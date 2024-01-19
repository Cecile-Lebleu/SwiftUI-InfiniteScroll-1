//
//  LoopingScrollView.swift
//  InfiniteScroll
//
//  Created by Cécile Lebleu on 3/1/24.
//

import SwiftUI

struct Item: Identifiable {
	var id: UUID = .init()
	var color: Color
}

struct Content: View {
//	@State private var items: [Item] = [.red, .blue, .green, .yellow, .black]
	@State private var items: [Item] = [.red]
		.compactMap { return .init(color: $0) }
	
	var body: some View {
			VStack {
				LoopingScrollView(width: 2500, spacing: 10, items: items) { item in
					RoundedRectangle(cornerRadius: 15)
						.fill(item.color.gradient)
				}
				.contentMargins(.horizontal, 15, for: .scrollContent)
			}
			.frame(height: 500)
			.padding(.vertical, 15)
		.scrollIndicators(.hidden)
	}
}

struct LoopingScrollView<Content: View, Item: RandomAccessCollection>: View where Item.Element: Identifiable {
	var width: CGFloat
	var spacing: CGFloat = 0
	var items: Item
	@ViewBuilder var content: (Item.Element) -> Content
	
    var body: some View {
		GeometryReader {
			let size = $0.size
			let repeatingCount = width > 0 ? Int((size.width / width).rounded()) + 1 : 1
			
			ScrollView(.horizontal) {
				LazyHStack(spacing: spacing) {
					ForEach(items) { item in
						content(item)
							.frame(width: width)
					}
					
					ForEach(0..<repeatingCount, id: \.self) { index in
						let item = Array(items)[index % items.count]
						
						content(item)
							.frame(width: width)
					}
				}
				.background {
					ScrollViewHelper1(
						width: width,
						spacing: spacing,
						itemsCount: items.count,
						repeatingCount: repeatingCount
					)
				}
			}
		}
    }
}

struct ScrollViewHelper1: UIViewRepresentable {
	var width: CGFloat
	var spacing: CGFloat
	var itemsCount: Int
	var repeatingCount: Int
	
	func makeCoordinator() -> Coordinator {
		return Coordinator(
			width: width,
			spacing: spacing,
			itemsCount: itemsCount,
			repeatingCount: repeatingCount
		)
	}
	
	func makeUIView(context: Context) -> some UIView {
		return .init()
	}
	
//	func updateUIView(_ uiView: UIScrollView, context: Context) {
//		// update the hosting controller's SwiftUI content
//		context.coordinator.hostingController.rootView = self.content
//		uiView.zoomScale = scale
//		// IDK what this line does
////		assert(context.coordinator.hostingController.view.superview == uiView)
//	}
	
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
		var spacing: CGFloat
		var itemsCount: Int
		var repeatingCount: Int
		
		init(width: CGFloat, spacing: CGFloat, itemsCount: Int, repeatingCount: Int) {
			self.width = width
			self.spacing = spacing
			self.itemsCount = itemsCount
			self.repeatingCount = repeatingCount
		}
		
		var isAdded: Bool = false
		
		func scrollViewDidScroll(_ scrollView: UIScrollView) {
			let minX = scrollView.contentOffset.x
			let mainContentSize = CGFloat(itemsCount) * width
			let spacingSize = CGFloat(itemsCount) * spacing
			
			if minX > (mainContentSize + spacingSize) {
				scrollView.contentOffset.x -= (mainContentSize + spacingSize)
			}
			
			if minX < 0 {
				scrollView.contentOffset.x += (mainContentSize + spacingSize)
			}
		}
	}
}

#Preview {
    Content()
}
