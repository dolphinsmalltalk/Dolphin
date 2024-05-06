"Filed out from Dolphin Smalltalk"!

StToken subclass: #StValueToken
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StValueToken guid: (GUID fromString: '{c37072cc-edda-4bac-aa9f-a73b3f4255d5}')!

StValueToken comment: ''!

!StValueToken categoriesForClass!System-Compiler! !

!StValueToken methodsFor!

length
	^value size!

printOn: aStream
	super printOn: aStream.
	aStream
		nextPut: $(;
		print: value;
		nextPut: $)!

value
	^value!

value: anObject
	value := anObject! !

!StValueToken categoriesForMethods!
length!accessing!private! !
printOn:!printing!public! !
value!accessing!public! !
value:!initializing!private! !
!

!StValueToken class methodsFor!

start: anInteger comments: aCollectionOrNil value: aString
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		value: aString;
		yourself! !

!StValueToken class categoriesForMethods!
start:comments:value:!instance creation!public! !
!

