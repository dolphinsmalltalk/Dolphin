"Filed out from Dolphin Smalltalk 2000 release 4.01"!

CodeTool subclass: #BrowserTextTool
	instanceVariableNames: 'changed originalText savedText menu undoManager selectionManager'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BrowserTextTool comment: ''!

BrowserTextTool guid: (GUID fromString: '{A8B6C1BE-0E73-11D5-B80B-000102677BBF}')!

!BrowserTextTool categoriesForClass!Unclassified! !
!BrowserTextTool methodsFor!

abstractClassVar: aString 
	self performRefactoring: (AbstractClassVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString))!

abstractInstVar: aString 
	self 
		performRefactoring: (AbstractInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString))!

accept
	self subclassResponsibility
!

altKeyPress: aCallData 
	aCallData keysym == XKBackSpace ifTrue: [self undo]
!

browseInstVarReaders
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarReadersTo: name in: self selectedClass]!

browseInstVarRefs
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarRefsTo: name in: self selectedClass]!

browseInstVarWriters
	| name |
	name := self selectedVariableName.
	name notNil 
		ifTrue: [self navigator browseGlobalInstVarWritersTo: name in: self selectedClass]!

buildInterfaceIn: aWidget 
	| textWidget breakpointWidget |
	self addWidget: (textWidget := aWidget createScrolledText: 'text'
						argBlock: 
							[:w | 
							w
								editMode: XmMULTILINEEDIT;
								scrollHorizontal: false;
								wordWrap: true;
								tabSpacing: EmTextCompatibilityFilter tabSize])
		named: #text.
	textWidget manageChild.
	self addWidget: (breakpointWidget := DbgTagWidget 
						createWidget: 'breakpoints'
						parent: aWidget
						argBlock: 
							[:w | 
							w
								fontStruct: (self class fontList isNil 
											ifTrue: [CgDisplay default defaultFontStruct]
											ifFalse: [self class fontList fontStruct]);
								verticalScrollBar: textWidget parent verticalScrollBar;
								width: 10;
								textWidget: textWidget;
								disabled: System image breakpointManager breakpointsEnabled not;
								leftAttachment: XmATTACHFORM;
								topAttachment: XmATTACHFORM;
								bottomAttachment: XmATTACHFORM])
		named: #breakpoints.
	breakpointWidget manageChild.
	textWidget parent setValuesBlock: 
			[:w | 
			w
				leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHFORM;
				topAttachment: XmATTACHFORM].
	"	tagWidget menu: self breakMenu owner: self."!

cancelText
	self text: originalText!

changedText
	changed := true.
	self hideBreakpoints!

compilerError: error 
	| widget errorPos |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^self].
	errorPos := error startPosition - 1 + widget getSelectionPosition x max: 0.
	widget setInputFocus;
		insertAndShow: errorPos value: error message;
		setSelection: errorPos @ (errorPos + error message size)!

configureBreakpoint: selectedBreakpoint 
	| breakpointWidget |
	breakpointWidget := self widgetAt: #breakpoints.
	breakpointWidget notNil 
		ifTrue: [breakpointWidget selectBreakpoint: selectedBreakpoint notify: true].
	self showWaitCursorWhile: 
			[| prompter |
			prompter := DbgBreakpointPrompter new.
			prompter breakpoint: selectedBreakpoint.
			prompter prompt notNil 
				ifTrue: 
					[prompter clearBreakpoint 
						ifTrue: [selectedBreakpoint clear]
						ifFalse: 
							[(selectedBreakpoint 
								setTriggerExpression: prompter triggerExpression
								process: prompter process
								iteration: prompter triggerIteration
								resetIterationsCounter: prompter resetIterationsCounter) 
									ifTrue: 
										[prompter deactivateBreakpoint 
											ifTrue: [selectedBreakpoint deactivate].
										prompter activateBreakpoint 
											ifTrue: [selectedBreakpoint activate]]
									ifFalse: 
										[self 
											warn: 'The trigger expression didn''t compile. No settings were changed.']]]].
	^selectedBreakpoint!

createAccessorsForClassVar: aString 
	self performRefactoring: (CreateAccessorsForVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString)
				classVariable: true)!

