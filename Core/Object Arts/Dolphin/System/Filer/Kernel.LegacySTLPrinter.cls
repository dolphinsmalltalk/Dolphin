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

printClass: aClass
	stream
		nextPutAll: '##(Smalltalk.';
		nextPutAll: (self nameForClass: aClass);
		nextPut: $)!

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
printClass:!printing!public! !
printMetaclass:!printing!public! !
printProcessor:!printing!public! !
!

