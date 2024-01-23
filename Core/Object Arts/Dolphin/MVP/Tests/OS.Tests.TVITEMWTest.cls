"Filed out from Dolphin Smalltalk"!

OS.Tests.CCITEMTest
	subclass: #'OS.Tests.TVITEMWTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.TreeViewConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.TVITEMWTest guid: (Core.GUID fromString: '{020cb0ac-9d92-4889-9952-baacee5b0f37}')!
OS.Tests.TVITEMWTest comment: ''!
!OS.Tests.TVITEMWTest methodsFor!

subjectClass
	^TVITEMW!

testInstanceCreation
	| subject |
	subject := self subjectClass hItem: 1234.
	self assert: subject hItem equals: 1234.
	self assert: subject printString equals: 'a <1p>(mask=0 hItem=1234)' << self subjectClass.
	subject := self subjectClass callbacksForItem: 1234.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> hItem=1234 iImage=-1 cChildren=-1)'
				<< { self subjectClass. TVIF_CHILDREN | TVIF_IMAGE | TVIF_TEXT }! !
!OS.Tests.TVITEMWTest categoriesForMethods!
subjectClass!constants!public! !
testInstanceCreation!constants!public! !
!

