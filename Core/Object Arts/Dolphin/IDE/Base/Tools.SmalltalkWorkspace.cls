"Filed out from Dolphin Smalltalk"!

UI.Presenter subclass: #'Tools.SmalltalkWorkspace'
	instanceVariableNames: 'evaluationContext errorModel findDetails workspacePool namespaces compilationErrors textStyles searchEnvironment modifiedModel flags indicatorStyles variableMetadataProvider'
	classVariableNames: 'Abbreviations AnnotationMode AutoCompleteDwell DefaultCaretColor DefaultFont DefaultTabWidth FontQuality IndicatorStyles KeyBindings KeywordCompletions MaxAutoCompletionListHeight MaxAutoCompletionListSize MaxAutoCompletionListWidth OptionFlags StandardUnaryReturnTypes TextStyles WrapIndentMode'
	imports: #(#{Kernel.CompilerFlags} #{UI.Scintilla private} #{Refactory.Browser private})
	classInstanceVariableNames: 'additionalKeyBindings commandQueryHandlers'
	classConstants: {
		'AutoCompleteMask' -> 16r8.
		'AutoCompletionCaseInsensitiveMask' -> 16r80.
		'AutoCompletionEnabledMask' -> 16r10.
		'AutoCompletionSpaceAddedMask' -> 16r40.
		'AutoCompletionTruncatingMask' -> 16r20.
		'LoadingMask' -> 16r1.
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

allDefinedVariablesDo: aMonadicValuable 
	workspacePool bindingsDo: aMonadicValuable!

allPools
	"Private - Answers an Array of all the PoolDictionaries used during evaluations in the
	receiver. The workspacePool of locals must be the first element of the array"

	^(OrderedCollection with: self workspacePool) 
		addAll: self namespaces; 
		asArray!

applyOptions
	"Private - Apply the class options to the receiver"

	self
		setFont;
		setCaretColor;
		setWordWrap;
		setTabWidth.
	"textStyles are initialized to class setting by default, but parent presenter might have
	replaced them. N.B. If you blow up here, its because you are trying to use a non-Scintilla
	view with SmalltalkWorkspace. This is no longer supported."
	view textStyles: self textStyles.
	view indicatorStyles: self indicatorStyles.
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
	view fontQuality: self class fontQuality!

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
						start: (self tokenStartAt: posInteger - 1)].
			^self].
	aSymbol == #identifier
		ifTrue: 
			[self
				showIdentifierCompletionListAt: posInteger
				maxItems: maxInteger
				start: (self tokenStartAt: posInteger).
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
			[self showSelectorCompletionListAt: posInteger maxItems: maxInteger.
			^self].
	^nil!

basicFindNext
	"Hilight the next occurrence which satisfies the find operation held in findDetails."

	^self view basicFindNext!

basicInspectIt
	"Evaluate and basic inspect the currently selected text (or the current line if there is no
	selection)."

	(self evaluateItIfFail: [^self]) basicInspect!

browseDefinitions
	"Prompt for a selector and open a method browser displaying the implementors of that
	selector."

	self routeCommand: (CommandDescription command: self browseDefinitionsCommand
				description: 'Browse Definitions')!

browseDefinitionsCommand
	^Message selector: #browseMessageDefinitions:in:
		arguments: {self selectedWord. self searchEnvironment}!

browseIt
	"Evaluate currently selected text (or the current line if there is no selection) in the
	receiver and browse the result."

	<acceleratorKey: 'Ctrl+B'>
	(self evaluateItIfFail: [^self]) browse!

browseReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector."

	<acceleratorKey: 'Shift+F12'>
	self commandPolicy
		route: (CommandDescription command: self browseReferencesCommand description: 'Browse References')!

browseReferencesCommand
	^Message selector: #browseMessageReferences:in:
		arguments: {self selectedWord. self searchEnvironment}!

cancelAutoCompletion
	self view cancelAutoCompletion!

caretPosition: anInteger 
	self view caretPosition: anInteger!

chooseNamespaces
	"Display a ListPrompter to allow the user to choose the evaluation pools associated with the
	receiver"

	ChoicePrompter
		on: (self aspectValue: #namespaces)
		multipleChoices: (SmalltalkSystem current availableNamespaces
				asSortedArray: [:a :b | a fullName <= b fullName])
		caption: 'Available Namespaces'!

chunkFilerClass
	^ChunkSourceFiler!

classForIdentifier: aStIdentifierToken
	^(self resolveVariable: aStIdentifierToken)
		ifNotNil: [:variable | self suggestClassForVariable: variable]!

classForToken: anAssociation
	"Private - Answer the inferred class of the specified token, or nil if not known."

	| style tokenRange |
	anAssociation isNil ifTrue: [^nil].
	style := anAssociation value.
	(##(IdentityDictionary withAll: {#literalString -> String.
				#literalSymbol -> Symbol.
				#literalCharacter -> Character.
				#literalArray -> Array.
				#literalBytes -> ByteArray.
				#literalBindingReference -> BindingReference})
		lookup: style) ifNotNil: [:literalClass | ^literalClass].
	tokenRange := anAssociation key.
	style == #identifier
		ifTrue: 
			[^self classForIdentifier: (StIdentifierToken
						start: tokenRange start
						comments: nil
						value: (view plainTextRange: tokenRange))].
	style == #literalPseudo
		ifTrue: 
			[^##(LookupTable withAll: {'nil' -> nil class. 'false' -> false class. 'true' -> true class})
				lookup: (view plainTextRange: tokenRange)].
	style == #literalNumber
		ifTrue: [^(SmalltalkStylingScanner on: (view plainTextRange: tokenRange) readStream) next valueClass].
	style == #specialCharacter
		ifTrue: 
			[| ch |
			ch := view characterAt: tokenRange stop.
			ch == $] ifTrue: [^BlockClosure].
			ch == $} ifTrue: [^Array]].
	style == #unaryMessage
		ifTrue: 
			[| tokenText |
			tokenText := view plainTextRange: tokenRange.
			tokenText = 'class'
				ifTrue: 
					[| penultimate |
					penultimate := self tokenBefore: tokenRange start - 1.
					^(self classForToken: penultimate) ifNotNil: [:class | class basicClass]].
			(StandardUnaryReturnTypes lookup: tokenText) ifNotNil: [:class | ^class]].
	^nil!

