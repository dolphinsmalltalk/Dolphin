"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBBTreeIterator
	instanceVariableNames: 'keyLength valueLength rootPagePosition searchPath currentKey currentKeyExists nextKey searchPathHeight version mutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeIterator guid: (GUID fromString: '{8162ee16-0fb8-11d4-b091-000000000000}')!
ODBBTreeIterator comment: ''!
!ODBBTreeIterator categoriesForClass!No category! !
!ODBBTreeIterator methodsFor!

at: aString ifAbsent: aBlock 
	| key association |
	key := ByteArray new: keyLength.
	key 
		replaceFrom: 1
		to: (aString size min: keyLength)
		with: aString
		startingAt: 1.
	association := self goToAndGetCurrentAt: key.
	self clearSearchCache.
	association isNil ifTrue: [^aBlock value].
	^association value odbLongAt: 1!

at: aString put: anInteger 
	| key value |
	key := ByteArray new: keyLength.
	key 
		replaceFrom: 1
		to: (aString size min: keyLength)
		with: aString
		startingAt: 1.
	value := ByteArray new: 4.
	value odbLongAt: 1 put: anInteger.
	self
		goTo: key put: value;
		clearSearchCache.
	^anInteger!

basicPut: aValue 
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists 
		ifTrue: 
			[(self lastPage)
				value: aValue;
				storeItemLocked]
		ifFalse: [self insertValue: aValue lockID: 0]] 
			ensure: [self unlockTree]!

clearSearchCache
	"Clear search path."

	mutex critical: [self clearSearchPath]!

clearSearchPath
	"Private - Clear search path."

	[searchPathHeight == 0] whileFalse: 
			[searchPath at: searchPathHeight put: nil.
			searchPathHeight := searchPathHeight - 1]!

created
	"Private - File has just been created."

	| buffer bufSize |
	bufSize := ODBSizeHolder sizeInBytes + 4.
	buffer := ByteArray new: bufSize.
	buffer
		odbShortAt: bufSize - 3 put: keyLength;
		odbShortAt: bufSize - 1 put: valueLength.
	stream putBytesFrom: buffer len: bufSize.
	(self pageClass 
		createOnFile: self
		position: rootPagePosition
		keyLength: keyLength
		valueLength: valueLength) store.
	currentKey := ByteArray new: keyLength.
	nextKey := ByteArray new: keyLength.
	stream flush!

createOn: aString 
	"Create a database file."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateNew
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self writeHeader!

critical: aBlock 
	^mutex critical: aBlock!

descriptionString
	^'BTree File
OmniBase 1.0, David Gorisek (c) 1998

'!

getCurrent
	"Answer association at current key or <nil> if none."

	self updateCurrentKey.
	currentKeyExists ifFalse: [^nil].
	^self lastPage association!

getFirst
	nextKey := ByteArray new: keyLength.
	self updateCurrentKey.
	currentKeyExists ifTrue: [^self lastPage association].
	^self searchNextAssociation!

getLast
	nextKey := (ByteArray new: keyLength) atAllPut: 255.
	self updateCurrentKey.
	currentKeyExists ifTrue: [^self lastPage association].
	^self searchPreviousAssociation!

getNext
	"Move to the next key and answer association."

	self updateCurrentKey.
	^self searchNextAssociation!

getPrevious
	"Move to the previous key and answer association."

	self updateCurrentKey.
	^self searchPreviousAssociation!

getSizeAt: versionDescriptor oldHolders: oldHolders 
	| sizeHolder |
	sizeHolder := (ODBSizeHolder new)
				loadFromStream: stream at: self headerLength;
				yourself.
	[versionDescriptor versionAtStartOK: sizeHolder versionNumber] 
		whileFalse: [sizeHolder loadPreviousVersionFrom: oldHolders].
	^sizeHolder dictionarySize!

getSizeHolder
	^(ODBSizeHolder new)
		loadFromStream: stream at: self headerLength;
		yourself!

goTo: aByteArray 
	aByteArray isNil ifFalse: [nextKey := aByteArray]!

goTo: aByteArray put: aValue 
	mutex critical: 
			[aByteArray isNil ifFalse: [nextKey := aByteArray].
			self basicPut: aValue].
	^aValue!

goToAndGetCurrentAt: aKey 
	| result |
	mutex critical: 
			[result := self
						goTo: aKey;
						getCurrent].
	^result!

initialize
	"Private - Initialize receiver."

	searchPath := Array new: 20.
	searchPathHeight := 0.
	rootPagePosition := self headerLength + ODBSizeHolder sizeInBytes + 4.
	mutex := Semaphore forMutualExclusion!

