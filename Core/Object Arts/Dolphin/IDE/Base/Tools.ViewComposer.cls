"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkToolShell subclass: #'Tools.ViewComposer'
	instanceVariableNames: 'toolboxPresenter status arenaPresenter inspector composingView ownsComposingView resourceIdentifier addPositionOffset grabbers selections grid viewHierarchyPresenter adornmentRegion primarySelection vcFlags modificationStatus image clipboard undoList'
	classVariableNames: 'Clipboard DefaultGridResolution ExtentImage PositionImage'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
		'AdornmentModifiedFlag' -> 16r4.
		'ModifiedFlag' -> 16r1.
		'MouseClickFlag' -> 16r2.
		'RefreshFlag' -> 16r8.
		'UndoRedoFlag' -> 16r10
	}!
Tools.ViewComposer guid: (Core.GUID fromString: '{045641aa-90d2-43e8-a81c-a3f76d7d35b4}')!
Tools.ViewComposer comment: 'The View Composer is Dolphin''s GUI builder. It is used to graphically create views (the user interface components of the MVP framework). 

The view resources are saved down as class-side methods, usually associated with the presenter classes to which the views will be attached. These methods are given selectors of the form, #resource_xxxx_yyyy, where xxxx_yyyy is the resource identifier. The resource methods answer an array of Smalltalk literals that can be used to rebuild an instance of the view when loaded via an STLInFiler.

The View Composer works by loading its ''composing view'' as a child of the desktop and positioning it offscreen so that it is invisible to the user. It then uses WM_PRINT messages to render an image of this view which it displays in its arenaPresenter. Using this shadow image of the real view has a couple of benefits. The first is that mouse clicks over the image can be intercepted directly, whereas mouse clicks over the real view would be handled by the Windows controls themselves. We also discovered that placing a real shell view inside another (e.g. as a composing view inside the View Composer) caused the menu bars for the shell view not to be displayed.

'!
!Tools.ViewComposer categoriesForClass!MVP-Presenters! !
!Tools.ViewComposer methodsFor!

addGrabberFor: aGrabAspectSymbol of: aView
	"Private - Create a new Grabber for aGrabAspectSymbol of our associated view and add it to
	our collection of active grabbers. Answer the new grabber"

	| grabber |
	grabber := self createGrabberFor: aGrabAspectSymbol of: aView.
	^self grabbers add: grabber.
	!

