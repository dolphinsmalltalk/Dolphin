"Filed out from Dolphin Smalltalk X6"!

Shell subclass: #SmaCCParserGenerator
	instanceVariableNames: 'subcanvasBuilder tabList parserClassNameHolder scannerClassNameHolder conflictHolder scannerHolder parserHolder testHolder generateDefinitionCommentsHolder generateSymbolCommentsHolder generateItemSetCommentsHolder allowUnicodeHolder ignoreCaseHolder'
	classVariableNames: 'ShowPrecedenceConflicts'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmaCCParserGenerator guid: (GUID fromString: '{DA5AC953-F2B8-4A4F-AA72-B85DB3758B8B}')!
SmaCCParserGenerator comment: ''!
!SmaCCParserGenerator categoriesForClass!Unclassified! !
!SmaCCParserGenerator methodsFor!

allowUnicodeHolder
	^allowUnicodeHolder!

compile: aSymbol
	| grammar stream oldIgnoreCase oldCharacterSize parserCompiler |
	(self scannerClassNameHolder value isEmpty or: [self parserClassNameHolder value isEmpty]) 
		ifTrue: [^MessageBox warning: 'Both classes are not specified'].
	Cursor wait showWhile: 
			[self verifySyntax ifFalse: [^self].
			oldIgnoreCase := SmaCCGrammar ignoreCase.
			oldCharacterSize := SmaCCGrammar maximumCharacterValue.
			
			[SmaCCGrammar
				ignoreCase: self ignoreCaseHolder value;
				maximumCharacterValue: (self allowUnicodeHolder value ifTrue: [2 ** 16 - 1] ifFalse: [255]).
			parserCompiler := SmaCCGrammarCompiler new.
			parserCompiler
				buildScanner: self scannerHolder value andParser: self parserHolder value;
				scannerClass: self scannerClassNameHolder value;
				parserClass: self parserClassNameHolder value.
			grammar := parserCompiler grammar.
			grammar type: aSymbol.
			stream := WriteStream on: String new.
			
			[parserCompiler createChanges.
			self generateDefinitionCommentsHolder value 
				ifTrue: [parserCompiler compileDefinitionComments].
			self generateSymbolCommentsHolder value ifTrue: [parserCompiler compileSymbolComment].
			self generateItemSetCommentsHolder value ifTrue: [parserCompiler compileItemSetsComment].
			parserCompiler compileChanges] 
					on: SmaCCCompilationNotification
					do: 
						[:ex | 
						(ShowPrecedenceConflicts or: [('*precedence*' match: ex messageText) not]) 
							ifTrue: 
								[stream
									nextPutAll: '-------------------------';
									cr;
									nextPutAll: ex messageText;
									cr;
									cr;
									nextPutAll: ex tag;
									cr].
						ex pass].
			self conflictHolder value: stream contents] 
					ensure: 
						[SmaCCGrammar
							ignoreCase: oldIgnoreCase;
							maximumCharacterValue: oldCharacterSize]]!

compileLALR1
	self compile: #LALR1!

compileLR1
	self compile: #LR1!

conflictHolder
	^conflictHolder!

createComponents
	super createComponents.
	scannerHolder := self add: TextPresenter new name: 'ScannerText'.
	parserHolder := self add: TextPresenter new name: 'ParserText'.
	scannerClassNameHolder := self add: TextPresenter new name: 'scannerField'.
	parserClassNameHolder := self add: TextPresenter new name: 'ParserField'.
	allowUnicodeHolder := self add: BooleanPresenter new name: 'unicode'.
	ignoreCaseHolder := self add: BooleanPresenter new name: 'ignoreCase'.
	generateDefinitionCommentsHolder := self add: BooleanPresenter new
				name: 'generateDefinition'.
	generateDefinitionCommentsHolder value: true.
	generateSymbolCommentsHolder := self add: BooleanPresenter new name: 'generateSymbol'.
	generateItemSetCommentsHolder := self add: BooleanPresenter new name: 'generateItemSet'.
	conflictHolder := self add: TextPresenter new name: 'messages'.
	testHolder := self add: TextPresenter new name: 'TestEdit'!

