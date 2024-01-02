"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.StToken'
	instanceVariableNames: 'start comments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StToken guid: (Core.GUID fromString: '{91b3208a-a4b2-4319-952d-c260cd7ab80f}')!
Kernel.StToken isNonInstantiable: true!
Kernel.StToken comment: 'StToken is the abstract superclass of <SmalltalkScanner> tokens.

Instance Variables:
	sourcePointer	<Integer>	The starting position in the original source code of this token.
'!
!Kernel.StToken categoriesForClass!System-Compiler! !
!Kernel.StToken methodsFor!

acceptVisitor: aTokenVisitor 
	^self subclassResponsibility!

comments
	^comments!

comments: aCollectionOrNil
	"Private - Set the code comment ranges associated with this token. Answer the receiver."

	comments := aCollectionOrNil.
	^self!

isAssignment
	^false!

isBinary
	^false!

isBinary: aString
	"Answer whether the receiver is a binary token with the specified value."

	^false!

isBinaryStarting: aCharacter
	"Answer whether the receiver is a binary token starting with the specified <Character>."

	^false!

isEof
	^false!

isIdentifier
	^false!

isKeyword
	^false!

isLiteralArrayToken
	^false!

isLiteralByteArrayToken
	^false!

isLiteralSymbolToken
	^false!

isLiteralToken
	^false!

isNumberLiteralToken
	^false!

isOptimized
	^false!

isPatternBlock
	^false!

isQualifiedReference
	^false!

isSpecial
	^false!

isSpecial: aCharacter
	^false!

length
	^self subclassResponsibility!

printOn: aStream 
	aStream
		nextPut: $\x20;
		nextPutAll: self class name!

removePositions
	start := nil!

scannerClass
	^Scanner!

sourceInterval
	"Answer an <Interval> that specifies the range of source positions occupied by the receiver."

	^self start to: self stop!

start
	^start!

start: anInteger
	start := anInteger!

stop
	^self start + self length - 1! !
!Kernel.StToken categoriesForMethods!
acceptVisitor:!public!visitor! !
comments!accessing!public! !
comments:!accessing!private! !
isAssignment!public!testing! !
isBinary!public!testing! !
isBinary:!public!testing! !
isBinaryStarting:!public!testing! !
isEof!public!testing! !
isIdentifier!public!testing! !
isKeyword!public!testing! !
isLiteralArrayToken!public!testing! !
isLiteralByteArrayToken!public!testing! !
isLiteralSymbolToken!public!testing! !
isLiteralToken!public!testing! !
isNumberLiteralToken!public!testing! !
isOptimized!public!testing! !
isPatternBlock!public!testing! !
isQualifiedReference!public!testing! !
isSpecial!public!testing! !
isSpecial:!public!testing! !
length!accessing!public! !
printOn:!printing!public! !
removePositions!accessing!public! !
scannerClass!constants!public! !
sourceInterval!accessing!public! !
start!accessing!public! !
start:!initializing!private! !
stop!accessing!public! !
!

!Kernel.StToken class methodsFor!

start: anInteger 
	<primitive: 157>
	^self new start: anInteger
!

start: anInteger comments: aCollectionOrNil
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		yourself! !
!Kernel.StToken class categoriesForMethods!
start:!instance creation!public! !
start:comments:!instance creation!public! !
!

