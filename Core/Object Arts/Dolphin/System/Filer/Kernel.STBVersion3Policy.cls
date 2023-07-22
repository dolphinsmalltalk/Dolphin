"Filed out from Dolphin Smalltalk"!

Kernel.STBVersion1Policy
	subclass: #'Kernel.STBVersion3Policy'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STBVersion3Policy guid: (Core.GUID fromString: '{0d80f5bc-67f6-4a70-a725-178fb91a9577}')!
Kernel.STBVersion3Policy comment: ''!
!Kernel.STBVersion3Policy methodsFor!

readObjectSize: aClass from: aPositionableStream
	"As of STB version 3, the out-filer only writes the object size for indexable objects."

	^aClass isVariable ifTrue: [aPositionableStream nextInt32] ifFalse: [0]! !
!Kernel.STBVersion3Policy categoriesForMethods!
readObjectSize:from:!public! !
!