displayError: aString at: aSmallInteger for: aTextPresenter 
	| originalString |
	aTextPresenter setFocus.
	originalString := aTextPresenter value.
	aTextPresenter view caretPosition: aSmallInteger.
	aTextPresenter
		replaceSelection: aString;
		selectionRange: (aSmallInteger to: aSmallInteger + aString size - 1)!

findParserClass
	| class |
	class := ChoicePrompter 
				choices: (SmaCCParser allSubclasses asSortedCollection: [:a :b | a name < b name])
				caption: 'What class do you want to use?'.
	class isNil ifTrue: [^self].
	parserClassNameHolder value: class name.
	(class class includesSelector: #parserDefinitionComment) 
		ifTrue: 
			[(MessageBox confirm: 'Do you wish to load the parser definition?') 
				ifTrue: 
					[parserHolder 
						value: (self removeCommentedPartOf: (class class sourceCodeAt: #parserDefinitionComment))]]!

findScannerClass
	| class |
	class := ChoicePrompter 
				choices: (SmaCCScanner allSubclasses asSortedCollection: [:a :b | a name < b name])
				caption: 'What class do you want to use?'.
	class isNil ifTrue: [^self].
	scannerClassNameHolder value: class name.
	(class class includesSelector: #scannerDefinitionComment) 
		ifTrue: 
			[(MessageBox confirm: 'Do you wish to load the parser definition?') 
				ifTrue: 
					[scannerHolder 
						value: (self removeCommentedPartOf: (class class sourceCodeAt: #scannerDefinitionComment))]]!

generateDefinitionCommentsHolder
	^generateDefinitionCommentsHolder!

generateItemSetCommentsHolder
	^generateItemSetCommentsHolder!

generateSymbolCommentsHolder
	^generateSymbolCommentsHolder!

ignoreCaseHolder
	^ignoreCaseHolder!

parse
	self parseAndEvaluate: [:each | MessageBox notify: 'Parses without errors']!

parseAndEvaluate: aBlock
	| class |
	class := self parserClass.
	class isNil ifTrue: [^MessageBox warning: 'No parser defined'].
	aBlock value: (class parse: testHolder value
				onError: 
					[:aString :position | 
					self 
						displayError: aString
						at: position
						for: testHolder.
					^self])!

parseAndInspect
	self parseAndEvaluate: [:each | each inspect]!

parserClass
	^Smalltalk at: self parserClassNameHolder value asSymbol!

parserClassNameHolder
	^parserClassNameHolder!

parserHolder
	^parserHolder!

removeCommentedPartOf: aString 
	| inStream outStream |
	inStream := ReadStream on: aString.
	outStream := WriteStream on: String new.
	inStream upTo: $".
	[inStream atEnd] whileFalse: 
			[(inStream peekFor: $") ifTrue: [outStream nextPut: $"].
			outStream nextPutAll: (inStream upTo: $")].
	^outStream contents!

scannerClassNameHolder
	^scannerClassNameHolder!

scannerHolder
	^scannerHolder!

testHolder
	^testHolder!

verifyParser
	^
	[SmaCCGrammarCompiler new buildScanner: self scannerHolder value
		andParser: self parserHolder value.
	true] 
			on: SmaCCParserError
			do: 
				[:ex | 
				self 
					displayError: ex description
					at: ex tag position
					for: parserHolder.
				ex return: false]!

verifyScanner
	SmaCCScannerParser parse: self scannerHolder value
		onError: 
			[:aString :position | 
			self 
				displayError: aString
				at: position
				for: scannerHolder.
			^false].
	^true!

verifySyntax
	^self verifyScanner and: [self verifyParser]! !
!SmaCCParserGenerator categoriesFor: #allowUnicodeHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #compile:!private! !
!SmaCCParserGenerator categoriesFor: #compileLALR1!actions!private! !
!SmaCCParserGenerator categoriesFor: #compileLR1!actions!private! !
!SmaCCParserGenerator categoriesFor: #conflictHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #createComponents!private! !
!SmaCCParserGenerator categoriesFor: #displayError:at:for:!public! !
!SmaCCParserGenerator categoriesFor: #findParserClass!actions!private! !
!SmaCCParserGenerator categoriesFor: #findScannerClass!actions!private! !
!SmaCCParserGenerator categoriesFor: #generateDefinitionCommentsHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #generateItemSetCommentsHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #generateSymbolCommentsHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #ignoreCaseHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #parse!actions!private! !
!SmaCCParserGenerator categoriesFor: #parseAndEvaluate:!private! !
!SmaCCParserGenerator categoriesFor: #parseAndInspect!actions!private! !
!SmaCCParserGenerator categoriesFor: #parserClass!private! !
!SmaCCParserGenerator categoriesFor: #parserClassNameHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #parserHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #removeCommentedPartOf:!private! !
!SmaCCParserGenerator categoriesFor: #scannerClassNameHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #scannerHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #testHolder!aspects!private! !
!SmaCCParserGenerator categoriesFor: #verifyParser!private! !
!SmaCCParserGenerator categoriesFor: #verifyScanner!private! !
!SmaCCParserGenerator categoriesFor: #verifySyntax!private! !

!SmaCCParserGenerator class methodsFor!

initialize
	ShowPrecedenceConflicts := false.
	Smalltalk developmentSystem addAdditionalToolsFolderIcon: self toolsFolderIcon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ShellView)  98 27 0 0 98 2 27131905 131073 416 0 524550 ##(ColorRef)  8 4278190080 328198 ##(Point)  1141 921 517 0 0 0 416 1180166 ##(ProportionalLayout)  234 240 98 0 32 234 256 608 0 0 0 0 0 1 0 0 0 0 1 0 0 983302 ##(MessageSequence)  202 208 98 3 721670 ##(MessageSend)  8 #createAt:extent: 98 2 530 133 175 530 1141 921 416 706 8 #text: 98 1 8 'Parser Generator' 416 706 8 #menuBar: 98 1 0 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 66 0 0 0 87 0 0 0 124 2 0 0 35 2 0 0] 98 1 410 8 ##(CardContainer)  98 16 0 416 98 2 8 1140850688 131073 976 0 482 512 0 5 0 0 0 976 655878 ##(CardLayout)  202 208 98 4 721414 ##(Association)  8 'Compile' 410 8 ##(ContainerView)  98 15 0 976 98 2 8 1140850688 131073 1184 0 721158 ##(SystemColor)  31 0 5 0 0 0 1184 852230 ##(FramingLayout)  234 240 98 32 410 8 ##(PushButton)  98 17 0 1184 98 2 8 1140924416 1 1360 0 482 512 0 5 0 0 0 1360 0 8 4294906781 1180998 4 ##(CommandDescription)  8 #findParserClass 8 '...' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 1049 61 530 41 41 1360 706 816 98 1 8 '...' 1360 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 2 0 0 30 0 0 0 32 2 0 0 50 0 0 0] 98 0 530 193 193 0 27 1181766 2 ##(FramingConstraints)  1114638 ##(STBSingletonProxy)  8 ##(FramingCalculation)  8 #fixedPreviousRight 11 1808 51 1802 1824 8 #fixedPreviousTop 1 1802 1824 8 #fixedPreviousBottom 1 410 8 ##(StaticText)  98 16 0 1184 98 2 8 1140850946 1 1920 0 0 0 5 0 0 0 1920 0 8 4294906439 852486 ##(NullConverter)  0 0 0 642 202 208 98 2 706 736 98 2 530 1 61 530 443 37 1920 706 816 98 1 8 'Parser class:' 1920 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 30 0 0 0 221 0 0 0 48 0 0 0] 98 0 1744 0 27 1762 1802 1824 8 #fixedParentLeft 1 1802 1824 8 #relativeParentWidth 327734 ##(Float)  8 154 153 153 153 153 153 217 63 1802 1824 8 #fixedParentTop 61 1802 1824 8 #fixedViewTop 37 410 8 ##(CheckBox)  98 16 0 1184 98 2 8 1140924419 1 2432 721990 2 ##(ValueHolder)  0 0 1802 8 ##(SearchPolicy)  8 #never 32 482 512 0 5 0 0 0 2432 0 8 4294906781 2018 0 0 0 642 202 208 98 3 706 736 98 2 530 221 157 530 361 37 2432 706 8 #isEnabled: 98 1 32 2432 706 816 98 1 8 'Allow Unicode Characters' 2432 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 78 0 0 0 34 1 0 0 96 0 0 0] 98 0 1744 0 27 1762 2304 2338 8 154 153 153 153 153 153 201 63 1802 1824 8 #fixedViewLeft 361 1888 11 2400 37 410 1936 98 16 0 1184 98 2 8 1140850946 1 2960 0 0 0 5 0 0 0 2960 0 8 4294906439 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 1 13 530 443 37 2960 706 816 98 1 8 'Scanner class:' 2960 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 6 0 0 0 221 0 0 0 24 0 0 0] 98 0 1744 0 27 1762 2272 1 2304 2338 8 154 153 153 153 153 153 217 63 2368 13 2400 37 410 8 ##(StaticRectangle)  98 14 0 1184 98 2 8 1140850951 262145 3296 0 482 512 0 5 0 0 0 3296 0 8 4294906439 642 202 208 98 2 706 736 98 2 530 11 309 530 1089 5 3296 706 2768 98 1 32 3296 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 154 0 0 0 37 2 0 0 156 0 0 0] 98 0 1744 0 27 1762 2272 11 1802 1824 8 #fixedParentRight -9 1888 11 1888 15 410 8 ##(TextEdit)  98 16 0 1184 98 2 8 1140916352 1025 3648 0 482 512 0 5 0 0 0 3648 0 8 4294906635 2018 0 0 1 642 202 208 98 3 706 736 98 2 530 453 7 530 587 41 3648 706 8 #selectionRange: 98 1 525062 ##(Interval)  3 1 3 3648 706 8 #isTextModified: 98 1 32 3648 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 226 0 0 0 3 0 0 0 7 2 0 0 23 0 0 0] 98 0 1744 0 27 1762 1808 11 3616 -69 2368 7 2400 41 410 2448 98 16 0 1184 98 2 8 1140924419 1 4080 2514 0 0 2544 32 482 512 0 5 0 0 0 4080 0 8 4294906781 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 221 111 530 227 37 4080 706 816 98 1 8 'Ignore Case' 4080 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 110 0 0 0 55 0 0 0 223 0 0 0 73 0 0 0] 98 0 1744 0 27 1762 2304 2338 8 154 153 153 153 153 153 201 63 2928 227 1888 11 2400 37 410 1376 98 17 0 1184 98 2 8 1140924416 1 4448 0 482 512 0 5 0 0 0 4448 0 8 4294906781 1474 8 #compileLALR1 8 'Compile LALR(1)' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 277 249 530 191 51 4448 706 816 98 1 8 'Compile LALR(1)' 4448 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 138 0 0 0 124 0 0 0 233 0 0 0 149 0 0 0] 98 0 1744 0 27 1762 2304 2338 8 0 0 0 0 0 0 208 63 2928 191 1888 11 2400 51 410 1936 98 16 0 1184 98 2 8 1140850944 1 4832 0 0 0 5 0 0 0 4832 0 8 4294906439 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 21 333 530 241 37 4832 706 816 98 1 8 'Messages:' 4832 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 166 0 0 0 130 0 0 0 184 0 0 0] 98 0 1744 0 27 1762 2272 21 2928 241 1888 21 2400 37 410 8 ##(MultilineTextEdit)  98 16 0 1184 98 2 8 1143017796 1025 5152 0 482 512 0 5 0 0 0 5152 0 8 4294906635 2018 0 0 9 642 202 208 98 3 706 736 98 2 530 11 369 530 1089 443 5152 706 3904 98 1 3938 3 1 3 5152 706 3984 98 1 32 5152 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 184 0 0 0 37 2 0 0 149 1 0 0] 98 0 1744 0 27 1762 2272 11 3616 -9 1888 1 1802 1824 8 #fixedParentBottom -3 410 2448 98 16 0 1184 98 2 8 1140924419 1 5568 2514 0 0 2544 32 482 512 0 5 0 0 0 5568 0 8 4294906781 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 665 157 530 361 37 5568 706 816 98 1 8 'Generate symbol comments' 5568 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 1 0 0 78 0 0 0 0 2 0 0 96 0 0 0] 98 0 1744 0 27 1762 2304 2338 8 51 51 51 51 51 51 227 63 2928 361 1856 1 2400 37 410 1376 98 17 0 1184 98 2 8 1140924416 1 5936 0 482 512 0 5 0 0 0 5936 0 8 4294906781 1474 8 #findScannerClass 8 '...' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 1049 7 530 41 41 5936 706 816 98 1 8 '...' 5936 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 12 2 0 0 3 0 0 0 32 2 0 0 23 0 0 0] 98 0 1744 0 27 1762 1808 11 1808 51 1856 1 1888 1 410 2448 98 16 0 1184 98 2 8 1140924419 1 6304 2514 0 0 2544 32 482 512 0 5 0 0 0 6304 0 8 4294906781 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 665 203 530 361 37 6304 706 816 98 1 8 'Generate item set comments' 6304 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 1 0 0 101 0 0 0 0 2 0 0 119 0 0 0] 98 0 1744 0 27 1762 1802 1824 8 #fixedPreviousLeft 1 2928 361 1888 11 2400 37 410 1376 98 17 0 1184 98 2 8 1140924416 1 6688 0 482 512 0 5 0 0 0 6688 0 8 4294906781 1474 8 #compileLR1 8 'Compile LR(1)' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 641 249 530 191 51 6688 706 816 98 1 8 'Compile LR(1)' 6688 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 64 1 0 0 124 0 0 0 159 1 0 0 149 0 0 0] 98 0 1744 0 27 1762 1802 1824 8 #fixedViewRight -189 2304 2338 8 0 0 0 0 0 0 232 63 1856 1 1888 1 410 2448 98 16 0 1184 98 2 8 1140924419 1 7104 2514 0 32 2544 16 482 512 0 5 0 0 0 7104 0 8 4294906781 2018 0 0 0 642 202 208 98 2 706 736 98 2 530 665 111 530 361 37 7104 706 816 98 1 8 'Generate definition comments' 7104 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 76 1 0 0 55 0 0 0 0 2 0 0 73 0 0 0] 98 0 1744 0 27 1762 2304 2338 8 51 51 51 51 51 51 227 63 2928 361 1856 1 2400 37 410 3664 98 16 0 1184 98 2 8 1140916352 1025 7472 0 482 512 0 5 0 0 0 7472 0 8 4294906635 2018 0 0 1 642 202 208 98 3 706 736 98 2 530 453 61 530 587 41 7472 706 3904 98 1 3938 3 1 3 7472 706 3984 98 1 32 7472 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 226 0 0 0 30 0 0 0 7 2 0 0 50 0 0 0] 98 0 1744 0 27 1762 1808 11 3616 -69 1856 1 2400 41 234 256 98 22 4448 8 'compileLALR' 7472 8 'ParserField' 5936 8 'findScannerClass' 7104 8 'generateDefinition' 5152 8 'messages' 4080 8 'ignoreCase' 1360 8 'findParserClass' 6688 8 'compileLR' 5568 8 'generateSymbol' 3648 8 'scannerField' 6304 8 'generateItemSet' 0 642 202 208 98 1 706 736 98 2 530 9 45 530 1109 815 1184 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 46 2 0 0 173 1 0 0] 98 16 2960 3648 5936 1920 7472 1360 4080 7104 2432 5568 6304 4448 6688 3296 4832 5152 1744 0 27 1138 8 'Test' 410 1200 98 15 0 976 98 2 8 1140850688 131073 8240 0 1266 31 0 5 0 0 0 8240 1298 234 240 98 6 410 1376 98 17 0 8240 98 2 8 1140924416 1 8368 0 482 512 0 5 0 0 0 8368 0 8 4294906781 1474 8 #parse 8 'Parse' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 5 771 530 191 41 8368 706 816 98 1 8 'Parse' 8368 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 129 1 0 0 97 0 0 0 149 1 0 0] 98 0 1744 0 27 1762 2272 5 2928 191 5536 -43 5536 -3 410 5168 98 16 0 8240 98 2 8 1143017796 1025 8736 0 482 512 0 5 0 0 0 8736 0 8 4294906635 2018 0 0 9 642 202 208 98 3 706 736 98 2 530 5 5 530 1101 761 8736 706 3904 98 1 3938 3 1 3 8736 706 3984 98 1 32 8736 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 2 0 0 0 2 0 0 0 40 2 0 0 126 1 0 0] 98 0 1744 0 27 1762 2272 5 3616 -3 2368 5 5536 -49 410 1376 98 17 0 8240 98 2 8 1140924416 1 9104 0 482 512 0 5 0 0 0 9104 0 8 4294906781 1474 8 #parseAndInspect 8 'Parse && Inspect' 1 1 0 0 32 642 202 208 98 2 706 736 98 2 530 205 771 530 191 41 9104 706 816 98 1 8 'Parse && Inspect' 9104 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 102 0 0 0 129 1 0 0 197 0 0 0 149 1 0 0] 98 0 1744 0 27 1762 1808 11 2928 191 1856 1 1888 1 234 256 98 6 8368 8 'parse' 8736 8 'TestEdit' 9104 8 'parseAndInspect' 0 642 202 208 98 1 706 736 98 2 530 9 45 530 1109 815 8240 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 46 2 0 0 173 1 0 0] 98 3 8736 8368 9104 1744 0 27 1138 8 'Scanner' 410 5168 98 16 0 976 98 2 8 1143017796 1025 9744 0 482 512 0 5 0 0 0 9744 0 8 4294906635 2018 0 0 9 642 202 208 98 3 706 736 98 2 530 9 45 530 1109 815 9744 706 3904 98 1 3938 3 1 3 9744 706 3984 98 1 32 9744 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 46 2 0 0 173 1 0 0] 98 0 1744 0 27 1138 8 'Parser' 410 5168 98 16 0 976 98 2 8 1143017796 1025 10128 0 482 512 0 5 0 0 0 10128 0 8 4294906635 2018 0 0 9 642 202 208 98 3 706 736 98 2 530 9 45 530 1109 815 10128 706 3904 98 1 3938 3 1 3 10128 706 3984 98 1 32 10128 914 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 4 0 0 0 22 0 0 0 46 2 0 0 173 1 0 0] 98 0 1744 0 27 1184 234 256 98 8 10128 8 'ParserText' 9744 8 'ScannerText' 1184 8 'CompileTab' 8240 8 'TestTab' 0 410 8 ##(TabView)  98 23 0 976 98 2 8 1140916736 1 10576 590662 2 ##(ListModel)  202 208 98 4 9728 10112 1168 8224 0 1802 2560 8 #identity 1266 31 0 1 0 0 0 10576 0 8 4294906623 8 ##(BasicListAbstract)  8 ##(IconicListAbstract)  1802 8 ##(IconImageManager)  8 #current 0 0 0 0 0 8 #noIcons 642 202 208 98 3 706 736 98 2 530 1 1 530 1125 867 10576 706 8 #selectionByIndex:ifAbsent: 98 2 7 706 8 #yourself 608 0 10576 706 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 10576 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 50 2 0 0 177 1 0 0] 98 0 1744 0 27 642 202 208 98 1 706 736 98 2 530 1 1 530 1125 867 976 914 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 50 2 0 0 177 1 0 0] 98 5 9744 10128 1184 8240 10576 1744 0 27 1744 0 27 )!

toolDescription
	^'SmaCC Parser Generator'!

toolsFolderIcon
	^SmalltalkSystemIcon 
		icon: self icon
		description: self toolDescription
		openBlock: [:folder :item | self show]!

uninitialize
	Smalltalk developmentSystem removeSystemFolderIconNamed: self toolDescription! !
!SmaCCParserGenerator class categoriesFor: #initialize!public! !
!SmaCCParserGenerator class categoriesFor: #resource_Default_view!public!resources-views! !
!SmaCCParserGenerator class categoriesFor: #toolDescription!constants!public! !
!SmaCCParserGenerator class categoriesFor: #toolsFolderIcon!public! !
!SmaCCParserGenerator class categoriesFor: #uninitialize!public! !

