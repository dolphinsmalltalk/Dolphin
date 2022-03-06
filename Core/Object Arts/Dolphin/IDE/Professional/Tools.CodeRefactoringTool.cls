"Filed out from Dolphin Smalltalk"!

Tools.RefactoringTool subclass: #'Tools.CodeRefactoringTool'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Kernel.ParseErrorCodes})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.CodeRefactoringTool guid: (Core.GUID fromString: '{9f149efa-c85c-464f-8eb3-43de901960b3}')!
Tools.CodeRefactoringTool comment: '.CodeRefactoringTool implements code refactorings for a code workspace. Its container will typically be a <MethodWorkspace>.

CodeRefactoringTool implements the following refactorings:
	Convert to Instance Variable
	Extract to Component
	Extract Method
	Extract Temporary
	Inline Message
	Inline Parameter
	Inline Temporary
	Move Temp to Inner Scope
	Remove Parameter
	Rename Class Variable
	Rename Instance Variable
	Rename Parameter
	Rename Temporary
	Rename Message*

*Can rename messages sent to self, super, static variables and literals, and when hosted in the debugger temporaries and instance variables as well, i.e. where the type of the receiver is known so that the method to rename can be located.'!
!Tools.CodeRefactoringTool categoriesForClass!Unclassified! !
!Tools.CodeRefactoringTool methodsFor!

addClassVariable: aStVariableNode to: aClass 
	self systemModel addClassVariable: aStVariableNode name to: aClass.
	presenter clearParseTree!

addInstanceVariable: aStVariableNode to: aClass 
	self systemModel addInstanceVariable: aStVariableNode name to: aClass.
	presenter clearParseTree!

addParameterCommand
	^presenter selectedMessageNode 
		ifNotNil: 
			[:node | 
			(presenter targetOfMessage: node) 
				ifNotNil: 
					[:target | 
					self 
						changeSignatureCommandFor: node
						in: target
						operation: [:method | self systemModel addParameterToMethod: method]
						title: 'Add Parameter']]!

addParameterToMessage
	self addParameterCommand value: self!

addSharedVariable: aStVariableNode to: aNamespace
	self systemModel addSharedVariable: aStVariableNode name to: aNamespace.
	presenter clearParseTree!

canPerformCodeRefactoring
	^presenter canRefactor and: [presenter isModified not]!

canRenameNode
	^presenter canRefactor and: [presenter isModified not and: [self selectedNode notNil]]!

changeSignature: aSymbol in: methodClass operation: aMonadicValuable title: titleString
	presenter performMethodRenameRefactoring: 
			[:method |
			(methodClass lookupMethod: aSymbol)
				ifNotNil: [:renamedMethod | presenter executeRefactoring: aMonadicValuable with: renamedMethod]
				ifNil: 
					[MessageBox errorMsg: ('<2p> is not defined in <1p>' expandMacrosWith: methodClass with: aSymbol)
						caption: ('<3s> send of <2p> in <1p>…'
								expandMacrosWith: methodClass
								with: aSymbol
								with: titleString).
					nil]]!

changeSignatureCommandFor: aStMessageNode in: aClass operation: aMonadicValuable title: aString
	"Private - Determines the receiver of a message under the caret, and if possible works out
	its class. Answers an appropriate <Message> which when sent to the receiver will initiate a
	method signature changing refactoring (e.g. a selector rename) of the appropriate method, by
	evaluating the <MonadicValuable> argument passing it that method. If the class of the
	receiver cannot be determined quickly (e.g. it is an instance variable reference in a method
	browser), then answer nil. Note that when hosted by the Debugger we can normally do a
	complete job because all initialised variables have a type we can use to lookup the method."

	^Message selector: #changeSignature:in:operation:title:
		arguments: {aStMessageNode selector. aClass. aMonadicValuable. aString}!

contextBindingFor: aString 
	^presenter contextBindingFor: aString!

convertTempToInstVar
	"Convert the selected temporary variable (or that under the cursor) to an instance variable,
	i.e. perform a 'Convert to Instance Variable' refactoring."

	self convertTempToInstVar: self selectedNode!

