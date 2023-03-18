"Filed out from Dolphin Smalltalk"!

Core.Exception
	subclass: #'Core.Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Error guid: (Core.GUID fromString: '{0324fe53-ad83-11d2-86eb-0020afab8efe}')!
Core.Error comment: ''!
!Core.Error categoriesForClass!Kernel-Exception Handling! !
!Core.Error methodsFor!

asWarning
	"Private - Answer the receiver as a generic Warning message."

	^Warning messageText: self description!

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

	^Notification signal: 'Error: ' , self description!

resignalAsWarning
	"Private - Resignal the receiver as if it had originally been raised as a generic Warning.
	This should be used only to get out of sticky situations (e.g. recursive walkbacks)."

	self resignalAs: self asWarning!

warningClass
	"Private - Answer the class of Warning to which the receiver is converted by #asWarning."

	^Warning! !
!Core.Error categoriesForMethods!
asWarning!converting!private! !
defaultAction!handling!public! !
isUserResumable!public!testing! !
notify!converting!public! !
resignalAsWarning!handler responses!private! !
warningClass!constants!private! !
!

Core.Error methodProtocol: #Error attributes: #(#ansi #readOnly) selectors: #(#defaultAction #description #isNested #isResumable #messageText #messageText: #outer #pass #resignalAs: #resume #resume: #retry #retryUsing: #return #return: #signal #signal: #tag)!

!Core.Error class methodsFor!

iconStyle
	"Answer an exception class describing the severity of the notification."

	^#error!

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
		ifTrue: [^receiver error: 'Invalid selector ' , selector printString].
	anInteger == _PrimitiveFailureCode.InvalidParameter2
		ifTrue: [^receiver error: 'Arguments not Array: ' , arguments printString].
	anInteger == _PrimitiveFailureCode.WrongNumberOfArgs
		ifTrue: 
			[^receiver
				error: ('Incorrect number of arguments: <1p>, expected <2p>' expandMacrosWith: arguments size
						with: selector argumentCount)].
	receiver
		error: ('Primitive perform of <1p> failed (<2p>)' expandMacrosWith: selector with: anInteger)!

subclassResponsibility: selector
	"Private - Raise an error that some message was sent to an abstract class."

	^SubclassResponsibilityError signal: selector printString , ' is the responsibility of the subclass'! !
!Core.Error class categoriesForMethods!
iconStyle!constants!public! !
mbIconId!parping!public! !
nonIntegerIndex:!instance creation!private! !
notIndexable:!instance creation!private! !
notYetImplemented!instance creation!private! !
performFailed:of:for:withArgs:!instance creation!private! !
subclassResponsibility:!instance creation!private! !
!

Core.Error class methodProtocol: #'Error class' attributes: #(#ansi #readOnly) selectors: #(#, #allSubclasses #allSuperclasses #handles: #name #new #signal #signal: #subclasses #superclass)!

