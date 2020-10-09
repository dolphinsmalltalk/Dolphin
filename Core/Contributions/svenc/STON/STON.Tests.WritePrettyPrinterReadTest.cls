"Filed out from Dolphin Smalltalk 7"!

STON.Tests.WriteReadTest subclass: #'STON.Tests.WritePrettyPrinterReadTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.WritePrettyPrinterReadTest guid: (Core.GUID fromString: '{0d657511-dca9-4a01-becd-1d55b4c6d33d}')!
STON.Tests.WritePrettyPrinterReadTest comment: 'STONWritePrettyPrinterReadTests tests pretty printed serialization followed by materialization.'!
!STON.Tests.WritePrettyPrinterReadTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.WritePrettyPrinterReadTest methodsFor!

serialize: anObject
	^String streamContents: 
			[:stream |
			STON prettyPrinter
				on: stream;
				nextPut: anObject]!

serializeJson: anObject
	^String streamContents: 
			[:stream |
			STON jsonPrettyPrinter
				on: stream;
				nextPut: anObject]! !
!STON.Tests.WritePrettyPrinterReadTest categoriesFor: #serialize:!private! !
!STON.Tests.WritePrettyPrinterReadTest categoriesFor: #serializeJson:!private! !

