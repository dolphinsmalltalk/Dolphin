"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkToolShell
	subclass: #'Tools.ViewComposer'
	instanceVariableNames: 'toolboxPresenter status arenaPresenter inspector composingView ownsComposingView resourceIdentifier addPositionOffset grabbers selections grid viewHierarchyPresenter primarySelection vcFlags modificationStatus image undoList'
	classVariableNames: 'Clipboard DefaultGridResolution ExtentImage PositionImage'
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {
			'ModifiedFlag' -> 16r1.
			'MouseClickFlag' -> 16r2.
			'RefreshFlag' -> 16r8.
			'UndoRedoFlag' -> 16r10
		}!

Tools.ViewComposer guid: (Core.GUID fromString: '{045641aa-90d2-43e8-a81c-a3f76d7d35b4}')!

Tools.ViewComposer comment: 'The View Composer is Dolphin''s GUI builder. It is used to graphically create views (the user interface components of the MVP framework). 

The view resources are saved down as class-side methods, usually associated with the presenter classes to which the views will be attached. These methods are given selectors of the form, #resource_xxxx_yyyy, where xxxx_yyyy is the resource identifier. The resource methods answer an array of Smalltalk literals that can be used to rebuild an instance of the view when loaded via an `STLInFiler`.

The View Composer works by loading its ''composing view'' as a child of the desktop and positioning it offscreen so that it is invisible to the user. It then uses `WM_PRINT` messages to render an image of this view which it displays in its arenaPresenter. Using this shadow image of the real view has a couple of benefits. The first is that mouse clicks over the image can be intercepted directly, whereas mouse clicks over the real view would be handled by the Windows controls themselves. We also discovered that placing a real shell view inside another (e.g. as a composing view inside the View Composer) caused the menu bars for the shell view not to be displayed.


##High Dpi

We want to do all editing at a fixed DPI, the natural choice being device-independent pixels (aka DIPs), which is 96 dpi. To achieve this we create the hidden instance of the view being editing with a DPI awareness context of ''unaware'', which results in Windows virtualizing the pixel extents and positions, etc, to 96-dpi. The rendering of the view in the View Composer''s arena is a bitmap captured by sending a WM_PRINT message to the view. This will render at 96-dpi, so could end up being very small if viewed on a system with scaling of 200%+. We could just stretch this to fit, but the scaling up a bitmap gives very poor results. Scaling by Windows of the 96-dpi view may be blurry (although we can even avoid most of that by using the new gdi-scaling mode), but this is still much better than the results from StretchBlt. We would also have the additional complexity of mapping between the physical pixel positions at which the arena operates, and the logical DIPs of the edited view. It makes sense, therefore, for the at least the `ViewComposerArea` to be operating at 96-dpi too. We could open the entire VC at 96-dpi, but aside from the fact that the whole thing will be blurry, this has other important side effects. The most significant of these is that all new windows opened when the VC is processing a message will inherit the same DPI awareness context by default unless we explicitly switch the DPI awareness context. Changing the DPI awareness context at appropriate for the whole VC would generate quite a lot of additional complexity. Fortunately the DPI awareness mechanisms in modern Windows are quite sophisticated, and we can even have window with differing DPI awareness within the same window hierarchy, which is known as ''mixed DPI hosting behaviour''. We have to enable mixed hosting explicitly on the immediate parent of the arena (a `ScrollingDecorator`) . The documentation warns ominously of unexpected (but undetailed) side-effects of turning it on in general, but by doing for a single container we can then create just the arena sub-view in an ''unaware'' DPI awareness context. The system then scales the composed view image and we get a reasonable visual result along with 96-dpi editing, especially if the GDI scaled unaware mode is used. Mixed hosting does also add some complexity, however, as we need to be aware of the DPI awareness context we should be using when interacting between the arena and the rest of the VC, but this seems manageable.




'!

!Tools.ViewComposer categoriesForClass!MVP-Presenters! !

!Tools.ViewComposer methodsFor!

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
		remove: aView ifAbsent: nil;
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

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #bottomAlign!

alignCenters
	"Aligns the vertical centres of all the selections to match that of the
	primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #centerX!

alignLefts
	"Aligns the left edges of all the selections to match that of the
	primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #leftAlign!

alignMiddles
	"Aligns the horizontal centres of all the selections to match that of the
	primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #centerY!

alignRights
	"Aligns the right edges of all the selections to match that of the
	primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #rightAlign!

alignTops
	"Aligns the top edges of all the selections to match that of the
	primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #topAlign!

allResourceIdentifiers
	^self systemModel allResourceIdentifiers!

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

	^self developmentSystem loadViewResource: aResourceArray inContext: contextView!

basicPasteResourceLink: aLiteralResourceIdentifier context: contextView 
	"Private - Pastes reference to aLiteralResourceIdentifier into contextView. Answers the
	pasted view. Generally, #pasteResourceLink:context:position: should be used instead, as that
	will take care of selection etc."

	^contextView addSubView: (ReferenceView resourceIdentifier: aLiteralResourceIdentifier)!

browseIt
	"Open a new class browser on the hierarchy at the same point as the receiver."

	<commandQuery: #hasComposingView>
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

canWidenSelection
	| selected |
	selected := self primarySelection.
	^selected notNil and: [selected ~~ self composingView]!

centerHorizontally
	"Move the selections so that the primary selection is centred horizontally in its parent,
	but maintaining the relative positions of the other selections."

	<commandQuery: #hasMoveableSelection>
	self inDesignDpiContextDo: 
			[| primaryRectangle center delta |
			self arena hideAdornment.
			primaryRectangle := self primarySelection rectangle.
			center := self primarySelection parentView getClientRect centerX.
			delta := primaryRectangle centerX - center.
			self selections
				do: [:each | self repositionView: each to: (each position x - delta rounded) @ each position y]]!

centerVertically
	"Move the selections so that the primary selection is centred vertically in its parent, but
	maintaining the relative positions of the other selections."

	self inDesignDpiContextDo: 
			[| primaryRectangle center delta |
			self arena hideAdornment.
			primaryRectangle := self primarySelection rectangle.
			center := self primarySelection parentView getClientRect centerY.
			delta := primaryRectangle centerY - center.
			self selections
				do: [:each | self repositionView: each to: each position x @ (each position y - delta rounded)]]!

chooseBackgroundColor
	"Set the background color of all selected objects to the users choice from a ColorDialog."

	<commandQuery: #hasSelection>
	| color |
	color := Color choose.
	color notNil ifTrue: [selections do: [:v | v backcolor: color]]!

chooseFont
	"Set the font of all selected objects to the users choice from a FontDialog."

	<commandQuery: #hasSelection>
	| font |
	font := Font choose.
	font notNil ifTrue: [selections do: [:v | v font: font]]!

chooseForegroundColor
	"Set the foreground color of all selected objects to the users choice from a ColorDialog."

	<commandQuery: #hasSelection>
	| color |
	color := Color choose.
	color notNil ifTrue: [selections do: [:v | v forecolor: color]]!

clearSelection
	"Removes the current selections from the receiver"

	<commandQuery: #hasSelection>
	| prompt selCount |
	selCount := selections size.
	prompt := selCount > 1
				ifTrue: ['Are you sure you wish to remove the <p> selected views?' expandMacrosWith: selCount]
				ifFalse: 
					['Are you sure you wish to remove the selected <p>?' expandMacrosWith: selections first class].
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

composingViewStl
	^self inDesignDpiContextDo: [composingView literalStoreArray]!

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

	<commandQuery: #hasSelection>
	self class copyAllToClipboard: selections!

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

	<commandQuery: #hasSelection>
	self
		copySelection;
		deleteSelections!

decreaseHeight
	<commandQuery: #hasSelection>
	self resizeBy: 0 @ -1!

