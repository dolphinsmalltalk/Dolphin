"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #WarningClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!WarningClassANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
testXallSubclasses!public! !
testXallSuperclasses!public! !
testXconcatenateOp!public! !
testXhandlesX!public! !
testXname!public! !
testXnew!public! !
testXsignal!public! !
testXsignalX!public! !
testXsubclasses!public! !
testXsuperclass!public! !
!

