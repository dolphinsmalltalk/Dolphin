"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #ErrorClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!ErrorClassANSITest categoriesFor: #canonicalObject!public! !
!ErrorClassANSITest categoriesFor: #protocol!public! !
!ErrorClassANSITest categoriesFor: #testXallSubclasses!public! !
!ErrorClassANSITest categoriesFor: #testXallSuperclasses!public! !
!ErrorClassANSITest categoriesFor: #testXconcatenateOp!public! !
!ErrorClassANSITest categoriesFor: #testXhandlesX!public! !
!ErrorClassANSITest categoriesFor: #testXname!public! !
!ErrorClassANSITest categoriesFor: #testXnew!public! !
!ErrorClassANSITest categoriesFor: #testXsignal!public! !
!ErrorClassANSITest categoriesFor: #testXsignalX!public! !
!ErrorClassANSITest categoriesFor: #testXsubclasses!public! !
!ErrorClassANSITest categoriesFor: #testXsuperclass!public! !

