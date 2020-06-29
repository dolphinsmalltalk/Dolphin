"Filed out from Dolphin Smalltalk 7"!

StLiteralToken subclass: #StNumberLiteralToken
	instanceVariableNames: 'source'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
StNumberLiteralToken guid: (GUID fromString: '{777f55ae-a939-4a73-9cc8-2cef3a91f41e}')!
StNumberLiteralToken comment: ''!
!StNumberLiteralToken categoriesForClass!Unclassified! !
!StNumberLiteralToken methodsFor!

acceptVisitor: aTokenVisitor
	^aTokenVisitor visitNumberLiteralToken: self!

forgetNegative
	value := value negated.
	source := source copyFrom: 2.
	start := start + 1!

formatOn: aStream source: aString
	"For numbers, we attempt to retain the original source form as unless it is a plain integer
	it may have been deliberately expressed in a particular format by the user."

	source ifNil: [self value printOn: aStream] ifNotNil: [aStream nextPutAll: source]!

isNegative
	^self value negative!

isNumberLiteralToken
	^true!

printOn: aStream
	aStream
		space;
		nextPutAll: self class name;
		nextPut: $(.
	self formatOn: aStream source: nil.
	aStream nextPut: $)!

source
	"Answer the original source code for the number."

	^source!

source: aString 
	source := aString! !
!StNumberLiteralToken categoriesFor: #acceptVisitor:!public!visitor! !
!StNumberLiteralToken categoriesFor: #forgetNegative!helpers!private! !
!StNumberLiteralToken categoriesFor: #formatOn:source:!printing!public! !
!StNumberLiteralToken categoriesFor: #isNegative!public!testing! !
!StNumberLiteralToken categoriesFor: #isNumberLiteralToken!public!testing! !
!StNumberLiteralToken categoriesFor: #printOn:!public! !
!StNumberLiteralToken categoriesFor: #source!accessing!public! !
!StNumberLiteralToken categoriesFor: #source:!initializing!private! !

!StNumberLiteralToken class methodsFor!

start: startInteger comments: aCollectionOrNil value: aString stop: stopInteger source: sourceString
	<primitive: 157>
	^self new
		start: startInteger;
		comments: aCollectionOrNil;
		value: aString;
		stop: stopInteger;
		source: sourceString;
		yourself! !
!StNumberLiteralToken class categoriesFor: #start:comments:value:stop:source:!public! !

