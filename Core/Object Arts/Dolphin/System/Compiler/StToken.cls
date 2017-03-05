"Filed out from Dolphin Smalltalk 7"!

Object subclass: #StToken
	instanceVariableNames: 'sourcePointer comments'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StToken guid: (GUID fromString: '{91b3208a-a4b2-4319-952d-c260cd7ab80f}')!
StToken comment: ''!
!StToken categoriesForClass!System-Compiler! !
!StToken methodsFor!

acceptVisitor: aTokenVisitor 
	^self subclassResponsibility!

comments
	^comments!

comments: aCollectionOrNil
	"Set the code comment ranges associated with this token. Answer the receiver."

	comments := aCollectionOrNil.
	^self!

isAssignment
	^false!

isBinary
	^false!

isBinary: aString
	"Answer whether the receiver is a binary token with the specified value."

	^false!

isEof
	^self class == ##(self)!

isIdentifier
	^false!

isKeyword
	^false!

isLiteralArrayToken
	^false!

isLiteralToken
	^false!

isOptimized
	^false!

isPatternBlock
	^false!

isPatternVariable
	^false!

isSpecial
	^false!

isSpecial: aCharacter
	^false!

length
	^0!

printOn: aStream 
	aStream
		nextPut: $\x20;
		nextPutAll: self class name!

removePositions
	sourcePointer := nil!

scannerClass
	^SmalltalkScanner!

sourceInterval
	"Answer an <Interval> that specifies the range of source positions occuppied by the receiver."

	^self start to: self stop!

start
	^sourcePointer!

start: anInteger 
	sourcePointer := anInteger!

stop
	^self start + self length - 1! !
!StToken categoriesFor: #acceptVisitor:!public!visitor! !
!StToken categoriesFor: #comments!accessing!public! !
!StToken categoriesFor: #comments:!accessing!public! !
!StToken categoriesFor: #isAssignment!public!testing! !
!StToken categoriesFor: #isBinary!public!testing! !
!StToken categoriesFor: #isBinary:!public!testing! !
!StToken categoriesFor: #isEof!public!testing! !
!StToken categoriesFor: #isIdentifier!public!testing! !
!StToken categoriesFor: #isKeyword!public!testing! !
!StToken categoriesFor: #isLiteralArrayToken!public!testing! !
!StToken categoriesFor: #isLiteralToken!public!testing! !
!StToken categoriesFor: #isOptimized!public!testing! !
!StToken categoriesFor: #isPatternBlock!public!testing! !
!StToken categoriesFor: #isPatternVariable!public!testing! !
!StToken categoriesFor: #isSpecial!public!testing! !
!StToken categoriesFor: #isSpecial:!public!testing! !
!StToken categoriesFor: #length!accessing!public! !
!StToken categoriesFor: #printOn:!printing!public! !
!StToken categoriesFor: #removePositions!accessing!public! !
!StToken categoriesFor: #scannerClass!constants!public! !
!StToken categoriesFor: #sourceInterval!accessing!public! !
!StToken categoriesFor: #start!accessing!public! !
!StToken categoriesFor: #start:!initializing!public! !
!StToken categoriesFor: #stop!accessing!public! !

!StToken class methodsFor!

start: anInteger 
	<primitive: 157>
	^self new start: anInteger
! !
!StToken class categoriesFor: #start:!instance creation!public! !

