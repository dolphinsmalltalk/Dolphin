"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.ValidationResult'
	instanceVariableNames: 'value caption hint presenter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ValidationResult guid: (Core.GUID fromString: '{c25bcb63-2b8b-4a6b-a96d-58e1b2297a22}')!
UI.ValidationResult comment: ''!
!UI.ValidationResult categoriesForClass!Kernel-Objects! !
!UI.ValidationResult methodsFor!

caption
	"Answer the caption to be used in any hint shown for this validation result, or nil if the default should be used. This is normally only relevant when the hint it set. "

	^caption!

caption: aString
	"Set the caption to be used in any hint shown for this validation result. This is normally only relevant when the hint is set."

	caption ifNil: [caption := aString]!

displayOn: aPuttableStream
	hint displayOn: aPuttableStream!

errorMessage: aString
	"Set this <ValidationResult> to be a failure with the argument as the error message hint."

	self value: false.
	self hint: (Error messageText: aString).
	^false!

hint
	"Answer the <Exception> representing the hint for the receiver, or nil if none. The <Exception> need not be an <Error>, it could be a <Warning>, or just a <Notification>. <Error> hints would typically be associated with validation that failed, and <Warnings> for validation that passed but with some concern, or <Notification> for general hints such as what might be expected when a value is empty."

	^hint!

hint: anException
	"Set the <Exception> representing the hint for the receiver, but only if there is no hint already.
	The hint can be displayed whether the validation passed or failed."

	hint ifNil: [hint := anException]!

message: aString
	self hint: (Notification messageText: aString)!

presenter
	^presenter!

presenter: aPresenterOrView
	presenter := aPresenterOrView!

value
	"Answer true if the validation represented by the receiver passed, or false if it failed."

	^value!

value: aBoolean
	"Set whether the associated validation passed (true) or failed (false). If the validation is already marked as failed, then that cannot be changed."

	(value isNil or: [value]) ifTrue: [value := aBoolean == true].
	^value!

warningMessage: aString
	"Set this <ValidationResult> to be successful, but with the argument as the warning message hint."

	self value: true.
	self hint: (Warning messageText: aString)! !
!UI.ValidationResult categoriesForMethods!
caption!accessing!public! !
caption:!accessing!public! !
displayOn:!accessing!public! !
errorMessage:!accessing!public! !
hint!accessing!public! !
hint:!accessing!public! !
message:!accessing!public! !
presenter!accessing!public! !
presenter:!accessing!public! !
value!accessing!public! !
value:!public! !
warningMessage:!accessing!public! !
!

!UI.ValidationResult class methodsFor!

errorMessage: aString
	^self new
		errorMessage: aString;
		yourself!

failed
	^self value: false!

new
	^self value: true!

value: aBoolean
	^self basicNew
		value: aBoolean;
		yourself! !
!UI.ValidationResult class categoriesForMethods!
errorMessage:!public! !
failed!public! !
new!public! !
value:!accessing!public! !
!

