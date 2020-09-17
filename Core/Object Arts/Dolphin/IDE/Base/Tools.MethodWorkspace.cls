"Filed out from Dolphin Smalltalk 7"!

Tools.SmalltalkWorkspace subclass: #'Tools.MethodWorkspace'
	instanceVariableNames: 'parseTree refactoringTool'
	classVariableNames: 'AutoParseDwell IsAutoParseEnabled'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'AutoParseMask' -> 16r100000
	}!
Tools.MethodWorkspace guid: (Core.GUID fromString: '{d7285d4c-35b2-4b52-a673-2e17fde39fec}')!
Tools.MethodWorkspace comment: 'MethodWorkspace is a specialised <SmalltalkWorkspace> for displaying method source that expects to be contained in a <MethodBrowser>.

MethodWorkspace maintains a parse tree for the current method that allows it to offer syntax-directed browsing, editing, and (in DPRO) refactoring commands. For example the widenSourceSelection command can be used to expand the selection to encompass the syntactic element containing the currently selected syntactic element (or the syntactic element under the caret if there is no selection).

Instance Variables:
	methodAST		<StMethodNode>. Root of the parse tree.
	refactoringTool	<CodeRefactoringTool>, or nil if not running DPRO.

Class Variables:
	AutoCompleteDwell				<integer>. Number of milliseconds delay before auto-completion list displayed after typing.
	IsAutoCompletionCaseInsensitive	<boolean>. Choice and selection of auto-completion candidates case insensitive?
	IsAutoCompletionEnabled		<boolean>. Automatic display of completion list when typing?
	IsAutoCompletionSpaceAdded	<boolean>. Completion inserts a space if needed before next word?
	IsAutoCompletionTruncating		<boolean>. Word completion by selection from list truncates trailing characters of token?
	KeywordCompletions				<LookupTable>. Common keyword selector completion templates.
	StandardUnaryReturnTypes		<LookupTable>. Return types of common unary messages.

'!
!Tools.MethodWorkspace categoriesForClass!MVP-Presenters! !
!Tools.MethodWorkspace methodsFor!

accept
	"Save the method source, updating the existing method or adding a new one depending on
	whether the user has edited the method signature."

	parentPresenter saveNewMethod: self source!

addToCommandRoute: route 
	"Update the <OrderedCollection>, path, with the receiver's contribution to the command path
	held by the <CommandPolicy>, route. Answer the next <Presenter> to visit. The receiver is
	guaranteed not to be on the command path already. Implementation Note: We add our method
	refactoring tool to the command route."

	refactoringTool notNil ifTrue: [route appendTarget: refactoringTool].
	^super addToCommandRoute: route!

allDefinedVariablesDo: aMonadicValuable 
	self parseTree 
		ifNotNil: [:ast | ast allDefinedVariableNodesDo: [:each | aMonadicValuable value: each name]]!

autoParse
	self textLength > 0 ifFalse: [^self].
	
	[| ast |
	ast := self parseTree.
	BrowserSemanticAnalyser
		analyzeParseTree: ast
		for: ast methodNode methodClass
		context: self evaluationContext
		pools: self allPools
		onError: nil]
			on: Parser notificationClass
			do: 
				[:err |
				"err toTrace"
				compilationErrors addLast: err.
				err resume].
	self highlightCompilationErrors: 0.
	self errorModel isNil ifTrue: [^self].
	self errorModel value: self firstError!

