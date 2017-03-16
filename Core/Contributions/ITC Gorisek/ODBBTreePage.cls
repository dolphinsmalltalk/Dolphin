"Filed out from Dolphin Smalltalk 7"!

ODBExternalBuffer subclass: #ODBBTreePage
	instanceVariableNames: 'pagePosition keyLength valueLength iterator indexOnPage itemLength'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreePage guid: (GUID fromString: '{8162edf6-0fb8-11d4-b091-000000000000}')!
ODBBTreePage comment: ''!
!ODBBTreePage categoriesForClass!No category! !
!ODBBTreePage methodsFor!

association
	| offset |
	offset := itemLength * indexOnPage + 2.
	^Association key: (contents copyFrom: offset to: offset + keyLength - 1)
		value: (contents copyFrom: offset + keyLength to: offset + keyLength + valueLength - 1)!

bytesPerPage
	"Private - Answer number of bytes needed to load a page."

	"(keyLen + valueLen + next + lockID) * pageSize + next0 + count"

	^(itemLength + 4) * self pageSize + 5!

createOnFile: anODBTreeIterator position: position keyLength: keyLen valueLength: valueLen 
	"Private - Create receiver on file."

	iterator := anODBTreeIterator.
	keyLength := keyLen.
	valueLength := valueLen.
	itemLength := keyLength + valueLength + 2.	"key+value+lockID"
	pagePosition := position.
	indexOnPage := 0.
	contents := ByteArray new: self bytesPerPage!

currentAssociation
	"Answer current association or <nil> 
        if upper pages have to be loaded."

	^(indexOnPage == self numberOfItems or: [indexOnPage < 0]) ifFalse: [self association]!

insertKey: key value: value lockID: lockID 
	"Insert key, value and lockID at current position on page. Answer 
        array with page split information or <nil> if no page split occured."

	| n startOffset |
	startOffset := itemLength * indexOnPage + 1.
	n := self numberOfItems.
	n == self pageSize 
		ifTrue: 
			["split page"
			contents at: 1 put: ((contents at: 1) bitOr: 128).	"this page must be leaf"
			n := ByteArray new: itemLength.
			n
				replaceFrom: 1
					to: keyLength
					with: key
					startingAt: 1;
				replaceFrom: keyLength + 1
					to: keyLength + valueLength
					with: value
					startingAt: 1;
				odbShortAt: itemLength - 1 put: lockID.
			^self 
				splitPageWith: n
				leftNext: 0
				rightNext: 0].
	n > indexOnPage 
		ifTrue: 
			[self bytesAtOffset: startOffset + itemLength
				put: (self bytesAtOffset: startOffset count: (n - indexOnPage) * itemLength)].
	self
		bytesAtOffset: startOffset put: key;
		bytesAtOffset: startOffset + keyLength put: value;
		uShortAtOffset: startOffset + keyLength + valueLength put: lockID.
	self numberOfItems: n + 1.
	^nil!

insertPageSplit: pageSplit 
	"Insert page split at current position on page. Answer array 
        with page split information if another page split is needed 
        or <nil> if current page is not full."

	| n itemOffset nextOffset pageSize item leftNext rightNext |
	leftNext := (pageSplit at: 1) position.
	item := pageSplit at: 2.
	rightNext := (pageSplit at: 3) position.
	pageSize := self pageSize.
	n := self numberOfItems.
	n == pageSize 
		ifTrue: 
			[^self 
				splitPageWith: item
				leftNext: leftNext
				rightNext: rightNext].
	itemOffset := itemLength * indexOnPage + 1.
	nextOffset := itemLength * pageSize + (indexOnPage * 4) + 1.
	n > indexOnPage 
		ifTrue: 
			[self bytesAtOffset: itemOffset + itemLength
				put: (self bytesAtOffset: itemOffset count: (n - indexOnPage) * itemLength).
			self bytesAtOffset: nextOffset + 8
				put: (self bytesAtOffset: nextOffset + 4 count: (n - indexOnPage) * 4)].
	self
		bytesAtOffset: itemOffset put: item;
		uLongAtOffset: nextOffset put: leftNext;
		uLongAtOffset: nextOffset + 4 put: rightNext;
		numberOfItems: n + 1.
	^nil!

