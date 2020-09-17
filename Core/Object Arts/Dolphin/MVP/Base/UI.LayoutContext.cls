"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'UI.LayoutContext'
	instanceVariableNames: 'container positions'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.LayoutContext guid: (Core.GUID fromString: '{85935809-471d-43cd-98f0-4c8f861663de}')!
UI.LayoutContext comment: 'LayoutContext is used by LayoutManagers to buffer window layout changes such as moving, resizing (i.e. changing the view rectangle) and hiding/showing views. LayoutContext can then apply the buffered changes en-masse using the Win32 DeferWindowPos APIs. This minimises the amount of unecesary relayout and redrawing that would otherwise occur as layout managers allocate space to their charges.

Note that DeferWindowPos is only able to batch up window repositioning requests for children of the same parent window. Consequently if a LayoutContext is used to buffer layout requests for multiple layout managers (which is typically the case), then it will generate multiple deferred window repositioning batches. These batches are applied bottom up so that the innermost children are repositioned first, and so on up the parent chain.'!
!UI.LayoutContext categoriesForClass!Kernel-Objects! !
!UI.LayoutContext methodsFor!

apply
	"Apply the batch of deferred window positioning operations that the receiver represents."

	self deferRectangles ifFalse: [^self].
	self repositionSubViewsOf: container.
	positions at: container ifPresent: [:pos | container rectangle: (pos at: 2)]!

clientExtentOf: aView 
	"Answer a <Point> representing the client extent of the specified <View>. This may be
	different to its current client extent if it has been repositioned during this operation."

	^(self clientRectangleOf: aView) extent!

clientRectangleOf: aView
	"Answer the client  <Rectangle> of the specified <View>. This may be different to its current
	client rectangle if it has been repositioned during this operation."

	^(positions lookup: aView)
		ifNil: [aView clientRectangle]
		ifNotNil: [:array | aView calcClientRectangleFromRectangle: (array at: 2)]!

deferRectangles
	^true!

deferWindowPositions: aSequencedReadableCollection
	| hdwp count userLib |
	count := aSequencedReadableCollection size.
	count == 0 ifTrue: [^self].
	userLib := UserLibrary default.
	hdwp := userLib beginDeferWindowPos: count.
	aSequencedReadableCollection do: 
			[:each |
			| rect view flags |
			view := each at: 1.
			flags := ##(SWP_NOZORDER | SWP_NOACTIVATE).
			rect := (each at: 2)
						ifNil: 
							[flags := flags bitOr: ##(SWP_NOSIZE | SWP_NOMOVE).
							Rectangle.Empty]
						ifNotNil: [:r | view adjustRectangle: r].
			(each at: 3)
				ifNotNil: [:show | flags := flags bitOr: (show ifTrue: [SWP_SHOWWINDOW] ifFalse: [SWP_HIDEWINDOW])].
			hdwp := userLib
						deferWindowPos: hdwp
						hwnd: view asParameter
						hwndInsertAfter: 0
						x: rect left
						y: rect top
						cx: rect width
						cy: rect height
						uFlags: flags].
	userLib endDeferWindowPos: hdwp!

extentOf: aView 
	"Answer a <Point>, being the window extent (not client extent) of the specified <View>. This
	may be different to its current view rectangle if it has been repositioned during this
	operation."

	^(self rectangleOf: aView) extent!

hideView: aView 
	self setView: aView visibility: false!

isViewVisible: aView
	"Answer whether the specified <View> will be visible after the window repositioning
	operations specified in this context are applied."

	(positions lookup: aView) ifNotNil: [:pos | (pos at: 3) ifNotNil: [:show | ^show]].
	^aView hasVisibleStyle!

positionForView: aView
	^positions at: aView ifAbsentPutClean: [{aView. nil. nil}]!

rectangleOf: aView
	"Answer the window <Rectangle> of the specified <View>. This may be different to its current
	view rectangle if it has been repositioned during this operation."

	(positions lookup: aView) ifNotNil: [:pos | (pos at: 2) ifNotNil: [:rect | ^rect]].
	^aView rectangle!

repositionSubViewsOf: aView
	"Private - Recursively reposition the sub-views of the argument.
	Unfortunately the DeferWindowPos API has the limitation that all windows in the repositioning batch must have the same parent, and consequently we must recursively position the subviews as multiple batches,
	rather than accumulating all the positions and then applying one large deferred update."

	| pairs |
	pairs := OrderedCollection new.
	aView subViewsDo: 
			[:each |
			self repositionSubViewsOf: each.
			positions at: each
				ifPresent: 
					[:pos |
					| view rect |
					view := pos at: 1.
					rect := pos at: 2.
					((rect notNil and: [rect ~= view rectangle]) or: 
							[| show |
							show := pos at: 3.
							show notNil and: [show ~= view isWindowVisible]])
						ifTrue: [pairs addLast: pos]]].
	self deferWindowPositions: pairs!

setContainer: aContainerView
	positions := LookupTable new.
	container := aContainerView!

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

	(self positionForView: aView) at: 2 put: aRectangle.
	self deferRectangles ifFalse: [aView rectangle: aRectangle].
	^aRectangle!

setView: aView visibility: aBoolean 
	(self positionForView: aView) at: 3 put: aBoolean!

showView: aView 
	self setView: aView visibility: true! !
!UI.LayoutContext categoriesFor: #apply!operations!public! !
!UI.LayoutContext categoriesFor: #clientExtentOf:!accessing!public! !
!UI.LayoutContext categoriesFor: #clientRectangleOf:!accessing!public! !
!UI.LayoutContext categoriesFor: #deferRectangles!private!testing! !
!UI.LayoutContext categoriesFor: #deferWindowPositions:!operations!public! !
!UI.LayoutContext categoriesFor: #extentOf:!accessing!public! !
!UI.LayoutContext categoriesFor: #hideView:!accessing!public! !
!UI.LayoutContext categoriesFor: #isViewVisible:!enquiries!public! !
!UI.LayoutContext categoriesFor: #positionForView:!accessing!private! !
!UI.LayoutContext categoriesFor: #rectangleOf:!accessing!public! !
!UI.LayoutContext categoriesFor: #repositionSubViewsOf:!operations!private! !
!UI.LayoutContext categoriesFor: #setContainer:!initializing!private! !
!UI.LayoutContext categoriesFor: #setView:extent:!accessing!public! !
!UI.LayoutContext categoriesFor: #setView:origin:!accessing!public! !
!UI.LayoutContext categoriesFor: #setView:rectangle:!accessing!public! !
!UI.LayoutContext categoriesFor: #setView:visibility:!accessing!public! !
!UI.LayoutContext categoriesFor: #showView:!accessing!public! !

!UI.LayoutContext class methodsFor!

forContainer: aView 
	^(self new)
		setContainer: aView;
		yourself! !
!UI.LayoutContext class categoriesFor: #forContainer:!instance creation!public! !

