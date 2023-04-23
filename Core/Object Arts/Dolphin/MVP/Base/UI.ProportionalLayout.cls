"Filed out from Dolphin Smalltalk"!

UI.LinearLayout
	subclass: #'UI.ProportionalLayout'
	instanceVariableNames: 'proportions isVertical'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ProportionalLayout guid: (Core.GUID fromString: '{87b4c64b-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ProportionalLayout comment: 'ProportionalLayout implements a general purpose <layoutManager> to layout <view> objects within a <compositeView>. The managed views are arranged either vertically or horizontally depending on the setting of the <boolean> #isVertical aspect. The layout manager attempts to keep the relative sizes of the views in proportion according to the arrangement aspects of each view, which must be <number>s. Any view with an arrangement of 0 will be left at its original size. Managed views that are not currently visible are ignored, in which case they are allocated no proportion of the available space.

For example. You have four views in a container managed by a ProportionalLayout; each has an arrangement of 2, 0, 5, 3 respectively. The second view will always keep its current size. The remainder of the space available in the container will be split between the remaining views in the ratios 2:5:3. 

Views can also dynamically control whether they are resized in horizontal or vertical dimensions by implementing the #hasFixedWidth and #hasFixedHeight messages. By default all views are resizable in both dimensions.

A ProportionalLayout is commonly used in conjunction with one or more <Splitter>s. In the standard ClassBrowserShell default view you can see two ProportionalLayout managers at work; one separating the panes horizontally and one vertically. Each of the panes is separated by a Splitter which, when moved, can be used to adjust the proportions of the views on either side of it. Note that Splitters are always given an arrangement of 0 so they are not resized by the layout manager and can remain at their preferred width/height.

Instance Variables:
	proportions		<LookupTable>
	isVertical		<boolean>

'!
!UI.ProportionalLayout categoriesForClass!MVP-Layout Managers-General! !
!UI.ProportionalLayout methodsFor!

arrangementOf: aView 
	"Answer a <Number> representing the current proportion for aView. Answer the default if a
	specific value has not been set. The proportion is used to size the views relative to the
	others managed by the receiver. A value of zero indicates a fixed size view."

	^self proportions at: aView ifAbsent: [aView defaultProportion]!

arrangementOf: aView put: aNumber 
	"Set the arrangement parameter of aView in the receiver to be anObject"

	self proportions at: aView put: aNumber abs!

hasFixedSize: aView
	^(self arrangementOf: aView) isZero 
		or: [self isVertical ifTrue: [aView hasFixedHeight] ifFalse: [aView hasFixedWidth]]!

hideShowSplitters: aCompositeView context: aLayoutContext
	"Private - Show only those splitters that have at least one resiable view on either side
	before the next splitter on that side. This should be the minimal set of splitters that
	allows for adjustment of the resizable panes, and no more."

	"Implementation Note: The algorithm is to run from left to right (or top to bottom) hiding
	all splitters that do not follow at least one visible resizable view since the preceeding
	visible splitter.The direction is reversed, and any splitters that are still visible that do
	not have a succeeding visible resizable view since the last splitter are also hidden."

	| resizable managed count |
	resizable := false.
	managed := aCompositeView managedSubViews.
	count := managed size.
	1 to: count
		do: 
			[:i |
			| each |
			each := managed at: i.
			each isSplitter
				ifTrue: 
					[resizable
						ifTrue: 
							[aLayoutContext showView: each.
							resizable := false]
						ifFalse: [aLayoutContext hideView: each]]
				ifFalse: 
					[((aLayoutContext isViewVisible: each) and: [(self hasFixedSize: each) not])
						ifTrue: [resizable := true]]].
	resizable := false.
	count to: 1
		by: -1
		do: 
			[:i |
			| each |
			each := managed at: i.
			(aLayoutContext isViewVisible: each)
				ifTrue: 
					[each isSplitter
						ifTrue: 
							[resizable
								ifTrue: 
									[aLayoutContext showView: each.
									resizable := false]
								ifFalse: [aLayoutContext hideView: each]]
						ifFalse: [(self hasFixedSize: each) not ifTrue: [resizable := true]]]]!

initialize
	super initialize.
	proportions := LookupTable new!

isVertical
	"Answer whether the receiver's components are positioned vertically."

	^isVertical!

isVertical: aBoolean
	"Set whether the view's managed by the receiver are layed out vertically or horizontally."

	isVertical := aBoolean!

layoutContainer: aCompositeView context: aLayoutContext
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of the
	specified container view, laying out those sub-views according to the rules and
	configuration of this particular layout manager."

	| extent majorExtent minorExtent offset freeSize totalProportions fixedSize insets subViews count |
	insets := aCompositeView actualInsets: aLayoutContext.
	extent := ((aLayoutContext clientRectangleOf: aCompositeView) insetBy: insets) extent.
	self isVertical
		ifTrue: 
			[majorExtent := extent y.
			minorExtent := extent x]
		ifFalse: 
			[majorExtent := extent x.
			minorExtent := extent y].
	self hideShowSplitters: aCompositeView context: aLayoutContext.
	subViews := (self visibleSubViewsOf: aCompositeView context: aLayoutContext) asArray.
	fixedSize := 0.
	totalProportions := 0.
	count := subViews size.
	1 to: count
		do: 
			[:i |
			| each |
			each := subViews at: i.
			(self hasFixedSize: each)
				ifTrue: [fixedSize := fixedSize + (self majorDimensionOf: (each layoutExtent: aLayoutContext))]
				ifFalse: [totalProportions := totalProportions + (self arrangementOf: each)]].
	freeSize := majorExtent - fixedSize max: 0.
	offset := insets origin.
	1 to: count
		do: 
			[:index |
			| each viewMajorExtent |
			each := subViews at: index.
			viewMajorExtent := (self hasFixedSize: each)
						ifTrue: [self majorDimensionOf: (each layoutExtent: aLayoutContext)]
						ifFalse: 
							[index = count
								ifTrue: [majorExtent + (self majorDimensionOf: insets origin) - (self majorDimensionOf: offset)]
								ifFalse: [((self arrangementOf: each) / totalProportions * freeSize) truncated]].
			aLayoutContext setView: each
				rectangle: (offset extent: (self pointWithMajor: viewMajorExtent minor: minorExtent)).
			offset := offset + (self pointWithMajor: viewMajorExtent minor: 0)]!

nearestResizableViewFrom: fromView inViews: views by: direction 
	"Private - Answer the first view in a direction from fromView which is resizable (i.e.
	visible and not of fixed size) or nil if there aren't any."

	| index |
	index := views identityIndexOf: fromView.
	
	[index := index + direction.
	index between: 1 and: views size] whileTrue: 
				[| aView |
				aView := views at: index.
				(self hasFixedSize: aView) ifFalse: [^aView]].
	^nil!

