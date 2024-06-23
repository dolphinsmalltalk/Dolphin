"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ExceptionANSITest
	instanceVariableNames: 'unchanged changed value exceptionClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExceptionANSITest guid: (GUID fromString: '{ebfa6b6b-b8ac-4a72-9b8e-99832ad8e276}')!

ExceptionANSITest comment: ''!

!ExceptionANSITest categoriesForClass!Unclassified! !

!ExceptionANSITest methodsFor!

canonicalObject
	^self exceptionClass new!

exceptionClass
	"We can't use Exception itself, because it is non-instantiable. We need an instantiable Exception that is not an Error."

	^exceptionClass ifNil: [exceptionClass := Exception newAnonymousSubclass]!

exceptionOuterReturn
	^
	[[self exceptionClass signal] on: Exception
		do: 
			[:except |
			except outer.
			unchanged := false]]
			on: Exception
			do: [:except | except return: true]!

exceptionPass
	" <signaledException>#pass "

	^
	[[self exceptionClass signal] on: Exception
		do: 
			[:ex |
			ex pass.
			unchanged := false]]
			on: Exception
			do: 
				[:ex |
				changed := true.
				ex return]

	"conformTo: #'signaledException' selector: #'pass'."!

exceptionReturn
	^[self exceptionClass signal]
		on: Exception
		do:
			[:except |
			except return.
			unchanged := false]!

mustBeBoolean: anObject
	self should: [anObject == true or: [anObject == false]].!

notificationOuterDefault
	value := 1.
	value := [Notification signal] on: Notification
				do: 
					[:except |
					| outer |
					outer := except outer.
					unchanged := false.
					outer]!

notificationOuterResume

	[[changed := Notification signal]
		on: Notification
		do:
			[:except |
			except outer.
			unchanged := false]]
				on: Notification
				do: [:except | except resume: true]!

protocol
	^#Exception!

resignalExceptionAsNotification

	| firstTime |
	firstTime := true.
	^[[self exceptionClass signal]
		on: Exception
		do:
			[:ex |
			firstTime
				ifTrue:
					[firstTime := false.
					ex resignalAs: Notification new.
					unchanged := false]
				ifFalse: [ex pass]]]
				on: Notification
				do: [:ex | ex return: true]!

resignalNotificationAsException
	^[[Notification signal]
		on: Notification
		do:
			[:ex |
			ex resignalAs: self exceptionClass new.
			unchanged := false]]
				on: Exception
				do:
					[:ex | ex return: true]!

resumedException
	^[[self exceptionClass signal] 
		on: Exception 
		do: 
			[:except |
			except resume: false. "Exception isn't resumable - this throws an exception"
			unchanged := false]]
				on: Exception
				do:
					[:ex | ex return: true]!

resumedExceptionWithValue
	^[[self exceptionClass signal] 
		on: Exception 
		do: 
			[:except |
			except resume: false.
			unchanged := false]]
				on: Exception
				do:
					[:ex | ex return: true]!

resumedNotification
	[value := Notification signal] 
		on: Notification 
		do: 
			[:except |
			except resume.
			unchanged := false]!

resumedNotificationWithValue
	[changed := Notification signal] 
		on: Notification 
		do: 
			[:except |
			except resume: true.
			unchanged := false]!

setUp
	super setUp.
	unchanged := true.
	value := nil.
	changed := false!

signalExceptionNestedWithError
	^[[self exceptionClass signal] on: Exception do: [:exception | exception return: exception isNested]]
		on: Error
		do: [:error | error return]!

signalNestedException
	^[[self exceptionClass signal]
		on: Exception
		do: [:exception | exception return: exception isNested]]
			on: Exception
			do: [:exception | exception return]!

signalUnnestedException
	^[self exceptionClass signal] on: Exception do: [:exception | exception return: exception isNested]!

testXdefaultAction
	" <exceptionDescription>#defaultAction "
	self should: [Notification signal == nil]!

testXdescription
	" <exceptionDescription>#description "
	| exception messageText |
"not sure - spec only says that default should be something 'readable'; well, at least it shouldn't be nil ..."
	self shouldnt: [self canonicalObject description == nil].
	exception := self canonicalObject.
	messageText := 'our chief weapon is fear'.
	exception messageText: messageText.
	self shouldnt: [(exception description indexOfSubCollection: messageText) = 0].!

testXisNested
	" <signaledException>#isNested "
	self shouldnt: [self signalUnnestedException].
	self shouldnt: [self signalExceptionNestedWithError].
	self should: [self signalNestedException].
"	conformTo: #'signaledException' selector: #'isNested'."!

testXisResumable
	" <exceptionDescription>#isResumable "
	#'Exception'.
	self mustBeBoolean: self canonicalObject isResumable.
	self shouldnt: [Error new isResumable].
	self should: [Notification new isResumable].
	self should: [ZeroDivide new isResumable].
	self should: [MessageNotUnderstood new isResumable].!

