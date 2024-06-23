"Filed out from Dolphin Smalltalk"!

UI.Presenter
	subclass: #'Tools.SmalltalkWorkspace'
	instanceVariableNames: 'evaluationContext errorModel findDetails workspacePool namespaces compilationErrors textStyles searchEnvironment modifiedModel flags indicatorDefinitions variableMetadataProvider'
	classVariableNames: 'Abbreviations AnnotationMode AutoCompleteDwell DefaultCaretColor DefaultFont DefaultTabWidth FontQuality IndicatorDefinitions KeyBindings KeywordCompletions MaxAutoCompletionListHeight MaxAutoCompletionListSize MaxAutoCompletionListWidth OptionFlags StandardUnaryReturnTypes TextStyles WrapIndentMode'
	imports: #(#{Kernel.CompilerFlags} #{UI.Scintilla private} #{Refactory.Browser private})
	classInstanceVariableNames: 'additionalKeyBindings'
	classConstants: {
			'AutoCompleteMask' -> 16r8.
			'AutoCompletionCaseInsensitiveMask' -> 16r80.
			'AutoCompletionEnabledMask' -> 16r10.
			'AutoCompletionSpaceAddedMask' -> 16r40.
			'AutoCompletionTruncatingMask' -> 16r20.
			'LiteralStyleNames'
				-> (Set withAll: #(#literalNumber #literalPseudo #literalString #literalSymbol)).
			'LoadingOptionsMask' -> 16r1.
			'UseDirectWriteMask' -> 16r100.
			'VariableTipsMask' -> 16r2.
			'WordWrapMask' -> 16r4
		}!

Tools.SmalltalkWorkspace guid: (Core.GUID fromString: '{87b4c687-026e-11d3-9fd7-00a0cc3e4a32}')!

Tools.SmalltalkWorkspace comment: '`SmalltalkWorkspace` is a `<presenter>` for displaying a workspace area within a `ScintillaView`. Note that, for efficiency purposes, a SmalltakWorkspace does not have a model. The textual data is held only within the associated view. since there seems little point in duplicating this text and holding it within the image as, say, a `<readableString>`.

In Dolphin 5.1 and earlier `SmalltalkWorkspace` could work with an `TextEdit` view, however as of Dolphin 6 it is specialised to support only `ScintillaView` as this allows it to take advantage of the advanced features of that control.

## Instance Variables:
  `evaluationContext`		`Object` that is the "self" context for evaluations
  `errorModel`				`<valueModel>` holding the first error notification from the last compilation
  `findDetails`				`Array` specifying text search details
  `workspacePool`			`Dictionary` holding local variables held by the workspace
  `evaluationPools`			`Array` of `Dictionary` being variable pools for evaluations
  `compilationErrors`		`<sequencedReadableCollection>` of `CompilerNotification`s (not necessarily all errors)
  `textStyles`				`<collection>` of `Scintilla.TextStyle`s use to colour text in the view.
  `searchEnvironment`		`BrowserEnvironment` defining the scope of code searches
  `modifiedModel`			`<valueModel>` indicating whether the text has been edited
  `flags`					`<integer>` various flags
  `indicatorStyles`			`<sequencedReadableCollection>` of `Scintilla.IndicatorStyle`
  `variableMetadataProvider`	`<variableMetadataProvider>` 

## Class Variables:
  `AnnotationMode`			One of `#hidden`, `#standard`, `#boxed`, or `#indented`, being the style used to display annotations
  `AutoCompleteDwell`			`Duration` that must elapse after text input before any auto-completion list is shown
  `DefaultCaretColor`			`Color` of the caret
  `DefaultFont`					`Font` of text in the normal style. Most text styles will at most modify one or two attributes of this.
  `DefaultTabWidth`				`<integer>` width of tabs (equivalent number of spaces)
  `FontQuality`					Scintilla font quality setting; one of `#default`, `#unaliased`, `#antialiased`, `#lcdOptimized`
  `IndicatorStyles`				`<sequencedReadableCollection>` of  `Scintilla.IndicatorStyle`. Default indicator styles.
  `KeyBindings`				`<sequencedReadableCollection>` of `Scintiall.KeyBinding`. Default additional key bindings
  `KeywordCompletions`			`LookupTable` mapping common selector strings to completions
  `MaxAutoCompletionListHeight`	`<integer>` maximum number of visible rows in auto-completion lists
  `MaxAutoCompletionListSize`	`<integer>` maximum number of rows in auto-completions lists
  `MaxAutoCompletionListWidth`	`<integer>` maximum character width of auto-completion lists
  `OptionFlags`					`<integer>`. Various option flags.
  `StandardUnaryReturnTypes`	`LookupTable` mapping some common selectors to the type of object they return
  `TextStyles`					`Array` of `Scintilla.TextStyle` being the text styles for Smalltalk code
  `WrapIndentMode`			Style of indentation of wrapped lines; one of `#fixed`, `#same`, `#indent`, `#deepIndent`

## Class Instance Variables:
  `additionalKeyBindings`		`<sequencedReadableCollection>` of `CommandDescription`. Additional key bindings, e.g. for extension commands
  `commandQueryHandlers`		`<sequencedReadableCollection>` of `Symbol`. Selectors of extension command query methods.
'!

!Tools.SmalltalkWorkspace categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !

!Tools.SmalltalkWorkspace methodsFor!

addAllStaticIdentifiersStartingWith: aString to: aSet limit: anInteger
	| visited class visitStatics filter env |
	visited := IdentitySet new.
	filter := aString isEmpty
				ifTrue: 
					[
					[:each |
					self
						addStatic: each
						toCompletionList: aSet
						limit: anInteger]]
				ifFalse: 
					[| ignoreCase |
					ignoreCase := self isAutoCompletionCaseInsensitive.
					
					[:each |
					(each key beginsWith: aString ignoreCase: ignoreCase)
						ifTrue: 
							[self
								addStatic: each
								toCompletionList: aSet
								limit: anInteger]]].
	env := self searchEnvironment.
	visitStatics := 
			[:eachClass |
			(visited includes: eachClass)
				ifFalse: 
					[visited add: eachClass.
					(env includesClassOrMetaclass: eachClass realClass)
						ifTrue: 
							[eachClass bindingsDo: filter.
							eachClass importedNamespacesDo: 
									[:eachNs |
									(visited includes: eachNs)
										ifFalse: 
											[visited add: eachNs.
											(env includesClassOrMetaclass: eachNs realClass) ifTrue: [eachNs bindingsDo: filter]]]]]].
	class := self selfClass instanceClass.
	class withAllSuperclassesDo: visitStatics.
	class environment ?? Smalltalk withAllSuperclassesDo: visitStatics.
	"Finally any namespaces configured into the workspace scope"
	namespaces do: [:each | each bindingsDo: filter].
	^aSet!

addStatic: aVariableBinding toCompletionList: aSet limit: anInteger
	| candidate |
	candidate := ListItem
				object: aVariableBinding
				text: aVariableBinding key asString
				icon: aVariableBinding value icon.
	"Occassionally we may get classes that cannot be identified unambiguously using their unqualified name alone, in which case we need to append the namespace to disambiguate. When selected for autocompletion, the qualified class name will be inserted"
	(aSet addNewElement: candidate)
		ifFalse: 
			[| existing |
			existing := aSet remove: candidate.
			"Occasionally we may encounter a package with the same name as a class, e.g. RBParser. In that case we leave the package name unchanged."
			(existing object isKindOf: VariableBinding)
				ifTrue: [existing text: (self unambiguousCompletionForBinding: existing object)].
			aSet add: existing.
			candidate text: (self unambiguousCompletionForBinding: aVariableBinding)].
	aSet add: candidate.
	aSet size > anInteger ifTrue: [OperationAborted signal]!

allPools
	"Private - Answers an Array of all the PoolDictionaries used during evaluations in the receiver. The workspacePool of locals must be the first element of the array"

	^{ self workspacePool } , self namespaces!

allVariablesVisibleFrom: aStProgramNode do: aMonadicValuable
	| parseContext classScope |
	parseContext := self parseContext.
	classScope := parseContext scope.
	parseContext methodClass allInstanceVariableNames keysAndValuesDo: 
			[:i :each |
			aMonadicValuable value: (StInstanceVariable
						scope: classScope
						index: i
						name: each)].
	workspacePool
		bindingsDo: [:each | aMonadicValuable value: (StWorkspaceVariable scope: classScope binding: each)]!

applyOptions
	"Private - Apply the class options to the receiver. As most options are applied to the view, this is skipped if the view is not availalble. This might happen when loading an image, and the restoration of the first workspace causes loading of options, and an attempt to apply them. The options will get applied to any views that were closed at the time the options were loaded when their view is created later."

	self
		setFont;
		setCaretColor;
		setWordWrap;
		setTabWidth.
	"textStyles are initialized to class setting by default, but parent presenter might have
	replaced them. N.B. If you blow up here, its because you are trying to use a non-Scintilla
	view with SmalltalkWorkspace. This is no longer supported."
	view textStyles: self textStyles.
	view mergeIndicatorDefinitions: self indicatorDefinitions.
	view
		wordChars: ##((Character byteCharacterSet
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]) asUtf8String).
	self hasSmalltalkStyler ifFalse: [self isAutoCompletionEnabled: false].
	view isAutoCompletionCaseInsensitive: self class isAutoCompletionCaseInsensitive.
	"This has no effect, since we takeover insertion of the completed word, but it's a useful
	way to store the flag on a per-instance basis"
	view isAutoCompletionTruncating: self class isAutoCompletionTruncating.
	view maxCompletionListHeight: self class maxAutoCompletionListHeight.
	view maxCompletionListWidth: self class maxAutoCompletionListWidth.
	view autoCompletionSeparator: $\x7F.
	self areVariableTipsEnabled ifTrue: [view isBackgroundDwellEnabled: true].
	"#2137"
	view annotationMode: self class annotationMode.
	view wrapIndentMode: self class wrapIndentMode.
	view setKeyBindings: self class customEditorKeyBindings.
	self class useDirectWrite ifTrue: [view drawingTechnology: #directWrite].
	view fontQuality: self class fontQuality.
	^true!

areVariableTipsEnabled
	^flags allMask: VariableTipsMask!

areVariableTipsEnabled: aBoolean 
	flags := flags mask: VariableTipsMask set: aBoolean!

autoComplete: aSymbol at: posInteger maxItems: maxInteger
	aSymbol == #specialCharacter
		ifTrue: 
			[(self maybeExtendingQualifiedNameAt: posInteger)
				ifTrue: 
					[self
						showIdentifierCompletionListAt: posInteger
						maxItems: maxInteger
						start: (self styleRunStartAt: posInteger - 1)].
			^self].
	aSymbol == #identifier
		ifTrue: 
			[self
				showIdentifierCompletionListAt: posInteger
				maxItems: maxInteger
				start: (view styleRunStartAt: posInteger).
			^self].
	aSymbol == #literalSymbol
		ifTrue: 
			[self showSymbolCompletionListAt: posInteger maxItems: maxInteger.
			^self].
	(#(#unaryMessage #keywordMessage #binaryMessage) identityIncludes: aSymbol)
		ifTrue: 
			[self showMessageCompletionListAt: posInteger maxItems: maxInteger.
			^self].
	(#(#unarySelector #keywordSelector #binarySelector) identityIncludes: aSymbol)
		ifTrue: 
			[self
				showSelectorCompletionListAt: posInteger
				maxItems: maxInteger
				start: (self styleRunStartAt: posInteger).
			^self].
	^nil!

basicFindNext
	"Hilight the next occurrence which satisfies the find operation held in findDetails."

	^self view basicFindNext!

basicInspectIt
	"Evaluate and basic inspect the currently selected text (or the current line if there is no
	selection)."

	(self evaluateItIfFail: [^self]) basicInspect!

browseClassDefinition: aClass
	self commandPolicy
		route: (CommandDescription command: (Message selector: #browseClass: argument: aClass realClass))!

browseClassReferences: aClass
	"Open a method browser on the methods referencing the specified <Class> in the receiver's search environment."

	self browseEnvironments: (self developmentSystem referencesToClass: aClass realClass
				in: self searchEnvironment)!

browseDefinitions
	"Context-sensitive browse references command (F12)."

	<commandQuery: #queryBrowseDefinitions:>
	<acceleratorKey: 'F12'>
	self perform: self browseDefinitionsCommand!

browseDefinitionsCommand
	| tokenStyle |
	self hasSelection ifTrue: [^#browseMessageDefinitions].
	tokenStyle := view styleUnderCaret name.
	tokenStyle == #identifier ifTrue: [^#browseVariableDefinition].
	tokenStyle == #literalSymbol ifTrue: [^#browseSelectorDefinitions].
	^#browseMessageDefinitions!

browseDefinitionsMatching: aMethodSearch
	"Private - Open a method browser on the methods in the receiver's search environment that have match the <MethodSearch> argument."

	"Route a command message to avoid requiring that the parent presenter implement #browseDefinitionsMatching:in:. Ultimately this can be handled by the development system model, but is also intercepted by <MethodExplorer> in order to add to its search history tree."

	self
		routeCommand: (CommandDescription command: (Message selector: #browseDefinitionsMatching:in:
						arguments: { aMethodSearch. self searchEnvironment }))!

browseIt
	"Evaluate currently selected text (or the current line if there is no selection) in the
	receiver and browse the result."

	<acceleratorKey: 'Ctrl+B'>
	(self evaluateItIfFail: [^self]) browse!

browseLiteralReferences
	"Open a method browser showing references to the value of the current literal node. Note this can be any literal value, not just symbols. For example you can search for all occurrences of String 'abc' in the system, or $🐬"

	<commandQuery: #queryBrowseLiteralReferences:>
	self browseReferencesMatching: (MethodSearch newLiteral: self selectedLiteralValue)!

browseMessageDefinitions
	self browseMessageDefinitions: self selectedWord in: self searchEnvironment!

browseMessageDefinitions: aString in: aBrowserEnvironment
	self developmentSystem browseMessageDefinitions: aString in: aBrowserEnvironment!

browseMessageReferences
	self browseMessageReferences: self selectedWord in: self searchEnvironment!

browseMessageReferences: aString in: aBrowserEnvironment
	"Private - Prompt for a selector and open a method explorer displaying the references to that
	selector, using the <readableString> argument as the initial suggestion (or if that is empty
	the first word of the clipboard text)."

	self developmentSystem browseMessageReferences: aString in: aBrowserEnvironment!

browseMethodsIn: aBrowserEnvironment 
	parentPresenter browseMethodsIn: aBrowserEnvironment!

browseReferences
	"Context-sensitive browse references command (Shift+F12)."

	<commandQuery: #queryBrowseReferences:>
	<acceleratorKey: 'Shift+F12'>
	self perform: self browseReferencesCommand!

browseReferencesCommand
	| tokenStyle |
	self hasSelection ifTrue: [^#browseMessageReferences].
	tokenStyle := view styleUnderCaret name.
	tokenStyle == #identifier ifTrue: [^#browseVariableReferences].
	(LiteralStyleNames includes: tokenStyle) ifTrue: [^#browseLiteralReferences].
	^#browseMessageReferences!

browseReferencesMatching: aMethodSearch
	"Private - Open a method browser on the methods in the receiver's search environment that have a reference matching the <MethodSearch> argument."

	"Route a command message to avoid requiring that the parent presenter implement #browseReferencesMatching:in:. Ultimately this can be handled by the development system model, but is also intercepted by <MethodExplorer> in order to add to its search history tree."

	self
		routeCommand: (CommandDescription command: (Message selector: #browseReferencesMatching:in:
						arguments: { aMethodSearch. self searchEnvironment }))!

browseSelectorDefinitions
	"Open a method browser showing definitions of the <Symbol> selector that is selected or under the cursor."

	<commandQuery: #queryBrowseSelectorDefinitions:>
	self browseDefinitionsMatching: (MethodSearch newLiteral: self selectedSymbol)!

browseVariableDefinition
	"Open a method browser showing references to the value of the current literal node. Note this can be any literal value, not just symbols. For example you can search for all occurrences of String 'abc' in the system, or $🐬"

	<commandQuery: #queryBrowseVariableDefinition:>
	| var range |
	range := view styleRunRangeAt: self selectedTokenPosition.
	var := self variableForIdentifierStyle: #identifier range: range.
	self browseClassDefinition: (self suggestClassForVariable: var)!

browseVariableReferences
	"Open a method browser showing references to the class of the current variable."

	<commandQuery: #queryBrowseVariableReferences:>
	| var range |
	range := view styleRunRangeAt: self selectedTokenPosition.
	var := self variableForIdentifierStyle: #identifier range: range.
	self browseClassReferences: (self suggestClassForVariable: var)!

cancelAutoCompletion
	self view cancelAutoCompletion!

canReformatComment
	^self isEditable and: [self view styleUnderCaret name == #comment]!

canReformatSource
	^self isEditable and: [self textLength > 0]!

caretPosition: anInteger 
	self view caretPosition: anInteger!

chooseNamespaces
	"Display a ListPrompter to allow the user to choose the evaluation pools associated with the
	receiver"

	<commandQuery: #isEditable>
	ChoicePrompter
		on: (self aspectValue: #namespaces)
		multipleChoices: (self systemModel availableNamespaces
				asSortedArray: [:a :b | a fullName <= b fullName])
		caption: 'Available Namespaces'!

chunkFilerClass
	^ChunkSourceFiler!

classForRange: anInterval
	^(self variableForIdentifierStyle: #identifier range: anInterval)
		ifNotNil: [:variable | self suggestClassForVariable: variable]!

classForStyleRun: anAssociation
	"Private - Answer the inferred class of the specified token, or nil if not known."

	| style range |
	anAssociation isNil ifTrue: [^nil].
	style := anAssociation value.
	(##(IdentityDictionary withAll: {
				#literalString -> String.
				#literalSymbol -> Symbol.
				#literalCharacter -> Character.
				#literalArray -> Array.
				#literalBytes -> ByteArray.
				#literalBindingReference -> BindingReference
			})
		lookup: style) ifNotNil: [:literalClass | ^literalClass].
	range := anAssociation key.
	style == #identifier ifTrue: [^self classForRange: range].
	style == #literalPseudo
		ifTrue: 
			[^##(LookupTable withAll: { 'nil' -> nil class. 'false' -> false class. 'true' -> true class })
				lookup: (view plainTextRange: range)].
	style == #literalNumber
		ifTrue: [^(SmalltalkStylingScanner on: (view plainTextRange: range) readStream) next valueClass].
	style == #specialCharacter
		ifTrue: 
			[| ch |
			ch := view characterAt: range stop.
			ch == $] ifTrue: [^BlockClosure].
			ch == $} ifTrue: [^Array]].
	style == #unaryMessage
		ifTrue: 
			[| tokenText |
			tokenText := view plainTextRange: range.
			tokenText = 'class'
				ifTrue: 
					[| penultimate |
					penultimate := self styleRunBefore: range start - 1.
					^(self classForStyleRun: penultimate) ifNotNil: [:class | class basicClass]].
			(StandardUnaryReturnTypes lookup: tokenText) ifNotNil: [:class | ^class]].
	^nil!

classForVariable: aStVariable
	^aStVariable valueClass!

clear
	"Remove all contents in the receiver's view"

	<commandQuery: #isEditable>
	self view clear.
	self newVariablePool!

clearErrors
	"Clear down the receiver's error model, if any, e.g. in preparation for a compilation"

	| v aCollectionOfSymbols |
	aCollectionOfSymbols := ##(Set withAll: #(#Error #Warning #Notification)).
	self clearStatus.
	compilationErrors := OrderedCollection new.
	v := self view.
	v removeIndicatorsOfTypes: aCollectionOfSymbols.
	v annotations: #()!

clearStatus
	self errorModel ifNotNil: [:errors | errors value: nil]!

cloneNew
	"Opens a SmalltalkWorkspace document which is effectively a clone of the receiver. It will
	contain the same contents and have the same evaluation context and workspace pools. Answers
	the clone"

	<commandQuery: #isEditable>
	| clone |
	clone := self developmentSystem newWorkspace.
	clone workspace
		text: self text;
		workspacePool: self workspacePool;
		namespaces: self namespaces;
		evaluationContext: self evaluationContext.
	^clone!

compilationErrors
	^compilationErrors!

compileAll
	"Compile the entire contents of the receiver and show the syntax colored result."

	self compileAllIfFail: [^self]
!

compileAllIfFail: failBlock
	"Private - Compile the entire contents of the receiver and show the syntax colored result.
	Show the syntax coloured result. Evaluate failBlock if there is a compilation error."

	^self compileRange: self view textRange ifFail: failBlock
!

compileIt
	"Compile the currently selected text (or the current line if there is no selection). 
	Show the syntax colored result."

	self compileItIfFail: [^self]
!

compileItIfFail: failBlock
	"Private - Compile the currently selected text (or the current line if there is no
	selection) within the receiver's evaluation context. Show the syntax coloured result"

	^self compileRange: self selectEvaluationRange ifFail: failBlock
!

compileRange: anInterval ifFail: failBlock
	"Private - Compile the specified, inclusive, range of text in the receiver within the
	receiver's evaluation context, evaluating failBlock if the compilation experiences errors,
	or the expression fails to complete when evaluated. Answers an instance of
	CompiledExpression."

	^self compileRange: anInterval ifFail: failBlock debug: false
!

compileRange: anInterval ifFail: failBlock debug: aBoolean
	"Private - Compile the specified, inclusive, range of text in the receiver within the
	receiver's evaluation context, evaluating failBlock if the compilation experiences errors,
	or the expression fails to complete when evaluated. Answers an instance of
	CompiledExpression."

	| result source offset compiler context |
	anInterval isEmpty
		ifTrue: 
			[source := String new.
			offset := 0]
		ifFalse: 
			[offset := anInterval first - 1.
			source := self view plainTextRange: anInterval].
	self selectionRange: anInterval.
	self clearErrors.
	context := self evaluationContext.
	compiler := context basicClass compilerClass.
	
	[result := compiler
				compileForEvaluation: source
				in: (context ifNotNil: [context basicClass])
				environment: self parseContext environment
				evaluationPools: self allPools
				flags: (aBoolean
						ifTrue: [self defaultCompilerFlags bitOr: DebugMethod]
						ifFalse: [self defaultCompilerFlags])]
			on: compiler warningClass
			do: [:cw | self compilerNotification: cw offset: offset]
			on: compiler errorClass
			do: 
				[:cn |
				"Note that this method sets the source selection appropriately"
				self compilerNotification: cn offset: offset].
	"A number of errors may have been recorded and displayed, go back to the first"
	self showFirstError: offset.

	"If the compilation failed, then evaluate the fail block and answer the result."
	(result isNil or: [result method isNil]) ifTrue: [^failBlock value].
	^result!

compilerNotification: aCompilerNotification offset: anInteger 
	"Private - A notification has been sent by the Compiler. If an errorsModel has been set up
	then the notification will be sent to that, and the offending range of source selected.
	Only the first error notification of any compilation will be set into any configured
	errorsModel, displacing any previous warning, further ones will be ignored."

	"The default behavior (where there is no error model) is to select the offending range of
	source, and display an Ok/Cancel message box with the error/warning. If the user presses Ok,
	then the compilation is permitted to continue, whereas Cancel aborts it."

	| copy |
	copy := aCompilerNotification copy.
	compilationErrors addLast: copy .
	self errorModel notNil 
		ifTrue: 
			[self showError: copy offset: anInteger.
			^aCompilerNotification isUserResumable 
				ifTrue: [aCompilerNotification resume]
				ifFalse: [aCompilerNotification return]].

	"Nothing set up so highlight the error/warning and display a message box"
	self selectionRange: aCompilerNotification range + anInteger.
	aCompilerNotification okToContinue!

completeInitialWord
	self
		showIdentifierCompletionListAt: 0
		maxItems: self maxCompletionListSize
		start: 1!

completeQualifiedIdentifier: qualifierString startingWith: prefixString maxItems: anInteger
	(self resolveClassNamed: qualifierString)
		ifNotNil: 
			[:class |
			| choices |
			choices := prefixString isEmpty
						ifTrue: [class classPool keys]
						ifFalse: 
							[| ignoreCase |
							ignoreCase := self isAutoCompletionCaseInsensitive.
							class classPool keys select: [:each | each beginsWith: prefixString ignoreCase: ignoreCase]].
			choices size <= anInteger
				ifTrue: [^self showCompletionList: choices prefixLength: prefixString size]].
	self view cancelAutoCompletion!

completeWord
	"The user has requested that a completion list be displayed to complete the current 'word'.
	The list will be displayed unless the number of choices is far too large or there are none
	matching, in which case a warning beep will sound."

	<commandQuery: #isEditable>
	<acceleratorKey: 'Ctrl+.'>
	| last styleName |
	last := view caretPosition - 1.
	last == 0
		ifTrue: 
			[self completeInitialWord.
			^self].
	styleName := (view styleAt: last) name.
	(self
		autoComplete: styleName
		at: last
		maxItems: self maxCompletionListSize)
			ifNil: 
				[self showCompletionListAfterStyleRun: (self styleRunBefore: last)
					maxItems: self maxCompletionListSize].
	view isAutoCompletionActive not ifTrue: [Sound warningBeep]!

completeWordAt: anInteger with: aString
	| replaceRange addSpace |
	replaceRange := self rangeToCompleteAt: anInteger.
	addSpace := self class isAutoCompletionSpaceAdded and: 
					[| nextChar |
					nextChar := view characterAt: replaceRange stop + 1.
					nextChar ~~ $\0 and: [nextChar isSeparator not]].
	view
		selectionRange: replaceRange;
		replaceSelection: (addSpace ifTrue: [aString , ' '] ifFalse: [aString]).
	^addSpace!

completionForChoice: aString
	| parts unqualifiedName fullName var |
	aString first isUpperCase ifFalse: [^aString].
	parts := $( split: aString.
	parts size = 1 ifTrue: [^aString].
	"If the class resolves unambiguously in context using only the unqualified name, then insert that. Otherwise insert the fully qualified name."
	unqualifiedName := parts first trimBlanks.
	fullName := (parts second readStream upTo: $)) , BindingReference.PathSeparatorString
				, unqualifiedName.
	var := self resolveIdentifier: unqualifiedName.
	^(var notNil and: [var isStaticVariable and: [var binding fullName = fullName]])
		ifTrue: [unqualifiedName]
		ifFalse: [fullName]!

completionListSortBlock
	^ScintillaView listSortBlock: self isAutoCompletionCaseInsensitive!

completionStringFor: aString at: anInteger
	| rawContents answer |
	"Completing anything other than a literal symbol is simple enough..."
	(view styleAt: anInteger) name == #literalSymbol ifFalse: [^aString].
	rawContents := aString first == $' ifTrue: [String readFrom: aString readStream] ifFalse: [aString].
	"Include quotes if and only if needed."
	answer := rawContents asSymbol printString.
	"Strip the leading # if already present in the view outside the range we will be replacing."
	^(view characterAt: anInteger - 1) == $# ifTrue: [answer allButFirst] ifFalse: [answer]!

copySelection
	"Copy the selection to the clipboard, or the line on which the caret is placed if there is
	no selection."

	self view copySelectionOrLine!

createComponents
	"Private - Create the presenters contained by the receiver. At this stage the receiver has
	not yet been initialized."

	errorModel := ValueHolder new.
	modifiedModel := ValueHolder new!

createSchematicWiring
	"Private - Create the trigger wiring for the receiver"

	super createSchematicWiring.
	self
		when: #hoverStart:
			send: #onHoverStart:
			to: self;
		when: #hoverEnd:
			send: #onHoverEnd:
			to: self;
		when: #charAdded:
			send: #onCharAdded:
			to: self;
		when: #autoComplete:startingAt:accept:
			send: #onAutoComplete:startingAt:accept:
			to: self;
		when: #timerTick:
			send: #onTimerTick:
			to: self!

debugIt
	"Debug the evaluation of the currently selected text (or the current line if there is no
	selection) within the receiver's evaluation context"

	^self debugItIfFail: []!

debugItIfFail: failBlock
	"Private - Debug the evaluation of the currently selected text (or the current line if there
	is no selection) within the receiver's evaluation context"

	^self evaluateItIfFail: failBlock debug: true
!

defaultCompilerFlags
	"Private - Answer the flags to be used by default when compiling expressions in the
	receiver."

	^Interactive!

defaultStylerClass
	^SmalltalkExpressionStyler!

descriptionOfVariable: aStVariable
	^aStVariable description!

developmentSystem
	^SmalltalkSystem current!

displayIt
	"Evaluate the currently selected text (or the current line if there is no selection). 
	Display the result at the current insert point (i.e. immediately after the selection)."

	<commandQuery: #isWriteable>
	<acceleratorKey: 'Ctrl+D'>
	self evaluateAndDisplay: [:obj | obj displayString: self developmentSystem displayItLocale]!

dragOver: aDragDropSession
	"The drag operation described by the <DragDropSession> argument has moved to a new position
	over the receiver's window. Use the session to provide feedback to the user about allowable
	operations etc. Implementation Note: Override this message to suggest a default drop action
	of pasting in the Chunk/String at the drop position."

	aDragDropSession operation: ((aDragDropSession isFormatAvailable: #Chunk)
				ifTrue: [#copy]
				ifFalse: 
					[(#(#String #ObjectRef) anySatisfy: [:e | aDragDropSession isFormatAvailable: e])
						ifTrue: [aDragDropSession intendedOperation]]).

	"Superclass triggers event to allow observers to override."
	super dragOver: aDragDropSession!

drop: session
	"The drag operation described by the <DragDropSession>, session, has culminated in a drop
	over the receiver."

	"Implementation Note: Override this message to implement default action of pasting in the
	String or Chunk at the drop position. However any observers of the #drop: trigger of the
	receiver get first crack - they should set the suggested target to nil in order to pre-empt
	the default action."

	| targetPos answer |
	answer := super drop: session.
	targetPos := session suggestedTarget.
	targetPos isNil
		ifFalse: 
			[self caretPosition: targetPos.
			session dragObjects do: 
					[:each |
					(each isFormatAvailable: #ObjectRef)
						ifTrue: [self dropObjectRef: (each format: #ObjectRef)]
						ifFalse: 
							[(each format: #Chunk ifAbsent: [each format: #String ifAbsent: []])
								ifNotNil: [:text | self replaceSelection: text]]]].
	^answer!

dropObjectRef: anObjectRef 
	"Private - Drops the anObjectRef into the receiver as a workspace variable. Prompts for the
	name of the variable"

	| varName selStart |
	varName := self promptForVariableName: anObjectRef.
	varName isNil ifTrue: [^self].
	self workspacePool at: varName put: anObjectRef value.
	selStart := self view caretPosition.
	self replaceSelection: varName.
	self selectionRange: (selStart to: selStart + varName size - 1).
	self setFocus!

errorModel
	"Answer the receiver's errorModel. Its value is the first notification from the last
	compilation. Note that this model may be shared by a number of presenters all contained
	within a single shell."

	^errorModel!

errorModel: aValueModel
	"Set the receiver's errorModel."

	errorModel := aValueModel!

evaluateAndDisplay: aMonadicValuable
	| result evalRange |
	evalRange := self selectEvaluationRange.
	result := self evaluateRange: evalRange ifFail: [^self].
	self showResult: (aMonadicValuable value: result) at: evalRange stop + 1!

evaluateIt
	"Evaluate the currently selected text (or the current line if there is no selection) within
	the receiver's evaluation context"

	<acceleratorKey: 'Ctrl+E'>
	^self evaluateItIfFail: []
!

evaluateItIfFail: failBlock
	"Private - Evaluate the currently selected text (or the current line if there is no
	selection) within the receiver's evaluation context"

	^self evaluateItIfFail: failBlock debug: false
!

evaluateItIfFail: failBlock debug: aDebugBoolean 
	"Private - Evaluate the currently selected text (or the current line if there is no
	selection) within the receiver's evaluation context"

	| evalRange result anInteger |
	evalRange := self selectEvaluationRange.
	result := self 
				evaluateRange: evalRange
				ifFail: [^failBlock value]
				debug: aDebugBoolean.
	anInteger := evalRange stop + 1.
	self caretPosition: anInteger.
	^result!

evaluateRange: anInterval ifFail: failBlock
	"Private - Evaluate the specified, inclusive, range of text in the receiver within the
	receiver's evaluation context, evaluating failBlock if the compilation experiences errors,
	or the expression fails to complete when evaluated."

	^self evaluateRange: anInterval ifFail: failBlock debug: false
!

evaluateRange: anInterval ifFail: failBlock debug: aBoolean
	"Private - Evaluate the specified, inclusive, range of text in the receiver within the
	receiver's evaluation context, evaluating failBlock if the compilation experiences errors,
	or the expression fails to complete when evaluated. If aBoolean is true then a debugger is
	brought up on the evaluation."

	| result expr |
	self cancelAutoCompletion.
	result := self
				compileRange: anInterval
				ifFail: failBlock
				debug: aBoolean.
	expr := result method.
	self developmentSystem sourceManager logEvaluate: expr getSource.

	".. if it is a debug request then associate a debugger with the active process"
	aBoolean
		ifTrue: 
			[| process |
			process := Processor activeProcess.
			process
				attachDebugger: 'Debug it'
				topFrame: process topFrame
				resumable: true].

	"... and evaluate the expression"
	result := expr value: self evaluationContext.
	self trigger: #expressionEvaluated: with: result.
	^result"Private - Answer the development system model."!

evaluationContext
	"Answers the evaluation context for this workspace."

	^evaluationContext!

evaluationContext: anObject
	"Sets the evaluation context for this workspace. Normally this is nil but for example in
	inspector workspaces evaluations are performed in the context of the object being inspected.
	This allows access to class variables and such like"

	evaluationContext := anObject.!

fileItIn
	"Files in the current selection in chunk format"

	<commandQuery: #hasSelection>
	^(self chunkFilerClass on: self selection readStream) fileIn!

findDetails
	"Answers the <FindDetails> from the last find executed in the receiver."

	^findDetails!

findDetails: aFindDetails 
	"Sets the findDetails instance variable to the argument."

	findDetails := aFindDetails!

firstError
	| ordered |
	ordered := compilationErrors
				asSortedArray: [:a :b | a severity > b severity or: [a severity = b severity and: [a position <= b position]]].
	^ordered isEmpty ifFalse: [ordered first]!

getCompletionSignatureFor: aString at: anInteger
	| selector |
	selector := aString asSymbol.
	(self styleRunBefore: anInteger - 1)
		ifNil: 
			[(self selfClass lookupMethod: selector)
				ifNotNil: [:method | ^self developmentSystem signatureOfMethod: method]]
		ifNotNil: 
			[:prev |
			| receiverStyle |
			receiverStyle := prev value.
			receiverStyle == #identifier
				ifTrue: 
					[| range |
					range := prev key.
					(self classForRange: range)
						ifNotNil: 
							[:methodClass |
							(methodClass lookupMethod: selector)
								ifNotNil: [:method | ^self developmentSystem signatureOfMethod: method]]]].
	"Perform a breadth-first traversal of the class hierarchy to find the highest definition of the selector and use the signature of that."
	Smalltalk allBehaviorsDo: 
			[:each |
			(each includesSelector: selector)
				ifTrue: [^self developmentSystem signatureOfMethod: (each compiledMethodAt: selector)]].
	"Should never get here - user shouldn't be offered choice of a selector that is not implemented."
	^self developmentSystem buildSimpleSignatureFor: selector!

hasErrors
	"Answer whether there are any errors in the source code (not warnings)"

	^compilationErrors anySatisfy: [:each | each severityClass == Error]!

hasFindDetails
	^self findDetails notNil!

hasSelection
	"Answers whether any text is selected in the receiver's view."
	
	^self view hasSelection!

hasSmalltalkStyler
	^self view styler isKindOf: SmalltalkStyler!

highlightCompilationErrors: anInteger
	| indicators annotations |
	self view removeIndicatorsOfTypes: ##(Set withAll: #(#Error #Warning #Notification)).
	indicators := self view indicators asOrderedCollection.
	annotations := OrderedCollection new.
	compilationErrors do: 
			[:each |
			indicators addLast: (Indicator
						typeName: each severityClass name
						range: each range + anInteger
						tag: each).
			annotations addLast: (Annotation
						line: each line
						text: ('<1s>: <2s>' expandMacrosWith: each severityName with: each errorMessage)
						style: each severityClass name)].
	self view
		indicators: indicators;
		annotations: annotations!

iconForVariable: aStVariable
	^aStVariable icon!

identifierAt: anInteger
	| style |
	style := (view styleAt: anInteger) name.
	^(#(#identifier #tempDecl #argDecl #blockArgDecl) identityIncludes: style)
		ifTrue: 
			[| range |
			range := view styleRunRangeAt: anInteger.
			StIdentifierToken
				start: range start
				comments: nil
				value: (view plainTextRange: range)]!

indicatorDefinitions
	^indicatorDefinitions!

indicatorDefinitions: aCollectionOfScintillaIndicatorDefinitions
	"The indicator definitions in a ScintillaView must be individual to it, so ensure we have a copy."

	indicatorDefinitions := aCollectionOfScintillaIndicatorDefinitions collect: [:each | each copy].
	self isOpen ifTrue: [self view indicatorDefinitions: indicatorDefinitions]!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := VariableTipsMask.
	"Set up the pools for evaluations in the receiver"
	self namespaces: {}.
	self newVariablePool.
	self clearStatus.
	compilationErrors := OrderedCollection new.
	self textStyles: self class textStyles.
	self indicatorDefinitions: self class indicatorDefinitions.
	self isAutoCompletionEnabled: self class isAutoCompletionEnabled.
	variableMetadataProvider := self!

insertCompletion: aString at: anInteger
	"Private-"

	view performUndoableAction: 
			[self completeWordAt: anInteger with: (self completionStringFor: aString at: anInteger)].!

insertKeywordCompletion: aString startingAt: anInteger
	| text selectionRange |
	selectionRange := (KeywordCompletions lookup: aString)
				ifNotNil: 
					[:template |
					| stream prefix word suffix start |
					stream := template readStream.
					prefix := stream upTo: $?.
					word := stream upTo: $?.
					suffix := stream upToEnd.
					text := prefix , word , suffix.
					start := anInteger + prefix size.
					start to: start + word size - 1]
				ifNil: 
					[| stream start |
					text := self getCompletionSignatureFor: aString at: anInteger.
					stream := text readStream.
					stream
						skipTo: $:;
						skipSeparators.
					start := stream position + anInteger.
					stream skipWhile: [:char | char isSeparator not].
					start to: stream position + anInteger - 1].
	view performUndoableAction: 
			[self completeWordAt: anInteger with: text.
			view selectionRange: selectionRange]!

inspectIt
	"Evaluate and inspect the currently selected text (or the current line if there is no
	selection). Inspect the result."

	<acceleratorKey: 'Ctrl+I'>
	<acceleratorKey: 'Ctrl+Shift+I'>	"Alternate inspector"
	<acceleratorKey: 'Ctrl+Q'>		"VW compatibility"
	(self evaluateItIfFail: [^self]) inspect!

inspectWorkspacePool
	"Private - Open an inspector on the Workspace Pool containing the receiver's shared
	variables."

	<commandQuery: #isEditable>
	self workspacePool inspect!

isAutoCompletionCaseInsensitive
	^view isAutoCompletionCaseInsensitive!

isAutoCompletionEnabled
	^flags allMask: AutoCompleteMask!

isAutoCompletionEnabled: aBoolean 
	flags := flags mask: AutoCompleteMask set: aBoolean!

isAutoCompletionTruncating
	^view isAutoCompletionTruncating!

isEditable
	^self isReadOnly not!

isModified
	"Answer whether the text in the receiver has been modified."

	^self view isModified!

isModified: aBoolean
	"Set/reset the receiver's dirty flag."

	self view isModified: aBoolean!

isReadOnly
	^self view isReadOnly!

isReadOnly: aBoolean 
	"We can't just disable the source pane since the underlying Windows control will also
	disable any scroll bar. Just using the #isReadOnly setting on a ScintillaView results in no
	visual cue so we also choose to replace the background colour"

	self isReadOnly == aBoolean ifTrue: [^self].
	self isReadOnly 
		ifFalse: 
			["Save the original background colour as a property"
			self view propertyAt: #_backcolor put: self view backcolor].
	(self view)
		isReadOnly: aBoolean;
		backcolor: (aBoolean 
					ifFalse: [self view propertyAt: #_backcolor ifAbsent: [^self]]
					ifTrue: [Color face3d])!

isSpecialToken: anAssociation oneOf: aString 
	^anAssociation value == #specialCharacter 
		and: [aString identityIncludes: (view characterAt: anAssociation key stop)]!

isSyntaxColoringEnabled
	^self view isStylingEnabled!

isWhitespaceAt: anInteger 
	^(view characterAt: anInteger) isSeparator 
		and: [(view styleIdAt: anInteger) = (view idOfStyleNamed: #whitespace)]!

isWriteable
	^self isReadOnly not!

killAutocompleteTimer
	self view killTimer: SCI_AUTOCSHOW!

maxCompletionListSize
	"Private - Answer the maximum number of items to display in a completion list when explicitly requested by the user. This is typically a much larger number than the maximum for auto-completion lists because we generally don't want them to pop up automatically until the number of choices is reasonable. This limit is to avoid an excessive delay in generating and displaying the list, although it can be very large."

	^10000!

maybeExtendingQualifiedNameAt: anInteger 
	^anInteger > 1 
		and: [(view characterAt: anInteger) == $. and: [(view styleAt: anInteger - 1) name == #identifier]]!

maybeShowCompletionList
	| styleName last |
	view isReadOnly ifTrue: [^self].
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	
	[(self
		autoComplete: styleName
		at: last
		maxItems: self class maxAutoCompletionListSize)
			ifNil: 
				[| char |
				"If a space is typed after certain identifiers e.g. an instance
				 variable in the debugger, or when certain special characters are
				 typed, we can show a sensible auto-completion list."
				char := view characterAt: last.
				((char == $^ and: [styleName == #specialCharacter])
					or: [char == $\x20 and: [(view styleIdAt: last) = (view idOfStyleNamed: #whitespace)]])
						ifTrue: 
							[self showCompletionListAfterStyleRun: (self styleRunBefore: last)
								maxItems: self class maxAutoCompletionListSize]]]
			on: OperationAborted
			do: [:ex | ]!

messagesForStyleRun: anAssociation startingWith: aString maxItems: anInteger
	"Private - Answer a completion list of selectors that could potentially be sent as messages following the specified token."

	| selectors class ignoreCase icon |
	ignoreCase := self isAutoCompletionCaseInsensitive.
	class := self classForStyleRun: anAssociation.
	"When completing against a variable that happens to have the value nil,
	treat it as possibly being of any type, as most likely it is simply uninitialized."
	(class notNil and: [class realClass == UndefinedObject and: [anAssociation value == #identifier]])
		ifTrue: [class := nil].
	selectors := Set new.
	(class ifNil: [self systemModel]) allSelectors do: 
			[:each |
			(each beginsWith: aString ignoreCase: ignoreCase)
				ifTrue: 
					[selectors add: each.
					selectors size > anInteger ifTrue: [OperationAborted signal]]].
	icon := Message icon.
	^selectors collect: 
			[:each |
			ListItem
				object: each
				text: each
				icon: icon]!

modifiedModel
	^modifiedModel!

modifiedModel: aValueModel
	modifiedModel := aValueModel!

nameBindingContext
	^self parseContext!

namespaces
	"Answers the namespaces imported into this workspace."

	^namespaces!

namespaces: aSequenceableCollection
	"Sets the namespaces importeed into this workspace to the specified sequence."

	namespaces := aSequenceableCollection asArray!

newVariablePool
	workspacePool := PoolDictionary new!

nodeForRange: anInterval
	^self parseTree
		ifNotNil: [:tree | (tree whichNodeIsContainedBy: anInterval) ifNil: [tree bestNodeFor: anInterval]]!

onAutoComplete: aString startingAt: anInteger accept: aValueHolder
	"Private - The user has made a choice from the auto-completion list. Perform our own insertion, and suppress the view's default completion."

	((view styleAt: anInteger) name ~~ #literalSymbol and: [aString includes: $:])
		ifTrue: [self insertKeywordCompletion: aString startingAt: anInteger]
		ifFalse: [self insertCompletion: (self completionForChoice: aString) at: anInteger].
	aValueHolder value: false!

onCharAdded: aCharacter 
	(self isAutoCompletionEnabled and: [self isSyntaxColoringEnabled]) ifFalse: [^self].
	self startAutocompleteTimer!

onHoverEnd: aPoint 
	self view cancelCallTip!

onHoverStart: aPoint
	| indicators index scintilla style range |
	scintilla := self view.
	scintilla isAutoCompletionActive ifTrue: [^self].
	indicators := scintilla indicatorsUnder: aPoint.
	(indicators notEmpty and: [self showTipForIndicators: indicators]) ifTrue: [^self].
	self areVariableTipsEnabled ifFalse: [^self].
	index := scintilla charCloseToPosition: aPoint.
	index <= 0 ifTrue: [^self].
	style := (view styleAt: index) name.
	range := view styleRunRangeAt: index.
	"Can be useful to see a tip for Characters, especially those expressed in $\xNN[NN] form. The tip now includes the Unicode character name."
	style == #literalCharacter
		ifTrue: 
			[self showTipForCharacterAt: index.
			^self].
	style == #literalNumber
		ifTrue: 
			[self showTipForNumberAt: index.
			^self].
	style == #literalBytes
		ifTrue: 
			[self showTipForByteArrayAt: index.
			^self].
	(#(#identifier #tempDecl #argDecl #blockArgDecl) identityIncludes: style)
		ifTrue: [self showTipForIdentifierStyle: style range: range]!

onRightButtonReleased: aMouseEvent 
	"If the right button is clicked outside the selection range, then change the caret position
	to the clicked position before the context menu is popped. This gives better results with
	context sensitive operations such as refactorings, auto-correction, etc, that can determine
	the type of parse node under a position and which don't require the full range of relevant
	text to be selected."

	| range pos |
	range := self selectionRange.
	pos := self view charNearestPosition: aMouseEvent position.
	(pos between: range start and: range stop) ifFalse: [self caretPosition: pos].
	^super onRightButtonReleased: aMouseEvent!

onTimerTick: anInteger 
	anInteger == SCI_AUTOCSHOW ifFalse: [^self].
	self killAutocompleteTimer.
	view isAutoCompletionActive ifFalse: [self maybeShowCompletionList]!

onViewAvailable
	super onViewAvailable.
	self applyOptions.!

onViewStateRestored
	super onViewStateRestored.
	self applyOptions!

parseContext
	^self evaluationContext
		ifNil: [self systemModel defaultParseContext]
		ifNotNil: [:receiverObj | ParseContext methodClass: receiverObj basicClass]!

parseTree
	^nil!

plainText
	"Answer the receiver's unformatted source text as a String."

	^self view plainText!

plainTextRange: anInterval 
	^self view plainTextRange: anInterval!

printIt
	"Evaluate the currently selected text (or the current line if there is no selection). Print
	(i.e. show the printString of) the result at the current insert point (i.e. immediately
	after the selection)."

	<commandQuery: #isWriteable>
	<acceleratorKey: 'Ctrl+P'>
	self evaluateAndDisplay: [:obj | obj printString]!

prompt: aString toSaveChanges: aSelectionChangingEvent
	self isModified == true
		ifTrue: 
			[| response prompt |
			self ensureVisible.
			prompt := aSelectionChangingEvent canIntercept 
						ifTrue: ['Do you want to preserve your unsaved <1s> changes?']
						ifFalse: ['Do you want to copy your unsaved <1s> changes to the clipboard?'].
			response := MessageBox new
						owner: self view topView;
						headline: prompt << aString;
						confirm.
			aSelectionChangingEvent canIntercept
				ifTrue: 
					[response
						ifTrue: 
							[self ensureVisible.
							aSelectionChangingEvent value: false]
						ifFalse: [self isModified: false]]
				ifFalse: 
					[self isModified: false.
					response ifTrue: [self text copyToClipboard]]].
	^aSelectionChangingEvent value!

promptForVariableName: anObjectRef
	"Prompt for a variable name to represent anObjectRef in the receiver's workspace pool"

	^(Prompter
		createOn: anObjectRef key asValue
		prompt: 'Enter a variable name:'
		caption: ('Drop of <s> onto workspace' expandMacrosWith: anObjectRef value basicPrintString))
		validater: 
				[:var |
				| result |
				result := (RBCondition isValidTemporaryVariableName: var) validate.
				result value
					ifTrue: 
						[(self workspacePool includesKey: var)
							ifTrue: [result errorMessage: '<p> is already defined in the workspace' << var]].
				result];
		showHintWhenEmpty: false;
		showModal!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: self class textStylesAspect;
		add: self class indicatorDefinitionsAspect;
		yourself!

queryBrowseClassOfLiteral: aCommandQuery
	self selectedLiteralValue
		ifNotNil: 
			[:literal |
			aCommandQuery
				beEnabled;
				text: 'Class <p>' << literal class]!

queryBrowseDefinitions: aCommandQuery
	"Browse Definitions (F12) is a context-sensitive command. We open a browser appropriate to the selected node, or let some other presenter handle if if the selected node is not browsable.
	As the command's menu text typically has an insertion to specify what will be browsed, we ensure it is reset, otherwise it might end up displaying whatever was last browsable."

	self browseDefinitionsCommand
		ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseLiteralReferences: aCommandQuery
	self selectedLiteralValue
		ifNotNil: 
			[:literal |
			aCommandQuery
				beEnabled;
				expandMenuTextWith: literal species name , ' ' , (literal printStringLimitedTo: 30)]!

queryBrowseReferences: aCommandQuery
	"Browse References (Shift+F12) is a context-sensitive command. We open a browser appropriate to the selected node, or let some other presenter handle if if the selected node is not browsable for references.
	As the command's menu text typically has an insertion to specify what will be browsed, we ensure it is reset, otherwise it might end up displaying whatever was last browsable."

	self browseReferencesCommand
		ifNotNil: [:selector | self queryContextCommand: aCommandQuery as: selector]!

queryBrowseSelectorDefinitions: aCommandQuery
	self selectedSymbol
		ifNotNil: 
			[:selector |
			aCommandQuery
				beEnabled;
				expandMenuTextWith: 'selector <p>' << selector]!

queryBrowseVariableDefinition: aCommandQuery
	| pos var |
	pos := self selectedTokenPosition.
	(pos == 0 or: [(view styleAt: pos) name ~~ #identifier]) ifTrue: [^self].
	var := self variableForIdentifierStyle: #identifier range: (view styleRunRangeAt: pos).
	(self suggestClassForVariable: var)
		ifNotNil: 
			[:varClass |
			aCommandQuery
				beEnabled;
				text: 'Class <p>' << varClass instanceClass]!

queryBrowseVariableReferences: aCommandQuery
	| pos |
	pos := self selectedTokenPosition.
	(pos ~~ 0 and: [(view styleAt: pos) name == #identifier])
		ifTrue: 
			[| var |
			var := self variableForIdentifierStyle: #identifier range: (view styleRunRangeAt: pos).
			(self suggestClassForVariable: var)
				ifNotNil: 
					[:varClass |
					aCommandQuery
						beEnabled;
						expandMenuTextWith: varClass instanceClass shortName]]!

queryToggleAutoCompletion: aCommandQuery
	(self isReadOnly not and: [self hasSmalltalkStyler and: [self isSyntaxColoringEnabled]])
		ifTrue: 
			[aCommandQuery
				isChecked: self isAutoCompletionEnabled;
				beEnabled]
		ifFalse: 
			[aCommandQuery
				isChecked: false;
				beDisabled]!

queryToggleStyling: aCommandQuery
	self hasSmalltalkStyler
		ifTrue: 
			[aCommandQuery
				beEnabled;
				isChecked: self isSyntaxColoringEnabled]
		ifFalse: 
			[aCommandQuery
				beDisabled;
				isChecked: false].
	"Ensure the command is not handled by the view"
	aCommandQuery receiver: self!

rangeToCompleteAt: anInteger 
	^(self isWhitespaceAt: anInteger) 
		ifTrue: [anInteger to: anInteger - 1]
		ifFalse: 
			[self isAutoCompletionTruncating 
				ifTrue: [self styleRunRangeAt: anInteger]
				ifFalse: [anInteger to: view caretPosition - 1]]!

reformatComment
	"Rewrap the comment under the caret so that its lines start at the position of the 
	comment's opening quote, and are no longer than the current  of the workspace view."

	<commandQuery: #canReformatComment>
	| range |
	range := view styleRunRangeAt: view caretPosition.
	self wrapLinesInRange: range indent: (view columnFromPosition: range start)!

reformatSource
	"Reformat and syntax colour the selected range of source in the receiver as if it is an expression. 
	Attempts to maintain the base indentation of the first selected line."

	<commandQuery: #canReformatSource>
	| source formatter reformatted expr tabs |
	source := self hasSelection ifTrue: [self selection] ifFalse: [self text].
	tabs := (source findFirst: [:each | each ~~ $\t]) - 1.
	expr := 
			[| context |
			context := self parseContext.
			Parser
				parseExpression: source
				in: context methodClass
				environment: context environment]
					on: Parser notificationClass
					do: [:e | e okToContinue ifTrue: [e exit: nil] ifFalse: [^self]].
	formatter := expr formatterClass new.
	reformatted := tabs <= 0
				ifTrue: [formatter format: expr]
				ifFalse: [formatter indent: tabs around: [(source copyFrom: 1 to: tabs) , (formatter format: expr)]].
	^self hasSelection
		ifTrue: [self replaceSelection: reformatted]
		ifFalse: 
			[self text: reformatted.
			self view moveToEndOfDocument]!

replaceSelection: aString
	"Replace the current selected range of text with aString"
	
	^self view replaceSelection: aString!

resolveClassNamed: qualifierString
	(self nameBindingContext resolveIdentifier: qualifierString)
		ifNotNil: [:var | var binding ifNotNil: [:binding | binding isClassBinding ifTrue: [^binding value]]].
	^nil!

resolveIdentifier: aString
	^(self nameBindingContext resolveIdentifier: aString)
		ifNil: 
			["Workspace pool is lowest priority, although only because the debugger uses this to create pseudo variables to represent the stack variables and we don't want to find these before the actual temps in the parse tree."
			(self workspacePool bindingFor: aString)
				ifNotNil: 
					[:var |
					^StWorkspaceVariable scope: (StEvalScope pools: { self workspacePool } outer: nil) binding: var]]!

searchEnvironment
	^searchEnvironment ifNil: [self systemModel browserEnvironment]!

searchEnvironment: aBrowserEnvironment 
	searchEnvironment := aBrowserEnvironment!

selectedIdentifier
	| pos |
	pos := self selectedTokenPosition.
	^(pos ~~ 0 and: [(view styleAt: pos) name == #identifier]) ifTrue: [view styleRunTextAt: pos]!

selectedLiteralValue
	| pos tokenStyle |
	pos := self selectedTokenPosition.
	pos == 0 ifTrue: [^nil].
	tokenStyle := (view styleAt: pos) name.
	(LiteralStyleNames includes: tokenStyle)
		ifTrue: [^(Scanner on: (view plainTextRange: (self styleRunRangeAt: pos)) readStream) next value].
	^nil!

selectedSymbol
	| pos |
	pos := self selectedTokenPosition.
	^(pos ~~ 0 and: [(view styleAt: pos) name == #literalSymbol])
		ifTrue: 
			[| tokenRange |
			tokenRange := view styleRunRangeAt: pos.
			(view plainTextFrom: tokenRange start + 1 to: tokenRange stop) asSymbol]!

selectedTokenPosition
	^self hasSelection
		ifTrue: 
			[| start |
			start := view selectionStart.
			(view styleRunRangeAt: start) = view selectionRange ifTrue: [start] ifFalse: [0]]
		ifFalse: [view caretPosition]!

selectedWord
	"Private - Answers a selection that may be of interest given by the current state of the
	receiver. This is used by #browseImplementors, #browseSenders, etc, as a suitable starting
	point for the search"

	| selected |
	selected := self selection.
	^selected isEmpty
		ifTrue: 
			[| caret |
			caret := view caretPosition.
			caret > view textLength ifTrue: [''] ifFalse: [view styleRunTextAt: caret]]
		ifFalse: [selected trimBlanks subStrings first]!

selectEvaluationRange
	"Private - Answer the current evaluation range, selecting the current line and answering its
	entire range if there is no selection."

	| te range |
	te := self view.
	range := te selectionRange.
	range isEmpty ifTrue: [range := te selectCurrentLine].
	^range!

selection
	"Answer the currently selected text in the receiver's source"

	^self view selection!

selectionRange
	"Answers an interval identifying the selected range of text. N.B. The last entry in the
	selection is exclusive (this is the way the underlying Windows controls identify an empty
	selection and caret position with the same interval)."
	
	^self view selectionRange!

selectionRange: anInterval
	"Sets anInterval to be the selected range of text. The last character in the interval is not
	included in the actual selection."
	
	^self view selectionRange: anInterval
!

selectLine: anInteger
	"Selects the complete line of text in the receiver at line number, anInteger, but excluding
	any end-of-line terminators. Line 1 is the first line of text. A BoundsError will be
	generated if the argument is between 1 and the number of lines in the receiver."

	^self view selectLine: anInteger!

selectNext
	"Select the next indicated region. If there are no further regions move to end. If at end
	cycle around to the first region. Indicators are used to mark errors, etc, so this typically
	equates to moving to the next error."

	<acceleratorKey: 'F8'>
	| indicators pos |
	indicators := view indicators.
	indicators isEmpty
		ifTrue: 
			[Sound warningBeep.
			^self].
	pos := view caretPosition.
	self selectionRange: ((indicators detect: [:each | each range start > pos] ifNone: nil)
				ifNil: 
					[| len |
					len := self textLength.
					pos > len ifTrue: [indicators first range] ifFalse: [len + 1 to: len]]
				ifNotNil: [:next | next range])!

selectorsStartingWith: aString maxItems: anInteger
	"Private - Build and answer a collection of selectors from those implemented in the
	receiver's superclasses that are potential completions for the specified prefix. If there
	are more matching selectors than the specified maximum, then answer an empty collection."

	| selectors class |
	selectors := Set new.
	class := self selfClass.
	class allSuperclassesDo: (aString isEmpty
				ifTrue: 
					[
					[:eachClass |
					selectors addAll: eachClass selectors.
					selectors size > anInteger ifTrue: [OperationAborted signal]]]
				ifFalse: 
					[| ignoreCase |
					ignoreCase := self isAutoCompletionCaseInsensitive.
					
					[:eachClass |
					eachClass selectors do: 
							[:eachSelector |
							(eachSelector beginsWith: aString ignoreCase: ignoreCase)
								ifTrue: 
									[selectors add: eachSelector.
									selectors size > anInteger ifTrue: [OperationAborted signal]]]]]).
	"Remove anything already overridden"
	^selectors difference: class selectors!

selectPrev
	"Select the previous indicated region. If there is no previous region, move to home. If at
	home cycle around to the last indicated region. Indicators are used to mark errors, etc, so
	this typically equates to moving to the previous compilation error."

	<acceleratorKey: 'Shift+F8'>
	| indicators pos |
	indicators := view indicators.
	indicators isEmpty
		ifTrue: 
			[Sound warningBeep.
			^self].
	pos := self selectionRange start.
	self selectionRange: ((indicators reverse detect: [:each | each range start < pos] ifNone: nil)
				ifNil: [pos = 1 ifTrue: [indicators last range] ifFalse: [1 to: 0]]
				ifNotNil: [:next | next range])!

selfClass
	^self parseContext methodClass!

setBackcolor
	view backcolor: self class defaultBackcolor!

setCaretColor
	self class defaultCaretColor ifNotNil: [:color | view caretForecolor: color]!

setFont
	| requiredFont |
	requiredFont := self class actualFont.
	"Don't set the font unless it really has changed, as if we do we need to rebuild all the styles, which is quite expensive."
	view actualFont = requiredFont ifFalse: [view font: requiredFont]!

setTabWidth
	view tabWidth: self class defaultTabWidth!

setWordWrap
	view wordWrap: self class wordWrap!

showCompletionList: aCollection prefixLength: anInteger
	(aCollection size = 1 and: [aCollection anyOne size = anInteger])
		ifTrue: 
			["Don't display a list of one item that is the same as the prefix"
			^self].
	view
		showAutoCompletionList: (aCollection asSortedCollection: self completionListSortBlock)
		prefixLength: anInteger
		withIcons: true!

showCompletionListAfterStyleRun: anAssociation maxItems: anInteger
	| styleName |
	anAssociation isNil ifTrue: [^self].
	"Don't try and autocomplete after tokens inside arrays"
	(view isIndicator: view styler literalArrayIndicatorId setAt: anAssociation key stop)
		ifTrue: [^self].
	styleName := anAssociation value.
	((#(#tempCloseBar #argDecl #unarySelector #assignment #binaryMessage #keywordMessage)
		identityIncludes: styleName) or: [self isSpecialToken: anAssociation oneOf: '.[(^'])
		ifTrue: 
			[self showCompletionList: (self
						visibleIdentifiersAt: anAssociation key start
						startingWith: ''
						atMost: anInteger)
				prefixLength: 0.
			^self].
	((#(#identifier #unaryMessage #literalString #literalNumber #literalCharacter #literalPseudo #literalSymbol)
		identityIncludes: styleName) or: [self isSpecialToken: anAssociation oneOf: '])}'])
		ifTrue: 
			[self showCompletionList: (self
						messagesForStyleRun: anAssociation
						startingWith: ''
						maxItems: anInteger)
				prefixLength: 0.
			^self]!

showError: aCompilerError offset: anInteger 
	self errorModel value isNil ifTrue: [aCompilerError beep].
	self errorModel value: aCompilerError.
	self selectionRange: aCompilerError range + anInteger!

showFirstError: anInteger 
	"Private - Display the first error, or warning, in the receiver's compilation errors collection,
	which contains errors collected on the last compilation or evaluation. Answer
	whether there are any errors."

	self highlightCompilationErrors: anInteger.
	self errorModel 
		ifNotNil: 
			[:errors | 
			self firstError 
				ifNil: [errors value: nil]
				ifNotNil: [:first | self showError: first offset: anInteger]].
	^compilationErrors notEmpty!

showIdentifierCompletionListAt: posInteger maxItems: maxInteger start: startInteger
	"Trim blanks in case requesting display of identifier list on whitespace"

	| prefix lastDot |
	prefix := (view plainTextFrom: startInteger to: posInteger) trimBlanks.
	lastDot := prefix lastIndexOf: $..
	lastDot == 0
		ifTrue: 
			[self showCompletionList: (self
						visibleIdentifiersAt: startInteger
						startingWith: prefix
						atMost: maxInteger)
				prefixLength: prefix size]
		ifFalse: 
			[self
				completeQualifiedIdentifier: (prefix copyFrom: 1 to: lastDot - 1)
				startingWith: (prefix copyFrom: lastDot + 1 to: prefix size)
				maxItems: maxInteger]!

showMessageCompletionListAt: posInteger maxItems: maxInteger 
	| start prefix selectors |
	start := self styleRunStartAt: posInteger.
	prefix := view plainTextFrom: start to: posInteger.
	selectors := self 
				messagesForStyleRun: (self styleRunBefore: start - 1)
				startingWith: prefix
				maxItems: maxInteger.
	self showCompletionList: selectors prefixLength: prefix size!

showResult: aString at: anInteger
	"Private - Show the result of an evaluation."

	self isOpen ifFalse: [^self].
	self caretPosition: anInteger.
	self replaceSelection: aString.
	self selectionRange: (anInteger to: anInteger + aString size - 1)!

showSelectorCompletionListAt: posInteger maxItems: maxInteger start: startInteger
	| prefix choices |
	prefix := view plainTextFrom: startInteger to: posInteger.
	choices := self selectorsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size!

showSymbolCompletionListAt: posInteger maxItems: maxInteger
	| prefix start symbols quoted prefixLength |
	start := self styleRunStartAt: posInteger.
	prefix := view plainTextRange: (start to: posInteger).
	prefixLength := prefix size.
	prefix first == $#
		ifTrue: 
			[prefix := prefix copyFrom: 2.
			prefixLength := prefixLength - 1].
	(quoted := prefix notEmpty and: [prefix first == $']) ifTrue: [prefix := prefix copyFrom: 2].
	symbols := self symbolsStartingWith: prefix maxItems: maxInteger.
	quoted ifTrue: [symbols := symbols collect: [:each | each displayString printString]].
	self showCompletionList: symbols prefixLength: prefixLength!

showTipForByteArrayAt: anInteger
	| elementText byte |
	elementText := view wordTextAt: anInteger.
	byte := Integer fromString: elementText.
	byte > 9 ifFalse: [^self].
	self view showCallTip: ((elementText includes: $r) ifTrue: [byte printString] ifFalse: [byte hex])
		at: anInteger!

showTipForCharacterAt: anInteger
	| representation ch tokenText tip charName |
	tokenText := view styleRunTextAt: anInteger.
	ch := (Scanner on: tokenText readStream) next value.
	tip := String writeStream.
	(ch isGraph
		ifTrue: 
			[representation := ch asUtf8String.
			representation = (tokenText copyFrom: 2)]
		ifFalse: 
			[representation := ch printString.
			representation = tokenText])
			ifTrue: [tip nextPutAll: 'Codepoint: ']
			ifFalse: 
				[tip
					nextPutAll: 'Character: ';
					nextPutAll: representation;
					nextPutAll: ', '].
	tip
		nextPutAll: ch codePointString;
		space.
	charName := ch unicodeName.
	tip nextPutAll: (charName isEmpty ifTrue: ['<unnamed>'] ifFalse: [charName]).
	self view showCallTip: tip contents at: anInteger!

showTipForIdentifierStyle: aSymbol range: anInterval
	(self variableForIdentifierStyle: aSymbol range: anInterval)
		ifNotNil: 
			[:var |
			| tip |
			tip := variableMetadataProvider tipForVariable: var.
			"Don't display the tip if it contains no useful information"
			(tip isNil or: [tip = (view plainTextRange: anInterval)])
				ifFalse: [self view showCallTip: tip at: anInterval stop]]!

showTipForIndicators: aCollectionOfScintillaIndicators
	| tip last |
	tip := String writeStream.
	last := 0.
	(aCollectionOfScintillaIndicators select: [:each | each tag notNil]) do: 
			[:each |
			tip nextPutAll: each tag displayString.
			last := last max: each range stop + 2]
		separatedBy: [tip nextPut: $\n].
	tip := tip grabContents.
	tip isEmpty ifTrue: [^false].
	self view showCallTip: tip at: last.
	^true!

showTipForNumberAt: anInteger
	| tokenText token number standard |
	tokenText := view styleRunTextAt: anInteger.
	token := (Scanner on: tokenText readStream) next.
	number := token value.
	standard := number printString.
	standard = tokenText
		ifTrue: 
			["Show the hex value for integers where that might be useful"
			(number isInteger and: [number > 9])
				ifTrue: [self view showCallTip: (number printStringRadix: 16) at: anInteger]]
		ifFalse: 
			["Show the standard Smalltalk literal form for the number where the source format is different"
			self view showCallTip: standard at: anInteger]!

startAutocompleteTimer
	self view setTimer: SCI_AUTOCSHOW interval: self class autoCompleteDwell!

stylerClass: aScintillaStylerClass
	self view stylerClass: aScintillaStylerClass!

styleRunBefore: anInteger
	^view styler styleRunBefore: anInteger!

styleRunRangeAt: anInteger
	^(view styleAt: anInteger) name == #specialCharacter
		ifTrue: [anInteger to: anInteger]
		ifFalse: [view styleRunRangeAt: anInteger]!

styleRunStartAt: anInteger
	^(view styleAt: anInteger) name == #specialCharacter
		ifTrue: [anInteger]
		ifFalse: [view styleRunStartAt: anInteger]!

suggestClassForVariable: aStVariable
	^aStVariable ifNotNil: [variableMetadataProvider classForVariable: aStVariable]!

symbolsStartingWith: aString maxItems: anInteger
	| stream ignoreCase |
	stream := Array writeStream: (anInteger bitShift: -1).
	ignoreCase := self isAutoCompletionCaseInsensitive.
	Symbol allInstancesDo: 
			[:each |
			(each beginsWith: aString ignoreCase: ignoreCase)
				ifTrue: 
					[stream nextPut: each.
					stream size > anInteger ifTrue: [OperationAborted signal]]].
	^stream contents!

text
	"Answer the receiver's text contents - always plainText in DX6 and later."

	^self view text!

text: aString
	"Set the text in the receiver to aString"

	^self view text: aString!

textLength
	"Answer the number of characters in plain text of the receiver"

	^self view textLength!

textStyles
	^textStyles!

textStyles: aCollectionOfScintillaTextStyles 
	textStyles := aCollectionOfScintillaTextStyles asArray.
	self isOpen ifTrue: [self view textStyles: textStyles]!

tipForVariable: aStVariable
	^aStVariable infoTip!

toggleAutoCompletion
	<commandQuery: #queryToggleAutoCompletion:>
	^self isAutoCompletionEnabled: self isAutoCompletionEnabled not!

toggleStyling
	<commandQuery: #queryToggleStyling:>
	^self view toggleStyling!

unambiguousCompletionForBinding: aVariableBinding
	"Private - Generate an insertion string for the specified variable that is unambiguous for the user, but that also allows us to later identify the correct identifier to insert, since unfortunately Scintilla does not pass the index of the item selected from the auto-completion list, only the string. We can do this by appending the namespace fullname in some unique way. We must use a smple space, i.e. $\x20,  to separate the namespace qualification from the unqualified name because the Scintilla list uses a simple C sort of the items, not a linguistic sort. This means that any of the other Unicode spaces will cause the qualified items to sort after any longer unqualified identifiers of the same prefix, which is certainly not what we want. We use some special brackets around the qualified name, however, to avoid confusing with normal brackets, although in practice these are only likely in package names, and these should not appear in the completion lists in workspaces, only in the search presenter."

	^'<1d> (<2d>)' << { aVariableBinding key. aVariableBinding environment fullName }!

updateErrorStatus
	self errorModel ifNotNil: [:errors | errors value: self firstError]!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time when the UI
	has been flagged as being invalid"

	super validateUserInterface.
	self modifiedModel value: self isModified!

variableForIdentifierStyle: aSymbol range: anInterval
	| node name |
	node := self nodeForRange: anInterval.
	node
		ifNotNil: 
			[node isVariable ifFalse: [^nil].
			node variable ifNotNil: [:var | ^var]].
	"Parse tree may not have undergone semantic analysis yet"
	name := view plainTextRange: anInterval.
	(self resolveIdentifier: name) ifNotNil: [:var | ^var].
	"Synthesize a likely variable:
		- Any known instance variables in scope would have been resolved (doesn't require a parse tree).
		- Any known static variables in scope would have been resolved (doesn't require a parse tree).
		- For the method/block parameters and temp declarations we know the right variable type (determined by the styling lexer).
		- For other cases we make an educated guess:
			- Static variables start with uppercase letters by convention, so for such identifiers assume an undeclared static variable
			- Assume other cases are temps"
	(aSymbol == #argDecl or: [aSymbol == #blockArgDecl])
		ifTrue: 
			["Method/block parameter "
			^StArgumentVariable node: (StParameterNode named: name start: anInterval start)].
	aSymbol == #tempDecl
		ifTrue: 
			["Method or block temporary declaration - we don't know which without a parse tree, but doesn't really matter for most purposes"
			^StTempVariable node: (StTempDeclNode named: name start: anInterval start)].
	"Other identifiers"
	name first isUpperCase
		ifTrue: 
			["Undeclared static"
			^StStaticVariable scope: self parseContext scope binding: nil].
	"Assume a temp"
	^StTempVariable node: (node ifNil: [StBasicVariableNode named: name start: anInterval start])!

variableMetadataProvider: aVariableResolver
	variableMetadataProvider := aVariableResolver!

visibleIdentifiersAt: posInteger startingWith: aString atMost: maxInteger
	"Private - Build and answer a collection of identifiers that are visible at the <integer> caret position, posInteger, as potential completions for the <String> prefix, aString. If in case-sensitive mode assume that the convention is followed of starting all class/pool/global variables with an uppercase letter, and all temps and inst. vars with a lowercase letter. If there are more matching identifiers than the maximum specified by the <integer>, maxInteger, then answer an empty collection."

	| ignoreCase candidates |
	candidates := Set new.
	ignoreCase := self isAutoCompletionCaseInsensitive.
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase not]])
		ifTrue: 
			[| currentNode |
			#(nil true false) do: 
					[:each |
					(each printString beginsWith: aString ignoreCase: ignoreCase)
						ifTrue: [candidates add: (ListItem object: each text: each printString)]].
			currentNode := self nodeForRange: (posInteger to: posInteger).
			self allVariablesVisibleFrom: currentNode
				do: 
					[:each |
					(each name beginsWith: aString ignoreCase: ignoreCase)
						ifTrue: 
							[candidates add: (ListItem
										object: each
										text: each name
										icon: (self iconForVariable: each)).
							candidates size > maxInteger ifTrue: [OperationAborted signal]]]].
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase]])
		ifTrue: 
			[self
				addAllStaticIdentifiersStartingWith: aString
				to: candidates
				limit: maxInteger].
	^candidates!

workspacePool
	"Answer the <Dictionary> for locals used in evaluations within the receiver"

	^workspacePool!

workspacePool: aDictionaryOrNil
	"Set the Dictionary for locals used in evaluations within the receiver"
	
	workspacePool := aDictionaryOrNil!

wrapLinesInRange: anInterval indent: anInteger 
	| scintilla justified |
	scintilla := self view.
	scintilla targetRange: anInterval.
	justified := self developmentSystem 
				wrapText: scintilla targetText
				indent: anInteger
				tabWidth: scintilla tabWidth.
	scintilla replaceTarget: justified"Private - Answer the development system model."! !

!Tools.SmalltalkWorkspace categoriesForMethods!
addAllStaticIdentifiersStartingWith:to:limit:!autocompletion!private! !
addStatic:toCompletionList:limit:!autocompletion!private! !
allPools!accessing!private! !
allVariablesVisibleFrom:do:!autocompletion!enumerating!private! !
applyOptions!operations!options!private! !
areVariableTipsEnabled!public!testing! !
areVariableTipsEnabled:!public!testing! !
autoComplete:at:maxItems:!autocompletion!helpers!private! !
basicFindNext!commands-actions!public! !
basicInspectIt!commands-actions!public! !
browseClassDefinition:!browsing!private! !
browseClassReferences:!browsing!private! !
browseDefinitions!commands-actions!public! !
browseDefinitionsCommand!commands-mappings!private! !
browseDefinitionsMatching:!browsing!private! !
browseIt!commands-actions!public! !
browseLiteralReferences!commands-actions!public! !
browseMessageDefinitions!commands-actions!private! !
browseMessageDefinitions:in:!browsing!private! !
browseMessageReferences!commands-actions!private! !
browseMessageReferences:in:!browsing!private! !
browseMethodsIn:!operations!public! !
browseReferences!commands-actions!public! !
browseReferencesCommand!commands-mappings!private! !
browseReferencesMatching:!browsing!private! !
browseSelectorDefinitions!commands-actions!public! !
browseVariableDefinition!commands-actions!public! !
browseVariableReferences!commands-actions!public! !
cancelAutoCompletion!helpers!private! !
canReformatComment!commands-queries!private! !
canReformatSource!commands-queries!private! !
caretPosition:!accessing!caret!public! !
chooseNamespaces!commands-actions!public! !
chunkFilerClass!constants!public! !
classForRange:!autocompletion!helpers!private! !
classForStyleRun:!autocompletion!helpers!private! !
classForVariable:!helpers!public! !
clear!operations!public! !
clearErrors!operations!public! !
clearStatus!operations!public! !
cloneNew!commands-actions!public! !
compilationErrors!accessing!private! !
compileAll!commands-actions!public! !
compileAllIfFail:!helpers!private! !
compileIt!commands-actions!public! !
compileItIfFail:!helpers!private! !
compileRange:ifFail:!helpers!private! !
compileRange:ifFail:debug:!helpers!private! !
compilerNotification:offset:!helpers!private! !
completeInitialWord!autocompletion!helpers!private! !
completeQualifiedIdentifier:startingWith:maxItems:!autocompletion!helpers!private! !
completeWord!autocompletion!commands-actions!public! !
completeWordAt:with:!autocompletion!helpers!private! !
completionForChoice:!autocompletion!private! !
completionListSortBlock!autocompletion!constants!private! !
completionStringFor:at:!autocompletion!helpers!private! !
copySelection!commands-actions!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
debugIt!commands-actions!public! !
debugItIfFail:!helpers!private! !
defaultCompilerFlags!constants!private! !
defaultStylerClass!constants!private! !
descriptionOfVariable:!public! !
developmentSystem!constants!private! !
displayIt!commands-actions!public! !
dragOver:!drag & drop!public! !
drop:!drag & drop!public! !
dropObjectRef:!helpers!private! !
errorModel!accessing!public! !
errorModel:!accessing!public! !
evaluateAndDisplay:!commands-actions!public! !
evaluateIt!commands-actions!public! !
evaluateItIfFail:!helpers!private! !
evaluateItIfFail:debug:!helpers!private! !
evaluateRange:ifFail:!helpers!private! !
evaluateRange:ifFail:debug:!helpers!private! !
evaluationContext!accessing!public! !
evaluationContext:!accessing!public! !
fileItIn!commands-actions!public! !
findDetails!accessing!public! !
findDetails:!accessing!public! !
firstError!helpers!private! !
getCompletionSignatureFor:at:!autocompletion!helpers!private! !
hasErrors!public!testing! !
hasFindDetails!public!testing! !
hasSelection!public!testing! !
hasSmalltalkStyler!commands-actions!private! !
highlightCompilationErrors:!helpers!private! !
iconForVariable:!helpers!public! !
identifierAt:!helpers!private! !
indicatorDefinitions!accessing!public! !
indicatorDefinitions:!accessing!public! !
initialize!initializing!private! !
insertCompletion:at:!autocompletion!helpers!private! !
insertKeywordCompletion:startingAt:!autocompletion!helpers!private! !
inspectIt!commands-actions!public! !
inspectWorkspacePool!commands-actions!private! !
isAutoCompletionCaseInsensitive!public!testing! !
isAutoCompletionEnabled!autocompletion!private!testing! !
isAutoCompletionEnabled:!accessing!autocompletion!private! !
isAutoCompletionTruncating!public!testing! !
isEditable!private!testing! !
isModified!public!testing! !
isModified:!modes!public! !
isReadOnly!public!testing! !
isReadOnly:!accessing!public! !
isSpecialToken:oneOf:!public!testing! !
isSyntaxColoringEnabled!private!testing! !
isWhitespaceAt:!accessing!autocompletion!private! !
isWriteable!private!testing! !
killAutocompleteTimer!autocompletion!private! !
maxCompletionListSize!autocompletion!constants!private! !
maybeExtendingQualifiedNameAt:!autocompletion!helpers!private! !
maybeShowCompletionList!autocompletion!helpers!private! !
messagesForStyleRun:startingWith:maxItems:!autocompletion!helpers!private! !
modifiedModel!accessing!public! !
modifiedModel:!accessing!public! !
nameBindingContext!accessing!autocompletion!private! !
namespaces!accessing!public! !
namespaces:!accessing!public! !
newVariablePool!operations!private! !
nodeForRange:!helpers!private! !
onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
onCharAdded:!autocompletion!event handling!private! !
onHoverEnd:!event handling!private! !
onHoverStart:!event handling!private! !
onRightButtonReleased:!event handling!public! !
onTimerTick:!event handling!private! !
onViewAvailable!event handling!public! !
onViewStateRestored!event handling!public! !
parseContext!commands-actions!public! !
parseTree!accessing!private! !
plainText!accessing!public! !
plainTextRange:!accessing!public! !
printIt!commands-actions!public! !
prompt:toSaveChanges:!helpers!private! !
promptForVariableName:!helpers!private! !
publishedAspects!development!public! !
queryBrowseClassOfLiteral:!commands-queries!private! !
queryBrowseDefinitions:!commands-queries!private! !
queryBrowseLiteralReferences:!commands-queries!private! !
queryBrowseReferences:!commands-queries!private! !
queryBrowseSelectorDefinitions:!commands-queries!private! !
queryBrowseVariableDefinition:!commands-queries!private! !
queryBrowseVariableReferences:!commands-queries!private! !
queryToggleAutoCompletion:!commands-actions!commands-queries!private! !
queryToggleStyling:!commands-actions!commands-queries!private! !
rangeToCompleteAt:!autocompletion!helpers!private! !
reformatComment!commands-actions!public! !
reformatSource!commands-actions!public! !
replaceSelection:!operations!public! !
resolveClassNamed:!helpers!private! !
resolveIdentifier:!autocompletion!helpers!private! !
searchEnvironment!commands-actions!public! !
searchEnvironment:!accessing!public! !
selectedIdentifier!helpers!private! !
selectedLiteralValue!commands-actions!public! !
selectedSymbol!helpers!private! !
selectedTokenPosition!helpers!private! !
selectedWord!helpers!private! !
selectEvaluationRange!helpers!private! !
selection!accessing!public! !
selectionRange!accessing!public! !
selectionRange:!accessing!public! !
selectLine:!operations!public! !
selectNext!commands-actions!public! !
selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
selectPrev!commands-actions!public! !
selfClass!accessing!autocompletion!private! !
setBackcolor!helpers!private! !
setCaretColor!helpers!private! !
setFont!helpers!private! !
setTabWidth!helpers!private! !
setWordWrap!helpers!private! !
showCompletionList:prefixLength:!autocompletion!helpers!private! !
showCompletionListAfterStyleRun:maxItems:!autocompletion!helpers!private! !
showError:offset:!helpers!private! !
showFirstError:!operations!private! !
showIdentifierCompletionListAt:maxItems:start:!autocompletion!helpers!private! !
showMessageCompletionListAt:maxItems:!autocompletion!helpers!private! !
showResult:at:!helpers!private! !
showSelectorCompletionListAt:maxItems:start:!autocompletion!helpers!private! !
showSymbolCompletionListAt:maxItems:!autocompletion!helpers!private! !
showTipForByteArrayAt:!helpers!private! !
showTipForCharacterAt:!helpers!private! !
showTipForIdentifierStyle:range:!helpers!private! !
showTipForIndicators:!helpers!private! !
showTipForNumberAt:!helpers!private! !
startAutocompleteTimer!autocompletion!helpers!private! !
stylerClass:!accessing!public! !
styleRunBefore:!accessing!autocompletion!private! !
styleRunRangeAt:!accessing!autocompletion!private! !
styleRunStartAt:!accessing!autocompletion!private! !
suggestClassForVariable:!helpers!public! !
symbolsStartingWith:maxItems:!autocompletion!helpers!private! !
text!accessing!public! !
text:!accessing!public! !
textLength!accessing!public! !
textStyles!accessing!public! !
textStyles:!accessing!public! !
tipForVariable:!helpers!public! !
toggleAutoCompletion!commands-actions!public! !
toggleStyling!commands-actions!public! !
unambiguousCompletionForBinding:!autocompletion!private! !
updateErrorStatus!operations!public! !
validateUserInterface!operations!public! !
variableForIdentifierStyle:range:!helpers!private! !
variableMetadataProvider:!accessing!public! !
visibleIdentifiersAt:startingWith:atMost:!autocompletion!helpers!private! !
workspacePool!accessing!public! !
workspacePool:!accessing!public! !
wrapLinesInRange:indent:!helpers!private! !
!

Tools.SmalltalkWorkspace methodProtocol: #textPresenter attributes: #(#readOnly) selectors: #(#clear #findDetails #findDetails: #hasFindDetails #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!
Tools.SmalltalkWorkspace methodProtocol: #variableMetadataProvider attributes: #(#readOnly) selectors: #(#classForVariable: #descriptionOfVariable: #iconForVariable: #tipForVariable:)!

!Tools.SmalltalkWorkspace class methodsFor!

actualFont
	"Answer the actual <Font> to use for instances of the receiver"

	^self defaultFont ifNil: [self model actualFont]!

annotationMode
	self ensureOptionsLoaded.
	^AnnotationMode!

annotationMode: aSymbol
	self annotationMode = aSymbol ifTrue: [^self].
	AnnotationMode := aSymbol.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view annotationMode: aSymbol].
	self persistOptions
!

applyOptions
	self primAllSubinstances do: [:each | each applyOptions]!

autoCompleteDwell
	"Answer the `Duration` that must elapse between characters being typed before the workspace will attempt to display an auto-completion list."

	self ensureOptionsLoaded.
	^AutoCompleteDwell!

autoCompleteDwell: aDuration
	self autoCompleteDwell = aDuration ifTrue: [^self].
	AutoCompleteDwell := aDuration.
	self persistOptions!

customEditorKeyBindings
	| bindings |
	bindings := self keyBindings asOrderedCollection.
	"We have to disable the default Scintilla key bindings for any of the chords we want to use for something else."
	self additionalKeyBindings do: 
			[:each |
			(ScintillaView.DefaultKeyBindings includesKey: each acceleratorKey)
				ifTrue: [bindings addLast: (KeyBinding newAcceleratorKey: each acceleratorKey message: SCI_NULL)]].
	^bindings!

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions to be bound to the receiver's commands. Each element of the collection should be a two element <Array>, the first element of which is the command symbol and the second the accelerator key string."

	"Note: The Ctrl+L and Ctrl+Shift+L shortcuts for cut and delete line respectively are no longer defined here because they are default Scintilla key bindings."

	^#(#(#toggleWordWrap 'CTRL+R'))!

defaultAutoCompleteDwell
	^30 milliseconds!

defaultBackcolor
	"Answer the default background to use for instances of the receiver"

	self ensureOptionsLoaded.
	^(Color named: #smalltalkWorkspace) basicActualColor!

defaultBackcolor: aColorOrNil
	"Set the default background to use for instances of the receiver"

	| current |
	current := Color named: #smalltalkWorkspace.
	current = aColorOrNil ifTrue: [^self].
	current actualColor: aColorOrNil ?? Color.Window.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view backcolorChanged].
	self persistOptions!

defaultCaretColor
	"Answer the default color to use for the caret in instances of the receiver"

	self ensureOptionsLoaded.
	^DefaultCaretColor!

defaultCaretColor: aColorOrNil 
	"Set the default caret color to use for instances of the receiver"

	DefaultCaretColor = aColorOrNil ifTrue: [^self].
	DefaultCaretColor := aColorOrNil.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each setCaretColor].
	self persistOptions!

defaultEditorKeyBindings
	"Answer any differences from standard Scintilla key bindings to apply by default in workspaces.
	Note that the defaultAdditionalAccelerators will also supplant any Scintilla commands normally associated with those key bindings."

	^##({KeyBinding newChord: 'CTRL+SHIFT+D' message: SCI_SELECTIONDUPLICATE})!

defaultFont
	"Answer the default  font to use for instances of the receiver"

	self ensureOptionsLoaded.
	^DefaultFont!

defaultFont: aFontOrNil 
	"Set the default <Font> to use for instances of the receiver"

	DefaultFont = aFontOrNil ifTrue: [^self].
	DefaultFont := aFontOrNil.
	self isLoadingOptions ifTrue: [^self].
	self allSubinstances do: [:each | each setFont].
	self persistOptions!

defaultIndicatorDefinitions
	"Answer the default indicators styles to be used in workspaces."

	^{
		IndicatorDefinition
			name: #Notification
			style: #hidden
			forecolor: Color commonGreen.
		IndicatorDefinition
			name: #Warning
			style: #squiggle
			forecolor: Color blue.
		IndicatorDefinition
			name: #Error
			style: #squiggle
			forecolor: Color red.
		(IndicatorDefinition
			name: #braceHighlight
			style: #straightBox
			forecolor: Color darkCyan)
			alpha: 40;
			foreAlpha: 65;
			yourself.
		(IndicatorDefinition
			name: #braceMismatch
			style: #straightBox
			forecolor: Color red)
			alpha: 55;
			foreAlpha: 128;
			yourself.
		(IndicatorDefinition new
			name: #secondarySelection
			style: #roundBox
			forecolor: Color black)
			alpha: 15;
			yourself
	} asOrderedCollection!

defaultKeywordCompletions
	"Private - Answer the default set of special keyword completion templates. These are to
	perform a more helpful insertion for commonly used keyword selectors where the arguments are
	of a known type, for example the control structures."

	^LookupTable withAll: {'at:ifAbsent:' -> 'at: ?key? ifAbsent: []'.
				'ifTrue:' -> 'ifTrue: [??]'.
				'ifFalse:' -> 'ifFalse: [??]'.
				'ifTrue:ifFalse:' -> 'ifTrue: [??] ifFalse: []'.
				'ifFalse:ifTrue:' -> 'ifFalse: [??] ifTrue: []'.
				'ifNil:' -> 'ifNil: [??]'.
				'ifNotNil:' -> 'ifNotNil: [:value | ?value?]'.
				'ifNil:ifNotNil:' -> 'ifNil: [??] ifNotNil: [:value | ]'.
				'ifNotNil:ifNil:' -> 'ifNotNil: [:value | ?value?] ifNil: []'.
				'whileTrue:' -> 'whileTrue: [??]'.
				'whileFalse:' -> 'whileFalse: [??]'.
				'do:' -> 'do: [:each | ?each?]'.
				'detect:' -> 'detect: [:each | ?each?]'.
				'detect:ifNone:' -> 'detect: [:each | ?each?] ifNone: []'.
				'collect:' -> 'collect: [:each | ?each?]'.
				'select:' -> 'select: [:each | ?each?]'.
				'reject:' -> 'reject: [:each | ?each?]'.
				'allSatisfy:' -> 'allSatisfy: [:each | ?true?]'.
				'anySatisfy:' -> 'anySatisfy: [:each | ?true?]'.
				'keysAndValuesDo:' -> 'keysAndValuesDo: [:eachKey :eachValue | ?eachKey?]'.
				'millisecondsToRun:' -> 'millisecondsToRun: [??]'.
				'or:' -> 'or: [?condition?]'.
				'and:' -> 'and: [?condition?]'.
				'on:do:' -> 'on: ?Error? do: [:ex | ]'.
				'timesRepeat:' -> 'timesRepeat: [??]'}!

defaultSelectionColor
	"Answer the default selection colour to use for instances of the receiver"

	self ensureOptionsLoaded.
	^(Color named: #workspaceSelection) basicActualColor!

defaultSelectionColor: aColorOrNil
	"Set the default selection colour to use for instances of the receiver"

	| actualColor themeColor |
	actualColor := aColorOrNil ifNil: [Color highlight alpha: 60].
	themeColor := Color named: #workspaceSelection.
	themeColor actualColor = actualColor ifTrue: [^self].
	themeColor actualColor: actualColor.
	self isLoadingOptions ifTrue: [^self].
	self allSubinstances do: [:each | each view setElementColor: SC_ELEMENT_SELECTION_BACK].
	self persistOptions!

defaultTabWidth
	self ensureOptionsLoaded.
	^DefaultTabWidth!

defaultTabWidth: anInteger 
	self defaultTabWidth = anInteger ifTrue: [^self].
	DefaultTabWidth := anInteger.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each setTabWidth].
	self persistOptions!

defaultTextStyle
	| style |
	style := TextStyle new.
	self defaultBackcolor ifNotNil: [:color | style backcolor: color].
	^style
		font: self actualFont;
		yourself!

defaultTextStyles
	"Answer the default text styles to be used for colouring text in workspaces. To configure the styles to taste modify through Dolphin Options.
	Braces and mismatch braces are styled using indicators now (see defaultIndicatorStyles)"

	"
	TextStyles := nil.
	(UI.Scintilla.TextStylesDialog createOn: self textStyles) defaultStyle: self defaultTextStyle; showModal
	"

	| answer |
	answer := {(TextStyle name: #argDecl)
					description: 'Argument declaration in method signature';
					isItalic: true;
					isBold: true;
					yourself.
				(TextStyle name: #assignment)
					description: 'Assignment operation, i.e. :=';
					isItalic: true;
					yourself.
				(TextStyle name: #binaryMessage)
					description: 'Binary in-fix messages such as + and -';
					forecolor: Color blue;
					yourself.
				(TextStyle name: #binarySelector)
					description: 'Binary in-fix selectors such as + and - (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself.
				(TextStyle name: #blockArgDecl)
					description: 'Block argument declaration';
					isItalic: true;
					yourself.
				(TextStyle name: #comment)
					description: 'Comments in method source';
					forecolor: Color commonGreen;
					isItalic: true;
					yourself.
				(TextStyle name: #identifier)
					description: 'Variables references (instance, temporary and class)';
					yourself.
				(TextStyle name: #illegal)
					description: 'Illegal characters, e.g. £';
					forecolor: Color red;
					isBold: true;
					yourself.
				(TextStyle name: #indentGuide)
					description: 'Indentation guides, when visible';
					forecolor: Color gray;
					yourself.
				(TextStyle name: #keywordMessage)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					yourself.
				(TextStyle name: #keywordSelector)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					isBold: true;
					yourself.
				(TextStyle name: #literalArray)
					description: 'Opening/closing token of literal array, i.e. #()';
					weight: SC_WEIGHT_SEMIBOLD;
					yourself.
				(TextStyle name: #literalBindingReference)
					description: 'Literal binding references, e.g. #{Object}';
					isItalic: true;
					yourself.
				(TextStyle name: #literalBytes)
					description: 'Literal byte arrays, e.g. #[0 1 2]';
					forecolor: Color olive;
					yourself.
				(TextStyle name: #literalCharacter)
					description: 'Literal character constants, e.g. $A';
					forecolor: Color navy;
					yourself.
				(TextStyle name: #literalNumber)
					description: 'Numeric literal constants, e.g. 1.2e6';
					forecolor: Color maroon;
					yourself.
				(TextStyle name: #literalPseudo)
					description: 'The literal constants true, false and nil';
					forecolor: Color teal;
					yourself.
				(TextStyle name: #literalString)
					description: 'Literal string constants, e.g. ''abc''';
					forecolor: Color purple;
					yourself.
				(TextStyle name: #literalSymbol)
					description: 'Literal symbol constants, e.g. #abc';
					forecolor: Color navy;
					yourself.
				TextStyle normal.
				(TextStyle name: #specialCharacter)
					description: 'Special characters, e.g. normal and block parentheses';
					yourself.
				(TextStyle name: #tag)
					description: 'Primitive or external call tag, e.g. <primitive: 1>';
					forecolor: Color gray;
					isItalic: true;
					yourself.
				(TextStyle name: #tempCloseBar)
					description: 'Temporary declarations closing bar';
					isItalic: true;
					yourself.
				(TextStyle name: #tempDecl)
					description: 'Temporary variable declaration';
					isItalic: true;
					yourself.
				(TextStyle name: #tempOpenBar)
					description: 'Temporary declarations opening bar';
					isItalic: true;
					yourself.
				(TextStyle name: #unaryMessage)
					description: 'Unary (no argument) messages';
					forecolor: Color blue;
					yourself.
				(TextStyle name: #unarySelector)
					description: 'Unary selectors (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself.
				(TextStyle name: #whitespace)
					description: 'Whitespace, when visible';
					forecolor: Color silver;
					yourself}.
	self assert: [answer size < 32].
	^answer!

defaultUnaryReturnTypes
	"Private - Answer the default set of standard messages with known return types. These allow for more
	targeted completion lists after common unary message sends."

	| answer |
	answer := LookupTable new.
	#(#isNil #isEmpty #notNil #asBoolean #not #isBehavior #isNumber #isInteger #isString)
		do: [:each | answer at: each put: Boolean].
	#(#size #basicSize #hash #identityHash #asInteger #yourAddress)
		do: [:each | answer at: each put: Integer].
	#(#printString #displayString #asString) do: [:each | answer at: each put: String].
	^answer
		at: #asArray put: Array;
		at: #asOrderedCollection put: OrderedCollection;
		at: #asQualifiedReference put: BindingReference;
		at: #asSet put: Set;
		at: #asSortedArray put: Array;
		at: #asSortedCollection put: SortedCollection;
		at: #asSymbol put: Symbol;
		at: #asUtf8String put: Utf8String;
		at: #readStream put: ReadStream;
		at: #writeStream put: WriteStream;
		shrink;
		yourself!

editorKeyBindings
	"Answer the full set of editor key bindings. This only includes the Scintilla commands and is constructed from the default Scintilla key bindings and any workspace overrides."

	^(ScintillaView mergeKeyBindings: self keyBindings)
		asSortedCollection: [:a :b | a commandSymbol <= b commandSymbol]!

editorKeyBindings: aCollectionOfScintillaKeyBindings
	KeyBindings := aCollectionOfScintillaKeyBindings
				ifNotNil: [ScintillaView unmergeKeyBindings: aCollectionOfScintillaKeyBindings]!

ensureOptionsLoaded
	OptionFlags ifNil: [self loadOptions]!

finishedLoadingOptions
	OptionFlags := OptionFlags bitAnd: ##(LoadingOptionsMask bitInvert)!

fontQuality
	self ensureOptionsLoaded.
	^FontQuality ?? #lcdOptimized!

fontQuality: aSymbol
	| quality |
	self fontQuality = aSymbol ifTrue: [^self].
	FontQuality := aSymbol.
	self isLoadingOptions ifTrue: [^self].
	quality := self fontQuality.
	self primAllSubinstances do: [:each | each view fontQuality: quality].
	self persistOptions!

getAdditionalKeyBindings
	^additionalKeyBindings ifNil: [self setAdditionalAccelerators: self additionalAccelerators]!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

indicatorDefinitions
	self ensureOptionsLoaded.
	^IndicatorDefinitions!

indicatorDefinitions: aCollectionOfScintillaIndicatorDefinitions
	"Set the Scintilla indicator definitions for the receiver's instances. These must have the names used in the styler, which by default is a <SmalltalkStyler>."

	IndicatorDefinitions = aCollectionOfScintillaIndicatorDefinitions ifTrue: [^self].
	IndicatorDefinitions := aCollectionOfScintillaIndicatorDefinitions.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each indicatorDefinitions: IndicatorDefinitions].
	self persistOptions!

indicatorDefinitionsAspect
	^(Aspect sequenceableCollection: #indicatorDefinitions
		addEvaluationFrom: [{ IndicatorDefinition shortName , ' new' }])
		beImmutable;
		defaultValue: [self defaultIndicatorDefinitions];
		yourself!

initialize
	"Private - Initialize the receiver's class variables.
		SmalltalkWorkspace initialize
	"

	KeywordCompletions := self defaultKeywordCompletions.
	StandardUnaryReturnTypes := self defaultUnaryReturnTypes.
	ThemeColor addNamed: #smalltalkWorkspace color: Color window.
	self startLoadingOptions.
	self optionsAspects do: [:each | each writeInto: self value: each defaultValue value].
	self finishedLoadingOptions!

invalidateLocalOptions
	OptionFlags := nil!

invalidateOptions
	self withAllSubclassesDo: [:each | each invalidateLocalOptions]!

isAutoCompletionCaseInsensitive
	^self optionFlags allMask: AutoCompletionCaseInsensitiveMask!

isAutoCompletionCaseInsensitive: aBoolean
	(self setOptionFlag: AutoCompletionCaseInsensitiveMask value: aBoolean)
		ifTrue: [self primAllSubinstances do: [:each | each view isAutoCompletionCaseInsensitive: aBoolean]]!

isAutoCompletionEnabled
	"Answer whether method workspaces should pro-actively show auto-completion lists as the user
	types. If disabled then the auto-completion list can still be shown on demand by issuing the
	#autoComplete command (see Help/Key Bindings for shortcut)."

	^self optionFlags allMask: AutoCompletionEnabledMask!

isAutoCompletionEnabled: aBoolean 
	(self setOptionFlag: AutoCompletionEnabledMask value: aBoolean)
		ifTrue: [self primAllSubinstances do: [:each | each isAutoCompletionEnabled: aBoolean]]!

isAutoCompletionSpaceAdded
	"Answer whether auto-completion will insert a space after a completing a word if the
	following character (if any) is not already a separator. By default this is enabled."

	^self optionFlags allMask: AutoCompletionSpaceAddedMask!

isAutoCompletionSpaceAdded: aBoolean
	self setOptionFlag: AutoCompletionSpaceAddedMask value: aBoolean!

isAutoCompletionTruncating
	"Answer whether the token which is being autocompleted will have any text after the caret
	deleted when it is auto-completed. Depending on your preference you may or many not find
	this convenient. It can save time in deleting unwanted text, but it might also remove text
	you want to retain if you start entering a token without there being a space between it and
	the next token."

	^self optionFlags allMask: AutoCompletionTruncatingMask!

isAutoCompletionTruncating: aBoolean
	(self setOptionFlag: AutoCompletionTruncatingMask value: aBoolean)
		ifTrue: [self primAllSubinstances do: [:each | each view isAutoCompletionTruncating: aBoolean]]!

isLoadingOptions
	^OptionFlags allMask: LoadingOptionsMask!

keyBindings
	self ensureOptionsLoaded.
	^KeyBindings ifNil: [self defaultEditorKeyBindings]!

keyBindings: anArray
	KeyBindings := anArray!

loadOptions
	SmalltalkToolShell loadOptionsFor: ##(self)!

maxAutoCompletionListHeight
	"Answer the maximum height (in rows) of the auto-completion list window."

	self ensureOptionsLoaded.
	^MaxAutoCompletionListHeight!

maxAutoCompletionListHeight: anInteger 
	anInteger < 2 ifTrue: [self errorSubscriptBounds: anInteger].
	self maxAutoCompletionListHeight = anInteger ifTrue: [^self].
	MaxAutoCompletionListHeight := anInteger.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view maxCompletionListHeight: anInteger].
	self persistOptions!

maxAutoCompletionListSize
	"Answer the maximum number of items that will be shown in a pro-active auto-completion list.
	If there are more items than this, then the workspace will delay showing a completion list
	until some more prefix characters have been typed that further narrow the number of choices.
	If you like 'eager' auto-completion, then set this number to a few hundred, if you don't
	then a maximum of 50 might be about right."

	self ensureOptionsLoaded.
	^MaxAutoCompletionListSize!

maxAutoCompletionListSize: anInteger 
	anInteger < 2 ifTrue: [self errorSubscriptBounds: anInteger].
	self maxAutoCompletionListSize = anInteger ifTrue: [^self].
	MaxAutoCompletionListSize := anInteger.
	self persistOptions!

maxAutoCompletionListWidth
	"Answer the maximum width (in characters) of the auto-completion list window."

	self ensureOptionsLoaded.
	^MaxAutoCompletionListWidth!

maxAutoCompletionListWidth: anInteger
	anInteger < 2 ifTrue: [self errorSubscriptBounds: anInteger].
	self maxAutoCompletionListWidth = anInteger ifTrue: [^self].
	MaxAutoCompletionListWidth := anInteger.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view maxCompletionListWidth: anInteger].
	self persistOptions!

optionFlags
	self ensureOptionsLoaded.
	^OptionFlags!

optionsAspects
	"Answer the aspects that, for this class only, should be saved and restored as options. This should not include any options of subclasses."

	| aspects |
	aspects := ##(self) publishedAspects.
	#(#yourself #editorKeyBindings) do: [:each | aspects removeKey: each].
	aspects add: ((Aspect name: #keyBindings)
				defaultValue: [self defaultEditorKeyBindings];
				yourself).
	^aspects!

persistOptions
	^SmalltalkToolShell persistOptionsFor: ##(self)!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| aspects |
	aspects := super publishedAspects.
	#(#isAutoCompletionEnabled #useDirectWrite #wordWrap)
		do: [:each | aspects add: ((Aspect boolean: each)
						defaultValue: true;
						yourself)].
	#(#isAutoCompletionCaseInsensitive #isAutoCompletionTruncating)
		do: [:each | aspects add: (Aspect boolean: each)].
	aspects
		add: ((Aspect integer: #defaultTabWidth)
					defaultValue: 8;
					yourself);
		add: ((Aspect integer: #maxAutoCompletionListSize)
					defaultValue: 200;
					yourself);
		add: ((Aspect integer: #maxAutoCompletionListHeight)
					defaultValue: 10;
					yourself);
		add: ((Aspect integer: #maxAutoCompletionListWidth)
					defaultValue: 40;
					yourself);
		add: ((Aspect duration: #autoCompleteDwell)
					defaultValue: self defaultAutoCompleteDwell;
					yourself);
		add: ((Aspect color: #defaultSelectionColor)
					defaultValue: [Color highlight alpha: 60];
					yourself);
		add: ((Aspect color: #defaultBackcolor)
					defaultValue: Color window;
					yourself);
		add: (Aspect color: #defaultCaretColor);
		add: ((Aspect symbol: #annotationMode from: ScintillaView annotationModes)
					defaultValue: #hidden;
					yourself).
	"We default the wrap indent to #same (i.e. maintain current indent in wrapped lines) so that inline comments will wrap neatly."
	aspects add: ((Aspect symbol: #wrapIndentMode from: ScintillaView wrapIndentModes)
				defaultValue: #same;
				yourself).
	aspects
		add: (Aspect sequenceableCollection: #editorKeyBindings
					addEvaluationFrom: [{KeyBinding shortName , ' new'}]) beImmutable;
		add: ((Aspect dictionary: #acceleratorKeyBindings)
					beImmutable;
					defaultValue: [self defaultAcceleratorKeyBindings];
					yourself);
		add: self textStylesAspect;
		add: self indicatorDefinitionsAspect;
		add: ((Aspect symbol: #fontQuality from: ScintillaView fontQualities)
					defaultValue: #lcdOptimized;
					yourself);
		add: ((Aspect font: #defaultFont)
					defaultValue: [Font name: 'Segoe UI' pointSize: 10];
					yourself).
	^aspects!

publishedEventsOfInstances
	"Answer a Set of Symbols that describe the published events triggered
	by instances of the receiver."

	^super publishedEventsOfInstances
		add: #expressionEvaluated:;
		yourself.
!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1411453252 1 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 2886 4 #{UI.Menu} nil true 50 13 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 210 nil true 50 10 258 1 290 #undo 8 '&Undo' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditUndo.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 338 4097 258 1 290 #cutSelection 8 'Cu&t' 1 1 450 nil true 482 8 'EditCut.ico' 544 65541 nil nil nil 258 1 290 #copySelection 8 '&Copy' 1 1 450 nil true 482 8 'EditCopy.ico' 544 65541 nil nil nil 258 1 290 #pasteClipboard 8 '&Paste' 1 1 450 nil true 482 8 'EditPaste.ico' 544 65541 nil nil nil 258 1 290 #clearSelection 8 'De&lete' 1 1 450 nil true 482 8 'EditClear.ico' 544 65541 nil nil nil 338 4097 258 1 290 #reformatSource 8 'Re&format' 1 1 nil nil nil 338 4097 258 1 290 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 210 nil true 50 10 258 1 290 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 258 1 290 #cloneNew 8 'Clo&ne' 1 1 450 nil true 482 8 'SmalltalkWorkspace.ico' 544 65541 nil nil nil 338 4097 258 1 290 #toggleAutoCompletion 8 'Auto-complete' 1 1 nil nil nil 258 1 290 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 258 1 290 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 258 1 290 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 258 1 290 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 258 1 290 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 258 1 290 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 338 4097 258 1 290 #browseIt 8 'Bro&wse It' 1 1 450 nil true 482 8 'ClassBrowserShell.ico' 544 65541 nil nil nil 258 1 290 #displayIt 8 '&Display It' 1 1 450 nil true 482 8 'DisplayIt.ico' 544 65541 nil nil nil 258 1 290 #printIt 8 '&Print It' 1 1 450 nil true 482 8 'PrintIt.ico' 544 65541 nil nil nil 258 1 290 #evaluateIt 8 'E&valuate It' 1 1 450 nil true 482 8 'EvaluateIt.ico' 544 65541 nil nil nil 258 1 290 #inspectIt 8 '&Inspect It' 1 1 450 nil true 482 8 'InspectIt.ico' 544 65541 nil nil nil 258 1 290 #debugIt 8 'Deb&ug It' 1 1 450 nil true 482 8 'DebugIt.ico' 544 65541 nil nil nil 338 4097 210 nil true 50 2 258 2097153 290 #browseDefinitions 8 'Defi&nitions of <d:…>' 1 17 nil nil nil 258 1 290 #browseReferences 8 '&References to <d:…>' 1 17 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #explicit nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 6 #{Graphics.Color} #gray 2578 #white 1 nil nil nil nil #callTip nil nil nil #normal 2546 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 2514 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 32 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 2786 2 23 178 #workspaceSelection 81 2578 #windowText nil 50 1 1030 #{UI.Scintilla.CharacterRepresentation} 8 $\x2028 nil 33 2848 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 2514 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 2514 1 #container 2528 nil nil nil nil #{Core.Utf8String} nil 2514 0 nil nil 2514 3 #Error 2546 1031 2578 #firebrick 2578 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2546 1029 nil 2578 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2546 1027 2578 #darkGoldenrod 2578 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 8 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 3298 461 311 32 3250 #sciSetMouseDwellTime: 8 #(500) 32 3250 #wordWrap: 8 #(true) 32 3250 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 32 nil 3 nil nil nil nil 3458 3 32 nil nil nil 67108863 nil nil 3458 5 32 nil nil nil nil nil nil 32 3250 #tabWidth: 8 #(4) 32 3250 #maxCompletionListHeight: 8 #(9) 32 3250 #hasAdditionalSelectionTyping: 8 #(true) 32 3250 #sciSetSelectionLayer: 8 #(1) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 229 12 0 0 165 0 0 0] 8 #() 3298 193 193 nil 45)!

setAdditionalKeyBindings: anArray
	additionalKeyBindings = anArray ifTrue: [^self].
	additionalKeyBindings := anArray.
	self persistOptions!

setOptionFlag: anInteger value: aBoolean
	"Private - Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	(self optionFlags allMask: anInteger) == aBoolean ifTrue: [^false].
	OptionFlags := OptionFlags mask: anInteger set: aBoolean.
	^self persistOptions!

startLoadingOptions
	OptionFlags := OptionFlags ?? 0 bitOr: LoadingOptionsMask!

textStyles
	self ensureOptionsLoaded.
	^TextStyles!

textStyles: aCollectionOfScintillaTextStyles
	"Set the text styles used to colour text in the receiver's instances. These must have the names used in the styler, which by default is a <SmalltalkStyler>."

	| textStyles prevTextStyles |
	textStyles := aCollectionOfScintillaTextStyles asSortedArray: [:a :b | a name <= b name].
	prevTextStyles := TextStyles.
	TextStyles := textStyles.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances
		do: [:each | each textStyles == prevTextStyles ifTrue: [each textStyles: TextStyles]].
	self persistOptions!

textStylesAspect
	^(Aspect name: #textStyles
		presenterBlock: 
			[:p :m |
			(StylesCollectionPresenter createIn: p on: m)
				defaultStyle: self defaultTextStyle;
				yourself])
		type: SequenceableCollection;
		beImmutable;
		defaultValue: [self defaultTextStyles];
		yourself!

uninitialize
	"Private - The receiver is about to be uninstalled from the system. Clean up."

	ThemeColor removeNamed: #smalltalkWorkspace!

useDirectWrite
	"Answer whether to use DirectWrite for drawing text in the workspace. This offers improved quality, coloured emoji's, and hardware acceleration, but may not 
	work well in all circumstances, so it can be turned off."

	^self optionFlags allMask: UseDirectWriteMask!

useDirectWrite: aBoolean
	(self setOptionFlag: UseDirectWriteMask value: aBoolean)
		ifTrue: 
			[| tech |
			tech := self useDirectWrite ifTrue: [#directWrite] ifFalse: [#default].
			self primAllSubinstances do: [:each | each view drawingTechnology: tech]]!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^self optionFlags allMask: WordWrapMask!

wordWrap: aBoolean
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	(self setOptionFlag: WordWrapMask value: aBoolean)
		ifTrue: [self primAllSubinstances do: [:each | each setWordWrap]]!

wrapIndentMode
	self ensureOptionsLoaded.
	^WrapIndentMode!

wrapIndentMode: aSymbol 
	self wrapIndentMode = aSymbol ifTrue: [^self].
	WrapIndentMode := aSymbol.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each view wrapIndentMode: aSymbol].
	self persistOptions! !

!Tools.SmalltalkWorkspace class categoriesForMethods!
actualFont!accessing!options!public! !
annotationMode!accessing!options!public! !
annotationMode:!accessing!options!public! !
applyOptions!private! !
autoCompleteDwell!accessing!autocompletion!public! !
autoCompleteDwell:!accessing!autocompletion!public! !
customEditorKeyBindings!options!private! !
defaultAdditionalAccelerators!constants!options!private! !
defaultAutoCompleteDwell!autocompletion!constants!options!public! !
defaultBackcolor!accessing!options!public! !
defaultBackcolor:!accessing!options!public! !
defaultCaretColor!accessing!options!public! !
defaultCaretColor:!accessing!options!public! !
defaultEditorKeyBindings!constants!options!public! !
defaultFont!accessing!options!public! !
defaultFont:!accessing!options!public! !
defaultIndicatorDefinitions!constants!public! !
defaultKeywordCompletions!autocompletion!private! !
defaultSelectionColor!accessing!options!public! !
defaultSelectionColor:!accessing!options!public! !
defaultTabWidth!options!public! !
defaultTabWidth:!accessing!public! !
defaultTextStyle!constants!options!private! !
defaultTextStyles!constants!options!public! !
defaultUnaryReturnTypes!autocompletion!private! !
editorKeyBindings!accessing!public! !
editorKeyBindings:!accessing!public! !
ensureOptionsLoaded!public! !
finishedLoadingOptions!options!private! !
fontQuality!accessing!public! !
fontQuality:!accessing!public! !
getAdditionalKeyBindings!accessing!private! !
icon!constants!public! !
indicatorDefinitions!accessing!public! !
indicatorDefinitions:!accessing!public! !
indicatorDefinitionsAspect!options!private! !
initialize!initializing!public! !
invalidateLocalOptions!options!private! !
invalidateOptions!options!private! !
isAutoCompletionCaseInsensitive!autocompletion!options!public! !
isAutoCompletionCaseInsensitive:!autocompletion!options!public! !
isAutoCompletionEnabled!autocompletion!options!public! !
isAutoCompletionEnabled:!autocompletion!options!public! !
isAutoCompletionSpaceAdded!autocompletion!options!public! !
isAutoCompletionSpaceAdded:!autocompletion!options!public! !
isAutoCompletionTruncating!autocompletion!options!public! !
isAutoCompletionTruncating:!autocompletion!options!public! !
isLoadingOptions!options!private! !
keyBindings!options!private! !
keyBindings:!options!private! !
loadOptions!options!private! !
maxAutoCompletionListHeight!accessing!autocompletion!public! !
maxAutoCompletionListHeight:!accessing!autocompletion!public! !
maxAutoCompletionListSize!accessing!autocompletion!public! !
maxAutoCompletionListSize:!accessing!autocompletion!public! !
maxAutoCompletionListWidth!accessing!autocompletion!public! !
maxAutoCompletionListWidth:!accessing!autocompletion!public! !
optionFlags!options!private! !
optionsAspects!options!private! !
persistOptions!options!private! !
publishedAspects!options!public! !
publishedEventsOfInstances!events!public! !
resource_Default_view!public!resources-views! !
setAdditionalKeyBindings:!accessing!private! !
setOptionFlag:value:!options!private! !
startLoadingOptions!options!private! !
textStyles!accessing!public! !
textStyles:!accessing!public! !
textStylesAspect!options!private! !
uninitialize!class hierarchy-removing!private! !
useDirectWrite!options!public! !
useDirectWrite:!options!public! !
wordWrap!accessing!options!public! !
wordWrap:!accessing!options!public! !
wrapIndentMode!accessing!options!public! !
wrapIndentMode:!accessing!options!public! !
!

