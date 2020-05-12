"Filed out from Dolphin Smalltalk 7"!

MultilineTextEditTest subclass: #ScintillaViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaViewTest guid: (GUID fromString: '{3c6fbe95-74e0-4325-97e1-82f12133d503}')!
ScintillaViewTest comment: ''!
!ScintillaViewTest categoriesForClass!Unclassified! !
!ScintillaViewTest methodsFor!

classToTest
	^ScintillaView!

initializePresenter
	| margins |
	super initializePresenter.
	margins := presenter view margins.
	margins do: [:each | each width: 0].
	presenter view margins: margins
!

margins
	^0 @ 0!

testFindStringStartingAt
	| found found2 |
	presenter codePage: #utf8.
	self assert: (presenter findString: 'Object' startingAt: 1) equals: 0.
	"This test relies on 'Object' appearing in the text multiple times"
	presenter text: self text.
	found := presenter findString: 'Object' startingAt: 1.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	self assert: (presenter findString: 'Object' startingAt: found) equals: found.
	self assert: found equals: (self text indexOfSubCollection: 'Object').
	found2 := presenter findString: 'Object' startingAt: found + 1.
	self assert: found2 > found.
	self assert: found2 equals: (self text indexOfSubCollection: 'Object' startingAt: found+1).
	self assert: (presenter findString: 'Wibble' startingAt: 1) equals: 0.
	self assert: (presenter findString: '' startingAt: 1) equals: 0.
	presenter text: 'Hello 🐬 World'.
	found := presenter findString: '🐬' startingAt: 1.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 7.
	self assert: found equals: 7.
	found := presenter findString: '🐬' startingAt: 8.
	self assert: found equals: 0.
	found := presenter findString: '🐬' startingAt: 50.
	self assert: found equals: 0!

testLanguages
	| lingos |
	lingos := ScintillaView lexerLanguages.
	lingos do: [:each | each notNil ifTrue: [presenter view lexer: each]]!

testSetGetAnnotations
	| annotations |
	presenter text: self text.
	annotations := OrderedCollection new.
	annotations
		add: (ScintillaAnnotation
					line: 1
					text: 'Wobble'
					style: #Error);
		add: (ScintillaAnnotation
					line: 2
					text: 'Wibble'
					style: #Warning);
		add: (ScintillaAnnotation
					line: 1
					text: 'Blah'
					style: #Notification).
	presenter annotations: annotations.
	self assert: (presenter annotations noDifference: annotations)!

testTokensFromTo
	| tokens expected styler |
	presenter textStyles: SmalltalkWorkspace textStyles.
	presenter stylerClass: SmalltalkExpressionStyler.
	styler := StStyler new.
	#('' ' ' ' 	 ' ' a' 'a ' ' a ' ' a #a' 'a #a ' ' a #a ' ' a #a 1.2 '''' ''blah blah'' (') do: 
			[:text |
			presenter text: text.
			presenter restyleAll.
			tokens := (presenter tokensFrom: 1 to: presenter textLength) asArray.
			expected := (SmalltalkScanner on: presenter text readStream) contents
						collect: [:each | (styler styleNameFor: each) -> (text copyFrom: each start to: each stop)].
			self assert: tokens equals: expected]! !
!ScintillaViewTest categoriesFor: #classToTest!helpers!private! !
!ScintillaViewTest categoriesFor: #initializePresenter!public!Running! !
!ScintillaViewTest categoriesFor: #margins!private!unit tests! !
!ScintillaViewTest categoriesFor: #testFindStringStartingAt!public!unit tests! !
!ScintillaViewTest categoriesFor: #testLanguages!public!unit tests! !
!ScintillaViewTest categoriesFor: #testSetGetAnnotations!public!unit tests! !
!ScintillaViewTest categoriesFor: #testTokensFromTo!public!unit tests! !

