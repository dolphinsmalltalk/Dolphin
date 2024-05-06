"Filed out from Dolphin Smalltalk"!

TypeConverter subclass: #NullConverter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NullConverter guid: (GUID fromString: '{87b4c706-026e-11d3-9fd7-00a0cc3e4a32}')!

NullConverter comment: 'NullConverter is a <typeConverter> which applies no transformation to the subject object or result in either direction.'!

!NullConverter categoriesForClass!MVP-Type Converters-General! !

!NullConverter methodsFor!

leftToRight: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject!

rightToLeft: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject! !

!NullConverter categoriesForMethods!
leftToRight:!operations!private! !
rightToLeft:!operations!private! !
!

