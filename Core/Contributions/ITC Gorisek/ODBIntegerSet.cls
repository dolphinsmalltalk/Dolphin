"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBIntegerSet
	instanceVariableNames: 'bitField currentPage changed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBIntegerSet guid: (GUID fromString: '{8162ee1b-0fb8-11d4-b091-000000000000}')!
ODBIntegerSet comment: ''!
!ODBIntegerSet categoriesForClass!No category! !
!ODBIntegerSet methodsFor!

add: anInteger 
	| pageNumber i j |
	pageNumber := anInteger bitShift: -15.	"-12-3=-15"
	i := ((anInteger bitAnd: 32767) bitShift: -3) + 1.	"8*4096=32768"
	j := 1 bitShift: (anInteger bitAnd: 7).
	self loadPage: pageNumber.
	((bitField at: i) bitAnd: j) == 0 
		ifTrue: 
			[changed := true.
			bitField at: i put: ((bitField at: i) bitOr: j)]!

close
	"Close stream associated with receiver."

	stream isNil 
		ifFalse: 
			[(changed and: [currentPage ~~ nil]) 
				ifTrue: 
					[stream
						position: (currentPage bitShift: 12) + self headerLength;
						putBytesFrom: bitField len: 4096	"2^12=4096"]].
	^super close!

includes: anInteger 
	| pageNumber i j |
	pageNumber := anInteger bitShift: -15.	"-12-3=-15"
	i := ((anInteger bitAnd: 32767) bitShift: -3) + 1.	"4096*8=32768"
	j := 1 bitShift: (anInteger bitAnd: 7).
	self loadPage: pageNumber.
	^((bitField at: i) bitAnd: j) == j!

initialize
	bitField := ByteArray new: 4096.
	changed := false!

loadPage: pageNumber 
	"Private - Check if page pageNumber is loaded. If not, 
	store current page to disk and load page pageNumber."

	| pagePos |
	pageNumber == currentPage ifTrue: [^self].
	changed 
		ifTrue: 
			[stream 
				atPosition: (currentPage bitShift: 12) + self headerLength
				putBytesFrom: bitField
				len: 4096].
	changed := false.
	(pagePos := (pageNumber bitShift: 12) + self headerLength) < stream size 
		ifTrue: 
			[stream 
				atPosition: pagePos
				getBytesFor: bitField
				len: 4096]
		ifFalse: 
			[1 to: bitField size do: [:i | bitField at: i put: 0].
			
			[stream 
				atPosition: stream size
				putBytesFrom: bitField
				len: 4096.
			pagePos > stream size] 
					whileTrue: []].
	currentPage := pageNumber! !
!ODBIntegerSet categoriesFor: #add:!public! !
!ODBIntegerSet categoriesFor: #close!public! !
!ODBIntegerSet categoriesFor: #includes:!public! !
!ODBIntegerSet categoriesFor: #initialize!public! !
!ODBIntegerSet categoriesFor: #loadPage:!public! !

