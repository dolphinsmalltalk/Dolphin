"Filed out from Dolphin Smalltalk"!

UI.Tests.LayoutManagerTest
	subclass: #'UI.Tests.FramingLayoutTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.FramingLayoutTest guid: (Core.GUID fromString: '{fa16fdd5-bd9e-4198-bc61-f33e43c14edc}')!

UI.Tests.FramingLayoutTest comment: ''!

!UI.Tests.FramingLayoutTest methodsFor!

layoutManagerClass
	^FramingLayout!

testCircularEdgeConstraint
	| button |
	shell insets: (5 @ 10 corner: 15 @ 20).
	button := shell addSubView: PushButton new.
	"#2028 - Check can't make silly choice"
	self should: [button arrangement leftFraming: #fixedViewLeft] raise: Error.
	self should: [button arrangement rightFraming: #fixedViewRight] raise: Error.
	self should: [button arrangement topFraming: #fixedViewTop] raise: Error.
	self should: [button arrangement bottomFraming: #fixedViewBottom] raise: Error!

testFramingCalculationSerialisation
	| proxyFormatArray proxyFormatBytes |
	proxyFormatArray := #(#'!!STL' 3 202 208 98 16 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(UI.FramingCalculation) 8 #centerRelativeParentHeight 442 464 8 #centerRelativeParentWidth 442 464 8 #fixedParentBottom 442 464 8 #fixedParentLeft 442 464 8 #fixedParentRight 442 464 8 #fixedParentTop 442 464 8 #fixedPreviousBottom 442 464 8 #fixedPreviousLeft 442 464 8 #fixedPreviousRight 442 464 8 #fixedPreviousTop 442 464 8 #fixedViewBottom 442 464 8 #fixedViewLeft 442 464 8 #fixedViewRight 442 464 8 #fixedViewTop 442 464 8 #relativeParentHeight 442 464 8 #relativeParentWidth).
	self
		assert: ((Object fromLiteralStoreArray: proxyFormatArray) asIdentitySet
				- FramingCalculation allCalculations) isEmpty.
	proxyFormatArray := FramingCalculation allCalculations literalStoreArray.
	self
		assert: ((Object fromLiteralStoreArray: proxyFormatArray) asIdentitySet
				- FramingCalculation allCalculations) isEmpty.
	proxyFormatBytes := #[33 83 84 66 32 51 32 202 0 0 0 208 0 0 0 98 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 154 0 0 0 82 0 0 0 16 0 0 0 68 111 108 112 104 105 110 32 77 86 80 32 66 97 115 101 82 0 0 0 18 0 0 0 70 114 97 109 105 110 103 67 97 108 99 117 108 97 116 105 111 110 178 0 0 0 26 0 0 0 99 101 110 116 101 114 82 101 108 97 116 105 118 101 80 97 114 101 110 116 72 101 105 103 104 116 186 1 0 0 208 1 0 0 178 0 0 0 25 0 0 0 99 101 110 116 101 114 82 101 108 97 116 105 118 101 80 97 114 101 110 116 87 105 100 116 104 186 1 0 0 208 1 0 0 178 0 0 0 17 0 0 0 102 105 120 101 100 80 97 114 101 110 116 66 111 116 116 111 109 186 1 0 0 208 1 0 0 178 0 0 0 15 0 0 0 102 105 120 101 100 80 97 114 101 110 116 76 101 102 116 186 1 0 0 208 1 0 0 178 0 0 0 16 0 0 0 102 105 120 101 100 80 97 114 101 110 116 82 105 103 104 116 186 1 0 0 208 1 0 0 178 0 0 0 14 0 0 0 102 105 120 101 100 80 97 114 101 110 116 84 111 112 186 1 0 0 208 1 0 0 178 0 0 0 19 0 0 0 102 105 120 101 100 80 114 101 118 105 111 117 115 66 111 116 116 111 109 186 1 0 0 208 1 0 0 178 0 0 0 17 0 0 0 102 105 120 101 100 80 114 101 118 105 111 117 115 76 101 102 116 186 1 0 0 208 1 0 0 178 0 0 0 18 0 0 0 102 105 120 101 100 80 114 101 118 105 111 117 115 82 105 103 104 116 186 1 0 0 208 1 0 0 178 0 0 0 16 0 0 0 102 105 120 101 100 80 114 101 118 105 111 117 115 84 111 112 186 1 0 0 208 1 0 0 178 0 0 0 15 0 0 0 102 105 120 101 100 86 105 101 119 66 111 116 116 111 109 186 1 0 0 208 1 0 0 178 0 0 0 13 0 0 0 102 105 120 101 100 86 105 101 119 76 101 102 116 186 1 0 0 208 1 0 0 178 0 0 0 14 0 0 0 102 105 120 101 100 86 105 101 119 82 105 103 104 116 186 1 0 0 208 1 0 0 178 0 0 0 12 0 0 0 102 105 120 101 100 86 105 101 119 84 111 112 186 1 0 0 208 1 0 0 178 0 0 0 20 0 0 0 114 101 108 97 116 105 118 101 80 97 114 101 110 116 72 101 105 103 104 116 186 1 0 0 208 1 0 0 178 0 0 0 19 0 0 0 114 101 108 97 116 105 118 101 80 97 114 101 110 116 87 105 100 116 104].
	self
		assert: ((Object fromBinaryStoreBytes: proxyFormatBytes) asIdentitySet
				- FramingCalculation allCalculations) isEmpty.
	proxyFormatBytes := FramingCalculation allCalculations binaryStoreBytes.
	self
		assert: ((Object fromBinaryStoreBytes: proxyFormatBytes) asIdentitySet
				- FramingCalculation allCalculations) isEmpty!

testResizeParentRelative
	| layout button rect offsets marginExtents |
	layout := shell layoutManager.
	shell insets: (5 @ 10 corner: 15 @ 20).
	button := shell addSubView: PushButton new.
	button arrangement
		leftFraming: #fixedParentLeft;
		rightFraming: #fixedParentRight;
		topFraming: #fixedParentTop;
		bottomFraming: #fixedParentBottom.
	shell extent: (shell calcExtentFromClientExtent: 300 @ 200).
	self assert: shell clientExtent equals: 300 @ 200.
	shell show.
	"Resize the button to check that the offset calculations are working correctly"
	rect := 5 @ 10 extent: shell clientExtent - shell insets origin - shell insets corner.
	layout resize: button to: rect.
	self assert: button rectangle equals: rect.
	offsets := button arrangement offsets.
	self assert: offsets equals: Rectangle new.
	"And again - this time the offsets are non-zero"
	rect := rect insetBy: 5.
	layout resize: button to: rect.
	self assert: button rectangle equals: rect.
	offsets := button arrangement offsets.
	self assert: offsets equals: (Rectangle new insetBy: 5).

	"Now resize the shell"
	shell extent: (shell calcExtentFromClientExtent: 400 @ 300).
	self assert: shell clientExtent equals: 400 @ 300.
	rect := (shell clientRectangle insetBy: shell insets) insetBy: 5.
	self assert: button rectangle equals: rect.
	self assert: offsets equals: (Rectangle new insetBy: 5).

	"Now increase the size of the insets"
	shell insets: (150 @ 110 corner: 165 @ 105).
	shell validateLayout.
	rect := (shell clientRectangle insetBy: shell insets) insetBy: 5.
	self assert: button rectangle equals: rect.
	offsets := button arrangement offsets.
	self assert: offsets equals: (Rectangle new insetBy: 5).

	"And reduce the size of the shell so that there is insufficient space to display the button"
	marginExtents := shell insets origin + shell insets corner + button arrangement offsets extent abs.
	shell extent: (shell calcExtentFromClientExtent: marginExtents).
	self assert: button rectangle extent isZero.
	"Allow just enough for the button to become visible (a 5x5 area is needed on XP)"
	marginExtents := shell insets origin + shell insets corner + button arrangement offsets extent abs
				+ 5.
	shell extent: (shell calcExtentFromClientExtent: marginExtents).
	self assert: button rectangle extent equals: 5 @ 5! !

!UI.Tests.FramingLayoutTest categoriesForMethods!
layoutManagerClass!private!unit tests! !
testCircularEdgeConstraint!public!unit tests! !
testFramingCalculationSerialisation!public!unit tests! !
testResizeParentRelative!public!unit tests! !
!