insertSplitItem: item leftNext: leftNext rightNext: rightNext 
	"Private - Insert aByteArray at indexOnPage. Answer item 
	at pageSize // 2 that is going to be moved up the tree."

	| itemOffset nextOffset n |
	n := self pageSize // 2.
	itemOffset := itemLength * indexOnPage + 1.
	nextOffset := itemLength * self pageSize + (indexOnPage * 4) + 1.
	self bytesAtOffset: itemOffset + itemLength
		put: (self bytesAtOffset: itemOffset count: (n - indexOnPage) * itemLength).
	self bytesAtOffset: nextOffset + 8
		put: (self bytesAtOffset: nextOffset + 4 count: (n - indexOnPage) * 4).
	self
		bytesAtOffset: itemOffset put: item;
		uLongAtOffset: nextOffset put: leftNext;
		uLongAtOffset: nextOffset + 4 put: rightNext!

leftNext
	"Answer leftmost pointer to next page. And 
        set indexOnPage to zero."

	indexOnPage := 0.
	^self nextAt: 0!

loadFromFile: anODBTreeIterator position: position keyLength: keyLen valueLength: valueLen 
	"Private - Load receiver from stream."

	iterator := anODBTreeIterator.
	keyLength := keyLen.
	valueLength := valueLen.
	itemLength := keyLen + valueLen + 2.	"key+value+lockID"
	pagePosition := position.
	contents := ByteArray new: self bytesPerPage.
	iterator stream atPosition: position getBytesFor: contents!

lockID
	^self uShortAtOffset: (indexOnPage + 1) * itemLength - 1!

lockID: anInteger 
	self uShortAtOffset: (indexOnPage + 1) * itemLength - 1 put: anInteger!

nextAt: index 
	(contents at: 1) > 127 ifTrue: [^0].
	^self uLongAtOffset: itemLength * self pageSize + 1 + (index * 4)!

nextAt: index put: position 
	self uLongAtOffset: itemLength * self pageSize + 1 + (index * 4) put: position!

nextPage
	"Increase indexOnPage and answer pointer to nextPage. 
        Answer <nil> if indexOnPage equals numberOfItems."

	indexOnPage < self numberOfItems ifFalse: [^nil].
	indexOnPage := indexOnPage + 1.
	^self nextAt: indexOnPage!

numberOfItems
	^(contents at: 1) bitAnd: 127!

numberOfItems: anInteger 
	"Private - Set number of items on page."

	(contents at: 1) < 128 
		ifTrue: [contents at: 1 put: anInteger]
		ifFalse: [contents at: 1 put: anInteger + 128]!

pageSize
	"Private - Answer maximum number of keys on page."

	"change methods #positionToCachedKey: and #positionToKey: too!!"

	^32!

position
	^pagePosition!

position: anInteger 
	pagePosition := anInteger!

positionToCachedKey: aKey 
	"Search for aKey on page. Answer <true> if found. 
        If not answer position of child page where aKey could 
        be located. Answer 0 if this is a leaf page. Answer 
        <nil> if position can not be determined (i.e. indexOnPage 
        is at the start or at the end of this page)."

	| n min max result flag |
	min := 0.
	max := n := (flag := contents at: 1) bitAnd: 127.
	indexOnPage := max bitShift: -1.
	n == 0 ifTrue: [^nil].
	
	[(result := iterator 
				isKey: contents
				at: indexOnPage * itemLength + 1
				lessThan: aKey) isNil 
		ifTrue: [^true].
	result ifTrue: [min := indexOnPage + 1] ifFalse: [max := indexOnPage].
	min == max] 
			whileFalse: [indexOnPage := min + max bitShift: -1].
	(indexOnPage := min) == n ifTrue: [^nil].
	indexOnPage == 0 ifTrue: [^nil].
	"Optimization for: ^self nextAt: indexOnPage"
	flag > 127 ifTrue: [^0].
	"PAGE SIZE=32 (bitShift: 5)"
	^self uLongAtOffset: (itemLength bitShift: 5) + 1 + (indexOnPage bitShift: 2)!

