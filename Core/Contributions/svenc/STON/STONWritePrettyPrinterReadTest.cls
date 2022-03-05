"Filed out from Dolphin Smalltalk"!

STONWriteReadTest subclass: #STONWritePrettyPrinterReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONWritePrettyPrinterReadTest guid: (GUID fromString: '{0d657511-dca9-4a01-becd-1d55b4c6d33d}')!
STONWritePrettyPrinterReadTest comment: 'STONWritePrettyPrinterReadTests tests pretty printed serialization followed by materialization.'!
!STONWritePrettyPrinterReadTest categoriesForClass!STON-Tests-Writer! !
!STONWritePrettyPrinterReadTest methodsFor!

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
!STONWritePrettyPrinterReadTest categoriesForMethods!
serialize:!private! !
serializeJson:!private! !
!

