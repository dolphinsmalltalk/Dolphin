"Filed out from Dolphin Smalltalk 7"!

UI.Presenter subclass: #'Tools.SmalltalkWorkspace'
	instanceVariableNames: 'evaluationContext errorModel findDetails workspacePool evaluationPools compilationErrors textStyles searchEnvironment modifiedModel flags indicatorStyles'
	classVariableNames: 'Abbreviations AnnotationMode AutoCompleteDwell DefaultCaretColor DefaultFont DefaultTabWidth FontQuality IndicatorStyles IsAutoCompletionCaseInsensitive IsAutoCompletionEnabled IsAutoCompletionSpaceAdded IsAutoCompletionTruncating KeyBindings KeywordCompletions MaxAutoCompletionListSize StandardUnaryReturnTypes TextStyles UseDirectWrite WordWrap WrapIndentMode'
	imports: #(#{Kernel.CompilerFlags} #{UI.Scintilla.ScintillaConstants})
	classInstanceVariableNames: 'additionalKeyBindings commandQueryHandlers'
	classConstants: {
		'AutoCompleteMask' -> 16r1.
		'VariableTipsMask' -> 16r2
	}!
Tools.SmalltalkWorkspace guid: (Core.GUID fromString: '{87b4c687-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.SmalltalkWorkspace comment: 'SmalltalkWorkspace is a <presenter> for displaying a workspace area within a <ScintillaView>. Note that, for efficiency purposes, a SmalltakWorkspace does not have a model. The textual data is held only within the associated view. since there seems little point in duplicating this text and holding it within the image as, say, a <readableString>.

In Dolphin 5.1 and earlier SmalltalkWorkspace could work with an <TextEdit> view, however as of Dolphin 6 it is specialised to support only <ScintillaView> as this allows it to take advantage of the advanced features of that control.

Instance Variables:
	evaluationContext		<Object> used as the "self" context for evaluations.
	errorModel				<valueModel> holding the first error notification from the last compilation.
	findDetails				<Array> specifying text search details.
	workspacePool			<PoolDictionary> holding local variables held by the workspace.
	evaluationPools			<Array> of <PoolDictionary>s for lookup pools during evaluations.
	compilationErrors		<OrderedCollection> of <CompilerNotification>s (not necessarily all errors)
	textStyles				<collection> of <ScintillaTextStyle>s use to colour text in the view.

Class Variables:
	DefaultBackcolor			<color> of the background to use.
	WordWrap				<boolean> indicating whether the workspace should word wrap text.
	DefaultFont				<Font> for source text
	AdditionalAccelerators	<Array> of 2-element <Array>s, being command <Symbol> accelerator key <String> pairs

'!
!Tools.SmalltalkWorkspace categoriesForClass!MVP-Presenters!MVP-Resources-IDE Tools! !
!Tools.SmalltalkWorkspace methodsFor!

allDefinedVariablesDo: aMonadicValuable 
	workspacePool bindingsDo: aMonadicValuable!

allPools
	"Private - Answers an Array of all the PoolDictionaries used during evaluations in the
	receiver. The workspacePool of locals must be the first element of the array"

	^(OrderedCollection with: self workspacePool) 
		addAll: self evaluationPools; 
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
	view wordChars: (Character byteCharacterSet
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]).
	self hasSmalltalkStyler ifFalse: [self isAutoCompletionEnabled: false].
	view isAutoCompletionCaseInsensitive: self class isAutoCompletionCaseInsensitive.
	"This has no effect, since we takeover insertion of the completed word, but it's a useful
	way to store the flag on a per-instance basis"
	view isAutoCompletionTruncating: self class isAutoCompletionTruncating.
	view maxCompletionListHeight: 10.
	view maxCompletionListWidth: 40.
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

	(self evaluateItIfFail: [^self]) browse!

browseReferences
	"Prompt for a selector and open a method browser displaying the references to that
	selector."

	self commandPolicy
		route: (CommandDescription command: self browseReferencesCommand description: 'Browse References')!

browseReferencesCommand
	^Message selector: #browseMessageReferences:in:
		arguments: {self selectedWord. self searchEnvironment}!

cancelAutoCompletion
	self view cancelAutoCompletion!

caretPosition: anInteger 
	self view caretPosition: anInteger!

chooseEvaluationPools
	"Display a ListPrompter to allow the user to choose the evaluation pools associated with the
	receiver"

	ChoicePrompter
		on: (self aspectValue: #evaluationPools)
		multipleChoices: Smalltalk developmentSystem availablePools asArray
		caption: 'Available pools'!

chunkFilerClass
	^ChunkSourceFiler!

classForIdentifier: aString
	aString = 'self' ifTrue: [^self selfClass].
	aString = 'super' ifTrue: [^self selfClass superclass].
	aString = 'thisContext' ifTrue: [^Integer].
	"In the debugger the workspacePool will also contain any temps and args, so we'll get
	sensible autocompletion on those too"
	^self resolveIdentifier: aString ifDefined: [:value | value basicClass]!

classForToken: anAssociation
	"Private - Answer the inferred class of the specified token, or nil if not known."

	| style text |
	anAssociation isNil ifTrue: [^nil].
	style := anAssociation value.
	text := view plainTextRange: anAssociation key.
	style == #identifier ifTrue: [^self classForIdentifier: text].
	style == #literalPseudo
		ifTrue: 
			[| lookup |
			lookup := ##(LookupTable new
						at: 'nil' put: nil class;
						at: 'false' put: false class;
						at: 'true' put: true class;
						shrink;
						yourself).
			^lookup lookup: text].
	style == #literalNumber ifTrue: [^(SmalltalkStylingScanner on: text readStream) next valueClass].
	style == #literalString ifTrue: [^String].
	style == #literalSymbol ifTrue: [^Symbol].
	style == #literalCharacter ifTrue: [^Character].
	style == #literalBindingReference ifTrue: [^BindingReference].
	style == #specialCharacter
		ifTrue: 
			[| ch |
			ch := text last.
			ch == $] ifTrue: [^BlockClosure].
			ch == $} ifTrue: [^Array]].
	style == #unaryMessage
		ifTrue: 
			[text = 'class'
				ifTrue: 
					[| penultimate |
					penultimate := self tokenBefore: anAssociation key start - 1.
					^(self classForToken: penultimate) ifNotNil: [:class | class basicClass]].
			(StandardUnaryReturnTypes lookup: text) ifNotNil: [:class | ^class]].
	^nil!

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
	clone := Smalltalk developmentSystem newWorkspace.
	clone workspace
		text: self text;
		workspacePool: self workspacePool;
		evaluationPools: self evaluationPools;
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
	then the the notification will be sent to that, and the offending range of source selected.
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
	addSpace := IsAutoCompletionSpaceAdded and: 
					[| nextChar |
					nextChar := view characterAt: replaceRange stop + 1.
					nextChar ~~ $\0 and: [nextChar isSeparator not]].
	view
		selectionRange: replaceRange;
		replaceSelection: (addSpace ifTrue: [aString , ' '] ifFalse: [aString]).
	^addSpace!

