"Filed out from Dolphin Smalltalk XP 2002 release 6.00"!

SUnitBrowserAbsTC subclass: #SUnitBrowserModelAbsTC
	instanceVariableNames: 'model'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SUnitBrowserModelAbsTC guid: (GUID fromString: '{86B0382F-449D-4858-9A18-BAC1A9343913}')!
SUnitBrowserModelAbsTC comment: ''!
!SUnitBrowserModelAbsTC categoriesForClass!Unclassified! !
!SUnitBrowserModelAbsTC methodsFor!

browser

	^self model browser
			!

model

	^model
			!

model: anSunitBrowserModel

	model := anSunitBrowserModel
			!

result

	^self model testResult
			!

setUp

	super setUp.

	self setUpModel!

setUpModel

	self model: (
		SUnitBrowserModel
			newForUI: SUnitBrowserDummyUI new
			builder: self sunitTestCaseClass)! !
!SUnitBrowserModelAbsTC categoriesFor: #browser!accessing!private! !
!SUnitBrowserModelAbsTC categoriesFor: #model!accessing!private! !
!SUnitBrowserModelAbsTC categoriesFor: #model:!accessing!private! !
!SUnitBrowserModelAbsTC categoriesFor: #result!accessing!private! !
!SUnitBrowserModelAbsTC categoriesFor: #setUp!public!running! !
!SUnitBrowserModelAbsTC categoriesFor: #setUpModel!private!running! !

