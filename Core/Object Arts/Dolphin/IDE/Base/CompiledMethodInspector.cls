"Filed out from Dolphin Smalltalk X6"!

BasicInspector subclass: #CompiledMethodInspector
	instanceVariableNames: ''
	classVariableNames: 'MethodTypes'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CompiledMethodInspector guid: (GUID fromString: '{87B4C691-026E-11D3-9FD7-00A0CC3E4A32}')!
CompiledMethodInspector comment: 'CompiledMethodInspector is a <compositePresenter> that implements a specialised inspect facility onto a <CompiledMethod>. This provides additional functionality to view the source, and the decompiled bytecodes.'!
!CompiledMethodInspector categoriesForClass!Development!MVP-Presenters! !
!CompiledMethodInspector methodsFor!

disassemblyText
	"Private - Answer a text decoding of the receivers byte codes."

	^self selfField disassembly!

source
	"Answer the text source of the receiver."

	^self selfField getSource!

sourceText
	"Private - Answer the text source of the receiver."

	^self selfField getSource!

text
	"Private - Answer the text to be displayed for the selected field."

	| field index |
	field := self variable.
	index := self variableIndex.
	^(index between: 2 and: self headerSize)
		ifTrue: [ field ]
		ifFalse: [ field printString ]! !
!CompiledMethodInspector categoriesFor: #disassemblyText!accessing!private! !
!CompiledMethodInspector categoriesFor: #source!accessing!public! !
!CompiledMethodInspector categoriesFor: #sourceText!accessing!private! !
!CompiledMethodInspector categoriesFor: #text!accessing!private! !

!CompiledMethodInspector class methodsFor!

headerList
	"Answer an OrderedCollection of associations between prefix attributes and selectors
	to be sent to instances of the receiver to access those attributes."

	^##(self superclass headerList, 
			(OrderedCollection
					with: ' - source' -> #sourceText
					with: ' - disassembly' -> #disassemblyText))!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	MethodTypes := #(
		'Normal'
		'Return nil'
		'Return true'
		'Return false'
		'Return literal constant 0'
		'Return self'
		'Return instance variable'
		'Set instance variable').
! !
!CompiledMethodInspector class categoriesFor: #headerList!constants!public! !
!CompiledMethodInspector class categoriesFor: #initialize!initializing!private! !