decreaseHorizontalGaps
	"Decrease the gap between the selected views in the horizontal plane. The views move toward
	from the centre line of the parent."

	<commandQuery: #hasSiblingSelections>
	self nudgeHorizontalGaps: -1!

decreaseVerticalGaps
	"Deccrease the gap between the selected views in the vertical plane. The views move toward
	from the middle line of the parent."

	<commandQuery: #hasSiblingSelections>
	self nudgeVerticalGaps: -1!

decreaseWidth
	<commandQuery: #hasSelection>
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
	selections copy do: [:each | self removeView: each].
	self setModified.
	self arena invalidate.
	self hasComposingView ifTrue: [self composingView validateLayout] ifFalse: [self isModified: false]!

dereference
	"Dereference the primary selection which is an instance of ReferenceView."

	<commandQuery: #isPrimaryReference>
	| referenceView dereferencedView |
	referenceView := self primarySelection.
	(MessageBox new
		headline: 'Dereference selected ReferenceView?';
		confirm: 'This reference to ''<1d>'' will be replaced by a copy.<n><n>Are you sure you want to continue?'
					<< referenceView resourceIdentifier)
			ifFalse: [^self].
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

	<commandQuery: #hasSiblingSelections>
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

	<commandQuery: #hasSiblingSelections>
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
			resource := self inDesignDpiContextDo: [aView literalStoreArray].
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

	<commandQuery: #hasPrimarySelection>
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

	<commandQuery: #isComposingTopView>
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

	<commandQuery: #isPrimaryReference>
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

	<commandQuery: #hasComposingView>
	self viewSave!

forceLayoutFor: aContainerView
	"Private - Forces the relaying out of aContainerView, presumably because its contents have changed"

	aContainerView invalidateLayout.
	self composingView notNil ifTrue: [
		self composingView invalidateLayout; validateLayout ]!

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

hasMultipleSelections
	"Private - Answer true if more than one item is selected."

	^selections size > 1!

hasOwnedComposingView: aView 
	^self composingView == aView and: [self ownsComposingView]!

hasPrimarySelection
	^self primarySelection notNil!

hasReferenceSelection
	^self primarySelection isKindOf: ReferenceView!

hasResource
	"Private - Answer true if the receiver has a full resource identifier"

	^resourceIdentifier notNil and: [resourceIdentifier name notNil ]!

hasSelection
	"Private - Answer true if there are any selections"

	^selections notEmpty

!

hasSiblingSelections
	^self hasMultipleSelections
		and: [(selections collect: [:each | each parentView]) asSet size = 1]!

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

	^(OS.SystemMetrics current virtualScreenRectangle right - 1) @ 10!

increaseHeight
	<commandQuery: #hasSelection>
	self resizeBy: 0 @ 1!

increaseHorizontalGaps
	"Increase the gap between the selected views in the horizontal plane. The views move away
	from the centre line of the parent."

	<commandQuery: #hasSiblingSelections>
	self nudgeHorizontalGaps: 1!

increaseVerticalGaps
	"Increase the gap between the selected views in the vertical plane. The views move away
	from the middle line of the parent."

	<commandQuery: #hasSiblingSelections>
	self nudgeVerticalGaps: 1!

increaseWidth
	<commandQuery: #hasSelection>
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

isComposingTopView
	^self composingView class conformsToProtocol: #topView!

isComposingViewPrimarySelection
	^primarySelection == self composingView!

isEditingExistingResource
	^self hasComposingView and: [self hasResource]!

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

isPrimaryReference
	^self primarySelection isKindOf: ReferenceView!

isSelected: aView
	"Private - Answer true if the aView is selected"

	^selections includes: aView
!

isUndoRedoInProgress
	^vcFlags anyMask: UndoRedoFlag!

matchBackgroundColors
	"Matches the background colors of all the selections to that of the primary selection."

	<commandQuery: #hasMultipleSelections>
	| color |
	color := primarySelection backcolor.
	self secondarySelections do: [:v | v backcolor: color].
	self setModified!

matchFonts
	"Matches the fonts of all the selections to that of the primary selection."

	<commandQuery: #hasMultipleSelections>
	| font |
	font := primarySelection font.
	self secondarySelections do: [:v | v font: font].
	self setModified!

matchForegroundColors
	"Matches the foreground colors of all the selections to that of the primary selection."

	<commandQuery: #hasMultipleSelections>
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

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #height!

matchSizes
	"Matches the sizes of all the selections to that of the primary selection"

	<commandQuery: #hasMultipleSelections>
	self
		matchHeights;
		matchWidths!

matchWidths
	"Matches the widths of all the selections to that of the primary selection"

	<commandQuery: #hasMultipleSelections>
	self matchGeometryAspect: #width!

maxUndoStates
	^40!

moveableSelections
	"Private - Answer an OrderedCollection of selections which can be
	moved during a positioning operation. We remove all subViews that
	are having their parents moved"
	
	| moveableSelections |
	moveableSelections := selections select: [ :each | self canMove: each ].
	^moveableSelections select: [ :each | 
		(each allParents intersection: moveableSelections) isEmpty ]
!

mutate
	"Mutate the primary selection to a user's choice of view"

	<commandQuery: #hasSelection>
	| viewClasses excluded |
	excluded := Set new.
	#(#{DesktopView} #{Smalltalk.WinAsyncSocket})
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
	self inDesignDpiContextDo: 
			[self moveableSelections do: [:each | self repositionView: each to: each position + aPoint]]!

nudgeDown
	<commandQuery: #hasMoveableSelection>
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
	<commandQuery: #hasMoveableSelection>
	self nudgeBy: -1 @ 0!

nudgeRight
	<commandQuery: #hasMoveableSelection>
	self nudgeBy: 1 @ 0!

nudgeUp
	<commandQuery: #hasMoveableSelection>
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
			[(MessageBox new
				owner: self view;
				headline: 'There are unsaved changes';
				confirm: 'Do you wish to retain them?')
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

	<commandQuery: #canPaste>
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
	| wasActive dpiContext |
	wasActive := self view isActive.
	vcFlags := vcFlags maskSet: UndoRedoFlag.
	dpiContext := OS.User32
				setThreadDpiAwarenessContext: (OS.User32 getWindowDpiAwarenessContext: self arena handle).
	aNiladicValuable ensure: 
			[vcFlags := vcFlags maskClear: UndoRedoFlag.
			OS.User32 setThreadDpiAwarenessContext: dpiContext].
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

queryRedo: aCommandQuery
	aCommandQuery isEnabled: undoList hasFuture!

queryToggleGroupStop: aCommandQuery
	self hasSelection
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: (selections allSatisfy: [:v | v isGroupStop])]!

queryToggleTabStop: aCommandQuery
	self hasSelection
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: (selections allSatisfy: [:v | v isTabStop])]!

queryUndo: aCommandQuery
	aCommandQuery isEnabled: undoList hasPast!

referenceViewMenu
	<commandQuery: #isPrimaryReference>
!

refreshImage
	" Re-render the composing view and display it in the arenaPresenter."

	self isImageDirty: true.
	inspector view invalidate!

refreshPublishedAspects
	inspector refresh!

removeHorizontalGaps
	"Remove any vertical spacing between the selected controls."

	<commandQuery: #hasSiblingSelections>
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

	<commandQuery: #hasSiblingSelections>
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
	(selections includes: aView) 
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
					state := self developmentSystem loadViewResource: aLiteralStoreArray inContext: self designDesktop.
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
	self resourceIdentifier storeOn: aWriteStream.
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
	selections addAll: anOrderedCollection.
	"The mouse click flag is used to suppress some of the response to selection in the view
	hierarchy tree, which we must do as otherwise selection of the first element in the
	collection in the tree will result in all other selections being discarded."
	wasClick := self isMouseClick.
	
	[self isMouseClick: true.
	self updatePrimarySelection] ensure: [self isMouseClick: wasClick]!