completionListSortBlock
	| crt |
	crt := OS.CRTLibrary default.
	"Note that we must use str[i]cmp to ensure the same comparison order as Scintilla uses when
	searching for items in the list."
	^self isAutoCompletionCaseInsensitive
		ifTrue: [[:a :b | (crt _stricmp: a displayString string2: b displayString) <= 0]]
		ifFalse: [[:a :b | (crt strcmp: a displayString string2: b displayString) <= 0]]!

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

displayIt
	"Evaluate the currently selected text (or the current line if there is no selection). 
	Display the result at the current insert point (i.e. immediately after the selection)."

	self evaluateAndDisplay: [:obj | obj displayString: self systemModel displayItLocale]!

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
	"Answer the receivers errorModel. Its value is the first notification from the last
	compilation. Note that this model may be shared by a number of presenters all contained
	within a single shell."

	^errorModel!

errorModel: aValueModel
	"Set the receivers errorModel."

	errorModel := aValueModel!

evaluateAndDisplay: aMonadicValuable
	| result evalRange |
	evalRange := self selectEvaluationRange.
	result := self evaluateRange: evalRange ifFail: [^self].
	self showResult: (aMonadicValuable value: result) at: evalRange stop + 1!

evaluateIt
	"Evaluate the currently selected text (or the current line if there is no selection) within
	the receiver's evaluation context"

	^self evaluateItIfFail: []!

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
	self systemModel sourceManager logEvaluate: expr getSource.

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
	^result!

evaluationContext
	"Answers the evaluation context for this workspace."

	^evaluationContext!

evaluationContext: anObject
	"Sets the evaluation context for this workspace. Normally this is nil but for example in
	inspector workspaces evaluations are performed in the context of the object being inspected.
	This allows access to class variables and such like"

	evaluationContext := anObject.!

evaluationPools
	"Answers the evaluation pool for this workspace."

	^evaluationPools!

evaluationPools: aCollectionOfPools
	"Sets the evaluation pools for this workspace to aCollectionOfPools"

	evaluationPools := aCollectionOfPools asArray!

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
	ordered := compilationErrors asSortedCollection: 
					[:a :b | 
					a severity > b severity or: [a severity = b severity and: [a position <= b position]]].
	^ordered isEmpty ifFalse: [ordered first]!

getCompletionSignatureFor: aString at: anInteger
	| prev receiverStyle selector |
	selector := aString asSymbol.
	prev := self tokenBefore: anInteger - 1.
	prev isNil
		ifTrue: 
			[(self selfClass lookupMethod: selector)
				ifNotNil: [:method | ^self systemModel signatureOfMethod: method]]
		ifFalse: 
			[receiverStyle := prev value.
			receiverStyle == #identifier
				ifTrue: 
					[| ident |
					ident := view plainTextRange: prev key.
					(self classForIdentifier: ident)
						ifNotNil: 
							[:methodClass |
							(methodClass lookupMethod: selector)
								ifNotNil: [:method | ^self systemModel signatureOfMethod: method]]]].
	"Perform a breadth-first traversal of the class hierarchy to find the highest definition of
	the selector and use the signature of that."
	Smalltalk allBehaviorsDo: 
			[:each |
			(each includesSelector: selector)
				ifTrue: [^self systemModel signatureOfMethod: (each compiledMethodAt: selector)]].
	"Should never get here - user shouldn't be offered choice of a selector that is not implemented."
	^self systemModel buildSimpleSignatureFor: selector!

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
			indicators add: (UI.Scintilla.Indicator
						styleName: each severityClass name
						range: each range + anInteger
						tag: each).
			annotations add: (UI.Scintilla.Annotation
						line: each line
						text: ('<1s>: <2s>' expandMacrosWith: each severityName with: each errorMessage)
						style: each severityClass name)].
	self view
		indicators: indicators;
		annotations: annotations!

