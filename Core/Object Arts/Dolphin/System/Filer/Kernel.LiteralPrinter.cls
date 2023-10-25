"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Kernel.LiteralPrinter'
	instanceVariableNames: 'stream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.LiteralPrinter guid: (Core.GUID fromString: '{dc229cbf-5d44-4ec5-be15-cce8b14f1855}')!
Kernel.LiteralPrinter comment: ''!
!Kernel.LiteralPrinter categoriesForClass!Kernel-Objects! !
!Kernel.LiteralPrinter methodsFor!

nameForClass: aClass
	^aClass fullName!

nextPut: aCharacter
	Notification deprecated. "For backwards compatibility with old definitions of literalPrintOn:"
	stream nextPut: aCharacter!

nextPutAll: aString
	Notification deprecated. "For backwards compatibility with old definitions of literalPrintOn:"
	stream nextPutAll: aString!

print: aLiteralObject
	aLiteralObject printOn: stream!

printArray: anArray
	stream nextPutAll: '#('.
	anArray do: [:each | each literalPrintOn: self] separatedBy: [stream space].
	stream nextPut: $)!

printCharacter: aCharacter
	aCharacter printOn: stream!

printClass: aClass
	stream
		nextPutAll: '##(';
		nextPutAll: (self nameForClass: aClass);
		nextPut: $)!

printLiteralStoreArray: anArray
	self printArray: anArray!

printMetaclass: aMetaclass
	self printClass: aMetaclass!

printProcessor: aProcessor
	stream nextPutAll: '##(Core.Processor)'!

printString: aString
	aString printOn: stream!

space
	Notification deprecated. "For backwards compatibility with old definitions of literalPrintOn:"
	stream space!

stream
	^stream!

stream: aPuttableStream
	stream := aPuttableStream! !
!Kernel.LiteralPrinter categoriesForMethods!
nameForClass:!printing!private! !
nextPut:!public!streaming! !
nextPutAll:!public!streaming! !
print:!printing!public! !
printArray:!printing!public! !
printCharacter:!printing!public! !
printClass:!printing!public! !
printLiteralStoreArray:!public! !
printMetaclass:!printing!public! !
printProcessor:!printing!public! !
printString:!printing!public! !
space!public!streaming! !
stream!accessing!public! !
stream:!accessing!private! !
!

!Kernel.LiteralPrinter class methodsFor!

on: aPuttableStream
	<primitive: 157>
	^self new
		stream: aPuttableStream;
		yourself!

print: aLiteralObject
	| stream |
	stream := String writeStream.
	aLiteralObject literalPrintOn: (self on: stream).
	^stream contents! !
!Kernel.LiteralPrinter class categoriesForMethods!
on:!instance creation!public! !
print:!public!utilities! !
!

