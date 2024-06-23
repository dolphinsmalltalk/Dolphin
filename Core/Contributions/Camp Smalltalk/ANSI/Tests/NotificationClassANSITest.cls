"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #NotificationClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NotificationClassANSITest guid: (GUID fromString: '{aae311a2-df97-404e-91f1-c2e89465646e}')!

NotificationClassANSITest comment: ''!

!NotificationClassANSITest categoriesForClass!Unclassified! !

!NotificationClassANSITest methodsFor!

canonicalObject
	^Notification!

protocol
	^#'Notification class'!

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
	" <Notification class>#new "
	#'Exception'.
	self value: [Notification new]
		should: [:r | true "??? r = Notification signal ???"]
		conformTo: #'Notification class' selector: #'new'.!

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

!NotificationClassANSITest categoriesForMethods!
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

