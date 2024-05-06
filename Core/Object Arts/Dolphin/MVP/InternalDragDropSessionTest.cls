"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #InternalDragDropSessionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InternalDragDropSessionTest guid: (GUID fromString: '{7ad52eea-323b-4bef-a087-a775a45fc039}')!

InternalDragDropSessionTest comment: ''!

!InternalDragDropSessionTest categoriesForClass!Unclassified! !

!InternalDragDropSessionTest methodsFor!

testInitialState
	| subject |
	subject := InternalDragDropSession new.
	self assertIsNil: subject dragSource.
	self assertIsNil: subject dragPoint.
	self assertIsNil: subject suggestedSource.
	self assert: subject dragObjects asArray equals: #().
	self assert: subject defaultOperation identicalTo: #move.
	self assertIsNil: subject dropTarget.
	self assertIsNil: subject suggestedTarget.
	self assert: subject supportedOperations equals: #(#move #copy).
	self assertIsNil: subject operation.
	self deny: subject isInDropTargetScrollZone.
	self deny: subject isExtendedDrag.
	self assert: subject operationDescriptions equals: DragDropSession.OperationDescriptions.
	self assert: subject scrollDelay equals: 1 seconds.
	self assert: subject scrollInterval equals: 100 milliseconds! !

!InternalDragDropSessionTest categoriesForMethods!
testInitialState!public! !
!

