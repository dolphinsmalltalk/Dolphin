"Filed out from Dolphin Smalltalk"!

Presenter subclass: #InplaceTextEditor
	instanceVariableNames: 'textRectangle minExtent textMetrics confirmed ownerView validationBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

InplaceTextEditor guid: (GUID fromString: '{772412aa-7ca7-476c-b034-e5397984a86d}')!

InplaceTextEditor comment: 'InplaceTextEditor is a special kind of "prompter" that appears as an in-place text edit control over the text being edited. It behaves like a modal dialog, in that control is not returned to the called until the in-place edit has been committed or cancelled. This makes for an easier programming model than the alternative of a modeless view shown from the activating command, and delayed response to events when a modeless view is cancelled/committed to complete the command. However InplaceTextEditor is not actually a true dialog, because if it were then when shown it would have the undesirable effect of de-activating the owning top-level window while the editor is open.

The in-place text editor is shown with an initial size that is sufficient to display the existing edited text (with the edit controls adornments such as borders and margins), plus sufficient extra space for any character in the current font to be typed. As more characters are typed, the edit box grows dynamically. If characters are deleted then the edit control shrinks, but never below the initial size.

The edit can be committed by pressing the ENTER key, or by clicking over some other window so the control loses focus. This causes the InplaceTextEditor window to close, and control is returned to the caller with a return value that is the edited text. The edit can be cancelled by pressing the ESCape key, in which case the InplaceTextEditor window is closed, and control is returned with a nil return value.

A validation block can be specified which controls whether the ability to commit an edit is enabled. If the validation block answers false, then the ENTER key will result in an error beep, and clicking elsewhere so the in-place edit loses focus (and is therefore closed) will be treated as cancelling the edit rather than committing it. Just like a normal <Prompter> the initial value has no special significance, and whether or not the original value can be committed without making any changes is entirely controlled by the validation block. By default the validation block will accept any input.

Instance Variables:
	textRectangle		<Rectangle>. The rectangle of the text being edited, specified in the co-ordinates of the ownerView.
	minExtent			<Point>. The minimum extent to which the in-place edit control is allowed to shrink. Initialised to the initial size required to allow editing of the original text.
	maxCharWidth		<integer>. The maximm width of a character from the font of the text being edited.
	confirmed			<boolean>. Whether or not the edit has been comitted.
	ownerView		<View>. The view for which text is being edited in place. Defaults to the view with focus.
	validationBlock		<monadicValuable> used to validate the input when a commit action is attempted.
'!

!InplaceTextEditor categoriesForClass!MVP-Presenters! !

!InplaceTextEditor methodsFor!

answer
	"Answer the model if the receiver was confirmed (with #apply, #ok) or nil otherwise"

	^self isConfirmed ifTrue: [self model value]!

apply
	"Apply the changes cached in the receiver back to the original model. This can be used to
	dynamically see the effect of the changes without closing the dialog. More often it is sent
	by the #ok method just before closing the associated view."

	| focus |

	"First ensure that any changes cached in the view with focus (if any) are flushed"
	focus := View focus.
	focus isNil ifFalse: [focus updateModel].

	self model apply.
	confirmed := true.!

bufferClass
	^ValueBuffer!

bufferedModelFor: aSubjectValueModel 
	"Private - Answers a buffer suitable for the receiver on aSubjectValueModel. This will become the
	actual model to which the receiver is bound."

	^(self bufferClass subject: aSubjectValueModel asValue) comparisonPolicy: SearchPolicy equality!

cancel
	"Close the receiver without applying the changes back to the original model"

	self view isTextModified: false.
	self view close!

createSchematicWiring
	self 
		when: #focusLost
		send: #onFocusLost
		to: self.
	self 
		when: #textChanged
		send: #onTextChanged
		to: self.
	^super createSchematicWiring!

createView: aResourceNameString 
	"Private - Creates and connects a view for the receiver from the resource identified by
	aResourceNameString. Answers the new view created"

	| contextView |
	contextView := parentPresenter isNil ifTrue: [View focus] ifFalse: [parentPresenter view].
	self view: (self class loadViewResource: aResourceNameString inContext: contextView).
	^self view!

