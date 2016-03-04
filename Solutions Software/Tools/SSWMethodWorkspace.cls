"Filed out from Dolphin Smalltalk 7"!

MethodWorkspace subclass: #SSWMethodWorkspace
	instanceVariableNames: 'lastPlainText unmodifiedParseTree'
	classVariableNames: ''
	poolDictionaries: 'SmalltalkParseErrorCodes'
	classInstanceVariableNames: ''!
SSWMethodWorkspace guid: (GUID fromString: '{648BBBF3-5DC4-4B25-B2FD-61A1F6A8E190}')!
SSWMethodWorkspace comment: ''!
!SSWMethodWorkspace categoriesForClass!Unclassified! !
!SSWMethodWorkspace methodsFor!

additionalAccelerators

	^OrderedCollection new
		add: #(#insertBreak 'Pause');
		add: #(#insertOrEditSpy 'F9');
		add: #(#removeSpy 'Shift+F9');
		add: #(#removeAllSpies 'Ctrl+F9');
		yourself!

createSchematicWiring

	super createSchematicWiring.

	self methodSpyManager 
		when: #methodSpyChangedIn: send: #onMethodSpyChangedIn: to: self;
		when: #methodSpyChanged send: #onMethodSpyChanged to: self!

currentSpy

	| currentSpyNode |

	currentSpyNode := self spyInsertNode.
	currentSpyNode isNil ifTrue: [^nil].

	^self selectedMethod methodSpies detect: [ :each | each methodSourceInterval start = currentSpyNode start] ifNone: 
		[self selectedMethod methodSpies detect: 
			[ :each | each methodSourceInterval includes: currentSpyNode start] ifNone: [nil]]!

highlightCompilationErrors: anInteger 

	| method |

	super highlightCompilationErrors: anInteger.

	method := self selectedMethod.

	(method notNil and: [self isModified not and: [method isSpy]]) ifTrue: [self highlightMethodSpies: anInteger in: method]!

highlightCurrentSpy

	"© 2002 Solutions Software

	Highlight the range of the current spy. Return the spy"

	| spy |

	spy := self currentSpy.

	self view selectionRange: spy methodSourceInterval.

	^spy!

highlightMethodSpies: anInteger in: method

	self view indicators: 
		(self view indicators 
			addAll:
				(method methodSpies collect: 
					[:each | 
					each scintillaIndicator: anInteger]);
			yourself)!

highlightSpyInsertPositionRange

	"Highlight and return the spy insert position range
	The highlighted range may be different (but equivalent) to the returned range 
	if auto-code formatting is in use"

	| parseTree highlightNode targetNode start source end range |

	parseTree := self unmodifiedParseTree.
	highlightNode := self spyInsertNodeIn: parseTree.
	highlightNode isNil ifTrue: [^nil].

	(self selectedMethod isSpy not and: [MethodBrowser autoFormat])
	ifTrue:
		[| normalParseTree |
		normalParseTree := self selectedMethod parseTree.
		targetNode := normalParseTree nodeAtIndex: (parseTree identityIndexOfNode: highlightNode).
		source := parseTree formattedCode]
	ifFalse:
		[targetNode := highlightNode.
		source := parseTree source].

	start := highlightNode start.
	end := source indexOfAnyOf: ':; ' startingAt: start.
	end = 0 ifTrue: [end := source size].

	range := start to: end.
	self view selectionRange: range.
	^targetNode start to: (targetNode start + (range size - 1))!