createClassForVariable: aStVariableNode
	| dialog |
	dialog := CreateSubclassDialog newSubclassOf: Object
				inPackage: presenter parseContext owningPackage.
	dialog subclassName: aStVariableNode name.
	dialog showModal.
	dialog answer isNil ifTrue: [^self].
	self systemModel
		createSubclass: dialog subclassName asSymbol
		of: dialog superclass
		package: dialog package
		subclasses: dialog subclasses.
	presenter clearParseTree!

declareAllUndeclaredVariablesAsTemps
	| ast undeclared |
	ast := self parseTree.
	undeclared := LookupTable new.
	presenter compilationErrors do: 
			[:each | 
			each errorCode = CErrUndeclared 
				ifTrue: 
					[| identifier |
					identifier := presenter plainTextRange: each range.
					undeclared at: identifier ifAbsentPut: each]].
	undeclared do: 
			[:each | 
			| var |
			var := ast whichNodeIsContainedBy: each range.
			(var notNil and: [var isVariable]) ifTrue: [self declareTemporary: var]]!

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
	presenter view
		targetRange: target;
		replaceTarget: insert!

emitKeywordSignatureFor: aStMessageNode in: aClass on: aPuttableStream 
	| argNames instVars |
	argNames := OrderedCollection new.
	instVars := aClass allInstanceVariableNames.
	argNames addAll: instVars.
	aStMessageNode selector keywords with: aStMessageNode arguments
		do: 
			[:keyword :arg | 
			| x argName argNameStem |
			aPuttableStream
				nextPutAll: keyword;
				space.
			argName := argNameStem := self nameForArgument: arg.
			x := 1.
			[argNames includes: argName] whileTrue: [argName := argNameStem , (x := x + 1) printString].
			argNames add: argName.
			aPuttableStream
				nextPutAll: argName;
				space].
	^argNames copyFrom: instVars size + 1!

