"Filed out from Dolphin Smalltalk"!

SmalltalkToolShell subclass: #ViewComposer
	instanceVariableNames: 'toolboxPresenter status arenaPresenter inspector composingView ownsComposingView resourceIdentifier addPositionOffset grabbers selections grid viewHierarchyPresenter primarySelection vcFlags modificationStatus image undoList'
	classVariableNames: 'Clipboard DefaultGridResolution ExtentImage ModifiedFlag MouseClickFlag PositionImage RefreshFlag UndoRedoFlag'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

ViewComposer guid: (GUID fromString: '{045641aa-90d2-43e8-a81c-a3f76d7d35b4}')!

ViewComposer addClassConstant: 'ModifiedFlag' value: 16r1!
ViewComposer addClassConstant: 'MouseClickFlag' value: 16r2!
ViewComposer addClassConstant: 'RefreshFlag' value: 16r8!
ViewComposer addClassConstant: 'UndoRedoFlag' value: 16r10!

ViewComposer comment: 'The View Composer is Dolphin''s GUI builder. It is used to graphically create views (the user interface components of the MVP framework). 

The view resources are saved down as class-side methods, usually associated with the presenter classes to which the views will be attached. These methods are given selectors of the form, #resource_xxxx_yyyy, where xxxx_yyyy is the resource identifier. The resource methods answer an array of Smalltalk literals that can be used to rebuild an instance of the view when loaded via an `STLInFiler`.

The View Composer works by loading its ''composing view'' as a child of the desktop and positioning it offscreen so that it is invisible to the user. It then uses `WM_PRINT` messages to render an image of this view which it displays in its arenaPresenter. Using this shadow image of the real view has a couple of benefits. The first is that mouse clicks over the image can be intercepted directly, whereas mouse clicks over the real view would be handled by the Windows controls themselves. We also discovered that placing a real shell view inside another (e.g. as a composing view inside the View Composer) caused the menu bars for the shell view not to be displayed.


##High Dpi

We want to do all editing at a fixed DPI, the natural choice being device-independent pixels (aka DIPs), which is 96 dpi. To achieve this we create the hidden instance of the view being editing with a DPI awareness context of ''unaware'', which results in Windows virtualizing the pixel extents and positions, etc, to 96-dpi. The rendering of the view in the View Composer''s arena is a bitmap captured by sending a WM_PRINT message to the view. This will render at 96-dpi, so could end up being very small if viewed on a system with scaling of 200%+. We could just stretch this to fit, but the scaling up a bitmap gives very poor results. Scaling by Windows of the 96-dpi view may be blurry (although we can even avoid most of that by using the new gdi-scaling mode), but this is still much better than the results from StretchBlt. We would also have the additional complexity of mapping between the physical pixel positions at which the arena operates, and the logical DIPs of the edited view. It makes sense, therefore, for the at least the `ViewComposerArea` to be operating at 96-dpi too. We could open the entire VC at 96-dpi, but aside from the fact that the whole thing will be blurry, this has other important side effects. The most significant of these is that all new windows opened when the VC is processing a message will inherit the same DPI awareness context by default unless we explicitly switch the DPI awareness context. Changing the DPI awareness context at appropriate for the whole VC would generate quite a lot of additional complexity. Fortunately the DPI awareness mechanisms in modern Windows are quite sophisticated, and we can even have window with differing DPI awareness within the same window hierarchy, which is known as ''mixed DPI hosting behaviour''. We have to enable mixed hosting explicitly on the immediate parent of the arena (a `ScrollingDecorator`) . The documentation warns ominously of unexpected (but undetailed) side-effects of turning it on in general, but by doing for a single container we can then create just the arena sub-view in an ''unaware'' DPI awareness context. The system then scales the composed view image and we get a reasonable visual result along with 96-dpi editing, especially if the GDI scaled unaware mode is used. Mixed hosting does also add some complexity, however, as we need to be aware of the DPI awareness context we should be using when interacting between the arena and the rest of the VC, but this seems manageable.




'!

!ViewComposer categoriesForClass!MVP-Presenters! !

!ViewComposer methodsFor!

addGrabbers
	"Private - Put up grabbers to manipulate the size of the primary selection"

	(primarySelection isNil or: [(self canSize: self primarySelection) not]) ifTrue: [^self].
	grabbers := {Grabber
					view: primarySelection
					aspect: #topLeft
					composer: self.
				Grabber
					view: primarySelection
					aspect: #bottomRight
					composer: self.
				Grabber
					view: primarySelection
					aspect: #topRight
					composer: self.
				Grabber
					view: primarySelection
					aspect: #bottomLeft
					composer: self.
				(Grabber
					view: primarySelection
					aspect: #topCenter
					composer: self) beVerticalOnly.
				(Grabber
					view: primarySelection
					aspect: #bottomCenter
					composer: self) beVerticalOnly.
				(Grabber
					view: primarySelection
					aspect: #leftCenter
					composer: self) beHorizontalOnly.
				(Grabber
					view: primarySelection
					aspect: #rightCenter
					composer: self) beHorizontalOnly}.
	self isComposingViewPrimarySelection
		ifTrue: 
			["The composingView's origin should not be moved, and therefore the grabbers for the origin, top centre, and left centre should be completely disabled. The grabbers for top-right and bottom-left corners should be constrained to operate in horizontal and vertical planes respectively."
			#(1 5 7) do: [:i | (grabbers at: i) beDisabled].
			(grabbers at: 3) beHorizontalOnly.
			(grabbers at: 4) beVerticalOnly].
	self showAdornment!

addSelectionFor: aView
	"Private - Adds a new selection"

	self hideAdornment.
	self selections
		remove: aView ifAbsent: [];
		addFirst: aView.
	self updatePrimarySelection.
	self showAdornment.
	self
		dropUndoState;
		saveUndoState!

