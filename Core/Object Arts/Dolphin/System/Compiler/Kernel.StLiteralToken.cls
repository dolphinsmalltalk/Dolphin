"Filed out from Dolphin Smalltalk 7"!

Kernel.StValueToken subclass: #'Kernel.StLiteralToken'
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralToken guid: (Core.GUID fromString: '{85fe993e-366b-4f11-9b9c-e5ac73674129}')!
Kernel.StLiteralToken comment: ''!
!Kernel.StLiteralToken categoriesForClass!System-Compiler! !
!Kernel.StLiteralToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitLiteralToken: self!

formatOn: aStream source: aString
	(value isKindOf: Symbol)
		ifTrue: 
			[aStream nextPut: $#.
			((Scanner isSelector: value) and: [value ~~ #'||'])
				ifTrue: [aStream nextPutAll: value]
				ifFalse: [value asString printOn: aStream].
			^self].
	value storeOn: aStream!

formattedFrom: aString
	| stream |
	stream := String smalltalkWriteStream: 32.
	self formatOn: stream source: aString.
	^stream contents!

isLiteralToken
	^true!

isMultiKeyword
	^false!

length
	^stopPosition - self start + 1!

realValue
	^value!

stop
	^stopPosition!

stop: anInteger
	stopPosition := anInteger!

valueClass
	^self value basicClass! !
!Kernel.StLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!Kernel.StLiteralToken categoriesFor: #formatOn:source:!printing!public! !
!Kernel.StLiteralToken categoriesFor: #formattedFrom:!printing!public! !
!Kernel.StLiteralToken categoriesFor: #isLiteralToken!public!testing! !
!Kernel.StLiteralToken categoriesFor: #isMultiKeyword!public!testing! !
!Kernel.StLiteralToken categoriesFor: #length!accessing!private! !
!Kernel.StLiteralToken categoriesFor: #realValue!accessing!public! !
!Kernel.StLiteralToken categoriesFor: #stop!accessing!public! !
!Kernel.StLiteralToken categoriesFor: #stop:!initializing!private! !
!Kernel.StLiteralToken categoriesFor: #valueClass!accessing!public! !

!Kernel.StLiteralToken class methodsFor!

start: startInteger comments: aCollectionOrNil value: aString stop: stopInteger
	<primitive: 157>
	^self new
		start: startInteger;
		comments: aCollectionOrNil;
		value: aString;
		stop: stopInteger;
		yourself
!

value: anObject
	| literal |
	literal := anObject class == Array
				ifTrue: [anObject collect: [:each | self value: each]]
				ifFalse: [anObject].
	^self
		start: nil
		comments: nil
		value: literal
		stop: nil! !
!Kernel.StLiteralToken class categoriesFor: #start:comments:value:stop:!instance creation!public! !
!Kernel.StLiteralToken class categoriesFor: #value:!instance creation!public! !

