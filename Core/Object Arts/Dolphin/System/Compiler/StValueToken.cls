"Filed out from Dolphin Smalltalk X6"!

StToken subclass: #StValueToken
	instanceVariableNames: 'value'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StValueToken guid: (GUID fromString: '{C37072CC-EDDA-4BAC-AA9F-A73B3F4255D5}')!
StValueToken comment: ''!
!StValueToken categoriesForClass!System-Compiler! !
!StValueToken methodsFor!

length
	^value size!

printOn: aStream
	super printOn: aStream.
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPutAll: ')'!

value
	^value!

value: anObject
	value := anObject!

value: aString start: anInteger 
	value := aString.
	sourcePointer := anInteger! !
!StValueToken categoriesFor: #length!accessing!private! !
!StValueToken categoriesFor: #printOn:!printing!public! !
!StValueToken categoriesFor: #value!accessing!public! !
!StValueToken categoriesFor: #value:!accessing!public! !
!StValueToken categoriesFor: #value:start:!initializing!public! !

!StValueToken class methodsFor!

value: aString start: anInteger 
	^self new value: aString start: anInteger! !
!StValueToken class categoriesFor: #value:start:!instance creation!public! !

