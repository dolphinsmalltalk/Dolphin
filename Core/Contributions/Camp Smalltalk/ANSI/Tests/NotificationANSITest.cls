"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #NotificationANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NotificationANSITest guid: (GUID fromString: '{05a68580-3eab-41dd-a67a-849688810ae0}')!
NotificationANSITest comment: ''!
!NotificationANSITest categoriesForClass!Unclassified! !
!NotificationANSITest methodsFor!

canonicalObject
	^Notification new!

protocol
	^#Notification!

testXdefaultAction
	" <Notification>#defaultAction "
	#'Exception'.
	self value: [Notification signal] should: [:r | r = nil]
		conformTo: #'Notification' selector: #'defaultAction'.!

testXdescription
	" <exceptionDescription>#description "
	#'Exception'.!

testXisNested
	" <signaledException>#isNested "
	#'Exception'.!

testXisResumable
	" <Notification>#isResumable "
	#'Exception'.
	self value: [ [ Notification signal ] on: Notification do: [ :aNotification |
					aNotification return: aNotification isResumable ] ]
		should: [:r | r]
		conformTo: #'Notification' selector: #'isResumable'.!

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
!NotificationANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
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

