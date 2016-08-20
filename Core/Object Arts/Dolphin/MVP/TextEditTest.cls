"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #TextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TextEditTest guid: (GUID fromString: '{5237B507-A634-4555-81AF-E15822492437}')!
TextEditTest comment: ''!
!TextEditTest categoriesForClass!Unclassified! !
!TextEditTest methodsFor!

classToTest
	^TextEdit!

dtestPositionOfChar
	"Use a non-proportional font to avoid variability introduced by kerning, especially of punctuation."

	| text canvas leading lineHeight metrics |
	presenter view font: Font system.
	text := self text.
	canvas := presenter view canvas.
	canvas font: presenter view actualFont.
	metrics := canvas textMetrics.
	leading := metrics tmExternalLeading.
	lineHeight := metrics tmHeight.	"+ metrics tmInternalLeading"
	presenter text: text.
	1 to: text size
		do: 
			[:i | 
			| line lineText startOfLine point extent |
			line := presenter view lineFromPosition: i.
			lineText := presenter view plainTextAtLine: line.
			startOfLine := presenter view positionAtLine: line.
			i - startOfLine > lineText size 
				ifTrue: [self assert: (String lineDelimiter includes: (text at: i))]
				ifFalse: 
					[| pos |
					extent := canvas textExtent: (lineText copyFrom: 1 to: i - startOfLine).
					point := extent x @ ((line - 1) * lineHeight) + self margins.
					pos := presenter view positionOfChar: i.
					self assert: pos = point]].
	canvas free!

margins
	^1 @ 0!

testPositionOfChar
	"Use a non-proportional font to avoid variability introduced by kerning, especially of punctuation."
	| text canvas leading lineHeight metrics |
	presenter view font: (Font name: 'Courier').
	text := self text.
	canvas := presenter view canvas.
	canvas font: presenter view actualFont.
	metrics := canvas textMetrics.
	leading := metrics tmExternalLeading.
	lineHeight := metrics tmHeight.	"+ metrics tmInternalLeading"
	presenter text: text.
	1 to: text size
		do: 
			[:i | 
			| line lineText startOfLine point extent |
			line := presenter view lineFromPosition: i.
			lineText := presenter view plainTextAtLine: line.
			startOfLine := presenter view positionAtLine: line.
			i - startOfLine > lineText size 
				ifTrue: [self assert: (String lineDelimiter includes: (text at: i))]
				ifFalse: 
					[| pos |
					extent := canvas textExtent: (lineText copyFrom: 1 to: i - startOfLine).
					point := extent x @ ((line - 1) * lineHeight) + self margins.
					pos := presenter view positionOfChar: i.
					self assert: pos = point]].
	canvas free!

text
	^'The quick brown fox jumped over the lazy dog'! !
!TextEditTest categoriesFor: #classToTest!helpers!private! !
!TextEditTest categoriesFor: #dtestPositionOfChar!public!unit tests! !
!TextEditTest categoriesFor: #margins!private!unit tests! !
!TextEditTest categoriesFor: #testPositionOfChar!public!unit tests! !
!TextEditTest categoriesFor: #text!constants!private! !