proportions
	"Private - Answer a <dictionary> of <View>s to the proportion number.
	Use a proportion number of 0 to indicate a view of fixed size."

	^proportions!

removeSubView: aView
	"Remove view from the collection of views which have been explicitly
	arranged by the receiver.
	Answer view."

	self proportions removeKey: aView ifAbsent: nil.
	^super removeSubView: aView!

reposition: aView to: aPoint
	"Private - This will expand/shrink the proportions of the two non fixed size views on either
	side of aView."

	| subviews currentPoint prevView nextView totalProportion changeSize prevSize nextSize containerView |
	containerView := aView parentView.
	subviews := containerView managedSubViews select: [:each | each isWindowVisible].
	currentPoint := aView position.
	prevView := self
				nearestResizableViewFrom: aView
				inViews: subviews
				by: -1.
	nextView := self
				nearestResizableViewFrom: aView
				inViews: subviews
				by: 1.
	(prevView isNil or: [nextView isNil]) ifTrue: [^self].
	self isVertical
		ifTrue: 
			[prevSize := prevView extent y.
			nextSize := nextView extent y.
			changeSize := aPoint y - currentPoint y]
		ifFalse: 
			[prevSize := prevView extent x.
			nextSize := nextView extent x.
			changeSize := aPoint x - currentPoint x].
	changeSize := changeSize positive
				ifTrue: [changeSize min: nextSize - 2]
				ifFalse: [changeSize max: prevSize negated + 2].
	prevSize := prevSize + changeSize.
	nextSize := nextSize - changeSize.
	totalProportion := self totalProportionsOf: {prevView. nextView}.
	prevSize + nextSize = 0
		ifFalse: 
			[self arrangementOf: prevView put: prevSize / (prevSize + nextSize) * totalProportion.
			self arrangementOf: nextView put: nextSize / (prevSize + nextSize) * totalProportion].
	prevView basicInvalidateLayout.
	nextView basicInvalidateLayout!

totalProportionsOf: viewCollection
	"Private - Answer the sum of all the views proportions."

	^viewCollection inject: 0 into: [:total :aView |
			total + (self arrangementOf: aView)].
! !
!UI.ProportionalLayout categoriesForMethods!
arrangementOf:!accessing!public! !
arrangementOf:put:!accessing!public! !
hasFixedSize:!private!testing! !
hideShowSplitters:context:!helpers!private! !
initialize!initializing!private! !
isVertical!public!testing! !
isVertical:!accessing!public! !
layoutContainer:context:!helpers!private! !
nearestResizableViewFrom:inViews:by:!helpers!private! !
proportions!accessing!private! !
removeSubView:!public!removing! !
reposition:to:!operations!private! !
totalProportionsOf:!helpers!private! !
!