createAccessorsForInstVar: aString 
	self performRefactoring: (CreateAccessorsForVariableRefactoring 
				variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString)
				classVariable: false)!

ctrlKeyPress: aCallData 
	(aCallData keysym == XKf or: [aCallData keysym == XKF]) 
		ifTrue: [self insertString: 'ifFalse:'].
	(aCallData keysym == XKt or: [aCallData keysym == XKT]) 
		ifTrue: [self insertString: 'ifTrue:'].
	(aCallData keysym == XKs or: [aCallData keysym == XKS]) 
		ifTrue: [self accept].
	(aCallData keysym == XKq or: [aCallData keysym == XKQ]) 
		ifTrue: [self inspectIt].
	(aCallData keysym == XKd or: [aCallData keysym == XKD]) 
		ifTrue: [self printIt].
	(aCallData keysym == XKe or: [aCallData keysym == XKE]) 
		ifTrue: [self doIt].
	(aCallData keysym == XKa or: [aCallData keysym == XKA]) 
		ifTrue: [self selectAll].
	(aCallData keysym == XKBackSpace 
		and: [(aCallData state bitAnd: Mod1Mask) == Mod1Mask]) ifTrue: [self redo]
!

doIt
	self evaluateSelectionIfFail: []!

doItReceiver
	"Answer the object that should be informed of the result of evaluating a
	text selection."

	^self nonMetaClass!

doubleSelectBreakpointTag: tagWidget clientData: textWidget callData: selectedBreakpoint 
	selectedBreakpoint notNil 
		ifTrue: [self configureBreakpoint: selectedBreakpoint]!

editItems
	^#('Add Breakpoint')!

enableMenu
	| collection interval |
	interval := self selectedInterval.
	collection := OrderedCollection new.
	interval isEmpty ifTrue: [collection addAll: self noSelectionItems].
	self isEditing 
		ifTrue: 
			[collection addAll: self editItems.
			self isEnabled ifFalse: [collection add: 'Accept']]
		ifFalse: [collection addAll: self noEditItems].
	collection addAll: self otherMenuItems.
	menu enableAllExcept: collection!

evaluate: text ifFail: aBlock
	| result |
	result := Compiler evaluate: text
				for: self doItReceiver
				ifFail: 
					[:error | 
					self compilerError: error.
					^aBlock value].
	System logEvaluate: text.
	^result!

evaluateSelectionIfFail: aBlock
	| text textWidget |
	textWidget := self widgetAt: #text.
	textWidget isNil ifTrue: [^aBlock value].
	text := self selectedText.
	text isEmpty ifTrue: [^aBlock value].
	^self evaluate: text ifFail: aBlock!

