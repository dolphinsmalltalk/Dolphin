"Filed out from Dolphin Smalltalk"!

Kernel.LiteralPrinter
	subclass: #'Kernel.STLPrinter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLPrinter guid: (Core.GUID fromString: '{c6563849-af3f-422b-b15f-1aba064e1b99}')!
Kernel.STLPrinter comment: ''!
!Kernel.STLPrinter categoriesForClass!Kernel-Objects! !
!Kernel.STLPrinter methodsFor!

printClass: aClass
	aClass fullyQualifiedReference printOn: stream!

printProcessor: aProcessor
	stream nextPutAll: '#{Core.Processor}'! !
!Kernel.STLPrinter categoriesForMethods!
printClass:!printing!public! !
printProcessor:!printing!public! !
!

!Kernel.STLPrinter class methodsFor!

printLiteralStoreArray: aLiteralStoreArray
	| stream |
	stream := String writeStream.
	self printLiteralStoreArray: aLiteralStoreArray on: stream.
	^stream contents!

printLiteralStoreArray: aLiteralStoreArray on: aPuttableStream
	((STLVersionPolicy forVersion: (aLiteralStoreArray at: 2)) literalPrinterClass
		on: aPuttableStream) printArray: aLiteralStoreArray! !
!Kernel.STLPrinter class categoriesForMethods!
printLiteralStoreArray:!instance creation!public! !
printLiteralStoreArray:on:!instance creation!public! !
!