insertValue: aValue lockID: lockID 
	"Private - Insert aValue and lockID at currentKey. 
        Precondition: search path to currentKey is loaded and 
        currentKey does not exists."

	| page pageSplit |
	page := searchPath at: searchPathHeight.
	pageSplit := page 
				insertKey: currentKey
				value: aValue
				lockID: lockID.
	pageSplit isNil 
		ifTrue: 
			[currentKeyExists := true.
			page storeLocked.
			^self].
	
	[(pageSplit at: 1)
		position: stream setToEnd;
		store.
	(pageSplit at: 3)
		position: stream position;
		store.
	searchPath at: searchPathHeight put: nil.
	searchPathHeight := searchPathHeight - 1.
	searchPathHeight == 0 
		ifFalse: [page := searchPath at: searchPathHeight]
		ifTrue: 
			[page := self pageClass 
						createOnFile: self
						position: rootPagePosition
						keyLength: keyLength
						valueLength: valueLength].
	pageSplit := page insertPageSplit: pageSplit.
	pageSplit isNil] 
			whileFalse: [].
	self clearSearchPath.
	page storeLocked!

isCurrentKeySet
	"Private - Answer <true> if currentKey is the same as the next key."

	nextKey == currentKey ifTrue: [^true].
	1 to: keyLength do: [:i | (currentKey at: i) == (nextKey at: i) ifFalse: [^false]].
	^true!

isKey: keyBytes at: startPos lessThan: key2 
	"Private - Answer <true> if key located at keyBytes from startPos + 1 
        is less than key2. Answer <nil> if keys are equal."

	| b1 b2 |
	1 to: keyLength
		do: [:i | (b1 := keyBytes at: startPos + i) == (b2 := key2 at: i) ifFalse: [^b1 < b2]].
	^nil!

isKey: key1 lessOrEqualTo: key2 
	"Answer <true> if key1 is less or equal to key2."

	| i |
	i := 1.
	[(key1 at: i) == (key2 at: i) and: [i < keyLength]] whileTrue: [i := i + 1].
	^(key1 at: i) <= (key2 at: i)!

isLocked
	"Answer <true> if current key is locked."

	self updateCurrentKey.
	currentKeyExists ifFalse: [^false].
	^self lastPage lockID ~= 0!

keyLength
	^keyLength!

keyLength: anInteger 
	keyLength := anInteger!

lastPage
	"Private - Answer last page in search path."

	^searchPath at: searchPathHeight!

loadCurrentKey
	"Private - Load current key from file when it is going to be updated."

	currentKey := nextKey.
	currentKeyExists := false.
	self
		clearSearchPath;
		searchCurrentKeyFrom: rootPagePosition!

loadPageAt: pagePosition 
	"Private - Load B-Tree page, store it in searchPath. 
        Answer loaded page."

	| page |
	page := self pageClass 
				loadFromFile: self
				position: pagePosition
				keyLength: keyLength
				valueLength: valueLength.
	searchPathHeight := searchPathHeight + 1.
	^searchPath at: searchPathHeight put: page!

lockCurrentValue: value with: lockID 
	"Try to lock currentKey & value with lockID. 
	Answer <true> if successfull."

	| result page |
	result := false.
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists 
		ifTrue: 
			[page := self lastPage.
			(result := page lockID == 0 and: [page association value = value]) 
				ifTrue: 
					[page
						lockID: lockID;
						storeItem]]
		ifFalse: 
			[self insertValue: value lockID: lockID.
			result := true]] 
			ensure: [self unlockTree].
	^result!

lockTree
	"Private - Lock tree when it is being updated."

	self waitForAddingLock!

opened
	"Private - File has just been opened."

	| buffer bufSize |
	bufSize := ODBSizeHolder sizeInBytes + 2 + 2.
	buffer := ByteArray new: bufSize.
	stream getBytesFor: buffer.
	keyLength := buffer odbShortAt: bufSize - 3.
	valueLength := buffer odbShortAt: bufSize - 1.
	currentKey := ByteArray new: keyLength.
	nextKey := ByteArray new: keyLength!

openOn: aString 
	"Open transaction file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareAll
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self compareHeader!

pageClass
	"Private - Answer B-Tree page class."

	^ODBBTreePage!

put: aValue 
	mutex critical: [self basicPut: aValue]!

putSizeHolder: aSizeHolder 
	stream position: self headerLength.
	aSizeHolder storeOnStream: stream!

removeLastPage
	"Private - Remove last page in search path. 
        Answer current last page in search path."

	searchPath at: searchPathHeight put: nil.
	searchPathHeight := searchPathHeight - 1.
	^searchPath at: searchPathHeight!

