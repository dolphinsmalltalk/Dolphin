"Filed out from Dolphin Smalltalk 7"!

SmalltalkToolShell subclass: #StsMethodEditionsBrowserShell
	instanceVariableNames: 'classObject methodSelector editionsList sourcePresenter'
	classVariableNames: ''
	poolDictionaries: 'CompilerFlags'
	classInstanceVariableNames: ''!
StsMethodEditionsBrowserShell guid: (GUID fromString: '{8162EDC9-0FB8-11D4-B091-000000000000}')!
StsMethodEditionsBrowserShell comment: ''!
!StsMethodEditionsBrowserShell categoriesForClass!Unclassified! !
!StsMethodEditionsBrowserShell methodsFor!

accept
	| method methodEdition |
	method := self saveMethodInClass: editionsList selectionOrNil first.
	
	[| selectionIndex |
	methodEdition := method isNil ifFalse: [self sourceControl getVersionInfoFor: method].
	self refresh.
	editionsList view refreshContents.
	selectionIndex := editionsList list findFirst: [:each | each = methodEdition edition].
	editionsList selectionByIndex: (Array with: selectionIndex) ifAbsent: []] 
			forkAt: Processor userBackgroundPriority!

canSaveMethod
	^self selectedMethod notNil and: [self selectedMethod methodClass notNil]!

createComponents
	super createComponents.
	editionsList := self 
				add: ListPresenter new
				name: 'editionsList'
				helpId: 10976.
	sourcePresenter := self add: MethodWorkspace new name: 'sourcePresenter'!

createSchematicWiring
	super createSchematicWiring.
	editionsList
		when: #selectionChanged
			send: #onEditionSelected
			to: self;
		when: #actionPerformed
			send: #onDoubleClicked
			to: self!

defaultHelpId
	^10904!

hasEditableMethodSelected
	^self selectedMethod notNil!

hasRefactorableMethodSelected
	^self hasEditableMethodSelected!

inspectEditionsUsing
	(self sourceControl packageNames: self sourceControl getAllPackageNames
		usingMethodEdition: editionsList selection first) inspect!

loadSelectedEdition
	| selectedEditions |
	(selectedEditions := editionsList selectionOrNil) first load.
	editionsList view refreshContents.
	editionsList selection: selectedEditions!

menuCompareMethodEditions
	(StsMethodComparisonShell create)
		setMethod1: editionsList selectionOrNil first method2: editionsList selectionOrNil last;
		showShell!

onDoubleClicked
	| me compiledMethod |
	((me := self selectedMethod) isNil or: [me methodClass isNil]) ifTrue: [^self].
	compiledMethod := me methodClass compiledMethodAt: me selector ifAbsent: [].
	compiledMethod isNil ifTrue: [me methodClass browse] ifFalse: [compiledMethod browse]!

onEditionSelected
	| selectedEditions text |
	selectedEditions := editionsList selectionOrNil.
	text := String new asRichText.
	selectedEditions notEmpty 
		ifTrue: 
			[sourcePresenter ensureVisible.
			text := selectedEditions first source.
			(classObject isKindOf: Behavior) 
				ifTrue: [sourcePresenter evaluationContext: classObject instanceClass]].
	sourcePresenter text: text!

onViewOpened
	super onViewOpened.
	editionsList setFocus
	"sourcePresenter view isReadOnly: true."!

parseContext
	^self selectedMethod ifNotNil: [:method | method methodClass]!