classForVariable: aStVariable
	^aStVariable valueClass!

clear
	"Remove all contents in the receiver's view"

	self view clear.
	self newVariablePool!

clearErrors
	"Clear down the receiver's error model, if any, e.g. in preparation for a compilation"

	self clearStatus.
	compilationErrors := OrderedCollection new.
	self view indicators: #(); annotations: #()!

clearStatus
	self errorModel ifNotNil: [:errors | errors value: nil]!

cloneNew
	"Opens a SmalltalkWorkspace document which is effectively a clone of the receiver. It will
	contain the same contents and have the same evaluation context and workspace pools. Answers
	the clone"

	| clone |
	clone := SmalltalkSystem current newWorkspace.
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
	
	[| f pools |
	f := self defaultCompilerFlags.
	aBoolean ifTrue: [f := f | DebugMethod].
	pools := self allPools.
	result := compiler
				compileForEvaluation: source
				in: (context ifNotNil: [context basicClass])
				environment: self parseContext environment
				evaluationPools: pools
				flags: f]
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

	compilationErrors addLast: aCompilerNotification.
	self errorModel notNil 
		ifTrue: 
			[self showError: aCompilerNotification offset: anInteger.
			^aCompilerNotification isUserResumable 
				ifTrue: [aCompilerNotification resume]
				ifFalse: [aCompilerNotification return]].

	"Nothing set up so highlight the error/warning and display a message box"
	self selectionRange: aCompilerNotification range + anInteger.
	aCompilerNotification okToContinue!

completeWord
	"The user has requested that a completion list be displayed to complete the current 'word'.
	The list will be displayed unless the number of choices is far too large or there are none
	matching, in which case a warning beep will sound."

	<acceleratorKey: 'Ctrl+.'>
	| last styleName |
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	(self
		autoComplete: styleName
		at: last
		maxItems: self maxCompletionListSize)
			ifNil: 
				[self showCompletionListAfterToken: (self tokenBefore: last) maxItems: self maxCompletionListSize].
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

completionListSortBlock
	^self isAutoCompletionCaseInsensitive
		ifTrue: [[:a :b | (OS.Ucrt _stricmp: a displayString string2: b displayString) <= 0]]
		ifFalse: [[:a :b | (OS.Ucrt strcmp: a displayString string2: b displayString) <= 0]]!

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

defaultParseContext
	^##(ParseContext methodClass: ProtoObject environment: Smalltalk)!

defaultStylerClass
	^SmalltalkExpressionStyler!

developmentSystem
	^SmalltalkSystem current!

displayIt
	"Evaluate the currently selected text (or the current line if there is no selection). 
	Display the result at the current insert point (i.e. immediately after the selection)."

	<acceleratorKey: 'Ctrl+D'>
	self evaluateAndDisplay: [:obj | obj displayString: self developmentSystem displayItLocale]"Private - Answer the development system model."!

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
	| prev receiverStyle selector |
	selector := aString asSymbol.
	prev := self tokenBefore: anInteger - 1.
	prev isNil
		ifTrue: 
			[(self selfClass lookupMethod: selector)
				ifNotNil: [:method | ^self developmentSystem signatureOfMethod: method]]
		ifFalse: 
			[receiverStyle := prev value.
			receiverStyle == #identifier
				ifTrue: 
					[| range ident |
					range := prev key.
					ident := view plainTextRange: range.
					(self classForIdentifier: (StIdentifierToken
								start: range start
								comments: nil
								value: ident))
						ifNotNil: 
							[:methodClass |
							(methodClass lookupMethod: selector)
								ifNotNil: [:method | ^self developmentSystem signatureOfMethod: method]]]].
	"Perform a breadth-first traversal of the class hierarchy to find the highest definition of
	the selector and use the signature of that."
	Smalltalk allBehaviorsDo: 
			[:each |
			(each includesSelector: selector)
				ifTrue: [^self developmentSystem signatureOfMethod: (each compiledMethodAt: selector)]].
	"Should never get here - user shouldn't be offered choice of a selector that is not implemented."
	^self developmentSystem buildSimpleSignatureFor: selector!

hasErrors
	"Answer whether there are any errors in the source code (not warnings)"

	^compilationErrors anySatisfy: [:each | each severityClass == Error]!

hasSelection
	"Answers whether any text is selected in the receiver's view."
	
	^self view hasSelection!

hasSmalltalkStyler
	^self view styler isKindOf: SmalltalkStyler!

highlightCompilationErrors: anInteger
	| indicators annotations |
	indicators := OrderedCollection new.
	annotations := OrderedCollection new.
	compilationErrors do: 
			[:each |
			indicators add: (Indicator
						styleName: each severityClass name
						range: each range + anInteger
						tag: each).
			annotations add: (Annotation
						line: each line
						text: ('<1s>: <2s>' expandMacrosWith: each severityName with: each errorMessage)
						style: each severityClass name)].
	self view
		indicators: indicators;
		annotations: annotations!

