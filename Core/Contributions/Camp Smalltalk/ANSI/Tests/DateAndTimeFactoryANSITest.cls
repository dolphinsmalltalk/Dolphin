"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #DateAndTimeFactoryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DateAndTimeFactoryANSITest guid: (GUID fromString: '{3291905d-72ee-4943-91dc-ca23d5131bc9}')!
DateAndTimeFactoryANSITest comment: ''!
!DateAndTimeFactoryANSITest categoriesForClass!Unclassified! !
!DateAndTimeFactoryANSITest methodsFor!

canonicalObject
	^DateAndTime!

protocol
	^#'DateAndTime factory'!

testXclockPrecision
	" <DateAndTime factory>#clockPrecision "
	#'Date and Time'.
	self value: [DateAndTime clockPrecision]
		should: [:r | "unspecified" true]
		conformTo: #'DateAndTime factory' selector: #'clockPrecision'.!

testXnow
	" <DateAndTime factory>#now "
	#'Date and Time'.
	self value: [DateAndTime now] should: [:r | "unspecified" true]
		conformTo: #'DateAndTime factory' selector: #'now'.!

testXyearXdayXhourXminuteXsecondX
	" <DateAndTime factory>#year:day:hour:minute:second: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	"April 26, 1997 CST"
	self value: [DateAndTime year: 1997 day: 116
				hour: 1 minute: 2 second: 3]
		should: [:r | (r year = 1997) & (r month = 4)
					& (r dayOfMonth = 26)
					& (r hour = 1) & (r minute = 2) & (r second = 3)]
		conformTo: #'DateAndTime factory'
		selector: #'year:day:hour:minute:second:'.!

testXyearXdayXhourXminuteXsecondXoffsetX
	" <DateAndTime factory>#year:day:hour:minute:second:offset: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	"April 26, 1997 CST"
	self value: [DateAndTime year: 1997 day: 116
				hour: 1 minute: 2 second: 3
						offset: (Duration hours: -6 "CST")]
		should: [:r | (r year = 1997) & (r month = 4)
					& (r dayOfMonth = 26)
					& (r hour = 1) & (r minute = 2) & (r second = 3)]
		conformTo: #'DateAndTime factory'
		selector: #'year:day:hour:minute:second:offset:'.!

testXyearXmonthXdayXhourXminuteXsecondX
	" <DateAndTime factory>#year:month:day:hour:minute:second: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	"April 26, 1997 CST"
	self value: [DateAndTime year: 1997 month: 4 day: 26
						hour: 1 minute: 2 second: 3]
		should: [:r | (r year = 1997) & (r month = 4) & (r dayOfMonth = 26)
					& (r hour = 1) & (r minute = 2) & (r second = 3)]
		conformTo: #'DateAndTime factory'
		selector: #'year:month:day:hour:minute:second:'.!

testXyearXmonthXdayXhourXminuteXsecondXoffsetX
	" <DateAndTime factory>#year:month:day:hour:minute:second:offset: "
	#'Date and Time'.
#'todo'. "??? finish impl this. ???"
	"April 26, 1997 CST"
	self value: [DateAndTime year: 1997 month: 4 day: 26
						hour: 1 minute: 2 second: 3
						offset: (Duration hours: -6 "CST")]
		should: [:r | (r year = 1997) & (r month = 4) & (r dayOfMonth = 26)
					& (r hour = 1) & (r minute = 2) & (r second = 3)]
		conformTo: #'DateAndTime factory'
		selector: #'year:month:day:hour:minute:second:offset:'.! !
!DateAndTimeFactoryANSITest categoriesFor: #canonicalObject!public! !
!DateAndTimeFactoryANSITest categoriesFor: #protocol!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXclockPrecision!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXnow!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXyearXdayXhourXminuteXsecondX!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXyearXdayXhourXminuteXsecondXoffsetX!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXyearXmonthXdayXhourXminuteXsecondX!public! !
!DateAndTimeFactoryANSITest categoriesFor: #testXyearXmonthXdayXhourXminuteXsecondXoffsetX!public! !

