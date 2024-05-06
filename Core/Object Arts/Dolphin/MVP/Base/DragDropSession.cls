"Filed out from Dolphin Smalltalk"!

Object subclass: #DragDropSession
	instanceVariableNames: 'dragSource dragPoint suggestedSource dragObjects defaultOperation dropTarget suggestedTarget operationsSupportedByDropTarget operation inDropTargetScrollZone dragImages scrollProcess'
	classVariableNames: 'Current DefaultImages OperationDescriptions'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!

DragDropSession guid: (GUID fromString: '{87b4c481-026e-11d3-9fd7-00a0cc3e4a32}')!

DragDropSession isAbstract: true!

DragDropSession comment: 'DragDropSessions are used to manage the modal process of dragging and dropping an object or objects from one window to another. 

Instance Variables:
	dragSource			<View> from which objects are being dragged (must be a drag source).
	dragPoint			<Point> identifying last known cursor location during a drag operation
	suggestedSource		<Object> suggested object to be dragged, typically the object under the cursor when the drag started
	dragObjects			<Collection> of <DragDropObject>
	defaultOperation		<Symbol> naming the drop operation to be performed, one of #move, #copy or #link.
	dropTarget			<View> which is the current drop target, or nil if there are no drop targets under the cursor.
	suggestedTarget		<Object> suggested as the target for the drop, typically the object under the cursor in the dropTarget
	operationsSupportedByDropTarget	<Array> of <Symbol>. The drop operations permitted by the current dropTarget
	operation			<Symbol>. The drop operation that would be performed if the drop operation takes place
	inDropTargetScrollZone		<Boolean>. Whether the cursor is over the automatic scroll zone of the dropTarget
	dragImages			<IdentityDictionary> mapping the <Symbol> names of the standard drag images to <Image>s.
	scrollProcess		<Process> that performs the automatic-scolling of the dropTarget when over the drop-target scroll zone.

Class Variables:
	OperationDescriptions	<IdentityDictionary>
	Current					The <DragDropSession> which is currently active, if any.
	DefaultImages			<IdentityDictionary> mapping the <Symbol> names of the standard drag images to default <Image>s.

'!

!DragDropSession categoriesForClass!MVP-DragDrop! !

!DragDropSession methodsFor!

addDragee: anObject
	"Add the <Object> argument to the receiver's collection of objects to be dragged."

	self addDragObject: (self newDragObject: anObject)!

addDragObject: aDragDropObject
	"Add aDragDropObject to the receiver's collection of objects to be dragged.
	This method may be useful for multiple selection situations."

	self dragObjects add: aDragDropObject!

availableFormats
	"Answer a <Set> of the <Symbol>s containing the names of all available formats."

	| answer |
	answer := IdentitySet new.
	self dragObjects do: [:o | answer addAll: o availableFormats].
	^answer!

defaultOperation
	"Answer the receiver's defaultOperation. This Symbol identifies the operation
	to be performed unless overridden with the keyboard during the drag."

	^defaultOperation
!

defaultOperation: aSymbol
	"Set the receiver's defaultOperation inst var to aSymbol. This identifies the operation
	to be performed unless overridden with the keyboard during the drag."

	defaultOperation := aSymbol
!

defaultScrollDelay
	"Answers the <Duration> of the delay between the drop pointer entering the scroll zone and a scroll operation starting"

	^1 seconds!

defaultScrollInset
	"Answers the size (in pixels) of the scroll border at the edge 
	of a potential drop target"

	^15!

defaultScrollInterval
	"Answers the <Duration> to wait between the scroll operations while the drop pointer is in the scroll zone"

	^100 milliseconds!

dragObjectClass
	^self subclassResponsibility!

dragObjects
	"Answer the receiver's dragObjects inst var - a Collection of the objects being dragged."

	dragObjects isNil ifTrue: [dragObjects := OrderedCollection new].
	^dragObjects!

dragObjects: anOrderedCollection
	"Set the receiver's dragObjects inst var to anOrderedCollection of the objects to be dragged."

	dragObjects := anOrderedCollection isNil ifFalse: [anOrderedCollection asOrderedCollection]!

dragPoint
	"Answer the receiver's dragPoint inst var. This contains the last known screen coordinates of the
	drag operation."

	^dragPoint!

dragPoint: anObject
	dragPoint := anObject!

dragPointInView: aView
	"Answer the receiver's dragPoint converted to the coordinate system of
	aView. This contains the last known coordinates of the drag operation."

	^View desktop mapPoint: self dragPoint to: aView
!

dragSource
	"Answer the drag source View."

	^dragSource!

dragSource: aView
	"Set the receiver's dragSource inst var to aView."

	dragSource := aView!

