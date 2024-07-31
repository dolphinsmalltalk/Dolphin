"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkWorkspace
	subclass: #'Tools.MethodWorkspace'
	instanceVariableNames: 'parseTree'
	classVariableNames: 'AutoParseDwell'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'NoAutoParseMask' -> 16r100000. 'NoSelectionMatching' -> 16r200000 }!

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

	<commandQuery: #canSaveMethod>
	parentPresenter saveNewMethod: self source!

allVariablesVisibleFrom: aStProgramNode do: aMonadicValuable
	(aStProgramNode ifNil: [self parseTree])
		ifNotNil: [:ast | ast scope visibleVariablesDo: [:each | aMonadicValuable value: each]]!

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions ifFalse: [^false].
	self isAutoParseEnabled: self class isAutoParseEnabled!

autoParse
	self textLength > 0 ifFalse: [^self].
	
	[| ast |
	ast := self parseTree.
	BrowserSemanticAnalyser analyseParseTree: ast pools: self allPools]
			on: Parser notificationClass
			do: 
				[:err |
				"err toTrace"
				compilationErrors addLast: err copy.
				err resume].
	self highlightCompilationErrors: 0.
	self errorModel isNil ifTrue: [^self].
	self errorModel value: self firstError!

browseAnnotatedMethods
	"Open a method browser showing methods in the search environment with the current annotation."

	<commandQuery: #queryBrowseAnnotatedMethods:>
	self browseReferencesMatching: (AnnotatedMethodSearch newLiteral: self selectedNode selector)!

browseBindingReferenceTarget
	<commandQuery: #queryBrowseBindingReferenceTarget:>
	| binding |
	binding := self selectedNode value bindingOrNil.
	self browseClassDefinition: (binding isClassVariable
				ifTrue: [binding environment]
				ifFalse: [binding isClassBinding ifTrue: [binding value] ifFalse: [binding value class instanceClass]])!

browseClass
	<commandQuery: #queryBrowseClass:>
	self browseClassDefinition: self selectedVariable binding value!

browseClassOfLiteral
	<commandQuery: #queryBrowseClassOfLiteral:>
	self browseClassDefinition: self selectedNode value class!

browseClassReferences
	<commandQuery: #queryBrowseClassReferences:>
	^self browseClassReferences: self selectedNode variable binding value!

browseClassVariableDefinition
	<commandQuery: #queryBrowseClassVariableDefinition:>
	self browseClassDefinition: self selectedVariable binding environment!

browseClassVariableReferences
	<commandQuery: #queryBrowseClassVariableReferences:>
	self browseEnvironments: (self developmentSystem
				referencesToVariable: self selectedNode variable binding realBinding
				in: self searchEnvironment)!