findDetails
	^nil!

font: aFont
	"Set the font to be used in the editor. This should generally match the font of the owner view."

	self view font: aFont.
	textMetrics := nil!

implicitBorder
	"Private - Widths of the implicit border on an edit control that has to be added to the calculated extent, plus some space for extra typing."

	^0 @ 1 corner: self textMetrics tmMaxCharWidth @ 1!

initialize
	"Private - Initialize the receiver"

	super initialize.
	self ownerView: View focus.
	confirmed := false.
	textRectangle := 0@0 extent: 100@20.
	validationBlock := [:replyString | true]!

isConfirmed
	"Answer true if the receiver has been confirmed and changes have been applied to the
	associated model. Can be sent after the in-place edit has closed to determine if the edit
	was committed rather than cancelled."

	^confirmed!

isInputValid
	^(self validationBlock value: self view text) == true!

model: aValueModel 
	"Set the model of the receiver to be aValueModel. Register with it's #valueChanged event"

	| actualModel |
	actualModel := aValueModel notNil ifTrue: [self bufferedModelFor: aValueModel].
	super model: actualModel.
	aValueModel 
		when: #valueChanged
		send: #onValueChanged
		to: self!

ok
	"Close the receiver and apply the changes cached in the receiver back to the model"

	self apply.
	self view close.
!

onFocusLost
	"Private - If the user clicks outside the in-place edit box, then treat as a committed edit
	if the value has changed and is valid, otherwise treat as cancel."

	"If focus is lost because the window is closing then don't do anything"

	self view isWindowVisible ifTrue: [self isInputValid ifTrue: [self ok] ifFalse: [self cancel]]!

onGetCursor: aSymbol 
	"The named area of the view associated with the receiver has been hit. Answer the
	appropriate mouse cursor or nil to accept the default."

	^Cursor iBeam!