searchCurrentKeyFrom: pagePosition 
	"Private - Search current key and remember all pages following."

	| currentPage nextPagePosition |
	currentPage := self loadPageAt: pagePosition.
	
	[(nextPagePosition := currentPage positionToKey: currentKey) == true 
		ifTrue: 
			[currentKeyExists := true.
			^self].
	nextPagePosition = 0] 
			whileFalse: [currentPage := self loadPageAt: nextPagePosition]!

searchNextAssociation
	"Private - Search for next association. Answer <nil> if none."

	| page association nextPagePosition |
	page := self lastPage.
	currentKeyExists ifFalse: [association := page currentAssociation].
	[association isNil] whileTrue: 
			[(nextPagePosition := page nextPage) = 0 
				ifFalse: 
					[nextPagePosition isNil 
						ifTrue: 
							[searchPathHeight = 1 
								ifTrue: 
									[nextKey := (ByteArray new: keyLength) atAllPut: 255.
									self clearSearchPath.
									^nil].
							page := self removeLastPage]
						ifFalse: 
							[
							[page := self loadPageAt: nextPagePosition.
							(nextPagePosition := page leftNext) = 0] 
									whileFalse: []]].
			association := page currentAssociation].
	nextKey := currentKey := association key.
	currentKeyExists := true.
	^association!

searchPreviousAssociation
	"Private - Search for the previous association. Answer <nil> if none."

	| page association pagePosition |
	page := self lastPage.
	[association isNil] whileTrue: 
			[(pagePosition := page previousPage) = 0 
				ifFalse: 
					[pagePosition isNil 
						ifTrue: 
							[searchPathHeight = 1 
								ifTrue: 
									[nextKey := ByteArray new: keyLength.
									self clearSearchPath.
									^nil].
							page := self removeLastPage]
						ifFalse: 
							[
							[page := self loadPageAt: pagePosition.
							(pagePosition := page rightNext) = 0] 
									whileFalse: []]].
			association := page previousAssociation].
	nextKey := currentKey := association key.
	currentKeyExists := true.
	^association!

unlockCurrentWith: lockID 
	"Try to unlock currentKey with lockID. 
        Answer <true> if successfull."

	| fileLockID |
	self lockTree.
	
	[self loadCurrentKey.
	currentKeyExists ifFalse: [^true].
	fileLockID := self lastPage lockID.
	fileLockID == 0 ifTrue: [^true].
	fileLockID == lockID 
		ifTrue: 
			[(self lastPage)
				lockID: 0;
				storeItem.
			^true]] 
			ensure: [self unlockTree].
	^false!

unlockTree
	"Private - Unlock tree after it has been updated."

	self unlockAdding!

updateCurrentKey
	"Private - Check if iterator has been moved
        and update cache if it has been moved."

	| nextPagePosition |
	searchPathHeight = 0 
		ifTrue: 
			[currentKey := nextKey.
			currentKeyExists := false.
			^self searchCurrentKeyFrom: rootPagePosition].
	self isCurrentKeySet ifTrue: [^self].
	currentKey := nextKey.
	currentKeyExists := false.
	[searchPathHeight > 1] whileTrue: 
			[(nextPagePosition := (searchPath at: searchPathHeight) positionToCachedKey: currentKey) 
				== true 
					ifTrue: 
						[currentKeyExists := true.
						^self].
			nextPagePosition isNil 
				ifFalse: 
					[nextPagePosition = 0 ifTrue: [^self].
					^self searchCurrentKeyFrom: nextPagePosition].
			searchPath at: searchPathHeight put: nil.
			searchPathHeight := searchPathHeight - 1].
	(nextPagePosition := (searchPath at: 1) positionToKey: currentKey) == true 
		ifTrue: 
			[currentKeyExists := true.
			^self].
	nextPagePosition = 0 ifFalse: [self searchCurrentKeyFrom: nextPagePosition]!

updateSizeAt: versionNumber oldHolders: oldHolders deltaSize: deltaSize 
	| oldHolder newHolder pos |
	pos := self headerLength.
	self waitForLockAt: pos length: ODBSizeHolder sizeInBytes.
	
	[oldHolder := (ODBSizeHolder new)
				loadFromStream: stream at: pos;
				yourself.
	oldHolders isNil 
		ifTrue: [newHolder := oldHolder]
		ifFalse: 
			[newHolder := oldHolder makeNewVersion: oldHolders.
			oldHolders flush].
	newHolder
		dictionarySize: oldHolder dictionarySize + deltaSize;
		versionNumber: versionNumber.
	newHolder storeOnStream: stream at: pos] 
			ensure: [self unlockAt: pos length: ODBSizeHolder sizeInBytes]!

