"Filed out from Dolphin Smalltalk"!

Tools.STxDebugger
	subclass: #'Tools.STBDebugger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.STBDebugger guid: (Core.GUID fromString: '{87b4c6e9-026e-11d3-9fd7-00a0cc3e4a32}')!
Tools.STBDebugger comment: '`STBDebugger` is an `STBInFiler` decorator that prints an indented trace of the contents of the STB file it is reading as it proceeds. `STBDebugger`s can be useful for debugging issues with serialized objects.

For example:
```
	bytes := (50@60 extent: 100@200) binaryStoreBytes.
	(STBDebugger dump: bytes readStream)."Display-it"
```
'!
!Tools.STBDebugger categoriesForClass!System-Binary storage! !
!Tools.STBDebugger methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| class anObject newObjectIndex prefixCode refIndex |
	traceStream cr.
	printOffsets value.
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].

	"First, read the prefix."
	prefixCode := stream nextInt32.
	"Now decode"
	(prefixCode allMask: STxFiler.PrefixSmallIntegerMask)
		ifTrue: 
			[count := count + 1.
			anObject := prefixCode bitShift: -1.
			traceStream
				nextPut: $[;
				print: anObject;
				nextPut: $].
			^anObject].
	refIndex := prefixCode bitShift: STxFiler.PrefixRefUnshift.
	(prefixCode allMask: STxFiler.PrefixDataMask)
		ifFalse: 
			[(prefixCode anyMask: STxFiler.PrefixCharacterMask)
				ifTrue: 
					[count := count + 1.
					anObject := self characterValue: refIndex.
					traceStream
						nextPut: $[;
						print: anObject;
						nextPut: $]]
				ifFalse: 
					[anObject := self objectAt: refIndex.
					traceStream
						nextPutAll: '[<';
						print: refIndex;
						nextPutAll: ': '.
					anObject printOn: (LimitedWriteStream over: traceStream).
					traceStream nextPutAll: '>]'].
			^anObject].

	"Ascertain the class of the object."
	indentLevel := indentLevel + 1.
	traceStream nextPut: $[.
	(prefixCode allMask: STxFiler.PrefixClassMask)
		ifTrue: 
			[class := decorated readClassDataWithPrefix: prefixCode.
			traceStream
				nextPutAll: (decorated locatorKeyFor: class);
				nextPut: $;.
			(decorated converterFor: class) ifNotNil: [:converter | traceStream print: converter version]]
		ifFalse: 
			[class := self classAt: refIndex.
			traceStream nextPutAll: (self locatorKeyFor: class)].
	traceStream nextPut: $].

	"Now read the object data."
	count := count + 1.
	newObjectIndex := decorated nextIndex.
	anObject := class stbReadFrom: self format: (decorated converterFor: class).
	class isBytes
		ifTrue: 
			[traceStream
				space;
				print: newObjectIndex;
				nextPutAll: ': ';
				print: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, or has some other need of fix up, do that now."
	^anObject stbFixup: self at: newObjectIndex!

inFilerClass
	^STBInFiler!

readSizeOf: aClass
	"Read the indexable size of an object of the specified <Class> from the object stream."

	| size |
	size := decorated readSizeOf: aClass.
	aClass isVariable
		ifTrue: 
			[traceStream
				nextPut: $[;
				print: size;
				nextPut: $]].
	^size! !
!Tools.STBDebugger categoriesForMethods!
basicNext!accessing!private! !
inFilerClass!constants!private! !
readSizeOf:!deserializing!public! !
!

