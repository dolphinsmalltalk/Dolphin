"Filed out from Dolphin Smalltalk 7"!

UI.DragDropSession subclass: #'UI.InternalDragDropSession'
	instanceVariableNames: 'lastImageKey imageList oldCursor dragButton operationDescriptions'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.InternalDragDropSession guid: (Core.GUID fromString: '{87b4c54b-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.InternalDragDropSession comment: '
Instance Variables:
	lastImageKey			<Symbol> name of the last displayed drag cursor image (e.g. #move or #copyScroll)
	imageList				<WinImageList> holding the drag cursor images.
	oldCursor				<Cursor> that was active before the drag started.
	dragButton				The <Symbol> name of the mouse button down when the drag started (one of #left, #middle or #right).
	operationDescriptions	<abstractDictionary> mapping d&d symbols to the descriptions to be used on the right drag popup menu

'!
!UI.InternalDragDropSession categoriesForClass!MVP-DragDrop! !
!UI.InternalDragDropSession methodsFor!

beginDragImage
	| dragIm |
	dragIm := dragImages at: #Object.
	imageList
		beginDragImage: dragIm key
			hotSpotX: 0
			hotSpotY: 0;
		dragEnter: nil at: self dragPoint!

buildDragImageList
	| i maxImageExtent |
	self getCustomDragImages.	"Put all of the images into an ImageList and convert the drag images into imageList indices."
	maxImageExtent := dragImages inject: Point.Zero into: [:max :image | max max: image extent].
	imageList := ImageList
				newExtent: (maxImageExtent min: SystemMetrics current largeIconExtent)
				depth: self defaultDragColorDepth
				initialSize: dragImages size
				growBy: 1
				masked: true.
	i := 0.
	dragImages := dragImages collect: 
					[:image |
					imageList addImage: image.
					i := i + 1.
					i - 1 -> image hotspot]!

cancelTrackingAt: anObject
	"The drag & drop operation has been cancelled."

	dropTarget isNil ifFalse: [self dropTargetLeave].
	imageList notNil 
		ifTrue: 
			[imageList
				dragLeave: nil;
				endDrag.
			Cursor current: oldCursor].
	Current := nil!

continueTrackingAt: aPoint from: lastPoint 
	"Move the representation of the DragDropObject from lastPoint to aPoint."

	| newDropTarget |
	self dragPoint: aPoint.
	(newDropTarget := self dropTargetUnder: aPoint) = dropTarget 
		ifTrue: [self dropTargetOver]
		ifFalse: 
			[self dropTargetLeave.
			dropTarget := newDropTarget.
			self dropTargetEnter].
	self giveFeedback.
	^self dragPoint!

defaultDragColorDepth
	"Private - Answer the color depth to use for drag icon images. Only XP can handle >24 bit depths"

	| metrics |
	metrics := SystemMetrics current.
	^metrics defaultColorDepth min: metrics dragImageColorDepth!

doDragDropAt: aPoint button: buttonSymbol
	"Initiate a drag and drop operation at the screen coordinates, aPoint, active while the mouse button
	identified by buttonSymbol remains pressed. The buttonSymbol indicates which button up event will be used to
	terminate the drag and whether it is a simple drag operation or an extended drag operation. Answer whether a
	drag and drop operation completed successfully. Note that a drag may never actually start unless the user moves 
	the mouse cursor outside the hysteresis rectangle around aPoint."

	(self class isADragButton: buttonSymbol) ifFalse: [^false].
	dragButton := buttonSymbol.
	self dragPoint: aPoint.
	(MouseTracker forPresenter: self dragSource presenter startingAt: aPoint)
		dragButton: buttonSymbol;
		origin: aPoint;
		startTracking: self.
	^true!

dragObjectClass
	^InternalDragDropObject!

dropTargetUnder: aPoint
	"Private - Look for the nearest drop target in the parent chain, starting with the view
	under the specified <Point>."

	| target |
	target := View fromPoint: aPoint.
	[target isNil or: [target isDropTarget]] whileFalse: [target := target parentView].
	^target!

endTrackingAt: aPoint 
	"Attempt a drop of the dragObject on the drapTarget at aPoint."

	self dragPoint: aPoint.
	self continueTrackingAt: aPoint from: aPoint.
	imageList
		dragLeave: nil;
		endDrag.
	Cursor current: oldCursor.
	operation isNil 
		ifTrue: [self dropTargetLeave]
		ifFalse: [(self dropTargetDrop and: [operation == #move]) ifTrue: [self dragSourceCut]].
	Current := nil!

getExtendedOperation
	"Private - An extended drop has occurred - query the drop target for a list of supported operations
	so that we may present these as a context menu to allow the user to choose the operation."

	self dropTarget notNil ifTrue: [dropTarget ddOperations: self].
	self supportedOperations isEmpty 
		ifTrue: [self operation: nil]
		ifFalse: 
			["Allow the command selected from the menu to be dispatched before returning"
			self promptForDropOperation].
	^operation!

giveCursorFeedback
	| cursorSelector |
	cursorSelector := ##(IdentityDictionary new
				at: #none put: #ddNone;
				at: #move put: #ddMove;
				at: #copy put: #ddCopy;
				at: #copyScroll put: #ddCopyScroll;
				at: #moveScroll put: #ddMoveScroll;
				at: #linkScroll put: #ddLinkScroll;
				yourself) at: self imageKey.
	(Cursor perform: cursorSelector) makeCurrent!

giveFeedback
	"Private - Set the drag cursor to indicate the effect of a drop on the current target."

	| imageKey |
	(imageKey := self imageKey) ~~ lastImageKey
		ifTrue: 
			[| dragIm |
			SystemMetrics current hasImageListDragCursors
				ifFalse: 
					["Fall back to using the old (non-specific) drag and drop
					 cursors"
					self giveCursorFeedback]
				ifTrue: 
					[dragIm := dragImages at: imageKey.
					imageList
						setDragCursorImage: dragIm key
						hotSpotX: dragIm value x
						hotSpotY: dragIm value y].
			lastImageKey := imageKey].
	imageList dragMoveTo: self dragPoint!

hideDragImage
	"Hide the current drag image. This may be useful to targets wishing to draw some sort of
	emphasis, e.g. a focus box, as it is necessary to turn off the cursor before drawing to
	avoid making a mess."

	imageList dragShow: false!

isExtendedDrag
	"Answer whether this drag was initiated with the 'right' mouse button."

	^dragButton == self class extendedDragButton!

operationDescriptions
	"Answer an <abstractDictionary> that maps the standard drag and drop operations symbols
	to menu item names for the purposes of an extended drag and drop (i.e. these are used as the
	descriptions on the right drag popup menu)."

	operationDescriptions isNil ifTrue: [operationDescriptions := super operationDescriptions].
	^operationDescriptions!

operationDescriptions: aLookupTable
	"Set the <abstractDictionary> that maps the standard drag and drop operations symbols
	to menu item names for the purposes of an extended drag and drop to the argument."

	operationDescriptions := aLookupTable!

promptForDropOperation
	| default opNames i defaultOp popup |
	defaultOp := self operation.
	popup := Menu new.
	i := 1.
	default := 0.
	opNames := self operationDescriptions.
	self supportedOperations do: 
			[:opSymbol |
			opSymbol == defaultOp ifTrue: [default := i].
			popup addCommand: (MessageSend
						receiver: self
						selector: #operation:
						argument: opSymbol)
				description: (opNames at: opSymbol).
			i := i + 1].
	popup
		addSeparator;
		addCommand: (MessageSend
					receiver: self
					selector: #operation:
					argument: nil)
			description: 'Cancel'.
	popup setDefault: default.
	self resetOperation.
	popup showIn: self dropTarget position: Cursor position.
	"Allow the command selected from the menu to be dispatched before returning"
	SessionManager inputState pumpMessages!

showDragImage
	"Show the current drag image. This may be useful to targets wishing to draw some sort of emphasis."

	imageList dragShow: true!

solidifyOperation
	"Private - Time to make up our minds on the actual drag operation to be performed.
	By default we assume it has already solidified."

	self isExtendedDrag ifTrue: [
		self getExtendedOperation]!

startTrackingAt: aPoint 
	"Start position tracking at aPoint. This is part of the 
	<MouseTracker> target protocol. Answers the actual position achieved,
	or nil if no drag objects were forthcoming (we lazily request the drag
	objects only when a drag is actually initiated)"

	self dragPoint: aPoint.
	self dragSource isDragSource ifTrue: [self dragSource ddGetObjects: self].
	(dragObjects isNil or: [dragObjects isEmpty]) 
		ifTrue: 
			["Cancel the drag&drop operation"
			^nil].
	self buildDragImageList.
	"Note that dragging is a modal operation - only one drag may be active at any one time"
	Current := self.
	"Initially we must be over the drag source"
	dropTarget := self dropTargetUnder: aPoint.
	self dropTargetEnter.
	oldCursor := Cursor reset.
	self beginDragImage.
	self giveFeedback.
	^self dragPoint! !
!UI.InternalDragDropSession categoriesFor: #beginDragImage!public!tracking! !
!UI.InternalDragDropSession categoriesFor: #buildDragImageList!private!tracking! !
!UI.InternalDragDropSession categoriesFor: #cancelTrackingAt:!public!tracking! !
!UI.InternalDragDropSession categoriesFor: #continueTrackingAt:from:!public!tracking! !
!UI.InternalDragDropSession categoriesFor: #defaultDragColorDepth!accessing!private! !
!UI.InternalDragDropSession categoriesFor: #doDragDropAt:button:!operations!public! !
!UI.InternalDragDropSession categoriesFor: #dragObjectClass!constants!public! !
!UI.InternalDragDropSession categoriesFor: #dropTargetUnder:!helpers!private!tracking! !
!UI.InternalDragDropSession categoriesFor: #endTrackingAt:!public!tracking! !
!UI.InternalDragDropSession categoriesFor: #getExtendedOperation!operations!private! !
!UI.InternalDragDropSession categoriesFor: #giveCursorFeedback!operations!private!wine fix! !
!UI.InternalDragDropSession categoriesFor: #giveFeedback!operations!private!wine fix! !
!UI.InternalDragDropSession categoriesFor: #hideDragImage!operations!public! !
!UI.InternalDragDropSession categoriesFor: #isExtendedDrag!public!testing! !
!UI.InternalDragDropSession categoriesFor: #operationDescriptions!accessing!public! !
!UI.InternalDragDropSession categoriesFor: #operationDescriptions:!accessing!public! !
!UI.InternalDragDropSession categoriesFor: #promptForDropOperation!operations!private! !
!UI.InternalDragDropSession categoriesFor: #showDragImage!operations!public! !
!UI.InternalDragDropSession categoriesFor: #solidifyOperation!operations!private! !
!UI.InternalDragDropSession categoriesFor: #startTrackingAt:!public!tracking! !

UI.InternalDragDropSession methodProtocol: #mouseTrackerTarget attributes: #(#readOnly) selectors: #(#cancelTrackingAt: #continueTrackingAt:from: #endTrackingAt: #startTrackingAt:)!