browseDefinitionsCommand
	"Private - Browse definitions of the object identified by the node under the cursor."

	| node |
	node := self selectedNode.
	node isNil ifTrue: [^nil].
	node isMessage ifTrue: [^#browseMessageDefinitions].
	node isLiteralNode
		ifTrue: 
			[| literalType |
			literalType := node valueClass realClass.
			literalType == Symbol ifTrue: [^#browseSelectorDefinitions].
			literalType == BindingReference ifTrue: [^#browseBindingReferenceTarget].
			^#browseClassOfLiteral].
	node isVariable
		ifTrue: 
			[^##(IdentityDictionary withAll: {
						#instance -> #browseInstanceVariableDefinition.
						#class -> #browseClassVariableDefinition.
						#classGlobal -> #browseClass.
						#temporary -> #browseTemporaryVariableDefinition.
						#special -> #browseSpecialVariableDefinition.
						#global -> #browseSharedVariableDefinition
					})
				lookup: (self variableClassification: node)].
	^nil!

browseEnvironments: aSequenceOfBrowserEnvironment
	"Private - Open a method browser on the methods in the specified sequence of <BrowserEnvironment>s"

	"Route a command message to avoid requiring that the parent presenter implement #browseMethodsInEnvironments:. Ultimately this can be handled by the development system model, but is also intercepted by <MethodExplorer> in order to add to its search history tree."

	self routeCommand: (CommandDescription
				command: (Message selector: #browseMethodsInEnvironments: argument: aSequenceOfBrowserEnvironment))!

browseInstanceVariableDefinition
	<commandQuery: #queryBrowseInstanceVariableDefinition:>
	self browseClassDefinition: (self parseContext methodClass
				whichClassDefinesInstVar: self selectedNode name)!

browseInstanceVariableReferences
	<commandQuery: #queryBrowseInstanceVariableReferences:>
	self
		routeCommand: (CommandDescription command: (Message selector: #browseMethodsInEnvironments:
						argument: (self developmentSystem
								referencesToInstVar: self selectedNode name
								inHierarchyOf: self parseContext methodClass realClass
								within: self searchEnvironment)))!

browseMessageDefinitions
	"Browse definitions of the object identified by the node under the cursor."

	<commandQuery: #queryBrowseMessageSelector:>
	self browseDefinitionsMatching: (MethodSearch newLiteral: self selectedNode selector)!

browseMessageReferences
	"Open a method browser showing references to the current message or literal symbol node."

	<commandQuery: #queryBrowseMessageSelector:>
	self browseReferencesMatching: (MethodSearch newLiteral: self selectedNode selector)!

browseMessageTarget
	"Open a class browser on the method to which the current message node maps. It is possible to identify a specific method from sends where the receiver is of a known type, i.e. sends to literals, static variables, and self/super sends. When the receiver is hosted in a debugger, there is also runtime context to resolve the types of variables."

	<commandQuery: #queryBrowseMessageTarget:>
	| node |
	node := self selectedMessageNode.
	self
		routeCommand: (CommandDescription command: (Message selector: #browseMethod:
						arguments: { ((self targetOfMessage: node) lookupMethod: node selector) realMethod }))!

browseReferencesCommand
	"Private - Answer the context-sensitive 'Browse References' command for the selected node."

	| node |
	node := self selectedNode.
	node isNil ifTrue: [^nil].
	node isMessage ifTrue: [^#browseMessageReferences].
	node isLiteralNode
		ifTrue: 
			[| literalType |
			literalType := node valueClass.
			literalType == BindingReference ifTrue: [^#browseReferencesToBindingReference].
			^literalType ~~ UndefinedObject ifTrue: [#browseLiteralReferences]].
	node isVariable
		ifTrue: 
			[^##(IdentityDictionary withAll: {
						#instance -> #browseInstanceVariableReferences.
						#class -> #browseClassVariableReferences.
						#classGlobal -> #browseClassReferences.
						#temporary -> #browseTemporaryVariableReferences.
						#special -> #browseSpecialVariableReferences.
						#global -> #browseSharedVariableReferences
					})
				lookup: (self variableClassification: node)].
	node isTag ifTrue: [^#browseAnnotatedMethods].
	^nil!

browseReferencesToBindingReference
	"Open a method browser showing references to the value of the current literal node. Note this can be any literal value, not just symbols. For example you can search for all occurrences of String 'abc' in the system, or $🐬"

	<commandQuery: #queryBrowseReferencesToBindingReference:>
	self browseReferencesMatching: (MethodSearch newLiteral: self selectedNode value)!

browseSharedVariableDefinition
	<commandQuery: #queryBrowseSharedVariableDefinition:>
	self browseClassDefinition: self selectedVariable binding value class instanceClass!

browseSharedVariableReferences
	<commandQuery: #queryBrowseSharedVariableReferences:>
	self
		browseEnvironments: (self developmentSystem referencesToVariable: self selectedNode variable binding realBinding
				in: self searchEnvironment)!

browseSpecialVariableDefinition
	<commandQuery: #queryBrowseSpecialVariableDefinition:>
	^self browseClassDefinition: (self selectedNode valueClassIn: self parseContext methodClass)!

browseSpecialVariableReferences
	<commandQuery: #queryBrowseSpecialVariableReferences:>
	| node |
	node := self selectedNode.
	node isThisContext
		ifTrue: [self browseReferencesMatching: ThisContextSearch new]
		ifFalse: [self browseClassReferences: (node valueClassIn: self parseContext methodClass)]!

browseTemporaryVariableDefinition
	<commandQuery: #queryBrowseTemporaryVariableDefinition:>
	self browseClassDefinition: (self suggestClassForVariable: self selectedVariable)!

browseTemporaryVariableReferences
	<commandQuery: #queryBrowseTemporaryVariableReferences:>
	self browseClassReferences: (self suggestClassForVariable: self selectedVariable)!

buildParseTree
	| parseContext |
	parseContext := self parseContext.
	self clearErrors.
	self selectedMethod
		ifNotNil: 
			[:method |
			method isExpression
				ifTrue: 
					[^Parser
						parseExpression: method getSource
						in: parseContext methodClass
						environment: parseContext environment]].
	^
	[Parser
		parseMethod: self source
		in: parseContext methodClass
		environment: parseContext environment]
			on: Compiler notificationClass
			do: 
				[:err |
				compilationErrors addLast: err copy.
				err resume]!

canSaveMethod
	^self isReadOnly not and: [parentPresenter canSaveMethod and: [self textLength > 0]]!

changeSignature: aSymbol in: methodClass operation: aMonadicValuable title: titleString
	<commandQuery: #queryChangeSignature:>
	self performMethodRenameRefactoring: 
			[:method |
			(methodClass lookupMethod: aSymbol)
				ifNotNil: [:renamedMethod | self executeRefactoring: aMonadicValuable with: renamedMethod]
				ifNil: 
					[MessageBox errorMsg: ('<2p> is not defined in <1p>' expandMacrosWith: methodClass with: aSymbol)
						caption: ('<3s> send of <2p> in <1p>…'
								expandMacrosWith: methodClass
								with: aSymbol
								with: titleString).
					nil]]!

clear
	"Remove all contents in the receiver's view"

	super clear.
	self clearParseTree!

clearParseTree
	"Private - Set the parse tree cache for the current method to the DeafObject to distinguish
	the case where the method has not yet been parsed from the case where the method failed to
	compile (in which case methodAST will have the value nil)."

	parseTree := DeafObject.Current.
	self resetParseTimer!

completeInitialWord
	self
		showSelectorCompletionListAt: 0
		maxItems: self maxCompletionListSize
		start: 1!

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

declareTemporary: aStVariableNode
	| tree body target insert |
	#todo.	"Add the temp in the innermost scope?"
	tree := self parseTree.
	body := tree body.
	body temporaries isEmpty
		ifTrue: 
			[body leftBar
				ifNil: 
					[| start |
					start := body start.
					target := start to: body start - 1.
					insert := '| <1d> |<n><t>' expandMacrosWith: aStVariableNode name]
				ifNotNil: 
					[:value |
					target := value + 1 to: body rightBar - 1.
					insert := ' <1s> ' expandMacrosWith: aStVariableNode name]]
		ifFalse: 
			[target := body temporaries last stop + 1 to: body rightBar - 1.
			insert := ' <1s> ' expandMacrosWith: aStVariableNode name].
	self view
		targetRange: target;
		replaceTarget: insert!

defaultStylerClass
	^SmalltalkMethodStyler!

descriptionForVariableNode: aStVariableNode
	aStVariableNode ifNil: [^nil].
	^variableMetadataProvider descriptionOfVariable: aStVariableNode variable!

evaluationContext
	"Answers the evaluation context for this workspace."

	^evaluationContext
		ifNil: [self parseContext ifNotNil: [:context | context methodClass instanceClass]]!

formattedCode: aStProgramNode
	^aStProgramNode formattedCode!

hasCompilationErrors
	^self compilationErrors notEmpty!

hasErrors
	"Answer whether there are any errors in the source code (not warnings)"

	^self parseTree isNil or: [super hasErrors]!

hasSelectedMessage
	^self selectedMessageNode notNil!

hasUndeclaredVariables
	^self compilationErrors anySatisfy: [:each | each errorCode = ParseErrorCodes.CErrUndeclared]!

initialize
	super initialize.
	self isAutoParseEnabled: self class isAutoParseEnabled!

isAutoParseEnabled
	^flags noMask: NoAutoParseMask!

isAutoParseEnabled: aBoolean
	flags := flags mask: NoAutoParseMask set: aBoolean not!

isEditable
	^super isEditable and: [parentPresenter hasEditableMethodSelected]!

isLocalVariable: aStVariableNode
	"Private - Answer whether the specified variable node represents one of the temporaries in the current
	method (note that parameters are excluded)."

	^self parseTree allTemporaryVariableNodes includes: aStVariableNode!

isSelectionMatched
	^flags noMask: NoSelectionMatching!

isSelectionMatched: aBoolean
	flags := flags mask: NoSelectionMatching set: aBoolean not!

killParseTimer
	self view killTimer: 1000!

lineFromPosition: anInteger 
	^view lineFromPosition: anInteger!

method
	Notification deprecated.
	^self selectedMethod!

nameBindingContext
	^evaluationContext
		ifNil: [self parseContext]
		ifNotNil: [:context | ParseContext methodClass: context basicClass]!

nameForArgumentNode: aStProgramNode
	aStProgramNode isVariable
		ifTrue: 
			[aStProgramNode variable
				ifNotNil: 
					[:var |
					(self suggestClassForVariable: var)
						ifNotNil: 
							[:aClass |
							| type |
							type := self developmentSystem typeForArgumentClass: aClass.
							^aClass isMeta
								ifTrue: ['aClass']
								ifFalse: [(type name first isVowel ifTrue: ['an'] ifFalse: ['a']) , type name]]].
			^aStProgramNode name].
	aStProgramNode isLiteralNode
		ifTrue: [^self developmentSystem nameForArgument: aStProgramNode value].
	aStProgramNode isBlock
		ifTrue: [^self developmentSystem nameForBlockOfArity: aStProgramNode argumentCount].
	^'anObject'!

onTextChanged
	"The text in the receiver's view has been changed. Clear cached information."

	self clearParseTree!

onTimerTick: anInteger 
	anInteger == 1000 ifFalse: [^super onTimerTick: anInteger].
	self killParseTimer.
	self isAutoParseEnabled ifTrue: [self autoParse]!

onUpdateUI: anSCNotification

	anSCNotification updated == SC_UPDATE_SELECTION
		ifTrue: [self selectionChanged].
!

parseContext
	^parentPresenter parseContext!

parseTree
	parseTree == DeafObject.Current
		ifTrue: 
			[parseTree := self buildParseTree.
			SemanticAnalyser analyseParseTree: parseTree pools: { self workspacePool }].
	^parseTree!

promptToSaveChanges
	^parentPresenter promptToSaveChanges!

queryBrowseAnnotatedMethods: aCommandQuery
	| node |
	node := self selectedNode.
	node isTag ifFalse: [^self].
	aCommandQuery
		beEnabled;
		text: 'Methods with annotation <d>' << node value selector!

queryBrowseBindingReferenceTarget: aCommandQuery
	| node |
	node := self selectedNode.
	((node isLiteralNode and: [node valueClass realClass == BindingReference])
		ifTrue: [node value bindingOrNil])
			ifNotNil: 
				[:binding |
				aCommandQuery
					beEnabled;
					text: 'Class <p>' << (binding isClassVariable
										ifTrue: [binding environment]
										ifFalse: [binding value class instanceClass])]!

queryBrowseClass: aCommandQuery
	^self queryBrowseVariableDefinition: aCommandQuery classification: #classGlobal!

queryBrowseClassReferences: aCommandQuery
	^self queryBrowseVariableReferences: aCommandQuery classification: #classGlobal!

queryBrowseClassVariableDefinition: aCommandQuery
	| var |
	var := self selectedVariable.
	(var notNil and: [var classification == #class]) ifFalse: [^self].
	aCommandQuery
		beEnabled;
		text: 'Class <p>' << var binding environment!

queryBrowseClassVariableReferences: aCommandQuery
	| var |
	var := self selectedVariable.
	(var notNil and: [var classification == #class])
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: var binding shortName]!

queryBrowseInstanceVariableDefinition: aCommandQuery
	| var |
	var := self selectedVariable.
	var classification == #instance ifFalse: [^self].
	aCommandQuery
		beEnabled;
		text: 'Class <p>' << (self parseContext methodClass whichClassDefinesInstVar: var name)!

queryBrowseInstanceVariableReferences: aCommandQuery
	| var |
	var := self selectedVariable.
	var classification == #instance
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: '<1p>.<2s>'
							<< { self parseContext methodClass whichClassDefinesInstVar: var name. var name }]!

queryBrowseMessageSelector: aCommandQuery
	| node message |
	node := self selectedNode.
	message := node isMessage ifTrue: [node selector].
	message ifNil: [^self].
	aCommandQuery
		beEnabled;
		expandMenuTextWith: message!

queryBrowseMessageTarget: aCommandQuery
	| method |
	method := self selectedMessageNode
				ifNotNil: [:node | (self targetOfMessage: node) ifNotNil: [:target | target lookupMethod: node selector]].
	method ifNil: [^self].
	aCommandQuery
		beEnabled;
		text: method printString!

queryBrowseReferencesToBindingReference: aCommandQuery
	| node |
	node := self selectedNode.
	(node isLiteralNode and: [node valueClass == BindingReference])
		ifTrue: 
			[aCommandQuery
				beEnabled;
				expandMenuTextWith: node value printString]!

queryBrowseSharedVariableDefinition: aCommandQuery
	^self queryBrowseVariableDefinition: aCommandQuery classification: #global!

queryBrowseSharedVariableReferences: aCommandQuery
	^self queryBrowseVariableReferences: aCommandQuery classification: #global!

queryBrowseSpecialVariableDefinition: aCommandQuery
	^self queryBrowseVariableDefinition: aCommandQuery classification: #special!

queryBrowseSpecialVariableReferences: aCommandQuery
	^self queryBrowseVariableReferences: aCommandQuery classification: #special!

queryBrowseTemporaryVariableDefinition: aCommandQuery
	^self queryBrowseVariableDefinition: aCommandQuery classification: #temporary!

queryBrowseTemporaryVariableReferences: aCommandQuery
	^self queryBrowseVariableReferences: aCommandQuery classification: #temporary!

queryBrowseVariableDefinition: aCommandQuery classification: aSymbol
	| var |
	var := self selectedVariable.
	((var notNil and: [var classification == aSymbol]) ifTrue: [self suggestClassForVariable: var])
		ifNotNil: 
			[:valueClass |
			aCommandQuery
				beEnabled;
				text: 'Class <p>' << valueClass instanceClass]!

queryBrowseVariableReferences: aCommandQuery classification: aSymbol
	| var |
	var := self selectedVariable.
	((var notNil and: [var classification == aSymbol]) ifTrue: [self suggestClassForVariable: var])
		ifNotNil: 
			[:valueClass |
			aCommandQuery
				beEnabled;
				expandMenuTextWith: valueClass instanceClass shortName]!

reformatAccept
	<commandQuery: #canSaveMethod>
	self reformattedSource ifNotNil: [:aString | parentPresenter saveNewMethod: aString]!

reformatMenu
	<commandQuery: #isEditable>
	!

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
	^(compilationErrors detect: [:each | each severityClass == Error] ifNone: nil)
		ifNil: [self formattedCode: ast]
		ifNotNil: 
			[:ex |
			self showError: ex copy offset: 0.
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

resolveVariableOfNode: aStVariableNode
	"Private - Attempt to resolve the correct variable for the specified identifier using the parse tree.  If the parseTree has not been built, then just rely on the simpler analysis done in the superclass. This will still be able to resolve non-local variables."

	| identifier |
	(aStVariableNode notNil and: [aStVariableNode isVariable]) ifFalse: [^nil].
	"The semantic analyzer may have run and bound the variable node already"
	aStVariableNode variable ifNotNil: [:var | ^var].
	identifier := aStVariableNode name.
	(self resolveIdentifier: identifier) ifNotNil: [:var | ^var].

	"If all else fails, synthesize a variable
		- Any known instance variables in scope would have been resolved (doesn't require a parse tree).
		- Any known static variables in scope would have been resolved (doesn't require a parse tree).
		- For the method/block parameters and temp declarations we know the right variable type (determined by the styling lexer).
		- For other cases we make an educated guess:
			- Static variables start with uppercase letters by convention, so for such identifiers assume an undeclared static variable
			- Assume other cases are temps"
	aStVariableNode isParameter
		ifTrue: 
			["Method/block parameter "
			^StArgumentVariable node: aStVariableNode].
	aStVariableNode isTempDeclaration
		ifTrue: 
			["Method or block temporary declaration - we don't know which without a parse tree, but doesn't really matter for most purposes"
			^StTempVariable node: aStVariableNode].
	"Other identifiers"
	identifier first isUpperCase
		ifTrue: 
			["Undeclared static"
			^StStaticVariable scope: self parseContext scope binding: nil].
	"Assume a temp"
	^StTempVariable node: aStVariableNode!

selectedErrorRange
	^self selectedNode sourceInterval!

selectedLiteralValue
	| node |
	node := self selectedNode.
	^node isLiteralNode ifTrue: [node value]!

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

selectedSymbol
	| literal |
	literal := self selectedLiteralValue.
	^literal class == Symbol ifTrue: [literal]!

selectedVariable
	^self resolveVariableOfNode: self selectedNode!

selectionChanged
	"The receiver highlights all text matching <view selection>"

	self isSelectionMatched
		ifTrue: [view identifyTextMatchingSelectionWithStyleName: #secondarySelection]!

selectorFromNode: aStProgramNode
	^aStProgramNode isMessage
		ifTrue: [aStProgramNode selector]
		ifFalse: 
			[(aStProgramNode isLiteralNode and: [aStProgramNode valueClass == Symbol])
				ifTrue: [aStProgramNode value]]!

selfClass
	^evaluationContext
		ifNil: [self parseContext ifNil: [UndefinedObject] ifNotNil: [:context | context methodClass]]
		ifNotNil: [:context | context basicClass]!

setParseTimer
	self view setTimer: 1000 interval: self class autoParseDwell asMilliseconds!

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
			[receiver isSpecialVariable ifTrue: [^receiver valueClassIn: self parseContext methodClass].
			(receiver variable ifNil: [self resolveIdentifier: receiver name])
				ifNotNil: [:var | ^self suggestClassForVariable: var]]
		ifFalse: [receiver isLiteralNode ifTrue: [^aStMessageNode receiver value basicClass]].
	^nil!

variableClassification: aStVariableNode
	^(self resolveVariableOfNode: aStVariableNode) ifNotNil: [:var | var classification]!

widenSourceSelection
	"Expand the selection to encompass the next greater syntactic element."

	<acceleratorKey: 'Ctrl+U'>
	| node |
	node := self selectedNode.
	
	[node isNil
		ifTrue: 
			[Sound warningBeep.
			^self].
	self selectionRange = node sourceInterval]
			whileTrue: [node := node parent].
	self selectionRange: node sourceInterval! !

!Tools.MethodWorkspace categoriesForMethods!
accept!commands-actions!public! !
allVariablesVisibleFrom:do:!autocompletion!enumerating!private! !
applyOptions!operations!options!private! !
autoParse!helpers!private! !
browseAnnotatedMethods!commands-actions!public! !
browseBindingReferenceTarget!commands-actions!public! !
browseClass!commands-actions!public! !
browseClassOfLiteral!commands-actions!public! !
browseClassReferences!commands-actions!public! !
browseClassVariableDefinition!commands-actions!public! !
browseClassVariableReferences!commands-actions!public! !
browseDefinitionsCommand!commands-mappings!private! !
browseEnvironments:!browsing!private! !
browseInstanceVariableDefinition!commands-actions!public! !
browseInstanceVariableReferences!commands-actions!public! !
browseMessageDefinitions!commands-actions!public! !
browseMessageReferences!commands-actions!public! !
browseMessageTarget!commands-actions!public! !
browseReferencesCommand!commands-mappings!private! !
browseReferencesToBindingReference!commands-actions!public! !
browseSharedVariableDefinition!commands-actions!public! !
browseSharedVariableReferences!commands-actions!public! !
browseSpecialVariableDefinition!commands-actions!public! !
browseSpecialVariableReferences!commands-actions!public! !
browseTemporaryVariableDefinition!commands-actions!public! !
browseTemporaryVariableReferences!commands-actions!public! !
buildParseTree!helpers!private! !
canSaveMethod!commands-queries!private! !
changeSignature:in:operation:title:!commands-actions!public!refactoring! !
clear!operations!public! !
clearParseTree!helpers!private! !
completeInitialWord!autocompletion!helpers!private! !
createSchematicWiring!initializing!public! !
declareTemporary:!private! !
defaultStylerClass!constants!private! !
descriptionForVariableNode:!private! !
evaluationContext!accessing!public! !
formattedCode:!helpers!private! !
hasCompilationErrors!private! !
hasErrors!public!testing! !
hasSelectedMessage!private! !
hasUndeclaredVariables!private! !
initialize!initializing!private! !
isAutoParseEnabled!accessing!public! !
isAutoParseEnabled:!accessing!public! !
isEditable!private!testing! !
isLocalVariable:!private! !
isSelectionMatched!accessing!public! !
isSelectionMatched:!accessing!public! !
killParseTimer!helpers!private! !
lineFromPosition:!enquiries!public! !
method!accessing!private! !
nameBindingContext!accessing!autocompletion!private! !
nameForArgumentNode:!private! !
onTextChanged!event handling!public! !
onTimerTick:!event handling!public! !
onUpdateUI:!event handling!public! !
parseContext!accessing!private! !
parseTree!accessing!private! !
promptToSaveChanges!helpers!public! !
queryBrowseAnnotatedMethods:!commands-queries!private! !
queryBrowseBindingReferenceTarget:!commands-queries!private! !
queryBrowseClass:!commands-queries!private! !
queryBrowseClassReferences:!commands-queries!private! !
queryBrowseClassVariableDefinition:!commands-queries!private! !
queryBrowseClassVariableReferences:!commands-queries!private! !
queryBrowseInstanceVariableDefinition:!commands-queries!private! !
queryBrowseInstanceVariableReferences:!commands-queries!private! !
queryBrowseMessageSelector:!commands-queries!private! !
queryBrowseMessageTarget:!commands-queries!private! !
queryBrowseReferencesToBindingReference:!commands-queries!private! !
queryBrowseSharedVariableDefinition:!commands-queries!private! !
queryBrowseSharedVariableReferences:!commands-queries!private! !
queryBrowseSpecialVariableDefinition:!commands-queries!private! !
queryBrowseSpecialVariableReferences:!commands-queries!private! !
queryBrowseTemporaryVariableDefinition:!commands-queries!private! !
queryBrowseTemporaryVariableReferences:!commands-queries!private! !
queryBrowseVariableDefinition:classification:!commands-queries!private! !
queryBrowseVariableReferences:classification:!commands-queries!private! !
reformatAccept!commands-actions!public! !
reformatMenu!commands-menus!public! !
reformatSource!commands-actions!public! !
reformattedSource!helpers!private! !
repositionAtSourceLine:!operations!public! !
resetParseTimer!helpers!private! !
resolveVariableOfNode:!autocompletion!helpers!private! !
selectedErrorRange!accessing!private! !
selectedLiteralValue!helpers!private! !
selectedMessage!accessing!private! !
selectedMessageNode!accessing!private! !
selectedMethod!accessing!public! !
selectedNode!accessing!public! !
selectedSymbol!helpers!private! !
selectedVariable!helpers!private! !
selectionChanged!event handling!public! !
selectorFromNode:!helpers!private! !
selfClass!autocompletion!private! !
setParseTimer!helpers!private! !
source!accessing!public! !
source:!accessing!public! !
targetOfMessage:!helpers!private! !
variableClassification:!helpers!private! !
widenSourceSelection!commands-actions!public! !
!

!Tools.MethodWorkspace class methodsFor!

autoParseDwell
	"Answer the <Duration> that must elapse after the user stops typing before an attempt is made to pro-actively parse the method source for errors."

	self ensureOptionsLoaded.
	^AutoParseDwell ?? ##(1 seconds)!

autoParseDwell: aDuration
	"Set the <Duration> that must elapse after the user stops typing before an attempt is made to pro-actively parse the method source for errors."

	self autoParseDwell = aDuration ifTrue: [^self].
	AutoParseDwell := aDuration.
	self persistOptions!

invalidateLocalOptions
	AutoParseDwell := nil!

isAutoParseEnabled
	"Answer whether the method source will be automatically parsed after the user has paused for a short while."

	^self optionFlags noMask: NoAutoParseMask!

isAutoParseEnabled: aBoolean
	(self setOptionFlag: NoAutoParseMask value: aBoolean not)
		ifTrue: [self primAllSubinstances do: [:each | each isAutoParseEnabled: aBoolean]]!

loadOptions
	SmalltalkToolShell loadOptionsFor: ##(self).
	superclass loadOptions.
!

optionsAspects
	"Answer the aspects that, for this class only, should be saved and restored as options."

	^IdentityDictionary new
		add: ((Aspect dictionary: #acceleratorKeyBindings)
					beImmutable;
					defaultValue: [self defaultAcceleratorKeyBindings];
					yourself);
		add: ((Aspect duration: #autoParseDwell)
					defaultValue: 1 seconds;
					yourself);
		add: ((Aspect boolean: #isAutoParseEnabled)
					defaultValue: true;
					yourself);
		yourself!

persistOptions
	super persistOptions.
	^SmalltalkToolShell persistOptionsFor: ##(self)!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^super publishedAspects
		addAll: self optionsAspects;
		yourself!

resource_Debugger_source
	"Answer the literal data from which the 'Debugger source' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Debugger_source)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1445007684 262145 32 nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 2886 4 #{UI.Menu} nil true 50 22 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 194 1 226 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 194 1 226 #acceptNoRestart 8 'Accept &No Restart' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 194 1 226 #runToCursor 8 'Run to &Cursor' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'RunToCursor.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 194 1 226 #toggleBreakpoint 8 'To&ggle Breakpoint' 1 1 nil nil nil 194 1 226 #toggleDisassembly 8 'Disasse&mbly' 1 1 nil nil nil 370 4097 146 nil true 8 #() 8 'Au&to-correct' #autoCorrectMenu 134217729 nil nil nil nil nil 146 nil true 50 16 194 1 226 #renameIt 8 'Re&name <d:Node>…' 1 17 nil nil nil 370 4097 194 1 226 #extractToTemporary 8 'Extract to &Temporary…' 1 1 nil nil nil 194 1 226 #extractMethod 8 'E&xtract Method…' 1 1 nil nil nil 194 1 226 #extractToComponent 8 'Extract to &Component…' 1 5 nil nil nil 370 4097 194 1 226 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 146 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 370 4097 194 1 226 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 194 1 226 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 194 1 226 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 370 4097 194 1 226 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 17 nil nil nil 194 1 226 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 194 1 226 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 1 450 nil true 482 8 'Refactoring.ico' 544 65541 nil nil nil nil nil 370 4097 146 nil true 50 10 194 1 226 #undo 8 '&Undo' 1 1 450 nil true 482 8 'EditUndo.ico' 544 65541 nil nil nil 370 4097 194 1 226 #cutSelection 8 'Cu&t' 1 1 450 nil true 482 8 'EditCut.ico' 544 65541 nil nil nil 194 1 226 #copySelection 8 '&Copy' 1 1 450 nil true 482 8 'EditCopy.ico' 544 65541 nil nil nil 194 1 226 #pasteClipboard 8 '&Paste' 1 1 450 nil true 482 8 'EditPaste.ico' 544 65541 nil nil nil 194 1 226 #clearSelection 8 'De&lete' 1 1 450 nil true 482 8 'EditClear.ico' 544 65541 nil nil nil 370 4097 194 1 226 #reformatSource 8 'Re&format' 1 1 nil nil nil 370 4097 194 1 226 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 146 nil true 50 10 194 1 226 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 194 1 226 #cloneNew 8 '&Clone' 1 1 450 nil true 482 8 'SmalltalkWorkspace.ico' 544 65541 nil nil nil 370 4097 194 1 226 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 194 1 226 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 194 1 226 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 194 1 226 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 194 1 226 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 194 1 226 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 194 1 226 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 370 4097 194 1 226 #browseIt 8 'Bro&wse It' 1 1 450 nil true 482 8 'ClassBrowserShell.ico' 544 65541 nil nil nil 194 1 226 #displayIt 8 '&Display It' 1 1 450 nil true 482 8 'DisplayIt.ico' 544 65541 nil nil nil 194 1 226 #printIt 8 '&Print It' 1 1 450 nil true 482 8 'PrintIt.ico' 544 65541 nil nil nil 194 1 226 #evaluateIt 8 'E&valuate It' 1 1 450 nil true 482 8 'EvaluateIt.ico' 544 65541 nil nil nil 194 1 226 #inspectIt 8 '&Inspect It' 1 1 450 nil true 482 8 'InspectIt.ico' 544 65541 nil nil nil 194 1 226 #debugIt 8 'Deb&ug It' 1 1 450 nil true 482 8 'Debugger.ico' 544 65541 nil nil nil 370 4097 146 nil true 50 4 194 2097153 226 #browseDefinitions 8 '&Definitions of <d:…>' 1 17 nil nil nil 194 1 226 #browseReferences 8 '&References to <d:…>' 1 17 nil nil nil 370 4097 194 1 226 #browseMessageTarget 8 '<d:Message Target>' 1 17 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #explicit nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 6 #{Graphics.Color} #silver 3682 #white 1 nil nil nil nil #callTip nil nil nil #normal 3650 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkMethodStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 3618 2 #circle 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 32 #circle nil nil nil nil nil nil #currentLine 3826 3 9 nil 326 1 #{Graphics.RGB} 16889855 32 #currentLine nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 9215 nil nil 3938 2 23 114 #workspaceSelection 81 3682 #windowText nil 50 1 1030 #{UI.Scintilla.CharacterRepresentation} 8 $\x2028 nil 33 4000 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 3618 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 3618 1 #container 3632 nil nil nil nil #{Core.Utf8String} nil 3618 1 #currentExpression 3142 5 #{UI.Scintilla.IndicatorDefinition} 17 32 3682 #purple 15 3 #currentExpression nil nil nil nil nil nil nil nil 3618 3 #Error 3650 1031 3682 #firebrick 3682 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 3650 1029 nil 3682 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3650 1027 3682 #darkGoldenrod 3682 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 9 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 63 16 0 0 230 0 0 0] 193 80 nil 32 4450 #contextMenu: 50 1 160 32 4450 #sciSetMouseDwellTime: 8 #(500) 32 4450 #wordWrap: 8 #(true) 32 4450 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 32 nil 3 nil nil nil nil 4722 3 32 33 nil nil 67108863 nil nil 4722 5 32 nil nil nil nil nil nil 32 4450 #tabWidth: 8 #(4) 32 4450 #maxCompletionListHeight: 8 #(9) 32 4450 #hasAdditionalSelectionTyping: 8 #(true) 32 4450 #sciSetSelectionLayer: 8 #(1) 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 45)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 11 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1445007684 1 32 nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 2886 4 #{UI.Menu} nil true 50 18 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 194 1 226 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 146 nil true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 nil nil nil nil nil 146 nil true 50 16 194 1 226 #renameIt 8 'Re&name <d:Node>…' 1 17 nil nil nil 322 4097 194 1 226 #extractToTemporary 8 'Extract to &Temporary…' 1 1 nil nil nil 194 1 226 #extractMethod 8 'E&xtract Method…' 1 1 nil nil nil 194 1 226 #extractToComponent 8 'Extract to &Component…' 1 5 nil nil nil 322 4097 194 1 226 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 146 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 322 4097 194 1 226 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 194 1 226 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 194 1 226 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 322 4097 194 1 226 #addParameterToMessage 8 '&Add Parameter to <d:Message>…' 1 17 nil nil nil 194 1 226 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 194 1 226 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'Refactoring.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil nil nil 146 nil true 50 2 194 1 226 #reformatSource 8 '&Source' 1 1 nil nil nil 194 1 226 #reformatComment 8 '&Comment' 1 1 nil nil nil 8 'Re&format' #reformatMenu 1 nil nil nil nil nil 322 4097 146 nil true 50 9 194 1 226 #undo 8 '&Undo' 1 1 1090 nil true 1122 8 'EditUndo.ico' 1184 65541 nil nil nil 322 4097 194 1 226 #cutSelection 8 'Cu&t' 1 1 1090 nil true 1122 8 'EditCut.ico' 1184 65541 nil nil nil 194 1 226 #copySelection 8 '&Copy' 1 1 1090 nil true 1122 8 'EditCopy.ico' 1184 65541 nil nil nil 194 1 226 #pasteClipboard 8 '&Paste' 1 1 1090 nil true 1122 8 'EditPaste.ico' 1184 65541 nil nil nil 194 1 226 #clearSelection 8 'De&lete' 1 1 1090 nil true 1122 8 'EditClear.ico' 1184 65541 nil nil nil 322 4097 194 1 226 #selectAll 8 '&Select All' 1 1 nil nil nil 194 1 226 #widenSourceSelection 8 '&Widen Selection' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 146 nil true 50 10 194 1 226 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 194 1 226 #cloneNew 8 '&Clone' 1 1 1090 nil true 1122 8 'SmalltalkWorkspace.ico' 1184 65541 nil nil nil 322 4097 194 1 226 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 194 1 226 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 194 1 226 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 194 1 226 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 194 1 226 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 194 1 226 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 194 1 226 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 322 4097 194 1 226 #browseIt 8 'Bro&wse <d:It>' 1 17 1090 nil true 1122 8 'ClassBrowserShell.ico' 1184 65541 nil nil nil 194 1 226 #displayIt 8 '&Display It' 1 1 1090 nil true 1122 8 'DisplayIt.ico' 1184 65541 nil nil nil 194 1 226 #printIt 8 '&Print It' 1 1 1090 nil true 1122 8 'PrintIt.ico' 1184 65541 nil nil nil 194 1 226 #evaluateIt 8 'E&valuate It' 1 1 1090 nil true 1122 8 'EvaluateIt.ico' 1184 65541 nil nil nil 194 1 226 #inspectIt 8 '&Inspect It' 1 1 1090 nil true 1122 8 'InspectIt.ico' 1184 65541 nil nil nil 194 1 226 #debugIt 8 'Deb&ug It' 1 1 1090 nil true 1122 8 'Debugger.ico' 1184 65541 nil nil nil 322 4097 146 nil true 50 4 194 2097153 226 #browseDefinitions 8 'Defi&nitions of <d:…>' 1 17 nil nil nil 194 1 226 #browseReferences 8 '&References to <d:…>' 1 17 nil nil nil 322 4097 194 1 226 #browseMessageTarget 8 'Target of Message...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #explicit nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 6 #{Graphics.Color} #gray 3554 #white 1 nil nil nil nil #callTip nil nil nil #normal 3522 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkMethodStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 3490 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 32 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 3762 2 23 114 #workspaceSelection 81 3554 #windowText nil 50 1 1030 #{UI.Scintilla.CharacterRepresentation} 8 $\x2028 nil 33 3824 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 3490 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 3490 1 #container 3504 nil nil nil nil #{Core.Utf8String} nil 3490 0 nil nil 3490 3 #Error 3522 1031 3554 #firebrick 3554 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 3522 1029 nil 3554 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 3522 1027 3554 #darkGoldenrod 3554 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 9 774 #{Core.MessageSend} #createWindow: 50 1 1030 #{UI.CreateWindow} 262 #{OS.RECTL} 8 #[255 14 0 0 10 0 0 0 63 16 0 0 230 0 0 0] 193 80 nil 32 4226 #contextMenu: 50 1 160 32 4226 #sciSetMouseDwellTime: 8 #(500) 32 4226 #wordWrap: 8 #(true) 32 4226 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 32 nil 3 nil nil nil nil 4498 3 32 nil nil nil 67108863 nil nil 4498 5 32 nil nil nil nil nil nil 32 4226 #backspaceUnindents: 8 #(true) 32 4226 #maxCompletionListHeight: 8 #(9) 32 4226 #hasAdditionalSelectionTyping: 8 #(true) 32 4226 #sciSetSelectionLayer: 8 #(1) 32 1 8 #() 518 #{Graphics.Point} 193 193 nil 45)! !

!Tools.MethodWorkspace class categoriesForMethods!
autoParseDwell!accessing!public! !
autoParseDwell:!accessing!public! !
invalidateLocalOptions!private! !
isAutoParseEnabled!accessing!public! !
isAutoParseEnabled:!accessing!public! !
loadOptions!public! !
optionsAspects!public! !
persistOptions!public! !
publishedAspects!public! !
resource_Debugger_source!public!resources-views! !
resource_Default_view!public!resources-views! !
!