adjustScroll
	"Private - Ensure the arena adopts scroll bars if required."

	self view inDpiAwarenessContextDo: 
			[| arena necessaryExtent |
			necessaryExtent := self composingView ifNotNil: [:cv | cv extent] ifNil: [0 @ 0].
			"Note that the preferredExtent of the arena is set as measured at the VC dpi rather than the design DPI (96) that the arena runs at. This is because it is consumed by the parent scrolling decorator, which is at the VC dpi."
			arena := self arena.
			arena preferredExtent: necessaryExtent + (self arenaBorderSize * self view dpi // arena dpi).
			arena parentView validateLayout]!

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
	(aView == self arena or: [aView canAcceptSubViews]) ifFalse: [^false].

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
	"Private - Answer the DIPs size for the arena borders."

	^20!

aspectAccessor
	^inspector aspectAccessor!

aspectAccessor: anAspectAccessor 
	| accessor |
	accessor := inspector aspectTreePresenter model asSet detect: [:each | each name=anAspectAccessor name] ifNone: [^self].
	inspector aspectTreePresenter selection: accessor.!

assertInArenaDpiContext
	self arena assertInNativeDpiContext!

assertInNativeDpiContext
	self assert: [view isInNativeDpiAwarenessContext]!

basicCaption
	"Private - Answer a basic caption that can be used to label the receiver's view.
	Normally this is augmented (in #updateCaption) by appending the document file
	name"

	^'View Composer'!

basicPasteResource: aResourceArray context: contextView
	"Private - Pastes a view realized from anSTLArray into contextView. Answers the pasted view.
	Generally, #pasteResource:context:position: should be used instead, as that will take care
	of selection etc."

	^contextView loadViewResource: aResourceArray forEdit: true!

basicPasteResourceLink: aLiteralResourceIdentifier context: contextView 
	"Private - Pastes reference to aLiteralResourceIdentifier into contextView. Answers the
	pasted view. Generally, #pasteResourceLink:context:position: should be used instead, as that
	will take care of selection etc."

	^contextView addSubView: (ReferenceView resourceIdentifier: aLiteralResourceIdentifier)!

browseIt
	"Open a new class browser on the hierarchy at the same point as the receiver."
	
	self composingView browse!

cancelSelectionFor: aView
	"Private - Removes the selection for aView"

	(self isSelected: aView) ifFalse: [^self].
	self hideAdornment.
	self selections remove: aView.
	self updatePrimarySelection.
	self showAdornment!

cancelSelections
	"Private - Removes all selections and grabbers"

	self hideAdornment.
	grabbers := nil.
	selections := OrderedCollection new.
	self primarySelection: nil!

canMove: aView 
	"Private - Answer true if aView can be moved around by the receiver"

	^aView ~~ self composingView!

canPaste
	"Private - Answer whether the ResourceManager clipboard can be pasted into the receiver."

	| dragObjects |
	dragObjects := self clipboard.
	^dragObjects notNil and: 
			[composingView isNil or: 
					[primarySelection notNil and: 
							[self
								areDragObjects: dragObjects
								acceptableFor: #copy
								inView: primarySelection]]]!

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

	self inDesignDpiContextDo: 
			[| primaryRectangle center delta |
			self arena hideAdornment.
			primaryRectangle := self primarySelection rectangle.
			center := self primarySelection parentView getClientRect centerX.
			delta := primaryRectangle centerX - center.
			self selections
				do: [:each | self repositionView: each to: (each position x - delta rounded) @ each position y]]!

centerVertically
	"Private - Move the selections so that the primary selection is centred vertically in its parent, but
	maintaining the relative positions of the other selections."

	self inDesignDpiContextDo: 
			[| primaryRectangle center delta |
			self arena hideAdornment.
			primaryRectangle := self primarySelection rectangle.
			center := self primarySelection parentView getClientRect centerY.
			delta := primaryRectangle centerY - center.
			self selections
				do: [:each | self repositionView: each to: each position x @ (each position y - delta rounded)]]!

chooseFont
	"Set the font of all selected objects to the users choice from a FontDialog."

	| font |
	font := Font choose.
	font notNil ifTrue:
		[self selections do: [:v | v font: font]].
!

clearSelection
	"Removes the current selections from the receiver"

	| prompt selCount |
	selCount := self selections size.
	prompt := selCount > 1 
				ifTrue: ['Are you sure you wish to remove the <1d> selected views?' expandMacrosWith: selCount]
				ifFalse: 
					['Are you sure you wish to remove the selected <1d>?' expandMacrosWith: self selections first class].
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
	self positionComposingView.
	self
		updateCaption;
		adjustScroll;
		refreshImage!

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
	sourceView parentView isDesktop
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
				add: ((PropertyInspector new)
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

	^self arena defaultComposingPosition!

defaultGridResolution
	"Private - Answers the default grid resolution to use in the receiver. Note that this is specified in device-independent pixels (i.e. arena resolution)."

	^5!

defaultHelpId
	^10827!

deleteSelections
	self selections copy do: [:each | self removeView: each].
	self arena invalidate.
	self validateLayout.
	self isModified: self hasComposingView!

dereference
	"Dereference the primary selection which is an instance of ReferenceView."

	| referenceView dereferencedView |
	referenceView := self primarySelection.
	(MessageBox
		confirm: ('This reference to ''<1d>'' will be replaced by a copy.<n><n>Are you sure you want to continue?'
				expandMacrosWith: referenceView resourceIdentifier)
		caption: 'Dereference to copy...') ifFalse: [^self].
	self hideAdornment.
	dereferencedView := self basicPasteResource: referenceView resource
				context: referenceView parentView.
	self copyAspectsFrom: referenceView to: dereferencedView.
	self pastedView: dereferencedView context: referenceView parentView.
	self removeView: referenceView!

designDesktop
	^DesignDesktopView default!

distributeHorizontally
	"Distribute the selected controls horizontally so that they are evenly spaced. The existing
	relative positions of the selections are maintained (i.e. the leftmost control remains so
	after distribution, etc)."

	self inDesignDpiContextDo: 
			[| distributees gap space totalWidth start |
			self arena hideAdornment.
			distributees := self selectionsByHorizontalPosition.
			totalWidth := distributees inject: 0 into: [:sum :each | sum + each width].
			space := distributees first parentView clientWidth - totalWidth.
			start := space < 0
						ifTrue: 
							[gap := space / (distributees size - 1).
							0]
						ifFalse: 
							[gap := space / (distributees size + 1).
							gap rounded].
			distributees inject: start
				into: 
					[:x :each |
					self repositionView: each to: x rounded @ each y.
					x + each width + gap]]!

distributeVertically
	"Distribute the selected controls vertically so that they are evenly spaced."

	self inDesignDpiContextDo: 
			[| distributees totalHeight gap start space |
			self arena hideAdornment.
			distributees := self selectionsByVerticalPosition.
			totalHeight := distributees inject: 0 into: [:sum :each | sum + each height].
			space := distributees first parentView clientHeight - totalHeight.
			start := space < 0
						ifTrue: 
							[gap := space / (distributees size - 1).
							0]
						ifFalse: 
							[gap := space / (distributees size + 1).
							gap rounded].
			distributees inject: start
				into: 
					[:y :each |
					self repositionView: each to: each x @ y rounded.
					y + each height + gap]]!

drawAdornment
	"Private - Draws the adornment for the receiver on the associated view. It
	must be painted after all child windows of the view have been drawn, 
	so that it appears on top of them"

	self arena showAdornment!

dropIncrement
	"Private - Answers a Point that is the incremental position between multiple dropped object"
	
	^10@10!

dropUndoState
	undoList goBack: 1!

dropView: aView onto: aTargetView at: aPoint
	"Private - Handle the drop of aView on aTargetView in the receiver.
	Answer true if the operation succeeds, false otherwise"

	| originalParent |
	originalParent := aView parentView.
	originalParent == aTargetView
		ifFalse: 
			[| resource name |
			"Only need to do anything if the view is not already in place"
			resource := aView literalStoreArray.
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
	"Edit the primary selection which is an instance of ReferenceView."

	self primarySelection resourceIdentifier edit!

endComposition
	"Close the existing shell in use by the receiver"

	self composingView isNil ifTrue: [^self].
	self cancelSelections.
	self closeComposingView.
	self refreshImage!

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
	self validateLayout!

getUndoState
	^self
		inDesignDpiContextDo: [{self composingView. selections. self aspectAccessor} literalStoreArray]!

grabbers
	"Private - Answers the collection of grabbers currently in operation"

	^grabbers ifNil: [#()]!

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

hasReferenceSelection
	^self primarySelection isKindOf: ReferenceView!

hasResource
	"Private - Answer true if the receiver has a full resource identifier"

	^resourceIdentifier notNil and: [resourceIdentifier name notNil ]!

hasSelection
	"Private - Answer true if there are any selections"

	^self selections notEmpty

!

hideAdornment
	"Private - Ensure that any selection adornments are hidden."

	self inDesignDpiContextDo: [self arena hideAdornment]!

hidingOffset
	"Answers the <Point> location where our composing view should be positioned so that so that
	it is not visible on the desktop.

	Note that, Windows will allow top-level shells to be positioned anywhere offscreen without
	problems but, unfortunately this is not the case for non-shell windows which are always
	forced back so they are fully visible on screen.

	Hence, here we choose our hiding offset such that only one pixel needs to be visible at the
	edge of the screen and Windows will not then try to interfere with our positioning. Note
	that we need to be careful to handle multi-monitor displays."

	^(SystemMetrics current virtualScreenRectangle right - 1) @ 10!

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

inDesignDpiContextDo: aNiladicBlock
	^self arena inDpiAwarenessContextDo: aNiladicBlock!

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
	"Open an inspector on the selected view(s)"

	self selections size = 1
		ifTrue: [self selections first inspect]
		ifFalse: [self selections asArray inspect]!

invalidateAdornmentFor: aView
	"Private - Invalidates the region occupied by the adornments for aView 
	and causes it to be repainted"

	self inDesignDpiContextDo: [self arena invalidateAdornmentFor: aView]!

isComposingViewPrimarySelection
	^primarySelection == self composingView!

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

isSelected: aView
	"Private - Answer true if the aView is selected"

	^self selections includes: aView
!

isUndoRedoInProgress
	^vcFlags anyMask: UndoRedoFlag!

matchBackgroundColors
	"Matches the background colors of all the selections to that of the primary selection."

	| color |
	color := primarySelection backcolor.
	self secondarySelections do: [:v | v backcolor: color].
	self setModified!

matchFonts
	"Matches the fonts of all the selections to that of the primary selection."

	| font |
	font := primarySelection font.
	self secondarySelections do: [:v | v font: font].
	self setModified!

matchForegroundColors
	"Matches the foreground colors of all the selections to that of the primary selection."

	| color |
	color := primarySelection forecolor.
	self secondarySelections do: [:v | v forecolor: color].
	self setModified!

matchGeometryAspect: anAspectSymbol
	"Private - Matches the geometry aspect in anAspectSymbol (#x, #y, #width, #height etc) of the selections to that of the primary selection"

	self inDesignDpiContextDo: 
			[| aspectSetSymbol primaryRectangle |
			self arena hideAdornment.
			aspectSetSymbol := (anAspectSymbol , ':') asSymbol.
			primaryRectangle := primarySelection parentView mapRectangle: primarySelection rectangle
						to: primarySelection topView.
			self selections do: 
					[:each |
					| rectangle selectionRectangle |
					rectangle := each topView mapRectangle: primaryRectangle to: each parentView.
					selectionRectangle := each rectangle.
					selectionRectangle perform: aspectSetSymbol with: (rectangle perform: anAspectSymbol).
					each rectangle: selectionRectangle]].
	self setModified.
	self showAdornment!

matchHeights
	"Matches the heights of all the selections to that of the primary selection"

	self matchGeometryAspect: #height!

matchSizes
	"Matches the sizes of all the selections to that of the primary selection"

	self
		matchHeights;
		matchWidths!

matchWidths
	"Matches the widths of all the selections to that of the primary selection"

	self matchGeometryAspect: #width!

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
	#(#DesktopView #WinAsyncSocket #BrowserView) 
		do: [:each | Smalltalk at: each ifPresent: [:viewClass | excluded add: viewClass]].
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
	self inDesignDpiContextDo: 
			[self moveableSelections do: [:each | self repositionView: each to: each position + aPoint]]!

nudgeDown
	self nudgeBy: 0 @ 1!

nudgeHorizontalGaps: delta
	| distributees extra |
	distributees := self selectionsByHorizontalPosition.
	extra := distributees size - 1.
	self inDesignDpiContextDo: 
			[self arena hideAdornment.
			distributees inject: extra / 2 * delta negated
				into: 
					[:offset :each |
					| pos |
					pos := each position.
					self repositionView: each to: (pos x + offset rounded) @ pos y.
					offset + delta]]!

nudgeLeft
	self nudgeBy: -1 @ 0!

nudgeRight
	self nudgeBy: 1 @ 0!

nudgeUp
	self nudgeBy: 0 @ -1!

nudgeVerticalGaps: delta
	self inDesignDpiContextDo: 
			[| distributees extra |
			self arena hideAdornment.
			distributees := self selectionsByVerticalPosition.
			extra := distributees size - 1.
			distributees inject: extra / (2 * delta negated)
				into: 
					[:offset :each |
					| pos |
					pos := each position.
					self repositionView: each to: pos x @ (pos y + offset rounded).
					offset + delta]]!

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

	self hideAdornment!

onDragHierarchy: session 
	"Private - A drag has been started. Drag the currently selected view hierarchy."

	| dragDropObject |
	dragDropObject := session newDragObject: session suggestedSource.
	session
		dragObjects: (OrderedCollection with: dragDropObject);
		defaultOperation: #move!

onDragLeaveArena: session
	self inDesignDpiContextDo: 
			[| arena |
			arena := self arena.
			session suggestedTarget ifNotNil: [:target | arena invalidateAdornmentFor: target].
			arena showAdornment]!

onDragOverArena: session
	self inDesignDpiContextDo: 
			[| arena op dropTarget |
			arena := self arena.
			session operation: nil.
			dropTarget := arena
						dropTargetFromScreenPoint: session dragPoint * arena dpi // session dragSource dpi.
			dropTarget == session suggestedTarget
				ifFalse: 
					[session suggestedTarget ifNotNil: [:target | arena invalidateAdornmentFor: target].
					dropTarget == arena
						ifTrue: [self hasComposingView ifTrue: [^session suggestedTarget: nil]]
						ifFalse: 
							[session hideCursorWhile: 
									[arena drawSelectionFor: dropTarget.
									arena update]].
					session suggestedTarget: dropTarget].
			op := session intendedOperation.
			(self
				areDragObjects: session dragObjects
				acceptableFor: op
				inView: dropTarget) ifTrue: [session operation: op]]!

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
	self inDesignDpiContextDo: 
			[| arena dropObject dropTarget position |
			arena := self arena.
			position := session dragPoint * arena dpi // session dragSource dpi.
			dropTarget := arena dropTargetFromScreenPoint: position.
			dropTarget == arena
				ifTrue: 
					[dropTarget := self designDesktop.
					position := arena defaultComposingPosition]
				ifFalse: 
					[position := arena mapScreenToClient: position.
					position := arena mapPoint: position toView: dropTarget].
			dropObject := session dragObjects first.
			(session isCopy or: [session isMove])
				ifTrue: 
					[(dropObject isFormatAvailable: #ResourceIdentifier)
						ifTrue: 
							[self
								dropViewResource: (dropObject format: #ResourceIdentifier) resource
								onto: dropTarget
								at: position
								named: nil]
						ifFalse: 
							[self
								dropView: dropObject object
								onto: dropTarget
								at: position]].
			session isLink
				ifTrue: 
					[self
						pasteResourceLink: (dropObject format: #ResourceIdentifier)
						context: dropTarget
						position: position].
			session suggestedTarget ifNotNil: [:target | arena invalidateAdornmentFor: target]]!

onDropOverHierarchy: session
	"Private - The drag operation described by the <DragDropSession>, session,
	would like to do a drop."

	| parent |
	(parent := session suggestedTarget) notNil
		ifFalse: 
			[session resetOperation.
			Sound errorBeep.
			^self].
	(self inDesignDpiContextDo: 
			[| position |
			position := self dropIncrement.
			session dragObjects allSatisfy: 
					[:dropObject |
					| ok |
					ok := false.
					(dropObject isObjectKindAvailable: View)
						ifTrue: 
							["A view has been dropped onto the receiver"
							ok := self
										dropView: dropObject object
										onto: parent
										at: dropObject object position].
					(dropObject isFormatAvailable: #ResourceIdentifier)
						ifTrue: 
							[| rid |
							"A view resource has been dropped onto the receiver"
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

					"Terminate if operation fails"
					ok]])
		ifFalse: [session resetOperation]!

onHierarchySelection
	"Private - The selection has changed in the view hierarchy presenter so
	alter the primary selection"

	self hideAdornment.
	self isMouseClick
		ifFalse: 
			[| v |
			v := viewHierarchyPresenter selectionOrNil.
			v isNil ifTrue: [self cancelSelections] ifFalse: [self selection: v]].
	inspector model: primarySelection!

onIdleEntered
	"Private - Idle has been entered. Ensure the adornment is displayed correctly"

	super onIdleEntered.
	self isOpen ifTrue: [self validateImage]!

onImageSaveCompleted
	self ownsComposingView ifFalse: [^self].
	"Show the composing view that was hidden before image save, without activing it (otherwise if editing a dialog this VC will be activated). Note, if we don't do this then the VC will *appear* to work but all the non-client detail of views (i.e borders) will disappear (#2291)"
	self composingView basicShowWithStyle: SW_SHOWNOACTIVATE!

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
	updatedAspect notNil ifTrue: [[self adjustScroll. inspector aspectChanged: updatedAspect] postToMessageQueue].
	self showAdornment!

onSessionStarted
	"Reassert the composingView to ensure the viewHierarchyPresenter state is refreshed"

	
	["Fix for #2261, where the VC was not correctly allowing views to be edited after image
	restart. Here we need to ensure that the view hierarchy tree pane is refreshed."
	self composingView: self composingView isOwned: self ownsComposingView.
	"Rebuilding the tree will have added an undo record, which we don't want"
	#highDpiToDo. "This isn't right, as if some changes have been undone, we'll lose the redo history. Ideally need to stop the tree rebuild adding an undo record."
	undoList goBack: 1; clearFuture.
	self ownsComposingView
		ifTrue: 
			["Show the composing view that was hidden before image save. Note, if we
			 don't do this then the VC will *appear* to work but all the non-client
			 detail of views (i.e borders) will disappear (#2291)"
			self composingView show]]
			postToInputQueue!

onSettingChanged: aWindowEvent
	image := nil.
	self positionComposingView.
	self refreshImage.
	^super onSettingChanged: aWindowEvent!

onViewAvailable
	#highDpiToDo.	"Set in resource."
	self arena view parentView isMixedDpiHost: true!

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
	position := self pasteContext isDesktop
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
		ifTrue: [self designDesktop]
		ifFalse: [self primarySelection isNil ifTrue: [self composingView] ifFalse: [self primarySelection]]!

pastedView: aView context: contextView 
	"Private - aView has been pasted into contextView.
	Perform post-paste operations."

	aView show.
	contextView isDesktop
		ifTrue: [self composingView: aView isOwned: true]
		ifFalse: 
			[contextView inDpiAwarenessContextDo: [contextView validateLayout].
			viewHierarchyPresenter model add: aView asChildOf: aView parentView].

	"Both the context and the view under composition may need laying out"
	self forceLayoutFor: contextView.
	self selection: aView.
	self drawAdornment.
!

pasteResource: aResourceArray context: contextView position: aPoint
	"Private - Paste the view realized from anSTLArray into contextView at position aPoint.
	Answers the pasted View."

	^self inDesignDpiContextDo: 
			[| pastedView |
			pastedView := self basicPasteResource: aResourceArray context: contextView.
			pastedView position: (self arena snapPoint: aPoint context: contextView).
			self pastedView: pastedView context: contextView.
			pastedView]!

pasteResourceLink: aLiteralResourceIdentifier context: contextView position: aPoint
	"Private - Paste a reference to the view indicated by aLiteralResourceIdentifier into
	contextView at position aPoint. Answers the pasted View."

	| pastedView |
	self assertInArenaDpiContext.
	pastedView := self basicPasteResourceLink: aLiteralResourceIdentifier context: contextView.
	pastedView position: (self arena snapPoint: aPoint context: contextView).
	self pastedView: pastedView context: contextView.
	^pastedView!

performCommand: aCommand
	"Performs aCommand on the receiver and answer the result"

	| result |
	self hideAdornment.
	result := super performCommand: aCommand.
	self isOpen
		ifTrue: 
			[self validateLayout.
			self showAdornment].
	^result!

performUndoRedo: aNiladicValuable
	| wasActive user32 dpiContext |
	wasActive := self view isActive.
	vcFlags := vcFlags maskSet: UndoRedoFlag.
	user32 := UserLibrary default.
	dpiContext := user32
				setThreadDpiAwarenessContext: (user32 getWindowDpiAwarenessContext: self arena handle).
	aNiladicValuable ensure: 
			[vcFlags := vcFlags maskClear: UndoRedoFlag.
			user32 setThreadDpiAwarenessContext: dpiContext].
	(wasActive and: [self view isActive not]) ifTrue: [self view zOrderTop]!

positionComposingView
	self ownsComposingView ifTrue: [self composingView position: self hidingOffset]!

primarySelection
	"Private - Answer the primary selection or nil if there is none."

	^primarySelection!

primarySelection: aViewOrNil
	"Private - Set the primary selection to aViewOrNil."

	primarySelection == aViewOrNil ifTrue: [^self].
	primarySelection removeEventsTriggeredFor: self.
	self hideAdornment.
	primarySelection := aViewOrNil.
	primarySelection
		ifNotNil: 
			[primarySelection
				when: #positionChanged:
				send: #onSelectionPositioned:
				to: self].
	grabbers := nil.
	self addGrabbers.
	self resetAddPositionOffset.
	primarySelection
		ifNotNil: 
			["Update the viewHierarchy."
			viewHierarchyPresenter selectionOrNil == primarySelection
				ifTrue: 
					[primarySelection ensureVisible.
					self refreshImage]
				ifFalse: [viewHierarchyPresenter selection: primarySelection]].
	self updateStatusBar!

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
	(#(#copySelection #cutSelection #clearSelection #inspectSelection #mutate #toggleGroupStop #toggleTabStop #decreaseHeight #decreaseWidth #increaseWidth #increaseHeight)
		identityIncludes: command)
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
			[aCommandQuery isEnabled: self hasReferenceSelection.
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

refresh
	self refreshImage.
	inspector refresh!

refreshImage
	" Re-render the composing view and display it in the arenaPresenter."

	self isImageDirty: true!

removeHorizontalGaps
	"Remove any vertical spacing between the selected controls."

	self inDesignDpiContextDo: 
			[| first |
			first := true.
			self selectionsByHorizontalPosition inject: 0
				into: 
					[:x :each |
					first ifTrue: [first := false] ifFalse: [self repositionView: each to: x @ each y].
					each rectangle right]]!

removeVerticalGaps
	"Remove any vertical spacing between the selected controls."

	self inDesignDpiContextDo: 
			[| first |
			first := true.
			self selectionsByVerticalPosition inject: 0
				into: 
					[:y :each |
					first ifTrue: [first := false] ifFalse: [self repositionView: each to: each x @ y].
					each rectangle bottom]]!

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

repositionView: aView to: positionInParent
	aView inDpiAwarenessContextDo: 
			[aView parentView layoutManager
				ifNil: 
					[aView
						position: positionInParent;
						invalidate]
				ifNotNil: 
					[:parentLayoutManager |
					parentLayoutManager reposition: aView to: positionInParent.
					#todo.	"Don't think this should be necessary - reposition:to: should already do this"
					parentLayoutManager layoutContainer: aView parentView]].
	self setModified!

resetAddPositionOffset
	"Private - Resets the position offset within a parent where
	a new child view should be added. Answers the new position"
	
	^addPositionOffset := Point new.

!

resizeBy: aPoint
	self inDesignDpiContextDo: 
			[self arena hideAdornment.
			self selections do: [:each | self resizeView: each to: each extent + aPoint]]!

resizeView: aView to: aPoint
	| parent |
	parent := aView parentView.
	aView inDpiAwarenessContextDo: 
			[parent layoutManager
				ifNil: [aView extent: aPoint]
				ifNotNil: [:layoutManager | layoutManager resize: aView to: (aView rectangle origin extent: aPoint)]].
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
					state := self designDesktop loadViewResource: aLiteralStoreArray forEdit: true.
					restoredView := state at: 1.
					self composingView: restoredView isOwned: restoredView notNil.
					restoredView ifNotNil: [restoredView hasVisibleStyle: true].
					self selections: (state at: 2)].
			self aspectAccessor: (state at: 3)]!

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

	^self selections reject: [:each | each == primarySelection]!

selectAll
	self selections: viewHierarchyPresenter model asOrderedCollection!

selection: aView
	"Private - Sets the primary (and only selection) to be aView"

	"If this view is already the primary and only selection then do nothing."

	(self primarySelection == aView and: [self selections size = 1]) ifTrue: [^self].
	self hideAdornment.
	grabbers := nil.
	selections := OrderedCollection new.
	self addSelectionFor: aView!

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
	stream := String writeStream: 32.
	self printShortCaptionOn: stream.
	^stream contents!

showAdornment
	"Private - Ensure the adornment of the current selections is displayed"

	| arena |
	arena := self arena.
	arena isAdornmentHidden ifFalse: [^self].
	arena inDpiAwarenessContextDo: [arena showAdornment]!

slideyPinNames
	^super slideyPinNames , #('toolsSlidey' 'toolbarsSlidey' 'inspectorSlidey')!

statusValue: aRectangle
	"Private - Update the status bar position and extent."

	"We have to be careful not to update the composer StatusBar in the DPI awareness context of the arena, as even though Windows will ensure that the correct DPI awareness context is established for a Window before it dispatches it messages, when we set the value the StatusBarItems will invalidate their client area in the parent StatusBar and calculate the invalidation rectangle based on the current DPI context at the time."

	view inDpiAwarenessContextDo: [status value: aRectangle]!

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

undoState
	^self composingView
		ifNil: [self getUndoState]
		ifNotNil: [:cv | cv whileInvisibleDo: [self getUndoState]]!

updateCaption
	"Private - The receiver has changed in such a way that the caption
	may need to be refreshed."

	| stream |
	stream := String writeStream: 128.
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

updateStatusBar
	| rect |
	primarySelection ifNil: [^self].
	rect := primarySelection getRect.
	self isComposingViewPrimarySelection ifTrue: [rect moveBy: self composingView position negated].
	self statusValue: (rect scaleToDpi: primarySelection dpi from: self view dpi)!

validateImage
	"Private - Re-render the composing view and display it in the arenaPresenter."

	((image notNil and: [image handle isNull]) or: [self isImageDirty]) ifFalse: [^self].
	self isImageDirty: false.
	image := self composingView
				ifNotNil: 
					[:cv |
					cv needsValidateLayout ifTrue: [cv validateLayout].
					cv screenshot: self arena actualBackcolor brush].
	arenaPresenter value: image!

validateLayout
	"Private - Validate the layout for the view being composed"

	composingView notNil
		ifTrue: [composingView inDpiAwarenessContextDo: [composingView validateLayout]]!

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

viewExportTo: aString
	self inDesignDpiContextDo: [composingView binaryStoreOn: (FileStream write: aString text: false)]!

viewHierarchyPresenter
	^viewHierarchyPresenter!

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

	| rid viewResources |
	self viewClose ifFalse: [^self].
	viewResources := self allResourceIdentifiers asSortedCollection.
	(rid := ChoicePrompter choices: viewResources caption: 'Open') notNil ifTrue: [self openOn: rid]!

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
	self resourceIdentifier assignView: composingView.
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
		viewSave!

viewTest
	"Load the resource (being edited by the ViewComposer) in a test mode."

	| testView parentView stl |
	parentView := (self composingView isKindOf: ShellView)
				ifTrue: [View desktop]
				ifFalse: 
					[ShellView show
						layoutManager: GridLayout new;
						yourself].
	stl := composingView literalStoreArray.
	testView := Object fromLiteralStoreArray: stl context: parentView.
	self view repositionShell: testView topView.
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

!ViewComposer categoriesForMethods!
addGrabbers!adornments!private! !
addSelectionFor:!adornments!private! !
adjustScroll!geometry!private! !
alignBottoms!commands!public! !
alignCenters!commands!public! !
alignLefts!commands!public! !
alignMiddles!commands!public! !
alignRights!commands!public! !
alignTops!commands!public! !
allResourceIdentifiers!public! !
areDragObjects:acceptableFor:inView:!drag & drop!private! !
arena!accessing!private! !
arenaBorderSize!constants!private! !
aspectAccessor!public! !
aspectAccessor:!public! !
assertInArenaDpiContext!development!private! !
assertInNativeDpiContext!development!private! !
basicCaption!accessing!private! !
basicPasteResource:context:!operations!private! !
basicPasteResourceLink:context:!private! !
browseIt!commands!public! !
cancelSelectionFor:!adornments!private! !
cancelSelections!adornments!private! !
canMove:!private!testing! !
canPaste!private!testing! !
canSaveState!private!saved state! !
canSize:!private!testing! !
centerHorizontally!commands!private! !
centerVertically!commands!private! !
chooseFont!commands!public! !
clearSelection!commands!public! !
clearUndoState!operations!private! !
clipboard!accessing!public! !
closeComposingView!helpers!private! !
composingView!accessing!public! !
composingView:isOwned:!accessing!private! !
copyAspectsFrom:to:!operations!private! !
copySelection!commands!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
createViewHierarchyModel!helpers!initializing!private! !
cutSelection!commands!public! !
decreaseHeight!commands!public! !
decreaseHorizontalGaps!commands!public! !
decreaseVerticalGaps!commands!public! !
decreaseWidth!commands!public! !
defaultComposingPosition!constants!private! !
defaultGridResolution!constants!private! !
defaultHelpId!public! !
deleteSelections!commands!public! !
dereference!commands!public! !
designDesktop!helpers!private! !
distributeHorizontally!commands!public! !
distributeVertically!commands!public! !
drawAdornment!adornments!private! !
dropIncrement!constants!private! !
dropUndoState!operations!private! !
dropView:onto:at:!drag & drop!private! !
dropViewResource:onto:at:named:!drag & drop!private! !
editContextMenu!commands!public! !
editMenuBar!commands!public! !
editReference!commands!public! !
endComposition!commands!public! !
fileNew!commands!public! !
fileOpen!commands!public! !
fileSave!commands!public! !
forceLayoutFor:!geometry!private! !
getUndoState!public! !
grabbers!adornments!private! !
grid!accessing!private! !
grid:!accessing!private! !
gridSetting!commands!private! !
hasClipboard!private!testing! !
hasComposingView!private!testing! !
hasMoveableSelection!private!testing! !
hasOwnedComposingView:!public! !
hasReferenceSelection!commands!private! !
hasResource!private!testing! !
hasSelection!private!testing! !
hideAdornment!adornments!private! !
hidingOffset!constants!private! !
increaseHeight!commands!public! !
increaseHorizontalGaps!commands!public! !
increaseVerticalGaps!commands!public! !
increaseWidth!commands!public! !
incrementAddPositionOffset!operations!private! !
inDesignDpiContextDo:!helpers!private! !
initialComposingPosition!constants!private! !
initialize!initializing!private! !
inspector!accessing!private! !
inspectSelection!commands!public! !
invalidateAdornmentFor:!adornments!private! !
isComposingViewPrimarySelection!private!testing! !
isImageDirty!private! !
isImageDirty:!private! !
isModified!public!testing! !
isModified:!accessing!private! !
isMouseClick!private!testing! !
isMouseClick:!accessing!private! !
isSelected:!private!testing! !
isUndoRedoInProgress!private! !
matchBackgroundColors!commands!public! !
matchFonts!commands!public! !
matchForegroundColors!commands!public! !
matchGeometryAspect:!geometry!private! !
matchHeights!commands!public! !
matchSizes!commands!public! !
matchWidths!commands!public! !
maxUndoStates!public! !
moveableSelections!adornments!private! !
mutate!commands!public! !
mutate:to:!operations!public! !
mutateTo:!operations!public! !
newDialogView!commands!public! !
newShellView!commands!public! !
nudgeBy:!operations!private! !
nudgeDown!commands!public! !
nudgeHorizontalGaps:!commands!public! !
nudgeLeft!commands!public! !
nudgeRight!commands!public! !
nudgeUp!commands!public! !
nudgeVerticalGaps:!commands!public! !
onCloseRequested:!event handling!private! !
onDragCutHierarchy:!event handling!private! !
onDragEnterArena:!drag & drop!event handling!private! !
onDragHierarchy:!event handling!private! !
onDragLeaveArena:!drag & drop!event handling!private! !
onDragOverArena:!drag & drop!event handling!private! !
onDragOverHierarchy:!event handling!private! !
onDropOverArena:!drag & drop!event handling!private! !
onDropOverHierarchy:!event handling!private! !
onHierarchySelection!event handling!private! !
onIdleEntered!operations!private! !
onImageSaveCompleted!private! !
onImageSaveStarting!private! !
onInspecteeChanged!event handling!private! !
onPromptToSaveChanges:!private!testing! !
onRequestDropOpsForShield:!event handling!private! !
onSelectionPositioned:!event handling!private! !
onSessionStarted!private! !
onSettingChanged:!event handling-win32!private! !
onViewAvailable!event handling!public! !
onViewClosed!event handling!private! !
onViewOpened!event handling!private! !
openOn:!operations!private! !
openOnCopyOf:!operations!private! !
ownsComposingView!public! !
pasteClipboard!commands!public! !
pasteContext!operations!private! !
pastedView:context:!operations!private! !
pasteResource:context:position:!operations!public! !
pasteResourceLink:context:position:!operations!private! !
performCommand:!commands!public! !
performUndoRedo:!helpers!private! !
positionComposingView!accessing!private! !
primarySelection!adornments!private! !
primarySelection:!adornments!private! !
printShortCaptionOn:!private!updating! !
queryCommand:!commands!private! !
refresh!commands!public! !
refreshImage!private! !
removeHorizontalGaps!commands!public! !
removeVerticalGaps!commands!public! !
removeView:!operations!private! !
repositionView:to:!private!tracking! !
resetAddPositionOffset!operations!private! !
resizeBy:!operations!private! !
resizeView:to:!operations!private! !
resourceIdentifier!accessing!public! !
resourceIdentifier:!public! !
resourceManager!accessing!public! !
restoreComposition:!private! !
restoreUndoState:!public! !
saveStateOn:!private!saved state! !
saveUndoState!operations!private! !
secondarySelections!adornments!private! !
selectAll!private! !
selection:!adornments!private! !
selections!adornments!private! !
selections:!adornments!private! !
selectionsByHorizontalPosition!helpers!private! !
selectionsByVerticalPosition!helpers!private! !
setModified!accessing!private! !
shortCaption!accessing!public! !
showAdornment!operations!private! !
slideyPinNames!accessing!private! !
statusValue:!private!tracking! !
toggleGroupStop!commands!public!tabbing! !
toggleSelectionFor:!adornments!private! !
toggleTabStop!commands!public!tabbing! !
undoState!public! !
updateCaption!private!updating! !
updatePrimarySelection!adornments!private! !
updateStatusBar!operations!private! !
validateImage!private! !
validateLayout!geometry!private! !
validateUserInterface!operations!private! !
viewClose!commands!public! !
viewCloseNoPrompt!commands!public! !
viewExport!commands!public! !
viewExportTo:!helpers!private! !
viewHierarchyPresenter!accessing!private! !
viewImport!commands!public! !
viewImportFrom:!helpers!private! !
viewOpen!commands!public! !
viewRedo!public! !
viewRevert!commands!public! !
viewSave!commands!public! !
viewSaveAs!commands!public! !
viewTest!commands!public! !
viewUndo!public! !
widenSelection!commands!public! !
zBack!commands!public! !
zBackward!commands!public! !
zForward!commands!public! !
zFront!commands!public! !
zOrderChangedFor:!private!updating! !
!

!ViewComposer class methodsFor!

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

defaultDefaultView
	^'Vertical view'!

defaultGridResolution
	"Answers the default grid resolution to use in the receiver."

	^DefaultGridResolution!

defaultGridResolution: anInteger
	"Set the default grid resolution to use in the receiver."

	DefaultGridResolution := anInteger!

displayOn: aStream
	"Append, to aStream, a String whose characters are a representation of the receiver as a user
	would want to see it."

	aStream nextPutAll: 'View Composer'!

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
	self
		addClassConstant: 'ModifiedFlag' value: 16r1;
		addClassConstant: 'MouseClickFlag' value: 16r2;
		addClassConstant: 'RefreshFlag' value: 16r8;
		addClassConstant: 'UndoRedoFlag' value: 16r10.
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 655878 ##(Smalltalk.ThemeColor) #toolBackground nil 517 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 ##(Smalltalk.Toolbar) 34 28 nil 416 34 2 8 1140853580 131073 528 nil nil nil 517 nil nil nil 528 327686 ##(Smalltalk.Color) #default 8 1759112192 170 192 34 8 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 672 nil nil nil 5 nil nil nil 672 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Toolbar) #resource_File_tools nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[11 2 0 0 0 0 0 0 88 2 0 0 25 0 0 0] 193 704 8 '' 672 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 8 'fileTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1040 nil nil nil 5 nil nil nil 1040 738 ##(Smalltalk.Toolbar) #resource_Search_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[51 1 0 0 0 0 0 0 11 2 0 0 25 0 0 0] 193 1072 8 '' 1040 3 976 994 193 193 nil 27 8 'searchTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1296 nil nil nil 5 nil nil nil 1296 738 ##(Smalltalk.Toolbar) #resource_Smalltalk_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1328 8 '' 1296 3 976 994 193 193 nil 27 8 'smalltalkTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 528 34 2 8 1140850688 131073 1552 nil nil nil 5 nil nil nil 1552 738 ##(Smalltalk.Toolbar) #resource_Image_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 1584 8 '' 1552 3 976 994 193 193 nil 27 8 'imageTools' nil nil nil 170 192 976 8 #() nil nil 9 1201 #smallIcons nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 15 4 0 0 25 0 0 0] 193 560 8 '' 528 3 34 4 1552 1296 1040 672 994 193 193 nil 31 410 ##(Smalltalk.StatusBar) 34 21 nil 416 34 2 8 1140853004 1 2048 nil nil nil 5 nil nil nil 2048 nil 8 1758805184 170 192 34 6 853830 1 ##(Smalltalk.StatusBarItem) 8193 37 2048 nil nil 787814 3 ##(Smalltalk.BlockClosure) 0 nil 1180966 ##(Smalltalk.CompiledExpression) 5 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:modified | modified ifTrue: [Smalltalk developmentSystem changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 721414 ##(Smalltalk.Association) #Smalltalk ##(Smalltalk) #developmentSystem #changedIcon #imageIndex 2208 7 257 nil nil 8 'modificationStatus' 2162 8193 301 2048 nil 2194 0 nil 2226 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:r | r notNil ifTrue: [r position displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #position #displayString 8 '' 2368 7 257 nil 834 #positionImage 8 #() ##(Smalltalk.ViewComposer) nil 8 'positionStatus' 2162 8193 301 2048 nil 2194 0 nil 2226 4 1 ##(Smalltalk.UndefinedObject) 8 'doIt' 8 '[:r | r notNil ifTrue: [r extent displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #extent #displayString 2448 2528 7 257 nil 834 #extentImage 2480 ##(Smalltalk.ViewComposer) nil 8 'extentStatus' nil nil nil 34 3 2352 2512 2176 1115206 1 ##(Smalltalk.StatusBarNullItem) 8705 1 2048 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 177 2 0 0 15 4 0 0 199 2 0 0] 193 2080 8 '' 2048 3 8 #() 994 193 193 nil 29 nil nil 410 ##(Smalltalk.ContainerView) 34 15 nil 416 34 2 8 1140850688 131073 2864 nil nil nil 5 nil nil nil 2864 1180166 ##(Smalltalk.ProportionalLayout) 170 176 976 true 170 192 34 2 410 ##(Smalltalk.ContainerView) 34 15 nil 2864 34 2 8 1140850688 131073 3008 nil nil nil 5 nil nil nil 3008 2930 138 ##(Smalltalk.Dictionary) 34 2 2306 410 ##(Smalltalk.ContainerView) 34 15 nil 3008 34 2 8 1140850688 131073 3136 nil nil nil 5 265030 4 ##(Smalltalk.Menu) nil true 34 18 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #cutSelection 8 'Cu&t' 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'EditCut.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 3250 1 3282 #copySelection 8 '&Copy' 1 1 3330 nil true 3376 8 'EditCopy.ico' 3424 nil nil 3250 1 3282 #pasteClipboard 8 '&Paste' 1 1 3330 nil true 3376 8 'EditPaste.ico' 3424 nil nil 3250 1 3282 #clearSelection 8 '&Delete' 1 1 3330 nil true 3376 8 'EditClear.ico' 3424 nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 3250 1 3282 #inspectSelection 8 '&Inspect' 1 1 3330 nil true 3376 8 'InspectIt.ico' 3424 nil nil 3698 4097 3250 1 3282 #editContextMenu 8 'Set Conte&xt Menu...' 1 1 nil nil nil 3698 4097 3250 1 3282 #toggleTabStop 8 'Make Tab &Stop' 1 1 nil nil nil 3250 1 3282 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 3698 4097 3202 nil true 34 7 3250 1 3282 #alignLefts 8 '&Lefts' 1 1 nil nil nil 3250 1 3282 #alignCenters 8 '&Centres' 1 1 nil nil nil 3250 1 3282 #alignRights 8 '&Rights' 1 1 nil nil nil 3698 4097 3250 1 3282 #alignTops 8 '&Tops' 1 1 nil nil nil 3250 1 3282 #alignMiddles 8 '&Middles' 1 1 nil nil nil 3250 1 3282 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 'View Alig&n' nil 134217729 nil nil nil nil nil 3202 nil true 34 5 3250 1 3282 #matchWidths 8 '&Widths' 1 1 nil nil nil 3250 1 3282 #matchHeights 8 '&Heights' 1 1 nil nil nil 3250 1 3282 #matchFonts 8 '&Fonts' 1 1 nil nil nil 3250 1 3282 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 3250 1 3282 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'View Matc&h' nil 134217729 nil nil nil nil nil 3202 nil true 34 4 3250 1 3282 #zFront 8 'Bring to &Front' 1 1 nil nil nil 3250 1 3282 #zForward 8 'Bring F&orward' 1 1 nil nil nil 3250 1 3282 #zBackward 8 'Send B&ackward' 1 1 nil nil nil 3250 1 3282 #zBack 8 'Send to Bac&k' 1 1 nil nil nil 8 'View &Arrange' nil 134217729 nil nil nil nil nil 3698 4097 3250 1 3282 #mutate 8 'M&utate View...' 1 1 nil nil nil 3202 nil true 34 2 3250 1 3282 #dereference 8 'De&reference to Copy' 1 1 nil nil nil 3250 1 3282 #editReference 8 '&Edit' 1 1 nil nil nil 8 '&Reference View' #referenceViewMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 3136 2930 170 176 34 4 410 ##(Smalltalk.ContainerView) 34 15 nil 3136 34 2 8 1140850688 131073 5152 nil nil nil 5 nil nil nil 5152 498 1 1 nil 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 5152 34 2 8 1140850688 131073 5232 nil nil nil 517 nil nil nil 5232 656710 1 ##(Smalltalk.CardLayout) 138 144 34 5 2306 8 'Arrange' 410 ##(Smalltalk.ReferenceView) 34 14 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 5232 34 2 8 1140850688 131073 5424 nil nil nil 5 nil nil nil 5424 5312 170 192 34 10 410 ##(Smalltalk.ReferenceView) 34 14 nil 5424 34 2 8 1140850688 131073 5520 nil nil nil 5 nil nil nil 5520 738 ##(Smalltalk.Toolbar) #resource_Edit_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 5552 8 '' 5520 3 976 994 193 193 nil 27 8 'editTools' 410 ##(Smalltalk.Toolbar) 34 28 nil 5424 34 2 8 1140853580 131137 5776 nil nil nil 517 nil 263494 1 ##(Smalltalk.Font) nil true 524550 ##(Smalltalk.LOGFONTW) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 5776 608 8 1759112192 170 192 34 4 410 ##(Smalltalk.ReferenceView) 34 14 nil 5776 34 2 8 1140850688 131073 5968 nil nil nil 5 nil nil nil 5968 738 ##(Smalltalk.Toolbar) #resource_View_composer_match_size_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[169 0 0 0 0 0 0 0 13 1 0 0 25 0 0 0] 193 6000 8 '' 5968 3 976 994 193 193 nil 27 8 'matchSizeTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5776 34 2 8 1140850688 131073 6224 nil nil nil 5 nil nil nil 6224 738 ##(Smalltalk.Toolbar) #resource_View_composer_alignment_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 169 0 0 0 25 0 0 0] 193 6256 8 '' 6224 3 976 994 193 193 nil 27 8 'alignmentTools' nil nil nil 170 192 976 138 144 976 nil nil 9 nil #smallIcons 994 45 45 nil 1842 1 1 1 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 5808 8 '' 5776 1 34 2 6224 5968 994 193 193 nil 31 8 'alignTools' 5392 8 'arrangementTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5424 34 2 8 1140850688 131073 6752 nil nil nil 5 nil nil nil 6752 738 ##(Smalltalk.Toolbar) #resource_View_composer_spacing_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 6784 8 '' 6752 1 976 994 193 193 nil 27 8 'layoutTools' 410 ##(Smalltalk.ReferenceView) 34 14 nil 5424 34 2 8 1140850688 131073 7008 nil nil nil 5 nil nil nil 7008 738 ##(Smalltalk.Toolbar) #resource_View_composer_nudge_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 7040 8 '' 7008 1 976 994 193 193 nil 27 8 'nudgeTools' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 5232 34 2 8 1140916738 1 7264 590662 2 ##(Smalltalk.ListModel) 138 144 34 5 8 'Edit' 5376 8 'Nudge' 8 'Align' 8 'Layout' nil 1310726 ##(Smalltalk.IdentitySearchPolicy) nil nil 1 nil nil nil 7264 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil #noIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 117 1 0 0 74 0 0 0] 193 7296 8 '' 7264 834 #setSingleSelection: 8 #(1) 7264 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 7264 3 8 #() 994 193 193 nil 27 nil 5232 994 33 33 1050182 1 ##(Smalltalk.ButtonInteractor) 5424 nil 1 590342 ##(Smalltalk.Rectangle) 994 695 3 994 727 35 nil 3282 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 4 0 0 0 113 1 0 0 50 0 0 0] 193 5456 8 '' 5424 3 34 5 5520 5392 7008 5776 6752 994 193 193 nil 27 34 2 8 1140850688 131073 5392 nil nil nil 5 nil nil nil 5392 738 ##(Smalltalk.Toolbar) #resource_View_composer_tools nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 8096 8 '' 5392 1 976 994 193 193 nil 27 2306 7408 7008 2306 7424 5776 2306 7440 6752 2306 7392 5520 5520 nil nil nil 170 192 976 nil 7264 5424 994 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 78 2 0 0 117 1 0 0 152 2 0 0] 193 5264 8 '' 5232 3 34 2 5424 7264 994 193 193 nil 27 nil nil 410 ##(Smalltalk.ScrollingDecorator) 34 18 nil 5152 34 2 8 1143996416 131073 8576 nil nil nil 4101 nil nil nil 8576 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 34 2 410 ##(Smalltalk.ViewComposerArena) 34 22 nil 8576 34 2 8 1140850944 1 8704 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 594 #cornsilk nil 533 nil nil nil 8704 nil nil 852486 ##(Smalltalk.NullConverter) nil nil nil nil #normal nil 7826 994 21 21 994 21 21 nil nil 770 138 144 34 2 834 #createWindow: 34 1 1769990 ##(Smalltalk.CreateInDpiAwarenessContext) 882 914 8 #[0 0 0 0 0 0 0 0 20 3 0 0 186 2 0 0] 193 8736 nil 786950 ##(Smalltalk.DpiAwareness) -9 #gdiScaled 8704 834 #text: 34 1 8 '' 8704 3 8 #() 994 193 193 nil 27 8 'arena' nil 994 1 1 true 994 17 17 770 138 144 34 1 834 #createWindow: 34 1 1179910 ##(Smalltalk.CreateMixedDpiHost) 882 914 8 #[0 0 0 0 0 0 0 0 117 1 0 0 78 2 0 0] 193 8608 8 '' 8576 3 34 1 8704 994 193 193 nil 27 170 192 34 2 5232 8 'toolbarsSlidey' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 117 1 0 0 152 2 0 0] 193 5184 8 '' 5152 3 34 2 8576 5232 994 193 193 nil 27 524806 ##(Smalltalk.Fraction) 521 323 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3136 34 2 8 1140850688 131073 9712 nil nil nil 517 nil nil nil 9712 5298 138 144 34 1 2306 590662 1 ##(Smalltalk.CardLabel) 8 'Property Inspector' 2194 0 nil 2226 6 1 16 8 'doIt' 8 '(CardLabel text: ''Property Inspector'' iconBlock: [PublishedAspectInspector icon])' 8 #[45 30 34 112 47 161 106 194 105] 983558 ##(Smalltalk.VariableBinding) #CardLabel 9840 9872 9970 #PublishedAspectInspector ##(Smalltalk.PublishedAspectInspector) #icon #text:iconBlock: 9888 11 1 nil 21659 410 ##(Smalltalk.ContainerView) 34 15 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 9712 34 2 8 1140850688 131073 10048 nil nil nil 5 nil nil nil 10048 9776 170 192 976 nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 9712 34 2 8 1140916866 1 10128 7330 138 144 34 1 9856 nil 7472 nil nil 1 nil nil nil 10128 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7520 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 186 0 0 0 152 2 0 0] 193 10160 8 '' 10128 834 #setSingleSelection: 8 #(1) 10128 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10128 3 8 #() 994 193 193 nil 27 nil 9712 994 33 33 7794 10048 nil 1 7826 994 5 3 994 37 35 nil 3282 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[4 0 0 0 4 0 0 0 159 0 0 0 148 2 0 0] 193 10080 8 '' 10048 3 34 1 10016 994 193 193 nil 27 34 2 8 1140850688 131073 10016 nil nil nil 5 nil nil nil 10016 2930 138 ##(Smalltalk.Dictionary) 34 3 2306 410 ##(Smalltalk.ReferenceView) 34 14 nil 10016 34 2 8 1140850688 131073 10880 nil nil nil 5 nil nil nil 10880 738 ##(Smalltalk.PropertyInspector) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 194 0 0 0 155 0 0 0 126 2 0 0] 193 10912 8 '' 10880 3 976 994 193 193 nil 27 327734 ##(Smalltalk.Float) 8 102 102 102 102 102 102 230 63 2306 410 ##(Smalltalk.Splitter) 34 12 nil 10016 34 2 8 1140850688 1 11168 nil nil nil 517 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 11168 nil 1 #left nil nil nil 994 1 1 994 9 9 nil 11264 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 189 0 0 0 155 0 0 0 194 0 0 0] 193 11200 8 '' 11168 3 8 #() 994 193 193 nil 27 1 2306 410 ##(Smalltalk.TreeView) 34 27 nil 10016 34 2 8 1140918819 1 11488 590918 3 ##(Smalltalk.TreeModel) nil 7472 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 976 608 nil 29 nil nil nil 11488 nil 8 1758766000 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7520 nil 2194 0 nil 2226 2 1 2192 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 226 0 106] #printString 11648 7 257 nil nil nil nil 170 176 976 nil #smallIcons 1 170 ##(Smalltalk.PluggableLookupTable) 976 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 155 0 0 0 189 0 0 0] 193 11520 8 '' 11488 3 8 #() 994 193 193 nil 27 11122 8 51 51 51 51 51 51 211 63 true 170 192 34 4 11488 8 'viewHierarchy' 10880 8 'inspector' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 155 0 0 0 144 2 0 0] 193 10784 8 '' 10016 3 34 3 11488 11168 10880 994 193 193 nil 27 10016 nil nil nil 170 192 976 nil 10128 10048 994 201 201 401 1 524319 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[122 1 0 0 0 0 0 0 52 2 0 0 152 2 0 0] 193 9744 8 '' 9712 3 34 2 10048 10128 994 193 193 nil 27 11122 8 154 153 153 153 153 153 233 63 false 170 192 34 2 9712 8 'inspectorSlidey' nil 770 138 144 34 2 834 #createWindow: 34 1 882 914 8 #[219 1 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 193 3168 8 '' 3136 834 #contextMenu: 34 1 3216 3136 3 34 3 5152 410 ##(Smalltalk.Splitter) 34 12 nil 3136 34 2 8 1140850688 1 12656 nil nil nil 517 nil nil nil 11234 12656 nil 1 #left nil nil nil 11264 11280 nil 11264 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[117 1 0 0 0 0 0 0 122 1 0 0 152 2 0 0] 193 12688 8 '' 12656 3 8 #() 994 193 193 nil 27 9712 994 193 193 nil 27 11122 8 106 223 176 246 13 107 239 63 2306 410 ##(Smalltalk.SlideyInneyOuteyThing) 34 23 nil 3008 34 2 8 1140850688 131073 12960 nil nil nil 517 nil nil nil 12960 5298 138 144 34 1 2306 9842 8 'View Toolbox' 2194 0 nil 2226 7 1 16 8 'doIt' 8 '(CardLabel text: ''View Toolbox'' iconBlock: [Icon fromId: ''View.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 9840 13104 3328 8 'View.ico' #fromId: #text:iconBlock: 13120 11 1 nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 410 ##(Smalltalk.SlidingCardTray) 34 22 nil 12960 34 2 8 1140850688 131073 13248 nil nil nil 5 nil nil nil 13248 13024 170 192 34 2 13216 8 'toolbox' nil 410 ##(Smalltalk.TabViewXP) 34 28 nil 12960 34 2 8 1140916864 1 13360 7330 138 144 34 1 13088 nil 7472 nil nil 1 nil nil nil 13360 nil 8 1758664336 ##(Smalltalk.BasicListAbstract) ##(Smalltalk.IconicListAbstract) 7520 nil nil nil nil nil #smallIcons nil nil nil nil nil 770 138 144 34 3 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 193 13392 8 '' 13360 834 #setSingleSelection: 8 #(1) 13360 834 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 13360 3 8 #() 994 193 193 nil 27 nil 12960 994 33 33 7794 13248 nil 1 7826 994 843 3 994 875 35 nil 3282 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[27 0 0 0 4 0 0 0 210 1 0 0 148 2 0 0] 193 13280 8 '' 13248 3 34 1 13216 994 193 193 nil 27 34 2 8 1140850688 131073 13216 nil nil nil 1029 nil nil nil 13216 738 ##(Smalltalk.ResourceToolboxPresenter) #resource_Default_view nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 18 0 0 0 183 1 0 0 144 2 0 0] 193 14016 8 '' 13216 3 976 994 193 193 nil 27 13216 nil nil nil 170 192 976 nil 13360 13248 994 745 959 401 1 524319 nil nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 193 12992 8 '' 12960 3 34 2 13248 13360 994 193 193 nil 27 11122 8 46 186 232 162 139 46 234 63 false 170 192 34 2 12960 8 'toolsSlidey' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 193 3040 8 '' 3008 3 34 3 12960 410 ##(Smalltalk.Splitter) 34 12 nil 3008 34 2 8 1140850688 1 14656 nil nil nil 517 nil nil nil 11234 14656 nil 1 #left nil nil nil 11264 11280 nil 11264 nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[214 1 0 0 0 0 0 0 219 1 0 0 152 2 0 0] 193 14688 8 '' 14656 3 8 #() 994 193 193 nil 27 3136 994 193 193 nil 27 8 'main' nil 770 138 144 34 1 834 #createWindow: 34 1 882 914 8 #[0 0 0 0 25 0 0 0 15 4 0 0 177 2 0 0] 193 2896 8 '' 2864 3 34 1 3008 994 193 193 nil 27 170 192 34 4 2048 8 'statusbar' 528 8 'toolbar' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 7 3202 nil true 34 16 3250 1 3282 #newShellView 8 '&New Shell View' 9373 1 3330 nil true 3376 8 'ShellView.ico' 3424 nil nil 3250 1 3282 #newDialogView 8 'New &Dialog View' 1 1 3330 nil true 3376 8 'DialogView.ico' 3424 nil nil 3698 4097 3250 1 3282 #viewOpen 8 '&Open...' 9375 1 nil nil nil 3250 1 3282 #viewClose 8 '&Close' 1 1 nil nil nil 3250 1 3282 #viewRevert 8 '&Revert' 1 1 788806 1 ##(Smalltalk.TextTileIcon) $🔁 nil nil 594 #commonGreen nil nil 1 nil nil nil nil 3698 4097 3250 1 3282 #viewImport 8 '&Import View...' 1 1 nil nil nil 3250 1 3282 #viewExport 8 '&Export View...' 1 1 nil nil nil 3698 4097 3250 1 3282 #viewSave 8 '&Save' 1 1 3330 nil true 3376 8 'FileSave.ico' 3424 nil nil 3250 1 3282 #viewSaveAs 8 'Save &As...' 1 1 nil nil nil 3698 4097 3250 1 3282 #viewTest 8 '&Test' 9385 1 3330 nil true 3376 8 'TestView.ico' 3424 nil nil 3698 4097 3250 1 3282 #exit 8 'E&xit' 17639 1 15586 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil 16275 nil nil 3202 nil true 34 12 3250 1 3282 #viewUndo 8 '&Undo' 9397 1 3330 nil true 3376 8 'EditUndo.ico' 3424 nil nil 3250 1 3282 #viewRedo 8 '&Redo' 9395 1 3330 nil true 3376 8 'EditRedo.ico' 3424 nil nil 3698 4097 3250 1 3282 #cutSelection 8 'Cu&t' 9393 1 3330 nil true 3376 8 'EditCut.ico' 3424 nil nil 3250 1 3282 #copySelection 8 '&Copy' 9351 1 3330 nil true 3376 8 'EditCopy.ico' 3424 nil nil 3250 1 3282 #pasteClipboard 8 '&Paste' 9389 1 3330 nil true 3376 8 'EditPaste.ico' 3424 nil nil 3250 1 3282 #clearSelection 8 '&Delete' 1 1 3330 nil true 3376 8 'EditClear.ico' 3424 nil nil 3698 4097 3250 1 3282 #widenSelection 8 '&Widen Selection' 9387 1 nil nil nil 3250 1 3282 #selectAll 8 'Select &All' 9347 1 nil nil nil 3698 4097 3250 1 3282 #refresh 8 'Refresh' 1257 1 3330 nil true 3376 8 'Refresh.ico' 3424 nil nil 8 '&Edit' nil 134217729 nil nil 16295 nil nil 3202 nil true 34 17 3250 1 3282 #editMenuBar 8 '&Menu Bar...' 1 1 nil nil nil 3250 1 3282 #editContextMenu 8 '&Context Menu...' 1 1 nil nil nil 3698 4097 3250 1 3282 #toggleTabStop 8 'Make &Tab Stop' 1 1 nil nil nil 3250 1 3282 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 3698 4097 3202 nil true 34 7 3250 1 3282 #alignLefts 8 '&Lefts' 1 1 nil nil nil 3250 1 3282 #alignCenters 8 '&Centres' 1 1 nil nil nil 3250 1 3282 #alignRights 8 '&Rights' 1 1 nil nil nil 3698 4097 3250 1 3282 #alignTops 8 '&Tops' 1 1 nil nil nil 3250 1 3282 #alignMiddles 8 '&Middles' 1 1 nil nil nil 3250 1 3282 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 '&Align' nil 134217729 nil nil 16317 nil nil 3202 nil true 34 5 3250 1 3282 #matchWidths 8 '&Widths' 1 1 nil nil nil 3250 1 3282 #matchHeights 8 '&Heights' 1 1 nil nil nil 3250 1 3282 #matchFonts 8 '&Fonts' 1 1 nil nil nil 3250 1 3282 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 3250 1 3282 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'Matc&h' nil 134217729 nil nil 16329 nil nil 3202 nil true 34 4 3250 1 3282 #zFront 8 'Bring to &Front' 9357 1 nil nil nil 3250 1 3282 #zForward 8 'Bring F&orward' 13453 1 nil nil nil 3250 1 3282 #zBackward 8 'Send B&ackward' 13463 1 nil nil nil 3250 1 3282 #zBack 8 'Send to Bac&k' 9367 1 nil nil nil 8 'A&rrange' nil 134217729 nil nil 16339 nil nil 3202 nil true 34 4 3250 1 3282 #nudgeLeft 8 '&Left' 9803 1 nil nil nil 3250 1 3282 #nudgeRight 8 '&Right' 9807 1 nil nil nil 3250 1 3282 #nudgeUp 8 '&Up' 9805 1 nil nil nil 3250 1 3282 #nudgeDown 8 '&Down' 9809 1 nil nil nil 8 '&Nudge' nil 134217729 nil nil 16349 nil nil 3202 nil true 34 4 3250 1 3282 #increaseHeight 8 '&Taller' 13905 1 nil nil nil 3250 1 3282 #increaseWidth 8 '&Fatter' 13903 1 nil nil nil 3250 1 3282 #decreateHeight 8 '&Shorter' 13901 1 nil nil nil 3250 1 3282 #decreaseWidth 8 'Th&inner' 13899 1 nil nil nil 8 'Gro&w' nil 134217729 nil nil 16359 nil nil 3698 4097 3202 nil true 34 3 3250 1 3282 #distributeHorizontally 8 'Distri&bute Evenly' 1 1 nil nil nil 3250 1 3282 #increaseHorizontalGaps 8 '&Increase' 1 1 nil nil nil 3250 1 3282 #decreaseHorizontalGaps 8 '&Decrease' 1 1 nil nil nil 8 'Hori&zontal Spacing' nil 134217729 nil nil 16367 nil nil 3202 nil true 34 3 3250 1 3282 #distributeVertically 8 'Distri&bute Evenly' 1 1 nil nil nil 3250 1 3282 #increaseVerticalGaps 8 '&Increase' 1 1 nil nil nil 3250 1 3282 #decreaseVerticalGaps 8 '&Decrease' 1 1 nil nil nil 8 '&Vertical Spacing' nil 134217729 nil nil 16375 nil nil 3698 4097 3250 1 3282 #mutate 8 'M&utate View...' 1 1 nil nil nil 3250 1 3282 #dereference 8 '&Dereference to Copy' 1 1 nil nil nil 8 '&Modify' nil 134217729 nil nil 16381 nil nil 3202 nil true 34 14 3250 1 3282 #browseIt 8 '&Browse It' 9349 1 3330 nil true 3376 8 'ClassBrowserShell.ico' 3424 nil nil 3250 1 3282 #displayIt 8 '&Display It' 9353 1 3330 nil true 3376 8 'DisplayIt.ico' 3424 nil nil 3250 1 3282 #printIt 8 '&Print It' 9377 1 3330 nil true 3376 8 'PrintIt.ico' 3424 nil nil 3250 1 3282 #evaluateIt 8 '&Evaluate It' 9355 1 3330 nil true 3376 8 'EvaluateIt.ico' 3424 nil nil 3250 1 3282 #inspectIt 8 '&Inspect It' 9363 1 3330 nil true 3376 8 'BasicInspector.ico' 3424 nil nil 3250 1 3282 #debugIt 8 'Deb&ug It' 1269 1 3330 nil true 3376 8 'Debugger.ico' 3424 nil nil 3250 1 3282 #fileItIn 8 '&File it In' 1 1 nil nil nil 3698 4097 3250 1 3282 #browseDefinitions 8 'Defi&nitions...' 1271 1 nil nil nil 3250 1 3282 #browseReferences 8 '&References...' 5367 1 nil nil nil 3698 4097 3250 1 3282 #accept 8 '&Accept' 9383 1 nil nil nil 3698 4097 3202 nil true 34 9 3250 1 3282 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 3250 1 3282 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 3250 1 3282 #toggleLineEndings 8 'Line &Endings' 1 1 15586 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 3250 1 3282 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 3250 1 3282 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 3250 1 3282 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 3250 1 3282 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 3698 4097 3202 nil true 34 2 3250 1 3282 459270 ##(Smalltalk.Message) #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 3250 1 3282 20210 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil 16421 nil nil 8 '&Options' nil 134217729 3330 nil true 3376 8 'Preferences.ico' 3424 nil 16423 nil nil 8 '&Workspace' nil 134217729 nil nil 16425 nil nil 3202 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil 16427 nil nil 3202 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil 16429 nil nil 3202 nil true 34 15 3250 1 3282 #helpContents 8 '&Contents' 1025 1 3330 nil true 3376 8 'Help.ico' 3424 nil nil 3250 1 3282 #help 8 'On this &Tool' 1249 1 nil nil nil 3250 1 3282 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 3698 4097 3250 1 3282 #learnSmalltalk 8 'Learn Smalltalk' 1 1 15586 $🎓 nil 594 #orchid 594 #white nil nil 1 nil nil nil nil 3698 4097 3250 1 3282 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 3250 1 3282 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 3250 1 3282 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 3698 4097 3250 1 3282 #dolphinHomePage 8 'Dolphin Homepage' 1 1 3330 nil true 3376 8 '!!APPLICATION' 3424 nil nil 3250 1 3282 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 3250 1 3282 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 3698 4097 3250 1 3282 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 15586 $🐬 nil nil 594 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil 16453 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 770 138 144 34 1 834 #createWindow: 34 1 882 7826 994 1 1 994 2111 1541 193 448 8 'View Composer' 416 1 34 3 528 2864 2048 994 193 193 nil 27 )!

toolsFolderHelpId
	^10593! !

!ViewComposer class categoriesForMethods!
addToClipboard:!clipboard operations!private! !
appendToClipboard:!clipboard operations!private! !
clearClipboard!clipboard operations!public! !
clipboard!accessing!public! !
clipboard:!accessing!public! !
copyAllToClipboard:!clipboard operations!public! !
defaultDefaultView!initializing!private! !
defaultGridResolution!constants!public! !
defaultGridResolution:!constants!public! !
displayOn:!displaying!public! !
extentImage!constants!private! !
icon!constants!public! !
initialize!initializing!private! !
openOn:!instance creation!public! !
positionImage!constants!private! !
publishedAspects!constants!public! !
resource_Vertical_view!public!resources-views! !
toolsFolderHelpId!public! !
!