identifierAt: anInteger
	| style |
	style := (view styleAt: anInteger) name.
	^(#(#identifier #tempDecl #argDecl #blockArgDecl) identityIncludes: style)
		ifTrue: 
			[| range |
			range := view tokenRangeAt: anInteger.
			StIdentifierToken
				start: range start
				comments: nil
				value: (view plainTextRange: range)]!

identifiersStartingWith: aString maxItems: anInteger
	"Private - Build and answer a colleciton of identifiers that are potential completions for
	the specified prefix. If in case-sensitive mode assume that the convention of starting all
	class/pool/global variables with an uppercase letter, and all temps and inst. vars with a
	lowercase one, is followed. If there are more matching identifiers than the specified
	maximum, then answer an empty collection."

	| variables ignoreCase filter accum selectVars |
	variables := Set new.
	ignoreCase := self isAutoCompletionCaseInsensitive.
	filter := aString isEmpty
				ifTrue: [[:each | true]]
				ifFalse: [[:each | each displayString beginsWith: aString ignoreCase: ignoreCase]].
	accum := 
			[:each |
			variables add: each.
			variables size > anInteger ifTrue: [^#()]].
	selectVars := [:each | (filter value: each) ifTrue: [accum value: each]].
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase not]])
		ifTrue: 
			[(#(nil true false) select: filter)
				do: [:each | accum value: (ListItem text: each printString icon: each icon)].
			(#('thisContext' 'super' 'self') select: filter) do: accum.
			self allDefinedVariablesDo: selectVars.
			self selfClass allInstanceVariableNames do: selectVars].
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase]])
		ifTrue: 
			[| class |
			class := self selfClass instanceClass.
			class withAllSuperclassesDo: 
					[:eachClass |
					eachClass bindingsDo: selectVars.
					eachClass importedNamespacesDo: [:eachNs | eachNs bindingsDo: selectVars]].
			namespaces do: [:eachPool | eachPool bindingsDo: selectVars].
			class environment ?? Smalltalk bindingsDo: selectVars].
	^variables!

indicatorStyles
	^indicatorStyles!

indicatorStyles: aCollectionOfScintillaIndicatorStyles
	"The indicator styles in a ScintillaView must be private to it, so ensure we have a copy."
	indicatorStyles := aCollectionOfScintillaIndicatorStyles collect: [:each | each copy].
	self isOpen ifTrue: [self view indicatorStyles: indicatorStyles]!

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
	self indicatorStyles: self class indicatorStyles.
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

killAutocompleteTimer
	self view killTimer: SCI_AUTOCSHOW!

maxCompletionListSize
	^10000!