testXmessageText
	" <exceptionDescription>#messageText "
	| exception messageText |
	exception := self canonicalObject.
	self should: [exception messageText == nil].
	messageText := 'our chief weapon is fear'.
	exception messageText: messageText.
	self should: [exception messageText = messageText].!

testXmessageTextX
	" <exceptionBuilder>#messageText: (Return Values: <RECEIVER>) "
	#'Exception'.!

testXouter
	" <signaledException>#outer "
	#'Exception'.
	changed := self exceptionOuterReturn.
	self should: [changed and: [unchanged]].
	self setUp.
	"The CS ANSI test interprets the #outer message as terminating the handler that sends it and returning the value of the outer handler as the resumption value. The standard is slightly ambiguous on this point, but it isn't clear what the value of the #outer message would be, as it would effectively be no different to #pass even for resumable exceptions. Both Dolphin and Squeak/Pharo interpret the resumption value of #outer as the return value from the #outer message itself. This makes sense since there is more flexibility in returning the value to the handler calling #outer, allowing the inner handler to decide the correct disposition based on the value returned by the outer handler - it can choose whether to return that value itself, or some other value, or do something else; #outer is like asking the enclosing handler what it would do if it were to handle the exception. It is possible, however, that both implementations are non-compliant in this regard."
	self notificationOuterDefault.
	"self should: [value == nil and: [unchanged]]."
	self should: [value == nil and: [unchanged not]].
	self setUp.
	self notificationOuterResume.
	"self should: [changed and: [unchanged]]."
	self should: [changed not and: [unchanged not]].!

testXpass
	" <signaledException>#pass "
	self exceptionPass.
	self should: [changed and: [unchanged]]!

testXresignalAsX
	" <signaledException>#resignalAs: "
	changed := self resignalNotificationAsException.
	self should: [changed and: [unchanged]].
	self setUp.
	changed := self resignalExceptionAsNotification.
	self should: [changed and: [unchanged]].!

testXresume
	" <signaledException>#resume "
	value := 1.
	self resumedNotification.
	self should: [(value == nil) and: [unchanged]].
	self setUp.
	changed := self resumedException.
	self should: [changed and: [unchanged]]!

testXresumeX
	" <signaledException>#resume: "
	self resumedNotificationWithValue.
	self should: [changed and: [unchanged]].
	self setUp.
	changed := self resumedExceptionWithValue.
	self should: [changed and: [unchanged]]!

testXretry
	" <signaledException>#retry "
	| firstTime |
	firstTime := true.
	[firstTime
		ifTrue: [self exceptionClass signal] 
		ifFalse: [changed := true]]
			on: Exception 
			do: 
				[:except |
				firstTime := false.
				except retry.
				unchanged := false].
	self should: [changed and: [unchanged]]!

testXretryUsingX
	" <signaledException>#retryUsing: "
	[self exceptionClass signal]
		on: Exception
		do:
			[:except |
			except retryUsing: [changed := true].
			unchanged := false].
	self should: [changed and: [unchanged]]!

testXreturn
	" <signaledException>#return "
	value := 1.
	value := self exceptionReturn.
	self should: [value == nil and: [unchanged]]!

testXreturnX
	" <signaledException>#return: "
	changed := [self exceptionClass signal]
		on: Exception
		do:
			[:except |
			except return: true.
			unchanged := false].
	self should: [changed and: [unchanged]]!

testXsignal
	" <exceptionSignaler>#signal "
	#'Exception'.
	"tested by the zillion other sends of signal"!

testXsignalX
	" <exceptionSignaler>#signal: "
	#'Exception'.
	"tested by the zillion other sends of signal"!

testXtag
	" <exceptionDescription>#tag "
	| exception messageText |
	exception := self canonicalObject.
	self should: [exception tag == nil].
	messageText := 'our chief weapon is fear'.
	exception messageText: messageText.
	self should: [exception tag = messageText].
	exception tag: 1.
	self should: [exception tag = 1].! !

!ExceptionANSITest categoriesForMethods!
canonicalObject!public! !
exceptionClass!private! !
exceptionOuterReturn!public! !
exceptionPass!public! !
exceptionReturn!public! !
mustBeBoolean:!public! !
notificationOuterDefault!public! !
notificationOuterResume!public! !
protocol!public! !
resignalExceptionAsNotification!public! !
resignalNotificationAsException!public! !
resumedException!public! !
resumedExceptionWithValue!public! !
resumedNotification!public! !
resumedNotificationWithValue!public! !
setUp!public! !
signalExceptionNestedWithError!public! !
signalNestedException!public! !
signalUnnestedException!public! !
testXdefaultAction!public! !
testXdescription!public! !
testXisNested!public! !
testXisResumable!public! !
testXmessageText!public! !
testXmessageTextX!public! !
testXouter!public! !
testXpass!public! !
testXresignalAsX!public! !
testXresume!public! !
testXresumeX!public! !
testXretry!public! !
testXretryUsingX!public! !
testXreturn!public! !
testXreturnX!public! !
testXsignal!public! !
testXsignalX!public! !
testXtag!public! !
!

