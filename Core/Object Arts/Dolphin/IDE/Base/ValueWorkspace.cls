"Filed out from Dolphin Smalltalk 7"!

SmalltalkWorkspace subclass: #ValueWorkspace
	instanceVariableNames: 'textModel'
	classVariableNames: 'ValueIsSelfCookie'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ValueWorkspace guid: (GUID fromString: '{87b4c6c9-026e-11d3-9fd7-00a0cc3e4a32}')!
ValueWorkspace comment: 'ValueWorkspace is a <valuePresenter> for displaying the contents of a <valueModel> using a <ScintillaView>. ValueWorkspace allows Smalltalk expressions to be entered and, when Accepted,  the result of the evaluation is stored back to the model. ValueWorkspace is used as a fundamental part of the PublishedAspectInspector.

Note that this is a somewhat unusual MVP triad; the ValueWorkspace model is not connected directly to the view. Instead, the view is redirected (via #viewModel) to another model that holds the textual rendition of the actual model.

Instance Variables:
	textModel		<ValueHolder> holding the textual rendition of the model''s value.

'!
!ValueWorkspace categoriesForClass!Development!MVP-Presenters! !
!ValueWorkspace methodsFor!

accept
	"Accept changes to the receiver by evaluating it, and setting the result into the associated
	model. If there is no selection, then the entire contents of the workspace are accepted."

	| evaluation |
	self displayValue isEmpty 
		ifTrue: 
			["If we have no contents justr leave well alone"
			^true].
	self view hasSelection 
		ifFalse: 
			["We assume that the whole text is to be evaluated. In this case, if the
			 text has not been changed we can ignore the accept and answer true. This
			 will allow the user to just hit enter on some store strings that don't
			 compile."
			self view isModified ifFalse: [^true].
			self view selectAll].
	evaluation := 
			[self evaluateItIfFail: 
					[self showCompileErrorBubble: errorModel value.
					^false]] 
					on: Error
					do: 
						[:x | 
						self showEvaluationErrorBubble: x.
						^false].
	self value: evaluation.
	^true!

beSingleLineMode
	"Set the receiver into single line mode"

	(self view)
		wantReturn: false;
		selectAll!

displayValue
	| value |
	value := self value.
	^[value printString] on: Error
		do: 
			[:ex | 
			self unableToDisplayVariableErrorFormatString 
				expandMacrosWith: 'self'
				with: value class
				with: ex description]!

errorBubbleTimeout
	^2000!

errorLocation
	"Answers the screen coordnates of where the error can be found. Typically this is the base of the caret location in our associated view"

	^self view caretScreenCoordinates + (0 @ self view actualFont pixelSize)!

evaluationContext
	"Answers the evaluation context for this workspace which is in fact the model's value"

	| ctx |
	ctx := super evaluationContext.
	^ctx == ValueIsSelfCookie ifTrue: [self value] ifFalse: [ctx]!

initialize
	"Private - Initialize the receiver's instance variables."

	super initialize.
	textModel := String new asValue.
	self evaluationContext: ValueIsSelfCookie!

isSingleLineMode
	"Answer true if the receiver will only manage a single line of text"

	^self view wantReturn not!

model: aValueModel 
	"Set the model of the receiver to be a value model on anObject."

	super model: aValueModel.
	aValueModel 
		when: #valueChanged
		send: #onValueChanged
		to: self.
	self onValueChanged!

onValueChanged
	"Private - The receiver's model has changed. Transfer the text representation of the new value to the
	textModel"

	textModel value: self displayValue!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the <CommandQuery>
	argument."

	| cmd |
	cmd := aCommandQuery commandSymbol.
	cmd == #accept 
		ifTrue: 
			[aCommandQuery isEnabled: self model canSet.
			^true].
	^super queryCommand: aCommandQuery!

showCompileErrorBubble: anError 
	self showErrorBubble: anError displayString caption: 'Syntax error'!

showErrorBubble: message caption: caption 
	(MessageBubble new)
		font: (Font name: 'Arial' pointSize: 10);
		timeout: self errorBubbleTimeout;
		isCentered: true;
		position: self errorLocation;
		caption: caption;
		errorMsg: message!

showEvaluationErrorBubble: anError 
	self showErrorBubble: anError displayString caption: 'Evaluation error'!

unableToDisplayVariableErrorFormatString
	"Private - Answer the format string used to construct the error message text to be displayed
	in place of a variable value when a variable is selected that cannot be printed."

	^'an invalid <2p> [<3s>]<n><n>Evaluate the following expression to debug:<n><t>self printString'!

value
	"Answer the model value of the receiver. Any view changes may first need to be flushed"

	self view notNil ifTrue: [self view updateModel].
	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject"

	self model value: anObject.
!

viewModel
	"Private - Answer the model that is to be connected to the view. It is actually
	connected to the receiver's textModel - not the receiver's value model"

	^textModel! !
!ValueWorkspace categoriesFor: #accept!commands!public! !
!ValueWorkspace categoriesFor: #beSingleLineMode!public! !
!ValueWorkspace categoriesFor: #displayValue!accessing!private! !
!ValueWorkspace categoriesFor: #errorBubbleTimeout!constants!private! !
!ValueWorkspace categoriesFor: #errorLocation!private! !
!ValueWorkspace categoriesFor: #evaluationContext!accessing!public! !
!ValueWorkspace categoriesFor: #initialize!initializing!private! !
!ValueWorkspace categoriesFor: #isSingleLineMode!public! !
!ValueWorkspace categoriesFor: #model:!accessing!public! !
!ValueWorkspace categoriesFor: #onValueChanged!event handling!private! !
!ValueWorkspace categoriesFor: #queryCommand:!commands!private! !
!ValueWorkspace categoriesFor: #showCompileErrorBubble:!private! !
!ValueWorkspace categoriesFor: #showErrorBubble:caption:!private! !
!ValueWorkspace categoriesFor: #showEvaluationErrorBubble:!private! !
!ValueWorkspace categoriesFor: #unableToDisplayVariableErrorFormatString!constants!private! !
!ValueWorkspace categoriesFor: #value!accessing!public! !
!ValueWorkspace categoriesFor: #value:!accessing!public! !
!ValueWorkspace categoriesFor: #viewModel!accessing!private! !

ValueWorkspace methodProtocol: #valuePresenter attributes: #(#readOnly) selectors: #(#value #value:)!

!ValueWorkspace class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ValueIsSelfCookie := (Object new)
				isImmutable: true;
				yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScintillaView) 34 50 nil nil 34 2 8 1411453252 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 524550 ##(Smalltalk.ColorRef) 8 4278190080 nil 21 265030 4 ##(Smalltalk.Menu) nil true 34 17 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #accept 18 7 38 65 99 99 101 112 116 1 1 nil nil nil 983366 1 ##(Smalltalk.DividerMenuItem) 4097 594 nil true 34 9 642 1 674 #undo 18 5 38 85 110 100 111 1 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 18 12 69 100 105 116 85 110 100 111 46 105 99 111 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 18 14 100 111 108 112 104 105 110 100 114 55 46 100 108 108 nil nil nil 722 4097 642 1 674 #cutSelection 18 4 67 117 38 116 1 1 834 nil true 880 18 11 69 100 105 116 67 117 116 46 105 99 111 928 nil nil 642 1 674 #copySelection 18 5 38 67 111 112 121 1 1 834 nil true 880 18 12 69 100 105 116 67 111 112 121 46 105 99 111 928 nil nil 642 1 674 #pasteClipboard 18 6 38 80 97 115 116 101 1 1 834 nil true 880 18 13 69 100 105 116 80 97 115 116 101 46 105 99 111 928 nil nil 642 1 674 #clearSelection 18 7 68 101 38 108 101 116 101 1 1 834 nil true 880 18 13 69 100 105 116 67 108 101 97 114 46 105 99 111 928 nil nil 642 1 674 #reformatSource 18 9 82 101 38 102 111 114 109 97 116 1 1 nil nil nil 722 4097 642 1 674 #selectAll 18 11 38 83 101 108 101 99 116 32 65 108 108 1 1 nil nil nil 18 5 38 69 100 105 116 nil 134217729 nil nil nil nil nil 642 1 674 #clear 18 6 67 108 101 97 38 114 1 1 nil nil nil 722 4097 642 1 674 #browseIt 18 10 66 114 111 38 119 115 101 32 73 116 1 1 834 nil true 880 18 21 67 108 97 115 115 66 114 111 119 115 101 114 83 104 101 108 108 46 105 99 111 928 nil nil 642 1 674 #displayIt 18 11 38 68 105 115 112 108 97 121 32 73 116 1 1 834 nil true 880 18 13 68 105 115 112 108 97 121 73 116 46 105 99 111 928 nil nil 642 1 674 #evaluateIt 18 12 69 38 118 97 108 117 97 116 101 32 73 116 1 1 834 nil true 880 18 14 69 118 97 108 117 97 116 101 73 116 46 105 99 111 928 nil nil 642 1 674 #inspectIt 18 11 38 73 110 115 112 101 99 116 32 73 116 1 1 834 nil true 880 18 13 73 110 115 112 101 99 116 73 116 46 105 99 111 928 nil nil 642 1 674 #debugIt 18 9 68 101 98 38 117 103 32 73 116 1 1 834 nil true 880 18 12 68 101 98 117 103 103 101 114 46 105 99 111 928 nil nil 722 4097 642 1 674 #chooseEvaluationPools 18 9 38 80 111 111 108 115 46 46 46 1 1 834 nil true 880 18 20 83 121 115 116 101 109 68 105 99 116 105 111 110 97 114 121 46 105 99 111 928 nil nil 642 1 674 #inspectWorkspacePool 18 10 86 97 114 105 97 98 38 108 101 115 1 1 nil nil nil 722 4097 594 nil true 34 2 642 2097153 674 #browseDefinitions 18 15 68 101 102 105 38 110 105 116 105 111 110 115 46 46 46 1 1 nil nil nil 642 1 674 #browseReferences 18 14 38 82 101 102 101 114 101 110 99 101 115 46 46 46 1 1 nil nil nil 18 7 38 66 114 111 119 115 101 nil 1 nil nil nil nil nil 722 4097 594 nil true 34 9 642 1 674 #toggleAutoCompletion 18 14 38 65 117 116 111 45 99 111 109 112 108 101 116 101 1 1 nil nil nil 642 1 674 #toggleIndentationGuides 18 19 73 110 100 101 110 116 97 116 105 111 110 32 38 71 117 105 100 101 115 1 1 nil nil nil 642 1 674 #toggleLineEndings 18 13 76 105 110 101 32 38 69 110 100 105 110 103 115 1 1 nil nil nil 642 1 674 #toggleLineNumbers 18 13 76 105 110 101 32 78 38 117 109 98 101 114 115 1 1 nil nil nil 642 1 674 #toggleStyling 18 16 38 83 121 110 116 97 120 32 67 111 108 111 114 105 110 103 1 1 nil nil nil 642 1 674 #toggleWhitespace 18 11 87 38 104 105 116 101 115 112 97 99 101 1 1 nil nil nil 642 1 674 #toggleWordWrap 18 10 38 87 111 114 100 32 87 114 97 112 1 1 nil nil nil 722 4097 594 nil true 34 2 642 1 674 459270 ##(Smalltalk.Message) #language: 8 #(#container) 18 10 38 83 109 97 108 108 116 97 108 107 1 1 nil nil nil 642 1 674 2658 #language: 8 #(#xml) 18 4 38 88 109 108 1 1 nil nil nil 18 9 38 76 97 110 103 117 97 103 101 nil 134217729 nil nil nil nil nil 18 8 38 79 112 116 105 111 110 115 nil 134217729 nil nil nil nil nil 18 10 38 87 111 114 107 115 112 97 99 101 nil 134217729 nil nil nil nil nil nil nil 416 nil 8 4294912177 852486 ##(Smalltalk.NullConverter) nil nil 9 nil 170 192 34 4 #normal 1182790 1 ##(Smalltalk.ScintillaTextStyle) 1 nil nil 1 nil nil nil nil #normal nil nil nil #callTip 2930 77 786694 ##(Smalltalk.IndexedColor) 33554457 2978 33554471 1 nil nil nil nil #callTip nil nil nil 34 40 2944 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 1639686 ##(Smalltalk.SmalltalkExpressionStyler) 1 nil nil false 138 144 8 #() 170 192 34 2 #default 1641542 1 ##(Smalltalk.ScintillaMarkerDefinition) 1 nil nil nil 416 #circle nil nil nil nil nil nil 138 ##(Smalltalk.IdentitySet) 3088 nil 170 176 3088 9215 nil nil nil nil 2978 33554447 nil nil 65 nil nil 170 192 34 6 #literalBytes 18 2 91 93 #specialCharacter 18 6 40 41 91 93 60 62 #literalArray 18 2 40 41 18 0 3 170 192 34 2 #container 2896 nil nil nil nil 3 nil 170 192 3088 nil nil 170 192 34 6 #Notification 2930 1029 nil 196934 1 ##(Smalltalk.RGB) 31185883 1 nil nil nil nil #Notification nil nil nil #Warning 2930 1027 3410 60239 3410 31326207 1 nil nil nil nil #Warning nil nil nil #Error 2930 1031 3410 335 3410 31317503 1 nil nil nil nil #Error nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 10 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 3650 501 41 416 3602 #contextMenu: 34 1 608 416 3602 #modificationEventMask: 8 #(4607) 416 3602 #hoverTime: 8 #(500) 416 3602 #caretPeriod: 8 #(530) 416 3602 #wordWrap: 8 #(true) 416 3602 #margins: 34 1 34 3 985158 2 ##(Smalltalk.ScintillaMargin) 1 416 1 3 nil nil 5 nil 3906 3 416 1 nil nil 67108863 5 nil 3906 5 416 1 nil nil nil 5 nil 416 3602 #tabWidth: 8 #(4) 416 3602 #maxCompletionListHeight: 8 #(9) 416 3602 #sciSetCodePage: 8 #(65001) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 121 8 0 0 30 0 0 0] 8 #() 3650 193 193 nil 29 )! !
!ValueWorkspace class categoriesFor: #defaultModel!models!public! !
!ValueWorkspace class categoriesFor: #initialize!initializing!private! !
!ValueWorkspace class categoriesFor: #resource_Default_view!public!resources-views! !

