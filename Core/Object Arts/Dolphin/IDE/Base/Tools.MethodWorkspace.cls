"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkWorkspace
	subclass: #'Tools.MethodWorkspace'
	instanceVariableNames: 'parseTree refactoringTool'
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

applyOptions
	"Private - Apply the class options to the receiver"

	super applyOptions.
	self isAutoParseEnabled: self class isAutoParseEnabled!

autoParse
	self textLength > 0 ifFalse: [^self].
	
	[| ast |
	ast := self parseTree.
	BrowserSemanticAnalyser analyseParseTree: ast pools: self allPools onError: nil]
			on: Parser notificationClass
			do: 
				[:err |
				"err toTrace"
				compilationErrors addLast: err.
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
			literalType := node valueClass.
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

browseLiteralReferences
	"Open a method browser showing references to the value of the current literal node. Note this can be any literal value, not just symbols. For example you can search for all occurrences of String 'abc' in the system, or $🐬"

	<commandQuery: #queryBrowseLiteralReferences:>
	self browseReferencesMatching: (MethodSearch newLiteral: self selectedNode value)!

browseMessageDefinitions
	"Browse definitions of the object identified by the node under the cursor."

	<commandQuery: #queryBrowseMessage:>
	self browseDefinitionsMatching: (MethodSearch newLiteral: self selectedNode selector)!

browseMessageReferences
	"Open a method browser showing references to the current message or literal symbol node."

	<commandQuery: #queryBrowseMessage:>
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
	parseContext := self parseContext ifNil: [self defaultParseContext].
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
	^[self parseSourceIn: parseContext] on: Compiler notificationClass
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

	parseTree := DeafObject.Current.
	self resetParseTimer!

contextBindingFor: aString 
	self allPools do: [:each | (each bindingFor: aString) ifNotNil: [:binding | ^binding]].
	^nil!

createComponents
	"Create the presenters contained by the receiver. At this stage the receiver has not yet
	been initialized."

	super createComponents.
	refactoringTool := self developmentSystem newCodeRefactoringToolFor: self"Private - Answer the development system model."!

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

	^evaluationContext
		ifNil: [self parseContext ifNotNil: [:context | context methodClass instanceClass]]!

formattedCode: aStProgramNode
	^aStProgramNode formattedCode!

hasErrors
	"Answer whether there are any errors in the source code (not warnings)"

	^self parseTree isNil or: [super hasErrors]!

initialize
	super initialize.
	self isAutoParseEnabled: self class isAutoParseEnabled!

isAutoParseEnabled
	^flags noMask: NoAutoParseMask!

isAutoParseEnabled: aBoolean
	flags := flags mask: NoAutoParseMask set: aBoolean not!

isEditable
	^super isEditable and: [parentPresenter hasEditableMethodSelected]!

isSelectionMatched
	^flags noMask: NoSelectionMatching!

isSelectionMatched: aBoolean
	flags := flags mask: NoSelectionMatching set: aBoolean not!

isTempVariable: aStVariableNode
	"Private - Answer whether the specified variable node represents one of the temporaries in
	the current method (note that parameters are included)."

	self parseTree allDefinedVariableNodesDo: [:each | each = aStVariableNode ifTrue: [^true]].
	^false!

killParseTimer
	self view killTimer: 1000!

lineFromPosition: anInteger 
	^view lineFromPosition: anInteger!

method
	Notification deprecated.
	^self selectedMethod!

nameBindingContext
	^evaluationContext
		ifNil: [self parseContext ifNil: [self defaultParseContext]]
		ifNotNil: 
			[:context |
			| class |
			class := context basicClass.
			ParseContext methodClass: class environment: class environment]!

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

	anSCNotification updated == SC_UPDATE_SELECTION
		ifTrue: [self selectionChanged].
!

parseContext
	^parentPresenter ifNotNil: [:p | p parseContext]!

parseSourceIn: aParseContext
	^Parser
		parseMethod: self source
		in: aParseContext methodClass
		environment: aParseContext environment!

parseTree
	parseTree == DeafObject.Current ifTrue: [parseTree := self buildParseTree].
	^parseTree!

promptToSaveChanges
	^parentPresenter promptToSaveChanges!

queryBrowseAnnotatedMethods: aCommandQuery
	| node |
	node := self selectedNode.
	aCommandQuery isEnabled: node isTag.
	(aCommandQuery menuText includes: $<)
		ifTrue: 
			[aCommandQuery text: ('Methods with annotation <1d>'
						expandMacrosWithArguments: { node isTag ifTrue: [node value selector] ifFalse: [$…] }
						locale: Locale smalltalk)]!

queryBrowseBindingReferenceTarget: aCommandQuery
	| node |
	node := self selectedNode.
	((node isLiteralNode and: [node valueClass == BindingReference]) ifTrue: [node value bindingOrNil])
		ifNotNil: 
			[:binding |
			aCommandQuery isEnabled: true.
			(aCommandQuery menuText includes: $<)
				ifTrue: 
					[aCommandQuery
						text: 'Class <1p>' << (binding isClassVariable
										ifTrue: [binding environment]
										ifFalse: [binding value class instanceClass])]]!

queryBrowseClass: aCommandQuery
	^self queryBrowseVariableDefinition: aCommandQuery classification: #classGlobal!

queryBrowseClassOfLiteral: aCommandQuery
	| node |
	node := self selectedNode.
	node isLiteralNode
		ifTrue: 
			[aCommandQuery isEnabled: true.
			(aCommandQuery menuText includes: $<)
				ifTrue: [aCommandQuery text: 'Class <1p>' << node value class]]!

queryBrowseClassReferences: aCommandQuery
	^self queryBrowseVariableReferences: aCommandQuery classification: #classGlobal!

queryBrowseClassVariableDefinition: aCommandQuery
	| var |
	var := self selectedVariable.
	(var notNil and: [var classification == #class])
		ifTrue: 
			[aCommandQuery isEnabled: true.
			(aCommandQuery menuText includes: $<)
				ifTrue: 
					[aCommandQuery
						text: ('Class <1p>' expandMacrosWithArguments: { var binding environment } locale: Locale smalltalk)]]!

queryBrowseClassVariableReferences: aCommandQuery
	| var |
	var := self selectedVariable.
	(var notNil and: [var classification == #class])
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText expandMacrosWithArguments: { var binding shortName }
							locale: Locale smalltalk)]!

queryBrowseInstanceVariableDefinition: aCommandQuery
	| var |
	var := self selectedVariable.
	var classification == #instance
		ifTrue: 
			[aCommandQuery isEnabled: true.
			(aCommandQuery menuText includes: $<)
				ifTrue: 
					[aCommandQuery text: ('Class <1p>'
								expandMacrosWithArguments: { self parseContext methodClass whichClassDefinesInstVar: var name }
								locale: Locale smalltalk)]]!

queryBrowseInstanceVariableReferences: aCommandQuery
	| var |
	var := self selectedVariable.
	var classification == #instance
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText expandMacrosWithArguments: {
									'<1p>.<2s>'
										<< { self parseContext methodClass whichClassDefinesInstVar: var name. var name }
								}
							locale: Locale smalltalk)]!

queryBrowseLiteralReferences: aCommandQuery
	| node |
	node := self selectedNode.
	node isLiteralNode
		ifTrue: 
			[| literal |
			literal := node value.
			aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText
							expandMacrosWithArguments: { literal species name , ' ' , literal printString }
							locale: Locale smalltalk)]!

