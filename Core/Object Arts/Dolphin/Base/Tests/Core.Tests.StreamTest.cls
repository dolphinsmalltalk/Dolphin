"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.StreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.StreamTest guid: (Core.GUID fromString: '{f1611eb3-2c1c-491e-a814-c62dcdce0fff}')!
Core.Tests.StreamTest isNonInstantiable: true!
Core.Tests.StreamTest comment: ''!
!Core.Tests.StreamTest methodsFor!

closeTempStream: aStream
	"Private - Clean up the temporary stream argument."!

streamClass
	^self subclassResponsibility!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self streamClass on: aString! !
!Core.Tests.StreamTest categoriesForMethods!
closeTempStream:!helpers!private! !
streamClass!helpers!private! !
streamOn:!helpers!private! !
!