extractionRange
	| interval |
	#todo.	"Can do a bit better here. The selected node interval can be used to simplify
		selection of the selection range (it doesn't have to be exact), but one then has to
		handle the case of multiple statements being selected. Where that is so the
		'selectedNode' will be the whole method."
	interval := presenter view selectionRange.
	interval isEmpty ifTrue: [interval := self selectedNode sourceInterval].
	^interval!

extractMethod
	"Create a new method from the selected text of the current method, i.e. perform an 'Extract
	Method' refactoring."

	presenter performMethodRefactoring: 
			[:method | 
			| interval |
			interval := self extractionRange.
			(self systemModel 
				extractMethod: interval
				from: method selector
				in: method methodClass) isNil 
				ifFalse: [presenter caretPosition: interval start]]!

extractToComponent
	"Extract the selected source text to form a new method in the class of some variable in the
	selected method's scope, i.e. perform an 'Extract to Component' refactoring."

	presenter performMethodRefactoring: 
			[:method | 
			self systemModel 
				extractToComponent: self extractionRange
				from: method selector
				in: method methodClass]!

extractToTemporary
	"Extract the selected text of the current method into an assignment to a temporary
	(i.e. perform an 'Extract to Temporary' refactoring)."

	presenter performCodeRefactoring: 
			[:method :node | 
			| line interval result |
			interval := node sourceInterval.
			line := presenter lineFromPosition: interval start.
			result := self systemModel 
						extractToTemporary: interval
						from: method selector
						in: method methodClass.
			result notNil 
				ifTrue: 
					["Try and keep the caret on the same line, accounting for the new lines that will be inserted"
					presenter repositionAtSourceLine: line 
								+ (node statementNode parent allTemporaryVariableNodes isEmpty ifTrue: [2] ifFalse: [1])].
			result]!

findAssignmentsToTemp: aStVariableNode 
	"Private - Find and answer the collection of nodes which represent assignments to the
	temporary variable represented by the argument in the same or an enclosing scope."

	| searcher |
	searcher := ParseTreeSearcher new.
	searcher matches: aStVariableNode name , ' := ``@expr'
		do: 
			[:aNode :answer | 
			answer
				add: aNode;
				yourself].
	^searcher executeTree: self parseTree initialAnswer: OrderedCollection new!

hasUndeclaredVariables
	^presenter compilationErrors anySatisfy: [:each | each errorCode = CErrUndeclared]!

implementMessage: aStMessageNode
	| dialog |
	dialog := self systemModel classChooserClass create.
	dialog
		caption: 'Choose Target Class…';
		allowNil: false.
	presenter parseContext owningPackage ifNotNil: [:package | dialog packages: {package}].
	dialog showModal ifNotNil: [:class | self implementMessage: aStMessageNode inClass: class]!

implementMessage: aStMessageNode inClass: aClass
	| change |
	change := self systemModel
				compile: (self stubTextFor: aStMessageNode inClass: aClass)
				in: aClass
				environment: nil
				categories: #()
				package: nil
				extraFlags: 0.
	presenter clearParseTree.
	change method
		ifNotNil: [:method | (self systemModel methodCategorizationPolicy bestSuggestionFor: method) addMethod: method]!

inlineMessage
	"Invoke the 'Inline Message' refactoring to inline the selected
	message send."

	presenter performCodeRefactoring: 
			[:method :node | 
			| line result |
			line := presenter lineFromPosition: node sourceInterval start.
			result := self systemModel 
						inlineMessage: node
						inMethod: method selector
						of: method methodClass.
			presenter repositionAtSourceLine: line.
			result]!

inlineParameter
	"Inline the parameter which is under the cursor (or selected), i.e. perform an 'Inline
	Parameter' refactoring."

	self inlineParameter: self selectedNode!

inlineTemporary
	"Invoke the 'Inline Temporary' refactoring to inline the temporary which is currently
	selected in the workspace. Note that we support the selection of the assignment expression
	to be inlined or at a minimum it is sufficient to just have the caret over either the
	declaration of the temporary to inline, or a reference to it."

	presenter performCodeRefactoring: [:method :node | self inlineTemporary: method in: node]!

inlineTemporary: aCompiledMethod in: aStProgramNode
	| assignment line result |
	assignment := aStProgramNode isAssignment
				ifTrue: [aStProgramNode]
				ifFalse: 
					[| assignments |
					assignments := self findAssignmentsToTemp: aStProgramNode.
					assignments isEmpty ifFalse: [assignments first]].
	assignment isNil
		ifTrue: 
			[Sound warningBeep.
			Notification
				signal: ('There are no assignments to <1p> to inline' expandMacrosWith: aStProgramNode name).
			^nil].
	line := presenter lineFromPosition: aStProgramNode sourceInterval start.
	result := self systemModel
				inlineTemporary: assignment sourceInterval
				from: aCompiledMethod selector
				in: aCompiledMethod methodClass.
	presenter repositionAtSourceLine: line.
	^result!

isLocalVariable: aStVariableNode
	"Private - Answer whether the specified variable node represents one of the temporaries in the current
	method (note that parameters are excluded)."

	^self parseTree allTemporaryVariableNodes includes: aStVariableNode!

moveTempToInnerScope
	"Move the temporary with focus (i.e. that selected or under the cursor) to the innermost
	scope in which it is first referenced, i.e. perform a 'Move to Inner Scope' refactoring."

	presenter performCodeRefactoring: 
			[:method :node | 
			| interval anchor |
			interval := node sourceInterval.
			anchor := interval start.
			(self systemModel 
				moveTempToInnerScope: interval
				in: method methodClass
				selector: method selector) isNil 
				ifFalse: [presenter caretPosition: anchor]]!

nameForArgument: aStProgramNode
	aStProgramNode isVariable
		ifTrue: 
			[aStProgramNode variable
				ifNotNil: 
					[:var |
					(presenter suggestClassForVariable: var)
						ifNotNil: 
							[:aClass |
							| type |
							type := self systemModel typeForArgumentClass: aClass.
							aClass isMeta
								ifTrue: ['aClass']
								ifFalse: [(type name first isVowel ifTrue: ['an'] ifFalse: ['a']) , type name]]].
			^aStProgramNode name].
	aStProgramNode isLiteralNode ifTrue: [^self systemModel nameForArgument: aStProgramNode value].
	aStProgramNode isBlock
		ifTrue: [^self systemModel nameForBlockOfArity: aStProgramNode argumentCount].
	^'anObject'!

onAboutToDisplayMenu: aMenu 
	"The system is about to display the <Menu>, popup, this is our chance to fiddle with it."

	| menuName |
	super onAboutToDisplayMenu: aMenu.
	menuName := aMenu name.
	menuName == #implementMessageMenu 
		ifTrue: 
			[self populateImplementMenu: aMenu.
			^self].
	menuName == #autoCorrectMenu 
		ifTrue: 
			[self populateAutoCorrectMenu: aMenu.
			^self]!

populateAutoCorrectMenu: aMenu 
	| node range |
	aMenu clear.
	#todo.	"Find the errors & warnings that either enclose the caret position, or are near it (separated only by whitespace or special character tokens from)"
	range := presenter selectedErrorRange.
	node := presenter nodeForRange: range.
	node isNil ifTrue: [^self].
	node isMessage ifTrue: [self populateAutoCorrectMenu: aMenu forMessage: node].
	node isVariable ifTrue: [self populateAutoCorrectMenu: aMenu forVariable: node].
	self hasUndeclaredVariables ifFalse: [^self].
	aMenu isEmpty ifFalse: [aMenu addSeparator].
	aMenu addCommand: (MessageSend receiver: self selector: #declareAllUndeclaredVariablesAsTemps)
		description: 'Declare &All Undeclared Temps'!

populateAutoCorrectMenu: aMenu forMessage: aStMessageNode
	| implementMenu |
	implementMenu := aMenu addSubmenu: ('&Implement <1p> In' expandMacrosWith: aStMessageNode selector).
	self populateImplementMenu: implementMenu forMessage: aStMessageNode!

populateAutoCorrectMenu: aMenu forUndefinedVar: aStVariableNode
	| parseContext |
	parseContext := presenter parseContext.
	^aStVariableNode name first isUppercase
		ifTrue: 
			[| subMenu |
			subMenu := aMenu addSubmenu: ('Add C&lass Variable <1p> to' expandMacrosWith: aStVariableNode name).
			parseContext methodClass instanceClass withAllSuperclassesDo: 
					[:eachClass |
					subMenu addCommand: (MessageSend
								receiver: self
								selector: #addClassVariable:to:
								arguments: {aStVariableNode. eachClass})
						description: eachClass name].
			aMenu addCommand: (MessageSend
						receiver: self
						selector: #createClassForVariable:
						arguments: {aStVariableNode})
				description: ('Create &Class <1p>' expandMacrosWith: aStVariableNode name).
			aMenu addCommand: (MessageSend
						receiver: self
						selector: #addSharedVariable:to:
						arguments: {aStVariableNode. parseContext environment})
				description: ('Declare &Shared Variable <1p>.<2s>' expandMacrosWith: parseContext environment with: aStVariableNode name)]
		ifFalse: 
			[| subMenu |
			aMenu addCommand: (MessageSend
						receiver: self
						selector: #declareTemporary:
						arguments: {aStVariableNode})
				description: ('Declare &Temp <1p>' expandMacrosWith: aStVariableNode name).
			subMenu := Menu
						description: ('Add &Instance Variable <1p> to' expandMacrosWith: aStVariableNode name).
			parseContext methodClass withAllSuperclassesDo: 
					[:eachClass |
					(ClassBuilder isFixedLayout: eachClass)
						ifFalse: 
							[subMenu addCommand: (MessageSend
										receiver: self
										selector: #addInstanceVariable:to:
										arguments: {aStVariableNode. eachClass})
								description: eachClass name]].
			subMenu isEmpty ifFalse: [aMenu addItem: subMenu]]!

populateAutoCorrectMenu: aMenu forVariable: aStVariableNode
	| range |
	range := aStVariableNode sourceInterval.
	(presenter compilationErrors select: [:each | each range = range]) do: 
			[:each |
			| code |
			code := each errorCode.
			code = CErrUndeclared
				ifTrue: [self populateAutoCorrectMenu: aMenu forUndefinedVar: aStVariableNode].
			code = CWarnUnreferencedTemp
				ifTrue: 
					[aMenu addCommand: (MessageSend
								receiver: self
								selector: #removeTempDecl:
								arguments: {aStVariableNode})
						description: 'Remove Declaration ']]!

populateImplementMenu: aMenu 
	"Private - Build the menu which lists the classes into which a stub can be generated for
	the message under the cursor."

	self populateImplementMenu: aMenu forMessage: presenter selectedMessageNode!

populateImplementMenu: aMenu forMessage: aStMessageNode
	aMenu clear.
	(presenter targetOfMessage: aStMessageNode)
		ifNotNil: 
			[:target |
			| class |
			class := target.
			[class notNil and: [(class includesSelector: aStMessageNode selector) not]] whileTrue: 
					[aMenu addCommand: (MessageSend
								receiver: self
								selector: #implementMessage:inClass:
								arguments: {aStMessageNode. class})
						description: class name.
					class := class superclass]].
	aMenu notEmpty ifTrue: [aMenu addSeparator].
	aMenu addCommand: (MessageSend
				receiver: self
				selector: #implementMessage:
				argument: aStMessageNode)
		description: '&Class…'.
	aMenu setDefault: 1!

queryCommand: aCommandQuery command: aCommand 
	| selector |
	selector := aCommand asSymbol.
	#codeRefactoringsMenu == selector 
		ifTrue: 
			[aCommandQuery isEnabled: self canPerformCodeRefactoring.
			^true].
	#implementMessageMenu == selector 
		ifTrue: 
			[aCommandQuery isEnabled: presenter selectedMessageNode notNil.
			^true].
	#autoCorrectMenu == selector 
		ifTrue: 
			[aCommandQuery isEnabled: presenter compilationErrors notEmpty.
			^true].
	(#(#extractMethod #extractToTemporary #extractToComponent) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery isEnabled: (self canPerformCodeRefactoring and: [presenter hasSelection]).
			^true].
	"Most code Refactorings require a selection of the correct type of node in the workspace and that the code not have been modified."
	#inlineMessage == selector 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self canPerformCodeRefactoring and: 
							[| node |
							node := self selectedNode.
							node notNil and: [node isMessage]]).
			^true].
	#inlineTemporary == selector 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self canPerformCodeRefactoring and: 
							[| node |
							node := self selectedNode.
							node notNil and: [node isAssignment or: [self isLocalVariable: node]]]).
			^true].
	#moveTempToInnerScope == selector 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self canPerformCodeRefactoring and: 
							[| node |
							node := self selectedNode.
							node notNil and: [self isLocalVariable: node]]).
			^true].
	#convertTempToInstVar == selector 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self canPerformCodeRefactoring and: 
							[| node |
							node := self selectedNode.
							node notNil and: 
									[(self isLocalVariable: node) and: 
											[#todo.	"Check here that the proposed instance variable is not already defined?"
											true]]]).
			^true].
	(#(#removeParameter #inlineParameter) identityIncludes: selector) 
		ifTrue: 
			[aCommandQuery 
				isEnabled: (self canPerformCodeRefactoring and: 
							[| node |
							node := self selectedNode.
							node notNil and: [self parseTree methodNode arguments includes: node]]).
			^true].
	^self queryRenameCommand: aCommandQuery command: aCommand!

queryRenameCommand: aCommandQuery command: aCommand
	| selector cmd |
	selector := aCommand asSymbol.
	cmd := aCommand.
	#renameNode == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: false;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {'Node'}
							locale: Locale smalltalk).
			cmd := self renameItCommand.
			cmd isNil ifTrue: [^false].
			selector := cmd asSymbol].
	#renameVariable == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: false;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {'Variable'}
							locale: Locale smalltalk).
			cmd := self renameVariableCommand: self selectedNode.
			cmd isNil ifTrue: [^false].
			selector := cmd asSymbol].
	#renameMessage == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: false;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {'Message'}
							locale: Locale smalltalk).
			cmd := self renameMessageCommand.
			cmd isNil ifTrue: [^false].
			selector := cmd asSymbol].
	#addParameterToMessage == selector
		ifTrue: 
			[aCommandQuery
				isEnabled: false;
				text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {'Message'}
							locale: Locale smalltalk).
			cmd := self addParameterCommand.
			cmd isNil ifTrue: [^false].
			selector := cmd asSymbol].

	"Handle the context sensitve rename node operation that has been identified."
	#changeSignature:in:operation:title: == selector
		ifTrue: 
			[| enable |
			enable := self canRenameNode.
			aCommandQuery isEnabled: enable.
			enable
				ifTrue: 
					[(cmd arguments second lookupMethod: cmd arguments first)
						ifNotNil: 
							[:method |
							aCommandQuery
								isEnabled: true;
								text: (aCommandQuery commandDescription menuText expandMacrosWithArguments: {method}
											locale: Locale smalltalk)]].
			^true].
	(#(#renameInstanceVariable: #renameClassVariable: #renameTemporary: #renameClass:)
		identityIncludes: selector)
			ifTrue: 
				[| enable |
				enable := self canRenameNode.
				aCommandQuery isEnabled: enable.
				enable
					ifTrue: 
						[aCommandQuery text: (aCommandQuery commandDescription menuText
									expandMacrosWithArguments: {self selectedNode name printString}
									locale: Locale smalltalk)].
				^true].
	^false!

