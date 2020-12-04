"Filed out from Dolphin Smalltalk 7"!

Kernel.StToken subclass: #'Kernel.StValueToken'
	instanceVariableNames: 'value'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StValueToken guid: (Core.GUID fromString: '{c37072cc-edda-4bac-aa9f-a73b3f4255d5}')!
Kernel.StValueToken comment: ''!
!Kernel.StValueToken categoriesForClass!System-Compiler! !
!Kernel.StValueToken methodsFor!

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
!Kernel.StValueToken categoriesFor: #length!accessing!private! !
!Kernel.StValueToken categoriesFor: #printOn:!printing!public! !
!Kernel.StValueToken categoriesFor: #value!accessing!public! !
!Kernel.StValueToken categoriesFor: #value:!initializing!private! !

!Kernel.StValueToken class methodsFor!

start: anInteger comments: aCollectionOrNil value: aString
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		value: aString;
		yourself! !
!Kernel.StValueToken class categoriesFor: #start:comments:value:!instance creation!public! !

