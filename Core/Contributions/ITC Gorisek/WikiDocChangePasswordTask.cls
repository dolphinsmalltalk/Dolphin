"Filed out from Dolphin Smalltalk X6.1"!

WikiDocTask subclass: #WikiDocChangePasswordTask
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocChangePasswordTask guid: (GUID fromString: '{74C00931-CF64-4480-9021-1F9E18C5D438}')!
WikiDocChangePasswordTask comment: ''!
!WikiDocChangePasswordTask categoriesForClass!Unclassified! !
!WikiDocChangePasswordTask methodsFor!

initialize
	super initialize.
	transaction := application newReadOnlyTransaction!

process: request on: stream 
	self 
		dispatch: request
		using: #(#processDefault:on: #processChangePassword:on:)
		on: stream
		withDefault: 'default'!

processChangePassword: request on: stream 
	| user errors newPassword t |
	t := application db newTransaction.
	language := Processor activeProcess language.
	[user := application userIndex at: session user username] evaluateIn: t.
	session := self webSession.
	errors := LookupTable new.
	user password = (request stringAt: 'oldpassword') 
		ifFalse: [errors at: 'oldpassword' put: 'WikiDoc.User.ChangePassword.BadOldPassword' webTranslate].
	newPassword := request stringAt: 'newpassword'.
	newPassword = (request stringAt: 'passwordConfirm') 
		ifFalse: [errors at: 'newpassword' put: 'WikiDoc.User.ChangePassword.PasswordsDoNotMatch' webTranslate].
	newPassword size < 4 
		ifTrue: [errors at: 'newpassword' put: 'WikiDoc.User.ChangePassword.PasswordTooShort' webTranslate].
	errors notEmpty ifTrue: [^(self newCoder: stream) wikiDocChangePasswordPage: user errors: errors].
	user password: newPassword.
	t markDirty: user.
	t commit.
	(self newCoder: stream) wikiDocChangePasswordConfirmationPage!

processDefault: request on: stream 
	(self newCoder: stream) wikiDocChangePasswordPage: session user errors: nil! !
!WikiDocChangePasswordTask categoriesFor: #initialize!public! !
!WikiDocChangePasswordTask categoriesFor: #process:on:!public! !
!WikiDocChangePasswordTask categoriesFor: #processChangePassword:on:!public! !
!WikiDocChangePasswordTask categoriesFor: #processDefault:on:!public! !

