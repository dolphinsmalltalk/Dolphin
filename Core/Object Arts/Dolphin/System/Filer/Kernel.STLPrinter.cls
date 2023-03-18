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