queryBrowseMessage: aCommandQuery
	| node message |
	node := self selectedNode.
	message := node isMessage ifTrue: [node selector].
	aCommandQuery
		isEnabled: message notNil;
		text: (aCommandQuery menuText expandMacrosWithArguments: { message ?? '…' }
					locale: Locale smalltalk)!

queryBrowseMessageTarget: aCommandQuery
	| node method |
	node := self selectedMessageNode.
	method := node notNil
				ifTrue: [(self targetOfMessage: node) ifNotNil: [:target | target lookupMethod: node selector]].
	aCommandQuery
		isEnabled: method notNil;
		text: (aCommandQuery menuText expandMacrosWithArguments: { method ?? 'Target of Message…' }
					locale: Locale smalltalk)!

queryBrowseReferencesToBindingReference: aCommandQuery
	| node |
	node := self selectedNode.
	(node isLiteralNode and: [node valueClass == BindingReference])
		ifTrue: 
			[aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText expandMacrosWithArguments: { node value printString }
							locale: Locale smalltalk)]!

queryBrowseSelectorDefinitions: aCommandQuery
	| node |
	node := self selectedNode.
	((node isLiteralNode and: [node valueClass == Symbol]) ifTrue: [node value])
		ifNotNil: 
			[:selector |
			aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText expandMacrosWithArguments: { 'selector <1p>' << selector }
							locale: Locale smalltalk)]!

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
			aCommandQuery isEnabled: true.
			(aCommandQuery menuText includes: $<)
				ifTrue: 
					[aCommandQuery
						text: ('Class <1p>' expandMacrosWithArguments: { valueClass instanceClass } locale: Locale smalltalk)]]!