positionToKey: aKey 
	"Search for aKey on page. Answer <true> if found. 
        If not answer position of child page where aKey could 
        be located. Answer 0 if this is a leaf page."

	| min max result flag |
	min := 0.
	max := (flag := contents at: 1) bitAnd: 127.
	indexOnPage := max bitShift: -1.
	max = 0 ifTrue: [^0].
	
	[(result := iterator 
				isKey: contents
				at: indexOnPage * itemLength + 1
				lessThan: aKey) == nil 
		ifTrue: [^true].
	result ifTrue: [min := indexOnPage + 1] ifFalse: [max := indexOnPage].
	min = max] 
			whileFalse: [indexOnPage := min + max bitShift: -1].
	indexOnPage := min.
	"Optimization for: ^self nextAt: indexOnPage"
	flag > 127 ifTrue: [^0].
	"PAGE SIZE=32 (bitShift: 5)"
	^self uLongAtOffset: (itemLength bitShift: 5) + 1 + (indexOnPage bitShift: 2)!

previousAssociation
	"Answer previous association or <nil> 
        if upper pages have to be loaded."

	| offset |
	(indexOnPage := indexOnPage - 1) < 0 ifTrue: [^nil].
	offset := indexOnPage * itemLength + 2.
	^Association key: (contents copyFrom: offset to: offset + keyLength - 1)
		value: (contents copyFrom: offset + keyLength to: offset + keyLength + valueLength - 1)!

previousPage
	"Answer pointer to nextPage or <nil> if none."

	indexOnPage < 0 ifTrue: [^nil].
	^self nextAt: indexOnPage!

rightNext
	"Answer rightmost pointer to next page and set 
        indexOnPage to numberOfItems."

	indexOnPage := self numberOfItems.
	^self nextAt: indexOnPage!

shiftPageLeft: count 
	"Private - Shift page to left count times. 
        Used for splitting pages."

	| nextOffset |
	indexOnPage := indexOnPage - count.
	nextOffset := self pageSize * itemLength + 1.
	self bytesAtOffset: 1 put: (contents copyFrom: itemLength * count + 2 to: nextOffset).
	self bytesAtOffset: nextOffset
		put: (contents copyFrom: count * 4 + nextOffset + 1 to: contents size)!

splitPageWith: item leftNext: leftNext rightNext: rightNext 
	"Private - Split current page into left and right page. 
	Answer array with leftPage, middle item and rightPage."

	| newPage halfPage newItem itemOffset |
	newPage := self class 
				createOnFile: iterator
				position: 0
				keyLength: keyLength
				valueLength: valueLength.
	halfPage := self pageSize // 2.
	(contents at: 1) < 127 
		ifTrue: [contents at: 1 put: halfPage]
		ifFalse: [contents at: 1 put: halfPage + 128].
	indexOnPage == halfPage 
		ifTrue: 
			[self nextAt: halfPage put: leftNext.
			newPage contents: contents shallowCopy.
			self
				shiftPageLeft: halfPage;
				nextAt: 0 put: rightNext.
			^Array 
				with: newPage
				with: item
				with: self].
	itemOffset := halfPage * itemLength + 2.
	indexOnPage < halfPage 
		ifTrue: 
			[newPage
				contents: contents shallowCopy;
				shiftPageLeft: halfPage.
			self 
				insertSplitItem: item
				leftNext: leftNext
				rightNext: rightNext.
			newItem := contents copyFrom: itemOffset to: itemOffset + itemLength - 1.
			^Array 
				with: self
				with: newItem
				with: newPage].
	newPage contents: contents shallowCopy.
	newItem := contents copyFrom: itemOffset to: itemOffset + itemLength - 1.
	self
		shiftPageLeft: halfPage + 1;
		insertSplitItem: item
			leftNext: leftNext
			rightNext: rightNext.
	^Array 
		with: newPage
		with: newItem
		with: self!

store
	"Store page on iterator stream."

	iterator stream 
		atPosition: pagePosition
		putBytesFrom: contents
		len: ((contents at: 1) > 127 
				ifFalse: [(itemLength + 4) * self pageSize + 5]
				ifTrue: [itemLength * self pageSize + 1])!