maybeExtendingQualifiedNameAt: anInteger 
	^anInteger > 1 
		and: [(view characterAt: anInteger) == $. and: [(view styleAt: anInteger - 1) name == #identifier]]!

maybeShowCompletionList
	| styleName last |
	view isReadOnly ifTrue: [^self].
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	(self
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
							[self showCompletionListAfterToken: (self tokenBefore: last) maxItems: self class maxAutoCompletionListSize]]!

messagesForToken: anAssociation startingWith: aString maxItems: anInteger
	"Private - Answer the set of selectors that could potentially be sent as messages following
	the specified token."

	| selectors class ignoreCase icon |
	ignoreCase := self isAutoCompletionCaseInsensitive.
	icon := Message icon.
	class := self classForToken: anAssociation.
	"When completing against a variable that happens to have the value nil,
	treat it as possibly being of any type, as most likely it is simply uninitialized."
	(class == UndefinedObject and: [anAssociation value == #identifier]) ifTrue: [class := nil].
	selectors := Set new.
	(class ifNil: [SmalltalkSystem current]) allSelectors do: 
			[:each |
			(each beginsWith: aString ignoreCase: ignoreCase)
				ifTrue: 
					[selectors add: each.
					selectors size > anInteger ifTrue: [^#()]]].
	^selectors collect: [:each | ListItem text: each icon: icon]!

modifiedModel
	^modifiedModel!

modifiedModel: aValueModel
	modifiedModel := aValueModel!

nameBindingContext
	^self evaluationContext
		ifNil: [self defaultParseContext]
		ifNotNil: 
			[:context |
			| class |
			class := context basicClass.
			ParseContext methodClass: class environment: class environment]!

namespaces
	"Answers the evaluation pool for this workspace."

	^namespaces!

namespaces: aCollectionOfNamespaces
	"Sets the evaluation pools for this workspace to aCollectionOfNamespaces"

	namespaces := aCollectionOfNamespaces asArray!

newVariablePool
	workspacePool := PoolDictionary new!

onAutoComplete: aString startingAt: anInteger accept: aValueHolder
	"Private - "

	((view styleAt: anInteger) name ~~ #literalSymbol and: [aString includes: $:])
		ifTrue: [self insertKeywordCompletion: aString startingAt: anInteger]
		ifFalse: [self insertCompletion: aString at: anInteger].
	aValueHolder value: false.!

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
	indicators isEmpty
		ifFalse: 
			[self showTipForIndicators: indicators.
			^self].
	self areVariableTipsEnabled ifFalse: [^self].
	index := scintilla charCloseToPosition: aPoint.
	index <= 0 ifTrue: [^self].
	style := (view styleAt: index) name.
	range := view tokenRangeAt: index.

	"Can be useful to see a tip for Characters expressed in $\xNN[NN] form"
	style == #literalCharacter
		ifTrue: 
			[self showTipForCharacter: range.
			^self].
	(#(#identifier #tempDecl #argDecl #blockArgDecl) identityIncludes: style)
		ifTrue: 
			[self showTipForIdentifier: (StIdentifierToken
						start: range start
						comments: nil
						value: (view plainTextRange: range))]!

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

onTipTextRequired: tool
	"Private - Tool tip text is required for the <ToolbarItem>, tool."

	| cmd |
	cmd := tool command asSymbol.
	#clearSelection == cmd ifTrue: [^'Delete selected text'].
	^super onTipTextRequired: tool!

onViewOpened
	"Private - Received when the receiver's view is been connected. "

	super onViewOpened.
	self applyOptions.

!

parseContext
	^self evaluationContext
		ifNil: [ParseContext methodClass: UndefinedObject environment: Smalltalk]
		ifNotNil: 
			[:receiverObj |
			| class |
			class := receiverObj basicClass.
			ParseContext methodClass: class environment: class environment]!

plainText
	"Answer the receiver's unformatted source text as a String."

	^self view plainText!

plainTextRange: anInterval 
	^self view plainTextRange: anInterval!

printIt
	"Evaluate the currently selected text (or the current line if there is no selection). Print
	(i.e. show the printString of) the result at the current insert point (i.e. immediately
	after the selection)."

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

	| nameValue |
	nameValue := anObjectRef key asValue.
	
	[| name |
	name := Prompter
				on: nameValue
				prompt: 'Enter a variable name:'
				caption: ('Drop of <1s> onto workspace' expandMacrosWith: anObjectRef value basicPrintString).
	name isNil ifTrue: [^nil].
	(Scanner isVariable: name)
		ifTrue: [true]
		ifFalse: 
			[MessageBox new
				headline: '<1p> is not a valid variable name.' << name;
				errorMsg.
			false]]
			whileFalse: [].
	^nameValue value!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	^(super publishedAspects)
		add: self class textStylesAspect;
		add: self class indicatorStylesAspect;
		yourself!

queryCommand: aCommandQuery
	"Private - Enter details about a potential command for the receiver into the 
	<CommandQuery>."

	| selector |
	selector := aCommandQuery commandSymbol.
	#fileItIn == selector
		ifTrue: 
			[aCommandQuery isEnabled: self hasSelection.
			^true].
	#reformatSource == selector
		ifTrue: 
			[aCommandQuery isEnabled: self isEditable.
			^true].
	#reformatComment == selector
		ifTrue: 
			[aCommandQuery isEnabled: (self isEditable and: [self view styleUnderCaret name == #comment]).
			^true].
	(#(#chooseNamespaces #inspectWorkspacePool #cloneNew #clear #displayIt #printIt #completeWord)
		identityIncludes: selector)
			ifTrue: 
				[aCommandQuery isEnabled: self isReadOnly not.
				^true].
	#toggleAutoCompletion == selector
		ifTrue: 
			[(self isReadOnly not and: [self hasSmalltalkStyler and: [self isSyntaxColoringEnabled]])
				ifTrue: 
					[aCommandQuery
						isChecked: self isAutoCompletionEnabled;
						isEnabled: true]
				ifFalse: 
					[aCommandQuery
						isChecked: false;
						isEnabled: false].
			^true].
	#toggleStyling == selector
		ifTrue: 
			[self hasSmalltalkStyler
				ifTrue: 
					[aCommandQuery
						isEnabled: true;
						isChecked: self isSyntaxColoringEnabled]
				ifFalse: 
					[aCommandQuery
						isEnabled: false;
						isChecked: false].
			"Ensure the command is not handled by the view"
			aCommandQuery receiver: self.
			^true].
	^super queryCommand: aCommandQuery!

rangeToCompleteAt: anInteger 
	^(self isWhitespaceAt: anInteger) 
		ifTrue: [anInteger to: anInteger - 1]
		ifFalse: 
			[self isAutoCompletionTruncating 
				ifTrue: [self tokenRangeAt: anInteger]
				ifFalse: [anInteger to: view caretPosition - 1]]!

reformatComment
	"Rewrap the comment under the caret so that its lines start at the position of the 
	comment's opening quote, and are no longer than the current  of the workspace view."

	| range |
	range := view tokenRangeAt: view caretPosition.
	self wrapLinesInRange: range indent: (view columnFromPosition: range start)!

reformatSource
	"Reformat and syntax colour the selected range of source in the receiver as if it is an expression. 
	Attempts to maintain the base indentation of the first selected line."

	| source formatter reformatted expr tabs |
	source := self hasSelection ifTrue: [self selection] ifFalse: [self text].
	tabs := (source findFirst: [:each | each ~~ Character tab]) - 1.
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
	tabs <= 0
		ifTrue: [reformatted := formatter format: expr]
		ifFalse: 
			[formatter indent: tabs
				around: [reformatted := (source copyFrom: 1 to: tabs) , (formatter format: expr)]].
	^self hasSelection
		ifTrue: [self replaceSelection: reformatted]
		ifFalse: 
			[self text: reformatted.
			self view moveToEndOfDocument]!

replaceSelection: aString
	"Replace the current selected range of text with aString"
	
	^self view replaceSelection: aString!

resolveIdentifier: aString ifDefined: aMonadicValuable
	^(self resolveVariable: aString) ifNotNil: [:variable | aMonadicValuable value: variable]!

resolveVariable: aStIdentifierToken
	| nameContext classScope name |
	nameContext := self nameBindingContext.
	classScope := StClassScope methodClass: nameContext methodClass environment: nameContext environment.
	name := aStIdentifierToken value.
	name = 'self' ifTrue: [^classScope selfVariable].
	name = 'super' ifTrue: [^classScope superVariable].
	name = 'thisContext' ifTrue: [^classScope thisContextVariable].
	^(nameContext methodClass indexOfInstVar: name ifAbsent: nil)
		ifNotNil: 
			[:i |
			StInstanceVariable
				scope: classScope
				index: i
				name: name]
		ifNil: 
			[(nameContext methodClass fullBindingFor: name environment: nameContext environment)
				ifNotNil: [:var | StStaticVariable scope: classScope binding: var]
				ifNil: 
					["Workspace pool is lowest priority"
					(self workspacePool bindingFor: name)
						ifNotNil: 
							[:var |
							^StWorkspaceVariable scope: (StEvalScope pools: {self workspacePool} outer: nil) binding: var]]]!

searchEnvironment
	^searchEnvironment ifNil: [self systemModel browserEnvironment]!

searchEnvironment: aBrowserEnvironment 
	searchEnvironment := aBrowserEnvironment!

selectedWord
	"Private - Answers a selection that may be of interest given by the current state of the
	receiver. This is used by #browseImplementors, #browseSenders, etc, as a suitable starting
	point for the search"

	| selected |
	selected := self selection trimBlanks.
	^selected isEmpty ifTrue: [selected] ifFalse: [selected subStrings first]!

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
					selectors size > anInteger ifTrue: [^#()]]]
				ifFalse: 
					[| ignoreCase |
					ignoreCase := self isAutoCompletionCaseInsensitive.
					
					[:eachClass |
					eachClass selectors do: 
							[:eachSelector |
							(eachSelector beginsWith: aString ignoreCase: ignoreCase)
								ifTrue: 
									[selectors add: eachSelector.
									selectors size > anInteger ifTrue: [^#()]]]]]).
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

showCompletionListAfterToken: anAssociation maxItems: anInteger 
	| styleName |
	anAssociation isNil ifTrue: [^self].
	"Don't try and autocomplete after tokens inside arrays"
	(view isIndicator: view styler literalArrayIndicatorId setAt: anAssociation key stop) 
		ifTrue: [^self].
	styleName := anAssociation value.
	((#(#tempCloseBar #argDecl #unarySelector #assignment #binaryMessage #keywordMessage) 
		identityIncludes: styleName) or: [self isSpecialToken: anAssociation oneOf: '.[(^']) 
		ifTrue: 
			[self showCompletionList: (self identifiersStartingWith: '' maxItems: anInteger) prefixLength: 0.
			^self].
	((#(#identifier #unaryMessage #literalString #literalNumber #literalCharacter #literalPseudo #literalSymbol) 
		identityIncludes: styleName) or: [self isSpecialToken: anAssociation oneOf: '])}']) 
		ifTrue: 
			[self showCompletionList: (self 
						messagesForToken: anAssociation
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

showIdentifierCompletionListAt: posInteger maxItems: maxInteger start: start
	"Trim blanks in case requesting display of identifier list on whitespace"

	| prefix choices lastDot |
	prefix := (view plainTextFrom: start to: posInteger) trimBlanks.
	lastDot := prefix lastIndexOf: $..
	lastDot isZero
		ifTrue: [choices := self identifiersStartingWith: prefix maxItems: maxInteger]
		ifFalse: 
			[| qualifier pool nameContext |
			"Qualified name, find the binding"
			qualifier := prefix copyFrom: 1 to: lastDot - 1.
			prefix := prefix copyFrom: lastDot + 1 to: prefix size.
			choices := #().
			nameContext := self nameBindingContext.
			(nameContext methodClass fullBindingFor: qualifier environment: nameContext environment)
				ifNotNil: 
					[:var |
					pool := var value.
					pool isBehavior ifTrue: [pool := pool classPool].
					(pool isKindOf: Dictionary)
						ifTrue: 
							[choices := prefix isEmpty
										ifTrue: [pool associations]
										ifFalse: 
											[| ignoreCase |
											ignoreCase := self isAutoCompletionCaseInsensitive.
											pool associations select: [:each | each key beginsWith: prefix ignoreCase: ignoreCase]].
							choices size > maxInteger ifTrue: [choices := #()]]]].
	self showCompletionList: choices prefixLength: prefix size!

showMessageCompletionListAt: posInteger maxItems: maxInteger 
	| start prefix selectors |
	start := self tokenStartAt: posInteger.
	prefix := view plainTextFrom: start to: posInteger.
	selectors := self 
				messagesForToken: (self tokenBefore: start - 1)
				startingWith: prefix
				maxItems: maxInteger.
	self showCompletionList: selectors prefixLength: prefix size!

showResult: aString at: anInteger
	"Private - Show the result of an evaluation."

	self isOpen ifFalse: [^self].
	self caretPosition: anInteger.
	self replaceSelection: aString.
	self selectionRange: (anInteger to: anInteger + aString size - 1)!

showSelectorCompletionListAt: posInteger maxItems: maxInteger
	| prefix start choices |
	start := self tokenStartAt: posInteger.
	prefix := view plainTextFrom: start to: posInteger.
	choices := self selectorsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size!

showSymbolCompletionListAt: posInteger maxItems: maxInteger
	| prefix start symbols quoted prefixLength |
	start := self tokenStartAt: posInteger.
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

showTipForCharacter: anInterval
	| representation ch tokenText tip |
	tokenText := view plainTextRange: anInterval.
	ch := (Scanner on: tokenText readStream) next value.
	tip := (ch isGraph
				ifTrue: 
					[representation := ch asUtf8String.
					representation = (tokenText copyFrom: 2)]
				ifFalse: 
					[representation := ch printString.
					representation = tokenText])
					ifTrue: ['Codepoint: ' , ch codePointString]
					ifFalse: ['Character: ' , representation].
	self view showCallTip: tip at: anInterval stop!

showTipForIdentifier: aStIdentifierToken
	(self resolveVariable: aStIdentifierToken)
		ifNotNil: 
			[:variable |
			| tip identifier |
			identifier := aStIdentifierToken value.
			tip := [variableMetadataProvider tipForVariable: variable] on: Error
						do: 
							[:ex |
							String writeStream
								nextPutAll: ([variable infoTip] on: Error do: [:ex2 | identifier]);
								nextPutAll: ': <';
								print: ex;
								nextPut: $>;
								contents].
			"Don't display the tip if it contains no useful information"
			tip = identifier ifFalse: [self view showCallTip: tip at: aStIdentifierToken stop]]!

showTipForIndicators: aCollectionOfScintillaIndicators
	| tip last |
	tip := String writeStream.
	last := 0.
	aCollectionOfScintillaIndicators do: 
			[:each |
			tip nextPutAll: each tag displayString.
			last := last max: each range stop + 2]
		separatedBy: [tip nextPut: $\n].
	self view showCallTip: tip contents at: last!

startAutocompleteTimer
	self view setTimer: SCI_AUTOCSHOW interval: self class autoCompleteDwell!

stylerClass: aScintillaStylerClass
	self view stylerClass: aScintillaStylerClass!

suggestClassForVariable: aStVariable
	^variableMetadataProvider classForVariable: aStVariable!

symbolsStartingWith: aString maxItems: anInteger
	| stream ignoreCase |
	stream := Array writeStream: (anInteger bitShift: -1).
	ignoreCase := self isAutoCompletionCaseInsensitive.
	Symbol allInstancesDo: 
			[:each |
			(each beginsWith: aString ignoreCase: ignoreCase)
				ifTrue: 
					[stream nextPut: each.
					stream size > anInteger ifTrue: [^#()]]].
	^stream contents!

systemModel
	^self parentPresenter systemModel!

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
	^self isAutoCompletionEnabled: self isAutoCompletionEnabled not!

toggleStyling
	^self view toggleStyling!

tokenBefore: anInteger 
	^view styler tokenBefore: anInteger!

tokenRangeAt: anInteger 
	^(view styleAt: anInteger) name == #specialCharacter 
		ifTrue: [anInteger to: anInteger]
		ifFalse: [view tokenRangeAt: anInteger]!

tokenStartAt: anInteger 
	^(view styleAt: anInteger) name == #specialCharacter 
		ifTrue: [anInteger]
		ifFalse: [view tokenStartAt: anInteger]!

updateErrorStatus
	self errorModel ifNotNil: [:errors | errors value: self firstError]!

validateUserInterface
	"Validates the user interface for the receiver. Usually performed at idle time when the UI
	has been flagged as being invalid"

	super validateUserInterface.
	self modifiedModel value: self isModified!

variableMetadataProvider: aVariableResolver
	variableMetadataProvider := aVariableResolver!

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
allDefinedVariablesDo:!autocompletion!enumerating!private! !
allPools!accessing!private! !
applyOptions!operations!options!private! !
areVariableTipsEnabled!public!testing! !
areVariableTipsEnabled:!public!testing! !
autoComplete:at:maxItems:!autocompletion!helpers!private! !
basicFindNext!commands!public! !
basicInspectIt!commands!public! !
browseDefinitions!commands!public! !
browseDefinitionsCommand!commands!private! !
browseIt!commands!public! !
browseReferences!commands!public! !
browseReferencesCommand!commands!private! !
cancelAutoCompletion!helpers!private! !
caretPosition:!accessing!caret!public! !
chooseNamespaces!commands!public! !
chunkFilerClass!constants!public! !
classForIdentifier:!autocompletion!helpers!private! !
classForToken:!autocompletion!helpers!private! !
classForVariable:!public! !
clear!operations!public! !
clearErrors!operations!public! !
clearStatus!operations!public! !
cloneNew!commands!public! !
compilationErrors!accessing!private! !
compileAll!commands!public! !
compileAllIfFail:!helpers!private! !
compileIt!commands!public! !
compileItIfFail:!helpers!private! !
compileRange:ifFail:!helpers!private! !
compileRange:ifFail:debug:!helpers!private! !
compilerNotification:offset:!helpers!private! !
completeWord!autocompletion!commands!public! !
completeWordAt:with:!autocompletion!helpers!private! !
completionListSortBlock!autocompletion!constants!private! !
completionStringFor:at:!autocompletion!helpers!private! !
copySelection!commands!public! !
createComponents!initializing!private! !
createSchematicWiring!initializing!private! !
debugIt!commands!public! !
debugItIfFail:!helpers!private! !
defaultCompilerFlags!constants!private! !
defaultParseContext!accessing!autocompletion!private! !
defaultStylerClass!constants!private! !
developmentSystem!constants!private! !
displayIt!commands!public! !
dragOver:!drag & drop!public! !
drop:!drag & drop!public! !
dropObjectRef:!helpers!private! !
errorModel!accessing!public! !
errorModel:!accessing!public! !
evaluateAndDisplay:!commands!public! !
evaluateIt!commands!public! !
evaluateItIfFail:!helpers!private! !
evaluateItIfFail:debug:!helpers!private! !
evaluateRange:ifFail:!helpers!private! !
evaluateRange:ifFail:debug:!helpers!private! !
evaluationContext!accessing!public! !
evaluationContext:!accessing!public! !
fileItIn!commands!public! !
findDetails!accessing!public! !
findDetails:!accessing!public! !
firstError!helpers!private! !
getCompletionSignatureFor:at:!autocompletion!helpers!private! !
hasErrors!public!testing! !
hasSelection!public!testing! !
hasSmalltalkStyler!commands!private! !
highlightCompilationErrors:!helpers!private! !
identifierAt:!helpers!private! !
identifiersStartingWith:maxItems:!autocompletion!helpers!private! !
indicatorStyles!accessing!public! !
indicatorStyles:!accessing!public! !
initialize!initializing!private! !
insertCompletion:at:!autocompletion!helpers!private! !
insertKeywordCompletion:startingAt:!autocompletion!helpers!private! !
inspectIt!commands!public! !
inspectWorkspacePool!commands!private! !
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
killAutocompleteTimer!autocompletion!private! !
maxCompletionListSize!autocompletion!constants!private! !
maybeExtendingQualifiedNameAt:!autocompletion!helpers!private! !
maybeShowCompletionList!autocompletion!helpers!private! !
messagesForToken:startingWith:maxItems:!autocompletion!helpers!private! !
modifiedModel!accessing!public! !
modifiedModel:!accessing!public! !
nameBindingContext!accessing!autocompletion!private! !
namespaces!accessing!public! !
namespaces:!accessing!public! !
newVariablePool!operations!private! !
onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
onCharAdded:!autocompletion!event handling!private! !
onHoverEnd:!event handling!private! !
onHoverStart:!event handling!private! !
onRightButtonReleased:!event handling!public! !
onTimerTick:!event handling!private! !
onTipTextRequired:!event handling!private! !
onViewOpened!event handling!private! !
parseContext!commands!public! !
plainText!accessing!public! !
plainTextRange:!accessing!public! !
printIt!public! !
prompt:toSaveChanges:!helpers!private! !
promptForVariableName:!helpers!private! !
publishedAspects!public! !
queryCommand:!commands!private! !
rangeToCompleteAt:!autocompletion!helpers!private! !
reformatComment!commands!public! !
reformatSource!commands!public! !
replaceSelection:!operations!public! !
resolveIdentifier:ifDefined:!autocompletion!helpers!private! !
resolveVariable:!autocompletion!helpers!private! !
searchEnvironment!commands!public! !
searchEnvironment:!accessing!public! !
selectedWord!helpers!private! !
selectEvaluationRange!helpers!private! !
selection!accessing!public! !
selectionRange!accessing!public! !
selectionRange:!accessing!public! !
selectLine:!operations!public! !
selectNext!commands!public! !
selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
selectPrev!commands!public! !
selfClass!accessing!autocompletion!private! !
setBackcolor!helpers!private! !
setCaretColor!helpers!private! !
setFont!helpers!private! !
setTabWidth!helpers!private! !
setWordWrap!helpers!private! !
showCompletionList:prefixLength:!autocompletion!helpers!private! !
showCompletionListAfterToken:maxItems:!autocompletion!helpers!private! !
showError:offset:!helpers!private! !
showFirstError:!operations!private! !
showIdentifierCompletionListAt:maxItems:start:!autocompletion!helpers!private! !
showMessageCompletionListAt:maxItems:!autocompletion!helpers!private! !
showResult:at:!helpers!private! !
showSelectorCompletionListAt:maxItems:!autocompletion!helpers!private! !
showSymbolCompletionListAt:maxItems:!autocompletion!helpers!private! !
showTipForCharacter:!event handling!private! !
showTipForIdentifier:!helpers!private! !
showTipForIndicators:!helpers!private! !
startAutocompleteTimer!autocompletion!helpers!private! !
stylerClass:!accessing!public! !
suggestClassForVariable:!autocompletion!helpers!public! !
symbolsStartingWith:maxItems:!autocompletion!helpers!private! !
systemModel!constants!private! !
text!accessing!public! !
text:!accessing!public! !
textLength!accessing!public! !
textStyles!accessing!public! !
textStyles:!accessing!public! !
tipForVariable:!public! !
toggleAutoCompletion!commands!public! !
toggleStyling!commands!public! !
tokenBefore:!accessing!autocompletion!private! !
tokenRangeAt:!accessing!autocompletion!private! !
tokenStartAt:!accessing!autocompletion!private! !
updateErrorStatus!operations!public! !
validateUserInterface!operations!public! !
variableMetadataProvider:!accessing!public! !
workspacePool!accessing!public! !
workspacePool:!accessing!public! !
wrapLinesInRange:indent:!helpers!private! !
!

Tools.SmalltalkWorkspace methodProtocol: #textPresenter attributes: #() selectors: #(#clear #findDetails #findDetails: #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!
Tools.SmalltalkWorkspace methodProtocol: #variableMetadataProvider attributes: #(#readOnly) selectors: #(#classForVariable: #tipForVariable:)!

!Tools.SmalltalkWorkspace class methodsFor!

actualFont
	"Answer the actual <Font> to use for instances of the receiver"

	^self defaultFont ifNil: [SmalltalkSystem current actualFont]!

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

defaultIndicatorStyles
	"Answer the default indicators styles to be used in workspaces."

	^OrderedCollection new
		add: (IndicatorStyle new
					forecolor: Color commonGreen;
					style: #hidden;
					name: #Notification;
					yourself);
		add: (IndicatorStyle new
					forecolor: Color blue;
					style: #squiggle;
					name: #Warning;
					yourself);
		add: (IndicatorStyle new
					forecolor: Color red;
					style: #squiggle;
					name: #Error;
					yourself);
		add: (IndicatorStyle new
					alpha: 40;
					foreAlpha: 65;
					forecolor: Color darkCyan;
					style: #straightBox;
					name: #braceHighlight;
					yourself);
		add: (IndicatorStyle new
					alpha: 55;
					foreAlpha: 128;
					forecolor: Color red;
					style: #straightBox;
					name: #braceMismatch;
					yourself);
		add: (IndicatorStyle new
					alpha: 15;
					style: #roundBox;
					name: #secondarySelection;
					yourself);
		yourself!

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
	OptionFlags := OptionFlags maskClear: LoadingMask!

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

getCommandQueryHandlers
	^commandQueryHandlers!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

indicatorStyles
	self ensureOptionsLoaded.
	^IndicatorStyles!

indicatorStyles: aCollectionOfScintillaIndicatorStyles 
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	IndicatorStyles = aCollectionOfScintillaIndicatorStyles ifTrue: [^self].
	IndicatorStyles := aCollectionOfScintillaIndicatorStyles.
	self isLoadingOptions ifTrue: [^self].
	self primAllSubinstances do: [:each | each indicatorStyles: IndicatorStyles].
	self persistOptions!

indicatorStylesAspect
	^(Aspect sequenceableCollection: #indicatorStyles
		addEvaluationFrom: [{IndicatorStyle shortName , ' new'}])
		beImmutable;
		defaultValue: [self defaultIndicatorStyles];
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
	^OptionFlags allMask: LoadingMask!

keyBindings
	self ensureOptionsLoaded.
	^KeyBindings ifNil: [self defaultEditorKeyBindings]!

keyBindings: anArray
	KeyBindings := anArray!

loadOptions
	SmalltalkToolShell loadOptionsFor: ##(self).
	self applyOptions!

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
		add: self indicatorStylesAspect;
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

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 34 52 nil nil 34 2 8 1411453252 1 416 918598 2 #{UI.ValueHolder} nil false 1769478 #{Kernel.EqualitySearchPolicy} nil 1245702 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 461638 4 #{UI.Menu} nil true 34 13 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 1179974 1 #{UI.DividerMenuItem} 4097 578 nil true 34 10 626 1 658 #undo 8 '&Undo' 1 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'EditUndo.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 706 4097 626 1 658 #cutSelection 8 'Cu&t' 1 1 818 nil true 850 8 'EditCut.ico' 912 65541 nil nil nil 626 1 658 #copySelection 8 '&Copy' 1 1 818 nil true 850 8 'EditCopy.ico' 912 65541 nil nil nil 626 1 658 #pasteClipboard 8 '&Paste' 1 1 818 nil true 850 8 'EditPaste.ico' 912 65541 nil nil nil 626 1 658 #clearSelection 8 'De&lete' 1 1 818 nil true 850 8 'EditClear.ico' 912 65541 nil nil nil 706 4097 626 1 658 #reformatSource 8 'Re&format' 1 1 nil nil nil 706 4097 626 1 658 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 578 nil true 34 10 626 1 658 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 626 1 658 #cloneNew 8 'Clo&ne' 1 1 818 nil true 850 8 'SmalltalkWorkspace.ico' 912 65541 nil nil nil 706 4097 626 1 658 #toggleAutoCompletion 8 'Auto-complete' 1 1 nil nil nil 626 1 658 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 626 1 658 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 626 1 658 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 626 1 658 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 626 1 658 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 626 1 658 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 706 4097 626 1 658 #browseIt 8 'Bro&wse It' 1 1 818 nil true 850 8 'ClassBrowserShell.ico' 912 65541 nil nil nil 626 1 658 #displayIt 8 '&Display It' 1 1 818 nil true 850 8 'DisplayIt.ico' 912 65541 nil nil nil 626 1 658 #printIt 8 '&Print It' 1 1 818 nil true 850 8 'PrintIt.ico' 912 65541 nil nil nil 626 1 658 #evaluateIt 8 'E&valuate It' 1 1 818 nil true 850 8 'EvaluateIt.ico' 912 65541 nil nil nil 626 1 658 #inspectIt 8 '&Inspect It' 1 1 818 nil true 850 8 'InspectIt.ico' 912 65541 nil nil nil 626 1 658 #debugIt 8 'Deb&ug It' 1 1 818 nil true 850 8 'DebugIt.ico' 912 65541 nil nil nil 706 4097 578 nil true 34 2 626 2097153 658 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 626 1 658 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 1395533126 1049094 #{UI.NullConverter} nil nil 9 nil 170 192 34 4 #normal 1444934 1 #{UI.Scintilla.TextStyle} 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2930 77 917510 #{Graphics.Color} #gray 2978 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 #{Core.IdentitySet} 3072 nil 170 176 3072 nil nil nil 170 176 34 4 81 2978 #windowText 23 546 #workspaceSelection nil 34 1 2360326 #{UI.Scintilla.CharacterRepresentation} $\x2028 nil 33 3216 2162950 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 170 192 34 6 #literalArray 8 '()' #specialCharacter 8 '()[]<>' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 2896 nil nil nil nil 208 nil 170 192 3072 nil nil 170 192 34 6 #Notification 2930 1029 nil 2978 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2930 1027 2978 #darkGoldenrod 2978 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2930 1031 2978 #firebrick 2978 #floralWhite 1 nil nil nil nil #Error nil nil nil nil nil nil 1310982 #{Core.MessageSequence} 34 9 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 12287 21 3730 461 311 416 3682 #contextMenu: 34 1 592 416 3682 #sciSetMouseDwellTime: 8 #(500) 416 3682 #wordWrap: 8 #(true) 416 3682 #margins: 34 1 34 3 1247302 3 #{UI.Scintilla.Margin} 1 416 1 3 nil nil nil nil 3922 3 416 1 nil nil 67108863 nil nil 3922 5 416 1 nil nil nil nil nil 416 3682 #tabWidth: 8 #(4) 416 3682 #maxCompletionListHeight: 8 #(9) 416 3682 #hasAdditionalSelectionTyping: 8 #(true) 416 3682 #sciSetSelectionLayer: 8 #(1) 416 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 229 24 0 0 165 0 0 0] 8 #() 3730 193 193 nil 35)!

setAdditionalKeyBindings: anArray
	additionalKeyBindings = anArray ifTrue: [^self].
	additionalKeyBindings := anArray.
	self persistOptions!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray!

setOptionFlag: anInteger value: aBoolean
	"Private - Set the receiver to reuse an already open instance of the receiver instead of
	creating an additional one according to aBoolean."

	(self optionFlags allMask: anInteger) == aBoolean ifTrue: [^false].
	OptionFlags := OptionFlags mask: anInteger set: aBoolean.
	self persistOptions.
	^self isLoadingOptions not!

startLoadingOptions
	OptionFlags := OptionFlags ?? 0 bitOr: LoadingMask!

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
defaultIndicatorStyles!constants!public! !
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
getCommandQueryHandlers!accessing!private! !
icon!constants!public! !
indicatorStyles!accessing!public! !
indicatorStyles:!accessing!public! !
indicatorStylesAspect!options!private! !
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
setCommandQueryHandlers:!accessing!private! !
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