removeParameter
	self removeParameter: self selectedNode!

removeTempDecl: aStVariableNode 
	| range scintilla |
	range := aStVariableNode sourceInterval.
	scintilla := presenter view.
	((scintilla characterAt: range start - 1) isWhitespace 
		and: [(scintilla characterAt: range stop + 1) isWhitespace]) ifTrue: [range stop: range stop + 1].
	scintilla clearRange: range!

renameClass: aStVariableNode
	| class model method |
	model := self systemModel.
	method := self selectedMethod.
	class := (method fullBindingFor: aStVariableNode name) value.
	presenter
		renameVariable: aStVariableNode
		operation: [:newName | model renameClass: class to: newName]
		validationBlock: [:name | model validateRenameClass: class to: name]!

renameClassVariable: aStVariableNode 
	| definingBehavior methodClass oldName model |
	methodClass := presenter selectedMethod methodClass.
	oldName := aStVariableNode name.
	definingBehavior := methodClass whichClassDefinesClassVar: oldName.
	model := self systemModel.
	presenter 
		renameVariable: aStVariableNode
		operation: 
			[:newName | 
			model 
				renameClassVariable: oldName
				to: newName
				in: definingBehavior
				within: model systemEnvironment]
		validationBlock: 
			[:name | 
			model 
				validateRenameClassVar: oldName
				to: name
				in: definingBehavior]!

