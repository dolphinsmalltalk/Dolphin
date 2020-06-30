"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #NotificationANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!NotificationANSITest categoriesFor: #canonicalObject!public! !
!NotificationANSITest categoriesFor: #protocol!public! !
!NotificationANSITest categoriesFor: #testXdefaultAction!public! !
!NotificationANSITest categoriesFor: #testXdescription!public! !
!NotificationANSITest categoriesFor: #testXisNested!public! !
!NotificationANSITest categoriesFor: #testXisResumable!public! !
!NotificationANSITest categoriesFor: #testXmessageText!public! !
!NotificationANSITest categoriesFor: #testXmessageTextX!public! !
!NotificationANSITest categoriesFor: #testXouter!public! !
!NotificationANSITest categoriesFor: #testXpass!public! !
!NotificationANSITest categoriesFor: #testXresignalAsX!public! !
!NotificationANSITest categoriesFor: #testXresume!public! !
!NotificationANSITest categoriesFor: #testXresumeX!public! !
!NotificationANSITest categoriesFor: #testXretry!public! !
!NotificationANSITest categoriesFor: #testXretryUsingX!public! !
!NotificationANSITest categoriesFor: #testXreturn!public! !
!NotificationANSITest categoriesFor: #testXreturnX!public! !
!NotificationANSITest categoriesFor: #testXsignal!public! !
!NotificationANSITest categoriesFor: #testXsignalX!public! !
!NotificationANSITest categoriesFor: #testXtag!public! !

