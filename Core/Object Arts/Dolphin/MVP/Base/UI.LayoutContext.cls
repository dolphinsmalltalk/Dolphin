"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.LayoutContext'
	instanceVariableNames: 'container placements'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: { 'DeferRectangles' -> true }!

UI.LayoutContext guid: (Core.GUID fromString: '{85935809-471d-43cd-98f0-4c8f861663de}')!

UI.LayoutContext comment: 'LayoutContext is used by LayoutManagers to buffer window layout changes such as moving, resizing (i.e. changing the view rectangle) and hiding/showing views. LayoutContext can then apply the buffered changes en-masse using the Win32 DeferWindowPos APIs. This minimises the amount of unecesary relayout and redrawing that would otherwise occur as layout managers allocate space to their charges.

Note that DeferWindowPos is only able to batch up window repositioning requests for children of the same parent window. Consequently if a LayoutContext is used to buffer layout requests for multiple layout managers (which is typically the case), then it will generate multiple deferred window repositioning batches. These batches are applied bottom up so that the innermost children are repositioned first, and so on up the parent chain.'!

!UI.LayoutContext categoriesForClass!Kernel-Objects! !

!UI.LayoutContext methodsFor!

apply
	"Apply the batch of deferred window positioning operations that the receiver represents."

	DeferRectangles ifFalse: [^self].
	self repositionSubViewsOf: container.
	(placements lookup: container) ifNotNil: [:placement | container rectangle: placement rectangle]!

clientExtentOf: aView 
	"Answer a <Point> representing the client extent of the specified <View>. This may be
	different to its current client extent if it has been repositioned during this operation."

	^(self clientRectangleOf: aView) extent!

clientRectangleOf: aView
	"Answer the client  <Rectangle> of the specified <View>. This may be different to its current
	client rectangle if it has been repositioned during this operation."

	^(placements lookup: aView)
		ifNil: [aView clientRectangle]
		ifNotNil: [:placement | aView calcClientRectangleFromRectangle: placement rectangle]!

extentOf: aView 
	"Answer a <Point>, being the window extent (not client extent) of the specified <View>. This
	may be different to its current view rectangle if it has been repositioned during this
	operation."

	^(self rectangleOf: aView) extent!

hideView: aView
	(self placementForView: aView) show: false!

isViewVisible: aView
	"Answer whether the specified <View> will be visible after the window repositioning
	operations specified in this context are applied."

	^(placements lookup: aView)
		ifNil: [aView hasVisibleStyle]
		ifNotNil: [:placement | placement isVisible]!

placementForView: aView
	^(placements lookup: aView) ifNil: [placements at: aView put: (LayoutPlacement view: aView)]!

rectangleOf: aView
	"Answer the window <Rectangle> of the specified <View>. This may be different to its current
	view rectangle if it has been repositioned during this operation."

	(placements lookup: aView) ifNotNil: [:placement | placement rectangle ifNotNil: [:rect | ^rect]].
	^aView rectangle!

repositionSubViewsOf: aView
	"Private - Recursively reposition the sub-views of the argument.
	Unfortunately the DeferWindowPos API has the limitation that all windows in the repositioning batch must have the same parent, and consequently we must recursively position the subviews as multiple batches, rather than accumulating all the positions and then applying one large deferred update."

	| newPlacements hdwp stream count |
	stream := WriteStream on: (newPlacements := Array new).
	aView subViewsDo: 
			[:each |
			self repositionSubViewsOf: each.
			(placements lookup: each) ifNotNil: [:placement | placement hasDeferredChange ifTrue: [stream nextPut: placement]]].
	count := stream position.
	count == 0 ifTrue: [^self].
	hdwp := User32 beginDeferWindowPos: count.
	1 to: count do: [:i | hdwp := (newPlacements at: i) deferWindowPos: hdwp].
	User32 endDeferWindowPos: hdwp!

setContainer: aContainerView
	container := aContainerView.
	placements := IdentityDictionary new.
	^self!

setView: aView extent: aPoint 
	"Set the window extent of the <View>, aView, to be the dimensions specified by the <Point>,
	aPoint. Answer the new window <Rectangle>. The view will not actually be resized until the
	batch of deferred position changes represented by the receiver are applied."

	^self setView: aView rectangle: ((self rectangleOf: aView) origin extent: aPoint).!

setView: aView origin: aPoint 
	"Set the window origin of the <View>, aView, to be the position specified by the <Point>,
	aPoint. Answer the new window <Rectangle>. The view will not actually be moved until the
	batch of deferred position changes represented by the receiver are applied."

	^self setView: aView rectangle: (aPoint extent: (self extentOf: aView)).!

setView: aView rectangle: aRectangle 
	"Set the window rectangle of the <View>, aView, to be the <Rectangle>, aRectangle. The view
	will not actually be repositioned until the batch of deferred position changes represented
	by the receiver are applied."

	(self placementForView: aView) rectangle: aRectangle.
	DeferRectangles ifFalse: [aView rectangle: aRectangle].
	^aRectangle!

showView: aView
	(self placementForView: aView) show: true!

visibleExtentOf: aView
	"Answer a <Point>, being the window extent (not client extent) of the specified <View> that will be visible at the end of the layout operation."

	^(placements lookup: aView)
		ifNil: [aView hasVisibleStyle ifTrue: [aView getWindowRect extent] ifFalse: [Point.Zero]]
		ifNotNil: [:placement | placement visibleExtent]! !

!UI.LayoutContext categoriesForMethods!
apply!operations!public! !
clientExtentOf:!accessing!public! !
clientRectangleOf:!accessing!public! !
extentOf:!accessing!public! !
hideView:!accessing!public! !
isViewVisible:!enquiries!public! !
placementForView:!accessing!private! !
rectangleOf:!accessing!public! !
repositionSubViewsOf:!operations!private! !
setContainer:!initializing!private! !
setView:extent:!accessing!public! !
setView:origin:!accessing!public! !
setView:rectangle:!accessing!public! !
showView:!accessing!public! !
visibleExtentOf:!enquiries!public! !
!

!UI.LayoutContext class methodsFor!

forContainer: aView
	^self new setContainer: aView! !

!UI.LayoutContext class categoriesForMethods!
forContainer:!instance creation!public! !
!

