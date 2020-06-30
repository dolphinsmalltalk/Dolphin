"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ZeroDivideANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ZeroDivideANSITest guid: (GUID fromString: '{e219428d-c7dd-42a5-a335-fbbf02393d9c}')!
ZeroDivideANSITest comment: ''!
!ZeroDivideANSITest categoriesForClass!Unclassified! !
!ZeroDivideANSITest methodsFor!

canonicalObject
	^ZeroDivide new!

protocol
	^#ZeroDivide!

testXdefaultAction
	" <Error>#defaultAction "
	#'Exception'.!

testXdescription
	" <exceptionDescription>#description "
	#'Exception'.!

testXdividend
	" <ZeroDivide>#dividend "
	#'Exception'.
	self value: [	[(ZeroDivide dividend: 1) signal
				] on: ZeroDivide do: [ :aZeroDivide |
					aZeroDivide return: (aZeroDivide dividend) ] ]
		should: [:r | r = 1] conformTo: #'ZeroDivide' selector: #'dividend'.!

testXisNested
	" <signaledException>#isNested "
	#'Exception'.!

testXisResumable
	" <ZeroDivide>#isResumable "
	#'Exception'.
	self value: [	[(ZeroDivide dividend: 1.0) signal
				] on: ZeroDivide do: [ :aZeroDivide |
					aZeroDivide return: aZeroDivide isResumable ] ]
		should: [:r | r] conformTo: #'ZeroDivide' selector: #'isResumable'.!

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
!ZeroDivideANSITest categoriesFor: #canonicalObject!public! !
!ZeroDivideANSITest categoriesFor: #protocol!public! !
!ZeroDivideANSITest categoriesFor: #testXdefaultAction!public! !
!ZeroDivideANSITest categoriesFor: #testXdescription!public! !
!ZeroDivideANSITest categoriesFor: #testXdividend!public! !
!ZeroDivideANSITest categoriesFor: #testXisNested!public! !
!ZeroDivideANSITest categoriesFor: #testXisResumable!public! !
!ZeroDivideANSITest categoriesFor: #testXmessageText!public! !
!ZeroDivideANSITest categoriesFor: #testXmessageTextX!public! !
!ZeroDivideANSITest categoriesFor: #testXouter!public! !
!ZeroDivideANSITest categoriesFor: #testXpass!public! !
!ZeroDivideANSITest categoriesFor: #testXresignalAsX!public! !
!ZeroDivideANSITest categoriesFor: #testXresume!public! !
!ZeroDivideANSITest categoriesFor: #testXresumeX!public! !
!ZeroDivideANSITest categoriesFor: #testXretry!public! !
!ZeroDivideANSITest categoriesFor: #testXretryUsingX!public! !
!ZeroDivideANSITest categoriesFor: #testXreturn!public! !
!ZeroDivideANSITest categoriesFor: #testXreturnX!public! !
!ZeroDivideANSITest categoriesFor: #testXsignal!public! !
!ZeroDivideANSITest categoriesFor: #testXsignalX!public! !
!ZeroDivideANSITest categoriesFor: #testXtag!public! !

