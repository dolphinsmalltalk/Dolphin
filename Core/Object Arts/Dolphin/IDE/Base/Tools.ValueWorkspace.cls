"Filed out from Dolphin Smalltalk"!

Tools.SmalltalkWorkspace
	subclass: #'Tools.ValueWorkspace'
	instanceVariableNames: 'textModel'
	classVariableNames: 'ValueIsSelfCookie'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.ValueWorkspace guid: (Core.GUID fromString: '{87b4c6c9-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.ValueWorkspace comment: 'ValueWorkspace is a <valuePresenter> for displaying the contents of a <valueModel> using a <ScintillaView>. ValueWorkspace allows Smalltalk expressions to be entered and, when Accepted,  the result of the evaluation is stored back to the model. ValueWorkspace is used as a fundamental part of the PublishedAspectInspector.

Note that this is a somewhat unusual MVP triad; the ValueWorkspace model is not connected directly to the view. Instead, the view is redirected (via #viewModel) to another model that holds the textual rendition of the actual model.

Instance Variables:
	textModel		<ValueHolder> holding the textual rendition of the model''s value.

'!
!Tools.ValueWorkspace categoriesForClass!MVP-Presenters! !
!Tools.ValueWorkspace methodsFor!

accept
	"Accept changes to the receiver by evaluating it, and setting the result into the associated
	model. If there is no selection, then the entire contents of the workspace are accepted."

	<commandQuery: #canAccept>
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
		wordWrap: false; 
		canHScroll: false;
		selectAll!

canAccept
	^self model canSet!

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
	^2 seconds!

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
!Tools.ValueWorkspace categoriesForMethods!
accept!commands-actions!public! !
beSingleLineMode!public! !
canAccept!commands-queries!private!testing! !
displayValue!accessing!private! !
errorBubbleTimeout!constants!private! !
errorLocation!private! !
evaluationContext!accessing!public! !
initialize!initializing!private! !
isSingleLineMode!public! !
model:!accessing!public! !
onValueChanged!event handling!private! !
showCompileErrorBubble:!private! !
showErrorBubble:caption:!private! !
showEvaluationErrorBubble:!private! !
unableToDisplayVariableErrorFormatString!constants!private! !
value!accessing!public! !
value:!accessing!public! !
viewModel!accessing!private! !
!

Tools.ValueWorkspace methodProtocol: #valuePresenter attributes: #(#readOnly) selectors: #(#value #value:)!

!Tools.ValueWorkspace class methodsFor!

defaultModel
	"Answer a default model to be assigned to the receiver when it
	is initialized."

	^nil asValue!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ValueIsSelfCookie := Object new
				beImmutableObject;
				yourself!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.Scintilla.ScintillaView} 38 #{Core.Array} 56 nil nil 50 2 8 1411453252 1 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 518 #{Graphics.ThemeColor} #smalltalkWorkspace nil 21 2886 4 #{UI.Menu} nil true 50 13 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #accept 8 '&Accept' 1 1 nil nil nil 326 1 #{UI.DividerMenuItem} 4097 210 nil true 50 10 258 1 290 #undo 8 '&Undo' 1 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'EditUndo.ico' 838 1 #{External.ResourceLibrary} 8 'dolphindr8.dll' 65541 nil nil nil 338 4097 258 1 290 #cutSelection 8 'Cu&t' 1 1 450 nil true 482 8 'EditCut.ico' 544 65541 nil nil nil 258 1 290 #copySelection 8 '&Copy' 1 1 450 nil true 482 8 'EditCopy.ico' 544 65541 nil nil nil 258 1 290 #pasteClipboard 8 '&Paste' 1 1 450 nil true 482 8 'EditPaste.ico' 544 65541 nil nil nil 258 1 290 #clearSelection 8 'De&lete' 1 1 450 nil true 482 8 'EditClear.ico' 544 65541 nil nil nil 338 4097 258 1 290 #reformatSource 8 'Re&format' 1 1 nil nil nil 338 4097 258 1 290 #selectAll 8 '&Select All' 1 1 nil nil nil 8 '&Edit' nil 134217729 nil nil nil nil nil 210 nil true 50 10 258 1 290 #inspectWorkspacePool 8 '&Variables' 1 1 nil nil nil 258 1 290 #cloneNew 8 '&Clone' 1 1 450 nil true 482 8 'SmalltalkWorkspace.ico' 544 65541 nil nil nil 338 4097 258 1 290 #toggleAutoCompletion 8 '&Auto-complete' 1 1 nil nil nil 258 1 290 #toggleIndentationGuides 8 'Indentation &Guides' 1 1 nil nil nil 258 1 290 #toggleLineNumbers 8 'Line N&umbers' 1 1 nil nil nil 258 1 290 #toggleLineEndings 8 'Line &Endings' 1 1 2374 2 #{Graphics.TextTileIcon} $¶ 8 'Arial' nil nil nil nil 1 nil nil nil nil 258 1 290 #toggleStyling 8 '&Syntax Coloring' 1 1 nil nil nil 258 1 290 #toggleWhitespace 8 'W&hitespace' 1 1 nil nil nil 258 1 290 #toggleWordWrap 8 '&Word Wrap' 1 1 nil nil nil 8 'Wor&kspace' nil 134217729 nil nil nil nil nil 338 4097 258 1 290 #browseIt 8 'Bro&wse It' 1 1 450 nil true 482 8 'ClassBrowserShell.ico' 544 65541 nil nil nil 258 1 290 #displayIt 8 '&Display It' 1 1 450 nil true 482 8 'DisplayIt.ico' 544 65541 nil nil nil 258 1 290 #printIt 8 '&Print It' 1 1 450 nil true 482 8 'PrintIt.ico' 544 65541 nil nil nil 258 1 290 #evaluateIt 8 'E&valuate It' 1 1 450 nil true 482 8 'EvaluateIt.ico' 544 65541 nil nil nil 258 1 290 #inspectIt 8 '&Inspect It' 1 1 450 nil true 482 8 'InspectIt.ico' 544 65541 nil nil nil 258 1 290 #debugIt 8 'Deb&ug It' 1 1 450 nil true 482 8 'Debugger.ico' 544 65541 nil nil nil 338 4097 210 nil true 50 2 258 2097153 290 #browseDefinitions 8 'Defi&nitions…' 1 1 nil nil nil 258 1 290 #browseReferences 8 '&References…' 1 1 nil nil nil 8 '&Browse' nil 1 nil nil nil nil nil 8 '&Workspace' nil 134217729 nil nil nil nil nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil 9 #focusLost nil nil nil nil 550 #{Core.IdentityDictionary} 2 #callTip 3142 1 #{UI.Scintilla.TextStyle} 77 6 #{Graphics.Color} #gray 2578 #white 1 nil nil nil nil #callTip nil nil nil #normal 2546 1 nil nil 1 nil nil nil nil #normal nil nil nil nil 1286 #{Tools.SmalltalkExpressionStyler} 1 nil nil false 550 #{Core.OrderedCollection} 0 2514 1 #default 3142 2 #{UI.Scintilla.MarkerDefinition} 1 nil nil nil 32 #circle nil nil nil nil nil nil 294 #{Core.IdentitySet} 0 nil 550 #{Core.LookupTable} 0 nil nil nil 2786 2 23 178 #workspaceSelection 81 2578 #windowText nil nil 262 #{UI.Scintilla.NullScintillaLibrary} nil 65 nil nil 2514 3 #literalArray 8 '()' #literalBytes 8 '[]' #specialCharacter 8 '()[]<>' nil 3 2514 1 #container 2528 nil nil nil nil #{Core.Utf8String} nil 2514 0 nil nil 2514 3 #Error 2546 1031 2578 #firebrick 2578 #floralWhite 1 nil nil nil nil #Error nil nil nil #Notification 2546 1029 nil 2578 #gainsboro 1 nil nil nil nil #Notification nil nil nil #Warning 2546 1027 2578 #darkGoldenrod 2578 #ivory 1 nil nil nil nil #Warning nil nil nil nil nil nil 262 #{Core.MessageSequence} 50 8 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 3234 221 41 32 3186 #sciSetMouseDwellTime: 8 #(500) 32 3186 #wordWrap: 8 #(true) 32 3186 #margins: 50 1 50 3 2118 3 #{UI.Scintilla.Margin} 1 32 nil 3 nil nil 5 nil 3394 3 32 nil nil nil 67108863 5 nil 3394 5 32 nil nil nil nil 5 nil 32 3186 #tabWidth: 8 #(4) 32 3186 #maxCompletionListHeight: 8 #(9) 32 3186 #hasAdditionalSelectionTyping: 8 #(true) 32 3186 #sciSetSelectionLayer: 8 #(1) 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 109 12 0 0 30 0 0 0] 8 #() 3234 193 193 nil 45)! !
!Tools.ValueWorkspace class categoriesForMethods!
defaultModel!models!public! !
initialize!initializing!private! !
resource_Default_view!public!resources-views! !
!

