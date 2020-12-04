"Filed out from Dolphin Smalltalk 7"!

UI.TypeConverter subclass: #'UI.NullConverter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.NullConverter guid: (Core.GUID fromString: '{87b4c706-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.NullConverter comment: 'NullConverter is a <typeConverter> which applies no transformation to the subject object or result in either direction.'!
!UI.NullConverter categoriesForClass!MVP-Type Converters-General! !
!UI.NullConverter methodsFor!

leftToRight: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject!

rightToLeft: anObject
	"Private - For a NullConverter this does nothing"
	
	^anObject! !
!UI.NullConverter categoriesFor: #leftToRight:!operations!private! !
!UI.NullConverter categoriesFor: #rightToLeft:!operations!private! !

