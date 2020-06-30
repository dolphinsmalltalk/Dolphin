"Filed out from Dolphin Smalltalk 7"!

STONWriteReadTest subclass: #STONWritePrettyPrinterReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!STONWritePrettyPrinterReadTest categoriesFor: #serialize:!private! !
!STONWritePrettyPrinterReadTest categoriesFor: #serializeJson:!private! !

