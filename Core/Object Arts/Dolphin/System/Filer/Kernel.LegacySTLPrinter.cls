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

print: aLiteralObject
	"In STL4 strings with embedded nulls were just trimmed so they would not serialize correctly. Not great, but that is what it did."

	(aLiteralObject isString ifTrue: [aLiteralObject trimNulls] ifFalse: [aLiteralObject])
		printOn: stream!

printClass: aClass
	stream nextPutAll: '##(Smalltalk'.
	aClass == Smalltalk
		ifFalse: 
			[stream
				nextPut: $.;
				nextPutAll: (self nameForClass: aClass)].
	stream nextPut: $)!

printMetaclass: aMetaclass
	stream
		nextPutAll: '##(Smalltalk.';
		nextPutAll: (self nameForClass: aMetaclass instanceClass);
		nextPutAll: ' class)'!

printProcessor: aProcessor
	stream nextPutAll: '##(Smalltalk.Processor)'! !
!Kernel.LegacySTLPrinter categoriesForMethods!
getShortName:!helpers!private! !
nameForClass:!helpers!printing!private! !
print:!printing!public! !
printClass:!printing!public! !
printMetaclass:!printing!public! !
printProcessor:!printing!public! !
!

