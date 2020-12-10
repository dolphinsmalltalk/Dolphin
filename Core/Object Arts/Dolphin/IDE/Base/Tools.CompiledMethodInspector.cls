"Filed out from Dolphin Smalltalk 7"!

Tools.BasicInspector subclass: #'Tools.CompiledMethodInspector'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'MethodTypes' -> #('Normal' 'Return nil' 'Return true' 'Return false' 'Return literal constant 0' 'Return self' 'Return instance variable' 'Set instance variable')
	}!
Tools.CompiledMethodInspector guid: (Core.GUID fromString: '{87b4c691-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.CompiledMethodInspector comment: 'CompiledMethodInspector is a <compositePresenter> that implements a specialised inspect facility onto a <CompiledMethod>. This provides additional functionality to view the source, and the decompiled bytecodes.'!
!Tools.CompiledMethodInspector categoriesForClass!MVP-Presenters! !
!Tools.CompiledMethodInspector methodsFor!

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
!Tools.CompiledMethodInspector categoriesFor: #disassemblyText!accessing!private! !
!Tools.CompiledMethodInspector categoriesFor: #source!accessing!public! !
!Tools.CompiledMethodInspector categoriesFor: #sourceText!accessing!private! !
!Tools.CompiledMethodInspector categoriesFor: #text!accessing!private! !

!Tools.CompiledMethodInspector class methodsFor!

headerList
	"Answer an OrderedCollection of associations between prefix attributes and selectors
	to be sent to instances of the receiver to access those attributes."

	^##(self superclass headerList, 
			(OrderedCollection
					with: ' - source' -> #sourceText
					with: ' - disassembly' -> #disassemblyText))! !
!Tools.CompiledMethodInspector class categoriesFor: #headerList!constants!public! !

