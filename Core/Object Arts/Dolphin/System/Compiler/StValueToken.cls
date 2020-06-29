"Filed out from Dolphin Smalltalk 7"!

StToken subclass: #StValueToken
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!StValueToken categoriesFor: #length!accessing!private! !
!StValueToken categoriesFor: #printOn:!printing!public! !
!StValueToken categoriesFor: #value!accessing!public! !
!StValueToken categoriesFor: #value:!initializing!private! !

!StValueToken class methodsFor!

start: anInteger comments: aCollectionOrNil value: aString
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		value: aString;
		yourself! !
!StValueToken class categoriesFor: #start:comments:value:!instance creation!public! !

