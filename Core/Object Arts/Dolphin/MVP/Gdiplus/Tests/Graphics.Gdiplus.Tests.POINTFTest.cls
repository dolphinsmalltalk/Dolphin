"Filed out from Dolphin Smalltalk 7"!

External.Tests.POINTTest subclass: #'Graphics.Gdiplus.Tests.POINTFTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.POINTFTest guid: (Core.GUID fromString: '{f101ec1a-93fa-4bb8-8718-e576364d0532}')!
Graphics.Gdiplus.Tests.POINTFTest comment: ''!
!Graphics.Gdiplus.Tests.POINTFTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.POINTFTest methodsFor!

subjectClass
	^POINTF!

testAsDword
	self
		should: [super testAsDword]
		raise: Error
		matching: [:ex | ex description equals: self subjectClass fullName , ' should not implement #asDword']! !
!Graphics.Gdiplus.Tests.POINTFTest categoriesFor: #subjectClass!constants!private! !
!Graphics.Gdiplus.Tests.POINTFTest categoriesFor: #testAsDword!public!unit tests! !

