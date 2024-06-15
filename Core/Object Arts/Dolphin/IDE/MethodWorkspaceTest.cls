"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #MethodWorkspaceTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MethodWorkspaceTest guid: (GUID fromString: '{e5dadb09-1b76-4a90-a763-95cc11d735d8}')!

MethodWorkspaceTest comment: ''!

!MethodWorkspaceTest categoriesForClass!Unclassified! !

!MethodWorkspaceTest methodsFor!

classToTest
	"Although we want to test MethodWorkspace, it has to be created within a MethodBrowser to give it context."

	^MethodBrowser!

testSelectedOrNearestNode
	| env workspace node |
	env := BrowserEnvironment new forClass: MethodWorkspace selectors: #(#selectedNode).
	presenter methods: env.
	presenter selectMethod: env allMethods first.
	self waitForInputIdle.
	workspace := presenter sourcePresenter.
	workspace selectionRange: (1 to: 0).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (1 to: 1).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (2 to: 1).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (22 to: 21).
	node := workspace selectedNode.
	self assert: node isMethod.
	workspace selectionRange: (221 to: 220).
	node := workspace selectedNode.
	self assert: node isVariable!

viewClass
	^ScintillaView! !

!MethodWorkspaceTest categoriesForMethods!
classToTest!helpers!private! !
testSelectedOrNearestNode!public! !
viewClass!constants!private! !
!

!MethodWorkspaceTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ScintillaView)  98 46 0 0 98 2 8 1445007684 1 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 17 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #accept 8 '&Accept' 1 1 0 0 0 594 1 626 8 #reformatAccept 8 'Ref&ormat/Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 546 0 16 98 0 8 'Auto-&correct' 8 #autoCorrectMenu 134217729 0 0 0 0 0 546 0 16 98 16 594 1 626 8 #renameNode 8 'Re&name <1d>...' 1 1 0 0 0 754 4097 594 1 626 8 #extractToTemporary 8 'Extract to &Temporary...' 1 1 0 0 0 594 1 626 8 #extractMethod 8 'E&xtract Method...' 1 1 0 0 0 594 1 626 8 #extractToComponent 8 'Extract to &Component...' 1 5 0 0 0 754 4097 594 1 626 8 #inlineMessage 8 'Inline &Message' 1 1 0 0 0 546 0 16 98 0 8 'Impl&ement Message In' 8 #implementMessageMenu 134217729 0 0 0 0 0 754 4097 594 1 626 8 #inlineTemporary 8 '&Inline Temporary' 1 1 0 0 0 594 1 626 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 0 0 0 594 1 626 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 754 4097 594 1 626 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 594 1 626 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 594 1 626 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Refactorin&gs' 8 #codeRefactoringsMenu 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'Refactoring.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 0 0 546 0 16 98 2 594 1 626 8 #reformatSource 8 '&Source' 1 1 0 0 0 594 1 626 8 #reformatComment 8 '&Comment' 1 1 0 0 0 8 'Re&format' 8 #reformatMenu 1 0 0 0 0 0 754 4097 546 0 16 98 8 594 1 626 8 #undo 8 '&Undo' 1 1 1746 0 16 1792 8 'EditUndo.ico' 1840 0 0 754 4097 594 1 626 8 #cutSelection 8 'Cu&t' 1 1 1746 0 16 1792 8 'EditCut.ico' 1840 0 0 594 1 626 8 #copySelection 8 '&Copy' 1 1 1746 0 16 1792 8 'EditCopy.ico' 1840 0 0 594 1 626 8 #pasteClipboard 8 '&Paste' 1 1 1746 0 16 1792 8 'EditPaste.ico' 1840 0 0 594 1 626 8 #clearSelection 8 'De&lete' 1 1 1746 0 16 1792 8 'EditClear.ico' 1840 0 0 754 4097 594 1 626 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 546 0 16 98 10 594 1 626 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 594 1 626 8 #cloneNew 8 'Clo&ne' 1 1 1746 0 16 1792 8 'SmalltalkWorkspace.ico' 1840 0 0 754 4097 594 1 626 8 #toggleAutoCompletion 8 'Auto-complete' 1 1 0 0 0 594 1 626 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 594 1 626 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 594 1 626 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 594 1 626 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 594 1 626 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 594 1 626 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 'Wor&kspace' 0 134217729 0 0 0 0 0 754 4097 594 1 626 8 #browseIt 8 'Bro&wse It' 1 1 1746 0 16 1792 8 'ClassBrowserShell.ico' 1840 0 0 594 1 626 8 #displayIt 8 '&Display It' 1 1 1746 0 16 1792 8 'DisplayIt.ico' 1840 0 0 594 1 626 8 #evaluateIt 8 'E&valuate It' 1 1 1746 0 16 1792 8 'EvaluateIt.ico' 1840 0 0 594 1 626 8 #inspectIt 8 '&Inspect It' 1 1 1746 0 16 1792 8 'InspectIt.ico' 1840 0 0 594 1 626 8 #debugIt 8 'Deb&ug It' 1 1 1746 0 16 1792 8 'Debugger.ico' 1840 0 0 754 4097 546 0 16 98 4 594 2097153 626 8 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 0 0 0 594 1 626 8 #browseReferences 8 '&References to <1d>' 1 1 0 0 0 754 4097 594 1 626 8 #browseMessage 8 '<1d>' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294909145 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 2 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 4240 0 0 0 98 40 4272 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler)  1 0 0 32 202 208 98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 4450 33554471 416 8 #circle 202 208 4352 0 63 9215 0 0 0 0 4450 33554447 0 0 0 0 0 234 256 98 6 8 #literalBytes 8 '[]' 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 8 #container 4208 0 0 0 0 3 0 234 256 98 6 8 #Notification 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 416 33554437 11 32 4768 0 8 #Error 4786 21 416 33554459 3 32 4816 0 8 #Warning 4786 19 416 33554465 3 32 4848 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 11 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3359 21 5010 641 441 416 4946 8 #contextMenu: 98 1 560 416 4946 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 4946 8 #isTextModified: 98 1 32 416 4946 8 #modificationEventMask: 98 1 9215 416 4946 8 #hoverTime: 98 1 1001 416 4946 8 #wordWrap: 98 1 16 416 4946 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 416 1 3 32 1 5442 3 416 1 1 32 67108863 5442 5 416 1 1 32 1 416 4946 8 #backspaceUnindents: 98 1 16 416 4946 8 #indentationGuides: 98 1 0 416 4946 8 #tabIndents: 98 1 16 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 207 7 0 0 230 0 0 0] 98 0 5010 193 193 0 27 )! !

!MethodWorkspaceTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
!

