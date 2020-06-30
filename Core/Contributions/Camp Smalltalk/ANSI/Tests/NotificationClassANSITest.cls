"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #NotificationClassANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!NotificationClassANSITest categoriesFor: #canonicalObject!public! !
!NotificationClassANSITest categoriesFor: #protocol!public! !
!NotificationClassANSITest categoriesFor: #testXallSubclasses!public! !
!NotificationClassANSITest categoriesFor: #testXallSuperclasses!public! !
!NotificationClassANSITest categoriesFor: #testXconcatenateOp!public! !
!NotificationClassANSITest categoriesFor: #testXhandlesX!public! !
!NotificationClassANSITest categoriesFor: #testXname!public! !
!NotificationClassANSITest categoriesFor: #testXnew!public! !
!NotificationClassANSITest categoriesFor: #testXsignal!public! !
!NotificationClassANSITest categoriesFor: #testXsignalX!public! !
!NotificationClassANSITest categoriesFor: #testXsubclasses!public! !
!NotificationClassANSITest categoriesFor: #testXsuperclass!public! !

