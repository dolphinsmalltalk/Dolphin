"Filed out from Dolphin Smalltalk 7"!

StValueToken subclass: #StLiteralToken
	instanceVariableNames: 'stopPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

stop
	^stopPosition!

stop: anInteger
	stopPosition := anInteger!

valueClass
	^self value basicClass! !
!StLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!StLiteralToken categoriesFor: #formatOn:source:!printing!public! !
!StLiteralToken categoriesFor: #formattedFrom:!printing!public! !
!StLiteralToken categoriesFor: #isLiteralToken!public!testing! !
!StLiteralToken categoriesFor: #isMultiKeyword!public!testing! !
!StLiteralToken categoriesFor: #length!accessing!private! !
!StLiteralToken categoriesFor: #realValue!accessing!public! !
!StLiteralToken categoriesFor: #stop!accessing!public! !
!StLiteralToken categoriesFor: #stop:!initializing!private! !
!StLiteralToken categoriesFor: #valueClass!accessing!public! !

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
!StLiteralToken class categoriesFor: #start:comments:value:stop:!instance creation!public! !
!StLiteralToken class categoriesFor: #value:!instance creation!public! !

