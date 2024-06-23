"Filed out from Dolphin Smalltalk"!

Kernel.STLOutFiler3
	subclass: #'Kernel.STLOutFiler4'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.STLOutFiler4 guid: (Core.GUID fromString: '{c8aba593-004c-40d3-80be-31312461a642}')!

Kernel.STLOutFiler4 comment: '`STBOutFiler4` is an `STLOutFiler` for writing object graphs in the the STL 4 serialization format introduced in Dolphin 7.1.

STL 4 primarily differed from STL 3 in storing all strings as UTF-8 encoded literal strings. At some point in its history nil''s started being written in literal form rather than as a zero prefix code, but although this should have resulted in a version increment, that did not happen.'!

!Kernel.STLOutFiler4 categoriesForClass!System-Binary storage! !

!Kernel.STLOutFiler4 methodsFor!

inFilerClass
	^STLInFiler4!

registerPredefinedObjects
	"Private - Post version 3, don't pre-register standard objects with literal representation as we write these directly to the stream."!

saveArray: anArray
	"Save an <Array> to the object stream."

	"As of STL 4 Arrays containing only atomic objects were written as literals. This is because there is no need to consider reference identity for these objects since it is implicit (an atomic class of objects is one where any one value can only have one instance). However metaclasses were not considered atomic in D7."

	(anArray allSatisfy: [:each | each isAtomic and: [each class ~~ Metaclass]])
		ifTrue: [self writeLiteral: anArray]
		ifFalse: 
			[| size |
			"No literal form, need to break it down"
			self writePreambleFor: anArray class: anArray basicClass.
			stream nextPut: (size := anArray basicSize).
			1 to: size do: [:i | self nextPut: (anArray basicAt: i)]]!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	"As of STL 4, Characters are stored as literals rather than encoded in the object prefix. However all characters, even non-atomic ones, were written without a literal prefix, so there was potential for multiple characters to be created on deserialization. Only the byte characters should have been written without a literal prefix so as to preserve the identity of non-byte characters.. This was not usually an issue in practice, at least in STL view resources, because (a) individual characters rarely occur in serialised content, and (b) STL view resources are stored in compiled methods, and the compiler folds equivalent characters when building the literal frame. The issue is corrected in STL 6."

	stream nextPut: aCharacter!

saveClass: aClass
	"Serialize a <Class> to the object stream. Note that only a reference is saved. The class must be present in the image where the stream is deserialised."

	"In STL4 the class is stored as a literal reference by printing it as ##() expression when storing as source. When compiled this results in a direct reference to the class in the STL array."

	stream nextPut: aClass!

saveString: aString
	"Serialize a <String> into the object stream."

	"In STL 4 strings were always stored as UTF-8 literals. The class of Utf16Strings and AnsiStrings was not preserved, but identity within the graph was, i.e. a string with shared references in the input graph will have the same shared references in the deserialised graph. Non-literal (unprintable) strings didn't work, although were unlikely to appear in the object graph in practice."

	| utf8 |
	utf8 := aString asUtf8String.
	stream
		nextPut: PrefixLiteralMask;
		nextPut: utf8.
	self register: aString!

saveSymbol: aSymbol
	stream nextPut: aSymbol!

variableBindingClass
	^VariableBinding!

writeReference: anInteger
	stream nextPut: (anInteger == 0 ifFalse: [anInteger bitShift: PrefixRefShift])! !

!Kernel.STLOutFiler4 categoriesForMethods!
inFilerClass!constants!private! !
registerPredefinedObjects!initializing!private! !
saveArray:!operations!public! !
saveCharacter:!operations!public! !
saveClass:!operations!public! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
variableBindingClass!constants!private! !
writeReference:!operations!private! !
!

!Kernel.STLOutFiler4 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

uninitialize
	self unregister!

version
	"Answer the version number of the format produced by the receiver."

	^4! !

!Kernel.STLOutFiler4 class categoriesForMethods!
initialize!class initialization!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

