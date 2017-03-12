"Filed out from Dolphin Smalltalk 7"!

SmalltalkWorkspace subclass: #MethodWorkspace
	instanceVariableNames: 'parseTree refactoringTool'
	classVariableNames: 'AutoParseDwell AutoParseMask IsAutoParseEnabled'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MethodWorkspace guid: (GUID fromString: '{d7285d4c-35b2-4b52-a673-2e17fde39fec}')!
MethodWorkspace comment: 'MethodWorkspace is a specialised <SmalltalkWorkspace> for displaying method source that expects to be contained in a <MethodBrowser>.

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
!MethodWorkspace categoriesForClass!Development! !
!MethodWorkspace methodsFor!

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
	
	[StSemanticAnalyser 
		checkParseTree: self parseTree
		for: self selfClass
		context: self evaluationContext
		pools: self allPools] 
			on: SmalltalkParser notificationClass
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
										argument: (self selectedMethod methodClass environment bindingFor: node name) value]]]
				ifNotNil: 
					[:selector | 
					^Message selector: #browseDefinitionsOfSelector:in:
						arguments: (Array with: selector with: self searchEnvironment)]].
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
									[^Message selector: #browseGlobalReferences:in:
										arguments: (Array with: (self selectedMethod methodClass environment bindingFor: node name)
												with: self searchEnvironment)]]]
				ifNotNil: 
					[:literal | 
					^Message selector: #browseReferencesToLiteral:in:
						arguments: (Array with: literal with: self searchEnvironment)]].
	^super browseReferencesCommand!

buildParseTree
	| methodClass |
	methodClass := self parseContext ifNil: [ProtoObject].
	self clearErrors.
	self selectedMethod 
		ifNotNil: 
			[:method | 
			method isExpression ifTrue: [^SmalltalkParser parseExpression: method getSource in: methodClass]].
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

parseContext
	^parentPresenter ifNotNil: [:p | p parseContext]!

parseSourceIn: methodClass 
	^SmalltalkParser parseMethod: self source in: methodClass!

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
				text: (aCommandQuery commandDescription menuText expandMacrosWith: (message ifNil: ['...'])).
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
			aCommandQuery text: (aCommandQuery commandDescription menuText expandMacrosWith: text).
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

selectorFromNode: aStProgramNode 
	^aStProgramNode isMessage 
		ifTrue: [aStProgramNode selector]
		ifFalse: 
			[(aStProgramNode isLiteralNode and: [aStProgramNode value isKindOf: Symbol]) 
				ifTrue: [aStProgramNode value]]!

selfClass
	^evaluationContext 
		ifNil: [self parseContext ifNil: [UndefinedObject]]
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
			[| methodClass identifier |
			methodClass := self selectedMethod methodClass.
			identifier := receiver name.
			identifier = 'self' ifTrue: [^methodClass].
			identifier = 'super' ifTrue: [^methodClass superclass].
			identifier = 'thisContext' ifTrue: [^Integer].
			(self isTempVariable: receiver) 
				ifTrue: 
					["If hosted in the debugger can make a stab at these"
					(self contextBindingFor: identifier) 
						ifNotNil: [:binding | binding value ifNotNil: [:value | ^value basicClass]].
					^nil].
			((self evaluationContext isKindOf: methodClass) 
				and: [methodClass allInstVarNames includes: identifier]) 
					ifTrue: 
						["In the debugger will have an evaluation context which is the receiver."
						^(self evaluationContext instVarNamed: identifier) basicClass].
			(methodClass fullBindingFor: identifier) 
				ifNotNil: [:binding | binding value ifNotNil: [:value | ^value basicClass]]]
		ifFalse: [receiver isLiteralNode ifTrue: [^aStMessageNode receiver value basicClass]].
	^nil!