renameInstanceVariable: aStVariableNode 
	| definingBehavior methodClass oldName model |
	methodClass := presenter selectedMethod methodClass.
	oldName := aStVariableNode name.
	definingBehavior := methodClass whichClassDefinesInstVar: oldName.
	model := self systemModel.
	presenter 
		renameVariable: aStVariableNode
		operation: 
			[:newName | 
			model 
				renameInstanceVariable: oldName
				to: newName
				in: definingBehavior
				within: model systemEnvironment]
		validationBlock: 
			[:candidateName | 
			model 
				validateRenameInstVar: oldName
				to: candidateName
				in: definingBehavior]!

renameItCommand
	| command node |
	node := self selectedNode.
	node isNil 
		ifFalse: 
			[command := self renameMessageCommand.
			command isNil ifTrue: [command := self renameVariableCommand: node]].
	^command!

renameMessage
	self renameMessageCommand value: self!

renameMessageCommand
	"Private - Answer an appropriate <Message> which when sent to the receiver will initiate a
	rename of the appropriate method, or nil if the not a suitable candidate for renaming."

	^presenter selectedMessageNode 
		ifNotNil: 
			[:node | 
			(presenter targetOfMessage: node) 
				ifNotNil: 
					[:target | 
					self 
						changeSignatureCommandFor: node
						in: target
						operation: [:method | self systemModel renameMethod: method]
						title: 'Rename']]!

