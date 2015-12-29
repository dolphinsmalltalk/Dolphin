"Filed out from Dolphin Smalltalk X6"!

AXValueConvertingControlSite subclass: #MaskedEdit
	instanceVariableNames: 'meFlags'
	classVariableNames: 'HadErrorsMask ModifiedMask TextModifiedMask'
	poolDictionaries: 'MSMaskConstants'
	classInstanceVariableNames: ''!
MaskedEdit guid: (GUID fromString: '{14C01E05-0749-4E6C-A0A4-EE98E6342079}')!
MaskedEdit comment: 'MaskedEdit is an Active-X control which is a more sophisticated form of TextEdit control. It has the ability to constrain input to that which matches a user-specified mask, for example only dates of a certain format. This class depends on having the MSMASK control installed, which it commonly is, especially if a Microsoft Visual Studio product (such as VB) is installed on the machine.

If this view class is used in an application then it is necessary to distribute MSMASK32.OCX. Note that this Active-X control is licensed. A Microsoft Installer merge module for the control is available (MSMASK32.MSM).
'!
!MaskedEdit categoriesForClass!MVP-Views! !
!MaskedEdit methodsFor!

apply
	"Apply the changes made to the edit to the receivers model (but only
	it the text is valid against the input mask). Answer whether any update 
	actually occurred to the model."

	| modified |
	modified := self isTextModified and: [self isTextValid].
	modified ifTrue: [self updateModel].
	^modified!

caretPosition
	"Answer the insertion cursor position, as the number of characters from the start
	of the receivers text"

	^self selectionRange start	"Use #start to avoid bounds error if empty"!

defaultProgId
	"Answer the 'prog id' of the Active-X control to be hosted in the receiver by default (i.e. initially
	and when no other prog id is specified)."

	^'MSMask.MaskEdBox'!

defaultText
	"Answer the default text that is used to populate the edit control initially."
	
	^self controlDispatch value!

defaultText: aString
	"Set the default text that is used to populate the edit control initially."
	
	self controlDispatch value: aString!

displayValue
	"Private - Answers the displayed contents of the receiver.
	If the input text is not valid then answer nil."
	
	^self isTextValid ifTrue: [self text]!

displayValue: aString
	"Private - Set the displayed contents of the receiver from the <readableString> argument."
	
	[self text: aString.
	"The control will have sent the #Changed event in response to the above programmatic change"
	self isTextModified: false]
		on: HRESULTError
		do: [:e | 
			e hresult statusCode = mskInvalidPropertyValue
				ifTrue: [self hadErrors: true]
				ifFalse: [e pass]]!

firesControlEvents: aBoolean
	"Set whether the receiver will sink events from the control's default source dispinterface
	and trigger corresponding Dolphin events off the presenter.
	In this case events must not be disabled."

	aBoolean ifFalse: [self error: 'Events are required for views own implementation']!

format
	"Answer the format for displaying numbers, dates, times and text when the control
	does not have focus. See the Masked Edit Control help for further details." 

	^self controlDispatch format!

format: aString
	"Set the format for displaying numbers, dates, times and text when the control
	does not have focus. See the Masked Edit Control help for further details. "

	self controlDispatch format: aString!

formattedText
	"Answer the string displayed in the masked edit control when the control doesn''t have the focus."
	
	^self controlDispatch formattedText!

formattedText: aString
	"Set the string displayed in the masked edit control when the control doesn''t have the focus."
	
	self controlDispatch formattedText: aString!

hadErrors
	"Answer whether the receiver has been informed that the input text does
	not match the mask since the last time text was changed. The validation error
	event is sent when the control loses focus, or when an invalid character
	is entered. We reset this flag each time the control reports that the text has
	changed (since it may potentially be valid after the change)."

	^meFlags allMask: HadErrorsMask!

hadErrors: aBoolean
	"Private - Set the flag that indicates that validation errors have been
	reported by the control."

	meFlags := meFlags mask: HadErrorsMask set: aBoolean!

hasSelection
	"Answer true if the receiver has a selected range of text"

	^self selectionRange notEmpty!

initialize
	"Private - Initialize the receiver"

	super initialize.
	meFlags := 0!

isModified
	"Answer true if the receiver's text has been modified, either by updates that
	have been fed back to the model or in pending changes to the view. 
	Note that this must be explicitly reset by sending #isModified:."

	^(meFlags allMask: ModifiedMask) or: [self isTextModified]!

