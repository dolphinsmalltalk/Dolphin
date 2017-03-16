"Filed out from Dolphin Smalltalk 7"!

ODBBTreePage subclass: #ODBGcBTreePage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGcBTreePage guid: (GUID fromString: '{8162edfa-0fb8-11d4-b091-000000000000}')!
ODBGcBTreePage comment: ''!
!ODBGcBTreePage categoriesForClass!No category! !
!ODBGcBTreePage methodsFor!

splitPageWith: item leftNext: leftNext rightNext: rightNext 
	"Private - Split current page into left and right page. 
	Answer array with leftPage, middle item and rightPage. 
	Left page in split will be full up to space for one item. 
	Split item will be put on the right page."

	| pageSize newPage newItem itemOffset leafBit |
	pageSize := self pageSize - 1.
	indexOnPage > pageSize 
		ifFalse: 
			[^super 
				splitPageWith: item
				leftNext: leftNext
				rightNext: rightNext].
	newPage := self class 
				createOnFile: iterator
				position: 0
				keyLength: keyLength
				valueLength: valueLength.
	leafBit := (contents at: 1) bitAnd: 128.
	"make left page"
	contents at: 1 put: pageSize + leafBit.
	itemOffset := pageSize * itemLength + 2.
	newItem := contents copyFrom: itemOffset to: itemOffset + itemLength - 1.
	newPage contents: contents shallowCopy.
	"make right page"
	contents at: 1 put: 1 + leafBit.
	self
		nextAt: 0 put: leftNext;
		nextAt: 1 put: rightNext.
	contents 
		replaceFrom: 2
		to: itemLength + 1
		with: item
		startingAt: 1.
	^Array 
		with: newPage
		with: newItem
		with: self! !
!ODBGcBTreePage categoriesFor: #splitPageWith:leftNext:rightNext:!public! !

