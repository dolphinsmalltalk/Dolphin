"Filed out from Dolphin Smalltalk 7"!

UI.LayoutManager subclass: #'UI.BorderLayout'
	instanceVariableNames: 'horizontalGap verticalGap north south east west center'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.BorderLayout guid: (Core.GUID fromString: '{87b4c646-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.BorderLayout comment: 'BorderLayout implements a general purpose <layoutManager> to layout <view> objects within a <compositeView>. It arranges views that have been added to their parent container with the #arrangement aspects #north, #south, #east, #west and #center. These identified views are "docked" along the appropriate edges and in the centre of the container. A BorderLayout attempts to keep the radial dimension of the edge components fixed at either their current size or (if specified) the preferred size, and then resizes the #center view to fill the remaining space.

BorderLayout is a very useful layout manager, and is commonly employed in conjunction with a shell to position a <Toolbar> to the north, a <Statusbar> to the south, and a composite view in the centre that contains the applicaiton views.

Instance Variables:
	horizontalGap	<integer> horizontal gap between adjacent views
	verticalGap		<integer> verticall gap between adjacent views
	north			<view> that will be positioned at the top of the container
	south			<view> that will be positioned at the bottom of the container
	east			<view> that will be positioned at the right of the container
	west			<view> that will be positioned at the left of the container
	center			<view> that will be positioned at the centre of the container
'!
!UI.BorderLayout categoriesForClass!MVP-Layout Managers-General! !
!UI.BorderLayout methodsFor!

arrangementOf: aView 
	"Answer the arrangement parameter of aView in the receiver. This will be one of #center,
	#east, #west, #north, #south or nil if no paramter has been set for aView"

	self center == aView ifTrue: [^#center].
	self west == aView ifTrue: [^#west].
	self east == aView ifTrue: [^#east].
	self north == aView ifTrue: [^#north].
	self south == aView ifTrue: [^#south].
	^nil!

arrangementOf: aView put: arrange 
	"Set the arrangement parameter of aView in the receiver to be anObject"

	self removeSubView: aView.
	arrange isNil ifTrue: [^aView].
	#todo.	"Refactor this to use a lookup table"
	arrange == #east 
		ifTrue: [self east: aView]
		ifFalse: 
			[arrange == #west 
				ifTrue: [self west: aView]
				ifFalse: 
					[arrange == #north 
						ifTrue: [self north: aView]
						ifFalse: 
							[arrange == #south 
								ifTrue: [self south: aView]
								ifFalse: 
									[arrange == #center 
										ifTrue: [self center: aView]
										ifFalse: [self error: 'Unrecognized arrangement parameter']]]]].
	^aView!

center
	"Answer the view arranged to the center of the container view for which the receiver lays
	out subviews."

	^center!

center: aView
	"Set the view arranged to the center of the container view for which the receiver lays out
	subviews."

	center := aView!

east
	"Answer the view arranged to the right edge of the container view for which the receiver
	lays out subviews."

	^east!

east: aView
	"Set the view arranged to the right edge of the container view for which the receiver lays
	out subviews."

	east := aView!

heightForEdge: aView ofWidth: anInteger inContext: aLayoutContext 
	| rect |
	rect := (aLayoutContext rectangleOf: aView) copy.
	rect width: anInteger.
	aLayoutContext setView: aView rectangle: rect.
	^(aView layoutExtent: aLayoutContext) y!

horizontalGap
	"Answer the horizontal gap between items laid out by the receiver"

	^horizontalGap!

horizontalGap: anInteger 
	"Set the horizontal gap between items laid out by the receiver to be the <integer>
	argument."

	horizontalGap := anInteger!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	horizontalGap := 0.
	verticalGap := 0!

layoutContainer: aCompositeView context: aLayoutContext 
	"Private - Update the <LayoutContext> argument with rectangles for the sub-views of its the
	specified container view, laying out those sub-views according to the rules and
	configuration of the particular layout manager."

	| top bottom left right insets containerExtent height width |
	insets := aCompositeView actualInsets: aLayoutContext.
	top := insets top.
	containerExtent := aLayoutContext clientExtentOf: aCompositeView.
	bottom := containerExtent y - insets bottom.
	left := insets left.
	right := containerExtent x - insets right.
	width := right - left.
	(self north notNil and: [aLayoutContext isViewVisible: self north]) 
		ifTrue: 
			[| desiredHeight |
			desiredHeight := self 
						heightForEdge: self north
						ofWidth: width
						inContext: aLayoutContext.
			aLayoutContext setView: self north rectangle: (left @ top extent: width @ desiredHeight).
			top := top + desiredHeight + self verticalGap].
	(self south notNil and: [aLayoutContext isViewVisible: self south]) 
		ifTrue: 
			[| desiredHeight |
			desiredHeight := self 
						heightForEdge: self south
						ofWidth: width
						inContext: aLayoutContext.
			aLayoutContext setView: self south
				rectangle: (left @ (bottom - desiredHeight) extent: width @ desiredHeight).
			bottom := bottom - (desiredHeight + self verticalGap)].
	"Available height now fixed"
	height := bottom - top.
	(self east notNil and: [aLayoutContext isViewVisible: self east]) 
		ifTrue: 
			[| desiredWidth |
			desiredWidth := self 
						widthForEdge: self east
						ofHeight: height
						inContext: aLayoutContext.
			aLayoutContext setView: self east
				rectangle: ((right - desiredWidth) @ top extent: desiredWidth @ height).
			right := right - (desiredWidth + self horizontalGap)].
	(self west notNil and: [aLayoutContext isViewVisible: self west]) 
		ifTrue: 
			[| desiredWidth |
			desiredWidth := self 
						widthForEdge: self west
						ofHeight: height
						inContext: aLayoutContext.
			aLayoutContext setView: self west rectangle: (left @ top extent: desiredWidth @ height).
			left := left + desiredWidth + self horizontalGap].
	width := right - left.
	self center 
		ifNotNil: [:child | aLayoutContext setView: child rectangle: (left @ top extent: width @ height)]!

north
	"Answer the view arranged to the top edge of the container
	view for which the receiver lays out subviews."

	^north!

north: aView
	"Set the view arranged to the top edge of the container
	view for which the receiver lays out subviews."

	north := aView!

preferredLayoutExtentOf: aCompositeView context: aLayoutContext
	"Answer a <Point> specifying the preferred extent for the <CompositeView> argument when
	laying out in the context of the specified <LayoutContext>."

	| extent insets ignoreVisibility |
	extent := 0 @ 0.
	ignoreVisibility := (aLayoutContext isViewVisible: aCompositeView) not.
	({self east. self west. self center}
		select: [:each | each notNil and: [ignoreVisibility or: [aLayoutContext isViewVisible: each]]]) do: 
				[:child |
				| childExtent |
				childExtent := child layoutExtent: aLayoutContext.
				extent x: extent x + childExtent x.
				extent y: (childExtent y max: extent y)]
			separatedBy: [extent x: extent x + self horizontalGap].
	({self north. self south}
		select: [:each | each notNil and: [ignoreVisibility or: [aLayoutContext isViewVisible: each]]]) do: 
				[:child |
				| d |
				d := child layoutExtent: aLayoutContext.
				extent x: (d x max: extent x).
				extent y: extent y + d y + self verticalGap].
	insets := aCompositeView actualInsets: aLayoutContext.
	^extent + insets origin + insets corner!

removeSubView: aView
	"Remove aView from the collection of views which have been explicitly
	arranged by the receiver.
	Answer aView."

	self center == aView ifTrue: [self center: nil].
	self west == aView ifTrue: [self west: nil].
	self east == aView ifTrue: [self east: nil].
	self north == aView ifTrue: [self north: nil].
	self south == aView ifTrue: [self south: nil].

	^super removeSubView: aView
!

reposition: aMovedView to: aPoint
	"Private - If aMovedView is not one of the receivers views then position
	it to where it wants to go, otherwise layout the receivers container."

	aMovedView position: aPoint.
	aMovedView arrangement notNil ifTrue: [
		super reposition: aMovedView to: aPoint]!

resize: aSizedView to: aRectangle
	"If aSizedView is not one of the receivers views then resize
	it to its desired rectangle, otherwise layout the receivers container."

	aSizedView rectangle: aRectangle.
	aSizedView arrangement notNil ifTrue: [
		super resize: aSizedView to: aRectangle].
	^self.
!

resolutionScaledBy: aPoint 
	"Private - The receiver is being loaded and it has been determined that the pixel resolution
	has changed since the point at which the view was saved. Scale any internal pixels by the
	<Point> argument."

	horizontalGap := (horizontalGap * aPoint x) truncated.
	verticalGap := (verticalGap * aPoint y) truncated!

south
	"Answer the view arranged to the bottom edge of the container
	view for which the receiver lays out subviews."

	^south!

south: aView
	"Set the view arranged to the bottom edge of the container
	view for which the receiver lays out subviews."

	south := aView!

verticalGap
	"Answer the vertical gap between items laid out by the receiver."

	^verticalGap!

verticalGap: anInteger 
	"Set the vertical gap between items laid out by the receiver to be the <integer> argument."

	verticalGap := anInteger!

west
	"Answer the view arranged to the left edge of the container
	view for which the receiver lays out subviews."

	^west!

west: aView
	"Set the view arranged to the left edge of the container
	view for which the receiver lays out subviews."

	west := aView!

widthForEdge: aView ofHeight: anInteger inContext: aLayoutContext 
	| rect |
	rect := (aLayoutContext rectangleOf: aView) copy.
	rect height: anInteger.
	aLayoutContext setView: aView rectangle: rect.
	^(aView layoutExtent: aLayoutContext) x! !
!UI.BorderLayout categoriesFor: #arrangementOf:!accessing!public! !
!UI.BorderLayout categoriesFor: #arrangementOf:put:!accessing!public! !
!UI.BorderLayout categoriesFor: #center!accessing!public! !
!UI.BorderLayout categoriesFor: #center:!accessing!public! !
!UI.BorderLayout categoriesFor: #east!accessing!public! !
!UI.BorderLayout categoriesFor: #east:!accessing!public! !
!UI.BorderLayout categoriesFor: #heightForEdge:ofWidth:inContext:!geometry!helpers!private! !
!UI.BorderLayout categoriesFor: #horizontalGap!accessing!public! !
!UI.BorderLayout categoriesFor: #horizontalGap:!accessing!public! !
!UI.BorderLayout categoriesFor: #initialize!initializing!private! !
!UI.BorderLayout categoriesFor: #layoutContainer:context:!geometry!private! !
!UI.BorderLayout categoriesFor: #north!accessing!public! !
!UI.BorderLayout categoriesFor: #north:!accessing!public! !
!UI.BorderLayout categoriesFor: #preferredLayoutExtentOf:context:!enquiries!public! !
!UI.BorderLayout categoriesFor: #removeSubView:!public!removing! !
!UI.BorderLayout categoriesFor: #reposition:to:!geometry!private! !
!UI.BorderLayout categoriesFor: #resize:to:!geometry!public! !
!UI.BorderLayout categoriesFor: #resolutionScaledBy:!geometry!private! !
!UI.BorderLayout categoriesFor: #south!accessing!public! !
!UI.BorderLayout categoriesFor: #south:!accessing!public! !
!UI.BorderLayout categoriesFor: #verticalGap!accessing!public! !
!UI.BorderLayout categoriesFor: #verticalGap:!accessing!public! !
!UI.BorderLayout categoriesFor: #west!accessing!public! !
!UI.BorderLayout categoriesFor: #west:!accessing!public! !
!UI.BorderLayout categoriesFor: #widthForEdge:ofHeight:inContext:!geometry!helpers!private! !

!UI.BorderLayout class methodsFor!

horizontalGap: horizontal verticalGap: vertical
	"Answer a new instance of the receiver intialized with
	the supplied gaps."

	^self new
		horizontalGap: horizontal;
		verticalGap: vertical;
		yourself! !
!UI.BorderLayout class categoriesFor: #horizontalGap:verticalGap:!instance creation!public! !

