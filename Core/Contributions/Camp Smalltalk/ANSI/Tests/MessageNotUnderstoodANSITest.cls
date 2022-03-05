"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #MessageNotUnderstoodANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
MessageNotUnderstoodANSITest guid: (GUID fromString: '{43868030-9b3f-4747-b82f-32c512f38460}')!
MessageNotUnderstoodANSITest comment: ''!
!MessageNotUnderstoodANSITest categoriesForClass!Unclassified! !
!MessageNotUnderstoodANSITest methodsFor!

canonicalObject
	^MessageNotUnderstood new 
		receiver: nil;
		tag: (Message selector: #foo: argument: 'bar');
		yourself!

protocol
	^#MessageNotUnderstood!

testXdefaultAction
	" <Error>#defaultAction "
	#'Exception'.!

testXdescription
	" <exceptionDescription>#description "
	#'Exception'.!

testXisNested
	" <signaledException>#isNested "
	#'Exception'.!

testXisResumable
	" <MessageNotUnderstood>#isResumable "
	#'Exception'.
	self value: [	[ MessageNotUnderstood signal
				] on: MessageNotUnderstood do: [ :mnu |
					mnu return: mnu isResumable ] ]
		should: [:r | r]
		conformTo: #'MessageNotUnderstood' selector: #'isResumable'.!

testXmessage
	" <MessageNotUnderstood>#message "
	#'Exception'.
	self value: [ [ 1 bob ] on: MessageNotUnderstood do: [ :mnu |
					mnu return: mnu message ] ]
		should: [:r | (r selector = #'bob') & (r arguments = Array new)]
		conformTo: #'MessageNotUnderstood' selector: #'message'.

	self value: [ [ 1 bob: 2 ] on: MessageNotUnderstood do: [ :mnu |
					mnu return: mnu message ] ]
		should: [:r | (r selector = #'bob:') & (r arguments = #( 2 ))]
		conformTo: #'MessageNotUnderstood' selector: #'message'.!

testXmessageText
	" <exceptionDescription>#messageText "
	#'Exception'.!

testXmessageTextX
	" <exceptionBuilder>#messageText: (Return Values: <RECEIVER>) "
	#'Exception'.!

testXouter
	" <signaledException>#outer "
	#'Exception'.!

testXpass
	" <signaledException>#pass "
	#'Exception'.!

testXreceiver
	" <MessageNotUnderstood>#receiver "
	#'Exception'.
	self value: [ [ 1 bob ] on: MessageNotUnderstood do: [ :mnu |
					mnu return: mnu receiver ] ]
		should: [:r | r = 1]
		conformTo: #'MessageNotUnderstood' selector: #'receiver'.!

testXresignalAsX
	" <signaledException>#resignalAs: "
	#'Exception'.!

testXresume
	" <signaledException>#resume "
	#'Exception'.!

testXresumeX
	" <signaledException>#resume: "
	#'Exception'.!

testXretry
	" <signaledException>#retry "
	#'Exception'.!

testXretryUsingX
	" <signaledException>#retryUsing: "
	#'Exception'.!

testXreturn
	" <signaledException>#return "
	#'Exception'.!

testXreturnX
	" <signaledException>#return: "
	#'Exception'.!

testXsignal
	" <exceptionSignaler>#signal "
	#'Exception'.!

testXsignalX
	" <exceptionSignaler>#signal: "
	#'Exception'.!

testXtag
	" <exceptionDescription>#tag "
	#'Exception'.! !
!MessageNotUnderstoodANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXdefaultAction!public! !
testXdescription!public! !
testXisNested!public! !
testXisResumable!public! !
testXmessage!public! !
testXmessageText!public! !
testXmessageTextX!public! !
testXouter!public! !
testXpass!public! !
testXreceiver!public! !
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