selectionsByHorizontalPosition
	^selections asSortedArray: [:a :b | a x < b x]!

selectionsByVerticalPosition
	^selections asSortedArray: [:a :b | a y < b y]!

setModified
	"Private - Sets the modification flag for the receiver"

	self isModified: true!

shortCaption
	| stream |
	stream := String smalltalkWriteStream: 32.
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
	"Toggle the primary selection's WS_GROUP style, and set that of any other selected items to match."

	<commandQuery: #queryToggleGroupStop:>
	| gs |
	gs := self primarySelection isGroupStop not.
	selections do: [:v | v isGroupStop: gs].
	self setModified!

toggleSelectionFor: aView
	"Private - Toggles the selection state for aView"

	(selections includes: aView) 
		ifTrue: [ self cancelSelectionFor: aView ]
		ifFalse: [ self addSelectionFor: aView ]

!

toggleTabStop
	"Toggle the primary selection's WS_TABSTOP style, and set that of any other selected items to match."

	<commandQuery: #queryToggleTabStop:>
	| ts |
	ts := self primarySelection isTabStop not.
	selections do: [:v | v isTabStop: ts].
	self setModified!

undoState
	^self composingView
		ifNil: [self getUndoState]
		ifNotNil: [:cv | cv whileInvisibleDo: [self getUndoState]]!

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
	actualPrimarySelection := selections notEmpty ifTrue: [selections first ].
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

	<commandQuery: #hasComposingView>
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

	<commandQuery: #hasComposingView>
	| filename path |
	path := self hasResource ifTrue: [resourceIdentifier exportedFileName].
	filename := FileSaveDialog new
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
	<commandQuery: #queryRedo:>
	self performUndoRedo: [self restoreUndoState: (undoList goForward: 1)]!

viewRevert
	"Revert the contents of the receiver's document to those in the
	associated file"

	<commandQuery: #isEditingExistingResource>
	| rid |
	rid := resourceIdentifier.
	(MessageBox new
		headline: 'Revert to saved view?';
		confirm: 'Are you sure you wish to revert to the previously saved copy?')
			ifTrue: 
				[self
					endComposition;
					openOn: rid]!

viewSave
	"Save the view as a resource."

	<commandQuery: #hasComposingView>
	| rid |
	self hasResource ifFalse: [^self viewSaveAs].
	rid := self resourceIdentifier.
	
	[self inDesignDpiContextDo: [rid assignView: self composingView].
	self isModified: false] on: Compiler errorClass
			do: 
				[:ex |
				| syntaxError |
				syntaxError := ex description.
				(MessageBox new
					caption: 'Unable to save ' , rid printString;
					iconStyle: #error;
					customButtons: #(#(#yes '&Debug') #(#no 'Cancel'));
					defaultButton: 2;
					headline: 'Syntax error in literal resource';
					text: syntaxError;
					isCancellable: true;
					confirm) ifTrue: [Processor activeProcess debug] ifFalse: [syntaxError return]]!

