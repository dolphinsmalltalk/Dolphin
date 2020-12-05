"Filed out from Dolphin Smalltalk 7"!

STON.StreamWriter subclass: #'STON.MapWriter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.MapWriter guid: (Core.GUID fromString: '{934f79fb-8d08-4d18-aedc-36e3878d689e}')!
STON.MapWriter comment: 'STONDictionaryWriter helps in writing dictionary based STON representations.'!
!STON.MapWriter categoriesForClass!STON-Core-Writer! !
!STON.MapWriter methodsFor!

at: key put: value
	first ifTrue: [ first := false ] ifFalse: [ writer mapElementSeparator ].
	writer encodeKey: key value: value! !
!STON.MapWriter categoriesFor: #at:put:!accessing!public! !