browseDefinitionsCommand
	"Private - Browse definitions of the object identified by the node under the cursor, or
	failing that prompt for a selector and open a method browser displaying the implementors of
	that selector."

	self selectedNode
		ifNotNil: 
			[:node |
			(self selectorFromNode: node)
				ifNil: 
					[node isVariable
						ifTrue: 
							[(self variableClassification: node) == #classGlobal
								ifTrue: 
									[^Message selector: #browseClass:
										argument: (self parseContext environment fullBindingFor: node name) value]]]
				ifNotNil: 
					[:selector |
					^Message selector: #browseDefinitionsOfSelector:in: arguments: {selector. self searchEnvironment}]].
	^super browseDefinitionsCommand!

browseMessage
	| node |
	node := self selectedMessageNode.
	self systemModel browseMethod: ((self targetOfMessage: node) lookupMethod: node selector)!

browseReferencesCommand
	"Private - Prompt for a selector and open a method browser displaying the references to that
	selector."

	self selectedNode
		ifNotNil: 
			[:node |
			(self selectorFromNode: node)
				ifNil: 
					[node isVariable
						ifTrue: 
							[| varClass |
							varClass := self variableClassification: node.
							(varClass == #classGlobal or: [varClass == #global])
								ifTrue: 
									[^Message selector: #browseVariableReferences:in:
										arguments: {self parseContext environment fullBindingFor: node name. self searchEnvironment}]]]
				ifNotNil: 
					[:literal |
					^Message selector: #browseReferencesToLiteral:in: arguments: {literal. self searchEnvironment}]].
	^super browseReferencesCommand!

buildParseTree
	| methodClass |
	methodClass := self parseContext ?? ProtoObject.
	self clearErrors.
	self selectedMethod
		ifNotNil: 
			[:method |
			method isExpression
				ifTrue: [^Parser parseExpression: method getSource in: methodClass]].
	^[self parseSourceIn: methodClass] on: Compiler notificationClass
		do: 
			[:err |
			compilationErrors addLast: err.
			err resume]!

canSaveMethod
	^self isReadOnly not and: [parentPresenter canSaveMethod and: [self textLength > 0]]!

clear
	"Remove all contents in the receiver's view"

	super clear.
	self clearParseTree!

clearParseTree
	"Private - Set the parse tree cache for the current method to the DeafObject to distinguish
	the case where the method has not yet been parsed from the case where the method failed to
	compile (in which case methodAST will have the value nil)."

	parseTree := DeafObject current.
	self resetParseTimer!

contextBindingFor: aString 
	self allPools do: [:each | (each bindingFor: aString) ifNotNil: [:binding | ^binding]].
	^nil!

createComponents
	"Create the presenters contained by the receiver. At this stage the receiver has not yet
	been initialized."

	super createComponents.
	refactoringTool := self systemModel newCodeRefactoringToolFor: self!

createSchematicWiring
	"Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self
		when: #textChanged
			send: #onTextChanged
			to: self;
		when: #updateUI:
			send: #onUpdateUI:
			to: self!

defaultStylerClass
	^SmalltalkMethodStyler!

evaluationContext
	"Answers the evaluation context for this workspace."

	^evaluationContext ifNil: [self parseContext ifNotNil: [:class | class instanceClass]]!

formattedCode: anStProgramNode
	^anStProgramNode formattedCode!

hasErrors
	"Answer whether there are any errors in the source code (not warnings)"

	^self parseTree isNil or: [super hasErrors]!

initialize
	super initialize.
	self isAutoParseEnabled: self class isAutoParseEnabled!

isAutoParseEnabled
	^flags allMask: AutoParseMask!

isAutoParseEnabled: aBoolean 
	flags := flags mask: AutoParseMask set: aBoolean!

isEditable
	^super isEditable and: [parentPresenter hasEditableMethodSelected]!

isTempVariable: anStVariableNode 
	"Private - Answer whether the specified variable node represents one of the temporaries in
	the current method (note that parameters are included)."

	self parseTree allDefinedVariableNodesDo: [:each | each = anStVariableNode ifTrue: [^true]].
	^false!

killParseTimer
	self view killTimer: 1000!

lineFromPosition: anInteger 
	^view lineFromPosition: anInteger!

method
	Notification deprecated.
	^self selectedMethod!

nameBindingContext
	^evaluationContext ifNil: [self parseContext ?? Smalltalk] ifNotNil: [:context | context basicClass]!

nodeForRange: anInterval 
	^self parseTree 
		ifNotNil: 
			[:tree | 
			| node |
			node := tree whichNodeIsContainedBy: anInterval.
			node isNil ifTrue: [node := tree bestNodeFor: anInterval].
			node]!

onAboutToDisplayMenu: aMenu 
	"The system is about to display the <Menu> argument this is our chance to fiddle with it."

	super onAboutToDisplayMenu: aMenu.
	refactoringTool notNil ifTrue: [^refactoringTool onAboutToDisplayMenu: aMenu]!

onTextChanged
	"The text in the receiver's view has been changed. Clear cached information."

	self clearParseTree!

onTimerTick: anInteger 
	anInteger == 1000 ifFalse: [^super onTimerTick: anInteger].
	self killParseTimer.
	self isAutoParseEnabled ifTrue: [self autoParse]!

onUpdateUI: anSCNotification

	anSCNotification updated == 16r2 "SC_UPDATE_SELECTION" 
		ifTrue: [self selectionChanged].
!

parseContext
	^parentPresenter ifNotNil: [:p | p parseContext]!

parseSourceIn: methodClass
	^Parser parseMethod: self source in: methodClass!

parseTree
	parseTree == DeafObject current ifTrue: [parseTree := self buildParseTree].
	^parseTree!

promptToSaveChanges
	^parentPresenter promptToSaveChanges!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver into the
	<CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	#reformatMenu == selector
		ifTrue: 
			[aCommandQuery isEnabled: self isReadOnly not.
			^true].
	(#(#accept #reformatAccept) identityIncludes: selector)
		ifTrue: 
			[aCommandQuery isEnabled: self canSaveMethod.
			^true].
	#reformatSource == selector
		ifTrue: 
			[aCommandQuery isEnabled: (self isReadOnly not and: [self textLength > 0]).
			^true].
	(#(#browseDefinitions #browseReferences) identityIncludes: selector)
		ifTrue: 
			[| message |
			message := self selectedMessage.
			aCommandQuery
				isEnabled: true;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {message ?? '...'}
							locale: Locale smalltalk).
			^true].
	#browseMessage == selector
		ifTrue: 
			[| text node |
			node := self selectedMessageNode.
			(node isNil or: 
					[| target |
					target := self targetOfMessage: node.
					target isNil or: [(text := target lookupMethod: node selector) isNil]])
				ifTrue: 
					[aCommandQuery isEnabled: false.
					text := 'Message']
				ifFalse: [aCommandQuery isEnabled: true].
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {text}
						locale: Locale smalltalk).
			^true].
	^super queryCommand: aCommandQuery!

reformatAccept
	self reformattedSource ifNotNil: [:aString | parentPresenter saveNewMethod: aString]!

reformatSource
	"Reformat and syntax colour the current contents of the method source pane, but do not
	accept it."

	| formatted |
	self hasSelection ifTrue: [^super reformatSource].
	formatted := self reformattedSource.
	(formatted notNil and: [formatted ~= self source]) ifFalse: [^self].
	self clearParseTree.
	"Use the target for replacement to avoid any visible selection"
	view
		targetAll;
		replaceTarget: formatted!

reformattedSource
	| ast |
	ast := self parseTree.
	^(compilationErrors detect: [:each | each severityClass == Error] ifNone: []) 
		ifNil: [self formattedCode: ast]
		ifNotNil: 
			[:ex | 
			self showError: ex offset: 0.
			nil]!

repositionAtSourceLine: anInteger 
	anInteger <= view lineCount ifFalse: [^self].
	self caretPosition: (view positionAtLine: anInteger).
	"Moves caret to the first non-whitespace on the line"
	view moveToVcHome!

resetParseTimer
	self
		killParseTimer;
		setParseTimer!

resolveIdentifier: aString ifDefined: aMonadicValuable
	| methodClass |
	methodClass := self parseContext.
	methodClass ifNil: [^nil].
 	"In the debugger will have an evaluation context which is the receiver."
	(self evaluationContext isKindOf: methodClass)
		ifTrue: 
			[
			aString = 'self' ifTrue: [^aMonadicValuable value: self evaluationContext].
			(self contextBindingFor: aString) ifNotNil: [:var | ^aMonadicValuable value: var value].
			(methodClass indexOfInstVar: aString ifAbsent: [])
				ifNotNil: [:i | ^aMonadicValuable value: (self evaluationContext instVarAt: i)]].
	(methodClass fullBindingFor: aString)
		ifNotNil: [:binding | binding value ifNotNil: [:value | ^aMonadicValuable value: value]].
	^nil!

selectedErrorRange
	^self selectedNode sourceInterval!

selectedMessage
	#todo.	"Handle case of selected node being method signature"
	^self selectedNode
		ifNotNil: 
			[:node |
			node isMessage
				ifTrue: [node selector]
				ifFalse: [(node isLiteralNode and: [node value isKindOf: Symbol]) ifTrue: [node value]]]!

selectedMessageNode
	^self selectedNode ifNotNil: [:node | node isMessage ifTrue: [node]]!

selectedMethod
	^parentPresenter ifNotNil: [:p | p selectedMethod]!

selectedNode
	"Answer an <StProgramNode> to represent the syntactic element which is currently selected,
	or which is under the caret."

	| range |
	range := self selectionRange.
	range isEmpty ifTrue: [range := range start to: range start].
	^(self nodeForRange: range) ifNil: [self parseTree]!

selectionChanged
	"The receiver highlights all text matching <view selection>"

	view identifyTextMatchingSelectionWithStyleName: #secondarySelection.!

selectorFromNode: aStProgramNode
	^aStProgramNode isMessage
		ifTrue: [aStProgramNode selector]
		ifFalse: 
			[(aStProgramNode isLiteralNode and: [aStProgramNode value isKindOf: Symbol])
				ifTrue: [aStProgramNode value]]!

selfClass
	^evaluationContext
		ifNil: [self parseContext ?? UndefinedObject]
		ifNotNil: [:context | context basicClass]!

setParseTimer
	self view setTimer: 1000 interval: self class autoParseDwell!

source
	^self plainText!

source: aString 
	self
		text: aString;
		isModified: true!

targetOfMessage: aStMessageNode
	| receiver |
	receiver := aStMessageNode receiver.
	receiver isVariable
		ifTrue: 
			[receiver isSpecialVariable ifTrue: [^receiver valueClassIn: self parseContext].
			^self resolveIdentifier: receiver name ifDefined: [:value | value basicClass]]
		ifFalse: [receiver isLiteralNode ifTrue: [^aStMessageNode receiver value basicClass]].
	^nil!

variableClassification: anStVariableNode 
	| class |
	(anStVariableNode notNil and: [anStVariableNode isVariable]) ifFalse: [^nil].
	(self isTempVariable: anStVariableNode) ifTrue: [^#temporary].
	class := self parseContext.
	(class allInstVarNames includes: anStVariableNode name) ifTrue: [^#instance].
	(class bindingFor: anStVariableNode name) ifNotNil: [^#class].
	(class environment fullBindingFor: anStVariableNode name) 
		ifNotNil: 
			[:var | 
			^(var value basicClass isMeta and: [var value name == var key]) ifTrue: [#classGlobal] ifFalse: [#global]].
	"Variable name not found in this context"
	^nil!

widenSourceSelection
	"Expand the selection to encompass the next greater syntactic element."

	| node |
	node := self selectedNode.
	
	[node isNil
		ifTrue: 
			[Sound warningBeep.
			^self].
	self selectionRange = node sourceInterval]
			whileTrue: [node := node parent].
	self selectionRange: node sourceInterval! !
!Tools.MethodWorkspace categoriesFor: #accept!commands!public! !
!Tools.MethodWorkspace categoriesFor: #addToCommandRoute:!commands!public! !
!Tools.MethodWorkspace categoriesFor: #allDefinedVariablesDo:!autocompletion!enumerating!private! !
!Tools.MethodWorkspace categoriesFor: #autoParse!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #browseDefinitionsCommand!commands!private! !
!Tools.MethodWorkspace categoriesFor: #browseMessage!commands!public! !
!Tools.MethodWorkspace categoriesFor: #browseReferencesCommand!commands!private! !
!Tools.MethodWorkspace categoriesFor: #buildParseTree!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #canSaveMethod!commands!private! !
!Tools.MethodWorkspace categoriesFor: #clear!operations!public! !
!Tools.MethodWorkspace categoriesFor: #clearParseTree!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #contextBindingFor:!private!refactoring! !
!Tools.MethodWorkspace categoriesFor: #createComponents!initializing!public! !
!Tools.MethodWorkspace categoriesFor: #createSchematicWiring!initializing!public! !
!Tools.MethodWorkspace categoriesFor: #defaultStylerClass!constants!private! !
!Tools.MethodWorkspace categoriesFor: #evaluationContext!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #formattedCode:!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #hasErrors!public!testing! !
!Tools.MethodWorkspace categoriesFor: #initialize!initializing!private! !
!Tools.MethodWorkspace categoriesFor: #isAutoParseEnabled!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #isAutoParseEnabled:!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #isEditable!private!testing! !
!Tools.MethodWorkspace categoriesFor: #isTempVariable:!private!refactoring! !
!Tools.MethodWorkspace categoriesFor: #killParseTimer!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #lineFromPosition:!enquiries!public! !
!Tools.MethodWorkspace categoriesFor: #method!accessing!private! !
!Tools.MethodWorkspace categoriesFor: #nameBindingContext!accessing!autocompletion!private! !
!Tools.MethodWorkspace categoriesFor: #nodeForRange:!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #onAboutToDisplayMenu:!event handling!public! !
!Tools.MethodWorkspace categoriesFor: #onTextChanged!event handling!public! !
!Tools.MethodWorkspace categoriesFor: #onTimerTick:!event handling!public! !
!Tools.MethodWorkspace categoriesFor: #onUpdateUI:!event handling!public! !
!Tools.MethodWorkspace categoriesFor: #parseContext!accessing!private! !
!Tools.MethodWorkspace categoriesFor: #parseSourceIn:!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #parseTree!accessing!private! !
!Tools.MethodWorkspace categoriesFor: #promptToSaveChanges!helpers!public! !
!Tools.MethodWorkspace categoriesFor: #queryCommand:!commands!private! !
!Tools.MethodWorkspace categoriesFor: #reformatAccept!commands!public! !
!Tools.MethodWorkspace categoriesFor: #reformatSource!commands!public! !
!Tools.MethodWorkspace categoriesFor: #reformattedSource!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #repositionAtSourceLine:!operations!public! !
!Tools.MethodWorkspace categoriesFor: #resetParseTimer!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #resolveIdentifier:ifDefined:!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #selectedErrorRange!accessing!private!refactoring! !
!Tools.MethodWorkspace categoriesFor: #selectedMessage!accessing!private! !
!Tools.MethodWorkspace categoriesFor: #selectedMessageNode!accessing!private!refactoring! !
!Tools.MethodWorkspace categoriesFor: #selectedMethod!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #selectedNode!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #selectionChanged!event handling!public! !
!Tools.MethodWorkspace categoriesFor: #selectorFromNode:!commands!private! !
!Tools.MethodWorkspace categoriesFor: #selfClass!autocompletion!private! !
!Tools.MethodWorkspace categoriesFor: #setParseTimer!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #source!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #source:!accessing!public! !
!Tools.MethodWorkspace categoriesFor: #targetOfMessage:!commands!private!refactoring! !
!Tools.MethodWorkspace categoriesFor: #variableClassification:!helpers!private! !
!Tools.MethodWorkspace categoriesFor: #widenSourceSelection!commands!public! !

!Tools.MethodWorkspace class methodsFor!

autoParseDwell
	"Answer the <integer> number of milliseconds that must elapse after the user stops typing
	before an attempt is made to pro-actively parse the method source for errors."

	^AutoParseDwell!

autoParseDwell: anInteger
	"Set the <integer> number of milliseconds that must elapse after the user stops typing
	before an attempt is made to pro-actively parse the method source for errors."

	AutoParseDwell := anInteger!

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions to be bound to the receiver's commands.
	Each element of the collection should be a two element <Array>, the first element of which is the command symbol
	and the second the accelerator key string."

	^super defaultAdditionalAccelerators copyWith: #(#widenSourceSelection 'Ctrl+U')!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	AutoParseDwell := 1000.
	IsAutoParseEnabled := true!

isAutoParseEnabled
	"Answer whether the method source will be automatically parsed after the user has paused for a short while."

	^IsAutoParseEnabled!

isAutoParseEnabled: aBoolean
	IsAutoParseEnabled := aBoolean!

resource_Debugger_source
	"Answer the literal data from which the 'Debugger source' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Debugger_source)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Scintilla.ScintillaView) 34 50 nil nil 34 2 8 1445007684 262145 416 nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 461638 4 ##(UI.Menu) nil true 34 22 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 562 1 594 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 562 1 594 #acceptNoRestart 8 'Accept &No Restart' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 562 1 594 #runToCursor 8 '&Run to Cursor' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'RunToCursor.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 562 1 594 #toggleBreakpoint 8 '&Toggle Breakpoint' 1 1 nil nil nil 562 1 594 #toggleDisassembly 8 'Disasse&mbly' 1 1 nil nil nil 738 4097 514 nil true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 nil nil nil nil nil 514 nil true 34 16 562 1 594 #renameNode 8 'Re&name <1d>...' 1 1 nil nil nil 738 4097 562 1 594 #extractToTemporary 8 'Extract to &Temporary...' 1 1 nil nil nil 562 1 594 #extractMethod 8 'E&xtract Method...' 1 1 nil nil nil 562 1 594 #extractToComponent 8 'Extract to &Component...' 1 5 nil nil nil 738 4097 562 1 594 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 514 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 738 4097 562 1 594 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 562 1 594 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 562 1 594 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 738 4097 562 1 594 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 562 1 594 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 562 1 594 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Refactorin&gs' #codeRefactoringsMenu 1 818 nil true 864 8 'Refactoring.ico' 912 nil nil nil nil 738 4097 514 nil true 34 10 562 1 594 #undo 8 '&Undo' 1 1 818 nil true 864 8 'EditUndo.ico' 912 nil nil 738 4097 562 1 594 #cutSelection 8 'Cu&t' 1 1 818 nil true 864 8 'EditCut.ico' 912 nil nil 562 1 594 #copySelection 8 '&Copy' 1 1 818 nil true 864 8 'EditCopy.ico' 912 nil nil 562 1 594 #pasteClipboard 8 '&Paste' 1 1 818 nil true 864 8 'EditPaste.ico' 912 nil nil 562 1 594 #clearSelection 8 'De&lete' 1 1 818 nil true 864 8 'EditClear.ico' 912 nil nil 738 4097 562 1 594 #reformatSource 8 'Re&format' 1 1 nil nil nil 738 4097 562 1 594 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 514 nil true 34 10 562 1 594 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 562 1 594 #cloneNew 8 '&Clone' 1 1 818 nil true 864 8 'SmalltalkWorkspace.ico' 912 nil nil 738 4097 562 1 594 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 562 1 594 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 562 1 594 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 562 1 594 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 562 1 594 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 562 1 594 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 562 1 594 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 738 4097 562 1 594 #browseIt 8 'Bro&wse It' 1 1 818 nil true 864 8 'ClassBrowserShell.ico' 912 nil nil 562 1 594 #displayIt 8 '&Display It' 1 1 818 nil true 864 8 'DisplayIt.ico' 912 nil nil 562 1 594 #printIt 8 '&Print It' 1 1 818 nil true 864 8 'PrintIt.ico' 912 nil nil 562 1 594 #evaluateIt 8 'E&valuate It' 1 1 818 nil true 864 8 'EvaluateIt.ico' 912 nil nil 562 1 594 #inspectIt 8 '&Inspect It' 1 1 818 nil true 864 8 'InspectIt.ico' 912 nil nil 562 1 594 #debugIt 8 'Deb&ug It' 1 1 818 nil true 864 8 'Debugger.ico' 912 nil nil 738 4097 514 nil true 34 4 562 2097153 594 #browseDefinitions 8 '&Definitions of <1d>' 1 1 nil nil nil 562 1 594 #browseReferences 8 '&References to <1d>' 1 1 nil nil nil 738 4097 562 1 594 #browseMessage 8 '<1d>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848849585 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 3826 77 917510 ##(Graphics.Color) #silver 3874 #white 1 nil nil nil nil #callTip nil nil nil nil 1770758 ##(Tools.SmalltalkMethodStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 3968 nil 170 176 3968 9215 nil nil nil nil 3888 nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 3792 nil nil nil nil 208 nil 170 192 3968 nil nil 170 192 34 6 #Notification 3826 1029 nil 3874 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3826 1027 3874 #darkGoldenrod 3874 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 3826 1031 3874 #firebrick 3874 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 11 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 4498 641 441 416 4450 #contextMenu: 34 1 528 416 4450 #hoverTime: 8 #(500) 416 4450 #caretPeriod: 8 #(530) 416 4450 #wordWrap: 8 #(true) 416 4450 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 416 1 3 nil nil nil nil 4722 3 416 1 nil nil 67108863 nil nil 4722 5 416 1 nil nil nil nil nil 416 4450 #tabWidth: 8 #(4) 416 4450 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 416 4450 #maxCompletionListHeight: 8 #(9) 416 4450 #edgeColumn: 8 #(1) 416 4450 #hasAdditionalSelectionTyping: 8 #(true) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 63 13 0 0 230 0 0 0] 8 #() 4498 193 193 nil 31 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Scintilla.ScintillaView) 34 50 nil nil 34 2 8 1445007684 1 416 nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 461638 4 ##(UI.Menu) nil true 34 18 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 562 1 594 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 514 nil true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 nil nil nil nil nil 514 nil true 34 16 562 1 594 #renameNode 8 'Re&name <1d>...' 1 1 nil nil nil 690 4097 562 1 594 #extractToTemporary 8 'Extract to &Temporary...' 1 1 nil nil nil 562 1 594 #extractMethod 8 'E&xtract Method...' 1 1 nil nil nil 562 1 594 #extractToComponent 8 'Extract to &Component...' 1 5 nil nil nil 690 4097 562 1 594 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 514 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 690 4097 562 1 594 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 562 1 594 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 562 1 594 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 690 4097 562 1 594 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 nil nil nil 562 1 594 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 562 1 594 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 'Refactorin&gs' #codeRefactoringsMenu 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'Refactoring.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil nil nil 514 nil true 34 2 562 1 594 #reformatSource 8 '&Source' 1 1 nil nil nil 562 1 594 #reformatComment 8 '&Comment' 1 1 nil nil nil 8 'Re&format' #reformatMenu 1 nil nil nil nil nil 690 4097 514 nil true 34 9 562 1 594 #undo 8 '&Undo' 1 1 1458 nil true 1504 8 'EditUndo.ico' 1552 nil nil 690 4097 562 1 594 #cutSelection 8 'Cu&t' 1 1 1458 nil true 1504 8 'EditCut.ico' 1552 nil nil 562 1 594 #copySelection 8 '&Copy' 1 1 1458 nil true 1504 8 'EditCopy.ico' 1552 nil nil 562 1 594 #pasteClipboard 8 '&Paste' 1 1 1458 nil true 1504 8 'EditPaste.ico' 1552 nil nil 562 1 594 #clearSelection 8 'De&lete' 1 1 1458 nil true 1504 8 'EditClear.ico' 1552 nil nil 690 4097 562 1 594 #selectAll 8 '&Select All' 1 1 nil nil nil 562 1 594 #widenSourceSelection 8 '&Widen Selection' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 514 nil true 34 10 562 1 594 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 562 1 594 #cloneNew 8 '&Clone' 1 1 1458 nil true 1504 8 'SmalltalkWorkspace.ico' 1552 nil nil 690 4097 562 1 594 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 562 1 594 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 562 1 594 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 562 1 594 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 562 1 594 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 562 1 594 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 562 1 594 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 690 4097 562 1 594 #browseIt 8 'Bro&wse It' 1 1 1458 nil true 1504 8 'ClassBrowserShell.ico' 1552 nil nil 562 1 594 #displayIt 8 '&Display It' 1 1 1458 nil true 1504 8 'DisplayIt.ico' 1552 nil nil 562 1 594 #printIt 8 '&Print It' 1 1 1458 nil true 1504 8 'PrintIt.ico' 1552 nil nil 562 1 594 #evaluateIt 8 'E&valuate It' 1 1 1458 nil true 1504 8 'EvaluateIt.ico' 1552 nil nil 562 1 594 #inspectIt 8 '&Inspect It' 1 1 1458 nil true 1504 8 'InspectIt.ico' 1552 nil nil 562 1 594 #debugIt 8 'Deb&ug It' 1 1 1458 nil true 1504 8 'Debugger.ico' 1552 nil nil 690 4097 514 nil true 34 4 562 2097153 594 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 nil nil nil 562 1 594 #browseReferences 8 '&References to <1d>' 1 1 nil nil nil 690 4097 562 1 594 #browseMessage 8 '<1d>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848880161 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 3714 77 917510 ##(Graphics.Color) #gray 3762 #white 1 nil nil nil nil #callTip nil nil nil nil 1770758 ##(Tools.SmalltalkMethodStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 3856 nil 170 176 3856 nil nil nil nil nil 3762 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 3680 nil nil nil nil 208 nil 170 192 3856 nil nil 170 192 34 6 #Notification 3714 1029 nil 3762 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3714 1027 3762 #darkGoldenrod 3762 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 3714 1031 3762 #firebrick 3762 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 11 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 4402 641 441 416 4354 #contextMenu: 34 1 528 416 4354 #hoverTime: 8 #(500) 416 4354 #caretPeriod: 8 #(530) 416 4354 #wordWrap: 8 #(true) 416 4354 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 416 1 3 nil nil nil nil 4626 3 416 1 nil nil 67108863 nil nil 4626 5 416 1 nil nil nil nil nil 416 4354 #backspaceUnindents: 8 #(true) 416 4354 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 416 4354 #maxCompletionListHeight: 8 #(9) 416 4354 #edgeColumn: 8 #(1) 416 4354 #hasAdditionalSelectionTyping: 8 #(true) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 63 13 0 0 230 0 0 0] 8 #() 4402 193 193 nil 31 )! !
!Tools.MethodWorkspace class categoriesFor: #autoParseDwell!accessing!public! !
!Tools.MethodWorkspace class categoriesFor: #autoParseDwell:!accessing!public! !
!Tools.MethodWorkspace class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.MethodWorkspace class categoriesFor: #initialize!initializing!public! !
!Tools.MethodWorkspace class categoriesFor: #isAutoParseEnabled!accessing!public! !
!Tools.MethodWorkspace class categoriesFor: #isAutoParseEnabled:!accessing!public! !
!Tools.MethodWorkspace class categoriesFor: #resource_Debugger_source!public!resources-views! !
!Tools.MethodWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

