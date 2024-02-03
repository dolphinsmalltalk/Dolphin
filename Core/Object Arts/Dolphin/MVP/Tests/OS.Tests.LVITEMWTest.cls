"Filed out from Dolphin Smalltalk"!

OS.Tests.CCITEMTest
	subclass: #'OS.Tests.LVITEMWTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.LVITEMWTest guid: (Core.GUID fromString: '{fde465af-bcb1-4b30-9a93-3937f7842dc8}')!
OS.Tests.LVITEMWTest comment: ''!
!OS.Tests.LVITEMWTest methodsFor!

subjectClass
	^LVITEMW!

testInstanceCreation
	| subject |
	subject := self subjectClass callbacksForIndex: 1234.
	self assert: subject iItem equals: 1234.
	self assert: subject handle equals: 1235.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=1234 iImage=-1)' << { self subjectClass. LVIF_TEXT | LVIF_IMAGE }.
	self assert: subject iSubItem equals: 0.
	subject column: 3.
	self assert: subject iSubItem equals: 2.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=1234 iSubItem=2 iImage=-1)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE }.
	self assert: subject iIndent equals: 0.
	subject indent: 2.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=1234 iSubItem=2 iImage=-1 iIndent=2)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE | LVIF_INDENT }.
	subject stateImageIndex: 123.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=1234 iSubItem=2 iImage=-1 iIndent=2 iStateImage=123)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE | LVIF_INDENT | LVIF_STATE }!

testInstanceCreation2
	| subject |
	subject := self subjectClass new.
	self assert: subject printString equals: 'a <1p>(mask=<2p> iItem=0)' << { self subjectClass. 0 }.
	subject
		row: 15
		text: 'Foo'
		imageIndex: nil
		indent: 0.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=14 text=''Foo'' iImage=<3p>)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE. I_IMAGENONE }.
	subject
		row: 16
		text: 'bar'
		imageIndex: 123
		indent: 0.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=15 text=''bar'' iImage=122)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE }.
	subject
		row: 17
		text: 'Foobar'
		imageIndex: 124
		indent: -1.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=16 text=''Foobar'' iImage=<3p> iIndent=-1)'
				<< { self subjectClass. LVIF_TEXT | LVIF_IMAGE | LVIF_INDENT. I_IMAGENONE }.
	subject
		row: 18
		text: 'Foo bar'
		imageIndex: nil
		indent: 2.
	self assert: subject printString
		equals: 'a <1p>(mask=<2p> iItem=17 text=''Foo bar'' iImage=<3p> iIndent=2)'
				<< { self subjectClass. LVIF_TEXT | LVIF_INDENT | LVIF_IMAGE. I_IMAGENONE }! !
!OS.Tests.LVITEMWTest categoriesForMethods!
subjectClass!constants!public! !
testInstanceCreation!constants!public! !
testInstanceCreation2!constants!public! !
!

