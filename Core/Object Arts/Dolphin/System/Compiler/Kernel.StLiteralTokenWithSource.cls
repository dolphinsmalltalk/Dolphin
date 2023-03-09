"Filed out from Dolphin Smalltalk"!

Kernel.StLiteralToken
	subclass: #'Kernel.StLiteralTokenWithSource'
	instanceVariableNames: 'source'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.StLiteralTokenWithSource guid: (Core.GUID fromString: '{6e8336e5-0558-42fa-9b79-f818fd4c46bf}')!
Kernel.StLiteralTokenWithSource isNonInstantiable: true!
Kernel.StLiteralTokenWithSource comment: ''!
!Kernel.StLiteralTokenWithSource methodsFor!

formatOn: aStream source: aString
	"For numbers, we attempt to retain the original source form as unless it is a plain integer
	it may have been deliberately expressed in a particular format by the user."

	source ifNil: [self value printOn: aStream] ifNotNil: [aStream nextPutAll: source]!

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
!Kernel.StLiteralTokenWithSource categoriesForMethods!
formatOn:source:!printing!public! !
printOn:!public! !
source!accessing!public! !
source:!initializing!private! !
!

!Kernel.StLiteralTokenWithSource class methodsFor!

start: startInteger comments: aCollectionOrNil value: aString stop: stopInteger source: sourceString
	<primitive: 157>
	^self new
		start: startInteger;
		comments: aCollectionOrNil;
		value: aString;
		stop: stopInteger;
		source: sourceString;
		yourself! !
!Kernel.StLiteralTokenWithSource class categoriesForMethods!
start:comments:value:stop:source:!public! !
!

