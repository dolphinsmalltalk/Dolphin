"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #TextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TextEditTest guid: (GUID fromString: '{5237b507-a634-4555-81af-e15822492437}')!
TextEditTest comment: ''!
!TextEditTest categoriesForClass!Unclassified! !
!TextEditTest methodsFor!

classToTest
	^TextEdit!

margins
	^1 @ 0!

nonProportionalFont
	^Font name: 'Courier'!

testPositionOfChar
	"Use a non-proportional font to avoid variability introduced by kerning, especially of punctuation."

	| text canvas lineHeight metrics i |
	presenter view font: self nonProportionalFont.
	text := self text.
	canvas := presenter view canvas.
	canvas font: presenter view actualFont.
	metrics := canvas textMetrics.
	lineHeight := metrics tmHeight.
	presenter text: text.
	i := 0.
	text readStream do: 
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
					extent := canvas textExtent: (lineText readStream next: i - startOfLine).
					point := extent x @ ((line - 1) * lineHeight) + self margins.
					pos := presenter view positionOfChar: i.
					self assert: pos equals: point]].
	canvas free!

text
	^'The quick brown fox jumped over the lazy dog'! !
!TextEditTest categoriesFor: #classToTest!helpers!private! !
!TextEditTest categoriesFor: #margins!private!unit tests! !
!TextEditTest categoriesFor: #nonProportionalFont!constants!private! !
!TextEditTest categoriesFor: #testPositionOfChar!public!unit tests! !
!TextEditTest categoriesFor: #text!constants!private! !