insertBreak

	| oldRange positionRange |

	(self isCurrentlyAtSpy and: [self currentSpy isSimpleHalt]) ifTrue: [^self silentlyRemoveSpy].

	(self querySpyCommandSymbol: #insertBreak) ifFalse: [Sound beep. ^self].

	oldRange  := self selectionRange. 
	positionRange := self highlightSpyInsertPositionRange.

	self safeRecompile:
		[self selectedMethod beSpiedOnBy: 
			(SSWMethodSpy newSimpleHalt 
				method: self selectedMethod;
				methodSourceInterval: positionRange;
				yourself)].

	self selectionRange: oldRange !

insertOrEditSpy

	"© 2002 Solutions Software"

	^(self querySpyCommandSymbol: #insertSpy)
		ifTrue: [self quickInsertSpy]
		ifFalse: [(self querySpyCommandSymbol: #inspectSpy) ifTrue: [self inspectSpy]]!

insertSpy

	"Create and inspect a Spy. It will be inserted into the method if accepted in the Inspector"

	| positionRange |

	positionRange := self highlightSpyInsertPositionRange.
	(SSWMethodSpy new 
		method: self selectedMethod;
		spySource: '"spy source"'; 
		methodSourceInterval: positionRange;
		yourself) inspect!

inspectSpy

	self highlightCurrentSpy inspect!

isCurrentlyAtSpy

	^self selectedMethod notNil and: [self selectedMethod isSpy and: [self currentSpy notNil]]!

isSpyEnabled

	^self currentSpy isLocallyEnabled!

methodSpyManager

	^SSWMethodSpyManager current!

onMethodSpyChanged

	self isModified not ifTrue: [self autoParse]!

onMethodSpyChangedIn: aCompiledMethod

	aCompiledMethod = self selectedMethod ifTrue: [self onMethodSpyChanged]!

onViewOpened

	super onViewOpened.

	self view contextMenu
		addSeparator;
		addItem: self spySubmenu.

	self setIndicatorsForSpies!

queryCommand: aCommandQuery

	| symbol |

	symbol := aCommandQuery commandSymbol.

	symbol == #methodSpies ifTrue:
		[aCommandQuery isEnabled: (self view isModified not and: [self view isReadOnly not]).
		^true].

	(#(#insertSpy #inspectSpy #toggleSpy #resetSpy #removeSpy #removeAllSpies) includes: symbol) ifTrue:
		[aCommandQuery isEnabled: (self querySpyCommandSymbol: symbol).
		(symbol = #toggleSpy and: [aCommandQuery isEnabled]) ifTrue: 
			[aCommandQuery isChecked: self isSpyEnabled].
		^true].

	^super queryCommand: aCommandQuery!

querySpyCommandSymbol: aSymbol

	"© 2002 Solutions Software"

	(self isModified or: [self selectedMethod isNil]) ifTrue: [^false].

	aSymbol == #removeAllSpies ifTrue: [^self selectedMethod isSpy].

	^self isCurrentlyAtSpy
	ifTrue: 	
		[aSymbol ~= #insertSpy and: [aSymbol ~= #insertBreak]]
	ifFalse:
		[(aSymbol == #insertSpy or: [aSymbol == #insertBreak])
			ifTrue: [self selectedMethod notNil and: [self spyInsertNode notNil]]
			ifFalse: [false]]!

quickInsertSpy

	"Create and insert a Method Spy, obtaining the code from a dialog"

	| positionRange spySource |

	positionRange := self highlightSpyInsertPositionRange.

	spySource := Prompter prompt: 'Enter Spy code' caption: 'Insert Spy'.
	(spySource isNil or: [spySource isEmpty]) ifFalse:
		[self methodSpyManager compileSpy:
			(SSWMethodSpy new 
				method: self selectedMethod;
				spySource: spySource; 
				methodSourceInterval: positionRange;
				yourself)]!

removeAllSpies

	(MessageBox confirm: 'Remove all Spies from this method?') ifFalse: [^self].

	self selectedMethod removeAllSpies!

removeSpy

	self highlightCurrentSpy.
	(MessageBox confirm: 'Remove this Method Spy?') ifFalse: [^self].

	self silentlyRemoveSpy!

resetSpy

	self highlightCurrentSpy reset!

safeRecompile: aBlock

	"Evaluate aBlock, trapping and notifying any compilation errors"

	[aBlock value] on: CompilerErrorNotification do:
		[ :exc |
		MessageBox warning: ('Failed to compile: ', exc description).
		exc return]!

setIndicatorsForSpies

	| currentStyles |

	currentStyles := self view indicatorStyles.

	(currentStyles anySatisfy: [ :each | each name = #SpyEnabled]) ifFalse: 
		[self view indicatorStyles:
			(currentStyles
				add: (ScintillaIndicatorStyle new name: #SpyEnabled; styleName: #roundBox; forecolor: 16r0000FF);
				add: (ScintillaIndicatorDefinition new name: #SpyDisabled; styleName: #roundBox; forecolor: 16r777777);
				yourself)]!

silentlyRemoveSpy

	self methodSpyManager removeSpy: self currentSpy!

spyInsertNode

	^self spyInsertNodeIn: self unmodifiedParseTree!

spyInsertNodeIn: parseTree

	| targetPos targetNodes targetNode |

	parseTree isNil ifTrue: [^nil].

	targetPos := self selectionRange start.

	targetNodes := OrderedCollection new.
	parseTree nodesDo: [ :each | each isSpyable ifTrue: [targetNodes add: each]]. 
	targetNodes isEmpty ifTrue: [^nil].

	targetPos <= parseTree body start
	ifTrue:
		[targetNode := targetNodes first]
	ifFalse: 
		[targetNode := 
			(targetNodes asSortedCollection: [ :n1 :n2 | n1 sourceInterval size <= n2 sourceInterval size])
				detect: [ :each | each sourceInterval includes: targetPos] 
				ifNone: 
					[(targetNodes asSortedCollection: [ :n1 :n2 | n1 start <= n2 start])
						detect: [ :each | each start >= targetPos] 
						ifNone: [nil]]].

	^targetNode!

spySubmenu 

	^Menu fromStrings: 
		#(	'Method Spies'
			'Insert Spy...//insertSpy'
			'Edit Spy...//editSpy'
			'Enabled//toggleSpy'
			'Inspect Spy//inspectSpy'
			'Reset Spy//resetSpy'
			'Remove Spy//removeSpy'
			'-'
			'Remove All Spies//removeAllSpies')!

text: aString

	super text: aString.

	self selectedMethod ifNotNil: [ :meth | meth isSpy ifTrue: [self autoParse]]!

toggleSpy

	self currentSpy toggleLocallyEnabled.
	self methodSpyManager spyChangedIn: self selectedMethod!

unmodifiedParseTree

	^self selectedMethod parseTree! !
!SSWMethodWorkspace categoriesFor: #additionalAccelerators!accessing!private! !
!SSWMethodWorkspace categoriesFor: #createSchematicWiring!initializing!public! !
!SSWMethodWorkspace categoriesFor: #currentSpy!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #highlightCompilationErrors:!helpers!public! !
!SSWMethodWorkspace categoriesFor: #highlightCurrentSpy!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #highlightMethodSpies:in:!helpers!public! !
!SSWMethodWorkspace categoriesFor: #highlightSpyInsertPositionRange!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #insertBreak!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #insertOrEditSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #insertSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #inspectSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #isCurrentlyAtSpy!private!testing! !
!SSWMethodWorkspace categoriesFor: #isSpyEnabled!private!testing! !
!SSWMethodWorkspace categoriesFor: #methodSpyManager!accessing!private! !
!SSWMethodWorkspace categoriesFor: #onMethodSpyChanged!event handling!private! !
!SSWMethodWorkspace categoriesFor: #onMethodSpyChangedIn:!event handling!public! !
!SSWMethodWorkspace categoriesFor: #onViewOpened!event handling!public! !
!SSWMethodWorkspace categoriesFor: #queryCommand:!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #querySpyCommandSymbol:!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #quickInsertSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #removeAllSpies!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #removeSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #resetSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #safeRecompile:!helpers!public! !
!SSWMethodWorkspace categoriesFor: #setIndicatorsForSpies!helpers!public! !
!SSWMethodWorkspace categoriesFor: #silentlyRemoveSpy!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #spyInsertNode!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #spyInsertNodeIn:!helpers:spies!public! !
!SSWMethodWorkspace categoriesFor: #spySubmenu!accessing!public! !
!SSWMethodWorkspace categoriesFor: #text:!accessing!public! !
!SSWMethodWorkspace categoriesFor: #toggleSpy!commands:spies!public! !
!SSWMethodWorkspace categoriesFor: #unmodifiedParseTree!accessing!private! !

!SSWMethodWorkspace class methodsFor!

new

	^self superNew!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ScintillaView) 98 50 0 0 98 2 8 1445007684 1 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 21 265030 4 ##(Smalltalk.Menu) 0 16 98 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #accept 8 '&Accept' 1 1 0 0 0 594 1 626 8 #reformatAccept 8 'Ref&ormat/Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 546 0 16 98 0 8 'Auto-&correct' 8 #autoCorrectMenu 134217729 0 0 0 0 0 546 0 16 98 16 594 1 626 8 #renameNode 8 'Re&name <1d>...' 1 1 0 0 0 754 4097 594 1 626 8 #extractToTemporary 8 'Extract to &Temporary...' 1 1 0 0 0 594 1 626 8 #extractMethod 8 'E&xtract Method...' 1 1 0 0 0 594 1 626 8 #extractToComponent 8 'Extract to &Component...' 1 5 0 0 0 754 4097 594 1 626 8 #inlineMessage 8 'Inline &Message' 1 1 0 0 0 546 0 16 98 0 8 'Impl&ement Message In' 8 #implementMessageMenu 134217729 0 0 0 0 0 754 4097 594 1 626 8 #inlineTemporary 8 '&Inline Temporary' 1 1 0 0 0 594 1 626 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 0 0 0 594 1 626 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 754 4097 594 1 626 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 594 1 626 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 594 1 626 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Refactorin&gs' 8 #codeRefactoringsMenu 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refactoring.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 0 0 546 0 16 98 2 594 1 626 8 #reformatSource 8 '&Source' 1 1 0 0 0 594 1 626 8 #reformatComment 8 '&Comment' 1 1 0 0 0 8 'Re&format' 8 #reformatMenu 1 0 0 0 0 0 754 4097 546 0 16 98 8 594 1 626 8 #undo 8 '&Undo' 1 1 1746 0 16 1792 8 'EditUndo.ico' 1840 0 0 754 4097 594 1 626 8 #cutSelection 8 'Cu&t' 1 1 1746 0 16 1792 8 'EditCut.ico' 1840 0 0 594 1 626 8 #copySelection 8 '&Copy' 1 1 1746 0 16 1792 8 'EditCopy.ico' 1840 0 0 594 1 626 8 #pasteClipboard 8 '&Paste' 1 1 1746 0 16 1792 8 'EditPaste.ico' 1840 0 0 594 1 626 8 #clearSelection 8 'De&lete' 1 1 1746 0 16 1792 8 'EditClear.ico' 1840 0 0 754 4097 594 1 626 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 546 0 16 98 10 594 1 626 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 594 1 626 8 #cloneNew 8 'Clo&ne' 1 1 1746 0 16 1792 8 'SmalltalkWorkspace.ico' 1840 0 0 754 4097 594 1 626 8 #toggleAutoCompletion 8 'Auto-complete' 1 1 0 0 0 594 1 626 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 594 1 626 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 594 1 626 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 594 1 626 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 594 1 626 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 594 1 626 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 'Wor&kspace' 0 134217729 0 0 0 0 0 754 4097 594 1 626 8 #browseIt 8 'Bro&wse It' 1 1 1746 0 16 1792 8 'ClassBrowserShell.ico' 1840 0 0 594 1 626 8 #displayIt 8 '&Display It' 1 1 1746 0 16 1792 8 'DisplayIt.ico' 1840 0 0 594 1 626 8 #evaluateIt 8 'E&valuate It' 1 1 1746 0 16 1792 8 'EvaluateIt.ico' 1840 0 0 594 1 626 8 #inspectIt 8 '&Inspect It' 1 1 1746 0 16 1792 8 'InspectIt.ico' 1840 0 0 594 1 626 8 #debugIt 8 'Deb&ug It' 1 1 1746 0 16 1792 8 'Debugger.ico' 1840 0 0 754 4097 546 0 16 98 4 594 2097153 626 8 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 0 0 0 594 1 626 8 #browseReferences 8 '&References to <1d>' 1 1 0 0 0 754 4097 594 1 626 8 #browseMessage 8 '<1d>' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294905355 852486 ##(Smalltalk.NullConverter) 0 0 9 0 234 256 98 4 8 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 4240 0 0 0 8 #callTip 4258 77 786694 ##(Smalltalk.IndexedColor) 33554457 4322 33554471 1 0 0 0 0 4288 0 0 0 98 40 4272 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 32 202 208 98 0 234 256 98 2 8 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 8 #circle 0 0 0 0 0 0 202 208 4432 0 63 9215 0 0 0 0 4322 33554447 0 0 65 0 0 234 256 98 6 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 #literalBytes 8 '[]' 8 '' 3 234 256 98 2 8 #container 4208 0 0 0 0 3 0 234 256 98 6 8 #Notification 1510470 2 ##(Smalltalk.ScintillaIndicatorStyle) 17 416 33554437 11 32 4800 0 0 0 0 0 0 8 #Error 4818 21 416 33554459 3 32 4848 0 0 0 0 0 0 8 #Warning 4818 19 416 33554465 3 32 4880 0 0 0 0 0 0 0 0 234 256 98 6 4800 4258 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 4800 0 0 0 4848 4258 1031 4962 335 4962 31317503 1 0 0 0 0 4848 0 0 0 4880 4258 1027 4962 60239 4962 31326207 1 0 0 0 0 4880 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 13 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 4935 21 5218 641 441 416 5154 8 #contextMenu: 98 1 560 416 5154 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 416 5154 8 #isTextModified: 98 1 32 416 5154 8 #modificationEventMask: 98 1 9215 416 5154 8 #hoverTime: 98 1 1001 416 5154 8 #secondaryCaretForecolor: 98 1 4962 16711423 416 5154 8 #caretPeriod: 98 1 1061 416 5154 8 #wordWrap: 98 1 16 416 5154 8 #margins: 98 1 98 3 984902 1 ##(Smalltalk.ScintillaMargin) 1 416 1 3 32 1 15 5762 3 416 1 1 32 67108863 15 5762 5 416 1 1 32 1 15 416 5154 8 #backspaceUnindents: 98 1 16 416 5154 8 #tabIndents: 98 1 16 416 5154 8 #areAdditionalCaretsVisible: 98 1 16 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 163 9 0 0 10 0 0 0 227 10 0 0 230 0 0 0] 98 0 5218 193 193 0 29 )! !
!SSWMethodWorkspace class categoriesFor: #new!instance creation!public! !
!SSWMethodWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

