"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #WarningClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WarningClassANSITest guid: (GUID fromString: '{13e6648c-2af2-49a3-8c6c-5d93b7c7b9f2}')!
WarningClassANSITest comment: ''!
!WarningClassANSITest categoriesForClass!Unclassified! !
!WarningClassANSITest methodsFor!

canonicalObject
	^Warning!

protocol
	^#'Warning class'!

testXallSubclasses
	" <classDescription>#allSubclasses "
	#'Exception'.!

testXallSuperclasses
	" <classDescription>#allSuperclasses "
	#'Exception'.!

testXconcatenateOp
	" <exceptionSelector>#, "
	#'Exception'.!

testXhandlesX
	" <Exception class>#handles: "
	#'Exception'.!

testXname
	" <classDescription>#name "
	#'Exception'.!

testXnew
	" <Warning class>#new "
	#'Exception'.
	self value: [Warning new] should: [:r | true "??? r = Warning signal ???"]
		conformTo: #'Warning class' selector: #'new'.!

testXsignal
	" <Exception class>#signal "
	#'Exception'.!

testXsignalX
	" <exceptionSignaler>#signal: "
	#'Exception'.!

testXsubclasses
	" <classDescription>#subclasses "
	#'Exception'.!

testXsuperclass
	" <classDescription>#superclass "
	#'Exception'.! !
!WarningClassANSITest categoriesFor: #canonicalObject!public! !
!WarningClassANSITest categoriesFor: #protocol!public! !
!WarningClassANSITest categoriesFor: #testXallSubclasses!public! !
!WarningClassANSITest categoriesFor: #testXallSuperclasses!public! !
!WarningClassANSITest categoriesFor: #testXconcatenateOp!public! !
!WarningClassANSITest categoriesFor: #testXhandlesX!public! !
!WarningClassANSITest categoriesFor: #testXname!public! !
!WarningClassANSITest categoriesFor: #testXnew!public! !
!WarningClassANSITest categoriesFor: #testXsignal!public! !
!WarningClassANSITest categoriesFor: #testXsignalX!public! !
!WarningClassANSITest categoriesFor: #testXsubclasses!public! !
!WarningClassANSITest categoriesFor: #testXsuperclass!public! !