storeItem
	"Store page on iterator stream."

	| offset |
	offset := itemLength * indexOnPage + 1 + keyLength.
	iterator stream atPosition: pagePosition + offset
		putBytesFrom: (contents copyFrom: 1 + offset to: offset + valueLength + 2)!

storeItemLocked
	"Store item at indexOnPage to iterator stream."

	| offset |
	offset := itemLength * indexOnPage + 1 + keyLength.
	iterator waitForLockAt: pagePosition + offset length: valueLength + 2.
	iterator stream atPosition: pagePosition + offset
		putBytesFrom: (contents copyFrom: 1 + offset to: offset + valueLength + 2).
	iterator unlockAt: pagePosition + offset length: valueLength + 2!

storeLocked
	"Store page on iterator stream."

	| length |
	(contents at: 1) > 127 
		ifFalse: [length := (itemLength + 4) * self pageSize + 5]
		ifTrue: [length := itemLength * self pageSize + 1].
	iterator waitForLockAt: pagePosition length: length.
	iterator stream 
		atPosition: pagePosition
		putBytesFrom: contents
		len: length.
	iterator unlockAt: pagePosition length: length!

value: aByteArray 
	self bytesAtOffset: itemLength * indexOnPage + 1 + keyLength put: aByteArray! !
!ODBBTreePage categoriesFor: #association!public! !
!ODBBTreePage categoriesFor: #bytesPerPage!private! !
!ODBBTreePage categoriesFor: #createOnFile:position:keyLength:valueLength:!private! !
!ODBBTreePage categoriesFor: #currentAssociation!public! !
!ODBBTreePage categoriesFor: #insertKey:value:lockID:!public! !
!ODBBTreePage categoriesFor: #insertPageSplit:!public! !
!ODBBTreePage categoriesFor: #insertSplitItem:leftNext:rightNext:!private! !
!ODBBTreePage categoriesFor: #leftNext!public! !
!ODBBTreePage categoriesFor: #loadFromFile:position:keyLength:valueLength:!private! !
!ODBBTreePage categoriesFor: #lockID!public! !
!ODBBTreePage categoriesFor: #lockID:!public! !
!ODBBTreePage categoriesFor: #nextAt:!private! !
!ODBBTreePage categoriesFor: #nextAt:put:!private! !
!ODBBTreePage categoriesFor: #nextPage!public! !
!ODBBTreePage categoriesFor: #numberOfItems!private! !
!ODBBTreePage categoriesFor: #numberOfItems:!private! !
!ODBBTreePage categoriesFor: #pageSize!private! !
!ODBBTreePage categoriesFor: #position!accessing!public! !
!ODBBTreePage categoriesFor: #position:!accessing!public! !
!ODBBTreePage categoriesFor: #positionToCachedKey:!public! !
!ODBBTreePage categoriesFor: #positionToKey:!public! !
!ODBBTreePage categoriesFor: #previousAssociation!public! !
!ODBBTreePage categoriesFor: #previousPage!public! !
!ODBBTreePage categoriesFor: #rightNext!public! !
!ODBBTreePage categoriesFor: #shiftPageLeft:!private! !
!ODBBTreePage categoriesFor: #splitPageWith:leftNext:rightNext:!private! !
!ODBBTreePage categoriesFor: #store!public! !
!ODBBTreePage categoriesFor: #storeItem!public! !
!ODBBTreePage categoriesFor: #storeItemLocked!public! !
!ODBBTreePage categoriesFor: #storeLocked!public! !
!ODBBTreePage categoriesFor: #value:!public! !

!ODBBTreePage class methodsFor!

createOnFile: anODBTreeIterator position: position keyLength: keyLen valueLength: valueLen 
	^self basicNew 
		createOnFile: anODBTreeIterator
		position: position
		keyLength: keyLen
		valueLength: valueLen!

loadFromFile: anODBTreeIterator position: position keyLength: keyLen valueLength: valueLen 
	^self basicNew 
		loadFromFile: anODBTreeIterator
		position: position
		keyLength: keyLen
		valueLength: valueLen! !
!ODBBTreePage class categoriesFor: #createOnFile:position:keyLength:valueLength:!instance creation!public! !
!ODBBTreePage class categoriesFor: #loadFromFile:position:keyLength:valueLength:!instance creation!public! !