isModified: aBoolean
	"Set the receiver's text modification flag.
	Implementation Note: If resetting the flag then we must make sure that
	the model is in sync. with the view, as otherwise any pending changes
	may be lost."

	aBoolean ifFalse: [self updateModel].
	meFlags := meFlags mask: ModifiedMask set: aBoolean!

isTextModified
	"Private - Answer whether the receiver's text has been modified since last sync'd with
	the model."

	^meFlags allMask: TextModifiedMask!

isTextModified: aBoolean
	"Private - Set the receiver's text modification flag."

	meFlags := meFlags mask: TextModifiedMask set: aBoolean!

isTextValid
	"Answer whether the receiver's text is valid (i.e. it matches the mask).
	If the control still has focus then we may not know if the text is valid or not."

	^self hadErrors not and: [self hasFocusDeeply not]!

mask
	"Answer the edit mask currently set into the receiver."

	^self controlDispatch mask!

mask: aString 
	self controlDispatch mask: aString!

onTextChanged
	"Private - Handle event from the control that informs us that the input text has been changed."

	self hadErrors: false.
	self isTextModified: true.
	self trigger: #textChanged.
	self invalidateUserInterface!

onValidationError: aString startingAt: anInteger
	"Private - Handle event from the control that informs us that the current input text does not match the mask."

	self hadErrors: true!

plainText
	"Answers the text from the receiver.
	Note that this may or may not include the 'prompt' characters (normally an underscore)
	for positions where there is as yet no input."
	
	^self controlDispatch text!

plainText: aString
	"Set the text of the receiver from the <readableString> argument.
	Note that if the #promptInclude property is true then this will fail if aString 
	does not include at least as many valid characters (or prompt 	characters) as 
	required by the current mask."
	
	self controlDispatch text: aString.
	self hadErrors: false
!

presenter: aPresenter
	"The receiver's presenter is being set."

	super presenter: aPresenter.

	"Force to include prompt so get validation behaviour on setting"
	self assert: [self firesControlEvents].
	self controlDispatch promptInclude: true.
	self presenter
		when: #ValidationError:StartPosition: send: #onValidationError:startingAt: to: self;
		when: #Change send: #onTextChanged to: self!

replaceSelection: text
	"Replace the receiver's current selection with the Rich or plain text 
	argument, text. Double dispatch to 'text' to do the right thing."

	text replaceSelectionIn: self!

selection
	"Answer a String containing the receiver's currently selected text"

	^self controlDispatch selText!

selectionPlainText: aString
	"Private - Replace the receiver's current selection with aString."

	self controlDispatch selText: aString
!

selectionRange
	"Answers an interval identifying the selected range of text.
	We convert the Windows' control's rather unconventional
	interval to a form consistent with Smalltalk - i.e. entirely
	inclusive, with an empty interval being signified by the
	start of the interval being greater than the end.
	The caret position is always indicated by the first element
	in the selection range, regardless of whether there is any
	actual selection."

	| disp start |
	disp := self controlDispatch.
	^(start := disp selStart)+1 to: (start + disp selLength)!

selectionRange: anInterval
	"Sets the selected range of text to the range provided in anInterval
	(the interval includes the start of the selection, but the last
	character in the interval is not included in the selection, but
	instead identifies the first non-selected character after that
	point)."

	^self selectionStart: anInterval start end: anInterval stop
!

selectionRichText: aRichText
	"Private - Replace the selected text in the receiver with the RTF 
	string, aRichText.
	This is the backend of a double-dispatch protocol between TextEdits and 
	RichText/Strings."

	self selectionPlainText: aRichText asString
	!

selectionStart: start end: end
	"Sets the selected range of text to the range defined by the parameters start 
	and end (1 based, start and end inclusive)."

	(self controlDispatch)
		selStart: start - 1;
		selLength: end - start!

textLimit
	"Answer an <integer> between 1 and 64 which is the maximum length of text that can be accepted
	by the masked edit control."
	
	^self controlDispatch maxLength!

textLimit: anInteger
	"Set the maximum text limit for the receiver. The absolute maximum amount of text that
	can be accepted by a masked edit control is 64 characters."

	self controlDispatch textLimit: anInteger!

