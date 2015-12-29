"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBObjectIdStack
	instanceVariableNames: 'cache top filePos valueSize bottom'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectIdStack guid: (GUID fromString: '{8162EE1C-0FB8-11D4-B091-000000000000}')!
ODBObjectIdStack comment: ''!
!ODBObjectIdStack categoriesForClass!No category! !
!ODBObjectIdStack methodsFor!

add: objectID 
	| oid index pos |
	top > self doubleCacheSize ifTrue: [self makeSpace].
	pos := top.
	top := top + 1.
	pos > self cacheSize ifTrue: [^(cache at: 2) at: pos - self cacheSize put: objectID].
	(cache at: 1) at: pos put: objectID!

cacheSize
	^5000!

doubleCacheSize
	^10000!

initialize
	cache := Array with: (Array new: self cacheSize) with: (Array new: self cacheSize).
	top := 1.
	bottom := 1.
	filePos := self headerLength.
	valueSize := ODBObjectID sizeInBytes!

isEmpty
	^top == bottom and: [filePos == self headerLength]!

loadPage
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	stream
		position: filePos - buf size;
		getBytesFor: buf.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			subCache at: i put: (ODBObjectID new fromBytes: buf at: pos).
			pos := pos + valueSize].
	filePos := filePos - buf size.
	top := count + 1.
	bottom := 1!

makeSpace
	"Private - Make space on stack."

	| cache1 pos |
	bottom == 1 ifTrue: [^self storePage].
	cache1 := cache at: 1.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: cache1.
	bottom > self cacheSize 
		ifTrue: 
			[top := top - self cacheSize.
			bottom := bottom - self cacheSize.
			^self].
	pos := bottom - 1.
	bottom := 1.
	top := top - pos.
	1 to: top - 1 - self cacheSize do: [:i | cache1 at: i put: (cache1 at: i + pos)]!

removeLast
	top == bottom ifTrue: [self loadPage].
	bottom > self cacheSize ifTrue: [^self removeLastCache2].
	^self removeLastCache1!

removeLastCache1
	| cache1 result |
	cache1 := cache at: 1.
	result := cache1 at: bottom.
	cache1 at: bottom put: nil.
	bottom := bottom + 1.
	^result!

removeLastCache2
	| cache2 result |
	cache2 := cache at: 2.
	result := cache2 at: bottom - self cacheSize.
	cache2 at: bottom - self cacheSize put: nil.
	bottom := bottom + 1.
	^result!

storePage
	| count buf pos subCache |
	count := self cacheSize.
	buf := ByteArray new: count * valueSize.
	pos := 1.
	subCache := cache at: 1.
	1 to: count
		do: 
			[:i | 
			(subCache at: i) putBytesTo: buf at: pos.
			subCache at: i put: nil.
			pos := pos + valueSize].
	stream
		position: filePos;
		putBytesFrom: buf.
	filePos := filePos + buf size.
	cache
		at: 1 put: (cache at: 2);
		at: 2 put: subCache.	"swap halves"
	top := count + 1.
	bottom := 1! !
!ODBObjectIdStack categoriesFor: #add:!public! !
!ODBObjectIdStack categoriesFor: #cacheSize!public! !
!ODBObjectIdStack categoriesFor: #doubleCacheSize!public! !
!ODBObjectIdStack categoriesFor: #initialize!public! !
!ODBObjectIdStack categoriesFor: #isEmpty!public! !
!ODBObjectIdStack categoriesFor: #loadPage!public! !
!ODBObjectIdStack categoriesFor: #makeSpace!public! !
!ODBObjectIdStack categoriesFor: #removeLast!public! !
!ODBObjectIdStack categoriesFor: #removeLastCache1!public! !
!ODBObjectIdStack categoriesFor: #removeLastCache2!public! !
!ODBObjectIdStack categoriesFor: #storePage!public! !