renameNode
	| command |
	command := self renameItCommand.
	[command value: self] postToMessageQueue!

renameTemporary: aStVariableNode 
	| method |
	method := self selectedMethod.
	presenter 
		renameVariable: aStVariableNode
		operation: 
			[:newName | 
			presenter systemModel 
				renameTemporary: aStVariableNode
				to: newName
				in: method methodClass
				selector: method selector]
		validationBlock: 
			[:candidate | 
			presenter systemModel 
				validateRenameTemp: aStVariableNode
				to: candidate
				in: method methodClass]!

renameVariable
	"Invoke the 'Rename Variable'  refactoring to rename the selected variable, 
	or that under the cursor if no selection. The name is looked up in scope rule order."

	| command |
	command := self renameVariableCommand: self selectedNode.
	[command value: self] postToMessageQueue!

renameVariableCommand: aStVariableNode
	^(##(IdentityDictionary new
		at: #temporary put: #renameTemporary:;
		at: #instance put: #renameInstanceVariable:;
		at: #class put: #renameClassVariable:;
		at: #classGlobal put: #renameClass:;
		yourself) lookup: (presenter variableClassification: aStVariableNode))
		ifNotNil: [:selector | Message selector: selector argument: aStVariableNode]!

selectedErrorRange
	^presenter selectedErrorRange!

