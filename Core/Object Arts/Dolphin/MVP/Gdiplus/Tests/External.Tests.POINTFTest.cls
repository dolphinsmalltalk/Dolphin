"Filed out from Dolphin Smalltalk"!

External.Tests.POINTTest subclass: #'External.Tests.POINTFTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Tests.POINTFTest guid: (Core.GUID fromString: '{f101ec1a-93fa-4bb8-8718-e576364d0532}')!
External.Tests.POINTFTest comment: ''!
!External.Tests.POINTFTest methodsFor!

subjectClass
	^POINTF!

subjectSupportNonIntegralValues
	^true!

testAsDword
	self
		should: [super testAsDword]
		raise: Error
		matching: [:ex | ex description = (self subjectClass printString , ' should not implement #asDword')]! !
!Graphics.Gdiplus.Tests.POINTFTest categoriesForMethods!
subjectClass!constants!private! !
subjectSupportNonIntegralValues!private!testing! !
testAsDword!public!unit tests! !
!

