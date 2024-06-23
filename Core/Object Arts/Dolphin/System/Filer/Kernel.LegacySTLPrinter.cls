"Filed out from Dolphin Smalltalk"!

Kernel.LiteralPrinter
	subclass: #'Kernel.LegacySTLPrinter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.LegacySTLPrinter guid: (Core.GUID fromString: '{e3eaf1b8-b401-429a-afdb-c99fd9f34d8e}')!

Kernel.LegacySTLPrinter comment: ''!

!Kernel.LegacySTLPrinter categoriesForClass!Kernel-Objects! !

!Kernel.LegacySTLPrinter methodsFor!

getShortName: aProgramObject
	| name |
	name := aProgramObject shortName.
	^(BindingReference isQualifiedName: name)
		ifTrue: [SourceFormatNotSupportedError signalWith: aProgramObject]
		ifFalse: [name]!

nameForClass: aClass
	^(Smalltalk oldNames lookup: aClass) ifNil: [self getShortName: aClass]!

printBindingReference: aBindingReference
	"BindingReferences are not supported prior to Dolphin 8."

	self shouldNotImplement!

printCharacter: aCharacter
	"In STL4, only printable byte characters were unescaped"

	| code |
	code := aCharacter code.
	(code > 32 and: [code < 127 or: [code <= 255 and: [aCharacter isGraph]]])
		ifTrue: 
			[stream
				nextPut: $$;
				nextPut: aCharacter]
		ifFalse: [aCharacter printEscapedOn: stream]!

printClass: aClass
	stream nextPutAll: '##(Smalltalk'.
	aClass == Smalltalk
		ifFalse: 
			[stream
				nextPut: $.;
				nextPutAll: (self nameForClass: aClass)].
	stream nextPut: $)!

printLiteralStoreArray: anArray
	stream nextPutAll: '#('.
	anArray do: 
			[:each |
			each literalPrintOn: self.
			stream space].
	stream nextPut: $)!

printMetaclass: aMetaclass
	stream
		nextPutAll: '##(Smalltalk.';
		nextPutAll: (self nameForClass: aMetaclass instanceClass);
		nextPutAll: ' class)'!

printProcessor: aProcessor
	stream nextPutAll: '##(Smalltalk.Processor)'!

printString: aString
	"In STL4 strings with embedded nulls were just trimmed so they would not serialize correctly. Not great, but that is what it did."

	aString trimNulls printOn: stream! !

!Kernel.LegacySTLPrinter categoriesForMethods!
getShortName:!helpers!private! !
nameForClass:!helpers!printing!private! !
printBindingReference:!printing!public! !
printCharacter:!printing!public! !
printClass:!printing!public! !
printLiteralStoreArray:!public! !
printMetaclass:!printing!public! !
printProcessor:!printing!public! !
printString:!printing!public! !
!

