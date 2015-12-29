"Filed out from Dolphin Smalltalk 7"!

Presenter subclass: #SmalltalkWorkspace
	instanceVariableNames: 'evaluationContext errorModel findDetails workspacePool evaluationPools compilationErrors textStyles searchEnvironment modifiedModel flags'
	classVariableNames: 'Abbreviations AnnotationMode AutoCompleteDwell AutoCompleteMask DefaultBackcolor DefaultCaretColor DefaultFont DefaultTabWidth IsAutoCompletionCaseInsensitive IsAutoCompletionEnabled IsAutoCompletionSpaceAdded IsAutoCompletionTruncating KeywordCompletions MaxAutoCompletionListSize StandardUnaryReturnTypes TextStyles VariableTipsMask WordWrap WrapIndentMode'
	poolDictionaries: 'CompilerFlags ScintillaConstants'
	classInstanceVariableNames: 'additionalAccelerators commandQueryHandlers'!
SmalltalkWorkspace guid: (GUID fromString: '{87B4C687-026E-11D3-9FD7-00A0CC3E4A32}')!
SmalltalkWorkspace comment: 'SmalltalkWorkspace is a <presenter> for displaying a workspace area within a <ScintillaView>. Note that, for efficiency purposes, a SmalltakWorkspace does not have a model. The textual data is held only within the associated view. since there seems little point in duplicating this text and holding it within the image as, say, a <readableString>.

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
!SmalltalkWorkspace categoriesForClass!Development!MVP-Presenters!MVP-Resources-IDE Tools! !
!SmalltalkWorkspace methodsFor!

allDefinedVariablesDo: aMonadicValuable 
	workspacePool keysDo: aMonadicValuable!

allPools
	"Private - Answers an Array of all the PoolDictionaries used during evaluations in the
	receiver. The workspacePool of locals must be the first element of the array"

	^(OrderedCollection with: self workspacePool) 
		addAll: self evaluationPools; 
		asArray!

applyOptions
	"Private - Apply the class options to the receiver"

	view backcolor ifNotNil: [:color | color isDefault ifTrue: [self setBackcolor]].
	self
		setFont;
		setCaretColor;
		setWordWrap;
		setTabWidth.
	"textStyles are initialized to class setting by default, but parent presenter might have
	replaced them. N.B. If you blow up here, its because you are trying to use a non-Scintilla
	view with SmalltalkWorkspace. This is no longer supported."
	view textStyles: self textStyles.
	view wordChars: (Character byteCharacterSet 
				select: [:each | (Compiler isAValidIdentifierChar: each) or: [each == $:]]).
	self hasSmalltalkStyler ifFalse: [self isAutoCompletionEnabled: false].
	view isAutoCompletionCaseInsensitive: self class isAutoCompletionCaseInsensitive.
	"This has no effect, since we takeover insertion of the completed word, but it's a useful
	way to store the flag on a per-instance basis"
	view isAutoCompletionTruncating: self class isAutoCompletionTruncating.
	view maxCompletionListHeight: 10.
	view maxCompletionListWidth: 40.
	self areVariableTipsEnabled ifTrue: [view isBackgroundDwellEnabled: true].
	"#2137"
	view sciSetCodePage: KernelLibrary default getACP.
	view annotationMode: self class annotationMode.
	view wrapIndentMode: self class wrapIndentMode!

areVariableTipsEnabled
	^flags allMask: VariableTipsMask!

areVariableTipsEnabled: aBoolean 
	flags := flags mask: VariableTipsMask set: aBoolean!

