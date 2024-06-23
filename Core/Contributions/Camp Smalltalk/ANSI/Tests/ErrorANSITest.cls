"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ErrorANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ErrorANSITest guid: (GUID fromString: '{28014a52-0e5f-4526-af9b-ad2e8fae09cf}')!

ErrorANSITest comment: ''!

!ErrorANSITest categoriesForClass!Unclassified! !

!ErrorANSITest methodsFor!

canonicalObject
	^Error new!

protocol
	^#Error!

testXdefaultAction
	" <Error>#defaultAction "
	#'Exception'.
#'todo'."??? I don't know what to test here.
	self value: [Error signal] should: [:r | true ??UNSPECIFIED??]
		conformTo: #'Error' selector: #'defaultAction'.
???"

	self value: [Error signal] shouldRaise: Error.!

testXdescription
	" <exceptionDescription>#description "
	#'Exception'.!

testXisNested
	" <signaledException>#isNested "

	#Exception.
	#bsm.	"Exception will always be nested when run with in SUnit, so fork off into a separate process"
	self 
		value: 
			[| sem result |
			sem := Semaphore new.
			
			[result := [Error signal] on: Error do: [:exception | exception return: exception isNested].
			sem signal] 
					fork.
			sem wait.
			result]
		should: [:r | r = false]
		conformTo: #signaledException
		selector: #isNested!

testXisResumable
	" <Error>#isResumable "
	#'Exception'.
	self value: [ [ Error signal ] on: Error do: [ :aError |
					aError return: aError isResumable ] ]
		shouldnt: [:r | r] conformTo: #'Error' selector: #'isResumable'.!

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

!ErrorANSITest categoriesForMethods!
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

