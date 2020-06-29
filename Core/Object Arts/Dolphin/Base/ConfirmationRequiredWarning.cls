"Filed out from Dolphin Smalltalk 7"!

Warning subclass: #ConfirmationRequiredWarning
	instanceVariableNames: 'confirmBlock refuseBlock cancelBlock'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ConfirmationRequiredWarning guid: (GUID fromString: '{6cbf0500-f796-4979-8f8d-3285e012aa94}')!
ConfirmationRequiredWarning comment: 'ConfirmationRequiredWarnings can be signalled when an operation requires user consent. The default action is to show a Yes/No[/Cancel] message box. When the user has responded, execution is continued from the signalling point answering true, false or nil, for Yes, No and Cancel (respectively) responses. The signaller can then act accordingly to proceed with the operation as appropriate. The actions to be taken (or values to be returned) when the buttons are pressed can be overridden individually by providing suitable <niladicValuable>s, e.g. blocks. The cancel button can be suppressed by setting the cancel block to nil.

Examples:
	ConfirmationRequiredWarning signal: ''Are you well?''. "By default, no Cancel option"
	ConfirmationRequiredWarning signal: ''Sugar?'' onYes: [''Two lumps''] onNo: [''No sugar''] onCancel: [''Tea refused''].'!
!ConfirmationRequiredWarning categoriesForClass!Kernel-Exception Handling! !
!ConfirmationRequiredWarning methodsFor!

cancel
	"Answer the the result of evaluating the <niladicValuable>, cancelBlock, as the value of the
	expression which signalled this exception, from whence execution continues. If no cancel
	block was specified, then the resumption value will be nil."

	self resume: self cancelBlock value!

cancelBlock
	^cancelBlock ?? []!

cancelBlock: aNiladicValuable
	cancelBlock := aNiladicValuable!

confirm
	"Answer the the result of evaluating the <niladicValuable>, confirmBlock, as the value of
	the expression which signalled this exception, from whence execution continues. If no
	confirm block was specified, then the resumption value will be true."

	self resume: self confirmBlock value!

confirmBlock
	^confirmBlock ?? [true]!

confirmBlock: aNiladicValuable
	confirmBlock := aNiladicValuable!

defaultAction
	^cancelBlock isNil
		ifTrue: 
			[(MessageBox confirm: self messageText)
				ifTrue: [self confirmBlock value]
				ifFalse: [self refuseBlock value]]
		ifFalse: 
			[MessageBox
				confirm: self messageText
				onYes: self confirmBlock
				onNo: self refuseBlock
				onCancel: self cancelBlock]!

refuse
	"Answer the the result of evaluating the <niladicValuable>, refuseBlock, as the value of
	the expression which signalled this exception, from whence execution continues. If no
	refuse block was specified, then the resumption value will be false."

	self resume: self refuseBlock value!

refuseBlock
	^refuseBlock ?? [false]!

refuseBlock: aNiladicValuable
	refuseBlock := aNiladicValuable! !
!ConfirmationRequiredWarning categoriesFor: #cancel!handler responses!public! !
!ConfirmationRequiredWarning categoriesFor: #cancelBlock!accessing!public! !
!ConfirmationRequiredWarning categoriesFor: #cancelBlock:!accessing!public! !
!ConfirmationRequiredWarning categoriesFor: #confirm!handler responses!public! !
!ConfirmationRequiredWarning categoriesFor: #confirmBlock!accessing!public! !
!ConfirmationRequiredWarning categoriesFor: #confirmBlock:!accessing!public! !
!ConfirmationRequiredWarning categoriesFor: #defaultAction!handling!public! !
!ConfirmationRequiredWarning categoriesFor: #refuse!handler responses!public! !
!ConfirmationRequiredWarning categoriesFor: #refuseBlock!accessing!public! !
!ConfirmationRequiredWarning categoriesFor: #refuseBlock:!accessing!public! !

!ConfirmationRequiredWarning class methodsFor!

signal: aString onYes: confirmValuable onNo: refuseValuable onCancel: cancelValuable
	"Signal a <Warning>, the default action for which is to prompt the user with a Yes/No/Cancel
	message box and then evaluate the appropriate <niladicValuable> argument based on the
	response."

	^(self new)
		confirmBlock: confirmValuable;
		refuseBlock: refuseValuable;
		cancelBlock: cancelValuable;
		signal: aString! !
!ConfirmationRequiredWarning class categoriesFor: #signal:onYes:onNo:onCancel:!instance creation!public! !

