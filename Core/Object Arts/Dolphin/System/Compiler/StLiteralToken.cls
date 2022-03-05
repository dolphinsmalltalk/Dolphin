"Filed out from Dolphin Smalltalk"!

StValueToken subclass: #StLiteralToken
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StLiteralToken guid: (GUID fromString: '{85fe993e-366b-4f11-9b9c-e5ac73674129}')!
StLiteralToken comment: ''!
!StLiteralToken categoriesForClass!System-Compiler! !
!StLiteralToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitLiteralToken: self!

formatOn: aStream source: aString 
	(value isKindOf: Symbol) 
		ifTrue: 
			[aStream nextPut: $#.
			((SmalltalkScanner isSelector: value) and: [value ~~ #'||']) 
				ifTrue: [aStream nextPutAll: value]
				ifFalse: [value asString printOn: aStream].
			^self].
	value storeOn: aStream!

formattedFrom: aString
	| stream |
	stream := String writeStream: 32.
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

sourceInterval
	"Answer an <Interval> that specifies the range of source positions occuppied by the receiver."

	^self start to: stopPosition!

stop
	^stopPosition!

stop: anInteger
	stopPosition := anInteger!

valueClass
	^self value basicClass! !
!StLiteralToken categoriesForMethods!
acceptVisitor:!public!visitor! !
formatOn:source:!printing!public! !
formattedFrom:!printing!public! !
isLiteralToken!public!testing! !
isMultiKeyword!public!testing! !
length!accessing!private! !
realValue!accessing!public! !
sourceInterval!accessing!public! !
stop!accessing!public! !
stop:!initializing!private! !
valueClass!accessing!public! !
!

!StLiteralToken class methodsFor!

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
!StLiteralToken class categoriesForMethods!
start:comments:value:stop:!instance creation!public! !
value:!instance creation!public! !
!