autoComplete: aSymbol at: posInteger maxItems: maxInteger 
	aSymbol == #identifier 
		ifTrue: 
			[self showIdentifierCompletionListAt: posInteger maxItems: maxInteger.
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
		arguments: (Array with: self selectedWord with: self searchEnvironment)!

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
		arguments: (Array with: self selectedWord with: self searchEnvironment)!

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
		caption: 'Available pools'.
	!

chunkFilerClass
	^ChunkSourceFiler!

classForIdentifier: aString 
	aString = 'self' ifTrue: [^self selfClass].
	aString = 'super' ifTrue: [^self selfClass superclass].
	aString = 'thisContext' ifTrue: [^Integer].
	"In the debugger the workspacePool will also contain any temps and args, so we'll get
	sensible autocompletion on those too"
	(self workspacePool bindingFor: aString) ifNotNil: [:var | ^var value basicClass].
	^[(self evaluationContext instVarNamed: aString) basicClass] on: NotFoundError
		do: [:ex | (self selfClass fullBindingFor: aString) ifNotNil: [:var | var value basicClass]]!

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
			lookup := ##((LookupTable new)
						at: 'nil' put: nil class;
						at: 'false' put: false class;
						at: 'true' put: true class;
						shrink;
						yourself).
			^lookup at: text ifAbsent: []].
	style == #literalNumber ifTrue: [^(SmalltalkStylingScanner on: text readStream) next numberClass].
	style == #literalString ifTrue: [^String].
	style == #literalSymbol ifTrue: [^Symbol].
	style == #literalCharacter ifTrue: [^Character].
	(style == #specialCharacter and: [(view characterAt: anAssociation key stop) == $]]) 
		ifTrue: [^BlockClosure].
	style == #unaryMessage 
		ifTrue: 
			[text = 'class' 
				ifTrue: 
					[| penultimate |
					penultimate := self tokenBefore: anAssociation key start - 1.
					^(self classForToken: penultimate) ifNotNil: [:class | class basicClass]].
			(StandardUnaryReturnTypes at: text ifAbsent: []) ifNotNil: [:class | ^class]].
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
	
	[| f |
	f := self defaultCompilerFlags.
	aBoolean ifTrue: [f := f | DebugMethod].
	result := compiler 
				compileForEvaluation: source
				in: context basicClass
				evaluationPools: self allPools
				logged: true
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
					nextChar ~~ Character null and: [nextChar isSeparator not]].
	view
		selectionRange: replaceRange;
		replaceSelection: (addSpace ifTrue: [aString , ' '] ifFalse: [aString]).
	^addSpace!

completionListSortBlock
	| crt |
	crt := CRTLibrary default.
	^self isAutoCompletionCaseInsensitive 
		ifTrue: [[:a :b | (crt _stricmp: a string2: b) <= 0]]
		ifFalse: [[:a :b | (crt strcmp: a string2: b) <= 0]]!

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

	| result evalRange |
	evalRange := self selectEvaluationRange.
	result := self evaluateRange: evalRange ifFail: [^self].
	"Source range is inclusive, so we want to move caret to immediately after
	that range"
	self showResult: result at: evalRange stop+1!

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

	| result |
	self cancelAutoCompletion.
	result := self 
				compileRange: anInterval
				ifFail: failBlock
				debug: aBoolean.

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
	result := result method value: self evaluationContext.
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

	"Nasty, but for backwards compatibility - will be removed in a future release"

	(aFindDetails isKindOf: Array) 
		ifTrue: 
			[| array sender |
			sender := Processor activeProcess topFrame sender.
			Notification 
				signal: ('Deprecated usage of TextPresenter>>findDetails: from <1p> (Argument is no longer an Array)' 
						expandMacrosWith: sender method).
			array := aFindDetails.
			findDetails := (FindDetails new)
						findWhat: array first;
						isForwards: array second;
						isCaseSensitive: array third;
						isWholeWord: array fourth;
						yourself.
			^self].
	findDetails := aFindDetails!

firstError
	^compilationErrors isEmpty 
		ifFalse: 
			[compilationErrors detect: [:each | each severityClass == Error] ifNone: [compilationErrors first]]!

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
			indicators add: (ScintillaIndicator 
						styleName: each severityClass name
						range: each range + anInteger
						tag: each).
			annotations add: (ScintillaAnnotation 
						line: each line
						text: ('<1s>: <2s>' expandMacrosWith: each severityName with: each errorMessage)
						style: each severityClass name)].
	(self view)
		indicators: indicators;
		annotations: annotations!

