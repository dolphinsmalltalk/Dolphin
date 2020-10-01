"Filed out from Dolphin Smalltalk 7"!

UI.Tests.PresenterTest subclass: #'UI.Tests.AbstractTextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.AbstractTextEditTest guid: (Core.GUID fromString: '{3f7e7558-eb69-4b84-a91f-de5dba0c2d10}')!
UI.Tests.AbstractTextEditTest isNonInstantiable: true!
UI.Tests.AbstractTextEditTest comment: ''!
!UI.Tests.AbstractTextEditTest categoriesForClass!Unclassified! !
!UI.Tests.AbstractTextEditTest methodsFor!

margins
	^self subclassResponsibility!

nonProportionalFont
	^Font name: 'Courier'!

testPositionOfChar
	| text canvas lineHeight metrics i |
	text := self text.
	"Use a non-proportional font to avoid variability introduced by kerning, especially of punctuation."
	presenter view font: self nonProportionalFont.
	canvas := presenter view canvas.
	canvas font: presenter view actualFont.
	metrics := canvas textMetrics.
	lineHeight := metrics tmHeight.
	presenter text: text.
	i := 0.
	text do: 
			[:ch |
			| line lineText startOfLine point extent |
			i := i + 1.
			line := presenter view lineFromPosition: i.
			lineText := presenter view plainTextAtLine: line.
			startOfLine := presenter view positionAtLine: line.
			i - startOfLine > lineText size
				ifTrue: [self assert: (String lineDelimiter includes: ch)]
				ifFalse: 
					[| pos |
					extent := canvas textExtent: (lineText first: i - startOfLine).
					point := extent x @ ((line - 1) * lineHeight) + self margins.
					pos := presenter view positionOfChar: i.
					self assert: pos equals: point]].
	canvas free!

text
	^self subclassResponsibility! !
!UI.Tests.AbstractTextEditTest categoriesFor: #margins!constants!private! !
!UI.Tests.AbstractTextEditTest categoriesFor: #nonProportionalFont!constants!private! !
!UI.Tests.AbstractTextEditTest categoriesFor: #testPositionOfChar!public!unit tests! !
!UI.Tests.AbstractTextEditTest categoriesFor: #text!constants!private! !