selectedMethod
	^presenter selectedMethod!

selectedNode
	^presenter selectedNode!

stubTextFor: aStMessageNode inClass: aClass
	| source body argc |
	source := String smalltalkWriteStream: 128.
	body := '^Error notYetImplemented'.
	argc := aStMessageNode argumentCount.
	argc == 0
		ifTrue: 
			[source nextPutAll: aStMessageNode selector.
			(aClass allInstanceVariableNames includes: aStMessageNode selector asString)
				ifTrue: [body := '^<1s>' expandMacrosWith: aStMessageNode selector]]
		ifFalse: 
			[argc == 1
				ifTrue: 
					[aStMessageNode selector isInfix
						ifTrue: 
							[source
								nextPutAll: aStMessageNode selector;
								space;
								nextPutAll: aStMessageNode arguments first name]
						ifFalse: 
							[| name argNames |
							argNames := self
										emitKeywordSignatureFor: aStMessageNode
										in: aClass
										on: source.
							name := aStMessageNode selector allButLast.
							(aClass allInstanceVariableNames includes: name)
								ifTrue: [body := '<1s> := <2s>' expandMacrosWith: name with: argNames first]]]
				ifFalse: 
					[self
						emitKeywordSignatureFor: aStMessageNode
						in: aClass
						on: source]].
	source
		crtab;
		nextPutAll: body.
	^source contents! !
!Tools.CodeRefactoringTool categoriesForMethods!
addClassVariable:to:!commands!private! !
addInstanceVariable:to:!commands!private! !
addParameterCommand!commands!private!refactoring! !
addParameterToMessage!commands!public!refactoring! !
addSharedVariable:to:!commands!private! !
canPerformCodeRefactoring!private!refactoring! !
canRenameNode!private!refactoring! !
changeSignature:in:operation:title:!helpers!private! !
changeSignatureCommandFor:in:operation:title:!helpers!private!refactoring! !
contextBindingFor:!private!refactoring! !
convertTempToInstVar!commands!public!refactoring! !
createClassForVariable:!autocorrection!private! !
declareAllUndeclaredVariablesAsTemps!commands!private! !
declareTemporary:!commands!private! !
emitKeywordSignatureFor:in:on:!helpers!private! !
extractionRange!helpers!private!refactoring! !
extractMethod!commands!public!refactoring! !
extractToComponent!commands!public!refactoring! !
extractToTemporary!commands!public!refactoring! !
findAssignmentsToTemp:!helpers!private! !
hasUndeclaredVariables!autocorrection!private! !
implementMessage:!commands!private!refactoring! !
implementMessage:inClass:!commands!private!refactoring! !
inlineMessage!commands!public!refactoring! !
inlineParameter!commands!public!refactoring! !
inlineTemporary!commands!public!refactoring! !
inlineTemporary:in:!private!refactoring! !
isLocalVariable:!helpers!private! !
moveTempToInnerScope!public!refactoring! !
nameForArgument:!helpers!private! !
onAboutToDisplayMenu:!event handling!public! !
populateAutoCorrectMenu:!autocorrection!private! !
populateAutoCorrectMenu:forMessage:!autocorrection!private! !
populateAutoCorrectMenu:forUndefinedVar:!autocorrection!private! !
populateAutoCorrectMenu:forVariable:!autocorrection!private! !
populateImplementMenu:!helpers!private! !
populateImplementMenu:forMessage:!helpers!private! !
queryCommand:command:!commands!private! !
queryRenameCommand:command:!commands!private! !
removeParameter!commands!public!refactoring! !
removeTempDecl:!autocorrection!commands!private! !
renameClass:!helpers!private! !
renameClassVariable:!private!refactoring! !
renameInstanceVariable:!private!refactoring! !
renameItCommand!private!refactoring! !
renameMessage!commands!public!refactoring! !
renameMessageCommand!commands!private!refactoring! !
renameNode!commands!public!refactoring! !
renameTemporary:!operations!private!refactoring! !
renameVariable!commands!public!refactoring! !
renameVariableCommand:!commands!private!refactoring! !
selectedErrorRange!accessing!private!refactoring! !
selectedMethod!accessing!private! !
selectedNode!accessing!private!refactoring! !
stubTextFor:inClass:!helpers!private! !
!