identifierAt: anInteger 
	| style |
	style := (view styleAt: anInteger) name.
	^(#(#identifier #tempDecl #argDecl) identityIncludes: style) 
		ifTrue: 
			[| range |
			range := view tokenRangeAt: anInteger.
			StIdentifierToken value: (view plainTextRange: range) start: range start]!

identifiersStartingWith: aString maxItems: anInteger 
	"Private - Build and answer a colleciton of identifiers that are potential completions for
	the specified prefix. If in case-sensitive mode assume that the convention of starting all
	class/pool/global variables with an uppercase letter, and all temps and inst. vars with a
	lowercase one, is followed. If there are more matching identifiers than the specified
	maximum, then answer an empty collection."

	| variables ignoreCase filter |
	variables := Set new.
	ignoreCase := self isAutoCompletionCaseInsensitive.
	filter := aString isEmpty 
				ifTrue: 
					[
					[:eachName | 
					variables add: eachName.
					variables size > anInteger ifTrue: [^#()]]]
				ifFalse: 
					[
					[:eachName | 
					(eachName beginsWith: aString ignoreCase: ignoreCase) 
						ifTrue: 
							[variables add: eachName.
							variables size > anInteger ifTrue: [^#()]]]].
	(ignoreCase or: [aString isEmpty or: [aString first isLowercase]]) 
		ifTrue: 
			[Compiler reservedWords do: filter.
			self allDefinedVariablesDo: filter.
			self selfClass allInstVarNames do: filter].
	(ignoreCase or: [aString isEmpty or: [aString first isUppercase]]) 
		ifTrue: 
			[| class |
			class := self selfClass instanceClass.
			class withAllSuperclassesDo: 
					[:eachClass | 
					eachClass classPool keysDo: filter.
					eachClass sharedPools do: [:eachPool | eachPool keysDo: filter]].
			evaluationPools do: [:each | each keysDo: filter].
			class environment keysDo: filter].
	^variables!

initialize
	"Private - Initialize the receiver"

	super initialize.
	flags := 0.
	"Set up the pools for evaluations in the receiver"
	self evaluationPools: Array new.
	self newVariablePool.
	self clearStatus.
	compilationErrors := OrderedCollection new.
	self textStyles: self class textStyles.
	self isAutoCompletionEnabled: self class isAutoCompletionEnabled!

insertCompletion: aString at: anInteger 
	"Private-"

	"Special case for insertions of unquoted symbols in Smalltalk-80 style literal arrays. Since
	this is deprecated syntax, correct it..."
	| word |
	word := ((view styleAt: anInteger) name == #literalSymbol 
				and: [(view characterAt: anInteger) ~~ $#]) ifTrue: ['#' , aString] ifFalse: [aString].
	view performUndoableAction: [self completeWordAt: anInteger with: word]!

insertKeywordCompletion: aString startingAt: anInteger 
	| text selectionRange |
	selectionRange := (KeywordCompletions at: aString ifAbsent: []) 
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
	^50000!

maybeShowCompletionList
	| styleName last |
	last := view caretPosition - 1.
	styleName := (view styleAt: last) name.
	(self 
		autoComplete: styleName
		at: last
		maxItems: self maxAutoCompletionListSize) 
			ifNil: 
				["If a space is typed after certain identifiers e.g. an instance
				 variable in the debugger, or when certain special characters are
				 typed, we can show a sensible auto-completion list."
				| char |
				char := view characterAt: last.
				((char == $^ and: [styleName == #specialCharacter]) 
					or: [char == Character space and: [(view styleIdAt: last) = (view idOfStyleNamed: #whitespace)]]) 
						ifTrue: 
							[self showCompletionListAfterToken: (self tokenBefore: last) maxItems: self maxAutoCompletionListSize]]!

messagesForToken: anAssociation startingWith: aString maxItems: anInteger 
	"Private - Answer the set of selectors that could potentially be sent as messages following
	the specified token."

	| selectors ignoreCase |
	ignoreCase := self isAutoCompletionCaseInsensitive.
	(self classForToken: anAssociation) 
		ifNil: 
			[| allSelectors |
			allSelectors := Smalltalk developmentSystem allSelectors.
			aString isEmpty 
				ifTrue: [selectors := allSelectors size > anInteger ifTrue: [#()] ifFalse: [allSelectors]]
				ifFalse: 
					[selectors := Set new.
					allSelectors do: 
							[:eachName | 
							(eachName beginsWith: aString ignoreCase: ignoreCase) 
								ifTrue: 
									[selectors add: eachName.
									selectors size > anInteger ifTrue: [^#()]]]]]
		ifNotNil: 
			[:class | 
			selectors := Set new.
			class withAllSuperclassesDo: (aString isEmpty 
						ifTrue: 
							[
							[:eachClass | 
							selectors addAll: eachClass selectors.
							selectors size > anInteger ifTrue: [^#()]]]
						ifFalse: 
							[
							[:eachClass | 
							eachClass selectors do: 
									[:eachSelector | 
									(eachSelector beginsWith: aString ignoreCase: ignoreCase) 
										ifTrue: 
											[selectors add: eachSelector.
											selectors size > anInteger ifTrue: [^#()]]]]])].
	^selectors!

modifiedModel
	^modifiedModel!

newVariablePool
	workspacePool := PoolDictionary new!

onAutoComplete: aString startingAt: anInteger accept: aValueHolder 
	"Private - "

	(aString first ~~ $# and: [aString includes: $:]) 
		ifTrue: [self insertKeywordCompletion: aString startingAt: anInteger]
		ifFalse: [self insertCompletion: aString at: anInteger].
	aValueHolder value: false!

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
	(SmalltalkScanner isVariable: name) 
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
			[aCommandQuery isEnabled: (self hasSelection and: [self isEditable]).
			^true].
	#reformatComment == selector 
		ifTrue: 
			[aCommandQuery isEnabled: (self isEditable and: [self view styleUnderCaret name == #comment]).
			^true].
	(#(#chooseEvaluationPools #inspectWorkspacePool #cloneNew #clear #displayIt) 
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
	source := self selection.
	tabs := (source findFirst: [:each | each ~~ Character tab]) - 1.
	expr := [SmalltalkParser parseExpression: source in: self parseContext] on: SmalltalkParser notificationClass
				do: 
					[:e | 
					e okToContinue.
					nil].
	expr isNil ifTrue: [^self].
	formatter := expr formatterClass new.
	tabs <= 0 
		ifTrue: [reformatted := formatter format: expr]
		ifFalse: 
			[formatter indent: tabs
				around: [reformatted := (source copyFrom: 1 to: tabs) , (formatter format: expr)]].
	^self replaceSelection: reformatted!

replaceSelection: aString
	"Replace the current selected range of text with aString"
	
	^self view replaceSelection: aString!

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

showCompletionList: aCollectionOfStrings prefixLength: anInteger 
	(aCollectionOfStrings size = 1 and: [aCollectionOfStrings anyOne size = anInteger]) 
		ifTrue: 
			["Don't display a list of one item that is the same as the prefix"
			^self].
	view 
		showAutoCompletionList: (aCollectionOfStrings asSortedCollection: self completionListSortBlock)
		prefixLength: anInteger!

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
		identityIncludes: styleName) or: [self isSpecialToken: anAssociation oneOf: '])']) 
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

	| errors |
	self highlightCompilationErrors: anInteger.
	errors := self errorModel.
	errors notNil 
		ifTrue: 
			[compilationErrors isEmpty 
				ifTrue: [errors value: nil]
				ifFalse: 
					[| first |
					first := self firstError.
					self showError: first offset: anInteger]].
	^compilationErrors notEmpty!

showIdentifierCompletionListAt: posInteger maxItems: maxInteger 
	| prefix start choices |
	start := self tokenStartAt: posInteger.
	"Trim blanks in case requesting display of identifier list on whitespace"
	prefix := (view plainTextFrom: start to: posInteger) trimBlanks.
	choices := self identifiersStartingWith: prefix maxItems: maxInteger.
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

showResult: anObject at: caretPos 
	"Private - Show the result of an evaluation."

	| result selStart |
	self isOpen ifFalse: [^self].
	result := anObject printString.
	self caretPosition: caretPos.
	selStart := caretPos.
	self replaceSelection: result.
	self selectionRange: (selStart to: selStart + result size - 1)!

showSelectorCompletionListAt: posInteger maxItems: maxInteger 
	| prefix start choices |
	start := self tokenStartAt: posInteger.
	prefix := view plainTextFrom: start to: posInteger.
	choices := self selectorsStartingWith: prefix maxItems: maxInteger.
	self showCompletionList: choices prefixLength: prefix size!

showSymbolCompletionListAt: posInteger maxItems: maxInteger 
	| prefix start symbols hashed prefixLength |
	start := self tokenStartAt: posInteger.
	prefix := view plainTextRange: (start to: posInteger).
	prefixLength := prefix size.
	(hashed := prefix first == $#) ifTrue: [prefix := prefix copyFrom: 2].
	symbols := self symbolsStartingWith: prefix maxItems: maxInteger.
	self 
		showCompletionList: (hashed ifTrue: [symbols collect: [:each | '#' , each]] ifFalse: [symbols])
		prefixLength: prefixLength!

showTipForIdentifier: anStIdentifierToken 
	| context name |
	context := self evaluationContext.
	name := anStIdentifierToken value.
	
	[| result |
	result := context basicClass compilerClass 
				evaluate: name
				for: context
				evaluationPools: self allPools
				logged: false
				ifFail: [^self].
	self view showCallTip: result debugPrintString at: anStIdentifierToken stop + 2] 
			on: Compiler notificationClass
			do: [:ex | ]!

showTipForIndicators: aCollectionOfScintillaIndicators 
	| tip last |
	tip := String writeStream.
	last := 0.
	aCollectionOfScintillaIndicators do: 
			[:each | 
			tip nextPutAll: each tag displayString.
			last := last max: each range stop + 2]
		separatedBy: [tip nextPut: Character lf].
	self view showCallTip: tip contents at: last!

startAutocompleteTimer
	self view setTimer: SCI_AUTOCSHOW interval: self class autoCompleteDwell!

stylerClass: aScintillaStylerClass
	self view stylerClass: aScintillaStylerClass!

symbolsStartingWith: aString maxItems: anInteger 
	| stream ignoreCase |
	stream := Array writeStream.
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
	| original scintilla justified |
	scintilla := self view.
	original := scintilla plainTextRange: anInterval.
	justified := self systemModel 
				wrapText: original
				indent: anInteger
				tabWidth: scintilla tabWidth.
	scintilla targetRange: anInterval.
	scintilla replaceTarget: justified! !
!SmalltalkWorkspace categoriesFor: #allDefinedVariablesDo:!autocompletion!enumerating!private! !
!SmalltalkWorkspace categoriesFor: #allPools!accessing!private! !
!SmalltalkWorkspace categoriesFor: #applyOptions!operations!options!private! !
!SmalltalkWorkspace categoriesFor: #areVariableTipsEnabled!public!testing! !
!SmalltalkWorkspace categoriesFor: #areVariableTipsEnabled:!public!testing! !
!SmalltalkWorkspace categoriesFor: #autoComplete:at:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #basicFindNext!commands!public! !
!SmalltalkWorkspace categoriesFor: #basicInspectIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #browseDefinitions!commands!public! !
!SmalltalkWorkspace categoriesFor: #browseDefinitionsCommand!commands!private! !
!SmalltalkWorkspace categoriesFor: #browseIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #browseReferences!commands!public! !
!SmalltalkWorkspace categoriesFor: #browseReferencesCommand!commands!private! !
!SmalltalkWorkspace categoriesFor: #cancelAutoCompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #caretPosition:!accessing!caret!public! !
!SmalltalkWorkspace categoriesFor: #chooseEvaluationPools!commands!public! !
!SmalltalkWorkspace categoriesFor: #chunkFilerClass!constants!public! !
!SmalltalkWorkspace categoriesFor: #classForIdentifier:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #classForToken:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #clear!operations!public! !
!SmalltalkWorkspace categoriesFor: #clearErrors!operations!public! !
!SmalltalkWorkspace categoriesFor: #clearStatus!operations!public! !
!SmalltalkWorkspace categoriesFor: #cloneNew!commands!public! !
!SmalltalkWorkspace categoriesFor: #compilationErrors!accessing!private! !
!SmalltalkWorkspace categoriesFor: #compileAll!commands!public! !
!SmalltalkWorkspace categoriesFor: #compileAllIfFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #compileIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #compileItIfFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #compileRange:ifFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #compileRange:ifFail:debug:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #compilerNotification:offset:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #completeWord!autocompletion!commands!public! !
!SmalltalkWorkspace categoriesFor: #completeWordAt:with:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #completionListSortBlock!autocompletion!constants!private! !
!SmalltalkWorkspace categoriesFor: #copySelection!commands!public! !
!SmalltalkWorkspace categoriesFor: #createComponents!initializing!private! !
!SmalltalkWorkspace categoriesFor: #createSchematicWiring!initializing!private! !
!SmalltalkWorkspace categoriesFor: #debugIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #debugItIfFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #defaultCompilerFlags!constants!private! !
!SmalltalkWorkspace categoriesFor: #defaultStylerClass!constants!private! !
!SmalltalkWorkspace categoriesFor: #displayIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #dragOver:!drag & drop!public! !
!SmalltalkWorkspace categoriesFor: #drop:!drag & drop!public! !
!SmalltalkWorkspace categoriesFor: #dropObjectRef:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #errorModel!accessing!public! !
!SmalltalkWorkspace categoriesFor: #errorModel:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #evaluateIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #evaluateItIfFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #evaluateItIfFail:debug:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #evaluateRange:ifFail:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #evaluateRange:ifFail:debug:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #evaluationContext!accessing!public! !
!SmalltalkWorkspace categoriesFor: #evaluationContext:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #evaluationPools!accessing!public! !
!SmalltalkWorkspace categoriesFor: #evaluationPools:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #fileItIn!commands!public! !
!SmalltalkWorkspace categoriesFor: #findDetails!accessing!public! !
!SmalltalkWorkspace categoriesFor: #findDetails:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #firstError!helpers!private! !
!SmalltalkWorkspace categoriesFor: #getCompletionSignatureFor:at:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #hasErrors!public!testing! !
!SmalltalkWorkspace categoriesFor: #hasSelection!public!testing! !
!SmalltalkWorkspace categoriesFor: #hasSmalltalkStyler!commands!private! !
!SmalltalkWorkspace categoriesFor: #highlightCompilationErrors:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #identifierAt:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #identifiersStartingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #initialize!initializing!private! !
!SmalltalkWorkspace categoriesFor: #insertCompletion:at:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #insertKeywordCompletion:startingAt:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #inspectIt!commands!public! !
!SmalltalkWorkspace categoriesFor: #inspectWorkspacePool!commands!private! !
!SmalltalkWorkspace categoriesFor: #isAutoCompletionCaseInsensitive!public!testing! !
!SmalltalkWorkspace categoriesFor: #isAutoCompletionEnabled!autocompletion!private!testing! !
!SmalltalkWorkspace categoriesFor: #isAutoCompletionEnabled:!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #isAutoCompletionTruncating!public!testing! !
!SmalltalkWorkspace categoriesFor: #isEditable!private!testing! !
!SmalltalkWorkspace categoriesFor: #isModified!public!testing! !
!SmalltalkWorkspace categoriesFor: #isModified:!modes!public! !
!SmalltalkWorkspace categoriesFor: #isReadOnly!public!testing! !
!SmalltalkWorkspace categoriesFor: #isReadOnly:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #isSpecialToken:oneOf:!public!testing! !
!SmalltalkWorkspace categoriesFor: #isSyntaxColoringEnabled!private!testing! !
!SmalltalkWorkspace categoriesFor: #isWhitespaceAt:!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #killAutocompleteTimer!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #maxAutoCompletionListSize!autocompletion!constants!private! !
!SmalltalkWorkspace categoriesFor: #maxCompletionListSize!autocompletion!constants!private! !
!SmalltalkWorkspace categoriesFor: #maybeShowCompletionList!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #messagesForToken:startingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #modifiedModel!accessing!public! !
!SmalltalkWorkspace categoriesFor: #newVariablePool!operations!private! !
!SmalltalkWorkspace categoriesFor: #onAutoComplete:startingAt:accept:!autocompletion!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onCharAdded:!autocompletion!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onHoverEnd:!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onHoverStart:!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onRightButtonReleased:!event handling!public! !
!SmalltalkWorkspace categoriesFor: #onTimerTick:!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onTipTextRequired:!event handling!private! !
!SmalltalkWorkspace categoriesFor: #onViewOpened!event handling!private! !
!SmalltalkWorkspace categoriesFor: #parseContext!commands!public! !
!SmalltalkWorkspace categoriesFor: #plainText!accessing!public! !
!SmalltalkWorkspace categoriesFor: #plainTextRange:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #prompt:toSaveChanges:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #promptForVariableName:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #publishedAspects!development!public! !
!SmalltalkWorkspace categoriesFor: #queryCommand:!commands!private! !
!SmalltalkWorkspace categoriesFor: #rangeToCompleteAt:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #reformatComment!commands!public! !
!SmalltalkWorkspace categoriesFor: #reformatSource!commands!public! !
!SmalltalkWorkspace categoriesFor: #replaceSelection:!operations!public! !
!SmalltalkWorkspace categoriesFor: #searchEnvironment!commands!public! !
!SmalltalkWorkspace categoriesFor: #searchEnvironment:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #selectedWord!helpers!private! !
!SmalltalkWorkspace categoriesFor: #selectEvaluationRange!helpers!private! !
!SmalltalkWorkspace categoriesFor: #selection!accessing!public! !
!SmalltalkWorkspace categoriesFor: #selectionRange!accessing!public! !
!SmalltalkWorkspace categoriesFor: #selectionRange:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #selectLine:!operations!public! !
!SmalltalkWorkspace categoriesFor: #selectNext!commands!public! !
!SmalltalkWorkspace categoriesFor: #selectorsStartingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #selectPrev!commands!public! !
!SmalltalkWorkspace categoriesFor: #selfClass!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #setBackcolor!helpers!private! !
!SmalltalkWorkspace categoriesFor: #setCaretColor!helpers!private! !
!SmalltalkWorkspace categoriesFor: #setFont!helpers!private! !
!SmalltalkWorkspace categoriesFor: #setTabWidth!helpers!private! !
!SmalltalkWorkspace categoriesFor: #setWordWrap!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showCompletionList:prefixLength:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showCompletionListAfterToken:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showError:offset:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showFirstError:!operations!private! !
!SmalltalkWorkspace categoriesFor: #showIdentifierCompletionListAt:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showMessageCompletionListAt:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showResult:at:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showSelectorCompletionListAt:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showSymbolCompletionListAt:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showTipForIdentifier:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #showTipForIndicators:!helpers!private! !
!SmalltalkWorkspace categoriesFor: #startAutocompleteTimer!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #stylerClass:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #symbolsStartingWith:maxItems:!autocompletion!helpers!private! !
!SmalltalkWorkspace categoriesFor: #systemModel!constants!private! !
!SmalltalkWorkspace categoriesFor: #text!accessing!public! !
!SmalltalkWorkspace categoriesFor: #text:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #textLength!accessing!public! !
!SmalltalkWorkspace categoriesFor: #textStyles!accessing!public! !
!SmalltalkWorkspace categoriesFor: #textStyles:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #toggleAutoCompletion!commands!public! !
!SmalltalkWorkspace categoriesFor: #toggleStyling!commands!public! !
!SmalltalkWorkspace categoriesFor: #tokenBefore:!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #tokenRangeAt:!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #tokenStartAt:!accessing!autocompletion!private! !
!SmalltalkWorkspace categoriesFor: #validateUserInterface!operations!public! !
!SmalltalkWorkspace categoriesFor: #workspacePool!accessing!public! !
!SmalltalkWorkspace categoriesFor: #workspacePool:!accessing!public! !
!SmalltalkWorkspace categoriesFor: #wrapLinesInRange:indent:!helpers!private! !

SmalltalkWorkspace methodProtocol: #textPresenter attributes: #() selectors: #(#clear #findDetails #findDetails: #hasSelection #isModified #isModified: #replaceSelection: #selectionRange #selectionRange:)!

!SmalltalkWorkspace class methodsFor!

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

defaultAdditionalAccelerators
	"Private - Answer a collection of additional accelerator definitions to be bound to the
	receiver's commands. Each element of the collection should be a two element <Array>, the
	first element of which is the command symbol and the second the accelerator key string."

	"Note: The Ctrl+L and Ctrl+Shift+L shortcuts for cut and delete line respectively are no
	longer defined here because they are default Scintilla key bindings."

	^#(#(#toggleWordWrap 'Ctrl+R') #(#duplicateSelection 'Ctrl+J') #(#completeWord 'Ctrl+.') #(#selectNext 'F8') #(#selectPrev 'Shift+F8'))!

defaultBackcolor
	"Answer the default background to use for instances of the receiver"

	^DefaultBackcolor!

defaultBackcolor: aColorOrNil 
	"Set the default background to use for instances of the receiver"

	DefaultBackcolor = aColorOrNil ifTrue: [^self].
	DefaultBackcolor := aColorOrNil.
	self allSubinstances do: [:each | each setBackcolor]!

defaultCaretColor
	"Answer the default color to use for the caret in instances of the receiver"

	^DefaultCaretColor!

defaultCaretColor: aColorOrNil 
	"Set the default caret color to use for instances of the receiver"

	DefaultCaretColor = aColorOrNil ifTrue: [^self].
	DefaultCaretColor := aColorOrNil.
	self allSubinstances do: [:each | each setCaretColor]!

defaultFont
	"Answer the default  font to use for instances of the receiver"

	^DefaultFont!

defaultFont: aFontOrNil 
	"Set the default <Font> to use for instances of the receiver"

	DefaultFont = aFontOrNil ifTrue: [^self].
	DefaultFont := aFontOrNil.
	self allSubinstances do: [:each | each setFont]!

defaultKeywordCompletions
	"Private - Answer the default set of special keyword completion templates. These are to
	perform a more helpful insertion for commonly used keyword selectors where the arguments are
	of a known type, for example the control structures."

	^(LookupTable new)
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
	style := ScintillaTextStyle new.
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
	answer := Set new.
	answer
		add: ((ScintillaTextStyle name: #illegal)
					description: 'Illegal characters, e.g. £';
					forecolor: Color red;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #comment)
					description: 'Comments in method source';
					forecolor: Color darkGreen;
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #identifier)
					description: 'Variables references (instance, temporary and class)';
					yourself);
		add: ((ScintillaTextStyle name: #argDecl)
					description: 'Argument declaration in method signature';
					isItalic: true;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #blockArgDecl)
					description: 'Block argument declaration';
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #tempDecl)
					description: 'Temporary variable declaration';
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #unarySelector)
					description: 'Unary selectors (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #unaryMessage)
					description: 'Unary (no argument) messages';
					forecolor: Color blue;
					yourself);
		add: ((ScintillaTextStyle name: #binarySelector)
					description: 'Binary in-fix selectors such as + and - (method signature)';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #binaryMessage)
					description: 'Binary in-fix messages such as + and -';
					forecolor: Color blue;
					yourself);
		add: ((ScintillaTextStyle name: #keywordSelector)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #keywordMessage)
					description: 'Components of multi-keyword message selectors';
					forecolor: Color blue;
					yourself);
		add: ((ScintillaTextStyle name: #literalPseudo)
					description: 'The literal constants true, false and nil';
					forecolor: Color darkCyan;
					yourself);
		add: ((ScintillaTextStyle name: #literalNumber)
					description: 'Numeric literal constants, e.g. 1.2e6';
					forecolor: Color darkRed;
					yourself);
		add: ((ScintillaTextStyle name: #literalString)
					description: 'Literal string constants, e.g. ''abc''';
					forecolor: Color darkMagenta;
					yourself);
		add: ((ScintillaTextStyle name: #literalSymbol)
					description: 'Literal symbol constants, e.g. #abc';
					forecolor: Color darkBlue;
					yourself);
		add: ((ScintillaTextStyle name: #literalCharacter)
					description: 'Literal character constants, e.g. $A';
					forecolor: Color darkBlue;
					yourself);
		add: ((ScintillaTextStyle name: #literalBytes)
					description: 'Literal byte arrays, e.g. #[0 1 2]';
					forecolor: Color brown;
					yourself);
		add: ((ScintillaTextStyle name: #assignment)
					description: 'Assignment operation, i.e. :=';
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #tempOpenBar)
					description: 'Temporary declarations opening bar';
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #tempCloseBar)
					description: 'Temporary declarations closing bar';
					isItalic: true;
					yourself);
		add: ((ScintillaTextStyle name: #specialCharacter)
					description: 'Special characters, e.g. normal and block parentheses';
					yourself);
		add: ((ScintillaTextStyle name: #literalArray)
					description: 'Opening/closing token of literal array, i.e. #()';
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #tag)
					description: 'Primitive or external call tag, e.g. <primitive: 1>';
					forecolor: Color darkGray;
					isItalic: true;
					yourself);
		yourself.
	self assert: [answer size < 32].
	"Scintilla pre-defined styles - note how #normal style inherits font of the view (which in turn should be the default system font)"
	answer
		add: ScintillaTextStyle normal yourself;
		add: ((ScintillaTextStyle name: #indentGuide)
					description: 'Indentation guides, when visible';
					forecolor: Color gray;
					yourself);
		add: ((ScintillaTextStyle name: #braceHighlight)
					description: 'Matching brace, when brace highlighting enabled';
					forecolor: Color blue;
					isBold: true;
					yourself);
		add: ((ScintillaTextStyle name: #braceMismatch)
					description: 'Mismatched brace, when brace highlighting enabled';
					forecolor: Color red;
					isBold: true;
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

getAdditionalAccelerators
	^additionalAccelerators!

getCommandQueryHandlers
	^commandQueryHandlers!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	"Private - Initialize the receiver's class variables.
		SmalltalkWorkspace initialize
	"

	DefaultBackcolor := RGB 
				red: 242
				green: 242
				blue: 236.
	DefaultFont := Font name: 'Trebuchet MS' pointSize: 10.
	WordWrap := true.
	DefaultTabWidth := 8.
	AutoCompleteDwell := 30.
	KeywordCompletions := self defaultKeywordCompletions.
	StandardUnaryReturnTypes := self defaultUnaryReturnTypes.
	IsAutoCompletionCaseInsensitive := false.
	IsAutoCompletionEnabled := true.
	IsAutoCompletionTruncating := false.
	IsAutoCompletionSpaceAdded := true.
	AutoCompleteMask := 1.
	VariableTipsMask := 2.
	MaxAutoCompletionListSize := 200.
	AnnotationMode := #hidden.
	WrapIndentMode := #fixed!

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
	#(#isAutoCompletionEnabled #isAutoCompletionCaseInsensitive #isAutoCompletionTruncating) 
		do: [:each | answer add: (Aspect boolean: each)].
	#(#defaultTabWidth #autoCompleteDwell #maxAutoCompletionListSize) 
		do: [:each | answer add: (Aspect integer: each)].
	#(#defaultBackcolor #defaultCaretColor) do: [:each | answer add: (Aspect color: each)].
	^answer
		add: (Aspect choice: #annotationMode from: ScintillaView annotationModes);
		add: (Aspect choice: #wrapIndentMode from: ScintillaView wrapIndentModes);
		add: (Aspect dictionary: #acceleratorKeyBindings) beImmutable;
		add: self textStylesAspect;
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
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.ScintillaView)  98 46 0 0 98 2 8 1411453252 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 21 265030 4 ##(Smalltalk.Menu)  0 16 98 17 984134 2 ##(Smalltalk.CommandMenuItem)  1 1180998 4 ##(Smalltalk.CommandDescription)  8 #accept 8 '&Accept' 1 1 0 0 0 983366 1 ##(Smalltalk.DividerMenuItem)  4097 610 0 16 98 9 658 1 690 8 #undo 8 '&Undo' 1 1 263494 3 ##(Smalltalk.Icon)  0 16 1572870 ##(Smalltalk.ImageRelativeFileLocator)  8 'EditUndo.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy)  8 'dolphindr006.dll' 0 0 0 754 4097 658 1 690 8 #cutSelection 8 'Cu&t' 1 1 882 0 16 928 8 'EditCut.ico' 976 0 0 658 1 690 8 #copySelection 8 '&Copy' 1 1 882 0 16 928 8 'EditCopy.ico' 976 0 0 658 1 690 8 #pasteClipboard 8 '&Paste' 1 1 882 0 16 928 8 'EditPaste.ico' 976 0 0 658 1 690 8 #clearSelection 8 'De&lete' 1 1 882 0 16 928 8 'EditClear.ico' 976 0 0 658 1 690 8 #reformatSource 8 'Re&format' 1 1 0 0 0 754 4097 658 1 690 8 #selectAll 8 '&Select All' 1 1 0 0 0 8 '&Edit' 0 134217729 0 0 0 0 0 658 1 690 8 #clear 8 'Clea&r' 1 1 0 0 0 754 4097 658 1 690 8 #browseIt 8 'Bro&wse It' 1 1 882 0 16 928 8 'ClassBrowserShell.ico' 976 0 0 658 1 690 8 #displayIt 8 '&Display It' 1 1 882 0 16 928 8 'DisplayIt.ico' 976 0 0 658 1 690 8 #evaluateIt 8 'E&valuate It' 1 1 882 0 16 928 8 'EvaluateIt.ico' 976 0 0 658 1 690 8 #inspectIt 8 '&Inspect It' 1 1 882 0 16 928 8 'InspectIt.ico' 976 0 0 658 1 690 8 #debugIt 8 'Deb&ug It' 1 1 882 0 16 928 8 'Debugger.ico' 976 0 0 754 4097 658 1 690 8 #chooseEvaluationPools 8 '&Pools...' 1 1 882 0 16 928 8 'SystemDictionary.ico' 976 0 0 658 1 690 8 #inspectWorkspacePool 8 'Variab&les' 1 1 0 0 0 754 4097 610 0 16 98 2 658 2097153 690 8 #browseDefinitions 8 'Defi&nitions...' 1 1 0 0 0 658 1 690 8 #browseReferences 8 '&References...' 1 1 0 0 0 8 '&Browse' 0 1 0 0 0 0 0 754 4097 610 0 16 98 9 658 1 690 8 #toggleAutoCompletion 8 '&Auto-complete' 1 1 0 0 0 658 1 690 8 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 0 0 0 658 1 690 8 #toggleLineEndings 8 'Line &Endings' 1 1 0 0 0 658 1 690 8 #toggleLineNumbers 8 'Line N&umbers' 1 1 0 0 0 658 1 690 8 #toggleStyling 8 '&Syntax Coloring' 1 1 0 0 0 658 1 690 8 #toggleWhitespace 8 'W&hitespace' 1 1 0 0 0 658 1 690 8 #toggleWordWrap 8 '&Word Wrap' 1 1 0 0 0 754 4097 610 0 16 98 2 658 1 690 459270 ##(Smalltalk.Message)  8 #language: 98 1 8 #container 8 '&Smalltalk' 1 1 0 0 0 658 1 690 3074 3104 98 1 8 #xml 8 '&Xml' 1 1 0 0 0 8 '&Language' 0 134217729 0 0 0 0 0 8 '&Options' 0 134217729 0 0 0 0 0 8 '&Workspace' 0 134217729 0 0 0 0 0 0 0 416 0 8 4294909145 852486 ##(Smalltalk.NullConverter)  0 0 9 0 234 256 98 2 8 #normal 1182726 ##(Smalltalk.ScintillaTextStyle)  1 0 0 1 0 0 0 0 3392 0 0 0 98 40 3424 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1639686 ##(Smalltalk.SmalltalkExpressionStyler)  1 0 0 32 202 208 98 0 234 256 98 2 8 #default 1639942 ##(Smalltalk.ScintillaMarkerDefinition)  1 1 786694 ##(Smalltalk.IndexedColor)  33554433 3602 33554471 416 8 #circle 202 208 3504 0 63 9215 0 0 0 0 3602 33554447 0 0 0 0 0 234 256 98 6 8 #literalBytes 8 '[]' 8 #specialCharacter 8 '()[]<>' 8 #literalArray 8 '()' 8 '' 3 234 256 98 2 3136 3360 0 0 0 0 3 0 234 256 98 6 8 #Notification 1509190 1 ##(Smalltalk.ScintillaIndicatorStyle)  17 416 33554437 11 32 3904 0 8 #Error 3922 21 416 33554459 3 32 3952 0 8 #Warning 3922 19 416 33554465 3 32 3984 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 11 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  3359 21 4146 461 311 416 4082 8 #contextMenu: 98 1 624 416 4082 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval)  3 1 3 416 4082 8 #isTextModified: 98 1 32 416 4082 8 #modificationEventMask: 98 1 9215 416 4082 8 #hoverTime: 98 1 1001 416 4082 8 #wordWrap: 98 1 16 416 4082 8 #margins: 98 1 98 3 984582 ##(Smalltalk.ScintillaMargin)  1 416 1 3 32 1 4578 3 416 1 1 32 67108863 4578 5 416 1 1 32 1 416 4082 8 #indentationGuides: 98 1 0 416 4082 8 #tabIndents: 98 1 16 416 4082 8 #tabWidth: 98 1 9 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 143 6 0 0 10 0 0 0 117 7 0 0 165 0 0 0] 98 0 4146 193 193 0 27 )!

setAdditionalAccelerators: anArray 
	additionalAccelerators := anArray!

setCommandQueryHandlers: anArray 
	commandQueryHandlers := anArray!

textStyles
	TextStyles isNil ifTrue: [self textStyles: self defaultTextStyles].
	^TextStyles!

textStyles: aCollectionOfScintillaTextStyles 
	"Set the text styles used to colour text in the receiver's instances. These must have the
	names used in the styler, which by default is a <SmalltalkStyler>."

	TextStyles := aCollectionOfScintillaTextStyles asOrderedCollection 
				sortUsing: (DefaultSortAlgorithm sortBlock: [:a :b | a name <= b name]).
	self primAllSubinstances do: [:each | each textStyles: self textStyles]!

textStylesAspect
	^(Aspect name: #textStyles
		presenterBlock: 
			[:p :m | 
			(ScintillaStylesCollectionPresenter createIn: p on: m)
				defaultStyle: self defaultTextStyle;
				yourself])
		beImmutable;
		yourself!

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
!SmalltalkWorkspace class categoriesFor: #actualFont!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #annotationMode!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #annotationMode:!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #autoCompleteDwell!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #autoCompleteDwell:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #defaultAdditionalAccelerators!constants!private! !
!SmalltalkWorkspace class categoriesFor: #defaultBackcolor!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultBackcolor:!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultCaretColor!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultCaretColor:!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultFont!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultFont:!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #defaultKeywordCompletions!autocompletion!private! !
!SmalltalkWorkspace class categoriesFor: #defaultTabWidth!accessing!public! !
!SmalltalkWorkspace class categoriesFor: #defaultTabWidth:!accessing!public! !
!SmalltalkWorkspace class categoriesFor: #defaultTextStyle!development!private! !
!SmalltalkWorkspace class categoriesFor: #defaultTextStyles!constants!development!public! !
!SmalltalkWorkspace class categoriesFor: #defaultUnaryReturnTypes!autocompletion!private! !
!SmalltalkWorkspace class categoriesFor: #getAdditionalAccelerators!accessing!private! !
!SmalltalkWorkspace class categoriesFor: #getCommandQueryHandlers!accessing!private! !
!SmalltalkWorkspace class categoriesFor: #icon!constants!public! !
!SmalltalkWorkspace class categoriesFor: #initialize!initializing!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionCaseInsensitive!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionCaseInsensitive:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionEnabled!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionEnabled:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionSpaceAdded!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionSpaceAdded:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionTruncating!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #isAutoCompletionTruncating:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #maxAutoCompletionListSize!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #maxAutoCompletionListSize:!accessing!autocompletion!public! !
!SmalltalkWorkspace class categoriesFor: #publishedAspects!development!public! !
!SmalltalkWorkspace class categoriesFor: #publishedEventsOfInstances!events!public! !
!SmalltalkWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !
!SmalltalkWorkspace class categoriesFor: #setAdditionalAccelerators:!accessing!private! !
!SmalltalkWorkspace class categoriesFor: #setCommandQueryHandlers:!accessing!private! !
!SmalltalkWorkspace class categoriesFor: #textStyles!accessing!public! !
!SmalltalkWorkspace class categoriesFor: #textStyles:!accessing!public! !
!SmalltalkWorkspace class categoriesFor: #textStylesAspect!development!private! !
!SmalltalkWorkspace class categoriesFor: #wordWrap!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #wordWrap:!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #wrapIndentMode!accessing!options!public! !
!SmalltalkWorkspace class categoriesFor: #wrapIndentMode:!accessing!options!public! !

