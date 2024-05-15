"Filed out from Dolphin Smalltalk"!

ListControlView subclass: #BasicListAbstract
	instanceVariableNames: 'lastSelIndices'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

BasicListAbstract guid: (GUID fromString: '{87b4c725-026e-11d3-9fd7-00a0cc3e4a32}')!

BasicListAbstract isAbstract: true!

BasicListAbstract comment: 'BasicListAbstract is an abstract class conforming to the <listView> protocol. Its concrete subclasses are implementations of the original Windows list boxes and combination boxes. All <listView>s are intended to be used in conjunction with a <listModel> holding the list items.

Instance Variables:

	getTextBlock	<monadicValuable> for mapping a list item to its display text.
	lastSel		<integer> or <Array> indicating the index(es) of the last single or multiple selection.

'!

!BasicListAbstract categoriesForClass!MVP-Views! !

!BasicListAbstract methodsFor!

basicAdd: anObject 
	"Private - Adds a string for the <Object> argument to the listbox control at the end of the
	list. Answers the argument."

	^self subclassResponsibility!

basicRefreshContents
	self noRedrawDo: 
			[self basicClear.
			self withOldWndProc: [self model do: [:each | self basicAdd: each]]].
	self invalidate!

basicResetSelection
	"Private - Set the receiver to have no selection."

	self setSingleSelection: self noSelection!

canHScroll
	"Answer whether the receiver is in horizontal scrolling mode."

	^self subclassResponsibility!

canHScroll: aBoolean 
	"Sets the receiver into horizontal scrolling mode if aBoolean is true."

	^self subclassResponsibility!

defaultExtent
	"Private - Answer the default size of the receiver in device-independent pixels (96-dpi DIPs). This is used only to determine the size of a view when it is created (although after scaling DIPs to the monitor DPI). Thereafter #preferredExtent is used when the desired size of a view is requested."

	^##(125 @ 175)!

defaultWindowExStyle
	"Private - Answer the default extended window creation style.
	Use the client edge style for the standard Win95 look."

	^super defaultWindowExStyle bitOr: WS_EX_CLIENTEDGE!

defaultWindowStyle
	"Private - Answer the default basic window creation style for list view"

	^super defaultWindowStyle bitOr: ##(WS_VSCROLL | WS_HSCROLL)!

displayStringFor: anObject 
	^(getTextBlock value: anObject) displayString!

ensureSelectionVisible
	"Ensure the selected item is visible, scrolling it into view if necessary."

	self setSingleSelection: self selectionByIndex!

initialize
	super initialize.
	lastSelIndices := #()!

lastSelIndices
	^lastSelIndices!

onItem: anObject addedAtIndex: anInteger 
	"Event received when an <Object> has been added to the receiver's
	model at the specified <integer> index. Insert the object into the list control."

	self basicAdd: anObject atIndex: anInteger.
	self updateSelectionCache!

onItem: anObject removedAtIndex: anInteger 
	"Event received when the <Object>, anObject, has been removed from the receiver's model at
	the <integer> index, anInteger. Remove the appropriate object from the listbox. We must also
	account for the fact that a selected item may have been removed."

	#todo.	"Determine if we need different order for single vs multi-select."
	self isMultiSelect 
		ifTrue: 
			[self basicRemoveAtIndex: anInteger.
			(lastSelIndices includes: anInteger) ifTrue: [self onSelChanged]]
		ifFalse: 
			[(lastSelIndices includes: anInteger) ifTrue: [self resetSelection].
			self basicRemoveAtIndex: anInteger].
	self updateSelectionCache!

onKeyTyped: aKeyEvent
	"Default handler for the receiver's view receiving a key entry."

	| answer |
	answer := super onKeyTyped: aKeyEvent.
	aKeyEvent code==VK_RETURN ifTrue: [
		self presenter performAction ].
	^answer!

onLeftButtonDoubleClicked: aMouseEvent
	"Default handler for a mouse left button double-click event."

	| answer |
	answer := super onLeftButtonDoubleClicked: aMouseEvent.
	self presenter performAction.
	^answer!

onSelChanged: anArray 
	lastSelIndices := anArray.
	super onSelChanged: anArray!

