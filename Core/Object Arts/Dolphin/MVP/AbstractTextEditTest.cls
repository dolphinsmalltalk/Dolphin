"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #AbstractTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractTextEditTest guid: (GUID fromString: '{823252e0-79ac-489c-ac11-ca4151d3e1c3}')!

AbstractTextEditTest isAbstract: true!

AbstractTextEditTest comment: ''!

!AbstractTextEditTest categoriesForClass!Unclassified! !

!AbstractTextEditTest methodsFor!

margins
	^self subclassResponsibility!

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
	^self subclassResponsibility! !

!AbstractTextEditTest categoriesForMethods!
margins!private!unit tests! !
testPositionOfChar!public!unit tests! !
text!constants!private! !
!

