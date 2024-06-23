"Filed out from Dolphin Smalltalk"!

Kernel.StValueToken
	subclass: #'Kernel.StLiteralToken'
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

!Kernel.StLiteralToken categoriesForMethods!
acceptVisitor:!public!visitor! !
formatOn:source:!printing!public! !
formattedFrom:!printing!public! !
isLiteralToken!public!testing! !
isMultiKeyword!public!testing! !
length!accessing!private! !
realValue!accessing!public! !
stop!accessing!public! !
stop:!initializing!private! !
valueClass!accessing!public! !
!

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

!Kernel.StLiteralToken class categoriesForMethods!
start:comments:value:stop:!instance creation!public! !
value:!instance creation!public! !
!

