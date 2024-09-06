//
//  CustomPicker.swift
//  coristronk
//
//  Created by Matran Bogdan on 06.09.2024.
//

import SwiftUI

/// This SegmentedPicker will take some Equatable array(Int, String, etc.)
public struct SegmentedPicker<T: Equatable, Content: View>: View {
    // Tells SwiftUI which views can be animated together
    @Namespace private var selectionAnimation
    /// The currently selected item, if there is one
    @Binding var selectedItem: T?
    /// The list of options available in this picker
    private let items: [T]
    /// The View that takes in one of the elements from the items array to display an item
    private let content: (T) -> Content

    /// Create a new Segmented Picker
    /// - Parameters:
    ///     - selectedItem: The currently selected item, optional
    ///     - items: The list of items to display as options, can be any Equatable type such as String, Int, etc.
    ///     - content: The View to display for elements of the items array
    public init(_ items: [T],
            selectedItem: Binding<T?>,
            @ViewBuilder content: @escaping (T) -> Content) {
        self._selectedItem = selectedItem
        self.items = items
        self.content = content
    }
    
    // @ViewBuilder is a great way to conditionally show Views
    //   but makes the highlight overlay into "different" Views to the View Layout System
    @ViewBuilder func overlay(for item: T) -> some View {
        if item == selectedItem {
            /// This could be changed to be passed in if you want
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.gray.opacity(0.4))
                // This is the magic for the animation effect when the selection changes
                //  it associates this View with the new View created over a newly selected item  and
                //  it allows SwiftUI to animate it moving to the newly selected View
                .matchedGeometryEffect(id: "selectedSegmentHighlight", in: self.selectionAnimation)
        }
    }

    public var body: some View {
        /// Horizontal is optional, could be vertical
        HStack {
            /// Iterate over the indices because it's easier, also requires ` id: \.self`, compiler might give misleading error if not
            ForEach(self.items.indices, id: \.self) { index in
                // For each selectable option in the items array
                Button(action: {
                    /// This works with `matchedGeometryEffect` on the selected overlay View
                    withAnimation(.linear) {
                        self.selectedItem = self.items[index]
                    }
                },
                       label: { self.content(self.items[index]) })
                    .contentShape(Rectangle())
                    // If nothing is selected there will be no selected item overlay thanks for @ViewBuilder
                    // This is where the selected overlay is applied to the Picker Segments
                    .overlay(self.overlay(for: self.items[index]))
            }
        }
    }
}