onSelChanging
	"Private - Handle a (pseudo) selection changing event. Answer whether the selection change was
	permitted (and indeed has already occurred).
	Implementation Note: The underlying control does not actually implement this functionality, so we have
	to simulate it by restoring the previous selection if the presenter requests that the proposed selection
	change be denied."

	| curSel |
	(curSel := self getSelectionsByIndex) = lastSelIndices 
		ifFalse: 
			[(self onSelChanging: curSel cause: #unknown) 
				ifFalse: 
					["Attempt to revert to previous selection"

					self basicSelectionsByIndex: lastSelIndices.
					(curSel := self getSelectionsByIndex) = lastSelIndices 
						ifTrue: 
							["Successfully prevented selection change"

							^false]].

			"Selection either could not be maintained or change permitted, so record and notify a selection change"
			self onSelChanged: curSel].
	^true!

onSelChanging: anArray cause: aSymbol
	"Private - Selection is changing in the receiver to the item in the receiver's model at the 
	specified <integer> index as a direct result of user input.
	A #selectionChanging: event is triggered to enquire as to whether the selection change 
	is permissible. If it is not then any observer that wishes to veto the change must set the
	the value of the <SelectionChangingEvent> to false. Note that selection notifications 
	are not propagated during state restoral."

	^self isStateRestoring or: 
			[| event |
			event := SelectionChangingEvent forSource: self.
			event
				newSelections: (anArray collect: [:each | self objectFromHandle: each]);
				oldSelections: (lastSelIndices collect: [:each | self objectFromHandle: each]);
				cause: aSymbol.
			self presenter onSelectionChanging: event.
			event value]!

onViewCreated
	"The receiver window has been created. Copy the info held in instance variables across to it"

	super onViewCreated.
	self basicRefreshContents.
	self basicSelectionsByIndex: lastSelIndices!

refreshContents
	"Refresh the receiver's contents to match the contents collection"

	self isOpen ifFalse: [^self].
	self basicRefreshContents.
	self onSelChanged!

selectionByIndex
	"Answer the 1-based <integer> index of the selected item in the view, or zero if there is not exactly one selection."

	^lastSelIndices size == 1 ifTrue: [lastSelIndices at: 1] ifFalse: [0]!

selections: aCollection ifAbsent: aNiladicOrMonadicValuable
	"Select the first occurrences of the specified collection of <Object>s in the receiver and
	answer the new selection. If any of the elements of the collection are not present in the
	receiver's list, then answer the result of evaluating the <monadicValuable>,
	exceptionHandler. If the exception handler expects a single argument it is passed a
	<collection> of the missing items."

	| missing indices |
	missing := OrderedCollection new.
	indices := self handlesFromObjects: aCollection whenAbsent: [:e | missing addLast: e].
	self setSelectionsByIndex: indices.
	^missing isEmpty ifTrue: [aCollection] ifFalse: [aNiladicOrMonadicValuable cull: missing]!

selectionsByIndex
	"Answer an <Array> of the <integer> the indices of the selected items 
	in the receiver in ascending order. The array will be empty if there is
	no selection."

	^lastSelIndices!

selectionsByIndex: aCollection ifAbsent: exceptionHandler
	"Select the objects identified by the <collection> of <integer> indices, indices, in the
	receiver. If any of the indices are out of bounds, then evaluate the <monadicValuable>,
	exceptionHandler, passing it a <collection> of the offending indices. For backwards
	compatibility with the superclass implementation, exceptionHandler can also be a
	<niladicValuable>, but in that the exception handler must work out for itself which indices
	were missing."

	| inRange size |
	size := self size.
	inRange := aCollection select: [:i | i between: 1 and: size].
	self setSelectionsByIndex: inRange.
	^aCollection size ~= inRange size
		ifTrue: [exceptionHandler cull: (aCollection difference: inRange)]
		ifFalse: [inRange]!

setSelectionsByIndex: indices 
	(indices noDifference: lastSelIndices) ifTrue: [^self].
	self basicSelectionsByIndex: indices.
	"Note: We have to check again whether the selection has changed because of the single-select case"
	self onSelChanged!

updateItem: anObject atIndex: anInteger 
	"Re-render the specified item, which is at the specified <integer> index in the list."

	"Implementation Note: The simple ListBox control has no way to do this directly, so we must
	add a new item and remove the old one, maintaining the selection as we do so."

	self basicAdd: anObject atIndex: anInteger.
	(lastSelIndices includes: anInteger) 
		ifTrue: 
			[self isMultiSelect 
				ifTrue: [self selectIndex: anInteger set: true]
				ifFalse: [self setSingleSelection: anInteger]].
	self basicRemoveAtIndex: anInteger + 1!

updateSelectionCache
	"Private - If there is a cached selection, update it."

	lastSelIndices notEmpty ifTrue: [lastSelIndices := self getSelectionsByIndex]! !

!BasicListAbstract categoriesForMethods!
basicAdd:!adding!private! !
basicRefreshContents!private!updating! !
basicResetSelection!private!selection! !
canHScroll!public! !
canHScroll:!public! !
defaultExtent!constants!private! !
defaultWindowExStyle!constants!private! !
defaultWindowStyle!constants!private! !
displayStringFor:!adding!private! !
ensureSelectionVisible!public!selection! !
initialize!initializing!public! !
lastSelIndices!private! !
onItem:addedAtIndex:!event handling!public! !
onItem:removedAtIndex:!event handling!public! !
onKeyTyped:!event handling!public! !
onLeftButtonDoubleClicked:!event handling!public! !
onSelChanged:!event handling!private! !
onSelChanging!event handling!private! !
onSelChanging:cause:!event handling!private! !
onViewCreated!event handling!public! !
refreshContents!public!updating! !
selectionByIndex!public!selection! !
selections:ifAbsent:!public!selection! !
selectionsByIndex!public!selection! !
selectionsByIndex:ifAbsent:!public!selection! !
setSelectionsByIndex:!private!selection! !
updateItem:atIndex:!event handling!public! !
updateSelectionCache!helpers!private!selection! !
!

!BasicListAbstract class methodsFor!

initialize
	View registerMessageMappings: {WM_CTLCOLORLISTBOX -> #wmCtlColor:wParam:lParam:}!

stbConvertFromVersion10: anArray
	"Private - Perform an STB conversion from a version 10 <ListView> to version 11,
	i.e. merge column and primaryColumns instance variables into one, and add a couple 
	of new spare inst. var slots."

	"Set lastSelIndices to empty"

	^(super stbConvertFromVersion10: anArray)
		at: 16 put: #();
		yourself!

uninitialize
	View unregisterMessageMappings: {WM_CTLCOLORLISTBOX}!

value: anObject
	"Private - Implement #value: in order to provide a default 'get text'
	monadic valuable for the receiver's subinstances.
	Implementation Note: More efficient replacement for a block or message
	valuable, mainly to save space in view resources."

	^anObject displayString! !

!BasicListAbstract class categoriesForMethods!
initialize!development!initializing!private! !
stbConvertFromVersion10:!binary filing!private! !
uninitialize!class hierarchy-removing!private! !
value:!evaluating!private! !
!