dragSourceCut
	"Private - We have completed a successful move operation - cut the dragObjects from the drag source."

	dragSource isDragSource
		ifTrue: [dragSource ddCut: self]!

dropTarget
	"Answer the current drop target."

	^dropTarget!

dropTarget: anObject
	dropTarget := anObject!

dropTargetDrop
	"Private - Instruct the current drop target to perform a drop."

	dropTarget isDropTarget ifTrue: [
		self isInDropTargetScrollZone: false.
		self solidifyOperation.
		operation notNil
			ifTrue: [^dropTarget ddDrop: self]
			ifFalse: [
				"Drag was cancelled (operation is nil)"
				dropTarget ddLeave: self]].
	^false!

dropTargetEnter
	"Private - Inform the drop target that the receiver has has entered its air space."

	operation := nil.
	suggestedTarget := nil.
	self isInDropTargetScrollZone: false.
	dropTarget notNil ifTrue: [dropTarget ddEnter: self]!

dropTargetLeave
	"Private - Inform the drop target that the receiver has left its air space."

	dropTarget notNil ifTrue: [dropTarget ddLeave: self].
	self showDragImage.
	self isInDropTargetScrollZone: false.
	operation := nil.
	suggestedTarget := nil!

dropTargetOver
	"Private - Inform the drop target that the receiver is still flying overhead."

	operation := nil.
	dropTarget notNil ifTrue: [dropTarget ddOver: self]!