value: key1 value: key2 
	"Answer <true> if key1 is less or equal to key2. 
	Receiver can be used as sortBlock for SortedCollection."

	| s1 s2 a1 a2 |
	s1 := key1 size.
	s2 := key2 size.
	1 to: keyLength
		do: 
			[:i | 
			i > s1 ifTrue: [a1 := 0] ifFalse: [a1 := key1 at: i].
			i > s2 ifTrue: [a2 := 0] ifFalse: [a2 := key2 at: i].
			a1 = a2 ifFalse: [^a1 < a2]].
	^true!

valueLength: anInteger 
	valueLength := anInteger!

version
	^version!

version: anObject 
	version := anObject! !
!ODBBTreeIterator categoriesFor: #at:ifAbsent:!public! !
!ODBBTreeIterator categoriesFor: #at:put:!public! !
!ODBBTreeIterator categoriesFor: #basicPut:!private! !
!ODBBTreeIterator categoriesFor: #clearSearchCache!public! !
!ODBBTreeIterator categoriesFor: #clearSearchPath!private! !
!ODBBTreeIterator categoriesFor: #created!public! !
!ODBBTreeIterator categoriesFor: #createOn:!public! !
!ODBBTreeIterator categoriesFor: #critical:!public! !
!ODBBTreeIterator categoriesFor: #descriptionString!public! !
!ODBBTreeIterator categoriesFor: #getCurrent!public! !
!ODBBTreeIterator categoriesFor: #getFirst!public! !
!ODBBTreeIterator categoriesFor: #getLast!public! !
!ODBBTreeIterator categoriesFor: #getNext!public! !
!ODBBTreeIterator categoriesFor: #getPrevious!public! !
!ODBBTreeIterator categoriesFor: #getSizeAt:oldHolders:!public! !
!ODBBTreeIterator categoriesFor: #getSizeHolder!public! !
!ODBBTreeIterator categoriesFor: #goTo:!public! !
!ODBBTreeIterator categoriesFor: #goTo:put:!public! !
!ODBBTreeIterator categoriesFor: #goToAndGetCurrentAt:!public! !
!ODBBTreeIterator categoriesFor: #initialize!private! !
!ODBBTreeIterator categoriesFor: #insertValue:lockID:!private! !
!ODBBTreeIterator categoriesFor: #isCurrentKeySet!public! !
!ODBBTreeIterator categoriesFor: #isKey:at:lessThan:!public! !
!ODBBTreeIterator categoriesFor: #isKey:lessOrEqualTo:!public! !
!ODBBTreeIterator categoriesFor: #isLocked!public! !
!ODBBTreeIterator categoriesFor: #keyLength!public! !
!ODBBTreeIterator categoriesFor: #keyLength:!public! !
!ODBBTreeIterator categoriesFor: #lastPage!private! !
!ODBBTreeIterator categoriesFor: #loadCurrentKey!private! !
!ODBBTreeIterator categoriesFor: #loadPageAt:!private! !
!ODBBTreeIterator categoriesFor: #lockCurrentValue:with:!public! !
!ODBBTreeIterator categoriesFor: #lockTree!public! !
!ODBBTreeIterator categoriesFor: #opened!public! !
!ODBBTreeIterator categoriesFor: #openOn:!public! !
!ODBBTreeIterator categoriesFor: #pageClass!public! !
!ODBBTreeIterator categoriesFor: #put:!public! !
!ODBBTreeIterator categoriesFor: #putSizeHolder:!public! !
!ODBBTreeIterator categoriesFor: #removeLastPage!private! !
!ODBBTreeIterator categoriesFor: #searchCurrentKeyFrom:!public! !
!ODBBTreeIterator categoriesFor: #searchNextAssociation!private! !
!ODBBTreeIterator categoriesFor: #searchPreviousAssociation!private! !
!ODBBTreeIterator categoriesFor: #unlockCurrentWith:!public! !
!ODBBTreeIterator categoriesFor: #unlockTree!public! !
!ODBBTreeIterator categoriesFor: #updateCurrentKey!private! !
!ODBBTreeIterator categoriesFor: #updateSizeAt:oldHolders:deltaSize:!public! !
!ODBBTreeIterator categoriesFor: #value:value:!public! !
!ODBBTreeIterator categoriesFor: #valueLength:!public! !
!ODBBTreeIterator categoriesFor: #version!public! !
!ODBBTreeIterator categoriesFor: #version:!public! !