identifierAt: anInteger
	| style |
	style := (view styleAt: anInteger) name.
	^(#(#identifier #tempDecl #argDecl) identityIncludes: style)
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
				do: [:each | accum value: (UI.Scintilla.ListItem text: each printString icon: each icon)].
			(#('thisContext' 'super' 'self') select: filter) do: accum.
			self allDefinedVariablesDo: selectVars.
			self selfClass allInstVarNames do: selectVars].
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase]])
		ifTrue: 
			[| class |
			class := self selfClass instanceClass.
			class withAllSuperclassesDo: 
					[:eachClass |
					eachClass bindingsDo: selectVars.
					eachClass importedNamespacesDo: [:eachNs | eachNs bindingsDo: selectVars]].
			evaluationPools do: [:eachPool | eachPool associationsDo: selectVars].
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
	self evaluationPools: {}.
	self newVariablePool.
	self clearStatus.
	compilationErrors := OrderedCollection new.
	self textStyles: self class textStyles.
	self indicatorStyles: self class indicatorStyles.
	self isAutoCompletionEnabled: self class isAutoCompletionEnabled!

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

maxAutoCompletionListSize
	^self class maxAutoCompletionListSize!

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
		maxItems: self maxAutoCompletionListSize)
			ifNil: 
				[| char |
				"If a space is typed after certain identifiers e.g. an instance
				 variable in the debugger, or when certain special characters are
				 typed, we can show a sensible auto-completion list."
				char := view characterAt: last.
				((char == $^ and: [styleName == #specialCharacter])
					or: [char == $\x20 and: [(view styleIdAt: last) = (view idOfStyleNamed: #whitespace)]])
						ifTrue: 
							[self showCompletionListAfterToken: (self tokenBefore: last) maxItems: self maxAutoCompletionListSize]]!

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
	(class ifNil: [Smalltalk developmentSystem]) allSelectors do: 
			[:each |
			(each beginsWith: aString ignoreCase: ignoreCase)
				ifTrue: 
					[selectors add: each.
					selectors size > anInteger ifTrue: [^#()]]].
	^selectors collect: [:each | UI.Scintilla.ListItem text: each icon: icon]!

modifiedModel
	^modifiedModel!

modifiedModel: aValueModel
	modifiedModel := aValueModel!

nameBindingContext
	^self evaluationContext ifNil: [Smalltalk] ifNotNil: [:context | context basicClass]!

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
	| indicators index scintilla |
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
	(self identifierAt: index) ifNotNil: [:identifier | self showTipForIdentifier: identifier]!

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
	^self evaluationContext basicClass!

plainText
	"Answer the receiver's unformatted source text as a String."

	^self view plainText!

plainTextRange: anInterval 
	^self view plainTextRange: anInterval!

printIt
	"Evaluate the currently selected text (or the current line if there is no selection). Print
	(i.e. show the printString of) the result at the current insert point (i.e. immediately
	after the selection)."

	self evaluateAndDisplay: [:obj | obj printString]!

prompt: aString toSaveChanges: aSelectionChangingEvent
	self isModified == true
		ifTrue: 
			[| response prompt mb |
			self ensureVisible.
			prompt := aSelectionChangingEvent canIntercept
						ifTrue: ['Do you wish to retain them']
						ifFalse: ['Would you like them copied to the clipboard'].
			mb := MessageBox new.
			mb owner: self view.
			"mb beTaskModal."
			response := mb
						confirm: ('There are unsaved <1s> changes.<n><n><2s>?' expandMacrosWith: aString with: prompt).
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
			[MessageBox errorMsg: ('<1p> is not a valid variable name.' expandMacrosWith: name).
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
	(#(#chooseEvaluationPools #inspectWorkspacePool #cloneNew #clear #displayIt #printIt #completeWord)
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
	expr := [Parser parseExpression: source in: self parseContext]
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
	(self workspacePool bindingFor: aString) ifNotNil: [:var | ^aMonadicValuable value: var value].
	^(self evaluationContext class indexOfInstVar: aString ifAbsent: [])
		ifNil: [(self nameBindingContext fullBindingFor: aString) ifNotNil: [:var | aMonadicValuable value: var value]]
		ifNotNil: [:i | aMonadicValuable value: (self evaluationContext instVarAt: i)]!

searchEnvironment
	^searchEnvironment ifNil: [self systemModel systemEnvironment]!

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

	| indicators pos |
	indicators := view indicators.
	indicators isEmpty
		ifTrue: 
			[Sound warningBeep.
			^self].
	pos := view caretPosition.
	self selectionRange: ((indicators detect: [:each | each range start > pos] ifNone: [])
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

	| indicators pos |
	indicators := view indicators.
	indicators isEmpty
		ifTrue: 
			[Sound warningBeep.
			^self].
	pos := self selectionRange start.
	self selectionRange: ((indicators reverse detect: [:each | each range start < pos] ifNone: [])
				ifNil: [pos = 1 ifTrue: [indicators last range] ifFalse: [1 to: 0]]
				ifNotNil: [:next | next range])!

selfClass
	^self parseContext!

setBackcolor
	view backcolor: self class defaultBackcolor!

setCaretColor
	self class defaultCaretColor ifNotNil: [:color | view caretForecolor: color]!

setFont
	view font: self class actualFont!

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
			[| qualifier pool |
			"Qualified name, find the binding"
			qualifier := prefix copyFrom: 1 to: lastDot - 1.
			prefix := prefix copyFrom: lastDot + 1 to: prefix size.
			choices := #().
			(self nameBindingContext fullBindingFor: qualifier)
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

showTipForIdentifier: anStIdentifierToken
	| name |
	name := anStIdentifierToken value.
	self resolveIdentifier: name
		ifDefined: 
			[:result |
			| tip |
			tip := [result debugPrintString] on: Error do: [:ex | name].
			"Don't display the tip if it contains no useful information"
			tip = name ifFalse: [self view showCallTip: tip at: anStIdentifierToken stop]]!

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
	"Private - Answer the development system model."

	^Smalltalk developmentSystem!

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
	textStyles := aCollectionOfScintillaTextStyles asOrderedCollection.
	self isOpen ifTrue: [self view textStyles: textStyles]!

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

workspacePool
	"Answer the PoolDictionary for locals used in evaluations within the receiver"

	^workspacePool!

workspacePool: aPoolDictionaryOrNil
	"Set the PoolDictionary for locals used in evaluations within the receiver"
	
	workspacePool := aPoolDictionaryOrNil!

wrapLinesInRange: anInterval indent: anInteger 
	| scintilla justified |
	scintilla := self view.
	scintilla targetRange: anInterval.
	justified := self systemModel 
				wrapText: scintilla targetText
				indent: anInteger
				tabWidth: scintilla tabWidth.
	scintilla replaceTarget: justified! !
!Tools.SmalltalkWorkspace categoriesFor: #allDefinedVariablesDo:!autocompletion!enumerating!private! !
!Tools.SmalltalkWorkspace categoriesFor: #allPools!accessing!private! !
!Tools.SmalltalkWorkspace categoriesFor: #applyOptions!operations!options!private! !
!Tools.SmalltalkWorkspace categoriesFor: #areVariableTipsEnabled!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #areVariableTipsEnabled:!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #autoComplete:at:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #basicFindNext!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #basicInspectIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #browseDefinitions!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #browseDefinitionsCommand!commands!private! !
!Tools.SmalltalkWorkspace categoriesFor: #browseIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #browseReferences!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #browseReferencesCommand!commands!private! !
!Tools.SmalltalkWorkspace categoriesFor: #cancelAutoCompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #caretPosition:!accessing!caret!public! !
!Tools.SmalltalkWorkspace categoriesFor: #chooseEvaluationPools!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #chunkFilerClass!constants!public! !
!Tools.SmalltalkWorkspace categoriesFor: #classForIdentifier:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #classForToken:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #clear!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #clearErrors!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #clearStatus!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #cloneNew!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #compilationErrors!accessing!private! !
!Tools.SmalltalkWorkspace categoriesFor: #compileAll!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #compileAllIfFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #compileIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #compileItIfFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #compileRange:ifFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #compileRange:ifFail:debug:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #compilerNotification:offset:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #completeWord!autocompletion!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #completeWordAt:with:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #completionListSortBlock!autocompletion!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #completionStringFor:at:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #copySelection!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #createComponents!initializing!private! !
!Tools.SmalltalkWorkspace categoriesFor: #createSchematicWiring!initializing!private! !
!Tools.SmalltalkWorkspace categoriesFor: #debugIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #debugItIfFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #defaultCompilerFlags!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #defaultStylerClass!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #displayIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #dragOver:!drag & drop!public! !
!Tools.SmalltalkWorkspace categoriesFor: #drop:!drag & drop!public! !
!Tools.SmalltalkWorkspace categoriesFor: #dropObjectRef:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #errorModel!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #errorModel:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateAndDisplay:!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateItIfFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateItIfFail:debug:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateRange:ifFail:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluateRange:ifFail:debug:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluationContext!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluationContext:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluationPools!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #evaluationPools:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #fileItIn!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #findDetails!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #findDetails:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #firstError!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #getCompletionSignatureFor:at:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #hasErrors!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #hasSelection!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #hasSmalltalkStyler!commands!private! !
!Tools.SmalltalkWorkspace categoriesFor: #highlightCompilationErrors:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #identifierAt:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #identifiersStartingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #indicatorStyles!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #indicatorStyles:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #initialize!initializing!private! !
!Tools.SmalltalkWorkspace categoriesFor: #insertCompletion:at:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #insertKeywordCompletion:startingAt:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #inspectIt!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #inspectWorkspacePool!commands!private! !
!Tools.SmalltalkWorkspace categoriesFor: #isAutoCompletionCaseInsensitive!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isAutoCompletionEnabled!autocompletion!private!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isAutoCompletionEnabled:!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #isAutoCompletionTruncating!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isEditable!private!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isModified!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isModified:!modes!public! !
!Tools.SmalltalkWorkspace categoriesFor: #isReadOnly!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isReadOnly:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #isSpecialToken:oneOf:!public!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isSyntaxColoringEnabled!private!testing! !
!Tools.SmalltalkWorkspace categoriesFor: #isWhitespaceAt:!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #killAutocompleteTimer!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #maxAutoCompletionListSize!autocompletion!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #maxCompletionListSize!autocompletion!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #maybeExtendingQualifiedNameAt:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #maybeShowCompletionList!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #messagesForToken:startingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #modifiedModel!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #modifiedModel:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #nameBindingContext!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #newVariablePool!operations!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onCharAdded:!autocompletion!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onHoverEnd:!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onHoverStart:!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onRightButtonReleased:!event handling!public! !
!Tools.SmalltalkWorkspace categoriesFor: #onTimerTick:!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onTipTextRequired:!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #onViewOpened!event handling!private! !
!Tools.SmalltalkWorkspace categoriesFor: #parseContext!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #plainText!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #plainTextRange:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #printIt!public! !
!Tools.SmalltalkWorkspace categoriesFor: #prompt:toSaveChanges:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #promptForVariableName:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #publishedAspects!public! !
!Tools.SmalltalkWorkspace categoriesFor: #queryCommand:!commands!private! !
!Tools.SmalltalkWorkspace categoriesFor: #rangeToCompleteAt:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #reformatComment!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #reformatSource!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #replaceSelection:!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #resolveIdentifier:ifDefined:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #searchEnvironment!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #searchEnvironment:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectedWord!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #selectEvaluationRange!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #selection!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectionRange!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectionRange:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectLine:!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectNext!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #selectPrev!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #selfClass!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #setBackcolor!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #setCaretColor!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #setFont!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #setTabWidth!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #setWordWrap!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showCompletionList:prefixLength:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showCompletionListAfterToken:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showError:offset:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showFirstError:!operations!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showIdentifierCompletionListAt:maxItems:start:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showMessageCompletionListAt:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showResult:at:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showSelectorCompletionListAt:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showSymbolCompletionListAt:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showTipForIdentifier:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #showTipForIndicators:!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #startAutocompleteTimer!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #stylerClass:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #symbolsStartingWith:maxItems:!autocompletion!helpers!private! !
!Tools.SmalltalkWorkspace categoriesFor: #systemModel!constants!private! !
!Tools.SmalltalkWorkspace categoriesFor: #text!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #text:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #textLength!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #textStyles!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #textStyles:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #toggleAutoCompletion!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #toggleStyling!commands!public! !
!Tools.SmalltalkWorkspace categoriesFor: #tokenBefore:!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #tokenRangeAt:!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #tokenStartAt:!accessing!autocompletion!private! !
!Tools.SmalltalkWorkspace categoriesFor: #updateErrorStatus!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #validateUserInterface!operations!public! !
!Tools.SmalltalkWorkspace categoriesFor: #workspacePool!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #workspacePool:!accessing!public! !
!Tools.SmalltalkWorkspace categoriesFor: #wrapLinesInRange:indent:!helpers!private! !

Tools.SmalltalkWorkspace methodProtocol: #textPresenter attributes: #() selectors: #(#clear #findDetails #findDetails: #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!

!Tools.SmalltalkWorkspace class methodsFor!

actualFont
	"Answer the actual <Font> to use for instances of the receiver"

	^self defaultFont ifNil: [Smalltalk developmentSystem actualFont]!

annotationMode
	^AnnotationMode!

annotationMode: anObject
	AnnotationMode := anObject!

autoCompleteDwell
	"Answer the <integer> number of milliseconds that must elapse between characters being typed
	before the workspace will attempt to display an auto-completion list."

	^AutoCompleteDwell!

autoCompleteDwell: anInteger 
	AutoCompleteDwell := anInteger!

customEditorKeyBindings
	| bindings |
	bindings := KeyBindings asOrderedCollection.
	self additionalKeyBindings do: 
			[:each |
			(UI.Scintilla.ScintillaView.DefaultKeyBindings includesKey: each acceleratorKey)
				ifTrue: [bindings add: (UI.Scintilla.KeyBinding newAcceleratorKey: each acceleratorKey message: SCI_NULL)]].
	^bindings!

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions to be bound to the
	receiver's commands. Each element of the collection should be a two element <Array>, the
	first element of which is the command symbol and the second the accelerator key string."

	"Note: The Ctrl+L and Ctrl+Shift+L shortcuts for cut and delete line respectively are no
	longer defined here because they are default Scintilla key bindings."

	^#(#(#evaluateIt 'Ctrl+E') #(#displayIt 'Ctrl+D') #(#printIt 'Ctrl+P') #(#inspectIt 'Ctrl+I') #(#toggleWordWrap 'Ctrl+R') #(#completeWord 'Ctrl+.') #(#selectNext 'F8') #(#selectPrev 'Shift+F8') #(#inspectIt 'Ctrl+Q'))!

defaultBackcolor
	"Answer the default background to use for instances of the receiver"

	^(Color named: #smalltalkWorkspace) actualColor!

defaultBackcolor: aColorOrNil
	"Set the default background to use for instances of the receiver"

	| current |
	current := Color named: #smalltalkWorkspace.
	current = aColorOrNil ifTrue: [^self].
	current actualColor: (aColorOrNil ifNil: [Color window]).
	self allSubinstances do: [:each | each view backcolorChanged]!

defaultCaretColor
	"Answer the default color to use for the caret in instances of the receiver"

	^DefaultCaretColor!

defaultCaretColor: aColorOrNil 
	"Set the default caret color to use for instances of the receiver"

	DefaultCaretColor = aColorOrNil ifTrue: [^self].
	DefaultCaretColor := aColorOrNil.
	self allSubinstances do: [:each | each setCaretColor]!

defaultEditorKeyBindings
	"Answer any differences from standard Scintilla key bindings to apply by default in workspaces.
	Note that the defaultAdditionalAccelerators will also supplant any Scintilla commands normally associated with those key bindings."

	^{UI.Scintilla.KeyBinding newChord: 'CTRL+SHIFT+D'
			message: UI.Scintilla.ScintillaConstants.SCI_SELECTIONDUPLICATE}!

defaultFont
	"Answer the default  font to use for instances of the receiver"

	^DefaultFont!

defaultFont: aFontOrNil 
	"Set the default <Font> to use for instances of the receiver"

	DefaultFont = aFontOrNil ifTrue: [^self].
	DefaultFont := aFontOrNil.
	self allSubinstances do: [:each | each setFont]!

defaultIndicatorStyles
	"Answer the default indicators styles to be used in workspaces."

	^OrderedCollection new
		add: (UI.Scintilla.IndicatorStyle new
					forecolor: Color commonGreen;
					style: #hidden;
					name: #Notification;
					yourself);
		add: (UI.Scintilla.IndicatorStyle new
					forecolor: Color blue;
					style: #squiggle;
					name: #Warning;
					yourself);
		add: (UI.Scintilla.IndicatorStyle new
					forecolor: Color red;
					style: #squiggle;
					name: #Error;
					yourself);
		add: (UI.Scintilla.IndicatorStyle new
					alpha: 40;
					foreAlpha: 65;
					forecolor: Color darkCyan;
					style: #straightBox;
					name: #braceHighlight;
					yourself);
		add: (UI.Scintilla.IndicatorStyle new
					alpha: 55;
					foreAlpha: 128;
					forecolor: Color red;
					style: #straightBox;
					name: #braceMismatch;
					yourself);
		add: (UI.Scintilla.IndicatorStyle new
					alpha: 15;
					style: #roundBox;
					name: #secondarySelection;
					yourself);
		yourself!

defaultKeywordCompletions
	"Private - Answer the default set of special keyword completion templates. These are to
	perform a more helpful insertion for commonly used keyword selectors where the arguments are
	of a known type, for example the control structures."

	^LookupTable new
		at: 'at:ifAbsent:' put: 'at: ?key? ifAbsent: []';
		at: 'ifTrue:' put: 'ifTrue: [??]';
		at: 'ifFalse:' put: 'ifFalse: [??]';
		at: 'ifTrue:ifFalse:' put: 'ifTrue: [??] ifFalse: []';
		at: 'ifFalse:ifTrue:' put: 'ifFalse: [??] ifTrue: []';
		at: 'ifNil:' put: 'ifNil: [??]';
		at: 'ifNotNil:' put: 'ifNotNil: [:value | ?value?]';
		at: 'ifNil:ifNotNil:' put: 'ifNil: [??] ifNotNil: [:value | ]';
		at: 'ifNotNil:ifNil:' put: 'ifNotNil: [:value | ?value?] ifNil: []';
		at: 'whileTrue:' put: 'whileTrue: [??]';
		at: 'whileFalse:' put: 'whileFalse: [??]';
		at: 'do:' put: 'do: [:each | ?each?]';
		at: 'detect:' put: 'detect: [:each | ?each?]';
		at: 'detect:ifNone:' put: 'detect: [:each | ?each?] ifNone: []';
		at: 'collect:' put: 'collect: [:each | ?each?]';
		at: 'select:' put: 'select: [:each | ?each?]';
		at: 'reject:' put: 'reject: [:each | ?each?]';
		at: 'allSatisfy:' put: 'allSatisfy: [:each | ?true?]';
		at: 'anySatisfy:' put: 'anySatisfy: [:each | ?true?]';
		at: 'keysAndValuesDo:' put: 'keysAndValuesDo: [:eachKey :eachValue | ?eachKey?]';
		at: 'millisecondsToRun:' put: 'millisecondsToRun: [??]';
		at: 'or:' put: 'or: [?condition?]';
		at: 'and:' put: 'and: [?condition?]';
		at: 'on:do:' put: 'on: ?Error? do: [:ex | ]';
		at: 'timesRepeat:' put: 'timesRepeat: [??]';
		shrink;
		yourself!

defaultTabWidth
	^DefaultTabWidth!

defaultTabWidth: anInteger 
	DefaultTabWidth = anInteger ifTrue: [^self].
	DefaultTabWidth := anInteger.
	self allSubinstances do: [:each | each setTabWidth]!

defaultTextStyle
	| style |
	style := UI.Scintilla.TextStyle new.
	self defaultBackcolor ifNotNil: [:color | style backcolor: color].
	^style
		font: self actualFont;
		yourself!

defaultTextStyles
	"Answer the default text styles to be used for colouring text in workspaces. To configure
	the styles to taste modify through Dolphin Options."

	"
	TextStyles := nil
	(ScintillaTextStylesDialog createOn: self textStyles) defaultStyle: self defaultTextStyle; showModal
	"

	| answer |
	answer := IdentityDictionary new.
	answer
		add: ((UI.Scintilla.TextStyle name: #illegal)
					description: 'Illegal characters, e.g. £';
					forecolor: Color red;
					isBold: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #comment)
					description: 'Comments in method source';
					forecolor: Color commonGreen;
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #identifier)
					description: 'Variables references (instance, temporary and class)';
					yourself);
		add: ((UI.Scintilla.TextStyle name: #argDecl)
					description: 'Argument declaration in method signature';
					isItalic: true;
					isBold: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #blockArgDecl)
					description: 'Block argument declaration';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #tempDecl)
					description: 'Temporary variable declaration';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #unarySelector)
					description: 'Unary selectors (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #unaryMessage)
					description: 'Unary (no argument) messages';
					forecolor: Color blue;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #binarySelector)
					description: 'Binary in-fix selectors such as + and - (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #binaryMessage)
					description: 'Binary in-fix messages such as + and -';
					forecolor: Color blue;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #keywordSelector)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #keywordMessage)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalPseudo)
					description: 'The literal constants true, false and nil';
					forecolor: Color teal;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalNumber)
					description: 'Numeric literal constants, e.g. 1.2e6';
					forecolor: Color maroon;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalString)
					description: 'Literal string constants, e.g. ''abc''';
					forecolor: Color purple;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalSymbol)
					description: 'Literal symbol constants, e.g. #abc';
					forecolor: Color navy;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalCharacter)
					description: 'Literal character constants, e.g. $A';
					forecolor: Color navy;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalBytes)
					description: 'Literal byte arrays, e.g. #[0 1 2]';
					forecolor: Color olive;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalBindingReference)
					description: 'Literal binding references, e.g. #{Object}';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #assignment)
					description: 'Assignment operation, i.e. :=';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #tempOpenBar)
					description: 'Temporary declarations opening bar';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #tempCloseBar)
					description: 'Temporary declarations closing bar';
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #specialCharacter)
					description: 'Special characters, e.g. normal and block parentheses';
					yourself);
		add: ((UI.Scintilla.TextStyle name: #literalArray)
					description: 'Opening/closing token of literal array, i.e. #()';
					weight: SC_WEIGHT_SEMIBOLD;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #tag)
					description: 'Primitive or external call tag, e.g. <primitive: 1>';
					forecolor: Color gray;
					isItalic: true;
					yourself);
		add: ((UI.Scintilla.TextStyle name: #whitespace)
					description: 'Whitespace, when visible';
					forecolor: Color silver;
					yourself);
		yourself.
	self assert: [answer size < 32].
	"Scintilla pre-defined styles - note how #normal style inherits font of the view (which in turn should be the default system font).
	braces and mismatch braces are styled using indicators now (see defaultIndicatorStyles)"
	answer
		add: UI.Scintilla.TextStyle normal yourself;
		add: ((UI.Scintilla.TextStyle name: #indentGuide)
					description: 'Indentation guides, when visible';
					forecolor: Color gray;
					yourself);
		yourself.
	^answer!

defaultUnaryReturnTypes
	"Private - Answer the default set of standard messages with known return types. These allow for more
	targetted completion lists after common unary message sends."

	| answer |
	answer := LookupTable new.
	#('isNil' 'isEmpty' 'notNil' 'asBoolean' 'not') do: [:each | answer at: each put: Boolean].
	#('size' 'basicSize' 'hash' 'asInteger' 'yourAddress') do: [:each | answer at: each put: Integer].
	#('printString' 'displayString' 'asString') do: [:each | answer at: each put: String].
	^answer
		shrink;
		yourself!

editorKeyBindings
	"Answer the full set of editor key bindings. This only includes the Scintilla commands and is constructed from the default Scintilla key bindings and any workspace overrides."

	^(UI.Scintilla.ScintillaView mergeKeyBindings: KeyBindings)
		asSortedCollection: [:a :b | a commandSymbol <= b commandSymbol]!

editorKeyBindings: aCollectionOfScintillaKeyBindings
	KeyBindings := aCollectionOfScintillaKeyBindings
				ifNil: [self defaultEditorKeyBindings]
				ifNotNil: [UI.Scintilla.ScintillaView unmergeKeyBindings: aCollectionOfScintillaKeyBindings]!

fontQuality
	^FontQuality ?? #lcdOptimized!

fontQuality: aSymbol
	| quality |
	FontQuality := aSymbol.
	quality := self fontQuality.
	self primAllSubinstances do: [:each | each view fontQuality: quality]!

getAdditionalKeyBindings
	^additionalKeyBindings ifNil: [self setAdditionalAccelerators: self defaultAdditionalAccelerators]!

getCommandQueryHandlers
	^commandQueryHandlers!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

indicatorStyles
	IndicatorStyles isNil ifTrue: [self indicatorStyles: self defaultIndicatorStyles].
	^IndicatorStyles!

indicatorStyles: aCollectionOfScintillaIndicatorStyles 
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	IndicatorStyles := aCollectionOfScintillaIndicatorStyles.
	self primAllSubinstances do: [:each | each indicatorStyles: self indicatorStyles]!

indicatorStylesAspect
	^(Aspect sequenceableCollection: #indicatorStyles
		addEvaluationFrom: {UI.Scintilla.IndicatorStyle name , ' new'})
		beImmutable;
		yourself!

initialize
	"Private - Initialize the receiver's class variables.
		SmalltalkWorkspace initialize
	"

	ThemeColor addNamed: #smalltalkWorkspace color: Color window.
	DefaultFont := Font name: 'Segoe UI' pointSize: 10.
	WordWrap := true.
	DefaultTabWidth := 8.
	AutoCompleteDwell := 30.
	KeywordCompletions := self defaultKeywordCompletions.
	StandardUnaryReturnTypes := self defaultUnaryReturnTypes.
	IsAutoCompletionCaseInsensitive := false.
	IsAutoCompletionEnabled := true.
	IsAutoCompletionTruncating := false.
	IsAutoCompletionSpaceAdded := true.
	MaxAutoCompletionListSize := 200.
	AnnotationMode := #hidden.
	"We set the wrap indent to same so that inline comments will wrap neatly."
	WrapIndentMode := #same.
	"Whether to configure Scintilla to use DirectWrite for drawing text - this offers better quality, colour fonts, h/w acceleration, but may not work on all platforms."
	UseDirectWrite := true.
	KeyBindings := self defaultEditorKeyBindings!

isAutoCompletionCaseInsensitive
	"Answer whether auto-completion ignores case. This has pros and cons: It is not necessary to
	type exactly the right case in order to incrementally search the auto-completion list;
	however the auto-completion lists may be longer, in some cases significantly so. For example
	when completing an identifier for which a lower-case first letter has been entered, if
	auto-completion is case-sensitive then this automatically excludes all class, pool, and
	global variables. In some cases this might cut thousands of potential entries from the list.
	By default auto-completion is case-sensitive because we feel it is more useful to have a
	shorter list even if it means one has to press the Shift key a bit more often."

	^IsAutoCompletionCaseInsensitive!

isAutoCompletionCaseInsensitive: aBoolean 
	IsAutoCompletionCaseInsensitive := aBoolean!

isAutoCompletionEnabled
	"Answer whether method workspaces should pro-actively show auto-completion lists as the user
	types. If disabled then the auto-completion list can still be shown on demand by issuing the
	#autoComplete command (see Help/Key Bindings for shortcut)."

	^IsAutoCompletionEnabled!

isAutoCompletionEnabled: aBoolean 
	IsAutoCompletionEnabled := aBoolean!

isAutoCompletionSpaceAdded
	"Answer whether auto-completion will insert a space after a completing a word if the
	following character (if any) is not already a separator. By default this is enabled."

	^IsAutoCompletionSpaceAdded!

isAutoCompletionSpaceAdded: aBoolean 
	IsAutoCompletionSpaceAdded := aBoolean!

isAutoCompletionTruncating
	"Answer whether the token which is being autocompleted will have any text after the caret
	deleted when it is auto-completed. Depending on your preference you may or many not find
	this convenient. It can save time in deleting unwanted text, but it might also remove text
	you want to retain if you start entering a token without there being a space between it and
	the next token."

	^IsAutoCompletionTruncating!

isAutoCompletionTruncating: aBoolean 
	IsAutoCompletionTruncating := aBoolean!

maxAutoCompletionListSize
	"Answer the maximum number of items that will be shown in a pro-active auto-completion list.
	If there are more items than this, then the workspace will delay showing a completion list
	until some more prefix characters have been typed that further narrow the number of choices.
	If you like 'eager' auto-completion, then set this number to a few hundred, if you don't
	then a maximum of 50 might be about right."

	^MaxAutoCompletionListSize!

maxAutoCompletionListSize: anInteger 
	anInteger < 2 ifTrue: [self errorSubscriptBounds: anInteger].
	MaxAutoCompletionListSize := anInteger!

publishedAspects
	"Answer a <LookupTable> of the <Aspect>s published by the receiver."

	| answer |
	answer := super publishedAspects.
	#(#isAutoCompletionEnabled #isAutoCompletionCaseInsensitive #isAutoCompletionTruncating #useDirectWrite)
		do: [:each | answer add: (Aspect boolean: each)].
	#(#defaultTabWidth #autoCompleteDwell #maxAutoCompletionListSize)
		do: [:each | answer add: (Aspect integer: each)].
	#(#defaultBackcolor #defaultCaretColor) do: [:each | answer add: (Aspect color: each)].
	^answer
		add: (Aspect choice: #annotationMode from: UI.Scintilla.ScintillaView annotationModes);
		add: (Aspect choice: #wrapIndentMode from: UI.Scintilla.ScintillaView wrapIndentModes);
		add: (Aspect sequenceableCollection: #editorKeyBindings
					addEvaluationFrom: {UI.Scintilla.KeyBinding name , ' new'}) beImmutable;
		add: (Aspect dictionary: #acceleratorKeyBindings) beImmutable;
		add: self textStylesAspect;
		add: self indicatorStylesAspect;
		add: (Aspect choice: #fontQuality from: UI.Scintilla.ScintillaView fontQualities);
		add: (Aspect font: #defaultFont);
		yourself!

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

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.Scintilla.ScintillaView) 34 50 nil nil 34 2 8 1411453252 1 416 918598 2 ##(UI.ValueHolder) nil false 1769478 ##(Kernel.EqualitySearchPolicy) nil 1245702 ##(Graphics.ThemeColor) #smalltalkWorkspace nil 21 461638 4 ##(UI.Menu) nil true 34 13 1180742 2 ##(UI.CommandMenuItem) 1 1377606 4 ##(UI.CommandDescription) #accept 8 '&Accept' 1 1 nil nil nil 1179974 1 ##(UI.DividerMenuItem) 4097 578 nil true 34 10 626 1 658 #undo 8 '&Undo' 1 1 853318 3 ##(Graphics.Icon) nil true 2031622 ##(Kernel.ImageRelativeFileLocator) 8 'EditUndo.ico' 2490894 ##(Kernel.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 706 4097 626 1 658 #cutSelection 8 'Cu&t' 1 1 818 nil true 864 8 'EditCut.ico' 912 nil nil 626 1 658 #copySelection 8 '&Copy' 1 1 818 nil true 864 8 'EditCopy.ico' 912 nil nil 626 1 658 #pasteClipboard 8 '&Paste' 1 1 818 nil true 864 8 'EditPaste.ico' 912 nil nil 626 1 658 #clearSelection 8 'De&lete' 1 1 818 nil true 864 8 'EditClear.ico' 912 nil nil 706 4097 626 1 658 #reformatSource 8 'Re&format' 1 1 nil nil nil 706 4097 626 1 658 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 578 nil true 34 10 626 1 658 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 626 1 658 #cloneNew 8 'Clo&ne' 1 1 818 nil true 864 8 'SmalltalkWorkspace.ico' 912 nil nil 706 4097 626 1 658 #toggleAutoCompletion 8 'Auto-complete' 1 1 nil nil nil 626 1 658 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 626 1 658 #toggleLineEndings 8 'Line &Endings' 1 1 1378630 1 ##(Graphics.TextTileIcon) $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 626 1 658 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 626 1 658 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 626 1 658 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 626 1 658 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 706 4097 626 1 658 #browseIt 8 'Bro&wse It' 1 1 818 nil true 864 8 'ClassBrowserShell.ico' 912 nil nil 626 1 658 #displayIt 8 '&Display It' 1 1 818 nil true 864 8 'DisplayIt.ico' 912 nil nil 626 1 658 #printIt 8 '&Print It' 1 1 818 nil true 864 8 'PrintIt.ico' 912 nil nil 626 1 658 #evaluateIt 8 'E&valuate It' 1 1 818 nil true 864 8 'EvaluateIt.ico' 912 nil nil 626 1 658 #inspectIt 8 '&Inspect It' 1 1 818 nil true 864 8 'InspectIt.ico' 912 nil nil 626 1 658 #debugIt 8 'Deb&ug It' 1 1 818 nil true 864 8 'DebugIt.ico' 912 nil nil 706 4097 578 nil true 34 2 626 2097153 658 #browseDefinitions 8 'Defi&nitions...' 1 1 nil nil nil 626 1 658 #browseReferences 8 '&References...' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 416 nil 8 2031697384 1049094 ##(UI.NullConverter) nil nil 9 1848875793 170 192 34 4 #normal 1444934 1 ##(UI.Scintilla.TextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2754 77 917510 ##(Graphics.Color) #gray 2802 #white 1 nil nil nil nil #callTip nil nil nil nil 2032902 ##(Tools.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1903686 2 ##(UI.Scintilla.MarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Core.IdentitySet) 2896 nil 170 176 2896 nil nil nil nil nil 2802 #silver nil nil 65 nil nil 170 192 34 6 #specialCharacter 8 '()[]<>' #literalArray 8 '()' #literalBytes 8 '[]' 8 '' 3 170 192 34 2 #container 2720 nil nil nil nil 208 nil 170 192 2896 nil nil 170 192 34 6 #Notification 2754 1029 nil 2802 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2754 1027 2802 #darkGoldenrod 2802 #ivory 1 nil nil nil nil #Warning nil nil nil #Error 2754 1031 2802 #firebrick 2802 #floralWhite 1 nil nil nil nil #Error nil nil nil nil 1310982 ##(Core.MessageSequence) 138 144 34 11 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 918022 ##(Graphics.Point) 6143 21 3442 461 311 416 3394 #contextMenu: 34 1 592 416 3394 #hoverTime: 8 #(500) 416 3394 #caretPeriod: 8 #(530) 416 3394 #wordWrap: 8 #(true) 416 3394 #margins: 34 1 34 3 1247302 3 ##(UI.Scintilla.Margin) 1 416 1 3 nil nil nil nil 3666 3 416 1 nil nil 67108863 nil nil 3666 5 416 1 nil nil nil nil nil 416 3394 #tabWidth: 8 #(4) 416 3394 #targetRange: 34 1 852742 ##(Core.Interval) 1 -1 3 416 3394 #maxCompletionListHeight: 8 #(9) 416 3394 #edgeColumn: 8 #(1) 416 3394 #hasAdditionalSelectionTyping: 8 #(true) 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 229 12 0 0 165 0 0 0] 8 #() 3442 193 193 nil 31 )!

setAdditionalKeyBindings: anArray
	additionalKeyBindings := anArray ifNotNil: [anArray]!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray!

textStyles
	TextStyles isNil ifTrue: [self textStyles: self defaultTextStyles].
	^TextStyles!

textStyles: aCollectionOfScintillaTextStyles
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	TextStyles := aCollectionOfScintillaTextStyles asOrderedCollection
				sortUsing: (SortAlgorithm defaultSort: [:a :b | a name <= b name]).
	self primAllSubinstances do: [:each | each textStyles: self textStyles]!

textStylesAspect
	^(Aspect name: #textStyles
		presenterBlock: 
			[:p :m |
			(UI.Scintilla.StylesCollectionPresenter createIn: p on: m)
				defaultStyle: self defaultTextStyle;
				yourself])
		beImmutable;
		yourself!

uninitialize
	"Private - The receiver is about to be uninstalled from the system. Clean up."

	ThemeColor removeNamed: #smalltalkWorkspace!

useDirectWrite
	"Answer whether to use DirectWrite for drawing text in the workspace. This offers improved quality, coloured emoji's, and hardware acceleration, but may not 
	work well in all circumstances, so it can be turned off."

	^UseDirectWrite and: [OS.KernelLibrary default isWindowsVistaOrGreater]!

useDirectWrite: aBoolean
	| tech |
	UseDirectWrite := aBoolean.
	tech := self useDirectWrite ifTrue: [#directWrite] ifFalse: [#default].
	self primAllSubinstances do: [:each | each view drawingTechnology: tech]

!

wordWrap
	"Answer true if instances of the receiver use word wrapping by default."

	^WordWrap!

wordWrap: aBoolean 
	"Sets the word wrapping state for instances of the receiver to aBoolean."

	WordWrap == aBoolean ifTrue: [^self].
	WordWrap := aBoolean.
	self allSubinstances do: [:each | each setWordWrap]!

wrapIndentMode
	^WrapIndentMode!

wrapIndentMode: aSymbol 
	WrapIndentMode := aSymbol! !
!Tools.SmalltalkWorkspace class categoriesFor: #actualFont!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #annotationMode!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #annotationMode:!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #autoCompleteDwell!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #autoCompleteDwell:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #customEditorKeyBindings!options!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultBackcolor!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultBackcolor:!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultCaretColor!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultCaretColor:!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultEditorKeyBindings!constants!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultFont!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultFont:!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultIndicatorStyles!constants!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultKeywordCompletions!autocompletion!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultTabWidth!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultTabWidth:!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultTextStyle!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultTextStyles!constants!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #defaultUnaryReturnTypes!autocompletion!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #editorKeyBindings!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #editorKeyBindings:!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #fontQuality!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #fontQuality:!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #getAdditionalKeyBindings!accessing!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #icon!constants!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #indicatorStyles!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #indicatorStyles:!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #indicatorStylesAspect!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #initialize!initializing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionCaseInsensitive!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionCaseInsensitive:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionEnabled!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionEnabled:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionSpaceAdded!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionSpaceAdded:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionTruncating!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #isAutoCompletionTruncating:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #maxAutoCompletionListSize!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #maxAutoCompletionListSize:!accessing!autocompletion!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #publishedAspects!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #publishedEventsOfInstances!events!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !
!Tools.SmalltalkWorkspace class categoriesFor: #setAdditionalKeyBindings:!accessing!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #setCommandQueryHandlers:!accessing!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #textStyles!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #textStyles:!accessing!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #textStylesAspect!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #uninitialize!class hierarchy-removing!private! !
!Tools.SmalltalkWorkspace class categoriesFor: #useDirectWrite!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #useDirectWrite:!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #wordWrap!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #wordWrap:!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #wrapIndentMode!accessing!options!public! !
!Tools.SmalltalkWorkspace class categoriesFor: #wrapIndentMode:!accessing!options!public! !