addGrabbers
	"Private - Put up grabbers to manipulate the size of the primary selection"

	| primaryView |
	primaryView := self primarySelection.
	(primaryView isNil or: [(self canSize: primaryView) not])
		ifTrue: [ ^self ].

	"Corners first"
	self addGrabberFor: #bottomRight of: primaryView.
	self addGrabberFor: #topLeft of: primaryView.
	self addGrabberFor: #topRight of: primaryView.
	self addGrabberFor: #bottomLeft of: primaryView.

	"Now centres"
	(self addGrabberFor: #leftCenter of: primaryView) beHorizontalOnly.
	(self addGrabberFor: #rightCenter of: primaryView) beHorizontalOnly.
	(self addGrabberFor: #topCenter of: primaryView) beVerticalOnly.
	(self addGrabberFor: #bottomCenter of: primaryView) beVerticalOnly
!

addSelectionFor: aView 
	"Private - Adds a new selection"

	self selections remove: aView ifAbsent: [].
	self selections addFirst: aView.
	self updatePrimarySelection.
	self updateAdornment.
	self
		dropUndoState;
		saveUndoState!

adjustScroll
	"Private - Ensure the arena adopts scroll bars if required."

	| necessaryExtent |
	necessaryExtent := self hasComposingView 
				ifTrue: [self composingView rectangle extent]
				ifFalse: [0 @ 0].
	self arena preferredExtent: necessaryExtent + self arenaBorderSize.
	(self arena parentView)
		invalidateLayout;
		validateLayout!

adornmentRectanglesFor: aView
	"Private - Answer a collection of rectangles that mark the edges of the secondary
	selection adornments of aView."

	| viewRects |
	viewRects := OrderedCollection new.
	self adornmentRectanglesFor: aView do: [:rect | viewRects add: rect].
	^viewRects!

adornmentRectanglesFor: aView do: aMonadicValuable
	"Private - Evaluate the monadic valuable argument for a collection of rectangles that mark the edges of the secondary
	selection adornments of aView."

	| grabberExt viewRect |
	grabberExt := Grabber defaultExtent.
	viewRect := aView rectangle insetBy: grabberExt // 2 negated.
	viewRect
		origin: (self mapPoint: viewRect origin toArenaFromView: aView);
		corner: (self mapPoint: viewRect corner toArenaFromView: aView).
	#(#topLeft #bottomRight #topRight #bottomLeft #topCenter #bottomCenter #leftCenter #rightCenter)
		do: [:eachAspect | aMonadicValuable value: (Rectangle center: (viewRect perform: eachAspect) extent: grabberExt)]!

adornmentRegion
	"Private - Answers a Region occupied by all the selection adornments"

	(adornmentRegion isNil or: [adornmentRegion isRealized not]) ifTrue: [self saveAdornmentRegion].
	^adornmentRegion!

adornmentRegionFor: aView
	"Private - Answers a Region occupied by the selection adornments for aView"

	| region1 |
	region1 := Region empty.
	self adornmentRectanglesFor: aView
		do: 
			[:each |
			| region2 temp |
			region2 := Region rectangle: (each insetBy: -1).
			temp := region1 union: region2.
			region1 free.
			region2 free.
			region1 := temp].
	^region1!

alignBottoms
	"Aligns the bottom edges of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #bottomAlign.!

alignCenters
	"Aligns the vertical centres of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #centerX.!

alignLefts
	"Aligns the left edges of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #leftAlign.!

alignMiddles
	"Aligns the horizontal centres of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #centerY.!

alignRights
	"Aligns the right edges of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #rightAlign.!

alignTops
	"Aligns the top edges of all the selections to match that of the
	primary selection"

	self matchGeometryAspect: #topAlign.!

allResourceIdentifiers
	^Smalltalk developmentSystem allResourceIdentifiers!

areDragObjects: aCollection acceptableFor: operationSymbol inView: aView 
	"Private - Answer whether aDragDropObjectCollection are all acceptable for the operation described by
	operationSymbol."

	"Can aView currently accept a new view?"

	| dragDropObject |
	(aView = self arena or: [aView canAcceptSubViews]) ifFalse: [^false].

	"Does the receiver support the intended operation?"
	"(#(#copy #link) includes: operationSymbol) ifFalse: [^false]."

	"Is the drag object a ViewResource?"
	dragDropObject := aCollection first.
	(operationSymbol == #link and: [(dragDropObject isFormatAvailable: #ResourceIdentifier) not]) 
		ifTrue: [^false].
	^(dragDropObject isObjectKindAvailable: View) 
		or: [dragDropObject isFormatAvailable: #STLViewResource]!

arena
	"Private - Answer the arena view where the shell being composed is displayed"

	^arenaPresenter view!

arenaBorderSize
	"Private - Answer a number of pixels border size for the arena"

	^20!

arenaLeftButtonPressed: aMouseEvent 
	"Private - Handles mouse down event. First check to see if it is within
	any sizing grabber; if so perform the sizing operation.
	Next see if it is within a selection border or a view; if so
	drag all the selections."

	"Create the mouse tracker now, just in case it's needed later.
	This ensures that it tracks from the CURRENT mouse location"

	| position grabberHit viewHit screenPosition mouseTracker |
	screenPosition := aMouseEvent screenPosition.
	mouseTracker := MouseTracker forPresenter: self startingAt: screenPosition.

	"Has the mouse hit a Grabber ?"
	position := aMouseEvent position - 1.
	grabberHit := self grabberHitBy: position.
	grabberHit notNil 
		ifTrue: 
			[self trackGrabber: grabberHit from: screenPosition.
			^nil].

	"Has the mouse hit a selection adornment ?"
	self primarySelection notNil 
		ifTrue: 
			[| region |
			region := self adornmentRegionFor: self primarySelection.
			(region containsPoint: position) ifTrue: [viewHit := self primarySelection]].

	"Has the mouse hit a selection border ?"
	self primarySelection notNil 
		ifTrue: 
			[| region |
			region := self borderRegionFor: self primarySelection.
			(region containsPoint: position) ifTrue: [viewHit := self primarySelection]].
	viewHit isNil 
		ifTrue: 
			["Has the mouse hit a view ?"
			viewHit := self viewHitBy: position.
			viewHit isNil 
				ifTrue: 
					[mouseTracker := nil.
					viewHit := self composingView]].
	viewHit isNil ifTrue: [^nil].
	self isMouseClick: true.
	aMouseEvent isCtrlDown 
		ifTrue: 
			[(self selections includes: viewHit) ifTrue: [mouseTracker := nil].
			self toggleSelectionFor: viewHit]
		ifFalse: 
			[aMouseEvent isShiftDown 
				ifTrue: [self addSelectionFor: viewHit]
				ifFalse: [self primarySelection == viewHit ifFalse: [self selection: viewHit]]].
	self isMouseClick: false.
	mouseTracker notNil 
		ifTrue: 
			[mouseTracker startTracking: self.
			viewHit == self composingView ifTrue: [self adjustScroll]].
	^nil!

arenaMouseMoved: aMouseEvent 
	| cursor |
	cursor := self cursor.
	cursor notNil ifTrue: [cursor setCursor].
	^nil!

aspectAccessor
	^inspector aspectAccessor!

aspectAccessor: anAspectAccessor 
	| accessor |
	accessor := inspector aspectTreePresenter model asSet detect: [:each | each name=anAspectAccessor name] ifNone: [^self].
	inspector aspectTreePresenter selection: accessor.!

basicCaption
	"Private - Answer a basic caption that can be used to label the receiver's view.
	Normally this is augmented (in #updateCaption) by appending the document file
	name"

	^'View Composer'!

basicPasteResource: aResourceArray context: contextView 
	"Private - Pastes a view realized from anSTLArray into contextView. Answers the pasted view.
	Generally, #pasteResource:context:position: should be used instead, as that will take care
	of selection etc."

	^self systemModel loadViewResource: aResourceArray inContext: contextView!

basicPasteResourceLink: aLiteralResourceIdentifier context: contextView 
	"Private - Pastes reference to aLiteralResourceIdentifier into contextView. Answers the
	pasted view. Generally, #pasteResourceLink:context:position: should be used instead, as that
	will take care of selection etc."

	^contextView addSubView: (ReferenceView resourceIdentifier: aLiteralResourceIdentifier)!

borderRectanglesFor: aView
	"Private - Answer a collection of rectangles that mark the borders of aView"

	| extent rect borderRects corner |
	extent := Grabber defaultExtent.
	rect := aView rectangle.
	borderRects := OrderedCollection new.
	corner := self mapPoint: rect topLeft toArenaFromView: aView.
	borderRects add: (corner extent: extent x @ rect height).
	borderRects add: (corner extent: rect width @ extent y).
	corner := self mapPoint: rect topRight toArenaFromView: aView.
	borderRects add: (corner - (extent x @ 0) extent: extent x @ rect height).
	corner := self mapPoint: rect bottomLeft toArenaFromView: aView.
	borderRects add: (corner - (0 @ extent y) extent: rect width @ extent y).
	^borderRects!

borderRegionFor: aView 
	"Private - Answers a Region occupied by the selection borders for aView"

	| region1 |
	region1 := Region empty.
	(self borderRectanglesFor: aView) do: 
			[:each | 
			| region2 temp |
			region2 := Region rectangle: (each insetBy: -1).
			temp := region1 union: region2.
			region1 free.
			region2 free.
			region1 := temp].
	^region1!

browseIt
	"Open a new class browser on the hierarchy at the same point as the receiver."
	
	self composingView browse!

calculatePositionOf: aView offsetBy: pointOffset 
	"Private - Answers the constrained position in the arena of aView when offset by pointOffset."

	| newPosition arenaPosition constrainedPosition parent parentArenaRect |
	parent := aView parentView.
	newPosition := aView position + pointOffset.
	constrainedPosition := self constrainPoint: newPosition.
	arenaPosition := self mapPoint: constrainedPosition toArenaFromView: aView.

	"Ensure aView stays within its parent rectangle."
	parentArenaRect := (self mapPoint: 0@0 toArenaFromView: aView) extent: parent clientExtent.
	arenaPosition := arenaPosition max: parentArenaRect origin.
	arenaPosition := arenaPosition min: parentArenaRect bottomRight-aView extent.
	^arenaPosition!

cancelSelectionFor: aView
	"Private - Removes the selection for aView"

	(self isSelected: aView) ifTrue: [
		self invalidateAdornmentFor: aView.
		self selections remove: aView.
		self updateAdornment.
		self updatePrimarySelection ]
!

cancelSelections
	"Private - Removes all selections and grabbers"

	self eraseAdornment.
	grabbers := nil.
	selections := OrderedCollection new.
	self primarySelection: nil.
!

cancelTrackingAt: aPoint 
	self eraseTrackingAt: aPoint.
	self updateAdornment!

canMove: aView 
	"Private - Answer true if aView can be moved around by the receiver"

	^aView ~~ self composingView!

canPaste
	"Private - Answer whether the ResourceManager clipboard can be pasted into the receiver."

	| dragObjects |
	(dragObjects := self clipboard) isNil ifTrue: [^false].
	self composingView isNil ifTrue: [^true].
	self primarySelection isNil ifTrue: [^false].
	^self 
		areDragObjects: dragObjects
		acceptableFor: #copy
		inView: self primarySelection!

canSaveState
	"Private - Answer true if the receiver can successfully have it's state saved by #saveStateOn:. Some
	tools may not be able to save their state and therefore will not be able to be exported as
	part of a IdeaSpace save operation"

	^self hasResource!

canSize: aView
	"Private - Answer true if aView can be sized by the receiver"

	^true

!

centerHorizontally
	"Private - Move the selections so that the primary selection is centred horizontally in its parent,
	but maintaining the relative positions of the other selections."

	| primaryRectangle center delta |
	primaryRectangle := self primarySelection rectangle.
	center := self primarySelection parentView clientRectangle centerX.
	delta := primaryRectangle centerX - center.
	self eraseAdornment.
	self selections 
		do: [:each | self repositionView: each to: (each position x - delta rounded) @ each position y]!

centerVertically
	"Private - Move the selections so that the primary selection is centred vertically in its parent, but
	maintaining the relative positions of the other selections."

	| primaryRectangle center delta |
	primaryRectangle := self primarySelection rectangle.
	center := self primarySelection parentView clientRectangle centerY.
	delta := primaryRectangle centerY - center.
	self eraseAdornment.
	self selections 
		do: [:each | self repositionView: each to: each position x @ (each position y - delta rounded)]!

chooseBackgroundColor
	"Set the background color of all selected objects to the users choice from a ColorDialog."

	| color |
	color := Color choose.
	color notNil ifTrue:
		[self selections do: [:v | v backcolor: color]].
!

chooseFont
	"Set the font of all selected objects to the users choice from a FontDialog."

	| font |
	font := Font choose.
	font notNil ifTrue:
		[self selections do: [:v | v font: font]].
!

chooseForegroundColor
	"Set the foreground color of all selected objects to the users choice from a ColorDialog."

	| color |
	color := Color choose.
	color notNil ifTrue:
		[self selections do: [:v | v forecolor: color]].
!

clearSelection
	"Removes the current selections from the receiver"

	| prompt selCount |
	selCount := self selections size.
	prompt := selCount > 1
				ifTrue: ['Are you sure you wish to remove the <1p> selected views?' expandMacrosWith: selCount]
				ifFalse: 
					['Are you sure you wish to remove the selected <1p>?' expandMacrosWith: self selections first class].
	(MessageBox confirm: prompt) ifTrue: [self deleteSelections]!

clearUndoState
	undoList clear.
	self saveUndoState!

clipboard
	^self class clipboard!

closeComposingView
	composingView isNil ifTrue: [^self].
	viewHierarchyPresenter model remove: composingView.
	self ownsComposingView ifTrue: [composingView destroy].
	composingView := nil.
	ownsComposingView := false!

composingView
	"Answers the View that is currently being composed by the receiver"

	^composingView
!

composingView: aView isOwned: isOwned 
	"Private - Sets the View that is currently being composed by the receiver.
	If nil then we are not editing any view"

	| hierarchy |
	composingView := aView.
	hierarchy := viewHierarchyPresenter model.
	hierarchy clear.
	hierarchy addRoot: composingView.
	ownsComposingView := isOwned.
	self ownsComposingView ifTrue: [self composingView position: self hidingOffset].
	self
		updateCaption;
		adjustScroll;
		refreshImage!

constrainPoint: aPoint
	"Private - Answers the position for aPoint after any view constraints have been taken 
	into consideration"

	^grid constrainPoint: aPoint!

constrainRectangle: aRectangle 
	^grid constrainRectangle: aRectangle!

continueTrackingAt: pointOffset from: previousPointOffset
	"Private - Continue selection tracking at pointOffset when the previous tracking 
	was at previousPointOffset. Part of the <MouseTracker> target protocol. 
	Answers the actual position achieved after any view constraints
	have been applied"

	self eraseTrackingAt: previousPointOffset.
	self drawTrackingAt: pointOffset.
	^pointOffset!

copyAspectsFrom: sourceView to: destinationView 
	"Private - Transfer all the understood published 	aspects from
	sourceView to destinationView. Also transfers certain aspects that are
	held by the parent."

	| originalName originalPreviousSibling destinationAspects sourceAspects |
	destinationAspects := destinationView publishedAspects.
	sourceAspects := sourceView publishedAspects.
	sourceAspects do: 
			[:eachSource | 
			| aspectName |
			aspectName := eachSource key.
			aspectName == #name 
				ifFalse: 
					[destinationAspects at: aspectName
						ifPresent: 
							[:destinationAspect | 
							| source destination |
							source := eachSource accessorFor: sourceView.
							destination := destinationAspect accessorFor: destinationView.
							(source canGet and: [destination canSet]) ifTrue: [destination value: source value]]]].
	originalName := sourceView name.
	originalPreviousSibling := sourceView previousSiblingView.
	sourceView parentView == View desktop 
		ifFalse: 
			[sourceView name: nil.
			destinationView name: originalName].
	destinationView zOrderAfter: originalPreviousSibling!

copySelection
	"Copies the selections to the View Composer clipboard. Note that we do not currently
	integrate with the real Windows clipboard"

	#todo "Use the Clipboard class".
	self class copyAllToClipboard: self selections.
!

createComponents
	"Private - Create the presenters contained by the receiver"

	super createComponents.
	inspector := self
				add: (PropertyInspector new
						isRootAspectVisible: false;
						yourself)
				name: 'inspector'
				helpId: 10829.
	viewHierarchyPresenter := self
				add: (TreePresenter on: self createViewHierarchyModel)
				name: 'viewHierarchy'
				helpId: 10828.
	arenaPresenter := self
				add: ImagePresenter new
				name: 'arena'
				helpId: 10831.
	toolboxPresenter := self
				add: ResourceToolboxPresenter new
				name: 'toolbox'
				helpId: 10830!

createGrabberFor: aGrabAspectSymbol of: aView
	"Private - Answer a new Grabber for aGrabAspectSymbol of our associated view"

	^Grabber
		view: aView
		aspect: aGrabAspectSymbol
		composer: self!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	inspector 
		when: #inspecteeChanged
		send: #onInspecteeChanged
		to: self.
	viewHierarchyPresenter
		when: #selectionChanged
			send: #onHierarchySelection
			to: self;
		when: #dragOver:
			send: #onDragOverHierarchy:
			to: self;
		when: #drop:
			send: #onDropOverHierarchy:
			to: self;
		when: #dragCut:
			send: #onDragCutHierarchy:
			to: self;
		when: #drag:
			send: #onDragHierarchy:
			to: self.
	arenaPresenter
		when: #dragEnter:
			send: #onDragEnterArena:
			to: self;
		when: #dragOver:
			send: #onDragOverArena:
			to: self;
		when: #dragLeave:
			send: #onDragLeaveArena:
			to: self;
		when: #drop:
			send: #onDropOverArena:
			to: self;
		when: #requestDropOperations:
			send: #onRequestDropOpsForShield:
			to: self.
	(viewHierarchyPresenter model)
		when: #item:addedInParent:
			send: #setModified
			to: self;
		when: #item:movedToParent:
			send: #setModified
			to: self.
	self 
		when: #closeRequested:
		send: #onCloseRequested:
		to: self.
	(SessionManager current)
		when: #imageSaveStarting
			send: #onImageSaveStarting
			to: self;
		when: #imageSaveCompleted
			send: #onImageSaveCompleted
			to: self;
		when: #sessionStarted
			send: #onSessionStarted
			to: self!

createViewHierarchyModel
	| tree |
	tree := VirtualTreeModel new.
	tree getChildrenBlock: [:aView | aView managedSubViews].
	tree getParentBlock: [:aView | aView parentView].
	^tree!

cursor
	"Answers the cursor to be used.
	If the mouse position is over a Grabber, then
	answer the appropriate cursor."

	"Has the mouse hit a selection border ?"

	^self cursorAt: (DesktopView current mapPoint: Cursor position to: self arena)!

cursorAt: position 
	| grabberHit |
	grabberHit := self grabberHitBy: position.
	grabberHit notNil ifTrue: [^grabberHit cursor].
	"Has the mouse hit a selection border ?"
	^self primarySelection notNil 
		ifTrue: 
			[| region |
			region := self borderRegionFor: self primarySelection.
			(region containsPoint: position) ifTrue: [Cursor sizeAll]]!

cutSelection
	"Cuts the current selections to the clipboard"

	self copySelection.
	self deleteSelections!

decreaseHeight
	self resizeBy: 0 @ -1!

decreaseHorizontalGaps
	"Decrease the gap between the selected views in the horizontal plane. The views move toward
	from the centre line of the parent."

	self nudgeHorizontalGaps: -1!

decreaseVerticalGaps
	"Deccrease the gap between the selected views in the vertical plane. The views move toward
	from the middle line of the parent."

	self nudgeVerticalGaps: -1!

decreaseWidth
	self resizeBy: -1 @ 0!

defaultComposingPosition
	"Private - Answer aPoint used to offset the composing view within the arena when first shown"

	^self arena insets origin!

defaultGridResolution
	"Private - Answers the default grid resolution to use in the receiver."

	^5!

defaultHelpId
	^10827!

defaultSelectionWidth
	"Private - Answer the default width of the selection border"

	^OS.SystemMetrics current sizingFrameExtent x

!

deleteSelections
	self selections copy do: [:each | self removeView: each].
	self setModified.
	self arena invalidate.
	self hasComposingView ifTrue: [self composingView validateLayout] ifFalse: [self isModified: false]!

dereference
	"Private - Dereference the primary selection which is an instance of ReferenceView."

	| referenceView dereferencedView |
	referenceView := self primarySelection.
	(MessageBox
		confirm: ('This reference to ''<1d>'' will be replaced by a copy.<n><n>Are you sure you want to continue?'
				expandMacrosWith: referenceView resourceIdentifier)
		caption: 'Dereference to copy...') ifFalse: [^self].
	self eraseAdornment.
	dereferencedView := self basicPasteResource: referenceView resource
				context: referenceView parentView.
	self copyAspectsFrom: referenceView to: dereferencedView.
	self pastedView: dereferencedView context: referenceView parentView.
	self removeView: referenceView!

distributeHorizontally
	"Distribute the selected controls horizontally so that they are evenly spaced. The existing
	relative positions of the selections are maintained (i.e. the leftmost control remains so
	after distribution, etc)."

	| distributees gap space totalWidth start clientWidth |
	clientWidth := self selections first parentView clientWidth.
	distributees := self selectionsByHorizontalPosition.
	totalWidth := distributees inject: 0 into: [:sum :each | sum + each extent x].
	space := clientWidth - totalWidth.
	start := space < 0 
				ifTrue: 
					[gap := space / (distributees size - 1).
					0]
				ifFalse: 
					[gap := space / (distributees size + 1).
					gap rounded].
	self eraseAdornment.
	distributees inject: start
		into: 
			[:x :each | 
			self repositionView: each to: x rounded @ each y.
			x + each extent x + gap]!

distributeVertically
	"Distribute the selected controls vertically so that they are evenly spaced."

	| distributees totalHeight clientHeight gap start space |
	distributees := self selectionsByVerticalPosition.
	totalHeight := distributees inject: 0 into: [:sum :each | sum + each height].
	clientHeight := distributees first parentView clientHeight.
	space := clientHeight - totalHeight.
	start := space < 0 
				ifTrue: 
					[gap := space / (distributees size - 1).
					0]
				ifFalse: 
					[gap := space / (distributees size + 1).
					gap rounded].
	self eraseAdornment.
	distributees inject: start
		into: 
			[:y :each | 
			self repositionView: each to: each x @ y rounded.
			y + each height + gap]!

drawAdornment
	"Private - Draws the adornment for the receiver on the associated view. It
	must be painted after all child windows of the view have been drawn, 
	so that it appears on top of them"

	self arena update.
	self secondarySelections do: [:each | self drawSelectionFor: each ].
	self grabbers do: [:each | each draw].
	self saveAdornmentRegion.

!

drawSelectionFor: aView
	"Private - Paint the selection border for aView."

	| canvas aMonadicValuable |
	canvas := self arena canvas.
	canvas pen: (Pen color: Color highlight).
	aMonadicValuable := [:each | canvas rectangle: each].
	self adornmentRectanglesFor: aView do: aMonadicValuable.
	canvas free!

drawTrackingAt: pointOffset 
	"Private - Draws the tracking for the current selections when offset by pointOffset."

	self moveableSelections do: 
			[:each | 
			| newPosition focusRect |
			newPosition := self calculatePositionOf: each offsetBy: pointOffset.
			focusRect := Rectangle origin: newPosition extent: each extent.
			self arena drawFocusRect: focusRect.

			"For the primary selection, we show the position and size in the statusbar."
			each = self primarySelection 
				ifTrue: 
					[| positionInParent |
					positionInParent := self mapPoint: newPosition toViewFromArena: each parentView.
					status value: (Rectangle origin: positionInParent extent: focusRect extent)]]!

dropIncrement
	"Private - Answers a Point that is the incremental position between multiple dropped object"
	
	^10@10!

dropTargetFromSession: session 
	"Private - Determine where the view should be dropped."

	| viewHit arenaPoint |
	arenaPoint := session dragPointInView: self arena.
	viewHit := self viewHitBy: arenaPoint.
	
	[viewHit isNil ifTrue: [^self arena].
	viewHit canAcceptSubViews] 
			whileFalse: [viewHit := viewHit parentView].
	^viewHit!

dropUndoState
	undoList goBack: 1!

dropView: aView onto: aTargetView at: aPoint 
	"Private - Handle the drop of aView on aTargetView in the receiver.
	Answer true if the operation succeeds, false otherwise"

	| originalParent |
	originalParent := aView parentView.
	originalParent == aTargetView 
		ifFalse: 
			["Only need to do anything if the view is not already in place"

			| resource name |
			resource := aView literalStoreArray .
			name := aView parentView notNil ifTrue: [aView name].
			^self 
				dropViewResource: resource
				onto: aTargetView
				at: aPoint
				named: name].
	^false!

dropViewResource: aResourceArray onto: aTargetView at: aPoint named: aNameStringOrNil 
	"Private - Handle the drop of aViewResource  on aTargetView in the receiver.
	Answer true if the operation succeeds, false otherwise"

	| dropee position |
	position := (aTargetView clientRectangle containsPoint: aPoint) 
				ifTrue: [aPoint]
				ifFalse: [self dropIncrement].
	Cursor wait showWhile: 
			[dropee := self 
						pasteResource: aResourceArray
						context: aTargetView
						position: position].
	dropee show.
	[dropee name: aNameStringOrNil] on: Error do: [:x | ].
	^true!

editContextMenu
	"Invoke the MenuComposer on the context menu of the primarySelection."

	| menuValue editor edited |
	edited := self primarySelection.
	menuValue := edited aspectValue: #contextMenu.
	menuValue
		when: #valueChanged
		send: #setModified
		to: self.
	editor := MenuComposer createOn: menuValue.
	editor showModal.
	editor isConfirmed ifTrue: [inspector aspectChanged: #contextMenu of: edited]!

editMenuBar
	"Invoke the MenuComposer on the menu bar of the composingView."

	| menuValue editor edited |
	edited := self composingView.
	menuValue := edited aspectValue: #menuBar.
	menuValue
		when: #valueChanged
		send: #setModified
		to: self.
	editor := MenuBarComposer createOn: menuValue.
	editor showModal.
	editor isConfirmed ifTrue: [inspector aspectChanged: #menuBar of: edited]!

editReference
	"Private - Edit the primary selection which is an instance of ReferenceView."

	self primarySelection resourceIdentifier edit!

endComposition
	"Close the existing shell in use by the receiver"

	self composingView isNil ifTrue: [^self].
	self cancelSelections.
	self closeComposingView.
	self refreshImage!

endTrackingAt: pointOffset 
	"Private - End selection tracking at aPoint."

	self eraseTrackingAt: pointOffset.
	self moveableSelections do: 
			[:each | 
			"Don't think this should be necessary - reposition:to: should already do this"
			| newPosition screenPosition positionInParent |
			newPosition := self calculatePositionOf: each offsetBy: pointOffset.
			screenPosition := newPosition - self defaultComposingPosition + self hidingOffset.
			positionInParent := View desktop mapPoint: screenPosition to: each parentView.
			self repositionView: each to: positionInParent].
	self updateAdornment!

eraseAdornment
	"Private - Erases the adorment of selections."
	
	(self arena)
		invalidateRgn: self adornmentRegion;
		update.
	self isAdornmentModified: false!

eraseTrackingAt: aPoint
	"Private - Erases the tracking for the current selection when the primary selection is
	moved to aPoint. Since tracking is drawn with an Xor pen mode we can redraw
	it once more to erase it"

	self drawTrackingAt: aPoint	
!

fileNew
	"Create a new Shell view to edit."

	self newShellView!

fileOpen
	"Open the view from a resource."

	self viewOpen!

fileSave
	"Save the view as a resource."

	self viewSave!

forceLayoutFor: aContainerView
	"Private - Forces the relaying out of aContainerView, presumably because its contents have changed"

	aContainerView invalidateLayout.
	self composingView notNil ifTrue: [
		self composingView invalidateLayout; validateLayout ]!

getAdornmentRegion
	"Private - Answers a Region occupied by all the selection adornments"

	^self selections inject: Region empty into: [:region :each | 
		region union: (self adornmentRegionFor: each) ].


!

grabberHitBy: aPoint
	"Private - Answer the grabber under aPoint or nil otherwise"

	^self grabbers detect: [ :each | each containsPoint: aPoint ] ifNone: []

!

grabbers
	"Private - Answers the collection of grabbers currently in operation"

	^grabbers ifNil: [grabbers := IdentitySet new: 8]!

grid
	"Private - Answers the Grid associated with the receiver."

	^grid!

grid: aGrid
	"Private - Sets the Grid associated with the receiver to aGrid."

	grid := aGrid!

gridSetting
	(IntegerPrompter create: 'Spinner view' on: (self grid aspectValue: #resolution))
		caption: 'View Composer';
		prompt: 'Grid Resolution:';
		interval: (1 to: 100);
		showModal!

hasClipboard
	"Private - Answer true if there is an item on the clipboard"

	^self clipboard notNil
!

hasComposingView
	"Private - Answer true if we are actually composing a view"

	^self composingView notNil
!

hasMoveableSelection
	"Private - Answer true if there are any selections"

	^self moveableSelections notEmpty!

hasOwnedComposingView: aView 
	^self composingView == aView and: [self ownsComposingView]!

hasPreferredExtent
	"Answers true if the primary selection is set to use a preferred extent"

	^self primarySelection preferredExtent notNil!

hasResource
	"Private - Answer true if the receiver has a full resource identifier"

	^resourceIdentifier notNil and: [resourceIdentifier name notNil ]!

hasSelection
	"Private - Answer true if there are any selections"

	^self selections notEmpty

!

hidingOffset
	"Answers the <Point> location where our composing view should be positioned so that so that
	it is not visible on the desktop.

	Note that, Windows will allow top-level shells to be positioned anywhere offscreen without
	problems but, unfortunately this is not the case for non-shell windows which are always
	forced back so they are fully visible on screen.

	Hence, here we choose our hiding offset such that only one pixel needs to be visible at the
	edge of the screen and Windows will not then try to interfere with our positioning. Note
	that we need to be careful to handle multi-monitor displays."

	^(OS.SystemMetrics current virtualScreenRectangle right - 1) @ 10!

increaseHeight
	self resizeBy: 0 @ 1!

increaseHorizontalGaps
	"Increase the gap between the selected views in the horizontal plane. The views move away
	from the centre line of the parent."

	self nudgeHorizontalGaps: 1!

increaseVerticalGaps
	"Increase the gap between the selected views in the vertical plane. The views move away
	from the middle line of the parent."

	self nudgeVerticalGaps: 1!

increaseWidth
	self resizeBy: 1 @ 0!

incrementAddPositionOffset
	"Private - Increments the position offset within a parent where
	a new child view should be added. Answers the new position"

	^addPositionOffset := addPositionOffset + self defaultComposingPosition!

initialComposingPosition
	"Private - Answer aPoint used to offset the composing view within the arena when first shown"

	^10000 @ 10000!

initialize
	"Private - Initialize the receiver"

	super initialize.

	self grid: (Grid resolution: self class defaultGridResolution).
	undoList := HistoryList new: self maxUndoStates.
	selections := OrderedCollection new.
	vcFlags := 0.
	ownsComposingView := false.
	self resetAddPositionOffset.
!

inspector
	"Private - Answer the published aspect inspector of the receiver"

	^inspector!

inspectSelection
	"Removes the current selections from the receiver"

	| sel |
	sel := self selections.
	sel size = 1
		ifTrue: [sel first inspect]
		ifFalse: [sel asArray inspect]!

invalidateAdornmentFor: aView
	"Private - Invalidates the region occupied by the adornments for aView 
	and causes it to be repainted"

	self arena invalidateRgn: (self adornmentRegionFor: aView)


!

isAdornmentModified
	"Private - Answer whether the adornments required updating."

	^vcFlags allMask: AdornmentModifiedFlag
!

isAdornmentModified: aBoolean
	"Private - Update the isAdornmentModified flag."

	vcFlags := vcFlags mask: AdornmentModifiedFlag set: aBoolean
!

isImageDirty
	^vcFlags anyMask: RefreshFlag!

isImageDirty: aBoolean
	vcFlags := vcFlags mask: RefreshFlag set: aBoolean!

isModified
	"Answer true if the view being composed has been modified"

	^vcFlags allMask: ModifiedFlag
!

isModified: aBoolean
	"Private - Set the modifiaction flag for the view being composed to aBoolean"

	aBoolean
		ifTrue: 
			[self
				refreshImage;
				saveUndoState].
	self isModified == aBoolean ifTrue: [^self].
	vcFlags := vcFlags mask: ModifiedFlag set: aBoolean.
	modificationStatus value: aBoolean!

isMouseClick
	"Private - Answer whether the Mouse Click flag is set."

	^vcFlags allMask: MouseClickFlag
!

isMouseClick: aBoolean
	"Private - Set/reset the mouse click flag."

	vcFlags := vcFlags mask: MouseClickFlag set: aBoolean!

isMouseTarget
	"Private - Answer true if the receiver wants mouse events that would otherwise
	go to the window under the mouse pointer"

	^true
!

isSelected: aView
	"Private - Answer true if the aView is selected"

	^self selections includes: aView
!

isUndoRedoInProgress
	^vcFlags anyMask: UndoRedoFlag!

mapPoint: aPoint toArenaFromView: aView 
	^(aView parentView mapPoint: aPoint to: View desktop) - self hidingOffset+self defaultComposingPosition!

mapPoint: aPoint toViewFromArena: aView 
	| offset |
	offset := self defaultComposingPosition - self hidingOffset.
	^(View desktop mapPoint: aPoint to: aView )-offset!

mapRectangle: aRectangle toArenaFromView: aView 
	| offset |
	offset := self defaultComposingPosition - self hidingOffset.
	^(aView parentView mapRectangle: aRectangle to: View desktop) moveBy: offset!

mapRectangle: aRectangle toViewFromArena: aView 
	| offset |
	offset := self defaultComposingPosition - self hidingOffset.
	^(View desktop mapRectangle: aRectangle to: aView parentView) moveBy: offset negated!

matchBackgroundColors
	"Matches the background colors of all the selections to that of the primary selection."

	| color |
	color := self primarySelection backcolor.
	(self selections reject: [:v | v == self primarySelection]) do:
		[:v | v backcolor: color].
	self setModified
!

matchFonts
	"Matches the fonts of all the selections to that of the primary selection."

	| font |
	font := self primarySelection font.
	(self selections reject: [:v | v == self primarySelection]) do:
		[:v | v font: font].
	self setModified
!

matchForegroundColors
	"Matches the foreground colors of all the selections to that of the primary selection."

	| color |
	color := self primarySelection forecolor.
	(self selections reject: [:v | v == self primarySelection]) do:
		[:v | v forecolor: color].
	self setModified
!

matchGeometryAspect: anAspectSymbol 
	"Private - Matches the geometry aspect in anAspectSymbol (#x, #y, #width, #height etc) of the 
	selections to that of the primary selection"

	self safetyWrap: 
			[| aspectSetSymbol primaryRectangle |
			aspectSetSymbol := (anAspectSymbol , ':') asSymbol.
			primaryRectangle := self primarySelection parentView 
						mapRectangle: self primarySelection rectangle
						to: self primarySelection topView.
			self selections do: 
					[:each | 
					| rectangle selectionRectangle |
					rectangle := each topView mapRectangle: primaryRectangle to: each parentView.
					selectionRectangle := each rectangle.
					selectionRectangle perform: aspectSetSymbol with: (rectangle perform: anAspectSymbol).
					each rectangle: selectionRectangle]]!

matchHeights
	"Matches the heights of all the selections to that of the primary selection"

	self matchGeometryAspect: #height.!

matchSizes
	"Matches the sizes of all the selections to that of the primary selection"

	self matchHeights; matchWidths!

matchWidths
	"Matches the widths of all the selections to that of the primary selection"

	self matchGeometryAspect: #width.!

maxUndoStates
	^40!

moveableSelections
	"Private - Answer an OrderedCollection of selections which can be
	moved during a positioning operation. We remove all subViews that
	are having their parents moved"
	
	| moveableSelections |
	moveableSelections := self selections select: [ :each | self canMove: each ].
	^moveableSelections select: [ :each | 
		(each allParents intersection: moveableSelections) isEmpty ]
!

mutate
	"Mutate the primary selection to a user's choice of view"

	| viewClasses excluded |
	excluded := Set new.
	#(#{DesktopView} #{WinAsyncSocket} #{BrowserView})
		do: [:each | each ifDefined: [:viewClass | excluded add: viewClass]].
	"excluded 
		addAll: (self class owningPackage classes select: [:each | each inheritsFrom: View])."
	viewClasses := View allSubclasses reject: [:each | (excluded includes: each) or: [each isAbstract]].
	(ChoicePrompter choices: viewClasses asSortedCollection caption: 'Mutate to')
		ifNotNil: [:viewClass | self mutateTo: viewClass]!

mutate: selectedView to: aViewClass 
	| newView |
	newView := selectedView parentView addSubView: aViewClass new.
	self copyAspectsFrom: selectedView to: newView.
	selectedView subViews copy inject: nil
		into: 
			[:prev :each | 
			| name |
			name := each name.
			each
				parentView: newView;
				recreate;
				name: name;
				zOrderAfter: prev;
				yourself].
	self pastedView: newView context: newView parentView.
	self removeView: selectedView.
	"Ensure any refs to old view (such as from a layout manager) are now to
	the new view"
	selectedView oneWayBecome: newView!

mutateTo: aViewClass 
	"Mutate the primary selection to an instance of aViewClass."

	self mutate: self primarySelection to: aViewClass!

newDialogView
	"Prepare the receiver to edit a new Dialog default view."

	| rid |
	rid := ResourceIdentifier class: Dialog name: Dialog defaultView.
	self openOnCopyOf: rid!

newShellView
	"Prepare the receiver to edit a new Shell default view."

	| rid |
	rid := ResourceIdentifier class: Shell name: Shell defaultView.
	self openOnCopyOf: rid!

nudgeBy: aPoint 
	self moveableSelections do: [:each | self repositionView: each to: each position + aPoint]!

nudgeDown
	self nudgeBy: 0 @ 1!

nudgeHorizontalGaps: delta 
	| distributees extra |
	distributees := self selectionsByHorizontalPosition.
	extra := distributees size - 1.
	self eraseAdornment.
	distributees inject: extra / 2 * delta negated
		into: 
			[:offset :each | 
			| pos |
			pos := each position.
			self repositionView: each to: (pos x + offset rounded) @ pos y.
			offset + delta]!

nudgeLeft
	self nudgeBy: -1 @ 0!

nudgeRight
	self nudgeBy: 1 @ 0!

nudgeUp
	self nudgeBy: 0 @ -1!

nudgeVerticalGaps: delta 
	| distributees extra |
	distributees := self selectionsByVerticalPosition.
	extra := distributees size - 1.
	self eraseAdornment.
	distributees inject: extra / (2 * delta negated)
		into: 
			[:offset :each | 
			| pos |
			pos := each position.
			self repositionView: each to: pos x @ (pos y + offset rounded).
			offset + delta]!

onCloseRequested: boolValueHolder
	"Private - A request to close the view onto the receiver as occurred.
	Prompt to save any outstanding changed"

	self onPromptToSaveChanges: boolValueHolder!

onDragCutHierarchy: session 
	"Private - The DragDropSession, session, has just completed a successful 
	move operation.  The receiver is now responsible for deleting the 
	dragged object s) from itself."

	session dragObjects do: 
			[:each | 
			| draggedView |
			draggedView := each object.
			viewHierarchyPresenter model remove: draggedView.
			draggedView parentView removeSubView: draggedView]!

onDragEnterArena: session 
	"Private - The drag operation described by the <DragDropSession>, session,
	has entered the receiver's arena window.
	Note that we don't worry about setting up the drop operation just yet,
	as we'll soon be getting an #onDragOverArena: message."

	self eraseAdornment!

onDragHierarchy: session 
	"Private - A drag has been started. Drag the currently selected view hierarchy."

	| dragDropObject |
	dragDropObject := session newDragObject: session suggestedSource.
	session
		dragObjects: (OrderedCollection with: dragDropObject);
		defaultOperation: #move!

onDragLeaveArena: session 
	"Private - The drag operation described by the <DragDropSession>, session,
	has left the receiver's arena window."

	session suggestedTarget notNil ifTrue: [self invalidateAdornmentFor: session suggestedTarget].
	self drawAdornment!

onDragOverArena: session 
	"Private - Answer the operation that would occur if a drop took place now."

	| op dropTarget |
	op := session intendedOperation.
	session operation: nil.
	"Determine where the view should be dropped. Make a note of this in the session."
	dropTarget := self dropTargetFromSession: session.
	dropTarget ~~ session suggestedTarget 
		ifTrue: 
			[session suggestedTarget notNil ifTrue: [self invalidateAdornmentFor: session suggestedTarget].

			"Don't allow a drop outside of the composingView (unless the arena is empty."
			(dropTarget == self arena and: [self composingView notNil]) ifTrue: [^session suggestedTarget: nil].
			session hideCursorWhile: 
					[self drawSelectionFor: dropTarget.
					self arena update].
			session suggestedTarget: dropTarget].
	(self 
		areDragObjects: session dragObjects
		acceptableFor: op
		inView: dropTarget) ifFalse: [^self].
	session operation: op!

onDragOverHierarchy: session 
	"Private - Answer the operation that would occur if a drop took place now from the
	<DragDropSession>, session. Basically the suggested target will allow a #copy or #link
	operation provided it is able to accept subviews"

	| targetView op |
	op := session intendedOperation.

	"Default is to do nothing."
	session operation: nil.
	session isTargetSameAsSource ifTrue: [^self].
	targetView := session suggestedTarget.
	(targetView isNil or: [targetView canAcceptSubViews]) ifFalse: [^self].
	(session isFormatAvailable: #ResourceIdentifier) 
		ifTrue: 
			[session intendedOperation == #move 
				ifFalse: 
					[session operation: op.
					^self]].
	(session isObjectKindAvailable: View) 
		ifTrue: 
			[session intendedOperation == #link 
				ifFalse: 
					[session operation: op.
					^self]]!

onDropOverArena: session 
	"Private - The drag operation described by the <DragDropSession>, session, has 
	culminated in a drop over the arena, which we handle here."

	| dropObject dropTarget dropPosition pastee |
	dropObject := session dragObjects first.
	dropTarget := self dropTargetFromSession: session.
	dropTarget = self arena ifTrue: [dropTarget := View desktop].
	dropPosition := View desktop mapPoint: session dragPoint to: self arena.
	dropPosition := self mapPoint: dropPosition toViewFromArena: dropTarget.
	"dropPosition := session dragPointInView: dropTarget."
	(session isCopy or: [session isMove]) 
		ifTrue: 
			[(dropObject isFormatAvailable: #ResourceIdentifier) 
				ifTrue: 
					[pastee := dropObject format: #ResourceIdentifier.
					self 
						dropViewResource: pastee resource
						onto: dropTarget
						at: dropPosition
						named: nil]
				ifFalse: 
					[pastee := dropObject object.
					self 
						dropView: pastee
						onto: dropTarget
						at: dropPosition]].
	session isLink
		ifTrue: 
			[pastee := dropObject format: #ResourceIdentifier.
			self 
				pasteResourceLink: pastee
				context: dropTarget
				position: dropPosition].
	session suggestedTarget notNil ifTrue: [self invalidateAdornmentFor: session suggestedTarget]!

onDropOverHierarchy: session 
	"Private - The drag operation described by the <DragDropSession>, session,
	would like to do a drop."

	| parent ok position |
	(parent := session suggestedTarget) notNil 
		ifFalse: 
			[session resetOperation.
			Sound errorBeep.
			^self].
	position := self dropIncrement.
	ok := false.
	session dragObjects do: 
			[:dropObject | 
			(dropObject isObjectKindAvailable: View) 
				ifTrue: 
					["A view has been dropped onto the receiver"
					ok := self 
								dropView: dropObject object
								onto: parent
								at: dropObject object position].
			(dropObject isFormatAvailable: #ResourceIdentifier) 
				ifTrue: 
					["A view resource has been dropped onto the receiver"
					| rid |
					rid := dropObject format: #ResourceIdentifier.
					session isCopy 
						ifTrue: 
							[self 
								dropViewResource: rid resource
								onto: parent
								at: position
								named: nil.
							ok := true].
					session isLink
						ifTrue: 
							[| dropee |
							dropee := ReferenceView resourceIdentifier: rid.
							ok := self 
										dropView: dropee
										onto: parent
										at: position].

					"Bump position"
					position := position + self dropIncrement].

			"Terminate early if operation fails"
			ok 
				ifFalse: 
					[session resetOperation.
					^self]]!

onHierarchySelection
	"Private - The selection has changed in the view hierarchy presenter so
	alter the primary selection"

	self isMouseClick 
		ifFalse: 
			[| v |
			v := viewHierarchyPresenter selectionOrNil.
			v isNil ifTrue: [self cancelSelections] ifFalse: [self selection: v]].
	inspector model: primarySelection.
	self refreshImage!

onIdleEntered
	"Private - Idle has been entered. Ensure the adornment is displayed correctly"

	super onIdleEntered.
	self isOpen
		ifTrue: 
			[self validateImage.
			self validateAdornment]!

onImageSaveCompleted
	self ownsComposingView 
		ifTrue: 
			["Show the composing view that was hidden before image save. Note, if we
			 don't do this then the VC will *appear* to work but all the non-client
			 detail of views (i.e borders) will disappear (#2291)"
			self composingView show]!

onImageSaveStarting
	"Save the current state of the receiver so it can be restored on image restart"

	self ownsComposingView 
		ifTrue: 
			["Hide the composing view so it doesn't try to appear or interfere with the task bar when the image is reloaded"
			self composingView hide]!

onInspecteeChanged
	"Private - The primary selection (i.e. the view being inspected) has been updated.
	Refresh the receiver appropriately. We also create a dummy command that can be
	added to the command history so that the change can be undone/redone."

	viewHierarchyPresenter model refresh: self primarySelection.
	self isModified: true!

onPromptToSaveChanges: aBooleanValue 
	"Private - Check to see if the composing view has been changed. 
	If so prompt to see if the changes should be retained and if they should then
	set the value of the out parameter, aBooleanValue, to false"

	self isModified 
		ifTrue: 
			[((MessageBox new)
				owner: self view;
				confirm: 'There are unsaved changes. Do you wish to retain them?') 
					ifTrue: [aBooleanValue value: false]
					ifFalse: [self isModified: false]].
	^aBooleanValue value!

onRequestDropOpsForShield: session
	"Private - An extended drop has been initiated over the shield by the <DragDropSession>,
	session. Specify the set of permitted drop operations."

	session supportedOperations: #(copy link)!

onSelectionPositioned: aPositionEvent 
	"Private - The selection has been resized or moved.
	Refresh the receiver appropriately"

	| updatedAspect |
	aPositionEvent isMove ifTrue: [updatedAspect := #position].
	aPositionEvent isResize ifTrue: [updatedAspect := #extent].
	updatedAspect notNil ifTrue: [[inspector aspectChanged: updatedAspect] postToMessageQueue].
	self updateAdornment!

onSessionStarted
	"Reassert the composingView to ensure the viewHierarchyPresenter state is refreshed"
	
	[
	"Fix for #2261, where the VC was not correctly allowing views to be edited after image
	restart. Here we need to ensure that the view hierarchy tree pane is refreshed."
	self composingView: self composingView isOwned: self ownsComposingView.

	self ownsComposingView 
		ifTrue: 
			["Show the composing view that was hidden before image save. Note, if we
			 don't do this then the VC will *appear* to work but all the non-client
			 detail of views (i.e borders) will disappear (#2291)"
			self composingView show]] 
			postToInputQueue!

onSettingChanged: aWindowEvent 
	adornmentRegion := nil.
	^super onSettingChanged: aWindowEvent!

onViewClosed
	viewHierarchyPresenter removeEventsTriggeredFor: self.
	self closeComposingView.
	super onViewClosed!

onViewOpened
	"Private - The receiver has just been connected to its view.
	Now we also connect locate the shield and arena subViews."

	| myView |
	super onViewOpened.
	self arena composer: self.
	myView := self view.
	status := ValueHolder new.
	(myView viewNamed: 'positionStatus') model: status.
	(myView viewNamed: 'extentStatus') model: status.
	modificationStatus := ValueHolder new.
	(myView viewNamed: 'modificationStatus') model: modificationStatus.
	self adjustScroll.
!

openOn: aResourceIdentifier 
	"Private - Open the ViewResource identified by aResourceIdentifier for editing and record its
	identity so we know how to save it back."

	| position |
	self viewClose ifFalse: [^self].
	aResourceIdentifier resource isNil 
		ifTrue: [^self error: 'Unable to load ' , aResourceIdentifier printString].
	position := self pasteContext == View desktop 
				ifTrue: [self initialComposingPosition]
				ifFalse: [self incrementAddPositionOffset].
	"Pretend performing an undo/redo operation to suppress capture of undo history"
	self performUndoRedo: [
		self 
			pasteResource: aResourceIdentifier resource
			context: self pasteContext
			position: position].

	"The paste will have set the modified flag. We clear it here,
	because we know the view has simply been opened."
	self isModified: false.
	self clearUndoState.
	resourceIdentifier := aResourceIdentifier.
	self
		updateCaption;
		setInitialFocus;
		validateImage!

openOnCopyOf: aResourceIdentifier 
	"Private - Open the ViewResource identified by aResourceIdentifier for editing but don't save
	this identifier so that we are effectively editing a copy. Not that this is subtly different from
	#openOn:"

	self openOn: aResourceIdentifier.
	resourceIdentifier := aResourceIdentifier copy.
	resourceIdentifier name: nil!

ownsComposingView
	^ownsComposingView!

pasteClipboard
	"Pastes the DragDropObject(s) held on the clipboard into the primary selection."

	| pasteContext |
	pasteContext := self pasteContext.
	self clipboard do: 
			[:each | 
			| data |
			data := (each isFormatAvailable: #STLViewResource) 
						ifTrue: [each format: #STLViewResource]
						ifFalse: [(each isFormatAvailable: #STBViewResource) ifTrue: [each format: #STBViewResource]].
			data notNil 
				ifTrue: 
					[self 
						pasteResource: data
						context: pasteContext
						position: self incrementAddPositionOffset]]!

pasteContext
	"Private - Answers the context where the object on the clipboard should be pasted."

	^self composingView isNil 
		ifTrue: [View desktop]
		ifFalse: [self primarySelection isNil ifTrue: [self composingView] ifFalse: [self primarySelection]]!

pastedView: aView context: contextView 
	"Private - aView has been pasted into contextView.
	Perform post-paste operations."

	aView show.
	contextView == View desktop 
		ifTrue: [self composingView: aView isOwned: true]
		ifFalse: 
			[contextView validateLayout.
			viewHierarchyPresenter model add: aView asChildOf: aView parentView].

	"Both the context and the view under composition may need laying out"
	self forceLayoutFor: contextView.
	self selection: aView.
	self drawAdornment.
!

pasteResource: aResourceArray context: contextView position: aPoint 
	"Private - Paste the view realized from anSTLArray into contextView at position aPoint.
	Answers the pasted View."

	| pastedView |
	pastedView := self basicPasteResource: aResourceArray context: contextView.
	pastedView position: (self snapPoint: aPoint context: contextView).
	self pastedView: pastedView context: contextView.
	^pastedView!

pasteResourceLink: aLiteralResourceIdentifier context: contextView position: aPoint 
	"Private - Paste arefernces to the view indicated by aLiteralResourceIdentifier into
	contextView at position aPoint. Answers the pasted View."

	| pastedView |
	pastedView := self basicPasteResourceLink: aLiteralResourceIdentifier context: contextView.
	pastedView position: (self snapPoint: aPoint context: contextView).
	self pastedView: pastedView context: contextView.
	^pastedView!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result"

	| result |
	self eraseAdornment.
	result := super performCommand: aCommand.
	self isOpen
		ifTrue: 
			[self validateLayout.
			self drawAdornment].
	^result!

performUndoRedo: aNiladicValuable
	vcFlags := vcFlags maskSet: UndoRedoFlag.
	aNiladicValuable ensure: [vcFlags := vcFlags maskClear: UndoRedoFlag]!

primarySelection
	"Private - Answer the primary selection or nil if there is none."

	^primarySelection!

primarySelection: aViewOrNil 
	"Private - Set the primary selection to aViewOrNil."

	primarySelection == aViewOrNil 
		ifFalse: 
			["The selection has changed"

			"First remove event triggers for the old selection"
			primarySelection removeEventsTriggeredFor: self.
			primarySelection := aViewOrNil.
			primarySelection notNil 
				ifTrue: 
					[primarySelection 
						when: #positionChanged:
						send: #onSelectionPositioned:
						to: self].
			self removeGrabbers.
			self addGrabbers.
			self resetAddPositionOffset.
			primarySelection notNil 
				ifTrue: 
					["Update the viewHierarchy."
					primarySelection ensureVisible.
					viewHierarchyPresenter selection: primarySelection]]!

printShortCaptionOn: aWriteStream 
	self hasComposingView 
		ifTrue: 
			[resourceIdentifier isNil 
				ifTrue: [aWriteStream nextPutAll: 'untitled']
				ifFalse: [aWriteStream display: resourceIdentifier]]
		ifFalse: [aWriteStream nextPutAll: self basicCaption]!

queryCommand: aCommandQuery 
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery> argument."

	| command |
	command := aCommandQuery commandSymbol.
	(#(#copySelection #mutate #toggleGroupStop #toggleTabStop #decreaseHeight #decreaseWidth #increaseWidth #increaseHeight) 
		identityIncludes: command) 
			ifTrue: 
				[aCommandQuery isEnabled: self hasSelection.
				^true].
	(#(#cutSelection #clearSelection) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self hasSelection.
			^true].
	(#(#nudgeLeft #nudgeRight #nudgeUp #nudgeDown #centerHorizontally #centerVertically) 
		identityIncludes: command) 
			ifTrue: 
				[aCommandQuery isEnabled: self hasMoveableSelection.
				^true].
	(#(#fileSave #viewSave) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: (self hasComposingView and: [self hasResource]).
			^true].
	#viewRevert == command 
		ifTrue: 
			[aCommandQuery isEnabled: (self hasComposingView and: [self hasResource]).
			^true].
	(#(#referenceViewMenu #dereference #editReference) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: (self primarySelection isKindOf: ReferenceView).
			^true].
	(#(#viewExport #viewSaveAs #viewClose #viewTest) includes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self hasComposingView.
			^true].
	(#(#zFront #zForward #zBackward #zBack) identityIncludes: command) 
		ifTrue: 
			[aCommandQuery isEnabled: self primarySelection notNil.
			^true].
	#widenSelection == command 
		ifTrue: 
			[| selected |
			selected := self primarySelection.
			aCommandQuery isEnabled: (selected notNil and: [selected ~~ self composingView]).
			^true].
	(#(#matchWidths #matchHeights #matchSizes #matchFonts #matchForegroundColors #matchBackgroundColors #alignLefts #alignMiddles #alignRights #alignTops #alignCenters #alignBottoms) 
		identityIncludes: command) 
			ifTrue: 
				[aCommandQuery isEnabled: self selections size > 1.
				^true].
	(#(#distributeHorizontally #distributeVertically #removeHorizontalGaps #removeVerticalGaps #increaseHorizontalGaps #decreaseHorizontalGaps #increaseVerticalGaps #decreaseVerticalGaps) 
		includes: command) 
			ifTrue: 
				[aCommandQuery isEnabled: (self selections size > 1 
							and: [(self selections collect: [:each | each parentView]) asSet size = 1]).
				^true].
	command == #editMenuBar 
		ifTrue: 
			[aCommandQuery isEnabled: (self composingView class conformsToProtocol: #topView).
			^true].
	command == #editContextMenu 
		ifTrue: 
			[aCommandQuery isEnabled: self primarySelection notNil.
			^true].
	command == #viewUndo 
		ifTrue: 
			[aCommandQuery isEnabled: undoList hasPast.
			^true].
	command == #viewRedo 
		ifTrue: 
			[aCommandQuery isEnabled: undoList hasFuture.
			^true].
	command == #toggleTabStop 
		ifTrue: 
			[self hasSelection 
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						isChecked: (self selections detect: [:v | v isTabStop not] ifNone: []) isNil].
			^true].
	command == #toggleGroupStop 
		ifTrue: 
			[self hasSelection 
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						isChecked: self primarySelection isGroupStop].
			^true].
	command == #pasteClipboard 
		ifTrue: 
			[aCommandQuery isEnabled: self canPaste.
			^true].
	^super queryCommand: aCommandQuery!

refreshImage
	" Re-render the composing view and display it in the arenaPresenter."

	self isImageDirty: true!

refreshPublishedAspects
	inspector refresh!

removeGrabbers
	"Private - Destroy all the grabbers"

	grabbers
		ifNotNil: 
			[grabbers do: [:each | each invalidate].
			grabbers := nil]!

removeHorizontalGaps
	"Remove any vertical spacing between the selected controls."

	| distributees first |
	distributees := self selectionsByHorizontalPosition.
	first := true.
	distributees inject: 0
		into: 
			[:x :each | 
			first ifTrue: [first := false] ifFalse: [self repositionView: each to: x @ each y].
			each rectangle right]!

removeVerticalGaps
	"Remove any vertical spacing between the selected controls."

	| distributees first |
	distributees := self selectionsByVerticalPosition.
	first := true.
	distributees inject: 0
		into: 
			[:y :each | 
			first ifTrue: [first := false] ifFalse: [self repositionView: each to: each x @ y].
			each rectangle bottom]!

removeView: aView 
	"Private - Removes aView from the receiver."

	aView == self composingView ifTrue: [^self endComposition].
	(self selections includes: aView) 
		ifTrue: 
			[self cancelSelectionFor: aView.
			self primarySelection isNil 
				ifTrue: [aView ~~ self composingView ifTrue: [self selection: aView parentView]]].
	viewHierarchyPresenter model remove: aView.
	aView parentView removeSubView: aView.
	self forceLayoutFor: aView parentView!

repositionView: each to: positionInParent 
	| parentLayoutManager |
	parentLayoutManager := each parentView layoutManager.
	parentLayoutManager isNil 
		ifTrue: 
			[each
				position: positionInParent;
				invalidate]
		ifFalse: 
			[parentLayoutManager reposition: each to: positionInParent.
			#todo.	"Don't think this should be necessary - reposition:to: should already do this"
			parentLayoutManager layoutContainer: each parentView].
	self setModified!

resetAddPositionOffset
	"Private - Resets the position offset within a parent where
	a new child view should be added. Answers the new position"
	
	^addPositionOffset := Point new.

!

resizeBy: aPoint 
	self selections do: [:each | self resizeView: each to: each extent + aPoint]!

resizeView: aView to: aPoint 
	| parent |
	parent := aView parentView.
	parent layoutManager 
		ifNil: [aView extent: aPoint]
		ifNotNil: 
			[:layoutManager | 
			| rect |
			rect := aView rectangle.
			layoutManager resize: aView to: (rect origin extent: aPoint)].
	parent validateLayout.
	self setModified!

resourceIdentifier
	"Answers the ResourceIdentifier of the current view under composition"

	^resourceIdentifier.!

resourceIdentifier: aLiteralResourceIdentifier 
	resourceIdentifier := aLiteralResourceIdentifier.
	self updateCaption!

resourceManager
	"Answers the instance of ResourceManager with which we are associated."

	^SessionManager current resourceManager!

restoreComposition: viewResource 
	"self endComposition."
	self 
		pasteResource: viewResource
		context: self pasteContext
		position: self incrementAddPositionOffset!

restoreUndoState: aLiteralStoreArray
	self inspector view noRedrawDo: 
			[| state |
			self arena noRedrawDo: 
					[| restoredView |
					self endComposition.
					state := self systemModel loadViewResource: aLiteralStoreArray inContext: View desktop.
					restoredView := state at: 1.
					self composingView: restoredView isOwned: restoredView notNil.
					restoredView ifNotNil: [restoredView hasVisibleStyle: true].
					self selections: (state at: 2)].
			self aspectAccessor: (state at: 3)]!

safetyWrap: aBlock
	"Private - Executes aBlock which may cause some aspect of the adornment to change.
	We wrap the block inside some safe redrawing of the adornment"

	aBlock value.
	self setModified.
	self updatePrimarySelection.
	self updateAdornment.

!

saveAdornmentRegion
	"Private - Make a note of the selection region in case we have to invalidate it later"

	adornmentRegion := self getAdornmentRegion.
!

saveStateOn: aWriteStream 
	"Private - Write the source of a monadic block that will configure an instance of the receiver's class
	to match the state current receiver, to aWriteStream. The block expects a fresh instance of
	the receiver's class as it's parameter"

	aWriteStream nextPutAll: '[ :aViewComposer | aViewComposer openOn: '.
	self resourceIdentifier literalStoreEvaluationOn: aWriteStream.
	aWriteStream
		nextPut: $.;
		cr.
	super saveStateOn: aWriteStream.
	aWriteStream nextPutAll: ' value: aViewComposer.'.
	aWriteStream nextPutAll: ']'!

saveUndoState
	self isUndoRedoInProgress ifTrue: [^self].
	undoList addLast: self undoState!

secondarySelections
	"Private - Answer a collection of selected views that doesn't contain
	the primary selection"

	^self selections reject: [:each | each==self primarySelection]
	!

selectAll
	self selections: viewHierarchyPresenter model asOrderedCollection!

selection: aView
	"Private - Sets the primary (and only selection) to be aView"

	"If this view is already the primary and only selection then do nothing."
	(self primarySelection == aView and: [ self selections size = 1 ]) ifTrue: [
		^self ].
	self cancelSelections.
	self addSelectionFor: aView !

selections
	"Private - Answer an OrderedCollection of selections within the receiver's jurisdiction"

	^selections

!

selections: anOrderedCollection 
	"Private - Sets the current selections from an OrderedCollection of views
	within the receiver's jurisdiction"

	| wasClick |
	self cancelSelections.
	anOrderedCollection do: [:each | self selections addLast: each].
	"The mouse click flag is used to suppress some of the response to selection in the view
	hierarchy tree, which we must do as otherwise selection of the first element in the
	collection in the tree will result in all other selections being discarded."
	wasClick := self isMouseClick.
	
	[self isMouseClick: true.
	self updatePrimarySelection] ensure: [self isMouseClick: wasClick]!

selectionsByHorizontalPosition
	^self selections asSortedCollection: [:a :b | a x < b x]!

selectionsByVerticalPosition
	^self selections asSortedCollection: [:a :b | a y < b y]!

setModified
	"Private - Sets the modification flag for the receiver"

	self isModified: true!

shortCaption
	| stream |
	stream := String smalltalkWriteStream: 32.
	self printShortCaptionOn: stream.
	^stream contents!

slideyPinNames
	^super slideyPinNames , #('toolsSlidey' 'toolbarsSlidey' 'inspectorSlidey')!

snapPoint: aPoint context: contextView
	"Private - Answers an instance of Point which is aPoint snapped
	to the grid. Both the argument aPoint and the answer are in the
	coordinate space of the argument contextView."

	^self arena
		mapPoint: (self constrainPoint: (contextView
			mapPoint: aPoint
			to: self arena))
		to: contextView.
!

startTrackingAt: pointOffset
	"Private - Start selection tracking at pointOffset. Part of the <MouseTracker> 
	target protocol. Answers the actual position achieved after any  
	constraints have been applied"

	self eraseAdornment.
	Cursor sizeAll setCursor.
	self drawTrackingAt: pointOffset.
	^pointOffset!

status
	"Private - Answer the receiver's status model."

	^status
!

toggleGroupStop
	"Toggles the WS_GROUP style of the selected items."

	| gs |
	gs := self primarySelection isGroupStop not.
	self selections do: [ :v | v isGroupStop: gs ].
!

toggleSelectionFor: aView
	"Private - Toggles the selection state for aView"

	(self selections includes: aView) 
		ifTrue: [ self cancelSelectionFor: aView ]
		ifFalse: [ self addSelectionFor: aView ]

!

toggleTabStop
	"Toggles the WS_TABSTOP style of the selected items."

	| ts |
	ts := self primarySelection isTabStop not.
	self selections do: [ :v | v isTabStop: ts ].
!

trackGrabber: aGrabber from: aScreenPoint
	"Private - Track aGrabber which has been hit with the mouse at aScreenPoint."

	self eraseAdornment.
	aGrabber cursor setCursor.
	aGrabber trackMouseFrom: aScreenPoint.
	(aGrabber view == self composingView) ifTrue: [
		self adjustScroll ].
	self updateAdornment.
	self setModified.
!

undoState
	| stateBlock |
	stateBlock := [{self composingView. selections. self aspectAccessor} literalStoreArray].
	^self composingView ifNil: [stateBlock value] ifNotNil: [:v | v whileInvisibleDo: stateBlock]!

updateAdornment
	"Private - Update the adornment of the current selections"

	self isAdornmentModified: true
!

updateCaption
	"Private - The receiver has changed in such a way that the caption
	may need to be refreshed."

	| stream |
	stream := String smalltalkWriteStream: 128.
	self printShortCaptionOn: stream.
	self composingView
		ifNotNil: 
			[:cv |
			stream
				nextPut: $(;
				display: cv class;
				nextPut: $)].
	self caption: stream contents!

updatePrimarySelection
	"Private - The primary selection may have changed. Update it if necessary."

	| actualPrimarySelection |
	actualPrimarySelection := self selections notEmpty ifTrue: [self selections first ].
	self primarySelection: actualPrimarySelection!

validateAdornment
	self isAdornmentModified ifFalse: [^self].
	self eraseAdornment.
	self drawAdornment.
	self primarySelection notNil
		ifTrue: 
			[| rect |
			rect := self primarySelection rectangle.
			self primarySelection = self composingView ifTrue: [rect moveBy: self hidingOffset negated].
			status value: rect].
	self isAdornmentModified: false!

validateImage
	"Private - Re-render the composing view and display it in the arenaPresenter."

	((image notNil and: [image handle isNull]) or: [self isImageDirty]) ifFalse: [^self].
	self isImageDirty: false.
	image := self composingView notNil
				ifTrue: [Bitmap fromView: self composingView background: self arena actualBackcolor brush].
	arenaPresenter value: image!

validateLayout
	"Private - Validate the layout for the view being composed"

	self composingView notNil ifTrue: [
		self composingView validateLayout ]
!

validateUserInterface
	"Private - Validates the user interface for the receiver. Usually performed at idle time when the UI
	has been flagged as being invalid."

	| myView |
	myView := self view.
	myView validateUserInterface.
	self hasComposingView 
		ifTrue: [self composingView needsValidateLayout ifTrue: [self composingView validateLayout]]!

viewClose
	"Close the view being composed by the receiver"

	"Are there outstanding changes?"

	(self onPromptToSaveChanges: true asValue) ifFalse: [^false].
	self viewCloseNoPrompt.
	^true!

viewCloseNoPrompt
	self composingView notNil ifTrue: [self endComposition].
	resourceIdentifier := nil.
	self
		updateCaption;
		adjustScroll!

viewExport
	"Saves the view being composed to a file selected by the user."

	| filename path |
	path := self hasResource ifTrue: [resourceIdentifier exportedFileName].
	filename := (FileSaveDialog new)
				fileTypes: #(#('View Files (*.vu)' '*.vu'));
				value: path;
				defaultExtension: '*.vu';
				showModal.
	filename isNil ifTrue: [^nil].
	self viewExportTo: filename!

viewExportTo: filename 
	self composingView binaryStoreOn: (FileStream write: filename text: false)!

viewHierarchyPresenter
	^viewHierarchyPresenter!

viewHitBy: aPoint 
	"Private - Answers the view that can be hit by a mouse action at aPoint. "

	| viewHit |
	self primarySelection notNil 
		ifTrue: 
			[| lookInView |
			lookInView := self primarySelection.
			
			[| position |
			position := View desktop mapPoint: aPoint + self hidingOffset - self defaultComposingPosition
						to: lookInView.
			viewHit := lookInView subViewFromPoint: position.
			lookInView := lookInView parentView.
			viewHit isNil and: [lookInView ~~ View desktop]] 
					whileTrue].
	self hasComposingView ifFalse: [^nil].
	(viewHit isNil and: [(0 @ 0 corner: self composingView extent) containsPoint: aPoint]) 
		ifTrue: [viewHit := self composingView].
	^viewHit!

viewImport
	"Load the ViewResource from a file selected by the user."

	| filename |
	filename := (FileOpenDialog new)
				fileTypes: #(#('View Files (*.vu)' '*.vu'));
				showModal.
	filename isNil ifTrue: [^nil].
	self viewImportFrom: filename!

viewImportFrom: filename 
	| viewResource |
	viewResource := (FileStream read: filename text: false) contents.
	self 
		pasteResource: viewResource
		context: self pasteContext
		position: self incrementAddPositionOffset.
	self updateCaption!

viewOpen
	"Prompt for a ViewResource and open it"

	self viewClose 
		ifTrue: 
			[| rid viewResources |
			viewResources := self allResourceIdentifiers asSortedCollection.
			(rid := ChoicePrompter choices: viewResources caption: 'Open') notNil ifTrue: [self openOn: rid]]!

viewRedo
	self performUndoRedo: [self restoreUndoState: (undoList goForward: 1)]!

viewRevert
	"Revert the contents of the receiver's document to those in the
	associated file"

	| rid |
	rid := resourceIdentifier.
	(MessageBox confirm: 'Are you sure you wish to revert to the previously saved copy?') ifTrue: [ 
		self endComposition; openOn: rid ].!

viewSave
	"Save the view as a resource."

	self hasResource ifFalse: [^self viewSaveAs].
	self resourceIdentifier assign: self composingView literalStoreArray.
	self isModified: false!

viewSaveAs
	"Save the composed view as a resource."

	| rid |
	resourceIdentifier isNil
		ifTrue: [rid := ResourceIdentifier class: Presenter name: Presenter defaultView]
		ifFalse: 
			[rid := resourceIdentifier copy.
			rid name isNil ifTrue: [rid name: Presenter defaultView]].
	(rid := rid prompt) isNil ifTrue: [^false].
	rid exists
		ifTrue: 
			[| message |
			message := '''<1d>'' is an existing resource. Do you wish to replace it?' expandMacrosWith: rid.
			(MessageBox confirm: message) ifFalse: [^false]].
	self resourceIdentifier: rid.
	self
		updateCaption;
		fileSave!

viewTest
	"Load the resource (being edited by the ViewComposer) in a test mode."

	| testView parentView |
	parentView := (self composingView isKindOf: ShellView) 
				ifTrue: [View desktop]
				ifFalse: 
					[(ShellView show)
						layoutManager: GridLayout new;
						yourself].
	testView := Object fromLiteralStoreArray: (self composingView literalStoreArray) context: parentView.
	testView show!

viewUndo
	self performUndoRedo: [self restoreUndoState: (undoList goBack: 1)]!

widenSelection
	"Widen the selection to encompass the parent of the current primary selection."

	self primarySelection == self composingView ifTrue: [^self].
	self selection: self primarySelection parentView!

zBack
	"Send the primary selection to the back of the Z-order."

	| editee |
	editee := self primarySelection.
	editee zOrderBottom.
	self zOrderChangedFor:  editee.
!

zBackward
	"Move the primary selection down one place in the Z-order."

	| nextSibling editee |
	editee := self primarySelection.
	nextSibling := editee nextSiblingView.
	nextSibling notNil ifTrue:
		[editee zOrderAfter: nextSibling].
	self zOrderChangedFor:  editee.
!

zForward
	"Move the primary selection up one place in the Z-order."

	| sibling editee |

	"We can only Zposition a view AFTER a specified sibling.
	So, locate the sibling two places in front and Zposition
	the receiver after it."
	editee := self primarySelection.
	sibling := editee previousSiblingView.
	sibling notNil ifTrue:
		[sibling := sibling previousSiblingView.
		sibling notNil ifTrue:
			[editee zOrderAfter: sibling]].

	sibling isNil ifTrue:
		[editee zOrderTop].

	self zOrderChangedFor:  editee!

zFront
	"Bring the primary selection to the front of the Z-order."

	| editee |
	editee := self primarySelection.
	editee zOrderTop.
	self zOrderChangedFor:  editee.
!

zOrderChangedFor: aView 
	"Private - The ZOrder position of aView has been changed. Inform the 
	view hierarchy model so that its views update appropriately"

	viewHierarchyPresenter model move: aView asChildOf: (viewHierarchyPresenter model parentOf: aView)! !
!Tools.ViewComposer categoriesFor: #addGrabberFor:of:!adornments!private! !
!Tools.ViewComposer categoriesFor: #addGrabbers!adornments!private! !
!Tools.ViewComposer categoriesFor: #addSelectionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #adjustScroll!geometry!private! !
!Tools.ViewComposer categoriesFor: #adornmentRectanglesFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #adornmentRectanglesFor:do:!adornments!private! !
!Tools.ViewComposer categoriesFor: #adornmentRegion!adornments!private! !
!Tools.ViewComposer categoriesFor: #adornmentRegionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #alignBottoms!commands!public! !
!Tools.ViewComposer categoriesFor: #alignCenters!commands!public! !
!Tools.ViewComposer categoriesFor: #alignLefts!commands!public! !
!Tools.ViewComposer categoriesFor: #alignMiddles!commands!public! !
!Tools.ViewComposer categoriesFor: #alignRights!commands!public! !
!Tools.ViewComposer categoriesFor: #alignTops!commands!public! !
!Tools.ViewComposer categoriesFor: #allResourceIdentifiers!public! !
!Tools.ViewComposer categoriesFor: #areDragObjects:acceptableFor:inView:!drag & drop!private! !
!Tools.ViewComposer categoriesFor: #arena!accessing!private! !
!Tools.ViewComposer categoriesFor: #arenaBorderSize!constants!private! !
!Tools.ViewComposer categoriesFor: #arenaLeftButtonPressed:!event handling!private! !
!Tools.ViewComposer categoriesFor: #arenaMouseMoved:!private! !
!Tools.ViewComposer categoriesFor: #aspectAccessor!public! !
!Tools.ViewComposer categoriesFor: #aspectAccessor:!public! !
!Tools.ViewComposer categoriesFor: #basicCaption!accessing!private! !
!Tools.ViewComposer categoriesFor: #basicPasteResource:context:!operations!private! !
!Tools.ViewComposer categoriesFor: #basicPasteResourceLink:context:!private! !
!Tools.ViewComposer categoriesFor: #borderRectanglesFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #borderRegionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #browseIt!commands!public! !
!Tools.ViewComposer categoriesFor: #calculatePositionOf:offsetBy:!adornments!private! !
!Tools.ViewComposer categoriesFor: #cancelSelectionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #cancelSelections!adornments!private! !
!Tools.ViewComposer categoriesFor: #cancelTrackingAt:!private!tracking! !
!Tools.ViewComposer categoriesFor: #canMove:!private!testing! !
!Tools.ViewComposer categoriesFor: #canPaste!private!testing! !
!Tools.ViewComposer categoriesFor: #canSaveState!private!saved state! !
!Tools.ViewComposer categoriesFor: #canSize:!private!testing! !
!Tools.ViewComposer categoriesFor: #centerHorizontally!commands!private! !
!Tools.ViewComposer categoriesFor: #centerVertically!commands!private! !
!Tools.ViewComposer categoriesFor: #chooseBackgroundColor!commands!public! !
!Tools.ViewComposer categoriesFor: #chooseFont!commands!public! !
!Tools.ViewComposer categoriesFor: #chooseForegroundColor!commands!public! !
!Tools.ViewComposer categoriesFor: #clearSelection!commands!public! !
!Tools.ViewComposer categoriesFor: #clearUndoState!operations!private! !
!Tools.ViewComposer categoriesFor: #clipboard!accessing!public! !
!Tools.ViewComposer categoriesFor: #closeComposingView!helpers!private! !
!Tools.ViewComposer categoriesFor: #composingView!accessing!public! !
!Tools.ViewComposer categoriesFor: #composingView:isOwned:!accessing!private! !
!Tools.ViewComposer categoriesFor: #constrainPoint:!geometry!private! !
!Tools.ViewComposer categoriesFor: #constrainRectangle:!geometry!private! !
!Tools.ViewComposer categoriesFor: #continueTrackingAt:from:!private!tracking! !
!Tools.ViewComposer categoriesFor: #copyAspectsFrom:to:!operations!private! !
!Tools.ViewComposer categoriesFor: #copySelection!commands!public! !
!Tools.ViewComposer categoriesFor: #createComponents!initializing!private! !
!Tools.ViewComposer categoriesFor: #createGrabberFor:of:!adornments!private! !
!Tools.ViewComposer categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.ViewComposer categoriesFor: #createViewHierarchyModel!helpers!initializing!private! !
!Tools.ViewComposer categoriesFor: #cursor!accessing!public! !
!Tools.ViewComposer categoriesFor: #cursorAt:!helpers!private! !
!Tools.ViewComposer categoriesFor: #cutSelection!commands!public! !
!Tools.ViewComposer categoriesFor: #decreaseHeight!commands!public! !
!Tools.ViewComposer categoriesFor: #decreaseHorizontalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #decreaseVerticalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #decreaseWidth!commands!public! !
!Tools.ViewComposer categoriesFor: #defaultComposingPosition!constants!private! !
!Tools.ViewComposer categoriesFor: #defaultGridResolution!constants!private! !
!Tools.ViewComposer categoriesFor: #defaultHelpId!public! !
!Tools.ViewComposer categoriesFor: #defaultSelectionWidth!constants!private! !
!Tools.ViewComposer categoriesFor: #deleteSelections!commands!public! !
!Tools.ViewComposer categoriesFor: #dereference!commands!private! !
!Tools.ViewComposer categoriesFor: #distributeHorizontally!commands!public! !
!Tools.ViewComposer categoriesFor: #distributeVertically!commands!public! !
!Tools.ViewComposer categoriesFor: #drawAdornment!adornments!private! !
!Tools.ViewComposer categoriesFor: #drawSelectionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #drawTrackingAt:!adornments!private! !
!Tools.ViewComposer categoriesFor: #dropIncrement!constants!private! !
!Tools.ViewComposer categoriesFor: #dropTargetFromSession:!drag & drop!private! !
!Tools.ViewComposer categoriesFor: #dropUndoState!operations!private! !
!Tools.ViewComposer categoriesFor: #dropView:onto:at:!drag & drop!private! !
!Tools.ViewComposer categoriesFor: #dropViewResource:onto:at:named:!drag & drop!private! !
!Tools.ViewComposer categoriesFor: #editContextMenu!commands!public! !
!Tools.ViewComposer categoriesFor: #editMenuBar!commands!public! !
!Tools.ViewComposer categoriesFor: #editReference!commands!private! !
!Tools.ViewComposer categoriesFor: #endComposition!commands!public! !
!Tools.ViewComposer categoriesFor: #endTrackingAt:!private!tracking! !
!Tools.ViewComposer categoriesFor: #eraseAdornment!adornments!private! !
!Tools.ViewComposer categoriesFor: #eraseTrackingAt:!adornments!private! !
!Tools.ViewComposer categoriesFor: #fileNew!commands!public! !
!Tools.ViewComposer categoriesFor: #fileOpen!commands!public! !
!Tools.ViewComposer categoriesFor: #fileSave!commands!public! !
!Tools.ViewComposer categoriesFor: #forceLayoutFor:!geometry!private! !
!Tools.ViewComposer categoriesFor: #getAdornmentRegion!adornments!private! !
!Tools.ViewComposer categoriesFor: #grabberHitBy:!adornments!private! !
!Tools.ViewComposer categoriesFor: #grabbers!adornments!private! !
!Tools.ViewComposer categoriesFor: #grid!accessing!private! !
!Tools.ViewComposer categoriesFor: #grid:!accessing!private! !
!Tools.ViewComposer categoriesFor: #gridSetting!commands!private! !
!Tools.ViewComposer categoriesFor: #hasClipboard!private!testing! !
!Tools.ViewComposer categoriesFor: #hasComposingView!private!testing! !
!Tools.ViewComposer categoriesFor: #hasMoveableSelection!private!testing! !
!Tools.ViewComposer categoriesFor: #hasOwnedComposingView:!public! !
!Tools.ViewComposer categoriesFor: #hasPreferredExtent!public!testing! !
!Tools.ViewComposer categoriesFor: #hasResource!private!testing! !
!Tools.ViewComposer categoriesFor: #hasSelection!private!testing! !
!Tools.ViewComposer categoriesFor: #hidingOffset!constants!private! !
!Tools.ViewComposer categoriesFor: #increaseHeight!commands!public! !
!Tools.ViewComposer categoriesFor: #increaseHorizontalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #increaseVerticalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #increaseWidth!commands!public! !
!Tools.ViewComposer categoriesFor: #incrementAddPositionOffset!operations!private! !
!Tools.ViewComposer categoriesFor: #initialComposingPosition!constants!private! !
!Tools.ViewComposer categoriesFor: #initialize!initializing!private! !
!Tools.ViewComposer categoriesFor: #inspector!accessing!private! !
!Tools.ViewComposer categoriesFor: #inspectSelection!commands!public! !
!Tools.ViewComposer categoriesFor: #invalidateAdornmentFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #isAdornmentModified!operations!private! !
!Tools.ViewComposer categoriesFor: #isAdornmentModified:!operations!private! !
!Tools.ViewComposer categoriesFor: #isImageDirty!private! !
!Tools.ViewComposer categoriesFor: #isImageDirty:!private! !
!Tools.ViewComposer categoriesFor: #isModified!public!testing! !
!Tools.ViewComposer categoriesFor: #isModified:!accessing!private! !
!Tools.ViewComposer categoriesFor: #isMouseClick!private!testing! !
!Tools.ViewComposer categoriesFor: #isMouseClick:!accessing!private! !
!Tools.ViewComposer categoriesFor: #isMouseTarget!private!testing! !
!Tools.ViewComposer categoriesFor: #isSelected:!private!testing! !
!Tools.ViewComposer categoriesFor: #isUndoRedoInProgress!private! !
!Tools.ViewComposer categoriesFor: #mapPoint:toArenaFromView:!helpers!private! !
!Tools.ViewComposer categoriesFor: #mapPoint:toViewFromArena:!private! !
!Tools.ViewComposer categoriesFor: #mapRectangle:toArenaFromView:!private! !
!Tools.ViewComposer categoriesFor: #mapRectangle:toViewFromArena:!private! !
!Tools.ViewComposer categoriesFor: #matchBackgroundColors!commands!public! !
!Tools.ViewComposer categoriesFor: #matchFonts!commands!public! !
!Tools.ViewComposer categoriesFor: #matchForegroundColors!commands!public! !
!Tools.ViewComposer categoriesFor: #matchGeometryAspect:!geometry!private! !
!Tools.ViewComposer categoriesFor: #matchHeights!commands!public! !
!Tools.ViewComposer categoriesFor: #matchSizes!commands!public! !
!Tools.ViewComposer categoriesFor: #matchWidths!commands!public! !
!Tools.ViewComposer categoriesFor: #maxUndoStates!public! !
!Tools.ViewComposer categoriesFor: #moveableSelections!adornments!private! !
!Tools.ViewComposer categoriesFor: #mutate!commands!public! !
!Tools.ViewComposer categoriesFor: #mutate:to:!operations!public! !
!Tools.ViewComposer categoriesFor: #mutateTo:!operations!public! !
!Tools.ViewComposer categoriesFor: #newDialogView!commands!public! !
!Tools.ViewComposer categoriesFor: #newShellView!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeBy:!operations!private! !
!Tools.ViewComposer categoriesFor: #nudgeDown!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeHorizontalGaps:!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeLeft!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeRight!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeUp!commands!public! !
!Tools.ViewComposer categoriesFor: #nudgeVerticalGaps:!commands!public! !
!Tools.ViewComposer categoriesFor: #onCloseRequested:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragCutHierarchy:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragEnterArena:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragHierarchy:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragLeaveArena:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragOverArena:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDragOverHierarchy:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDropOverArena:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onDropOverHierarchy:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onHierarchySelection!event handling!private! !
!Tools.ViewComposer categoriesFor: #onIdleEntered!operations!private! !
!Tools.ViewComposer categoriesFor: #onImageSaveCompleted!private! !
!Tools.ViewComposer categoriesFor: #onImageSaveStarting!private! !
!Tools.ViewComposer categoriesFor: #onInspecteeChanged!event handling!private! !
!Tools.ViewComposer categoriesFor: #onPromptToSaveChanges:!private!testing! !
!Tools.ViewComposer categoriesFor: #onRequestDropOpsForShield:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onSelectionPositioned:!event handling!private! !
!Tools.ViewComposer categoriesFor: #onSessionStarted!private! !
!Tools.ViewComposer categoriesFor: #onSettingChanged:!event handling-win32!private! !
!Tools.ViewComposer categoriesFor: #onViewClosed!event handling!private! !
!Tools.ViewComposer categoriesFor: #onViewOpened!event handling!private! !
!Tools.ViewComposer categoriesFor: #openOn:!operations!private! !
!Tools.ViewComposer categoriesFor: #openOnCopyOf:!operations!private! !
!Tools.ViewComposer categoriesFor: #ownsComposingView!public! !
!Tools.ViewComposer categoriesFor: #pasteClipboard!commands!public! !
!Tools.ViewComposer categoriesFor: #pasteContext!operations!private! !
!Tools.ViewComposer categoriesFor: #pastedView:context:!operations!private! !
!Tools.ViewComposer categoriesFor: #pasteResource:context:position:!operations!public! !
!Tools.ViewComposer categoriesFor: #pasteResourceLink:context:position:!operations!public! !
!Tools.ViewComposer categoriesFor: #performCommand:!commands!public! !
!Tools.ViewComposer categoriesFor: #performUndoRedo:!helpers!private! !
!Tools.ViewComposer categoriesFor: #primarySelection!adornments!private! !
!Tools.ViewComposer categoriesFor: #primarySelection:!adornments!private! !
!Tools.ViewComposer categoriesFor: #printShortCaptionOn:!private!updating! !
!Tools.ViewComposer categoriesFor: #queryCommand:!commands!private! !
!Tools.ViewComposer categoriesFor: #refreshImage!private! !
!Tools.ViewComposer categoriesFor: #refreshPublishedAspects!commands!private! !
!Tools.ViewComposer categoriesFor: #removeGrabbers!adornments!private! !
!Tools.ViewComposer categoriesFor: #removeHorizontalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #removeVerticalGaps!commands!public! !
!Tools.ViewComposer categoriesFor: #removeView:!operations!private! !
!Tools.ViewComposer categoriesFor: #repositionView:to:!private!tracking! !
!Tools.ViewComposer categoriesFor: #resetAddPositionOffset!operations!private! !
!Tools.ViewComposer categoriesFor: #resizeBy:!operations!private! !
!Tools.ViewComposer categoriesFor: #resizeView:to:!operations!private! !
!Tools.ViewComposer categoriesFor: #resourceIdentifier!accessing!public! !
!Tools.ViewComposer categoriesFor: #resourceIdentifier:!public! !
!Tools.ViewComposer categoriesFor: #resourceManager!accessing!public! !
!Tools.ViewComposer categoriesFor: #restoreComposition:!private! !
!Tools.ViewComposer categoriesFor: #restoreUndoState:!public! !
!Tools.ViewComposer categoriesFor: #safetyWrap:!operations!private! !
!Tools.ViewComposer categoriesFor: #saveAdornmentRegion!adornments!private! !
!Tools.ViewComposer categoriesFor: #saveStateOn:!private!saved state! !
!Tools.ViewComposer categoriesFor: #saveUndoState!operations!private! !
!Tools.ViewComposer categoriesFor: #secondarySelections!adornments!private! !
!Tools.ViewComposer categoriesFor: #selectAll!private! !
!Tools.ViewComposer categoriesFor: #selection:!adornments!private! !
!Tools.ViewComposer categoriesFor: #selections!adornments!private! !
!Tools.ViewComposer categoriesFor: #selections:!adornments!private! !
!Tools.ViewComposer categoriesFor: #selectionsByHorizontalPosition!helpers!private! !
!Tools.ViewComposer categoriesFor: #selectionsByVerticalPosition!helpers!private! !
!Tools.ViewComposer categoriesFor: #setModified!accessing!private! !
!Tools.ViewComposer categoriesFor: #shortCaption!accessing!public! !
!Tools.ViewComposer categoriesFor: #slideyPinNames!accessing!private! !
!Tools.ViewComposer categoriesFor: #snapPoint:context:!geometry!private! !
!Tools.ViewComposer categoriesFor: #startTrackingAt:!private!tracking! !
!Tools.ViewComposer categoriesFor: #status!accessing!private! !
!Tools.ViewComposer categoriesFor: #toggleGroupStop!commands!public!tabbing! !
!Tools.ViewComposer categoriesFor: #toggleSelectionFor:!adornments!private! !
!Tools.ViewComposer categoriesFor: #toggleTabStop!commands!public!tabbing! !
!Tools.ViewComposer categoriesFor: #trackGrabber:from:!adornments!private! !
!Tools.ViewComposer categoriesFor: #undoState!public! !
!Tools.ViewComposer categoriesFor: #updateAdornment!operations!private! !
!Tools.ViewComposer categoriesFor: #updateCaption!private!updating! !
!Tools.ViewComposer categoriesFor: #updatePrimarySelection!adornments!private! !
!Tools.ViewComposer categoriesFor: #validateAdornment!operations!private! !
!Tools.ViewComposer categoriesFor: #validateImage!private! !
!Tools.ViewComposer categoriesFor: #validateLayout!geometry!private! !
!Tools.ViewComposer categoriesFor: #validateUserInterface!operations!private! !
!Tools.ViewComposer categoriesFor: #viewClose!commands!public! !
!Tools.ViewComposer categoriesFor: #viewCloseNoPrompt!commands!public! !
!Tools.ViewComposer categoriesFor: #viewExport!commands!public! !
!Tools.ViewComposer categoriesFor: #viewExportTo:!helpers!private! !
!Tools.ViewComposer categoriesFor: #viewHierarchyPresenter!accessing!private! !
!Tools.ViewComposer categoriesFor: #viewHitBy:!accessing!private! !
!Tools.ViewComposer categoriesFor: #viewImport!commands!public! !
!Tools.ViewComposer categoriesFor: #viewImportFrom:!helpers!private! !
!Tools.ViewComposer categoriesFor: #viewOpen!commands!public! !
!Tools.ViewComposer categoriesFor: #viewRedo!public! !
!Tools.ViewComposer categoriesFor: #viewRevert!commands!public! !
!Tools.ViewComposer categoriesFor: #viewSave!commands!public! !
!Tools.ViewComposer categoriesFor: #viewSaveAs!commands!public! !
!Tools.ViewComposer categoriesFor: #viewTest!commands!public! !
!Tools.ViewComposer categoriesFor: #viewUndo!public! !
!Tools.ViewComposer categoriesFor: #widenSelection!commands!public! !
!Tools.ViewComposer categoriesFor: #zBack!commands!public! !
!Tools.ViewComposer categoriesFor: #zBackward!commands!public! !
!Tools.ViewComposer categoriesFor: #zForward!commands!public! !
!Tools.ViewComposer categoriesFor: #zFront!commands!public! !
!Tools.ViewComposer categoriesFor: #zOrderChangedFor:!private!updating! !

!Tools.ViewComposer class methodsFor!

addToClipboard: each 
	^self appendToClipboard: ((InternalDragDropObject new)
				format: #STBViewResource data: each binaryStoreBytes;
				format: #STLViewResource data: each literalStoreArray;
				yourself)!

appendToClipboard: aDragDropObject 
	"Private - Add aDragDropObjects to the collection held in the receiver's clipboard inst var."

	self clipboard isNil ifTrue: [self clipboard: OrderedCollection new].
	self clipboard add: aDragDropObject!

clearClipboard
	"Clear the clipboard."

	Clipboard := nil!

clipboard
	"Answer the receiver's clipboard inst var. This is either an OrdreredCollection of
	DragDropObjects or nil."

	^Clipboard!

clipboard: aCollectionOfDragDropObjects
	"Set the receiver's clipboard inst var to aCollectionOfDragDropObjects."

	Clipboard := aCollectionOfDragDropObjects!

copyAllToClipboard: aCollection 
	self clearClipboard.
	aCollection do: [:each | self addToClipboard: each]!

copyToClipboard: aView 
	self clearClipboard.
	self addToClipboard: aView!

defaultDefaultView
	^'Vertical view'!

defaultGridResolution
	"Answers the default grid resolution to use in the receiver."

	^DefaultGridResolution!

defaultGridResolution: anInteger
	"Set the default grid resolution to use in the receiver."

	DefaultGridResolution := anInteger!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream nextPutAll: 'View Composer'!

extentImage
	^(Icon fromId: 'EXTENT.ICO') imageIndex!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables and register to receive the
	#onStartup event from the SessionManager.

	self initialize
	"

	Smalltalk developmentSystem
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	self canUseIdeaSpace: true.
	self defaultSlideyPinsMap: ##(IdentityDictionary new
				at: #toolsSlidey put: false;
				at: #toolbarsSlidey put: false;
				yourself).
	DefaultGridResolution := 5!

openOn: aResourceIdentifier
	^self show openOn: aResourceIdentifier!

positionImage
	^(Icon fromId: 'POSITION.ICO') imageIndex!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: (Aspect boolean: #canUseIdeaSpace);
		add: (Aspect integer: #defaultGridResolution);
		yourself.
	^aspects!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

		^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 1245702 ##(Graphics.ThemeColor) #toolBackground nil 517 nil nil nil 416 984838 ##(UI.BorderLayout) 1 1 410 ##(UI.Toolbar) 34 25 nil 416 34 2 8 1140853580 131073 528 nil nil nil 519 nil nil nil 528 917510 ##(Graphics.Color) #default 8 1801306032 170 192 34 8 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 7 nil nil nil 672 1376838 1 ##(UI.ResourceIdentifier) ##(UI.Toolbar) #resource_Image_tools nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 1 1 882 63 51 672 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 8 #() 882 193 193 nil 27 8 'imageTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1024 nil nil nil 7 nil nil nil 1024 738 ##(UI.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 615 1 882 437 51 1024 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 976 992 nil 27 8 'searchTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1264 nil nil nil 7 nil nil nil 1264 738 ##(UI.Toolbar) #resource_File_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1051 1 882 155 51 1264 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 13 2 0 0 0 0 0 0 90 2 0 0 25 0 0 0] 976 992 nil 27 8 'fileTools' 410 ##(UI.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1504 nil nil nil 7 nil nil nil 1504 738 ##(UI.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 63 1 882 553 51 1504 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 976 992 nil 27 8 'smalltalkTools' 170 192 976 8 #() nil nil 1 nil 882 33 33 nil nil 852806 1 ##(UI.FlowLayout) 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 2079 51 528 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 15 4 0 0 25 0 0 0] 34 4 672 1504 1024 1264 992 nil 27 410 ##(UI.StatusBar) 34 18 nil 416 34 2 8 1140853004 1 1984 nil nil nil 7 nil nil nil 1984 nil 8 1801004784 170 192 34 6 1050374 ##(UI.StatusBarItem) 1 37 1984 nil nil 1246566 3 ##(Kernel.BlockClosure) 0 nil 1639718 ##(Kernel.CompiledExpression) 5 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 1049094 ##(Core.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2144 7 257 nil nil 8 'modificationStatus' 2098 1 301 1984 nil 2130 0 nil 2162 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:r | r notNil ifTrue: [r extent displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #extent #displayString 8 '' 2304 7 257 nil 834 #extentImage 8 #() ##(Tools.ViewComposer) nil 8 'extentStatus' 2098 1 301 1984 nil 2130 0 nil 2162 4 1 ##(Core.UndefinedObject) 8 'doIt' 8 '[:r | r notNil ifTrue: [r position displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #position #displayString 2384 2464 7 257 nil 834 #positionImage 2416 ##(Tools.ViewComposer) nil 8 'positionStatus' 34 3 2448 2288 2112 1311750 ##(UI.StatusBarNullItem) 513 1 1984 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1379 882 2079 45 1984 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 177 2 0 0 15 4 0 0 199 2 0 0] 8 #() 992 nil 27 nil nil 410 ##(UI.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2784 nil nil nil 7 nil nil nil 2784 1376774 ##(UI.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(UI.ContainerView) 34 15 nil 2784 34 2 8 1140850688 131073 2928 nil nil nil 7 nil nil nil 2928 2850 138 ##(Core.Dictionary) 34 2 2242 410 ##(UI.ContainerView) 34 15 nil 2928 34 2 8 1140850688 131073 3056 nil nil nil 7 461638 4 ##(UI.Menu) nil true 34 18 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #cutSelection 8 'Cu&t' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'EditCut.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3170 1 3202 #copySelection 8 '&Copy' 1 1 3250 nil true 3296 8 'EditCopy.ico' 3344 nil nil 3170 1 3202 #pasteClipboard 8 '&Paste' 1 1 3250 nil true 3296 8 'EditPaste.ico' 3344 nil nil 3170 1 3202 #clearSelection 8 '&Delete' 1 1 3250 nil true 3296 8 'EditClear.ico' 3344 nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 3170 1 3202 #inspectSelection 8 '&Inspect' 1 1 3250 nil true 3296 8 'InspectIt.ico' 3344 nil nil 3618 4097 3170 1 3202 #editContextMenu 8 'Set Conte&xt Menu...' 1 1 nil nil nil 3618 4097 3170 1 3202 #toggleTabStop 8 'Make Tab &Stop' 1 1 nil nil nil 3170 1 3202 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 3618 4097 3122 nil true 34 7 3170 1 3202 #alignLefts 8 '&Lefts' 1 1 nil nil nil 3170 1 3202 #alignCenters 8 '&Centres' 1 1 nil nil nil 3170 1 3202 #alignRights 8 '&Rights' 1 1 nil nil nil 3618 4097 3170 1 3202 #alignTops 8 '&Tops' 1 1 nil nil nil 3170 1 3202 #alignMiddles 8 '&Middles' 1 1 nil nil nil 3170 1 3202 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 'View Alig&n' nil 134217729 nil nil nil nil nil 3122 nil true 34 5 3170 1 3202 #matchWidths 8 '&Widths' 1 1 nil nil nil 3170 1 3202 #matchHeights 8 '&Heights' 1 1 nil nil nil 3170 1 3202 #matchFonts 8 '&Fonts' 1 1 nil nil nil 3170 1 3202 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 3170 1 3202 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'View Matc&h' nil 134217729 nil nil nil nil nil 3122 nil true 34 4 3170 1 3202 #zFront 8 'Bring to &Front' 1 1 nil nil nil 3170 1 3202 #zForward 8 'Bring F&orward' 1 1 nil nil nil 3170 1 3202 #zBackward 8 'Send B&ackward' 1 1 nil nil nil 3170 1 3202 #zBack 8 'Send to Bac&k' 1 1 nil nil nil 8 'View &Arrange' nil 134217729 nil nil nil nil nil 3618 4097 3170 1 3202 #mutate 8 'M&utate View...' 1 1 nil nil nil 3122 nil true 34 2 3170 1 3202 #dereference 8 'De&reference to Copy' 1 1 nil nil nil 3170 1 3202 #editReference 8 '&Edit' 1 1 nil nil nil 8 '&Reference View' #referenceViewMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3056 2850 170 176 34 4 410 ##(UI.ContainerView) 34 15 nil 3056 34 2 8 1140850688 131073 5072 nil nil nil 7 nil nil nil 5072 498 1 1 nil 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 5072 34 2 8 1140850688 131073 5152 nil nil nil 519 nil nil nil 5152 853318 1 ##(UI.CardLayout) 138 144 34 5 2242 8 'Arrange' 410 ##(UI.ReferenceView) 34 14 nil 410 ##(UI.SlidingCardTray) 34 22 nil 5152 34 2 8 1140850688 131073 5344 nil nil nil 7 nil nil nil 5344 5232 170 192 34 10 410 ##(UI.ReferenceView) 34 14 nil 5344 34 2 8 1140850688 131073 5440 nil nil nil 5 nil nil nil 5440 738 ##(UI.Toolbar) #resource_View_composer_nudge_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 731 57 5440 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 976 992 nil 27 8 'nudgeTools' 410 ##(UI.ReferenceView) 34 14 nil 5344 34 2 8 1140850688 131073 5680 nil nil nil 5 nil nil nil 5680 738 ##(UI.Toolbar) #resource_Edit_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 731 57 5680 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 976 992 nil 27 8 'editTools' 410 ##(UI.Toolbar) 34 25 nil 5344 34 2 8 1140853580 131137 5920 nil nil nil 517 nil 852998 ##(Graphics.Font) nil true 655622 ##(OS.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 882 193 193 nil 5920 608 8 1801306032 170 192 34 4 410 ##(UI.ReferenceView) 34 14 nil 5920 34 2 8 1140850688 131073 6128 nil nil nil 5 nil nil nil 6128 738 ##(UI.Toolbar) #resource_View_composer_alignment_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 339 51 6128 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 169 0 0 0 25 0 0 0] 976 992 nil 27 8 'alignmentTools' 410 ##(UI.ReferenceView) 34 14 nil 5920 34 2 8 1140850688 131073 6368 nil nil nil 5 nil nil nil 6368 738 ##(UI.Toolbar) #resource_View_composer_match_size_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 339 1 882 201 51 6368 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 169 0 0 0 0 0 0 0 13 1 0 0 25 0 0 0] 976 992 nil 27 8 'matchSizeTools' 170 192 976 138 144 976 nil nil 1 nil 882 33 33 882 45 45 nil 1794 1 1 1 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 731 57 5920 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 34 2 6128 6368 992 nil 27 8 'alignTools' 5312 8 'arrangementTools' 410 ##(UI.ReferenceView) 34 14 nil 5344 34 2 8 1140850688 131073 6880 nil nil nil 5 nil nil nil 6880 738 ##(UI.Toolbar) #resource_View_composer_spacing_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 731 57 6880 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 976 992 nil 27 8 'layoutTools' nil 410 ##(UI.TabViewXP) 34 28 nil 5152 34 2 8 1140916738 1 7120 787270 2 ##(UI.ListModel) 138 144 34 5 8 'Edit' 5296 8 'Nudge' 8 'Align' 8 'Layout' nil 1769478 ##(Kernel.IdentitySearchPolicy) nil nil 1 nil nil nil 7120 nil 8 1801049728 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 1639750 1 ##(Graphics.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 747 153 7120 834 #setSingleSelection: 8 #(2) 7120 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7120 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 117 1 0 0 76 0 0 0] 8 #() 992 nil 27 nil 5152 882 33 33 1246790 1 ##(UI.ButtonInteractor) 5344 nil 1 1180166 ##(Graphics.Rectangle) 882 695 3 882 727 35 nil 3202 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 9 882 731 93 5344 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 113 1 0 0 50 0 0 0] 34 5 5680 5312 5440 5920 6880 992 nil 27 34 2 8 1140850688 131073 5312 nil nil nil 7 nil nil nil 5312 738 ##(UI.Toolbar) #resource_View_composer_tools nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 731 57 5312 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 976 992 nil 27 2242 7264 5440 2242 7280 5920 2242 7296 6880 2242 7248 5680 5312 nil nil nil 170 192 976 nil 7120 5344 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1177 882 747 153 5152 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 76 2 0 0 117 1 0 0 152 2 0 0] 34 2 5344 7120 992 nil 27 nil nil 410 ##(UI.ScrollingDecorator) 34 18 nil 5072 34 2 8 1143996416 131073 8368 nil nil nil 7 nil nil nil 8368 1769798 1 ##(UI.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Tools.ViewComposerArena) 34 22 nil 8368 34 2 8 1140850944 1 8496 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 594 #cornsilk nil 535 nil nil nil 8496 nil nil 1049094 ##(UI.NullConverter) nil nil nil nil #normal nil 7666 882 21 21 882 21 21 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 1577 1397 8496 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 20 3 0 0 186 2 0 0] 8 #() 992 nil 27 8 'arena' nil 882 1 1 true 882 17 17 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 747 1177 8368 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 117 1 0 0 76 2 0 0] 34 1 8496 992 nil 27 170 192 34 2 5152 8 'toolbarsSlidey' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 747 1329 5072 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 117 1 0 0 152 2 0 0] 34 2 8368 5152 992 nil 27 852486 ##(Core.Fraction) 521 323 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 3056 34 2 8 1140850688 131073 9328 nil nil nil 519 nil nil nil 9328 5218 138 144 34 1 2242 787270 1 ##(UI.CardLabel) 8 'Property Inspector' 2130 0 nil 2162 6 1 16 8 'doIt' 8 '(CardLabel text: ''Property Inspector'' iconBlock: [PublishedAspectInspector icon])' 8 #[45 30 34 112 47 161 106 194 105] 1442886 2 ##(Kernel.VariableBinding) #CardLabel 9456 ##(Smalltalk) 1 9488 9586 #'Tools.PublishedAspectInspector' ##(Tools.PublishedAspectInspector) nil 1 #icon #text:iconBlock: 9504 11 1 nil 21659 410 ##(UI.ContainerView) 34 15 nil 410 ##(UI.SlidingCardTray) 34 22 nil 9328 34 2 8 1140850688 131073 9664 nil nil nil 7 nil nil nil 9664 9392 170 192 976 nil 410 ##(UI.TabViewXP) 34 28 nil 9328 34 2 8 1140916866 1 9744 7186 138 144 34 1 9472 nil 7328 nil nil 1 nil nil nil 9744 nil 8 1801049728 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 7376 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 373 1329 9744 834 #setSingleSelection: 8 #(1) 9744 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 9744 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 186 0 0 0 152 2 0 0] 8 #() 992 nil 27 nil 9328 882 33 33 7634 9664 nil 1 7666 882 5 3 882 37 35 nil 3202 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 9 9 882 309 1313 9664 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 4 0 0 0 158 0 0 0 148 2 0 0] 34 1 9632 992 nil 27 34 2 8 1140850688 131073 9632 nil nil nil 7 nil nil nil 9632 2850 138 ##(Core.Dictionary) 34 3 2242 410 ##(UI.ReferenceView) 34 14 nil 9632 34 2 8 1140850688 131073 10464 nil nil nil 7 nil nil nil 10464 738 ##(Tools.PropertyInspector) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 389 882 309 889 10464 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 194 0 0 0 154 0 0 0 126 2 0 0] 976 992 nil 27 655414 ##(Core.Float) 8 102 102 102 102 102 102 230 63 2242 410 ##(UI.TreeView) 34 27 nil 9632 34 2 8 1140918819 1 10736 787526 3 ##(UI.TreeModel) nil 7328 721670 ##(UI.TreeNode) nil nil nil 170 192 976 608 nil 31 nil nil nil 10736 nil 8 1801125840 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 7376 nil 2130 0 nil 2162 2 1 2128 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 226 0 106] #printString 10896 7 257 nil nil nil nil 170 176 976 nil #smallIcons 1 170 192 976 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 309 379 10736 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 154 0 0 0 189 0 0 0] 8 #() 992 nil 27 10690 8 51 51 51 51 51 51 211 63 2242 410 ##(UI.Splitter) 34 12 nil 9632 34 2 8 1140850688 1 11200 nil nil nil 519 nil nil nil 1707078 1 ##(UI.DraggableViewInteractor) 11200 nil 1 #left nil nil nil 882 1 1 882 9 9 nil 11296 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 379 882 309 11 11200 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 154 0 0 0 194 0 0 0] 8 #() 992 nil 27 1 true 170 192 34 4 10464 8 'inspector' 10736 8 'viewHierarchy' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 309 1277 9632 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 154 0 0 0 144 2 0 0] 34 3 10736 11200 10464 992 nil 27 9632 nil nil nil 170 192 976 nil 9744 9664 882 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 757 1 882 373 1329 9328 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 122 1 0 0 0 0 0 0 52 2 0 0 152 2 0 0] 34 2 9664 9744 992 nil 27 10690 8 154 153 153 153 153 153 233 63 false 170 192 34 2 9328 8 'inspectorSlidey' nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 951 1 882 1129 1329 3056 834 #contextMenu: 34 1 3136 3056 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 219 1 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 34 3 5072 410 ##(UI.Splitter) 34 12 nil 3056 34 2 8 1140850688 1 12160 nil nil nil 519 nil nil nil 11266 12160 nil 1 #left nil nil nil 11296 11312 nil 11296 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 747 1 882 11 1329 12160 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 117 1 0 0 0 0 0 0 122 1 0 0 152 2 0 0] 8 #() 992 nil 27 9328 992 nil 27 10690 8 106 223 176 246 13 107 239 63 2242 410 ##(UI.SlideyInneyOuteyThing) 34 23 nil 2928 34 2 8 1140850688 131073 12432 nil nil nil 519 nil nil nil 12432 5218 138 144 34 1 2242 9458 8 'View Toolbox' 2130 0 nil 2162 7 1 16 8 'doIt' 8 '(CardLabel text: ''View Toolbox'' iconBlock: [Icon fromId: ''View.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 9456 12576 3248 8 'View.ico' #fromId: #text:iconBlock: 12592 11 1 nil nil 410 ##(UI.ReferenceView) 34 14 nil 410 ##(UI.SlidingCardTray) 34 22 nil 12432 34 2 8 1140850688 131073 12720 nil nil nil 7 nil nil nil 12720 12496 170 192 34 2 12688 8 'toolbox' nil 410 ##(UI.TabViewXP) 34 28 nil 12432 34 2 8 1140916864 1 12832 7186 138 144 34 1 12560 nil 7328 nil nil 1 nil nil nil 12832 nil 8 1801049728 ##(UI.BasicListAbstract) ##(UI.IconicListAbstract) 7376 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createAt:extent: 34 2 882 1 1 882 941 1329 12832 834 #setSingleSelection: 8 #(1) 12832 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 12832 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 8 #() 992 nil 27 nil 12432 882 33 33 7634 12720 nil 1 7666 882 841 3 882 873 35 nil 3202 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 57 9 882 877 1313 12720 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 28 0 0 0 4 0 0 0 210 1 0 0 148 2 0 0] 34 1 12688 992 nil 27 34 2 8 1140850688 131073 12688 nil nil nil 1031 nil nil nil 12688 738 ##(Tools.ResourceToolboxPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 37 882 877 1277 12688 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 18 0 0 0 182 1 0 0 144 2 0 0] 976 992 nil 27 12688 nil nil nil 170 192 976 nil 12832 12720 882 745 959 401 1 524319 nil nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 941 1329 12432 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 34 2 12720 12832 992 nil 27 10690 8 46 186 232 162 139 46 234 63 false 170 192 34 2 12432 8 'toolsSlidey' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 1 882 2079 1329 2928 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 34 3 12432 410 ##(UI.Splitter) 34 12 nil 2928 34 2 8 1140850688 1 14064 nil nil nil 519 nil nil nil 11266 14064 nil 1 #left nil nil nil 11296 11312 nil 11296 nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 941 1 882 11 1329 14064 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 214 1 0 0 0 0 0 0 219 1 0 0 152 2 0 0] 8 #() 992 nil 27 3056 992 nil 27 8 'main' nil 770 138 144 34 1 834 #createAt:extent: 34 2 882 1 51 882 2079 1329 2784 930 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 15 4 0 0 177 2 0 0] 34 1 2928 992 nil 27 170 192 34 4 528 8 'toolbar' 1984 8 'statusbar' nil 658246 4 ##(UI.MenuBar) nil true 34 7 3122 nil true 34 16 3170 1 3202 #newShellView 8 '&New Shell View' 9373 1 3250 nil true 3296 8 'ShellView.ico' 3344 nil nil 3170 1 3202 #newDialogView 8 'New &Dialog View' 1 1 3250 nil true 3296 8 'DialogView.ico' 3344 nil nil 3618 4097 3170 1 3202 #viewOpen 8 '&Open...' 9375 1 nil nil nil 3170 1 3202 #viewClose 8 '&Close' 1 1 nil nil nil 3170 1 3202 #viewRevert 8 '&Revert' 1 1 1378630 1 ##(Graphics.TextTileIcon) $\x1F501 nil nil 594 #commonGreen nil nil 1 nil nil nil nil 3618 4097 3170 1 3202 #viewImport 8 '&Import View...' 1 1 nil nil nil 3170 1 3202 #viewExport 8 '&Export View...' 1 1 nil nil nil 3618 4097 3170 1 3202 #viewSave 8 '&Save' 1 1 3250 nil true 3296 8 'FileSave.ico' 3344 nil nil 3170 1 3202 #viewSaveAs 8 'Save &As...' 1 1 nil nil nil 3618 4097 3170 1 3202 #viewTest 8 '&Test' 9385 1 3250 nil true 3296 8 'TestView.ico' 3344 nil nil 3618 4097 3170 1 3202 #exit 8 'E&xit' 17639 1 14946 $\x2716 nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 48159 nil nil 3122 nil true 34 12 3170 1 3202 #viewUndo 8 '&Undo' 9397 1 3250 nil true 3296 8 'EditUndo.ico' 3344 nil nil 3170 1 3202 #viewRedo 8 '&Redo' 9395 1 3250 nil true 3296 8 'EditRedo.ico' 3344 nil nil 3618 4097 3170 1 3202 #cutSelection 8 'Cu&t' 9393 1 3250 nil true 3296 8 'EditCut.ico' 3344 nil nil 3170 1 3202 #copySelection 8 '&Copy' 9351 1 3250 nil true 3296 8 'EditCopy.ico' 3344 nil nil 3170 1 3202 #pasteClipboard 8 '&Paste' 9389 1 3250 nil true 3296 8 'EditPaste.ico' 3344 nil nil 3170 1 3202 #clearSelection 8 '&Delete' 1 1 3250 nil true 3296 8 'EditClear.ico' 3344 nil nil 3618 4097 3170 1 3202 #widenSelection 8 '&Widen Selection' 9387 1 nil nil nil 3170 1 3202 #selectAll 8 'Select &All' 9347 1 nil nil nil 3618 4097 3170 1 3202 #refreshPublishedAspects 8 'Refresh Inspector' 1257 1 3250 nil true 3296 8 'Refresh.ico' 3344 nil nil 8 '&Edit' nil 134217729 nil nil 48179 nil nil 3122 nil true 34 17 3170 1 3202 #editMenuBar 8 '&Menu Bar...' 1 1 nil nil nil 3170 1 3202 #editContextMenu 8 '&Context Menu...' 1 1 nil nil nil 3618 4097 3170 1 3202 #toggleTabStop 8 'Make &Tab Stop' 1 1 nil nil nil 3170 1 3202 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 3618 4097 3122 nil true 34 7 3170 1 3202 #alignLefts 8 '&Lefts' 1 1 nil nil nil 3170 1 3202 #alignCenters 8 '&Centres' 1 1 nil nil nil 3170 1 3202 #alignRights 8 '&Rights' 1 1 nil nil nil 3618 4097 3170 1 3202 #alignTops 8 '&Tops' 1 1 nil nil nil 3170 1 3202 #alignMiddles 8 '&Middles' 1 1 nil nil nil 3170 1 3202 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 '&Align' nil 134217729 nil nil 48201 nil nil 3122 nil true 34 5 3170 1 3202 #matchWidths 8 '&Widths' 1 1 nil nil nil 3170 1 3202 #matchHeights 8 '&Heights' 1 1 nil nil nil 3170 1 3202 #matchFonts 8 '&Fonts' 1 1 nil nil nil 3170 1 3202 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 3170 1 3202 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'Matc&h' nil 134217729 nil nil 48213 nil nil 3122 nil true 34 4 3170 1 3202 #zFront 8 'Bring to &Front' 9357 1 nil nil nil 3170 1 3202 #zForward 8 'Bring F&orward' 13453 1 nil nil nil 3170 1 3202 #zBackward 8 'Send B&ackward' 13463 1 nil nil nil 3170 1 3202 #zBack 8 'Send to Bac&k' 9367 1 nil nil nil 8 'A&rrange' nil 134217729 nil nil 48223 nil nil 3122 nil true 34 4 3170 1 3202 #nudgeLeft 8 '&Left' 9803 1 nil nil nil 3170 1 3202 #nudgeRight 8 '&Right' 9807 1 nil nil nil 3170 1 3202 #nudgeUp 8 '&Up' 9805 1 nil nil nil 3170 1 3202 #nudgeDown 8 '&Down' 9809 1 nil nil nil 8 '&Nudge' nil 134217729 nil nil 48233 nil nil 3122 nil true 34 4 3170 1 3202 #increaseHeight 8 '&Taller' 13905 1 nil nil nil 3170 1 3202 #increaseWidth 8 '&Fatter' 13903 1 nil nil nil 3170 1 3202 #decreateHeight 8 '&Shorter' 13901 1 nil nil nil 3170 1 3202 #decreaseWidth 8 'Th&inner' 13899 1 nil nil nil 8 'Gro&w' nil 134217729 nil nil 48243 nil nil 3618 4097 3122 nil true 34 3 3170 1 3202 #distributeHorizontally 8 'Distri&bute Evenly' 1 1 nil nil nil 3170 1 3202 #increaseHorizontalGaps 8 '&Increase' 1 1 nil nil nil 3170 1 3202 #decreaseHorizontalGaps 8 '&Decrease' 1 1 nil nil nil 8 'Hori&zontal Spacing' nil 134217729 nil nil 48251 nil nil 3122 nil true 34 3 3170 1 3202 #distributeVertically 8 'Distri&bute Evenly' 1 1 nil nil nil 3170 1 3202 #increaseVerticalGaps 8 '&Increase' 1 1 nil nil nil 3170 1 3202 #decreaseVerticalGaps 8 '&Decrease' 1 1 nil nil nil 8 '&Vertical Spacing' nil 134217729 nil nil 48259 nil nil 3618 4097 3170 1 3202 #mutate 8 'M&utate View...' 1 1 nil nil nil 3170 1 3202 #dereference 8 '&Dereference to Copy' 1 1 nil nil nil 8 '&Modify' nil 134217729 nil nil 48265 nil nil 3122 nil true 34 14 3170 1 3202 #browseIt 8 '&Browse It' 9349 1 3250 nil true 3296 8 'ClassBrowserShell.ico' 3344 nil nil 3170 1 3202 #displayIt 8 '&Display It' 9353 1 3250 nil true 3296 8 'DisplayIt.ico' 3344 nil nil 3170 1 3202 #printIt 8 '&Print It' 9377 1 3250 nil true 3296 8 'PrintIt.ico' 3344 nil nil 3170 1 3202 #evaluateIt 8 '&Evaluate It' 9355 1 3250 nil true 3296 8 'EvaluateIt.ico' 3344 nil nil 3170 1 3202 #inspectIt 8 '&Inspect It' 9363 1 3250 nil true 3296 8 'BasicInspector.ico' 3344 nil nil 3170 1 3202 #debugIt 8 'Deb&ug It' 1269 1 3250 nil true 3296 8 'Debugger.ico' 3344 nil nil 3170 1 3202 #fileItIn 8 '&File it In' 1 1 nil nil nil 3618 4097 3170 1 3202 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 3170 1 3202 #browseReferences 8 '&References...' 5367 1 nil nil nil 3618 4097 3170 1 3202 #accept 8 '&Accept' 9383 1 nil nil nil 3618 4097 3122 nil true 34 9 3170 1 3202 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3170 1 3202 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3170 1 3202 #toggleLineEndings 8 'Line &Endings' 1 1 14946 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3170 1 3202 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3170 1 3202 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3170 1 3202 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3170 1 3202 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 3618 4097 3122 nil true 34 2 3170 1 3202 786950 ##(Core.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3170 1 3202 19570 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 48305 nil nil 8 '&Options' nil 134217729 3250 nil true 3296 8 'Preferences.ico' 3344 nil 48307 nil nil 8 '&Workspace' nil 134217729 nil nil 48309 nil nil 3122 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 48311 nil nil 3122 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 48313 nil nil 3122 nil true 34 15 3170 1 3202 #helpContents 8 '&Contents' 1025 1 3250 nil true 3296 8 'Help.ico' 3344 nil nil 3170 1 3202 #help 8 'On this &Tool' 1249 1 nil nil nil 3170 1 3202 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3618 4097 3170 1 3202 #learnSmalltalk 8 'Learn Smalltalk' 1 1 14946 $\x1F393 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 3618 4097 3170 1 3202 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3170 1 3202 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3170 1 3202 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3618 4097 3170 1 3202 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 3250 nil true 3296 8 '!!APPLICATION' 3344 nil nil 3170 1 3202 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3170 1 3202 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3618 4097 3170 1 3202 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 14946 $\x1F42C nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 48337 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil nil 770 138 144 34 2 834 #createAt:extent: 34 2 882 6143 21 882 2111 1541 416 834 #text: 34 1 8 'View Composer' 416 930 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 30 16 0 0 12 3 0 0] 34 3 528 2784 1984 992 nil 27 )!

toolsFolderHelpId
	^10593! !
!Tools.ViewComposer class categoriesFor: #addToClipboard:!clipboard operations!private! !
!Tools.ViewComposer class categoriesFor: #appendToClipboard:!clipboard operations!private! !
!Tools.ViewComposer class categoriesFor: #clearClipboard!clipboard operations!public! !
!Tools.ViewComposer class categoriesFor: #clipboard!accessing!public! !
!Tools.ViewComposer class categoriesFor: #clipboard:!accessing!public! !
!Tools.ViewComposer class categoriesFor: #copyAllToClipboard:!clipboard operations!public! !
!Tools.ViewComposer class categoriesFor: #copyToClipboard:!clipboard operations!public! !
!Tools.ViewComposer class categoriesFor: #defaultDefaultView!initializing!private! !
!Tools.ViewComposer class categoriesFor: #defaultGridResolution!constants!public! !
!Tools.ViewComposer class categoriesFor: #defaultGridResolution:!constants!public! !
!Tools.ViewComposer class categoriesFor: #displayOn:!displaying!public! !
!Tools.ViewComposer class categoriesFor: #extentImage!constants!private! !
!Tools.ViewComposer class categoriesFor: #icon!constants!public! !
!Tools.ViewComposer class categoriesFor: #initialize!initializing!private! !
!Tools.ViewComposer class categoriesFor: #openOn:!instance creation!public! !
!Tools.ViewComposer class categoriesFor: #positionImage!constants!private! !
!Tools.ViewComposer class categoriesFor: #publishedAspects!constants!public! !
!Tools.ViewComposer class categoriesFor: #resource_Vertical_view!public!resources-views! !
!Tools.ViewComposer class categoriesFor: #toolsFolderHelpId!public! !

