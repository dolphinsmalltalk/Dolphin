"Filed out from Dolphin Smalltalk"!

Kernel.StToken
	subclass: #'Kernel.StValueToken'
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
!Kernel.StValueToken categoriesForMethods!
length!accessing!private! !
printOn:!printing!public! !
value!accessing!public! !
value:!initializing!private! !
!

!Kernel.StValueToken class methodsFor!

start: anInteger comments: aCollectionOrNil value: aString
	<primitive: 157>
	^self new
		start: anInteger;
		comments: aCollectionOrNil;
		value: aString;
		yourself! !
!Kernel.StValueToken class categoriesForMethods!
start:comments:value:!instance creation!public! !
!