onKeyTyped: aKeyEvent 
	aKeyEvent code == VK_ESCAPE 
		ifTrue: 
			[self commandPolicy route: (CommandDescription command: #cancel).
			^0].
	aKeyEvent code == VK_RETURN 
		ifTrue: 
			[self commandPolicy route: (CommandDescription command: #ok).
			^0].
	^super onKeyTyped: aKeyEvent!

onTextChanged
	self resizeToFit: view plainText!

onValueChanged
	"The value held by the receiver's model has changed. The default is to trigger a
	#valueChanged event off the receiver"

	self trigger: #valueChanged!

onViewOpened
	super onViewOpened.
	self setInitialFocus!

ownerView
	^ownerView!

ownerView: aView 
	ownerView := aView!

pasteClipboard
	"Paste the clipboard text into the receiver's edit box."

	"Implementation note: We have to resize the control in advance to be of sufficient size to receive the pasted text, and any existing text retained, or it may be truncated."

	| insertionRange pastedText currentText newText |
	currentText := view plainText.
	insertionRange := view selectionRange.
	pastedText := Clipboard current getTextOrEmpty.
	newText := (currentText copyFrom: 1 to: insertionRange start - 1) , pastedText
				, (currentText copyFrom: insertionRange stop + 1 to: currentText size).
	self resizeToFit: newText.
	view pasteClipboard!

queryCommand: aCommandQuery 
	"Private - Enters details about a potential command for the receiver into the
	<CommandQuery>."

	aCommandQuery commandSymbol == #ok 
		ifTrue: 
			[aCommandQuery isEnabled: self isInputValid.
			^true].
	^super queryCommand: aCommandQuery!

requiredExtent: aString
	| min preferred borders |
	borders := self implicitBorder.
	preferred := (view extentForText: aString)
				+ ((borders left + borders right) @ (borders top + borders bottom)).
	min := minExtent ifNil: [minExtent := preferred].
	^min max: preferred!

resizeToFit: aString
	"Private - Adjust the width of the receiver to fit the text, allowing space for extra typing."

	| extent requiredExtent |
	extent := view extent.
	requiredExtent := self requiredExtent: aString.
	extent x: requiredExtent x.
	view extent: extent!

runModalInProcessLoop
	^SessionManager inputState loopWhile: [self isOpen]!

setInitialFocus
	self view setFocus!

show
	| rect |
	self view
		selectAll;
		setMarginWidths: #(0 0).
	"Adjust the position of the dialog to be over the edited text."
	rect := self view calcRectangleFromClientRectangle: textRectangle.
	minExtent := rect extent.
	self view
		rectangle: (rect expandBy: self implicitBorder);
		layout;
		show!

showModal
	"Show the receiver's view as a modal 'dialog'. Answer the revised text, or the original text if cancelled."

	self showModalView.
	^self answer!

showModalView
	
	[self show.
	self runModalInProcessLoop] ensure: [self view basicDestroy]!

textMetrics
	textMetrics
		ifNil: 
			[| canvas |
			canvas := self view canvas.
			canvas font: self view actualFont.
			textMetrics := canvas textMetrics.
			canvas free].
	^textMetrics!

textRectangle: aRectangle 
	"Set the rectangle of the text being edited in-place. N.B. The Rectangle is expected to be in the co-ordinates of the owner view (the parent with focus on whose behalf the receiver is to edit text)."

	textRectangle := aRectangle!

validationBlock
	^validationBlock!

validationBlock: aBlock 
	"Set the <monadicValuable> used to validate the user's reply. The valuable is passed the
	current reply text as its argument, and is expected to answer whether it is valid. The
	ability to commit the edit is not enabled until the validationBlock answers true."

	validationBlock := aBlock!

value
	"Answer the model value of the receiver"

	^self model value!

value: anObject
	"Set the model value of the receiver to be anObject. The change will not be flushed back to
	the original subject model until #apply is received"

	self model value: anObject.! !

!InplaceTextEditor categoriesForMethods!
answer!accessing!public! !
apply!commands!public! !
bufferClass!accessing!private! !
bufferedModelFor:!accessing!private! !
cancel!commands!public! !
createSchematicWiring!initializing!public! !
createView:!operations!private! !
findDetails!public!searching & replacing! !
font:!initializing!public! !
implicitBorder!constants!private! !
initialize!initializing!private! !
isConfirmed!public!testing! !
isInputValid!private!testing! !
model:!accessing!public! !
ok!commands!public! !
onFocusLost!event handling!private! !
onGetCursor:!event handling!public! !
onKeyTyped:!event handling!private! !
onTextChanged!event handling!private! !
onValueChanged!event handling!public! !
onViewOpened!event handling!private! !
ownerView!accessing!public! !
ownerView:!accessing!public! !
pasteClipboard!commands!public! !
queryCommand:!commands!private! !
requiredExtent:!helpers!private! !
resizeToFit:!helpers!private! !
runModalInProcessLoop!helpers!private! !
setInitialFocus!operations!public! !
show!helpers!private! !
showModal!public!realizing/unrealizing! !
showModalView!helpers!private! !
textMetrics!helpers!private! !
textRectangle:!initializing!public! !
validationBlock!accessing!public! !
validationBlock:!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
!

!InplaceTextEditor class methodsFor!

createOn: aValueHolder 
	^(super createOn: aValueHolder)
		onViewOpened;
		yourself!

defaultModel
	^String new!

icon
	"Answers an Icon that can be used to represent this class"

	^TextEdit icon!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.TextEdit) 34 16 nil nil 34 2 8 1149304832 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #window nil 1543 nil nil nil 416 nil 8 1759000288 852486 ##(Smalltalk.NullConverter) nil 8 '' 65 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[127 7 0 0 10 0 0 0 222 7 0 0 30 0 0 0] 193 448 nil 416 706 #text: 34 1 8 'Text to be edited' 416 706 #setMarginWidths: 34 1 8 #(2 2) 416 3 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!InplaceTextEditor class categoriesForMethods!
createOn:!public! !
defaultModel!models!public! !
icon!constants!public! !
resource_Default_view!public!resources-views! !
!

