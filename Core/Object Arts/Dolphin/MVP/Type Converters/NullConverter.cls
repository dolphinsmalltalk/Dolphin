"Filed out from Dolphin Smalltalk X6"!

TypeConverter subclass: #NullConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NullConverter guid: (GUID fromString: '{87B4C706-026E-11D3-9FD7-00A0CC3E4A32}')!
NullConverter comment: 'NullConverter is a <typeConverter> which applies no transformation to the subject object or result in either direction.'!
!NullConverter categoriesForClass!MVP-Type Converters-General! !
!NullConverter methodsFor!

leftToRight: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject!

rightToLeft: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject! !
!NullConverter categoriesFor: #leftToRight:!operations!private! !
!NullConverter categoriesFor: #rightToLeft:!operations!private! !