viewSaveAs
	"Save the composed view as a resource."

	<commandQuery: #hasComposingView>
	| rid |
	resourceIdentifier isNil
		ifTrue: [rid := ResourceIdentifier class: Presenter name: Presenter defaultView]
		ifFalse: 
			[rid := resourceIdentifier copy.
			rid name isNil ifTrue: [rid name: Presenter defaultView]].
	(rid := rid prompt) isNil ifTrue: [^false].
	rid exists
		ifTrue: 
			[(MessageBox new
				headline: 'Overwrite existing resource?';
				confirm: '''<d>'' is an existing resource. Do you wish to replace it?' << rid) ifFalse: [^false]].
	self resourceIdentifier: rid.
	self
		updateCaption;
		viewSave!

viewTest
	"Load the resource (being edited by the ViewComposer) in a test mode."

	<commandQuery: #hasComposingView>
	| testView parentView stl |
	parentView := (self composingView isKindOf: ShellView)
				ifTrue: [View desktop]
				ifFalse: 
					[ShellView show
						layoutManager: GridLayout new;
						yourself].
	stl := self composingViewStl.
	testView := Object fromLiteralStoreArray: stl context: parentView.
	self view repositionShell: testView topView.
	testView show!

viewUndo
	<commandQuery: #queryUndo:>
	self performUndoRedo: [self restoreUndoState: (undoList goBack: 1)]!

widenSelection
	"Widen the selection to encompass the parent of the current primary selection."

	<commandQuery: #canWidenSelection>
	self canWidenSelection ifTrue: [self selection: self primarySelection parentView]!

zBack
	"Send the primary selection to the back of the Z-order."

	<commandQuery: #hasPrimarySelection>
	| editee |
	editee := self primarySelection.
	editee zOrderBottom.
	self zOrderChangedFor: editee!

zBackward
	"Move the primary selection down one place in the Z-order."

	<commandQuery: #hasPrimarySelection>
	| nextSibling editee |
	editee := self primarySelection.
	nextSibling := editee nextSiblingView.
	nextSibling notNil ifTrue: [editee zOrderAfter: nextSibling].
	self zOrderChangedFor: editee!

zForward
	"Move the primary selection up one place in the Z-order."

	<commandQuery: #hasPrimarySelection>
	| sibling editee |
	"We can only Zposition a view AFTER a specified sibling.
	So, locate the sibling two places in front and Zposition
	the receiver after it."
	editee := self primarySelection.
	sibling := editee previousSiblingView.
	sibling notNil
		ifTrue: 
			[sibling := sibling previousSiblingView.
			sibling notNil ifTrue: [editee zOrderAfter: sibling]].
	sibling isNil ifTrue: [editee zOrderTop].
	self zOrderChangedFor: editee!

zFront
	"Bring the primary selection to the front of the Z-order."

	<commandQuery: #hasPrimarySelection>
	| editee |
	editee := self primarySelection.
	editee zOrderTop.
	self zOrderChangedFor: editee!

zOrderChangedFor: aView 
	"Private - The ZOrder position of aView has been changed. Inform the 
	view hierarchy model so that its views update appropriately"

	viewHierarchyPresenter model move: aView asChildOf: (viewHierarchyPresenter model parentOf: aView)! !

!Tools.ViewComposer categoriesForMethods!
addGrabbers!adornments!private! !
addSelectionFor:!adornments!private! !
adjustScroll!geometry!private! !
alignBottoms!commands-actions!public! !
alignCenters!commands-actions!public! !
alignLefts!commands-actions!public! !
alignMiddles!commands-actions!public! !
alignRights!commands-actions!public! !
alignTops!commands-actions!public! !
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
browseIt!commands-actions!public! !
cancelSelectionFor:!adornments!private! !
cancelSelections!adornments!private! !
canMove:!private!testing! !
canPaste!private!testing! !
canSaveState!private!saved state! !
canSize:!private!testing! !
canWidenSelection!commands-queries!private! !
centerHorizontally!commands-actions!public! !
centerVertically!commands-actions!public! !
chooseBackgroundColor!commands-actions!public! !
chooseFont!commands-actions!public! !
chooseForegroundColor!commands-actions!public! !
clearSelection!commands-actions!public! !
clearUndoState!operations!private! !
clipboard!accessing!public! !
closeComposingView!helpers!private! !
composingView!accessing!public! !
composingView:isOwned:!accessing!private! !
composingViewStl!helpers!public! !
copyAspectsFrom:to:!operations!private! !
copySelection!commands-actions!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
createViewHierarchyModel!helpers!initializing!private! !
cutSelection!commands-actions!public! !
decreaseHeight!commands-actions!public! !
decreaseHorizontalGaps!commands-actions!public! !
decreaseVerticalGaps!commands-actions!public! !
decreaseWidth!commands-actions!public! !
defaultComposingPosition!constants!private! !
defaultGridResolution!constants!private! !
defaultHelpId!public! !
deleteSelections!operations!public! !
dereference!commands-actions!public! !
designDesktop!helpers!private! !
distributeHorizontally!commands-actions!public! !
distributeVertically!commands-actions!public! !
drawAdornment!adornments!private! !
dropIncrement!constants!private! !
dropUndoState!operations!private! !
dropView:onto:at:!drag & drop!private! !
dropViewResource:onto:at:named:!drag & drop!private! !
editContextMenu!commands-actions!public! !
editMenuBar!commands-actions!public! !
editReference!commands-actions!public! !
endComposition!operations!public! !
fileNew!commands-actions!public! !
fileOpen!commands-actions!public! !
fileSave!commands-actions!public! !
forceLayoutFor:!geometry!private! !
getUndoState!public! !
grabbers!adornments!private! !
grid!accessing!private! !
grid:!accessing!private! !
gridSetting!commands-actions!public! !
hasClipboard!private!testing! !
hasComposingView!private!testing! !
hasMoveableSelection!private!testing! !
hasMultipleSelections!private!testing! !
hasOwnedComposingView:!public! !
hasPrimarySelection!private!testing! !
hasReferenceSelection!commands!private! !
hasResource!private!testing! !
hasSelection!private!testing! !
hasSiblingSelections!commands-queries!private! !
hideAdornment!adornments!private! !
hidingOffset!constants!private! !
increaseHeight!commands-actions!public! !
increaseHorizontalGaps!commands-actions!public! !
increaseVerticalGaps!commands-actions!public! !
increaseWidth!commands-actions!public! !
incrementAddPositionOffset!operations!private! !
inDesignDpiContextDo:!helpers!private! !
initialComposingPosition!constants!private! !
initialize!initializing!private! !
inspector!accessing!private! !
inspectSelection!commands-actions!public! !
invalidateAdornmentFor:!adornments!private! !
isComposingTopView!commands-queries!private! !
isComposingViewPrimarySelection!private!testing! !
isEditingExistingResource!commands-queries!private! !
isImageDirty!private! !
isImageDirty:!private! !
isModified!public!testing! !
isModified:!accessing!private! !
isMouseClick!private!testing! !
isMouseClick:!accessing!private! !
isPrimaryReference!commands-queries!private! !
isSelected:!private!testing! !
isUndoRedoInProgress!private! !
matchBackgroundColors!commands-actions!public! !
matchFonts!commands-actions!public! !
matchForegroundColors!commands-actions!public! !
matchGeometryAspect:!geometry!private! !
matchHeights!commands-actions!public! !
matchSizes!commands-actions!public! !
matchWidths!commands-actions!public! !
maxUndoStates!public! !
moveableSelections!adornments!private! !
mutate!commands-actions!public! !
mutate:to:!operations!public! !
mutateTo:!operations!public! !
newDialogView!commands-actions!public! !
newShellView!commands-actions!public! !
nudgeBy:!operations!private! !
nudgeDown!commands-actions!public! !
nudgeHorizontalGaps:!operations!private! !
nudgeLeft!commands-actions!public! !
nudgeRight!commands-actions!public! !
nudgeUp!commands-actions!public! !
nudgeVerticalGaps:!operations!private! !
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
pasteClipboard!commands-actions!public! !
pasteContext!operations!private! !
pastedView:context:!operations!private! !
pasteResource:context:position:!operations!public! !
pasteResourceLink:context:position:!operations!private! !
performCommand:!commands-actions!public! !
performUndoRedo:!helpers!private! !
positionComposingView!accessing!private! !
primarySelection!adornments!private! !
primarySelection:!adornments!private! !
printShortCaptionOn:!private!updating! !
queryRedo:!commands-queries!private! !
queryToggleGroupStop:!commands-queries!private! !
queryToggleTabStop:!commands-queries!private! !
queryUndo:!commands-queries!private! !
referenceViewMenu!commands-menus!public! !
refreshImage!private! !
refreshPublishedAspects!commands-actions!public! !
removeHorizontalGaps!commands-actions!public! !
removeVerticalGaps!commands-actions!public! !
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
toggleGroupStop!commands-actions!public!tabbing! !
toggleSelectionFor:!adornments!private! !
toggleTabStop!commands-actions!public!tabbing! !
undoState!public! !
updateCaption!private!updating! !
updatePrimarySelection!adornments!private! !
updateStatusBar!operations!private! !
validateImage!private! !
validateLayout!geometry!private! !
validateUserInterface!operations!private! !
viewClose!commands-actions!public! !
viewCloseNoPrompt!operations!public! !
viewExport!commands-actions!public! !
viewExportTo:!helpers!private! !
viewHierarchyPresenter!accessing!private! !
viewImport!commands-actions!public! !
viewImportFrom:!helpers!private! !
viewOpen!commands-actions!public! !
viewRedo!public! !
viewRevert!commands-actions!public! !
viewSave!commands-actions!public! !
viewSaveAs!commands-actions!public! !
viewTest!commands-actions!public! !
viewUndo!public! !
widenSelection!commands-actions!public! !
zBack!commands-actions!public! !
zBackward!commands-actions!public! !
zForward!commands-actions!public! !
zFront!commands-actions!public! !
zOrderChangedFor:!private!updating! !
!

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

defaultDefaultSlideyPinsMap
	^##(IdentityDictionary new
		at: #inspectorSlidey put: true;
		at: #toolsSlidey put: false;
		at: #toolbarsSlidey put: false;
		yourself)!

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

	SmalltalkSystem current
		addSystemFolderIcon: self toolsFolderIcon;
		registerTool: self.
	DefaultGridResolution := 5.
	self defaultSlideyPinsMap: self defaultDefaultSlideyPinsMap!

openOn: aResourceIdentifier
	^self show openOn: aResourceIdentifier!

positionImage
	^(Icon fromId: 'POSITION.ICO') imageIndex!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	aspects
		add: ((Aspect boolean: #canUseIdeaSpace)
					defaultValue: true;
					yourself);
		add: ((Aspect integer: #defaultGridResolution)
					defaultValue: 5;
					yourself).
	^aspects!

resource_Vertical_view
	"Answer the literal data from which the 'Vertical view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Vertical_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 518 #{Graphics.ThemeColor} #toolBackground nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 18 #{UI.Toolbar} 50 28 nil 32 50 2 8 1140853580 131073 160 nil nil nil 517 nil nil nil 160 6 #{Graphics.Color} #default nil 518 #{Kernel.STBIdentityDictionaryProxy} #{Core.IdentityDictionary} 50 8 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 304 nil nil nil 5 nil nil nil 304 582 1 #{UI.ResourceIdentifier} #{UI.Toolbar} #resource_File_tools nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[13 2 0 0 0 0 0 0 90 2 0 0 25 0 0 0] 193 336 8 '' 304 3 8 #() 518 #{Graphics.Point} 193 193 nil 27 8 'fileTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 656 nil nil nil 5 nil nil nil 656 370 #{UI.Toolbar} #resource_Image_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 193 688 8 '' 656 3 592 610 193 193 nil 27 8 'imageTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 896 nil nil nil 5 nil nil nil 896 370 #{UI.Toolbar} #resource_Search_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[51 1 0 0 0 0 0 0 13 2 0 0 25 0 0 0] 193 928 8 '' 896 3 592 610 193 193 nil 27 8 'searchTools' 18 #{UI.ReferenceView} 50 14 nil 160 50 2 8 1140850688 131073 1136 nil nil nil 5 nil nil nil 1136 370 #{UI.Toolbar} #resource_Smalltalk_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[31 0 0 0 0 0 0 0 51 1 0 0 25 0 0 0] 193 1168 8 '' 1136 3 592 610 193 193 nil 27 8 'smalltalkTools' nil nil nil nil 8 #() nil nil 1 nil #smallIcons nil nil 838 1 #{UI.FlowLayout} 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 15 4 0 0 25 0 0 0] 193 192 8 '' 160 3 50 4 656 1136 896 304 610 193 193 nil 31 18 #{UI.StatusBar} 50 21 nil 32 50 2 8 1140853004 1 1584 nil nil nil 5 nil nil nil 1584 nil nil 258 #{Core.IdentityDictionary} 50 6 1862 1 #{UI.StatusBarItem} 8193 301 1584 nil 1382 3 #{Kernel.BlockClosure} 0 nil 1318 #{Kernel.CompiledExpression} 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:r | r notNil ifTrue: [r extent displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #extent #displayString 8 '' 1728 7 257 nil 450 #extentImage 8 #() #{Tools.ViewComposer} nil 8 'extentStatus' 1682 8193 37 1584 nil nil 1714 0 nil 1746 6 1 1712 8 'doIt' 8 '[:modified | modified ifTrue: [Tools.SmalltalkSystem current changedIcon imageIndex]]' 8 #[33 105 17 122 45 159 160 161 106 60 106] 1094 2 #{Kernel.VariableBinding} #SmalltalkSystem #{Tools.SmalltalkSystem} #{Tools} 1 #current #changedIcon #imageIndex 1904 #ifTrue: 7 257 nil nil 8 'modificationStatus' 1682 8193 301 1584 nil 1714 0 nil 1746 4 1 #{Core.UndefinedObject} 8 'doIt' 8 '[:r | r notNil ifTrue: [r position displayString] ifFalse: ['''']]' 8 #[32 105 17 222 4 17 158 159 106 31 106] #position #displayString 1824 2048 7 257 nil 450 #positionImage 1856 #{Tools.ViewComposer} nil 8 'positionStatus' nil nil nil 50 3 2032 1696 1888 1094 1 #{UI.StatusBarNullItem} 8705 1 1584 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 177 2 0 0 15 4 0 0 199 2 0 0] 193 1616 8 '' 1584 3 8 #() 610 193 193 nil 29 nil nil 18 #{UI.ContainerView} 50 15 nil 32 50 2 8 1140850688 131073 2368 nil nil nil 5 nil nil nil 2368 518 #{UI.ProportionalLayout} 550 #{Core.LookupTable} 0 true 258 #{Core.IdentityDictionary} 50 2 18 #{UI.ContainerView} 50 15 nil 2368 50 2 8 1140850688 131073 2528 nil nil nil 5 nil nil nil 2528 2434 518 #{Kernel.STBCollectionProxy} #{Core.Dictionary} 50 2 518 #{Core.Association} 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 2528 50 2 8 1140850688 131073 2688 nil nil nil 517 nil nil nil 2688 1350 1 #{UI.CardLayout} 550 #{Core.OrderedCollection} 1 2658 838 1 #{UI.CardLabel} 8 'View Toolbox' 1714 0 nil 1746 7 1 #{Core.AnsiString} 8 'doIt' 8 '(CardLabel text: ''View Toolbox'' iconBlock: [Icon fromId: ''View.ico''])' 8 #[29 30 35 113 31 32 180 106 195 105] 2832 2864 #{Graphics.Icon} 8 'View.ico' #fromId: #text:iconBlock: 2880 11 1 nil nil 18 #{UI.ReferenceView} 50 14 nil 18 #{UI.SlidingCardTray} 50 22 nil 2688 50 2 8 1140850688 131073 3008 nil nil nil 5 nil nil nil 3008 2768 258 #{Core.IdentityDictionary} 50 2 2976 8 'toolbox' nil 18 #{UI.TabViewXP} 50 28 nil 2688 50 2 8 1140916864 1 3120 838 2 #{UI.ListModel} 2786 1 2848 nil 6 #{Kernel.IdentitySearchPolicy} nil nil 1 nil nil nil 3120 nil nil 518 #{Core.Message} #displayString 8 #() 3266 #iconImageIndex 3296 1350 1 #{Graphics.IconImageManager} nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 193 3152 8 '' 3120 450 #setSingleSelection: 8 #(1) 3120 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 3120 3 8 #() 610 193 193 nil 27 nil 2688 610 33 33 1606 1 #{UI.ButtonInteractor} 3008 nil 1 518 #{Graphics.Rectangle} 610 843 3 610 875 35 nil 1350 4 #{UI.CommandDescription} #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[27 0 0 0 4 0 0 0 210 1 0 0 148 2 0 0] 193 3040 8 '' 3008 3 50 1 2976 610 193 193 nil 27 50 2 8 1140850688 131073 2976 nil nil nil 1029 nil nil nil 2976 370 #{Tools.ResourceToolboxPresenter} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 183 1 0 0 144 2 0 0] 193 3904 8 '' 2976 3 592 610 193 193 nil 27 2976 nil nil nil 550 #{Core.IdentityDictionary} 0 nil 3120 3008 610 745 959 401 1 524319 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 214 1 0 0 152 2 0 0] 193 2720 8 '' 2688 3 50 2 3008 3120 610 193 193 nil 27 8 0.8181818181818181 2658 18 #{UI.ContainerView} 50 15 nil 2528 50 2 8 1140850688 131073 4336 nil nil nil 5 2886 4 #{UI.Menu} nil true 50 18 1094 2 #{UI.CommandMenuItem} 1 3698 #cutSelection 8 'Cu&t' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditCut.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 4450 1 3698 #copySelection 8 '&Copy' 1 1 4514 nil true 4546 8 'EditCopy.ico' 4608 65541 nil nil nil 4450 1 3698 #pasteClipboard 8 '&Paste' 1 1 4514 nil true 4546 8 'EditPaste.ico' 4608 65541 nil nil nil 4450 1 3698 #clearSelection 8 '&Delete' 1 1 4514 nil true 4546 8 'EditClear.ico' 4608 65541 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 4450 1 3698 #inspectSelection 8 '&Inspect' 1 1 4514 nil true 4546 8 'InspectIt.ico' 4608 65541 nil nil nil 4930 4097 4450 1 3698 #editContextMenu 8 'Set Conte&xt Menu…' 1 1 nil nil nil 4930 4097 4450 1 3698 #toggleTabStop 8 'Make Tab &Stop' 1 1 nil nil nil 4450 1 3698 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 4930 4097 4402 nil true 50 7 4450 1 3698 #alignLefts 8 '&Lefts' 1 1 nil nil nil 4450 1 3698 #alignCenters 8 '&Centres' 1 1 nil nil nil 4450 1 3698 #alignRights 8 '&Rights' 1 1 nil nil nil 4930 4097 4450 1 3698 #alignTops 8 '&Tops' 1 1 nil nil nil 4450 1 3698 #alignMiddles 8 '&Middles' 1 1 nil nil nil 4450 1 3698 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 'View Alig&n' nil 134217729 nil nil nil nil nil 4402 nil true 50 5 4450 1 3698 #matchWidths 8 '&Widths' 1 1 nil nil nil 4450 1 3698 #matchHeights 8 '&Heights' 1 1 nil nil nil 4450 1 3698 #matchFonts 8 '&Fonts' 1 1 nil nil nil 4450 1 3698 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 4450 1 3698 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'View Matc&h' nil 134217729 nil nil nil nil nil 4402 nil true 50 4 4450 1 3698 #zFront 8 'Bring to &Front' 1 1 nil nil nil 4450 1 3698 #zForward 8 'Bring F&orward' 1 1 nil nil nil 4450 1 3698 #zBackward 8 'Send B&ackward' 1 1 nil nil nil 4450 1 3698 #zBack 8 'Send to Bac&k' 1 1 nil nil nil 8 'View &Arrange' nil 134217729 nil nil nil nil nil 4930 4097 4450 1 3698 #mutate 8 'M&utate View…' 1 1 nil nil nil 4402 nil true 50 2 4450 1 3698 #dereference 8 'De&reference to Copy' 1 1 nil nil nil 4450 1 3698 #editReference 8 '&Edit' 1 1 nil nil nil 8 '&Reference View' #referenceViewMenu 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil 4336 2434 2610 2464 50 2 2658 18 #{UI.ContainerView} 50 15 nil 4336 50 2 8 1140850688 131073 6416 nil nil nil 5 nil nil nil 6416 130 1 1 nil 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 6416 50 2 8 1140850688 131073 6496 nil nil nil 517 nil nil nil 6496 2754 2786 5 2658 8 'Arrange' 18 #{UI.ReferenceView} 50 14 nil 18 #{UI.SlidingCardTray} 50 22 nil 6496 50 2 8 1140850688 131073 6656 nil nil nil 5 nil nil nil 6656 6560 258 4096 50 10 18 #{UI.Toolbar} 50 28 nil 6656 50 2 8 1140853580 131073 6752 nil nil nil 517 nil 1350 1 #{Graphics.Font} nil true 262 #{OS.LOGFONTW} 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 0 65 0 114 0 105 0 97 0 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 193 nil nil 6752 240 nil 258 4096 50 4 18 #{UI.ReferenceView} 50 14 nil 6752 50 2 8 1140850688 131073 6928 nil nil nil 5 nil nil nil 6928 370 #{UI.Toolbar} #resource_View_composer_alignment_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 169 0 0 0 25 0 0 0] 193 6960 8 '' 6928 3 592 610 193 193 nil 27 8 'alignmentTools' 18 #{UI.ReferenceView} 50 14 nil 6752 50 2 8 1140850688 131073 7168 nil nil nil 5 nil nil nil 7168 370 #{UI.Toolbar} #resource_View_composer_match_size_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[169 0 0 0 0 0 0 0 13 1 0 0 25 0 0 0] 193 7200 8 '' 7168 3 592 610 193 193 nil 27 8 'matchSizeTools' nil nil nil nil 2786 0 nil nil 1 nil #smallIcons 610 45 45 nil 1394 1 1 1 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 6784 8 '' 6752 3 50 2 6928 7168 610 193 193 nil 31 8 'alignTools' 6624 8 'arrangementTools' 18 #{UI.ReferenceView} 50 14 nil 6656 50 2 8 1140850688 131073 7648 nil nil nil 5 nil nil nil 7648 370 #{UI.Toolbar} #resource_Edit_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 7680 8 '' 7648 1 592 610 193 193 nil 27 8 'editTools' 18 #{UI.ReferenceView} 50 14 nil 6656 50 2 8 1140850688 131073 7888 nil nil nil 5 nil nil nil 7888 370 #{UI.Toolbar} #resource_View_composer_spacing_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 7920 8 '' 7888 1 592 610 193 193 nil 27 8 'layoutTools' 18 #{UI.ReferenceView} 50 14 nil 6656 50 2 8 1140850688 131073 8128 nil nil nil 5 nil nil nil 8128 370 #{UI.Toolbar} #resource_View_composer_nudge_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 8160 8 '' 8128 1 592 610 193 193 nil 27 8 'nudgeTools' nil 18 #{UI.TabViewXP} 50 28 nil 6496 50 2 8 1140916738 1 8368 3186 2786 5 8 'Edit' 6608 8 'Nudge' 8 'Align' 8 'Layout' nil 3248 nil nil 1 nil nil nil 8368 nil nil 3280 3312 3344 nil nil nil nil nil #noIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 117 1 0 0 74 0 0 0] 193 8400 8 '' 8368 450 #setSingleSelection: 8 #(4) 8368 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 8368 3 8 #() 610 193 193 nil 27 nil 6496 610 33 33 3602 6656 nil 1 3634 610 695 3 610 727 35 nil 3698 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[4 0 0 0 4 0 0 0 113 1 0 0 50 0 0 0] 193 6688 8 '' 6656 3 50 5 7648 6624 8128 6752 7888 610 193 193 nil 27 50 2 8 1140850688 131073 6624 nil nil nil 5 nil nil nil 6624 370 #{UI.Toolbar} #resource_View_composer_tools nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 109 1 0 0 46 0 0 0] 193 9024 8 '' 6624 1 592 610 193 193 nil 27 2658 8480 8128 2658 8496 6752 2658 8512 7888 2658 8464 7648 6752 nil nil nil 4098 0 nil 8368 6656 610 201 201 401 1 524319 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 78 2 0 0 117 1 0 0 152 2 0 0] 193 6528 8 '' 6496 3 50 2 6656 8368 610 193 193 nil 27 nil nil 18 #{UI.ScrollingDecorator} 50 18 nil 6416 50 2 8 1143996416 131073 9472 nil nil nil 4101 nil nil nil 9472 326 1 #{UI.ScrollingDecoratorLayout} true 258 4096 50 2 18 #{Tools.ViewComposerArena} 50 22 nil 9472 50 2 8 1140850944 1 9600 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 226 #cornsilk nil 533 nil nil nil 9600 nil nil 518 #{UI.NullConverter} nil nil nil nil #normal nil 3634 610 21 21 610 21 21 nil nil 402 50 2 450 #createWindow: 50 1 518 #{UI.CreateInDpiAwarenessContext} 498 530 8 #[0 0 0 0 0 0 0 0 20 3 0 0 186 2 0 0] 193 9632 nil -9 9600 450 #text: 50 1 8 '' 9600 3 8 #() 610 193 193 nil 27 8 'arena' nil 610 1 1 true 610 17 17 402 50 1 450 #createWindow: 50 1 262 #{UI.CreateMixedDpiHost} 498 530 8 #[0 0 0 0 0 0 0 0 117 1 0 0 78 2 0 0] 193 9504 8 '' 9472 3 50 1 9600 610 193 193 nil 27 258 4096 50 2 6496 8 'toolbarsSlidey' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 117 1 0 0 152 2 0 0] 193 6448 8 '' 6416 3 50 2 9472 6496 610 193 193 nil 27 518 #{Core.Fraction} 521 323 2658 18 #{UI.SlideyInneyOuteyThing} 50 23 nil 4336 50 2 8 1140850688 131073 10544 nil nil nil 517 nil nil nil 10544 2754 2786 1 2658 2834 8 'Property Inspector' 1714 0 nil 1746 3 1 4512 8 'doIt' 8 '[Tools.PublishedAspectInspector icon]' 8 #[31 105 45 159 106] 1986 #PublishedAspectInspector #{Tools.PublishedAspectInspector} #{Tools} 1 #icon 10688 7 1 nil 21659 18 #{UI.ContainerView} 50 15 nil 18 #{UI.SlidingCardTray} 50 22 nil 10544 50 2 8 1140850688 131073 10816 nil nil nil 5 nil nil nil 10816 10608 4098 0 nil 18 #{UI.TabViewXP} 50 28 nil 10544 50 2 8 1140916866 1 10896 3186 2786 1 10656 nil 3248 nil nil 1 nil nil nil 10896 nil nil 3280 3312 3344 nil nil nil nil nil #smallIcons nil nil nil nil nil 402 50 3 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 186 0 0 0 152 2 0 0] 193 10928 8 '' 10896 450 #setSingleSelection: 8 #(1) 10896 450 #tcmSetExtendedStyle:dwExStyle: 8 #(-1 0) 10896 3 8 #() 610 193 193 nil 27 nil 10544 610 33 33 3602 10816 nil 1 3634 610 5 3 610 37 35 nil 3698 #togglePin 8 'Pin or Unpin the tray' 1 1 nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[4 0 0 0 4 0 0 0 159 0 0 0 148 2 0 0] 193 10848 8 '' 10816 3 50 1 10784 610 193 193 nil 27 50 2 8 1140850688 131073 10784 nil nil nil 5 nil nil nil 10784 2434 2610 #{Core.Dictionary} 50 3 2658 18 #{UI.TreeView} 50 35 nil 10784 50 2 8 1140918819 1 11584 1094 3 #{UI.TreeModel} nil 3248 774 #{UI.TreeNode} nil nil nil 4098 0 240 nil 29 nil nil nil 11584 nil nil 3280 3312 3344 nil 1714 0 nil 1746 2 1 1712 8 'doIt' 8 '[:x | x printString]' 8 #[30 105 226 0 106] #printString 11728 7 257 nil nil nil nil 2466 0 nil #smallIcons 1 4098 0 1 262 #{UI.TreeViewDynamicUpdateMode} 11584 nil nil nil nil nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 155 0 0 0 189 0 0 0] 193 11616 8 '' 11584 3 8 #() 610 193 193 nil 29 8 0.3 2658 18 #{UI.Splitter} 50 12 nil 10784 50 2 8 1140850688 1 12064 nil nil nil 517 nil nil nil 3142 1 #{UI.DraggableViewInteractor} 12064 nil 1 #left nil nil nil 610 1 1 610 9 9 nil 12160 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 189 0 0 0 155 0 0 0 194 0 0 0] 193 12096 8 '' 12064 3 8 #() 610 193 193 nil 27 1 2658 18 #{UI.ReferenceView} 50 14 nil 10784 50 2 8 1140850688 131073 12368 nil nil nil 5 nil nil nil 12368 370 #{Tools.PropertyInspector} #resource_Default_view nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 194 0 0 0 155 0 0 0 126 2 0 0] 193 12400 8 '' 12368 3 592 610 193 193 nil 27 8 0.7 true 258 4096 50 4 12368 8 'inspector' 11584 8 'viewHierarchy' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 18 0 0 0 155 0 0 0 144 2 0 0] 193 11488 8 '' 10784 3 50 3 11584 12064 12368 610 193 193 nil 27 10784 nil nil nil 4098 0 nil 10896 10816 610 201 201 401 1 524319 nil nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[122 1 0 0 0 0 0 0 52 2 0 0 152 2 0 0] 193 10576 8 '' 10544 3 50 2 10816 10896 610 193 193 nil 27 8 0.8 false 258 4096 50 2 10544 8 'inspectorSlidey' nil 402 50 2 450 #createWindow: 50 1 498 530 8 #[219 1 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 193 4368 8 '' 4336 450 #contextMenu: 50 1 4416 4336 3 50 3 6416 18 #{UI.Splitter} 50 12 nil 4336 50 2 8 1140850688 1 13264 nil nil nil 517 nil nil nil 12130 13264 nil 1 #left nil nil nil 12160 12176 nil 12160 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[117 1 0 0 0 0 0 0 122 1 0 0 152 2 0 0] 193 13296 8 '' 13264 3 8 #() 610 193 193 nil 27 10544 610 193 193 nil 27 8 0.9818181818181817 false 258 4096 50 2 2688 8 'toolsSlidey' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 0 0 0 0 15 4 0 0 152 2 0 0] 193 2560 8 '' 2528 3 50 3 2688 18 #{UI.Splitter} 50 12 nil 2528 50 2 8 1140850688 1 13728 nil nil nil 517 nil nil nil 12130 13728 nil 1 #left nil nil nil 12160 12176 nil 12160 nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[214 1 0 0 0 0 0 0 219 1 0 0 152 2 0 0] 193 13760 8 '' 13728 3 8 #() 610 193 193 nil 27 4336 610 193 193 nil 27 8 'main' nil 402 50 1 450 #createWindow: 50 1 498 530 8 #[0 0 0 0 25 0 0 0 15 4 0 0 177 2 0 0] 193 2400 8 '' 2368 3 50 1 2528 610 193 193 nil 27 258 4096 50 4 1584 8 'statusbar' 160 8 'toolbar' nil 2886 4 #{UI.MenuBar} nil true 50 7 4402 nil true 50 16 4450 1 3698 #newShellView 8 '&New Shell View' 9373 1 4514 nil true 4546 8 'ShellView.ico' 4608 65541 nil nil nil 4450 1 3698 #newDialogView 8 'New &Dialog View' 1 1 4514 nil true 4546 8 'DialogView.ico' 4608 65541 nil nil nil 4930 4097 4450 1 3698 #viewOpen 8 '&Open…' 9375 1 nil nil nil 4450 1 3698 #viewClose 8 '&Close' 1 1 nil nil nil 4450 1 3698 #viewRevert 8 '&Revert' 1 1 2374 2 #{Graphics.TextTileIcon} 8 $🔁 nil nil 226 #commonGreen nil nil 1 nil nil nil nil 4930 4097 4450 1 3698 #viewImport 8 '&Import View…' 1 1 nil nil nil 4450 1 3698 #viewExport 8 '&Export View…' 1 1 nil nil nil 4930 4097 4450 1 3698 #viewSave 8 '&Save' 1 1 4514 nil true 4546 8 'FileSave.ico' 4608 65541 nil nil nil 4450 1 3698 #viewSaveAs 8 'Save &As…' 1 1 nil nil nil 4930 4097 4450 1 3698 #viewTest 8 '&Test' 9385 1 4514 nil true 4546 8 'TestView.ico' 4608 65541 nil nil nil 4930 4097 4450 1 3698 #exit 8 'E&xit' 17639 1 14658 8 $✖ nil nil nil nil nil 1 nil nil nil nil 8 '&File' nil 134217729 nil nil nil nil nil 4402 nil true 50 12 4450 1 3698 #viewUndo 8 '&Undo' 9397 1 4514 nil true 4546 8 'EditUndo.ico' 4608 65541 nil nil nil 4450 1 3698 #viewRedo 8 '&Redo' 9395 1 4514 nil true 4546 8 'EditRedo.ico' 4608 65541 nil nil nil 4930 4097 4450 1 3698 #cutSelection 8 'Cu&t' 9393 1 4514 nil true 4546 8 'EditCut.ico' 4608 65541 nil nil nil 4450 1 3698 #copySelection 8 '&Copy' 9351 1 4514 nil true 4546 8 'EditCopy.ico' 4608 65541 nil nil nil 4450 1 3698 #pasteClipboard 8 '&Paste' 9389 1 4514 nil true 4546 8 'EditPaste.ico' 4608 65541 nil nil nil 4450 1 3698 #clearSelection 8 '&Delete' 1 1 4514 nil true 4546 8 'EditClear.ico' 4608 65541 nil nil nil 4930 4097 4450 1 3698 #widenSelection 8 '&Widen Selection' 9387 1 nil nil nil 4450 1 3698 #selectAll 8 'Select &All' 9347 1 nil nil nil 4930 4097 4450 1 3698 #refreshPublishedAspects 8 'Refresh Inspector' 1257 1 4514 nil true 4546 8 'Refresh.ico' 4608 65541 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 4402 nil true 50 17 4450 1 3698 #editMenuBar 8 '&Menu Bar…' 1 1 nil nil nil 4450 1 3698 #editContextMenu 8 '&Context Menu…' 1 1 nil nil nil 4930 4097 4450 1 3698 #toggleTabStop 8 'Make &Tab Stop' 1 1 nil nil nil 4450 1 3698 #toggleGroupStop 8 'Make &Group Stop' 1 1 nil nil nil 4930 4097 4402 nil true 50 7 4450 1 3698 #alignLefts 8 '&Lefts' 1 1 nil nil nil 4450 1 3698 #alignCenters 8 '&Centres' 1 1 nil nil nil 4450 1 3698 #alignRights 8 '&Rights' 1 1 nil nil nil 4930 4097 4450 1 3698 #alignTops 8 '&Tops' 1 1 nil nil nil 4450 1 3698 #alignMiddles 8 '&Middles' 1 1 nil nil nil 4450 1 3698 #alignBottoms 8 '&Bottoms' 1 1 nil nil nil 8 '&Align' nil 134217729 nil nil nil nil nil 4402 nil true 50 5 4450 1 3698 #matchWidths 8 '&Widths' 1 1 nil nil nil 4450 1 3698 #matchHeights 8 '&Heights' 1 1 nil nil nil 4450 1 3698 #matchFonts 8 '&Fonts' 1 1 nil nil nil 4450 1 3698 #matchForegroundColors 8 'Foreground &Colors' 1 1 nil nil nil 4450 1 3698 #matchBackgroundColors 8 '&Background Colors' 1 1 nil nil nil 8 'Matc&h' nil 134217729 nil nil nil nil nil 4402 nil true 50 4 4450 1 3698 #zFront 8 'Bring to &Front' 9357 1 nil nil nil 4450 1 3698 #zForward 8 'Bring F&orward' 13453 1 nil nil nil 4450 1 3698 #zBackward 8 'Send B&ackward' 13463 1 nil nil nil 4450 1 3698 #zBack 8 'Send to Bac&k' 9367 1 nil nil nil 8 'A&rrange' nil 134217729 nil nil nil nil nil 4402 nil true 50 4 4450 1 3698 #nudgeLeft 8 '&Left' 9803 1 nil nil nil 4450 1 3698 #nudgeRight 8 '&Right' 9807 1 nil nil nil 4450 1 3698 #nudgeUp 8 '&Up' 9805 1 nil nil nil 4450 1 3698 #nudgeDown 8 '&Down' 9809 1 nil nil nil 8 '&Nudge' nil 134217729 nil nil nil nil nil 4402 nil true 50 4 4450 1 3698 #increaseHeight 8 '&Taller' 13905 1 nil nil nil 4450 1 3698 #increaseWidth 8 '&Fatter' 13903 1 nil nil nil 4450 1 3698 #decreateHeight 8 '&Shorter' 13901 1 nil nil nil 4450 1 3698 #decreaseWidth 8 'Th&inner' 13899 1 nil nil nil 8 'Gro&w' nil 134217729 nil nil nil nil nil 4930 4097 4402 nil true 50 3 4450 1 3698 #distributeHorizontally 8 'Distri&bute Evenly' 1 1 nil nil nil 4450 1 3698 #increaseHorizontalGaps 8 '&Increase' 1 1 nil nil nil 4450 1 3698 #decreaseHorizontalGaps 8 '&Decrease' 1 1 nil nil nil 8 'Hori&zontal Spacing' nil 134217729 nil nil nil nil nil 4402 nil true 50 3 4450 1 3698 #distributeVertically 8 'Distri&bute Evenly' 1 1 nil nil nil 4450 1 3698 #increaseVerticalGaps 8 '&Increase' 1 1 nil nil nil 4450 1 3698 #decreaseVerticalGaps 8 '&Decrease' 1 1 nil nil nil 8 '&Vertical Spacing' nil 134217729 nil nil nil nil nil 4930 4097 4450 1 3698 #mutate 8 'M&utate View…' 1 1 nil nil nil 4450 1 3698 #dereference 8 '&Dereference to Copy' 1 1 nil nil nil 8 '&Modify' nil 134217729 nil nil nil nil nil 4402 nil true 50 14 4450 1 3698 #browseIt 8 '&Browse It' 9349 1 4514 nil true 4546 8 'ClassBrowserShell.ico' 4608 65541 nil nil nil 4450 1 3698 #displayIt 8 '&Display It' 9353 1 4514 nil true 4546 8 'DisplayIt.ico' 4608 65541 nil nil nil 4450 1 3698 #printIt 8 '&Print It' 9377 1 4514 nil true 4546 8 'PrintIt.ico' 4608 65541 nil nil nil 4450 1 3698 #evaluateIt 8 '&Evaluate It' 9355 1 4514 nil true 4546 8 'EvaluateIt.ico' 4608 65541 nil nil nil 4450 1 3698 #inspectIt 8 '&Inspect It' 9363 1 4514 nil true 4546 8 'BasicInspector.ico' 4608 65541 nil nil nil 4450 1 3698 #debugIt 8 'Deb&ug It' 1269 1 4514 nil true 4546 8 'Debugger.ico' 4608 65541 nil nil nil 4450 1 3698 #fileItIn 8 '&File it In' 1 1 nil nil nil 4930 4097 4450 1 3698 #browseDefinitions 8 'Defi&nitions…' 1271 1 nil nil nil 4450 1 3698 #browseReferences 8 '&References…' 5367 1 nil nil nil 4930 4097 4450 1 3698 #accept 8 '&Accept' 9383 1 nil nil nil 4930 4097 4402 nil true 50 9 4450 1 3698 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 4450 1 3698 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 4450 1 3698 #toggleLineEndings 8 'Line &Endings' 1 1 14658 $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 4450 1 3698 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 4450 1 3698 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 4450 1 3698 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 4450 1 3698 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 4930 4097 4402 nil true 50 2 4450 1 3698 3266 #language: 8 #(#container) 8 '&Smalltalk' 1 1 nil nil nil 4450 1 3698 3266 #language: 8 #(#xml) 8 '&Xml' 1 1 nil nil nil 8 '&Language' nil 134217729 nil nil nil nil nil 8 '&Options' nil 134217729 4514 nil true 4546 8 'Preferences.ico' 4608 65541 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil 4402 nil true 8 #() 8 '&Tools' #toolsMenu 134217729 nil nil nil nil nil 4402 nil true 8 #() 8 'Wi&ndow' #windowMenu 134217729 nil nil nil nil nil 4402 nil true 50 15 4450 1 3698 #helpContents 8 '&Contents' 1025 1 4514 nil true 4546 8 'Help.ico' 4608 65541 nil nil nil 4450 1 3698 #help 8 'On this &Tool' 1249 1 nil nil nil 4450 1 3698 #helpWhatsThis 8 'What''s This?' 5345 1 nil nil nil 4930 4097 4450 1 3698 #learnSmalltalk 8 'Learn Smalltalk' 1 1 14658 8 $🎓 nil 226 #orchid 226 #white nil nil 1 nil nil nil nil 4930 4097 4450 1 3698 #helpWhatsNew 8 'What''s &New' 1 1 nil nil nil 4450 1 3698 #helpGuidedTour 8 '&Guided Tour' 1 1 nil nil nil 4450 1 3698 #helpTutorials 8 'Tutorials' 1 1 nil nil nil 4930 4097 4450 1 3698 #dolphinHomePage 8 'Dolphin Homepage' 1 1 4514 nil true 4546 8 '!!APPLICATION' 4608 65541 nil nil nil 4450 1 3698 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 nil nil nil 4450 1 3698 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 nil nil nil 4930 4097 4450 1 3698 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 14658 8 $🐬 nil nil 226 #darkSlateBlue nil nil 1 nil nil nil nil 8 '&Help' #help 134217729 nil nil nil nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 nil nil nil nil 1 nil 193 402 50 1 450 #createWindow: 50 1 498 530 8 #[255 14 0 0 10 0 0 0 30 19 0 0 12 3 0 0] 193 80 8 'View Composer' 32 1 50 3 160 2368 1584 610 193 193 nil 27)!

toolsFolderHelpId
	^10593! !

!Tools.ViewComposer class categoriesForMethods!
addToClipboard:!clipboard operations!private! !
appendToClipboard:!clipboard operations!private! !
clearClipboard!clipboard operations!public! !
clipboard!accessing!public! !
clipboard:!accessing!public! !
copyAllToClipboard:!clipboard operations!public! !
defaultDefaultSlideyPinsMap!initializing!private! !
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

