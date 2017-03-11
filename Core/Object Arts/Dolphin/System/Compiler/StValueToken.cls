"Filed out from Dolphin Smalltalk 7"!

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
	aStream nextPut: $(.
	value printOn: aStream.
	aStream nextPutAll: ')'!

value
	^value!

value: anObject
	value := anObject! !
!StValueToken categoriesFor: #length!accessing!private! !
!StValueToken categoriesFor: #printOn:!printing!public! !
!StValueToken categoriesFor: #value!accessing!public! !
!StValueToken categoriesFor: #value:!accessing!public! !

!StValueToken class methodsFor!

value: aString start: anInteger
	^(self start: anInteger) value: aString! !
!StValueToken class categoriesFor: #value:start:!instance creation!public! !

