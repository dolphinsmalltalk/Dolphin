"Filed out from Dolphin Smalltalk"!

Tools.STxDebugger
	subclass: #'Tools.STLDebugger'
	instanceVariableNames: 'slotName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.STLDebugger guid: (Core.GUID fromString: '{2594ee50-2952-4436-bb8b-a33cafe7790e}')!
Tools.STLDebugger comment: ' `STLDebugger` is an `STLInFiler` decorator that prints an indented trace of the contents of the STL file it is reading as it proceeds. `STLDebugger` can be useful for debugging issues with serialized objects, such as tracking down the cause of excessive size of a view resource.

For example to view the contents of a view resource, one can proceed as follows:
```
	rid := UI.ResourceIdentifier class: UI.Shell.
	(STLDebugger dump: rid resource readStream) "Display-it"
''
'!
!Tools.STLDebugger categoriesForClass!System-Binary storage! !
!Tools.STLDebugger methodsFor!

basicNext
	"Private - Answer the next object from the receiver's stream."

	| prefixOrLiteral class anObject newObjectIndex refIndex |
	traceStream cr.
	printOffsets value.
	indentLevel timesRepeat: [traceStream nextPutAll: '    '].
	slotName
		ifNotNil: 
			[traceStream
				display: slotName;
				nextPut: $:;
				space.
			slotName := nil].

	"First, read the prefix."
	prefixOrLiteral := stream next.
	prefixOrLiteral isInteger
		ifFalse: 
			[count := count + 1.
			traceStream print: prefixOrLiteral.
			^prefixOrLiteral value].

	"SmallInteger?"
	(prefixOrLiteral allMask: STxFiler.PrefixSmallIntegerMask)
		ifTrue: 
			[anObject := prefixOrLiteral bitShift: -1.
			count := count + 1.
			traceStream print: anObject.
			^anObject].

	"Literal?"
	prefixOrLiteral == STxFiler.PrefixLiteralMask
		ifTrue: 
			[| literal |
			literal := decorated readLiteralData.
			count := count + 1.
			traceStream
				print: decorated readMap size;
				nextPutAll: ': '.
			literal printOn: (LimitedWriteStream over: traceStream).
			^literal].
	refIndex := prefixOrLiteral bitShift: STxFiler.PrefixRefUnshift.
	(prefixOrLiteral allMask: STxFiler.PrefixDataMask)
		ifFalse: 
			[(prefixOrLiteral anyMask: STxFiler.PrefixCharacterMask)
				ifTrue: 
					["Should only be encountered in STL 3 streams"
					anObject := self characterValue: refIndex.
					count := count + 1.
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
	(prefixOrLiteral allMask: STxFiler.PrefixClassMask)
		ifTrue: 
			[class := decorated readClassDataWithPrefix: prefixOrLiteral.
			traceStream display: class name]
		ifFalse: 
			[class := self classAt: refIndex.
			traceStream nextPutAll: class name].
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
				nextPutAll: ': '.
			traceStream print: anObject].
	indentLevel := indentLevel - 1.
	"If anObject was a proxy for the real one, evaluate it now."
	^anObject stbFixup: self at: newObjectIndex!

inFilerClass
	^STLInFiler! !
!Tools.STLDebugger categoriesForMethods!
basicNext!accessing!private! !
inFilerClass!constants!private! !
!

