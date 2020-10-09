"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'STON.Tests.STONTestCase'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.STONTestCase guid: (Core.GUID fromString: '{9a0043c8-db65-4c88-8bc2-e780669c6e17}')!
STON.Tests.STONTestCase isNonInstantiable: true!
STON.Tests.STONTestCase comment: ''!
!STON.Tests.STONTestCase categoriesForClass!SUnit! !
!STON.Tests.STONTestCase methodsFor!

materialize: string
	^STON reader
		on: string readStream;
		next!

serialize: anObject
	^String streamContents: 
			[:stream |
			(Processor activeProcess debugger ifNotNil: [STON prettyPrinter] ifNil: [STON writer])
				on: stream;
				nextPut: anObject]! !
!STON.Tests.STONTestCase categoriesFor: #materialize:!private! !
!STON.Tests.STONTestCase categoriesFor: #serialize:!private! !

