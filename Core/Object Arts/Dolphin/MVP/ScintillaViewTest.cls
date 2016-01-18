"Filed out from Dolphin Smalltalk 7"!

MultilineTextEditTest subclass: #ScintillaViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScintillaViewTest guid: (GUID fromString: '{3C6FBE95-74E0-4325-97E1-82F12133D503}')!
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

testLanguages
	| lingos |
	lingos := ScintillaView classPool at: 'Lexers'.
	lingos do: [:each | each notNil ifTrue: [presenter view lexer: each]]!

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
			self assert: tokens = expected]! !
!ScintillaViewTest categoriesFor: #classToTest!helpers!private! !
!ScintillaViewTest categoriesFor: #initializePresenter!public!Running! !
!ScintillaViewTest categoriesFor: #margins!private!unit tests! !
!ScintillaViewTest categoriesFor: #testLanguages!public!unit tests! !
!ScintillaViewTest categoriesFor: #testTokensFromTo!public!unit tests! !

