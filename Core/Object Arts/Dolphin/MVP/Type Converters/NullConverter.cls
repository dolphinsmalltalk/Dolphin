"Filed out from Dolphin Smalltalk 7"!

TypeConverter subclass: #NullConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NullConverter guid: (GUID fromString: '{87B4C706-026E-11D3-9FD7-00A0CC3E4A32}')!
NullConverter comment: 'NullConverter is a <typeConverter> which applies no transformation to the subject object or result in either direction.'!
!NullConverter categoriesForClass!MVP-Type Converters-General! !
!NullConverter methodsFor!

= comparand

	^self class == comparand class and: [
		self leftNullValue = comparand leftNullValue and: [
		self rightNullValue = comparand rightNullValue]]!

hash

	^leftNullValue hash!

leftToRight: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject!

rightToLeft: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject!

storeOn: aStream indent: anInteger variables: aDictionary

	(leftNullValue isNil and: [rightNullValue isNil]) ifTrue: [
		aStream nextPutAll: 'NullConverter new'.
	] ifFalse: [
		super storeOn: aStream indent: anInteger variables: aDictionary.
	].! !
!NullConverter categoriesFor: #=!comparing!public! !
!NullConverter categoriesFor: #hash!comparing!public! !
!NullConverter categoriesFor: #leftToRight:!operations!private! !
!NullConverter categoriesFor: #rightToLeft:!operations!private! !
!NullConverter categoriesFor: #storeOn:indent:variables:!public! !

