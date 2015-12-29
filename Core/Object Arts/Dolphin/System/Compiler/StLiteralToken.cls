"Filed out from Dolphin Smalltalk X6"!

StValueToken subclass: #StLiteralToken
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralToken guid: (GUID fromString: '{85FE993E-366B-4F11-9B9C-E5AC73674129}')!
StLiteralToken comment: ''!
!StLiteralToken categoriesForClass!System-Compiler! !
!StLiteralToken methodsFor!

acceptVisitor: aTokenVisitor 
	^aTokenVisitor acceptLiteralToken: self!

isLiteralToken
	^true!

isMultiKeyword
	^false!

length
	^stopPosition - self start + 1!

realValue
	^value!

sourceInterval
	"Answer an <Interval> that specifies the range of source positions occuppied by the receiver."

	^self start to: stopPosition!

stop: anInteger
	stopPosition := anInteger!

storeOn: aStream 
	(value isKindOf: Symbol) 
		ifTrue: 
			[aStream nextPut: $#.
			((SmalltalkScanner isSelector: value) and: [value ~~ #'||']) 
				ifTrue: [aStream nextPutAll: value]
				ifFalse: [value asString printOn: aStream].
			^self].
	value class == Character 
		ifTrue: 
			[aStream
				nextPut: $$;
				nextPut: value.
			^self].
	value storeOn: aStream!

value: aString start: anInteger stop: stopInteger 
	value := aString.
	sourcePointer := anInteger.
	stopPosition := stopInteger! !
!StLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralToken categoriesFor: #isLiteralToken!public!testing! !
!StLiteralToken categoriesFor: #isMultiKeyword!public!testing! !
!StLiteralToken categoriesFor: #length!accessing!private! !
!StLiteralToken categoriesFor: #realValue!accessing!public! !
!StLiteralToken categoriesFor: #sourceInterval!accessing!public! !
!StLiteralToken categoriesFor: #stop:!accessing!public! !
!StLiteralToken categoriesFor: #storeOn:!printing!public! !
!StLiteralToken categoriesFor: #value:start:stop:!initializing!private! !

!StLiteralToken class methodsFor!

value: anObject 
	| literal |
	literal := anObject class == Array 
				ifTrue: [anObject collect: [:each | self value: each]]
				ifFalse: [anObject].
	^self 
		value: literal
		start: nil
		stop: nil!

value: aString start: anInteger stop: stopInteger 
	^(self new)
		value: aString
			start: anInteger
			stop: stopInteger;
		yourself! !
!StLiteralToken class categoriesFor: #value:!instance creation!public! !
!StLiteralToken class categoriesFor: #value:start:stop:!instance creation!public! !

