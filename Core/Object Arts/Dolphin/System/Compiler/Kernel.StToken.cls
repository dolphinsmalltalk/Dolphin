"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Kernel.StToken'
	instanceVariableNames: 'start comments'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StToken guid: (Core.GUID fromString: '{91b3208a-a4b2-4319-952d-c260cd7ab80f}')!
Kernel.StToken isNonInstantiable: true!
Kernel.StToken comment: 'StToken is the abstract superclass of <SmalltalkScanner>tokens.

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

isEof
	^false!

isIdentifier
	^false!

isKeyword
	^false!

isLiteralArrayToken
	^false!

isLiteralToken
	^false!

isNumberLiteralToken
	^false!

isOptimized
	^false!

isPatternBlock
	^false!

isPatternVariable
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
	"Answer an <Interval> that specifies the range of source positions occuppied by the receiver."

	^self start to: self stop!

start
	^start!

start: anInteger
	start := anInteger!

stop
	^self start + self length - 1! !
!Kernel.StToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StToken categoriesFor: #comments!accessing!public! !
!Kernel.StToken categoriesFor: #comments:!accessing!private! !
!Kernel.StToken categoriesFor: #isAssignment!public!testing! !
!Kernel.StToken categoriesFor: #isBinary!public!testing! !
!Kernel.StToken categoriesFor: #isBinary:!public!testing! !
!Kernel.StToken categoriesFor: #isEof!public!testing! !
!Kernel.StToken categoriesFor: #isIdentifier!public!testing! !
!Kernel.StToken categoriesFor: #isKeyword!public!testing! !
!Kernel.StToken categoriesFor: #isLiteralArrayToken!public!testing! !
!Kernel.StToken categoriesFor: #isLiteralToken!public!testing! !
!Kernel.StToken categoriesFor: #isNumberLiteralToken!public!testing! !
!Kernel.StToken categoriesFor: #isOptimized!public!testing! !
!Kernel.StToken categoriesFor: #isPatternBlock!public!testing! !
!Kernel.StToken categoriesFor: #isPatternVariable!public!testing! !
!Kernel.StToken categoriesFor: #isQualifiedReference!public!testing! !
!Kernel.StToken categoriesFor: #isSpecial!public!testing! !
!Kernel.StToken categoriesFor: #isSpecial:!public!testing! !
!Kernel.StToken categoriesFor: #length!accessing!public! !
!Kernel.StToken categoriesFor: #printOn:!printing!public! !
!Kernel.StToken categoriesFor: #removePositions!accessing!public! !
!Kernel.StToken categoriesFor: #scannerClass!constants!public! !
!Kernel.StToken categoriesFor: #sourceInterval!accessing!public! !
!Kernel.StToken categoriesFor: #start!accessing!public! !
!Kernel.StToken categoriesFor: #start:!initializing!private! !
!Kernel.StToken categoriesFor: #stop!accessing!public! !

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
!Kernel.StToken class categoriesFor: #start:!instance creation!public! !
!Kernel.StToken class categoriesFor: #start:comments:!instance creation!public! !