queryCommand: query 
	| selector selectedEditions |
	selector := query commandSymbol.
	(#(#accept #loadSelectedEdition) includes: selector) 
		ifTrue: 
			[query isEnabled: ((selectedEditions := editionsList selectionOrNil) notNil 
						and: [selectedEditions size = 1 and: [selectedEditions first methodClass notNil]]).
			^true].
	selector == #menuCompareMethodEditions 
		ifTrue: 
			[query isEnabled: ((selectedEditions := editionsList selectionOrNil) notNil 
						and: [selectedEditions size = 2]).
			^true].
	selector == #inspectEditionsUsing 
		ifTrue: 
			[query isEnabled: ((selectedEditions := editionsList selectionOrNil) notNil 
						and: [selectedEditions size = 1]).
			^true].
	^super queryCommand: query!

refresh
	| editions existingCompiledMethod realClass |
	editions := self sourceControl getMethodEditions: methodSelector class: classObject.
	realClass := classObject class == Symbol 
				ifTrue: [Smalltalk at: classObject ifAbsent: []]
				ifFalse: [classObject].
	existingCompiledMethod := realClass isNil 
				ifFalse: [realClass compiledMethodAt: methodSelector ifAbsent: []].
	(existingCompiledMethod notNil and: [(editions detect: [:each | each isLoaded] ifNone: []) isNil]) 
		ifTrue: 
			[editions addFirst: (self sourceControl getMethodEditionFor: existingCompiledMethod
						in: self sourceControl databaseConnection newLongReadOnlyTransaction)].
	editionsList list: editions.
	self caption: 'Editions of ' , methodSelector printString , ' in ' 
				, (classObject class == Symbol ifTrue: [classObject] ifFalse: [classObject name]) asString!

saveMethodInClass: selectedMethodEdition 
	| newMethodEdition source modified |
	modified := sourcePresenter isModified.
	sourcePresenter
		clearErrors;
		isModified: false.
	source := sourcePresenter plainText.
	
	[newMethodEdition := selectedMethodEdition methodClass compile: source
				categories: selectedMethodEdition categories] 
			on: CompilerNotification
			do: [:cn | sourcePresenter compilerNotification: cn offset: 0].
	newMethodEdition isNil ifTrue: [sourcePresenter isModified: modified].
	^newMethodEdition!

saveNewMethod: methodSource 
	| modified originalSelection change newMethod selectedMethod methodClass |
	selectedMethod := self selectedMethod.
	(methodClass := selectedMethod methodClass) isNil ifTrue: [^nil].
	originalSelection := sourcePresenter selectionRange.
	modified := sourcePresenter isModified.
	sourcePresenter
		clearErrors;
		isModified: false.
	
	[change := self systemModel 
				compile: methodSource
				in: methodClass
				categories: selectedMethod categories
				package: nil
				extraFlags: Interactive] 
			on: CompilerNotification
			do: [:cn | sourcePresenter compilerNotification: cn offset: 0].
	newMethod := change ifNotNil: [change method].
	newMethod 
		ifNil: 
			["If the compilation fails we must restore the modified flag"
			sourcePresenter isModified: modified]
		ifNotNil: [self selectLoadedEdition].
	(sourcePresenter showFirstError: 0) 
		ifFalse: [sourcePresenter view selectionRange: originalSelection].
	^newMethod!

selectedMethod
	| selection |
	^((selection := editionsList selectionOrNil) isNil or: [selection isEmpty]) 
		ifFalse: [selection first]!

selectLoadedEdition
	| editions existingCompiledMethod realClass |
	editions := self sourceControl getMethodEditions: methodSelector class: classObject.
	realClass := classObject class == Symbol 
				ifTrue: [Smalltalk at: classObject ifAbsent: []]
				ifFalse: [classObject].
	existingCompiledMethod := realClass isNil 
				ifFalse: [realClass compiledMethodAt: methodSelector ifAbsent: []].
	(existingCompiledMethod notNil and: [(editions detect: [:each | each isLoaded] ifNone: []) isNil]) 
		ifTrue: 
			[editions addFirst: (self sourceControl getMethodEditionFor: existingCompiledMethod
						in: self sourceControl databaseConnection newLongReadOnlyTransaction)].
	editionsList
		list: editions;
		selection: (Array with: (editions detect: [:each | each isLoaded] ifNone: [])).
	self caption: 'Editions of ' , methodSelector printString , ' in ' 
				, (classObject class == Symbol ifTrue: [classObject] ifFalse: [classObject name]) asString!

setClass: aClass selector: aSymbol 
	classObject := aClass.
	methodSelector := aSymbol.
	self refresh! !
!StsMethodEditionsBrowserShell categoriesFor: #accept!public! !
!StsMethodEditionsBrowserShell categoriesFor: #canSaveMethod!public! !
!StsMethodEditionsBrowserShell categoriesFor: #createComponents!private! !
!StsMethodEditionsBrowserShell categoriesFor: #createSchematicWiring!private! !
!StsMethodEditionsBrowserShell categoriesFor: #defaultHelpId!public! !
!StsMethodEditionsBrowserShell categoriesFor: #hasEditableMethodSelected!public!testing! !
!StsMethodEditionsBrowserShell categoriesFor: #hasRefactorableMethodSelected!private!refactoring!testing! !
!StsMethodEditionsBrowserShell categoriesFor: #inspectEditionsUsing!commands!public!testing! !
!StsMethodEditionsBrowserShell categoriesFor: #loadSelectedEdition!private! !
!StsMethodEditionsBrowserShell categoriesFor: #menuCompareMethodEditions!private! !
!StsMethodEditionsBrowserShell categoriesFor: #onDoubleClicked!commands!public!testing! !
!StsMethodEditionsBrowserShell categoriesFor: #onEditionSelected!private! !
!StsMethodEditionsBrowserShell categoriesFor: #onViewOpened!private! !
!StsMethodEditionsBrowserShell categoriesFor: #parseContext!public! !
!StsMethodEditionsBrowserShell categoriesFor: #queryCommand:!private! !
!StsMethodEditionsBrowserShell categoriesFor: #refresh!private! !
!StsMethodEditionsBrowserShell categoriesFor: #saveMethodInClass:!private! !
!StsMethodEditionsBrowserShell categoriesFor: #saveNewMethod:!private! !
!StsMethodEditionsBrowserShell categoriesFor: #selectedMethod!public! !
!StsMethodEditionsBrowserShell categoriesFor: #selectLoadedEdition!private! !
!StsMethodEditionsBrowserShell categoriesFor: #setClass:selector:!public! !

!StsMethodEditionsBrowserShell class methodsFor!

displayOn: aStream 
	aStream nextPutAll: 'Method Editions Browser'!

icon
	^StsMethodEdition icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ShellView) 98 27 0 0 98 2 27131905 131073 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 551 0 0 0 416 788230 ##(Smalltalk.BorderLayout) 1 1 410 8 ##(Smalltalk.Toolbar) 98 25 0 416 98 2 8 1140851500 131137 560 0 482 512 0 519 0 263174 ##(Smalltalk.Font) 0 16 459014 ##(Smalltalk.LOGFONT) 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 228 196 71 1 0 0 204 53 71 1 2 0 20 59 0 0 0 0 255 0 5 86 119 1] 328198 ##(Smalltalk.Point) 193 193 0 560 482 512 8 4294903529 234 256 98 4 410 8 ##(Smalltalk.ReferenceView) 98 14 0 560 98 2 8 1140850688 131073 832 0 0 0 7 0 0 0 832 1180166 ##(Smalltalk.ResourceIdentifier) 576 8 #resource_Smalltalk_tools 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 63 1 738 991 51 832 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 31 0 0 0 0 0 0 0 14 2 0 0 25 0 0 0] 98 0 738 193 193 0 27 8 'smalltalkTools' 410 848 98 14 0 560 98 2 8 1140850688 131073 1216 0 0 0 7 0 0 0 1216 914 576 8 #resource_Image_tools 0 962 202 208 98 1 1026 1056 98 2 738 1 1 738 63 51 1216 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 31 0 0 0 25 0 0 0] 1168 1184 0 27 8 'imageTools' 234 256 1168 98 0 234 240 1168 0 1 0 738 33 31 738 45 45 0 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1249 51 560 1026 8 #updateSizePosted 1168 560 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 25 0 0 0] 98 2 1216 832 1184 0 27 410 8 ##(Smalltalk.StatusBar) 98 18 0 416 98 2 8 1140850956 1 1776 0 721158 ##(Smalltalk.SystemColor) 31 0 7 0 658 0 16 690 8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 215 4 228 196 71 1 0 0 204 53 71 1 6 0 20 59 0 0 0 0 255 0 5 86 119 1] 738 193 193 0 1776 0 8 4294905391 234 256 98 2 853766 ##(Smalltalk.StatusBarItem) 1 -1 1776 0 8 ##(Smalltalk.BasicListAbstract) 8 ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) 8 'errors' 202 208 98 1 2016 1115142 ##(Smalltalk.StatusBarNullItem) 513 1 1776 0 0 962 202 208 98 1 1026 1056 98 2 738 1 799 738 1249 45 1776 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 143 1 0 0 112 2 0 0 165 1 0 0] 98 0 1184 0 27 0 0 410 8 ##(Smalltalk.ContainerView) 98 15 0 416 98 2 8 1140850688 131073 2336 0 482 512 0 7 0 0 0 2336 1180166 ##(Smalltalk.ProportionalLayout) 234 240 98 2 410 8 ##(Smalltalk.MultipleSelectionListView) 98 30 0 2336 98 2 8 1140936777 1025 2496 590662 2 ##(Smalltalk.ListModel) 202 208 1168 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 482 512 0 7 265030 4 ##(Smalltalk.Menu) 0 16 98 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) 8 #refresh 8 'Upda&te List' 1 1 0 0 0 2722 1 2754 8 #loadSelectedEdition 8 '&Load Edition' 1 1 0 0 0 2722 1 2754 8 #menuCompareMethodEditions 8 '&Compare Editions' 1 1 0 0 0 2722 1 2754 8 #inspectEditionsUsing 8 'Inspect Editions &Using' 1 1 0 0 0 8 '' 0 1 0 0 0 0 0 0 0 2496 0 8 4294909021 2032 2048 2080 0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn) 8 '' 1241 8 #left 2032 8 ##(Smalltalk.SortedCollection) 0 0 2496 0 3 0 0 8 #report 1168 0 133217 0 98 1 0 962 202 208 98 2 1026 1056 98 2 738 1 1 738 1249 369 2496 1026 8 #contextMenu: 98 1 2688 2496 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 112 2 0 0 184 0 0 0] 98 0 1184 0 27 3 16 234 256 98 4 2496 8 'editionsList' 410 848 98 14 0 2336 98 2 8 1140916224 131073 3440 0 0 0 23 0 0 0 3440 914 8 ##(Smalltalk.MethodWorkspace) 8 #resource_Default_view 0 962 202 208 98 1 1026 1056 98 2 738 1 379 738 1249 371 3440 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 189 0 0 0 112 2 0 0 118 1 0 0] 1168 1184 0 27 8 'sourcePresenter' 0 962 202 208 98 1 1026 1056 98 2 738 1 51 738 1249 749 2336 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 25 0 0 0 112 2 0 0 143 1 0 0] 98 3 2496 410 8 ##(Smalltalk.Splitter) 98 12 0 2336 98 2 8 1140850688 1 3872 0 482 512 0 519 0 0 0 3872 962 202 208 98 1 1026 1056 98 2 738 1 369 738 1249 11 3872 1122 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 184 0 0 0 112 2 0 0 189 0 0 0] 98 0 1184 0 27 3440 1184 0 27 234 256 98 2 560 8 'toolbar' 0 461638 4 ##(Smalltalk.MenuBar) 0 16 98 6 2674 0 16 98 8 2722 1 2754 8 #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) 0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'FileNew.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 2722 1 2754 8 #fileOpen 8 '&Open...' 9375 1 4322 0 16 4368 8 'FileOpen.ico' 4416 0 0 2722 1 2754 8 #fileFileIn 8 '&File In...' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 2722 1 2754 8 #saveImage 8 'Sa&ve Image' 1 1 4322 0 16 4368 8 'Snapshot.ico' 4416 0 0 2722 1 2754 8 #smalltalkExit 8 'E&xit Dolphin' 1 1 4322 0 16 4368 8 'PowerSwitch.ico' 4416 0 0 4610 4097 2722 1 2754 8 #exit 8 '&Close' 17639 1 4322 0 16 4368 8 'CloseWindow.ico' 4416 0 0 8 '&File' 0 134217729 0 0 42431 0 0 2674 0 16 98 13 2722 1 2754 8 #undo 8 '&Undo' 9397 1 4322 0 16 4368 8 'EditUndo.ico' 4416 0 0 4610 4097 2722 1 2754 8 #cutSelection 8 'Cu&t' 9393 1 4322 0 16 4368 8 'EditCut.ico' 4416 0 0 2722 1 2754 8 #copySelection 8 '&Copy' 9351 1 4322 0 16 4368 8 'EditCopy.ico' 4416 0 0 2722 1 2754 8 #pasteClipboard 8 '&Paste' 9389 1 4322 0 16 4368 8 'EditPaste.ico' 4416 0 0 2722 1 2754 8 #editDelete 8 '&Delete' 1 1 4322 0 16 4368 8 'EditClear.ico' 4416 0 0 2674 0 16 98 2 2722 1 2754 8 #reformatSource 8 '&Source' 9391 1 0 0 0 2722 1 2754 8 #reformatComment 8 '&Comment' 9367 1 0 0 0 8 'Ref&ormat' 0 134217729 0 0 42447 0 0 4610 4097 2722 1 2754 8 #selectAll 8 'Select &All' 9347 1 0 0 0 4610 4097 2722 1 2754 8 #editFind 8 '&Find...' 9357 1 4322 0 16 4368 47 786694 ##(Smalltalk.ShellLibrary) 0 0 2722 1 2754 8 #findNext 8 'Find &Next' 1253 1 4322 0 16 4368 8 'FindNext.ico' 4416 0 0 2722 1 2754 8 #findReplace 8 '&Replace...' 9361 1 0 0 0 8 '&Edit' 0 134217729 0 0 42457 0 0 2674 0 16 98 16 2722 1 2754 8 #browseIt 8 '&Browse It' 9349 1 4322 0 16 4368 8 'ClassBrowserShell.ico' 4416 0 0 2722 1 2754 8 #displayIt 8 '&Display It' 9353 1 4322 0 16 4368 8 'DisplayIt.ico' 4416 0 0 2722 1 2754 8 #evaluateIt 8 '&Evaluate It' 9355 1 4322 0 16 4368 8 'EvaluateIt.ico' 4416 0 0 2722 1 2754 8 #inspectIt 8 '&Inspect It' 9363 1 4322 0 16 4368 8 'InspectIt.ico' 4416 0 0 2722 1 2754 8 #debugIt 8 'Deb&ug It' 1269 1 4322 0 16 4368 8 'Debugger.ico' 4416 0 0 2722 1 2754 8 #fileItIn 8 'Fi&le It In' 1 1 0 0 0 4610 4097 2722 1 2754 8 #browseDefinitions 8 'Defi&nitions' 1271 1 0 0 0 2722 1 2754 8 #browseReferences 8 '&References' 5367 1 0 0 0 4610 4097 2722 2097153 2754 8 #accept 8 '&Accept' 9383 1 0 0 0 2722 1 2754 8 #reformatAccept 8 'Refor&mat/Accept' 13479 1 0 0 0 4610 4097 2674 0 16 98 14 2722 1 2754 8 #renameVariable 8 'Re&name <1d>...' 1 1 0 0 0 4610 4097 2722 1 2754 8 #extractToTemporary 8 'Extract to &Temporary...' 9385 1 0 0 0 2722 1 2754 8 #extractMethod 8 'E&xtract Method...' 9371 1 0 0 0 2722 1 2754 8 #extractToComponent 8 'Extract to &Component...' 1 1 0 0 0 2722 1 2754 8 #inlineMessage 8 'Inline &Message' 13467 1 0 0 0 4610 4097 2722 1 2754 8 #inlineTemporary 8 '&Inline Temporary' 13481 1 0 0 0 2722 1 2754 8 #moveTempToInnerScope 8 'Move to Inner &Scope' 9655 1 0 0 0 2722 1 2754 8 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 4610 4097 2722 1 2754 8 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 2722 1 2754 8 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 2722 1 2754 8 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Re&factorings' 8 #codeRefactoringsMenu 134217729 4322 0 16 4368 8 'Refactoring.ico' 4416 0 42501 0 0 4610 4097 2674 0 16 98 7 2722 1 2754 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 2722 1 2754 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 2722 1 2754 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 2722 1 2754 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 2722 1 2754 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 2722 1 2754 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 2722 1 2754 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 '&Options' 0 134217729 0 0 42517 0 0 8 '&Workspace' 0 134217729 0 0 42519 0 0 2674 0 16 98 0 8 '&Tools' 8 #toolsMenu 1 0 0 42521 0 0 2674 0 16 98 0 8 'Wi&ndow' 8 #windowMenu 134217729 0 0 42523 0 0 2674 0 16 98 15 2722 1 2754 8 #helpContents 8 '&Contents' 1025 1 4322 0 16 4368 49 5856 0 0 2722 1 2754 8 #help 8 'On this &Tool' 1249 1 0 0 0 2722 1 2754 8 #helpWhatsThis 8 'What''s This?' 5345 1 0 0 0 4610 4097 2722 1 2754 8 #learnSmalltalk 8 'Learn Smalltalk' 1 1 0 0 0 4610 4097 2722 1 2754 8 #helpWhatsNew 8 'What''s &New' 1 1 0 0 0 2722 1 2754 8 #helpGuidedTour 8 '&Guided Tour' 1 1 0 0 0 2722 1 2754 8 #helpTutorials 8 'Tutorials' 1 1 0 0 0 4610 4097 2722 1 2754 8 #objectArtsHomePage 8 'Object Arts Homepage' 1 1 0 0 0 2722 1 2754 8 #dolphinNewsgroup 8 'Dolphin Newsgroup/Forum' 1 1 0 0 0 2722 1 2754 8 #dolphinWikiWeb 8 'Dolphin WikiWeb' 1 1 0 0 0 4610 4097 2722 1 2754 8 #aboutDolphin 8 '&About Dolphin Smalltalk' 1 1 4322 0 16 4368 8 '!!APPLICATION' 4416 0 0 8 '&Help' 0 134217729 0 0 42547 0 0 8 '' 0 1 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 962 202 208 98 3 1026 1056 98 2 738 3839 21 738 1281 961 416 1026 8 #text: 98 1 8 'Method Editions Browser' 416 1026 8 #updateMenuBar 1168 416 1122 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 255 9 0 0 234 1 0 0] 98 3 560 2336 1776 1184 0 27 )! !
!StsMethodEditionsBrowserShell class categoriesFor: #displayOn:!public! !
!StsMethodEditionsBrowserShell class categoriesFor: #icon!public! !
!StsMethodEditionsBrowserShell class categoriesFor: #resource_Default_view!public!resources-views! !