queryBrowseVariableReferences: aCommandQuery classification: aSymbol
	| var |
	var := self selectedVariable.
	((var notNil and: [var classification == aSymbol]) ifTrue: [self suggestClassForVariable: var])
		ifNotNil: 
			[:valueClass |
			aCommandQuery
				isEnabled: true;
				text: (aCommandQuery menuText expandMacrosWithArguments: { valueClass instanceClass shortName }
							locale: Locale smalltalk)]!

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
	^self selectedNode value!

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
addToCommandRoute:!commands-routing!public! !
allDefinedVariablesDo:!autocompletion!enumerating!private! !
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
browseLiteralReferences!commands-actions!public! !
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
clear!operations!public! !
clearParseTree!helpers!private! !
contextBindingFor:!private!refactoring! !
createComponents!initializing!public! !
createSchematicWiring!initializing!public! !
defaultStylerClass!constants!private! !
evaluationContext!accessing!public! !
formattedCode:!helpers!private! !
hasErrors!public!testing! !
initialize!initializing!private! !
isAutoParseEnabled!accessing!public! !
isAutoParseEnabled:!accessing!public! !
isEditable!private!testing! !
isSelectionMatched!accessing!public! !
isSelectionMatched:!accessing!public! !
isTempVariable:!private!refactoring! !
killParseTimer!helpers!private! !
lineFromPosition:!enquiries!public! !
method!accessing!private! !
nameBindingContext!accessing!autocompletion!private! !
onAboutToDisplayMenu:!event handling!public! !
onTextChanged!event handling!public! !
onTimerTick:!event handling!public! !
onUpdateUI:!event handling!public! !
parseContext!accessing!private! !
parseSourceIn:!helpers!private! !
parseTree!accessing!private! !
promptToSaveChanges!helpers!public! !
queryBrowseAnnotatedMethods:!commands-queries!private! !
queryBrowseBindingReferenceTarget:!commands-queries!private! !
queryBrowseClass:!commands-queries!private! !
queryBrowseClassOfLiteral:!commands-queries!private! !
queryBrowseClassReferences:!commands-queries!private! !
queryBrowseClassVariableDefinition:!commands-queries!private! !
queryBrowseClassVariableReferences:!commands-queries!private! !
queryBrowseInstanceVariableDefinition:!commands-queries!private! !
queryBrowseInstanceVariableReferences:!commands-queries!private! !
queryBrowseLiteralReferences:!commands-queries!private! !
queryBrowseMessage:!commands-queries!private! !
queryBrowseMessageTarget:!commands-queries!private! !
queryBrowseReferencesToBindingReference:!commands-queries!private! !
queryBrowseSelectorDefinitions:!commands-queries!private! !
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
selectedErrorRange!accessing!private!refactoring! !
selectedMessage!accessing!private! !
selectedMessageNode!accessing!private!refactoring! !
selectedMethod!accessing!public! !
selectedNode!accessing!public! !
selectedSymbol!commands-actions!public! !
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 34 52 nil nil 34 2 8 1445007684 262145 416 nil 1245702 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 461638 4 #{UI.Menu} nil true 34 22 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 562 1 594 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 562 1 594 #acceptNoRestart 8 'Accept &No Restart' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 562 1 594 #runToCursor 8 'Run to &Cursor' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'RunToCursor.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 562 1 594 #toggleBreakpoint 8 'To&ggle Breakpoint' 1 1 nil nil nil 562 1 594 #toggleDisassembly 8 'Disasse&mbly' 1 1 nil nil nil 738 4097 514 nil true 8 #() 8 'Au&to-correct' #autoCorrectMenu 134217729 nil nil nil nil nil 514 nil true 34 16 562 1 594 #renameNode 8 'Re&name <1d>…' 1 1 nil nil nil 738 4097 562 1 594 #extractToTemporary 8 'Extract to &Temporary…' 1 1 nil nil nil 562 1 594 #extractMethod 8 'E&xtract Method…' 1 1 nil nil nil 562 1 594 #extractToComponent 8 'Extract to &Component…' 1 5 nil nil nil 738 4097 562 1 594 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 514 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 738 4097 562 1 594 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 562 1 594 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 562 1 594 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 738 4097 562 1 594 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 562 1 594 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 562 1 594 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 1 818 nil true 850 8 'Refactoring.ico' 912 65541 nil nil nil nil nil 738 4097 514 nil true 34 10 562 1 594 #undo 8 '&Undo' 1 1 818 nil true 850 8 'EditUndo.ico' 912 65541 nil nil nil 738 4097 562 1 594 #cutSelection 8 'Cu&t' 1 1 818 nil true 850 8 'EditCut.ico' 912 65541 nil nil nil 562 1 594 #copySelection 8 '&Copy' 1 1 818 nil true 850 8 'EditCopy.ico' 912 65541 nil nil nil 562 1 594 #pasteClipboard 8 '&Paste' 1 1 818 nil true 850 8 'EditPaste.ico' 912 65541 nil nil nil 562 1 594 #clearSelection 8 'De&lete' 1 1 818 nil true 850 8 'EditClear.ico' 912 65541 nil nil nil 738 4097 562 1 594 #reformatSource 8 'Re&format' 1 1 nil nil nil 738 4097 562 1 594 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 514 nil true 34 10 562 1 594 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 562 1 594 #cloneNew 8 '&Clone' 1 1 818 nil true 850 8 'SmalltalkWorkspace.ico' 912 65541 nil nil nil 738 4097 562 1 594 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 562 1 594 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 562 1 594 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 562 1 594 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 562 1 594 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 562 1 594 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 562 1 594 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 738 4097 562 1 594 #browseIt 8 'Bro&wse It' 1 1 818 nil true 850 8 'ClassBrowserShell.ico' 912 65541 nil nil nil 562 1 594 #displayIt 8 '&Display It' 1 1 818 nil true 850 8 'DisplayIt.ico' 912 65541 nil nil nil 562 1 594 #printIt 8 '&Print It' 1 1 818 nil true 850 8 'PrintIt.ico' 912 65541 nil nil nil 562 1 594 #evaluateIt 8 'E&valuate It' 1 1 818 nil true 850 8 'EvaluateIt.ico' 912 65541 nil nil nil 562 1 594 #inspectIt 8 '&Inspect It' 1 1 818 nil true 850 8 'InspectIt.ico' 912 65541 nil nil nil 562 1 594 #debugIt 8 'Deb&ug It' 1 1 818 nil true 850 8 'Debugger.ico' 912 65541 nil nil nil 738 4097 514 nil true 34 4 562 2097153 594 #browseDefinitions 8 '&Definitions of <1d>' 1 1 nil nil nil 562 1 594 #browseReferences 8 '&References to <1d>' 1 1 nil nil nil 738 4097 562 1 594 #browseMessageTarget 8 '<1d>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 4034 77 917510 #{Graphics.Color} #silver 4082 #white 1 nil nil nil nil #callTip nil nil nil nil 1770758 #{Tools.SmalltalkMethodStyler} 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 4176 nil 170 176 4176 9215 nil nil 170 176 34 4 81 4082 #windowText 23 482 #workspaceSelection nil 34 1 2360326 #{UI.Scintilla.CharacterRepresentation} $\x2028 nil 33 4320 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 4000 nil nil nil nil 208 nil 170 192 4176 nil nil 170 192 34 6 #Notification 4034 1029 nil 4082 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 4034 1031 4082 #firebrick 4082 #floralWhite 1 nil nil nil nil #Error nil nil nil #Warning 4034 1027 4082 #darkGoldenrod 4082 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 9 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 4834 641 441 416 4786 #contextMenu: 34 1 528 416 4786 #sciSetMouseDwellTime: 8 #(500) 416 4786 #wordWrap: 8 #(true) 416 4786 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 416 1 3 nil nil nil nil 5026 3 416 1 nil nil 67108863 nil nil 5026 5 416 1 nil nil nil nil nil 416 4786 #tabWidth: 8 #(4) 416 4786 #maxCompletionListHeight: 8 #(9) 416 4786 #hasAdditionalSelectionTyping: 8 #(true) 416 4786 #sciSetSelectionLayer: 8 #(1) 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 63 25 0 0 230 0 0 0] 8 #() 4834 193 193 nil 35)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 34 52 nil nil 34 2 8 1445007684 1 416 nil 1245702 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 461638 4 #{UI.Menu} nil true 34 18 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 562 1 594 #reformatAccept 8 'Ref&ormat/Accept' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 514 nil true 8 #() 8 'Auto-&correct' #autoCorrectMenu 134217729 nil nil nil nil nil 514 nil true 34 16 562 1 594 #renameNode 8 'Re&name <1d>…' 1 1 nil nil nil 690 4097 562 1 594 #extractToTemporary 8 'Extract to &Temporary…' 1 1 nil nil nil 562 1 594 #extractMethod 8 'E&xtract Method…' 1 1 nil nil nil 562 1 594 #extractToComponent 8 'Extract to &Component…' 1 5 nil nil nil 690 4097 562 1 594 #inlineMessage 8 'Inline &Message' 1 1 nil nil nil 514 nil true 8 #() 8 'Impl&ement Message In' #implementMessageMenu 134217729 nil nil nil nil nil 690 4097 562 1 594 #inlineTemporary 8 '&Inline Temporary' 1 1 nil nil nil 562 1 594 #moveTempToInnerScope 8 'Move to Inner &Scope' 1 1 nil nil nil 562 1 594 #convertTempToInstVar 8 'Con&vert to Instance Variable' 1 1 nil nil nil 690 4097 562 1 594 #addParameterToMessage 8 '&Add Parameter to <1d>…' 1 1 nil nil nil 562 1 594 #inlineParameter 8 'In&line Parameter' 1 1 nil nil nil 562 1 594 #removeParameter 8 'Remove &Parameter' 1 1 nil nil nil 8 '&Refactorings' #codeRefactoringsMenu 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'Refactoring.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil nil nil 514 nil true 34 2 562 1 594 #reformatSource 8 '&Source' 1 1 nil nil nil 562 1 594 #reformatComment 8 '&Comment' 1 1 nil nil nil 8 'Re&format' #reformatMenu 1 nil nil nil nil nil 690 4097 514 nil true 34 9 562 1 594 #undo 8 '&Undo' 1 1 1458 nil true 1490 8 'EditUndo.ico' 1552 65541 nil nil nil 690 4097 562 1 594 #cutSelection 8 'Cu&t' 1 1 1458 nil true 1490 8 'EditCut.ico' 1552 65541 nil nil nil 562 1 594 #copySelection 8 '&Copy' 1 1 1458 nil true 1490 8 'EditCopy.ico' 1552 65541 nil nil nil 562 1 594 #pasteClipboard 8 '&Paste' 1 1 1458 nil true 1490 8 'EditPaste.ico' 1552 65541 nil nil nil 562 1 594 #clearSelection 8 'De&lete' 1 1 1458 nil true 1490 8 'EditClear.ico' 1552 65541 nil nil nil 690 4097 562 1 594 #selectAll 8 '&Select All' 1 1 nil nil nil 562 1 594 #widenSourceSelection 8 '&Widen Selection' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 514 nil true 34 10 562 1 594 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 562 1 594 #cloneNew 8 '&Clone' 1 1 1458 nil true 1490 8 'SmalltalkWorkspace.ico' 1552 65541 nil nil nil 690 4097 562 1 594 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 562 1 594 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 562 1 594 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 562 1 594 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 562 1 594 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 562 1 594 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 562 1 594 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 690 4097 562 1 594 #browseIt 8 'Bro&wse It' 1 1 1458 nil true 1490 8 'ClassBrowserShell.ico' 1552 65541 nil nil nil 562 1 594 #displayIt 8 '&Display It' 1 1 1458 nil true 1490 8 'DisplayIt.ico' 1552 65541 nil nil nil 562 1 594 #printIt 8 '&Print It' 1 1 1458 nil true 1490 8 'PrintIt.ico' 1552 65541 nil nil nil 562 1 594 #evaluateIt 8 'E&valuate It' 1 1 1458 nil true 1490 8 'EvaluateIt.ico' 1552 65541 nil nil nil 562 1 594 #inspectIt 8 '&Inspect It' 1 1 1458 nil true 1490 8 'InspectIt.ico' 1552 65541 nil nil nil 562 1 594 #debugIt 8 'Deb&ug It' 1 1 1458 nil true 1490 8 'Debugger.ico' 1552 65541 nil nil nil 690 4097 514 nil true 34 4 562 2097153 594 #browseDefinitions 8 'Defi&nitions of <1d>' 1 1 nil nil nil 562 1 594 #browseReferences 8 '&References to <1d>' 1 1 nil nil nil 690 4097 562 1 594 #browseMessageTarget 8 '<1d>' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 3906 77 917510 #{Graphics.Color} #gray 3954 #white 1 nil nil nil nil #callTip nil nil nil nil 1770758 #{Tools.SmalltalkMethodStyler} 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 4048 nil 170 176 4048 nil nil nil 170 176 34 4 81 3954 #windowText 23 482 #workspaceSelection nil 34 1 2360326 #{UI.Scintilla.CharacterRepresentation} $\x2028 nil 33 4192 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 3872 nil nil nil nil 208 nil 170 192 4048 nil nil 170 192 34 6 #Notification 3906 1029 nil 3954 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Error 3906 1031 3954 #firebrick 3954 #floralWhite 1 nil nil nil nil #Error nil nil nil #Warning 3906 1027 3954 #darkGoldenrod 3954 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 9 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 4706 641 441 416 4658 #contextMenu: 34 1 528 416 4658 #sciSetMouseDwellTime: 8 #(500) 416 4658 #wordWrap: 8 #(true) 416 4658 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 416 1 3 nil nil nil nil 4898 3 416 1 nil nil 67108863 nil nil 4898 5 416 1 nil nil nil nil nil 416 4658 #backspaceUnindents: 8 #(true) 416 4658 #maxCompletionListHeight: 8 #(9) 416 4658 #hasAdditionalSelectionTyping: 8 #(true) 416 4658 #sciSetSelectionLayer: 8 #(1) 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 63 25 0 0 230 0 0 0] 8 #() 4706 193 193 nil 35)! !
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