forcedOperation
	"If the user is currently holding down one of the drag and drop modifier keys
	answer the operation intended. If no such keys are held down then answer nil."

	Keyboard default isCtrlDown ifTrue: [^#copy].
	Keyboard default isShiftDown ifTrue: [^#move].
	Keyboard default isAltDown ifTrue: [^#link].
	^nil!

getCustomDragImages
	"Private - Determine any drag images which are to differ from the default.
	Usually this is only the underlying object icon, but we also invite the 
	drag source to set custom images for the various drop effects. 
	This is optional and if none are provided then default images will be used."

	"Make sure the required #Object image is available"

	dragImages at: #Object
		ifAbsentPut: 
			[| dragged |
			dragged := self dragObjects first.
			dragged isObjectAvailable 
				ifTrue: [dragged object icon]
				ifFalse: [Icon question]].
	dragSource isDragSource ifTrue: [dragSource ddGetImages: self]!

hideCursorWhile: aBlock 
	"Evaluate the <monadicBlock> argument with the drag image hidden."

	self hideDragImage.
	aBlock ensure: [self showDragImage]!

hideDragImage
	"Hide the current drag image. This may be useful to targets wishing to draw some sort of
	emphasis, e.g. a focus box, as it is necessary to turn off the cursor before drawing to
	avoid making a mess. Normally you should use #hideCursorWhile: to hide and subsequently
	reshow the drag cursor in a simple and reliable way."

	^self subclassResponsibility!

imageAt: aSymbol put: anImage
	"Set an image in the receiver's image dictionary. This is an IdentityDictionary mapping a drop operation to
	a drag image. The standard operation image keys are #none, #move, #moveScroll, #copy, #copyScroll, #link
	and #linkScroll. You may provide a drag image for a user-defined drop operation by adding it with the
	operation key symbol."

	dragImages at: aSymbol put: anImage!

imageKey
	"Private - Answer the key symbol to select the appropriate drag image.
	This will be one of the standard image keys #none, #move, #copy, #link,
	#moveScroll, #copyScroll, #linkScroll or else a symbol matching some
	user defined operation."

	operation isNil ifTrue: [^#none].
	inDropTargetScrollZone 
		ifTrue: 
			[operation == #move ifTrue: [^#moveScroll].
			operation == #copy ifTrue: [^#copyScroll].
			operation == #link ifTrue: [^#linkScroll]].
	^operation!

initialize
	"Private - Initialize the receiver."

	defaultOperation := #move.
	operationsSupportedByDropTarget := #(#move #copy).
	inDropTargetScrollZone := false.
	dragImages := self class defaultDragImages copy.
	^self!

intendedOperation
	"Answer the receiver's defaultOperation unless the user is forcing a different operation
	using the keyboard."

	| intendedOperation |
	(intendedOperation := self forcedOperation) isNil
		ifTrue: [intendedOperation := self defaultOperation].
	^intendedOperation!

isCopy
	^self operation == #copy!

isFormatAvailable: aSymbol 
	"Answer whether andy of the dragged objects can render themselves in the specified format."

	^self dragObjects anySatisfy: [:each | each isFormatAvailable: aSymbol]!

isInDropTargetScrollZone
	"Private - Answer whether the cursor is currently over a 'drag and drop scroll zone' in the drop target."

	^inDropTargetScrollZone!

isInDropTargetScrollZone: aBoolean 
	"Private - Set the receiver's inDropTargetScrollZone inst var to aBoolean to indicate whether the cursor
	is currently over a 'drag and drop scroll zone' in the drop target."

	(aBoolean eqv: inDropTargetScrollZone) ifTrue: [^self].
	aBoolean ifTrue: [self startScrollProcess] ifFalse: [self stopScrollProcess].
	inDropTargetScrollZone := aBoolean!

isLink
	^self operation == #link!

isMove
	^self operation == #move!

isObjectKindAvailable: aClass
	"Answer whether the receiver can render itself as an Object which 
	is a kind of aClass"

	^self dragObjects allSatisfy: [:each | each isObjectKindAvailable: aClass ]!

isTargetSameAsSource
	"Answer true if the source and target locations are the same"

	^(self dragSource==self dropTarget and: [
		(self suggestedSource==self suggestedTarget) and: [
	self suggestedSource notNil]])
!

newDragObject: anObject 
	"Answer a new <DragDropObject> on the <Object> argument."

	^self dragObjectClass object: anObject!

operation
	"Answer the receiver's operation inst var. This is a symbol identifying the operaion a drop would currently have
	on the drop target. This can be nil to indicate that there would be no effect, one of the standard drag and drop
	operations #move, #copy, #link, or some other symbol defined by the target."

	^operation!

operation: aSymbol
	"Set the receiver's operation inst var to aSymbol - this identifies the operation a drop would currently
	have on the drop target. This can be nil to indicate that there would be no effect, one of the standard
	drag and drop operations #move, #copy or #link, or some other Symbol defined by the target."

	operation := aSymbol!

operationDescriptions
	"Answer an <abstractDictionary> that maps the standard drag and drop operations symbols
	to menu item names for the purposes of an extended drag and drop (i.e. these are used as the
	descriptions on the right drag popup menu)."

	^OperationDescriptions!

resetOperation
	operation := nil!

scrollDelay
	"Answers the <Duration> of the delay between the drop pointer entering the scroll zone and a scroll operation starting"

	^self defaultScrollDelay!

scrollInterval
	"Answers the <Duration> to wait between the scroll operations while the drop pointer is in the scroll zone"

	^self defaultScrollInterval!

showDragImage
	"Show the current drag image. This may be useful to targets wishing to draw some sort of
	emphasis."

	^self subclassResponsibility!

solidifyOperation
	"Private - Time to make up our minds on the actual drag operation to be performed.
	By default we assume it has already solidified."

!

startScrollProcess
	"Private - Start a process for scrolling the drop target"				

	self stopScrollProcess.
	scrollProcess := 
			[self scrollDelay wait.
			
			[dropTarget ddScroll: self.
			self scrollInterval wait] repeat]
					forkAt: Processor userBackgroundPriority!

stopScrollProcess
	"Private - Stops the process for scrolling the drop target"

	scrollProcess isNil ifTrue: [^self].
	scrollProcess terminate.
	scrollProcess := nil!

suggestedSource
	"Answer the receiver's suggestedSource inst var. This is NOT the drag object but the object that
	was under the mouse at the point the drag commenced and may be nil. This can be used by the
	dragSource's #requestDragObjects to help identify which object(s) within the dragSource is to be
	the actual drag object(s)."

	^suggestedSource!

suggestedSource: anObject
	"Set the receiver's suggestedSource inst var to anObject. This is NOT the drag object but the
	object that was under the mouse at the point the drag commenced and may be nil. This can be
	used by the dragSource's #requestDragObjects to help identify which object(s) within the
	dragSource is to be the actual drag object(s)."

	suggestedSource := anObject!

suggestedTarget
	"Answer the receiver's suggestedTarget inst var. This is NOT the dropTarget object but an object
	specified by a dropTarget on a previous call of #onDragEnter, #onDragOver or #onDrop and may
	therefore be nil. This can be used by the dropTarget to help with both drawing of drop emphasis
	and with the identification of drop participants in any eventual #onDrop."

	^suggestedTarget!

suggestedTarget: anObject
	"Set the receiver's suggestedTarget inst var. This is NOT the dropTarget object but an object
	specified by a dropTarget to help with both drawing of drop emphasis and with the identification
	of drop participants in any eventual #onDrop."

	suggestedTarget := anObject!

supportedOperations
	"Answer a <Collection> of <Symbol>, that specifies the drop operations 
	supported by the current drop target."

	^operationsSupportedByDropTarget!

supportedOperations: ops
	"Set the receiver's operationsSupportedByDropTarget inst var to the <Collection>
	of <Symbol>, ops. This specifies the drop operations supported by the current
	drop target."

	operationsSupportedByDropTarget := ops! !

!DragDropSession categoriesForMethods!
addDragee:!adding!public! !
addDragObject:!adding!public! !
availableFormats!accessing!public! !
defaultOperation!accessing!public! !
defaultOperation:!accessing!public! !
defaultScrollDelay!constants!public! !
defaultScrollInset!constants!public! !
defaultScrollInterval!constants!public! !
dragObjectClass!constants!public! !
dragObjects!accessing!public! !
dragObjects:!accessing!public! !
dragPoint!accessing!public! !
dragPoint:!accessing!private! !
dragPointInView:!accessing!public! !
dragSource!accessing!public! !
dragSource:!accessing!public! !
dragSourceCut!drag & drop-source!private! !
dropTarget!accessing!public! !
dropTarget:!accessing!private! !
dropTargetDrop!drag & drop-drop target protocol!drag & drop-target!private! !
dropTargetEnter!drag & drop-target!private! !
dropTargetLeave!drag & drop-target!private! !
dropTargetOver!drag & drop-target!private! !
forcedOperation!keyboard input!public! !
getCustomDragImages!drag & drop-source!private! !
hideCursorWhile:!operations!public! !
hideDragImage!operations!public! !
imageAt:put:!accessing!public! !
imageKey!accessing!private! !
initialize!initializing!private! !
intendedOperation!keyboard input!public! !
isCopy!public!testing! !
isFormatAvailable:!public!testing! !
isInDropTargetScrollZone!accessing!private! !
isInDropTargetScrollZone:!accessing!private! !
isLink!public!testing! !
isMove!public!testing! !
isObjectKindAvailable:!public!testing! !
isTargetSameAsSource!public!testing! !
newDragObject:!adding!public! !
operation!accessing!public! !
operation:!accessing!public! !
operationDescriptions!accessing!public! !
resetOperation!accessing!public! !
scrollDelay!accessing!public! !
scrollInterval!accessing!public! !
showDragImage!operations!public! !
solidifyOperation!operations!private! !
startScrollProcess!operations!private! !
stopScrollProcess!operations!private! !
suggestedSource!accessing!public! !
suggestedSource:!accessing!public! !
suggestedTarget!accessing!public! !
suggestedTarget:!accessing!public! !
supportedOperations!accessing!public! !
supportedOperations:!accessing!public! !
!

!DragDropSession class methodsFor!

current
	"Answer the current (singleton) instance of the receiver or nil if there is none."

	^Current!

defaultDragImages
	DefaultImages isNil 
		ifTrue: 
			[DefaultImages := IdentityDictionary new.
			DefaultImages
				at: #none put: Cursor ddNone;
				at: #move put: Cursor ddMove;
				at: #copy put: Cursor ddCopy;
				at: #link put: Cursor ddLink;
				at: #moveScroll put: Cursor ddMoveScroll;
				at: #copyScroll put: Cursor ddCopy;
				at: #linkScroll put: Cursor ddLink].
	^DefaultImages!

dragButton
	"Private - Answer the symbol that represents which mouse button starts a normal drag operation."

	^#left!

dragSource: aView
	"Answer a new instance of the receiver with aView as the drag source."

	^self dragSource: aView item: nil!

dragSource: aView item: anObject
	"Answer a new instance of the receiver with the argument, aView, as the dragSource and
	the argument, anObject, as suggestedSource."

	^(self new)
		dragSource: aView;
		suggestedSource: anObject;
		yourself!

extendedDragButton
	"Private - Answer the symbol that represents which mouse button starts an extended drag operation."

	^#right!

initialize
	"Private - Initialize the reciever."

	(OperationDescriptions := IdentityDictionary new)
		at: #move put: 'Move here';
		at: #copy put: 'Copy here';
		at: #link put: 'Link'!

isADragButton: aSymbol
	"Answer whether the mouse button identified by aSymbol is recognized as a drag initiator button."

	^aSymbol == self dragButton or: [aSymbol == self extendedDragButton]!

new
	^super new initialize!

onPreStripImage
	"Private - The image is about to be stripped. Nil any lazily initialized class variables."

	self uninitialize
!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	Current := nil.
	DefaultImages := nil! !

!DragDropSession class categoriesForMethods!
current!accessing!public! !
defaultDragImages!accessing!public! !
dragButton!constants!private! !
dragSource:!instance creation!public! !
dragSource:item:!instance creation!public! !
extendedDragButton!constants!private! !
initialize!development!initializing!private! !
isADragButton:!public!testing! !
new!instance creation!public! !
onPreStripImage!class hierarchy-removing!private! !
uninitialize!class hierarchy-removing!private! !
!

