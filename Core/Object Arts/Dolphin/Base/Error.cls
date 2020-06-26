"Filed out from Dolphin Smalltalk 7"!

Exception subclass: #Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
Error guid: (GUID fromString: '{0324fe53-ad83-11d2-86eb-0020afab8efe}')!
Error comment: ''!
!Error categoriesForClass!Kernel-Exception Handling! !
!Error methodsFor!

asWarning
	"Private - Answer the receiver as a generic Warning message."

	^Warning new 
		messageText: self description!

defaultAction
	"Perform the default action for the receiver if it is not handled
	(forward to the SessionManager for application specific handling."

	^SessionManager current onUnhandledError: self!

isUserResumable
	"Answer whether the user should be given the option of resuming when prompted with regard to
	this exception."

	"Implementation Note: We want to avoid the user being given the option to resume errors in a
	runtime system, as it is almost certainly not desired (e.g. if they hit OK in response to a
	MessageNotUnderstood, then they will almost certainly get a knock on error occurring)."

	^false!

notify
	"Signal a <Notification> with the receiver's description. Generally used to provide
	a trace showing that an error has been suppressed."

	^Notification signal: 'Error: ', self description!

resignalAsWarning
	"Private - Resignal the receiver as if it had originally been raised as a generic Warning.
	This should be used only to get out of sticky situations (e.g. recursive walkbacks)."

	self resignalAs: self asWarning!

warningClass
	"Private - Answer the class of Warning to which the receiver is converted by #asWarning."
	
	^Warning! !
!Error categoriesFor: #asWarning!converting!private! !
!Error categoriesFor: #defaultAction!handling!public! !
!Error categoriesFor: #isUserResumable!public!testing! !
!Error categoriesFor: #notify!converting!public! !
!Error categoriesFor: #resignalAsWarning!handler responses!private! !
!Error categoriesFor: #warningClass!constants!private! !

Error methodProtocol: #Error attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Error class methodsFor!

mbIconId
	^MB_ICONERROR!

nonIntegerIndex: anObject
	"Private - Raise an Error to the effect that anObject was used as an 
	integer index, but it isn't!!"

	^self signal: 'Index: ', anObject printString, ' is not an integer'!

notIndexable: anObject
	"Private - Raise an error that some attempt was made to index a non-indexable Object."

	^self signal: 'not indexable'!

notYetImplemented
	"Private - Raise an error that some method is not implemented yet but should 
	be in future."

	^self signal: 'Not implemented yet'
!

performFailed: anInteger of: selector for: receiver withArgs: arguments
	"Private - A primitive perform call failed, generate an appropriate error."

	anInteger == _PrimitiveFailureCode.InvalidParameter1
		ifTrue: [^receiver error: ('Invalid selector <1p>' expandMacrosWith: selector)].
	anInteger == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: [^receiver error: 'Arguments not Array: ' , arguments printString].
	anInteger == _PrimitiveFailureCode.WrongNumberOfArgs
		ifTrue: 
			[^receiver
				error: ('Incorrect number of arguments: <1d>, expected <2d>' expandMacrosWith: arguments size
						with: selector argumentCount)].
	receiver
		error: ('Primitive perform of <1p> failed (<2d>)' expandMacrosWith: selector with: anInteger)!

severityClass
	"Answer an exception class describing the severity of the notification."

	^Error!

subclassResponsibility: selector
	"Private - Raise an error that some message was sent to an abstract class."

	^SubclassResponsibilityError signal: selector printString, ' is the responsibility of the subclass'! !
!Error class categoriesFor: #mbIconId!parping!public! !
!Error class categoriesFor: #nonIntegerIndex:!instance creation!private! !
!Error class categoriesFor: #notIndexable:!instance creation!private! !
!Error class categoriesFor: #notYetImplemented!instance creation!private! !
!Error class categoriesFor: #performFailed:of:for:withArgs:!instance creation!private! !
!Error class categoriesFor: #severityClass!constants!public! !
!Error class categoriesFor: #subclassResponsibility:!instance creation!private! !

Error class methodProtocol: #'Error class' attributes: #(#ansi #readOnly) selectors: #(#, #allSubclasses #allSuperclasses #handles: #name #new #signal #signal: #subclasses #superclass)!