variableClassification: anStVariableNode 
	| class |
	(anStVariableNode notNil and: [anStVariableNode isVariable]) ifFalse: [^nil].
	(self isTempVariable: anStVariableNode) ifTrue: [^#temporary].
	class := self parseContext.
	(class allInstVarNames includes: anStVariableNode name) ifTrue: [^#instance].
	(class classPool bindingFor: anStVariableNode name) ifNotNil: [^#class].
	(class environment bindingFor: anStVariableNode name) 
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
!MethodWorkspace categoriesFor: #accept!commands!public! !
!MethodWorkspace categoriesFor: #addToCommandRoute:!commands!public! !
!MethodWorkspace categoriesFor: #allDefinedVariablesDo:!autocompletion!enumerating!private! !
!MethodWorkspace categoriesFor: #autoParse!helpers!private! !
!MethodWorkspace categoriesFor: #browseDefinitionsCommand!commands!private! !
!MethodWorkspace categoriesFor: #browseMessage!commands!public! !
!MethodWorkspace categoriesFor: #browseReferencesCommand!commands!private! !
!MethodWorkspace categoriesFor: #buildParseTree!helpers!private! !
!MethodWorkspace categoriesFor: #canSaveMethod!commands!private! !
!MethodWorkspace categoriesFor: #clear!operations!public! !
!MethodWorkspace categoriesFor: #clearParseTree!helpers!private! !
!MethodWorkspace categoriesFor: #contextBindingFor:!private!refactoring! !
!MethodWorkspace categoriesFor: #createComponents!initializing!public! !
!MethodWorkspace categoriesFor: #createSchematicWiring!initializing!public! !
!MethodWorkspace categoriesFor: #defaultStylerClass!constants!private! !
!MethodWorkspace categoriesFor: #evaluationContext!accessing!public! !
!MethodWorkspace categoriesFor: #formattedCode:!helpers!private! !
!MethodWorkspace categoriesFor: #hasErrors!public!testing! !
!MethodWorkspace categoriesFor: #initialize!initializing!private! !
!MethodWorkspace categoriesFor: #isAutoParseEnabled!accessing!public! !
!MethodWorkspace categoriesFor: #isAutoParseEnabled:!accessing!public! !
!MethodWorkspace categoriesFor: #isEditable!private!testing! !
!MethodWorkspace categoriesFor: #isTempVariable:!private!refactoring! !
!MethodWorkspace categoriesFor: #killParseTimer!helpers!private! !
!MethodWorkspace categoriesFor: #lineFromPosition:!enquiries!public! !
!MethodWorkspace categoriesFor: #method!accessing!private! !
!MethodWorkspace categoriesFor: #nodeForRange:!helpers!private! !
!MethodWorkspace categoriesFor: #onAboutToDisplayMenu:!event handling!public! !
!MethodWorkspace categoriesFor: #onTextChanged!event handling!public! !
!MethodWorkspace categoriesFor: #onTimerTick:!event handling!public! !
!MethodWorkspace categoriesFor: #parseContext!accessing!private! !
!MethodWorkspace categoriesFor: #parseSourceIn:!helpers!private! !
!MethodWorkspace categoriesFor: #parseTree!accessing!private! !
!MethodWorkspace categoriesFor: #promptToSaveChanges!helpers!public! !
!MethodWorkspace categoriesFor: #queryCommand:!commands!private! !
!MethodWorkspace categoriesFor: #reformatAccept!commands!public! !
!MethodWorkspace categoriesFor: #reformatSource!commands!public! !
!MethodWorkspace categoriesFor: #reformattedSource!helpers!private! !
!MethodWorkspace categoriesFor: #repositionAtSourceLine:!operations!public! !
!MethodWorkspace categoriesFor: #resetParseTimer!helpers!private! !
!MethodWorkspace categoriesFor: #selectedErrorRange!accessing!private!refactoring! !
!MethodWorkspace categoriesFor: #selectedMessage!accessing!private! !
!MethodWorkspace categoriesFor: #selectedMessageNode!accessing!private!refactoring! !
!MethodWorkspace categoriesFor: #selectedMethod!accessing!public! !
!MethodWorkspace categoriesFor: #selectedNode!accessing!public! !
!MethodWorkspace categoriesFor: #selectorFromNode:!commands!private! !
!MethodWorkspace categoriesFor: #selfClass!autocompletion!private! !
!MethodWorkspace categoriesFor: #setParseTimer!helpers!private! !
!MethodWorkspace categoriesFor: #source!accessing!public! !
!MethodWorkspace categoriesFor: #source:!accessing!public! !
!MethodWorkspace categoriesFor: #targetOfMessage:!commands!private!refactoring! !
!MethodWorkspace categoriesFor: #variableClassification:!helpers!private! !
!MethodWorkspace categoriesFor: #widenSourceSelection!commands!public! !

!MethodWorkspace class methodsFor!

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

	^super defaultAdditionalAccelerators , #(#(#widenSourceSelection 'Ctrl+U'))!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	AutoParseDwell := 1000.
	IsAutoParseEnabled := true.
	AutoParseMask := 16r100000!

isAutoParseEnabled
	"Answer whether the method source will be automatically parsed after the user has paused for a short while."

	^IsAutoParseEnabled!

isAutoParseEnabled: aBoolean
	IsAutoParseEnabled := aBoolean!

resource_Debugger_source
	"Answer the literal data from which the 'Debugger source' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Debugger_source)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 0 0 34 2 8 1445007684 1 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 21 265030 4 ##(Smalltalk.Menu) 0 true 34 21 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 0 0 0 578 1 610 #reformatAccept 8 'Ref&ormat/Accept' 1 1 0 0 0 578 1 610 #acceptNoRestart 8 'Acce&pt No Restart' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 578 1 610 #runToCursor 8 '&Run to Cursor' 1 1 0 0 0 578 1 610 #toggleBreakpoint 8 '&Toggle Breakpoint' 1 1 0 0 0 578 1 610 #toggleDisassembly 8 'Disasse&mbly' 1 1 0 0 0 754 4097 530 0 true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 0 0 0 0 0 530 0 true 34 16 578 1 610 #renameNode 8 'Re&name <1d>...' 1 1 0 0 0 754 4097 578 1 610 #extractToTemporary 8 'Extract to &Temporary...' 1 1 0 0 0 578 1 610 #extractMethod 8 'E&xtract Method...' 1 1 0 0 0 578 1 610 #extractToComponent 8 'Extract to &Component...' 1 5 0 0 0 754 4097 578 1 610 #inlineMessage 8 'Inline &Message' 1 1 0 0 0 530 0 true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 0 0 0 0 0 754 4097 578 1 610 #inlineTemporary 8 '&Inline Temporary' 1 1 0 0 0 578 1 610 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 0 0 0 578 1 610 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 754 4097 578 1 610 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 578 1 610 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 578 1 610 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Refactorin&gs' #codeRefactoringsMenu 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refactoring.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 0 0 754 4097 530 0 true 34 9 578 1 610 #undo 8 '&Undo' 1 1 1682 0 true 1728 8 'EditUndo.ico' 1776 0 0 754 4097 578 1 610 #cutSelection 8 'Cu&t' 1 1 1682 0 true 1728 8 'EditCut.ico' 1776 0 0 578 1 610 #copySelection 8 '&Copy' 1 1 1682 0 true 1728 8 'EditCopy.ico' 1776 0 0 578 1 610 #pasteClipboard 8 '&Paste' 1 1 1682 0 true 1728 8 'EditPaste.ico' 1776 0 0 578 1 610 #clearSelection 8 'De&lete' 1 1 1682 0 true 1728 8 'EditClear.ico' 1776 0 0 578 1 610 #reformatSource 8 'Re&format' 1 1 0 0 0 754 4097 578 1 610 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 530 0 true 34 10 578 1 610 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 578 1 610 #cloneNew 8 'Clo&ne' 1 1 1682 0 true 1728 8 'SmalltalkWorkspace.ico' 1776 0 0 754 4097 578 1 610 #toggleAutoCompletion 8 'Auto-complete' 1 1 0 0 0 578 1 610 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 578 1 610 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 578 1 610 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 578 1 610 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 578 1 610 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 578 1 610 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 'Wor&kspace' 0 134217729 0 0 0 0 0 754 4097 578 1 610 #browseIt 8 'Bro&wse It' 1 1 1682 0 true 1728 8 'ClassBrowserShell.ico' 1776 0 0 578 1 610 #displayIt 8 '&Display It' 1 1 1682 0 true 1728 8 'DisplayIt.ico' 1776 0 0 578 1 610 #evaluateIt 8 'E&valuate It' 1 1 1682 0 true 1728 8 'EvaluateIt.ico' 1776 0 0 578 1 610 #inspectIt 8 '&Inspect It' 1 1 1682 0 true 1728 8 'InspectIt.ico' 1776 0 0 578 1 610 #debugIt 8 'Deb&ug It' 1 1 1682 0 true 1728 8 'Debugger.ico' 1776 0 0 754 4097 530 0 true 34 4 578 2097153 610 #browseDefinitions 8 '&Definitions of <1d>' 1 1 0 0 0 578 1 610 #browseReferences 8 '&References to <1d>' 1 1 0 0 0 754 4097 578 1 610 #browseMessage 8 '<1d>' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 0 0 1 0 0 0 0 #normal 0 0 0 #callTip 3666 77 786694 ##(Smalltalk.IndexedColor) 33554457 3714 33554471 1 0 0 0 0 #callTip 0 0 0 34 40 3680 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 false 138 144 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 3824 0 170 176 3824 9215 0 0 0 0 3714 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 3632 0 0 0 0 3 0 170 192 3824 0 0 170 192 34 6 #Notification 3666 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 3666 1027 4146 60239 4146 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 3666 1031 4146 335 4146 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 8 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 4386 641 441 416 4338 #contextMenu: 34 1 544 416 4338 #modificationEventMask: 8 #(4607) 416 4338 #hoverTime: 8 #(500) 416 4338 #caretPeriod: 8 #(530) 416 4338 #wordWrap: 8 #(true) 416 4338 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 0 0 0 0 4642 3 416 1 0 0 67108863 0 0 4642 5 416 1 0 0 0 0 0 416 4338 #tabWidth: 8 #(4) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 191 8 0 0 230 0 0 0] 8 #() 4386 193 193 0 29 )!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 0 0 34 2 8 1445007684 1 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 21 265030 4 ##(Smalltalk.Menu) 0 true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 8 '&Accept' 1 1 0 0 0 578 1 610 #reformatAccept 8 'Ref&ormat/Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem) 4097 530 0 true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 0 0 0 0 0 530 0 true 34 16 578 1 610 #renameNode 8 'Re&name <1d>...' 1 1 0 0 0 706 4097 578 1 610 #extractToTemporary 8 'Extract to &Temporary...' 1 1 0 0 0 578 1 610 #extractMethod 8 'E&xtract Method...' 1 1 0 0 0 578 1 610 #extractToComponent 8 'Extract to &Component...' 1 5 0 0 0 706 4097 578 1 610 #inlineMessage 8 'Inline &Message' 1 1 0 0 0 530 0 true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 0 0 0 0 0 706 4097 578 1 610 #inlineTemporary 8 '&Inline Temporary' 1 1 0 0 0 578 1 610 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 0 0 0 578 1 610 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 0 0 0 706 4097 578 1 610 #addParameterToMessage 8 '&Add Parameter to <1d>...' 1 1 0 0 0 578 1 610 #inlineParameter 8 'In&line Parameter' 1 1 0 0 0 578 1 610 #removeParameter 8 'Remove &Parameter' 1 1 0 0 0 8 'Refactorin&gs' #codeRefactoringsMenu 1 263494 3 ##(Smalltalk.Icon) 0 true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Refactoring.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' 0 0 0 0 0 530 0 true 34 2 578 1 610 #reformatSource 8 '&Source' 1 1 0 0 0 578 1 610 #reformatComment 8 '&Comment' 1 1 0 0 0 8 'Re&format' #reformatMenu 1 0 0 0 0 0 706 4097 530 0 true 34 9 578 1 610 #undo 8 '&Undo' 1 1 1474 0 true 1520 8 'EditUndo.ico' 1568 0 0 706 4097 578 1 610 #cutSelection 8 'Cu&t' 1 1 1474 0 true 1520 8 'EditCut.ico' 1568 0 0 578 1 610 #copySelection 8 '&Copy' 1 1 1474 0 true 1520 8 'EditCopy.ico' 1568 0 0 578 1 610 #pasteClipboard 8 '&Paste' 1 1 1474 0 true 1520 8 'EditPaste.ico' 1568 0 0 578 1 610 #clearSelection 8 'De&lete' 1 1 1474 0 true 1520 8 'EditClear.ico' 1568 0 0 706 4097 578 1 610 #selectAll 8 '&Select All' 1 1 0 0 0 578 1 610 #widenSourceSelection 8 '&Widen Selection' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 530 0 true 34 10 578 1 610 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 578 1 610 #cloneNew 8 'Clo&ne' 1 1 1474 0 true 1520 8 'SmalltalkWorkspace.ico' 1568 0 0 706 4097 578 1 610 #toggleAutoCompletion 8 'Auto-complete' 1 1 0 0 0 578 1 610 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 578 1 610 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 578 1 610 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 578 1 610 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 578 1 610 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 578 1 610 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 8 'Wor&kspace' 0 134217729 0 0 0 0 0 706 4097 578 1 610 #browseIt 8 'Bro&wse It' 1 1 1474 0 true 1520 8 'ClassBrowserShell.ico' 1568 0 0 578 1 610 #displayIt 8 '&Display It' 1 1 1474 0 true 1520 8 'DisplayIt.ico' 1568 0 0 578 1 610 #evaluateIt 8 'E&valuate It' 1 1 1474 0 true 1520 8 'EvaluateIt.ico' 1568 0 0 578 1 610 #inspectIt 8 '&Inspect It' 1 1 1474 0 true 1520 8 'InspectIt.ico' 1568 0 0 578 1 610 #debugIt 8 'Deb&ug It' 1 1 1474 0 true 1520 8 'Debugger.ico' 1568 0 0 706 4097 530 0 true 34 4 578 2097153 610 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 0 0 0 578 1 610 #browseReferences 8 '&References to <1d>' 1 1 0 0 0 706 4097 578 1 610 #browseMessage 8 '<1d>' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294906539 852486 ##(Smalltalk.NullConverter) 0 0 9 0 170 192 34 4 #callTip 1182790 1 ##(Smalltalk.ScintillaTextStyle) 77 786694 ##(Smalltalk.IndexedColor) 33554457 3634 33554471 1 0 0 0 0 #callTip 0 0 0 #normal 3602 1 0 0 1 0 0 0 0 #normal 0 0 0 34 40 3680 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1377542 ##(Smalltalk.SmalltalkMethodStyler) 1 0 0 false 138 144 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 0 0 0 416 #circle 0 0 0 0 0 0 138 ##(Smalltalk.IdentitySet) 3760 0 170 176 3760 9215 0 0 0 0 3634 33554447 0 0 65 0 0 170 192 34 6 #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' #literalArray 8 '()' 8 '' 3 170 192 34 2 #container 3568 0 0 0 0 3 0 170 192 3760 0 0 170 192 34 6 #Notification 3602 1029 0 196934 1 ##(Smalltalk.RGB) 31185883 1 0 0 0 0 #Notification 0 0 0 #Warning 3602 1027 4082 60239 4082 31326207 1 0 0 0 0 #Warning 0 0 0 #Error 3602 1031 4082 335 4082 31317503 1 0 0 0 0 #Error 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 138 144 34 8 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 4322 641 441 416 4274 #contextMenu: 34 1 544 416 4274 #modificationEventMask: 8 #(4607) 416 4274 #hoverTime: 8 #(500) 416 4274 #caretPeriod: 8 #(530) 416 4274 #wordWrap: 8 #(true) 416 4274 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 0 0 0 0 4578 3 416 1 0 0 67108863 0 0 4578 5 416 1 0 0 0 0 0 416 4274 #backspaceUnindents: 8 #(true) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 191 8 0 0 230 0 0 0] 8 #() 4322 193 193 0 29 )! !
!MethodWorkspace class categoriesFor: #autoParseDwell!accessing!public! !
!MethodWorkspace class categoriesFor: #autoParseDwell:!accessing!public! !
!MethodWorkspace class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!MethodWorkspace class categoriesFor: #initialize!initializing!public! !
!MethodWorkspace class categoriesFor: #isAutoParseEnabled!accessing!public! !
!MethodWorkspace class categoriesFor: #isAutoParseEnabled:!accessing!public! !
!MethodWorkspace class categoriesFor: #resource_Debugger_source!public!resources-views! !
!MethodWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

