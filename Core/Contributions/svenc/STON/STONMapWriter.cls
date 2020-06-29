"Filed out from Dolphin Smalltalk 7"!

STONStreamWriter subclass: #STONMapWriter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONMapWriter guid: (GUID fromString: '{934f79fb-8d08-4d18-aedc-36e3878d689e}')!
STONMapWriter comment: 'STONDictionaryWriter helps in writing dictionary based STON representations.'!
!STONMapWriter categoriesForClass!STON-Core-Writer! !
!STONMapWriter methodsFor!

at: key put: value
	first ifTrue: [ first := false ] ifFalse: [ writer mapElementSeparator ].
	writer encodeKey: key value: value! !
!STONMapWriter categoriesFor: #at:put:!accessing!public! !

