"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.StringPointerArrayTest
	subclass: #'OS.COM.Tests.LPWSTRArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.LPWSTRArrayTest guid: (Core.GUID fromString: '{e90f2fcf-c993-418f-bb52-ee22925cf849}')!

OS.COM.Tests.LPWSTRArrayTest comment: ''!

!OS.COM.Tests.LPWSTRArrayTest class methodsFor!

arrayClass
	^LPWSTRArray!

elementFromIndex: anInteger
	^##({
		''.
		'a'.
		'£'.
		'a£🍺ö'.
		'Ḽơᶉëᶆ ȋṕšᶙṁ ḍỡḽǭᵳ ʂǐť ӓṁệẗ, ĉṓɲṩḙċťᶒțûɾ ấɖḯƥĭṩčįɳġ ḝłįʈ, șếᶑ ᶁⱺ ẽḭŭŝḿꝋď ṫĕᶆᶈṓɍ ỉñḉīḑȋᵭṵńť ṷŧ ḹẩḇőꝛế éȶ đꝍꞎôꝛȇ ᵯáꞡᶇā ąⱡîɋṹẵ'.
		Utf16String with: $\x1 with: $\x7F with: $\x80 with: $\xFF
	}) at: anInteger

! !

!OS.COM.Tests.LPWSTRArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