updateModel
	"Private - The displayed value of the receiver may have been changed so set this
	back into the model after first running through the type converter.
	Overridden here since TextEdit and subclasses are allowed to have no model, and
	also because we can detect if the view's representation has actually changed since
	we sync'd back to the model. The option to have no model is for efficiency, to avoid 
	having to maintain two copies of possibly 	large text (one in Windows, one in Smalltalk)."

	self isTextModified ifTrue: [
		self isTextModified: false.
		self isModified: true.
		self model notNil ifTrue: [ 
			super updateModel]]!

willAutoTab
	"Answer whether the will automatically tab to the next field when
	valid text that matches the mask has been entered."

	^self controlDispatch autoTab!

willAutoTab: aBoolean
	"Set whether the will automatically tab to the next field when
	valid text that matches the mask has been entered."

	self controlDispatch autoTab: aBoolean! !
!MaskedEdit categoriesFor: #apply!commands!public! !
!MaskedEdit categoriesFor: #caretPosition!public!selection! !
!MaskedEdit categoriesFor: #defaultProgId!constants!public! !
!MaskedEdit categoriesFor: #defaultText!accessing!public! !
!MaskedEdit categoriesFor: #defaultText:!accessing!public! !
!MaskedEdit categoriesFor: #displayValue!private!updating! !
!MaskedEdit categoriesFor: #displayValue:!private!updating! !
!MaskedEdit categoriesFor: #firesControlEvents:!accessing!public! !
!MaskedEdit categoriesFor: #format!accessing!public! !
!MaskedEdit categoriesFor: #format:!accessing!public! !
!MaskedEdit categoriesFor: #formattedText!accessing!public! !
!MaskedEdit categoriesFor: #formattedText:!accessing!public! !
!MaskedEdit categoriesFor: #hadErrors!public!testing! !
!MaskedEdit categoriesFor: #hadErrors:!accessing!private! !
!MaskedEdit categoriesFor: #hasSelection!public!selection! !
!MaskedEdit categoriesFor: #initialize!initializing!private! !
!MaskedEdit categoriesFor: #isModified!operations!public!testing! !
!MaskedEdit categoriesFor: #isModified:!modes!public! !
!MaskedEdit categoriesFor: #isTextModified!private!testing! !
!MaskedEdit categoriesFor: #isTextModified:!accessing!private! !
!MaskedEdit categoriesFor: #isTextValid!public!testing! !
!MaskedEdit categoriesFor: #mask!accessing!public! !
!MaskedEdit categoriesFor: #mask:!accessing!public! !
!MaskedEdit categoriesFor: #onTextChanged!event handling!private! !
!MaskedEdit categoriesFor: #onValidationError:startingAt:!event handling!private! !
!MaskedEdit categoriesFor: #plainText!public!updating! !
!MaskedEdit categoriesFor: #plainText:!public!updating! !
!MaskedEdit categoriesFor: #presenter:!event handling!public! !
!MaskedEdit categoriesFor: #replaceSelection:!public!selection! !
!MaskedEdit categoriesFor: #selection!public!selection! !
!MaskedEdit categoriesFor: #selectionPlainText:!private!selection! !
!MaskedEdit categoriesFor: #selectionRange!public!selection! !
!MaskedEdit categoriesFor: #selectionRange:!public!selection! !
!MaskedEdit categoriesFor: #selectionRichText:!private!selection! !
!MaskedEdit categoriesFor: #selectionStart:end:!public!selection! !
!MaskedEdit categoriesFor: #textLimit!accessing!public! !
!MaskedEdit categoriesFor: #textLimit:!operations!public! !
!MaskedEdit categoriesFor: #updateModel!private!updating! !
!MaskedEdit categoriesFor: #willAutoTab!public!testing! !
!MaskedEdit categoriesFor: #willAutoTab:!accessing!public! !

MaskedEdit methodProtocol: #textView attributes: #(#readOnly) selectors: #(#caretPosition #hasSelection #isModified #isModified: #replaceSelection: #selectionPlainText: #selectionRange #selectionRange: #selectionRichText:)!
MaskedEdit methodProtocol: #valueView attributes: #(#readOnly) selectors: #(#value #value:)!

!MaskedEdit class methodsFor!

icon
	^Icon fromId: 2 in: (ExternalResourceLibrary open: 'msmask32.ocx')!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	HadErrorsMask := 1.
	TextModifiedMask := 2.
	ModifiedMask := 3.! !
!MaskedEdit class categoriesFor: #icon!constants!public! !
!MaskedEdit class categoriesFor: #initialize!initializing!private! !

