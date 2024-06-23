"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #ErrorClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ErrorClassANSITest guid: (GUID fromString: '{9146d8ba-8fce-4db0-94e7-771cf4e7dac9}')!

ErrorClassANSITest comment: ''!

!ErrorClassANSITest categoriesForClass!Unclassified! !

!ErrorClassANSITest methodsFor!

canonicalObject
	^Error!

protocol
	^#'Error class'!

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
	" <Error class>#new "
	#'Exception'.
	self value: [Error new] should: [:r | true "??? r = Error signal ???"]
		conformTo: #'Error class' selector: #'new'.!

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

!ErrorClassANSITest categoriesForMethods!
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