findReplace
	| textWidget |
	(textWidget := self widgetAt: #text) setInputFocus.
	(CwTextSearchDialog for: textWidget) mwmInputMode: MWMINPUTMODELESS;
		open!

hideBreakpoints
	| breakpoints |
	breakpoints := self widgetAt: #breakpoints.
	(breakpoints isNil or: [breakpoints isManaged]) ifFalse: [^self].
	(self widgetAt: #text) parent setValuesBlock: 
			[:w | 
			w
				leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHFORM;
				topAttachment: XmATTACHFORM].
	breakpoints unmanageChild!

initialize
	super initialize.
	menu := nil.
	changed := false.
"rbDmm 
this code is VA gui specific
	menu := self initializeMenu: self class menu.
	menu executeBeforeStartup: [self enableMenu].
	changed := false
"!

initializeMenu: aMenu
	| options selectors |
	options := #(#copySelection #cut #paste).
	selectors := #(#copySelection #cutSelection #paste).
	aMenu
		values: (aMenu values collect: 
					[:each | 
					| index |
					index := options indexOf: each ifAbsent: [nil].
					index notNil
						ifTrue: [[(self widgetAt: #text) perform: (selectors at: index)]]
						ifFalse: [each]]).
	^super initializeMenu: aMenu!

insertError: aString at: position 
	| widget |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^self].
	widget
		setInputFocus;
		insertAndShow: position - 1 value: aString , ' ->';
		setSelection: (position - 1) @ (position + 2 + aString size)!

insertString: aString 
	| widget selection |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^self].
	selection := widget hasSelection 
				ifTrue: [widget getSelectionPosition]
				ifFalse: [widget cursorPosition @ widget cursorPosition].
	widget 
		replace: selection x
		toPos: selection y
		value: aString
!

inspectIt
	(self evaluateSelectionIfFail: [^self]) inspect!

isEditing
	^changed!

isEnabled
	^true!

isText
	^true!

keyboardAccept
	(self isEditing and: [self isEnabled]) ifTrue: [self accept]
!

keyPress: aCallData 
	(aCallData state bitAnd: ControlMask) == ControlMask 
		ifTrue: [^self ctrlKeyPress: aCallData].
	(aCallData state bitAnd: Mod1Mask) == Mod1Mask 
		ifTrue: [self altKeyPress: aCallData]
!

menu
	^menu!

noEditItems
	^#('Accept' 'Cancel')!

noSelectionItems
	^#('Do It' 'Print It' 'Inspect It')!

otherMenuItems
	^#()!

performRefactoring: aRefactoring 
	aRefactoring isNil ifTrue: [^self].
	self handleError: 
			[aRefactoring execute.
			codeModel navigate.
			self updateContents]!

postBuild
	| textWidget breakpointWidget |
	super postBuild.
	self hideBreakpoints.
	textWidget := self widgetAt: #text.
	breakpointWidget := self widgetAt: #breakpoints.
	(selectionManager := CwSmalltalkTextSelectionManager for: textWidget) 
		connect.
	textWidget
		addCallback: XmNvalueChangedCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #changedText;
		addEventHandler: KeyPressMask
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #keyPress:.
	self schedulePopUpMenu: self menu for: textWidget.
	undoManager := (CwTextUndoManager for: (self widgetAt: #text))
				connect;
				yourself.

	(textWidget parent verticalScrollBar)
		addCallback: XmNvalueChangedCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		addCallback: XmNdragCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		addCallback: XmNpageIncrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		addCallback: XmNpageDecrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		addCallback: XmNincrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		addCallback: XmNdecrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget.

	breakpointWidget
		addCallback: #singleSelectionCallback
			receiver: self
			selector: #singleSelectBreakpointTag:clientData:callData:
			clientData: textWidget;
		addCallback: #doubleSelectionCallback
			receiver: self
			selector: #doubleSelectBreakpointTag:clientData:callData:
			clientData: textWidget!

printIt
	| result widget start |
	result := self evaluateSelectionIfFail: [^self].
	widget := self widgetAt: #text.
	(widget isNil or: [widget isDestroyed]) ifTrue: [^self].
	start := widget getSelectionPosition y.
	widget insertAndShow: start value: ' ' , result printString;
		setSelection: start @ widget getInsertionPosition!

protectInstVar: aString 
	self 
		performRefactoring: (ProtectInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString))!

pushUpClassVar: aString 
	self performRefactoring: (PullUpClassVariableRefactoring 
				variable: aString asSymbol
				class: (self nonMetaClass whichClassDefinesClassVar: aString) superclass)!

pushUpInstVar: aString 
	self 
		performRefactoring: (PullUpInstanceVariableRefactoring variable: aString
				class: (self selectedClass whichClassDefinesInstVar: aString) superclass)!

redo
	undoManager redo!

releaseCallbacks
	| textWidget breakpointWidget |
	textWidget := self widgetAt: #text.
	breakpointWidget := self widgetAt: #breakpoints.
	textWidget isNil ifTrue: [^self].
	undoManager disconnect.
	selectionManager disconnect.
	textWidget
		removeAllCallbacks: XmNvalueChangedCallback;
		removeEventHandler: KeyPressMask
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #keyPress:.
	self unschedulePopUpMenu: self menu for: textWidget.

	(textWidget parent verticalScrollBar)
		removeCallback: XmNvalueChangedCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		removeCallback: XmNdragCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		removeCallback: XmNpageIncrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		removeCallback: XmNpageDecrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		removeCallback: XmNincrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget;
		removeCallback: XmNdecrementCallback
			receiver: self
			selector: #processCallback:clientData:callData:
			clientData: #updateBreakpointWidget.

	breakpointWidget
		removeCallback: #singleSelectionCallback
			receiver: self
			selector: #singleSelectBreakpointTag:clientData:callData:
			clientData: textWidget;
		removeCallback: #doubleSelectionCallback
			receiver: self
			selector: #doubleSelectBreakpointTag:clientData:callData:
			clientData: textWidget!

renameClassVar: aString 
	self navigator renameClassVar: aString asSymbol
		in: (self nonMetaClass whichClassDefinesClassVar: aString).
	self updateContents!

renameInstVar: aString 
	self navigator renameInstVar: aString
		in: (self selectedClass whichClassDefinesInstVar: aString).
	self updateContents!

saveState
	savedText := self text. 
!

selectAll
	| widget |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^self].
	widget setSelection: 0 @ widget value size!

selectedEnvyItem
	| class selector |
	class := self nonMetaClass.
	class isNil ifTrue: [^self application].
	selector := self selector.
	^selector isNil
		ifTrue: [self protocol isNil
				ifTrue: [class]
				ifFalse: [nil]]
		ifFalse: [self selectedClass compiledMethodAt: selector ifAbsent: [nil]]!

selectedEnvyItems
	| classes methods |
	classes := self nonMetaClasses.
	classes isEmpty ifTrue: [^self applications].
	methods := self methods.
	^methods isEmpty
		ifTrue: [self protocol isNil ifTrue: [classes] ifFalse: [#()]]
		ifFalse: [methods]!

selectedInterval
	| widget point |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^1 to: 0].
	point := widget getSelectionPosition.
	^point x + 1 to: point y!

selectedText
	| widget selection |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^''].
	selection := widget getSelection.
	^selection isNil ifTrue: [''] ifFalse: [selection]!

selectedVariableName
	"Guess the variable name from the selection"

	^self selectedText!

showBreakpoints
	| breakpoints |
	breakpoints := self widgetAt: #breakpoints.
	(breakpoints isNil or: [breakpoints isManaged not]) ifFalse: [^self].
	breakpoints manageChild.
	((self widgetAt: #text) parent)
		setValuesBlock: 
				[:w | 
				w
					leftAttachment: XmATTACHWIDGET;
					leftWidget: breakpoints;
					rightAttachment: XmATTACHFORM;
					bottomAttachment: XmATTACHFORM;
					topAttachment: XmATTACHFORM];
		redraw!

singleSelectBreakpointTag: tagWidget clientData: textWidget callData: selectedBreakpoint 
	selectedBreakpoint notNil 
		ifTrue: 
			[| positions |
			(positions := selectedBreakpoint sourcePositions) notNil 
				ifTrue: [(self widgetAt: #text) setSelection: (positions x - 1) @ positions y]]!

targetTextWidget

	^self widgetAt: #text!

text
	^(self widgetAt: #text) value!

text: aString 
	self textNoChange: aString.
	originalText := aString.
	changed := false!

textNoChange: aString 
	| widget |
	widget := self widgetAt: #text.
	widget isNil ifTrue: [^self].
	widget setString: aString!

undo
	undoManager undo!

updateBreakpointWidget
	| scrollBar newOffset breakpointWidget |
	breakpointWidget := self widgetAt: #breakpoints.
	breakpointWidget isManaged ifFalse: [^self].
	scrollBar := (self widgetAt: #text) parent verticalScrollBar.
	newOffset := scrollBar value - scrollBar minimum.
	breakpointWidget offset ~= newOffset ifTrue: [breakpointWidget redraw]!

updateDisplay
	| isChanged |
	isChanged := changed.
	savedText notNil ifTrue: 
			[self textNoChange: savedText.
			savedText := nil].
	changed := isChanged!

updateRequest
	^super updateRequest and: 
			[self isEditing not or: 
					[self
						confirm: 'The text showing has been altered.<n>Do you wish to discard those changes?'
								expandMacros]]
! !
!BrowserTextTool categoriesFor: #abstractClassVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #abstractInstVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #accept!*-subclass responsibility!*-unclassified!public! !
!BrowserTextTool categoriesFor: #altKeyPress:!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #browseInstVarReaders!*-unclassified!public! !
!BrowserTextTool categoriesFor: #browseInstVarRefs!*-unclassified!public! !
!BrowserTextTool categoriesFor: #browseInstVarWriters!*-unclassified!public! !
!BrowserTextTool categoriesFor: #buildInterfaceIn:!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #cancelText!*-unclassified!public! !
!BrowserTextTool categoriesFor: #changedText!*-unclassified!public! !
!BrowserTextTool categoriesFor: #compilerError:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #configureBreakpoint:!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #createAccessorsForClassVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #createAccessorsForInstVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #ctrlKeyPress:!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #doIt!*-unclassified!public! !
!BrowserTextTool categoriesFor: #doItReceiver!*-unclassified!private! !
!BrowserTextTool categoriesFor: #doubleSelectBreakpointTag:clientData:callData:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #editItems!*-unclassified!public! !
!BrowserTextTool categoriesFor: #enableMenu!*-unclassified!private! !
!BrowserTextTool categoriesFor: #evaluate:ifFail:!*-compilation failures!*-unclassified!private! !
!BrowserTextTool categoriesFor: #evaluateSelectionIfFail:!*-unclassified!private! !
!BrowserTextTool categoriesFor: #findReplace!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #hideBreakpoints!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #initialize!*-unclassified!public! !
!BrowserTextTool categoriesFor: #initializeMenu:!*-unclassified!private! !
!BrowserTextTool categoriesFor: #insertError:at:!*-unclassified!private! !
!BrowserTextTool categoriesFor: #insertString:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #inspectIt!*-unclassified!public! !
!BrowserTextTool categoriesFor: #isEditing!*-unclassified!public! !
!BrowserTextTool categoriesFor: #isEnabled!*-unclassified!public! !
!BrowserTextTool categoriesFor: #isText!*-unclassified!public! !
!BrowserTextTool categoriesFor: #keyboardAccept!*-unclassified!public! !
!BrowserTextTool categoriesFor: #keyPress:!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #menu!*-unclassified!public! !
!BrowserTextTool categoriesFor: #noEditItems!*-unclassified!private! !
!BrowserTextTool categoriesFor: #noSelectionItems!*-unclassified!private! !
!BrowserTextTool categoriesFor: #otherMenuItems!*-unclassified!private! !
!BrowserTextTool categoriesFor: #performRefactoring:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #postBuild!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #printIt!*-unclassified!public! !
!BrowserTextTool categoriesFor: #protectInstVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #pushUpClassVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #pushUpInstVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #redo!*-unclassified!public! !
!BrowserTextTool categoriesFor: #releaseCallbacks!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #renameClassVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #renameInstVar:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #saveState!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectAll!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectedEnvyItem!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectedEnvyItems!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectedInterval!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectedText!*-unclassified!public! !
!BrowserTextTool categoriesFor: #selectedVariableName!*-unclassified!public! !
!BrowserTextTool categoriesFor: #showBreakpoints!*-compilation failures!*-unclassified!public! !
!BrowserTextTool categoriesFor: #singleSelectBreakpointTag:clientData:callData:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #targetTextWidget!*-unclassified!public! !
!BrowserTextTool categoriesFor: #text!*-unclassified!public! !
!BrowserTextTool categoriesFor: #text:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #textNoChange:!*-unclassified!public! !
!BrowserTextTool categoriesFor: #undo!*-unclassified!public! !
!BrowserTextTool categoriesFor: #updateBreakpointWidget!*-unclassified!public! !
!BrowserTextTool categoriesFor: #updateDisplay!*-unclassified!public! !
!BrowserTextTool categoriesFor: #updateRequest!*-unclassified!public! !

!BrowserTextTool class methodsFor!

menu
	^MenuHolder
		fromSpec: #(#('&Find' '&Replace' '&Find/Replace...' nil '&Undo' 'Redo' nil '&Copy' 'Cu&t' '&Paste' nil '&Do It' 'Pri&nt It' '&Inspect It' nil '&Accept' 'Cancel' nil 'Print') #(#find #replace #findReplace nil #undo #redo nil #copySelection #cut #paste nil #doIt #printIt #inspectIt nil #accept #cancelText nil #hardcopy))! !
!BrowserTextTool class categoriesFor: #menu!*-compilation failures!*-unclassified!public! !

