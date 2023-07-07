"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.Tests.MockScintillaView'
	instanceVariableNames: 'lastStyled tokens text currentTextStyles styleIdMap messages'
	classVariableNames: ''
	imports: #(#{UI.Scintilla private})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.Tests.MockScintillaView guid: (Core.GUID fromString: '{50616a84-12e3-4960-b005-82a37278383b}')!
UI.Scintilla.Tests.MockScintillaView comment: 'To set up:

	mock := MockScintillaView new.
	mock textStyles: SmalltalkWorkspace defaultTextStyles

Then to style:

	styler := SmalltalkMethodStyler new.
	text := (Object>>#printString) getSource.
	mock text: text.
	styler 
		colorTextFrom: 1
		to: text size
		in: mock.
	"Now can access the ''tokens''"
	mock tokens'!
!UI.Scintilla.Tests.MockScintillaView categoriesForClass!Kernel-Objects! !
!UI.Scintilla.Tests.MockScintillaView methodsFor!

applyStyle: aSymbol toNext: anInteger 
	self styleNext: anInteger mask: ((self styleNamed: aSymbol) ifNil: [0] ifNotNil: [:style | style id])!

characterAt: anInteger 
	^text at: anInteger!

maxStyle
	^31!

messages
	^messages!

plainTextFrom: startInteger to: stopInteger 
	^text copyFrom: startInteger to: stopInteger!

plainTextRange: anInterval
	^self plainTextFrom: anInterval start to: anInterval stop!

resetMessages
	messages := OrderedCollection new!

sendMessage: anIntegerMessageID wParam: wParam lParam: lParam
	^messages addLast: { anIntegerMessageID. wParam. lParam }!

setCurrentTextStyles: aCollection
	| newStylesByName allocatedStyles newStylesById availableStyles count |
	count := aCollection size.
	allocatedStyles := OrderedCollection new: count.
	aCollection do: [:each | each basicId ifNotNil: [:id | allocatedStyles add: id]].
	availableStyles := ((1 to: STYLE_DEFAULT - 1) , (STYLE_LASTPREDEFINED + 1 to: self maxStyle)
				difference: allocatedStyles) readStream.
	newStylesByName := IdentityDictionary new: count.
	newStylesById := IdentityDictionary new: count.
	aCollection do: 
			[:each |
			each basicId isNil ifTrue: [each basicId: availableStyles next].
			newStylesByName at: each name put: each.
			newStylesById at: each basicId put: each].
	newStylesByName at: #normal ifAbsentPut: [TextStyle normal].
	currentTextStyles := newStylesByName.
	styleIdMap := newStylesById!

setIndicator: anIntegerOrSymbol from: startInteger length: lengthInteger 
	"Apply the indicator identified by the <integer> id or <symbol> name, anIntegerOrSymbol, to
	the range of text in the receiver starting from the one-base integer character position,
	startInteger, for a run length specified by the <integer>, lengthInteger."

!

startStylingFrom: anInteger 
	lastStyled := anInteger - 1!

styleNamed: aSymbol
	"Answer a <ScintillaTextStyle> being the named style, or nil if the name is not recognised."

	^currentTextStyles lookup: aSymbol!

styleNext: anInteger mask: anInteger2
	| range |
	range := lastStyled + 1 to: lastStyled + anInteger.
	range isEmpty ifTrue: [^self].
	range stop > text size ifTrue: [^BoundsError signal: range stop].
	(tokens notEmpty and: [(tokens last at: 2) == anInteger2])
		ifTrue: [(tokens last at: 1) stop: range stop]
		ifFalse: [tokens addLast: {range. anInteger2}].
	lastStyled := range stop!

styleWithId: anInteger
	^styleIdMap at: anInteger
		ifAbsent: 
			[TextStyle new
				name: anInteger;
				yourself]!

stylingPosition
	^lastStyled + 1!

text: aString 
	text := aString.
	lastStyled := 0.
	tokens := OrderedCollection new!

textLength
	^text size!

textStyles: aSet 
	self setCurrentTextStyles: aSet!

tokens
	| answer lastStyle |
	answer := OrderedCollection new.
	lastStyle := nil.
	tokens do: 
			[:each |
			| id style |
			id := each last bitAnd: self maxStyle.
			style := id == 0 ifTrue: [#whitespace] ifFalse: [(self styleWithId: id) name].
			lastStyle == style
				ifTrue: 
					[| last |
					last := answer last.
					last at: 1 put: (last first start to: each first stop).
					last at: 3 put: (self plainTextRange: last first)]
				ifFalse: 
					[lastStyle := style.
					answer addLast: {each first. style. self plainTextRange: each first}]].
	^answer! !
!UI.Scintilla.Tests.MockScintillaView categoriesForMethods!
applyStyle:toNext:!public!styling! !
characterAt:!public!unit tests! !
maxStyle!public!unit tests! !
messages!accessing!public! !
plainTextFrom:to:!public!unit tests! !
plainTextRange:!accessing!public! !
resetMessages!accessing!public! !
sendMessage:wParam:lParam:!operations!public! !
setCurrentTextStyles:!private!style definition! !
setIndicator:from:length:!indicators!public! !
startStylingFrom:!public!unit tests! !
styleNamed:!accessing!public!styling! !
styleNext:mask:!public!unit tests! !
styleWithId:!accessing!public!style definition! !
stylingPosition!accessing!public! !
text:!public!unit tests! !
textLength!public!unit tests! !
textStyles:!public!unit tests! !
tokens!public!unit tests! !
!

!UI.Scintilla.Tests.MockScintillaView class methodsFor!

icon
	^ScintillaView icon! !
!UI.Scintilla.Tests.MockScintillaView class categoriesForMethods!
icon!constants!public! !
!

