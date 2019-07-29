"Filed out from Dolphin Smalltalk 7"!

STONWriteReadTests subclass: #STONWritePrettyPrinterReadTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONWritePrettyPrinterReadTests guid: (GUID fromString: '{0d657511-dca9-4a01-becd-1d55b4c6d33d}')!
STONWritePrettyPrinterReadTests comment: 'STONWritePrettyPrinterReadTests tests pretty printed serialization followed by materialization.'!
!STONWritePrettyPrinterReadTests categoriesForClass!STON-Tests-Writer! !
!STONWritePrettyPrinterReadTests methodsFor!

serialize: anObject
	^ String streamContents: [ :stream |
		STON writer 
			on: stream; 
			prettyPrint: true;
			nextPut: anObject ]!

serializeJson: anObject
	^ String streamContents: [ :stream |
		STON jsonWriter 
			on: stream; 
			prettyPrint: true;
			nextPut: anObject ]! !
!STONWritePrettyPrinterReadTests categoriesFor: #serialize:!private! !
!STONWritePrettyPrinterReadTests categoriesFor: #serializeJson:!private! !

