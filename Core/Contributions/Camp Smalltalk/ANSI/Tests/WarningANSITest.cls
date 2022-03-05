"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #WarningANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WarningANSITest guid: (GUID fromString: '{62a40256-0d91-4368-a959-aff805526b40}')!
WarningANSITest comment: ''!
!WarningANSITest categoriesForClass!Unclassified! !
!WarningANSITest methodsFor!

canonicalObject
	^Warning new!

protocol
	^#Warning!

testXdefaultAction
	" <Warning>#defaultAction "

	| tmp theText |
	#Exception.
	theText := 'the text'.
	self 
		value: 
			[[Warning signal: 'the text'] on: Warning do: [:aWarning | tmp := aWarning messageText]]
		should: [:r | true & (tmp = theText)	"UNSPECIFIED"]
		conformTo: #Warning
		selector: #defaultAction!

testXdescription
	" <exceptionDescription>#description "
	#'Exception'.!

testXisNested
	" <signaledException>#isNested "
	#'Exception'.!

testXisResumable
	" <Notification>#isResumable "
	#'Exception'.!

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
!WarningANSITest categoriesForMethods!
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

