"Filed out from Dolphin Smalltalk"!

Kernel.STLLegacyOutFiler
	subclass: #'Kernel.STLOutFiler3'
	instanceVariableNames: 'globals globalNils'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.STLOutFiler3 guid: (Core.GUID fromString: '{819044fa-ab3f-453d-9601-3d7a45ddcc55}')!
Kernel.STLOutFiler3 comment: '`STLOutFiler3` is a `STLOutFiler` that writes object graphs in the STL v3 format.

STL 3 was the original STL format introduced in Dolphin 6. There were no versions prior to 3 as the version number was synchronised with the STB version current at the time. This was partly because there was a lot of shared implementation and the object prefix encoding was the same. Not all literals were necessarily written as literals into the STL; nil appeared as the special prefix code zero (as in STB), and likewise Characters were encoded in the prefix. The same predefined objects and classes were also used, so some classes were not directly visible in the literal array source, but were hidden in the encoding (e.g. Array).'!
!Kernel.STLOutFiler3 categoriesForClass!System-Binary storage! !
!Kernel.STLOutFiler3 methodsFor!

inFilerClass
	^STLInFiler3!

locatorKeyFor: aClass
	"Answer a <String> name for the <Class> argument that receiver's class locator can use to resolve the class."

	"We need to use a backwards compatible name that would have been used for the class prior to the introduction of namespaces in Dolphin 8. This will be the unqualified name that would have appeared in the Smalltalk dictionary."

	^self preNamespaceLocatorKeyFor: aClass!

nextPut: anObject
	"Write anObject to the stream in STL format."

	| objectToSave |
	"Originally STB had a special mechanism for saving globals that would have the deliberate side-effect of inserting variables into the Smalltalk dictionary when deserialising. This was really intended only for use in the original binary packages, and fell out of use when source format packages were introduced. The mechanism remained, however, and although it should never have been part of STL it was inherited through shared implementation. It was finally dropped from STx 5 in Dolphin 8"
	(self objectIsGlobal: anObject)
		ifTrue: 
			[self putGlobal: anObject.
			^anObject].
	(self refForObject: anObject)
		ifNotNil: 
			[:refIndex |
			self writeReference: refIndex.
			^anObject].	"If anObject is the subject of an override:with: message then we output the 'with' proxy object instead."
	objectToSave := self overrideFor: anObject.
	objectToSave == Collection.AbsentCookie
		ifTrue: [anObject stbSaveOn: self]
		ifFalse: 
			[objectToSave notNil ifTrue: [self removeOverrideFor: anObject].
			self saveObject: anObject as: objectToSave].
	^anObject!

objectIsGlobal: anObject
	"Private - Answer true if anObject has been registered as global."

	anObject isNil
		ifTrue: [^globalNils isEmpty not].

	^globals includesKey: anObject!

putGlobal: anObject
	"Private - Wrap anObject up as an STBGlobalObjectProxy and output that instead."

	| symbolCollection symbol |
	anObject isNil
		ifTrue: [symbol := globalNils removeFirst]
		ifFalse: 
			[symbolCollection := globals at: anObject.
			symbol := symbolCollection removeFirst.
			symbolCollection isEmpty ifTrue: [globals removeKey: anObject]].
	self nextPut: (Smalltalk.STBGlobalObjectProxy for: anObject name: symbol)!

register: anObject asGlobal: aSymbol
	"Add anObject to the globals dictionary.
	When this object is output it will be wrapped in an STBGlobalObjectProxy.
	When the proxy is subsequently loaded it be added to Smalltalk with the
	name aSymbol. If the same object is registered as several global symbols
	then it must be #nextPut: a corresponding number of times." 

	(anObject isNil
		ifTrue: [globalNils]
		ifFalse: [globals at: anObject ifAbsentPut: [OrderedCollection new]]) add: aSymbol!

registerPredefined
	super registerPredefined.
	globals := IdentityDictionary new.
	globalNils := OrderedCollection new.!

registerPredefinedObjects
	"Private - We pre-register objects that must never be recreated - note that if the 'fixed' list of pre-registered objects is changed, then the STB version must be
	changed and an upgrade mechanism put in place."

	self
		register: true;
		register: false;
		register: Smalltalk;
		register: Processor!

saveArray: anArray
	"Save an <Array> to the object stream."

	"Arrays were never written in literal form - always broken down."

	| size |
	self writePreambleFor: anArray class: anArray basicClass.
	stream nextPut: (size := anArray basicSize).
	1 to: size do: [:i | self nextPut: (anArray basicAt: i)]!

saveCharacter: aCharacter
	"Serialize a <Character> to the object stream."

	"In the original STL format (3), Characters were encoded, as in STB, and could only be byte-characters in the encoding of the system ANSI code page. This did mean that some characters may not restore correctly on a system with a different code page."

	| codeUnit |
	codeUnit := aCharacter codeUnit.
	codeUnit > 255 ifTrue: [self errorExtendedCharacterNotSupported: aCharacter].
	stream nextPut: ((codeUnit bitShift: PrefixRefShift) bitOr: PrefixCharacterMask)!

saveClass: aClass
	"Serialize a <Class> to the object stream. Note that only a reference is saved. The class must be present in the image where the stream is deserialised."

	"In STL 3 classes were stored as if literals, and had a literal prefix. This wasn't really necessary since classes are atomic."

	self writeLiteral: aClass!

saveFloat: aFloat
	"Serialize a <Float> to the object stream."

	"In STL 3/4, Float's were not stored as literals, but as the raw bytes (little-endian)"

	self writePreambleFor: aFloat class: aFloat basicClass.
	stream nextPut: 8.
	1 to: 8 do: [:i | stream nextPut: (aFloat basicAt: i)]!

saveMetaclass: aMetaclass
	"Save a metaclass instance to the object stream."

	"In STL 3/4 metaclasses were proxied"

	| inst |
	inst := aMetaclass instanceClass.
	self saveObject: aMetaclass
		as: (STBMetaclassProxy locatorKey: (self locatorKeyFor: inst) package: inst owningPackage)!

saveNil
	"Serialize nil to the object stream"

	"An oversite in STL 3 was that nil was not written as a literal"

	stream nextPut: 0!

saveObject: anObject as: anObjectToSave
	"If anObjectToSave is zero then output anObject as normal (ie. without any proxy)."

	anObjectToSave == 0 ifTrue: [^self saveObject: anObject].

	"A proxy of nil means output nil instead of anObject."
	anObjectToSave ifNil: [^self saveNil].

	"Output anObjectToSave (usually a proxy) instead of anObject"
	self
		writeProxyPreambleFor: anObject class: anObjectToSave basicClass;
		writeInstanceVariables: anObjectToSave!

saveScaledDecimal: aScaledDecimal
	"Serialize a <ScaledDecimal> to the object stream."

	self saveObject: aScaledDecimal!

saveStatic: aBindingReference
	"Serialize a static variable reference into the stream."

	"Requires <BindingReference>s, which did not exist at the time of STL 3/4."

	self errorStaticVarRefsNotSupported!

saveString: aString
	"Serialize a <String> into the object stream."

	"In STL 3 only byte strings were supported. Dolphin's string literals at the time were compiled as AnsiString instances. These didn't necessarily round-trip correctly between images running on a host OS with a different system code page. There was no support for extended Unicode characters."

	aString asAnsiString asUtf8String = aString
		ifFalse: 
			[STBError
				signal: 'String contains extended character that cannot be represented in STL 3: <1p>' << aString].
	self writeLiteral: aString!

saveSymbol: aSymbol
	self writeLiteral: aSymbol!

saveVariableBinding: aVariableBinding
	"Pre-namespace format"

	self
		writePreambleFor: aVariableBinding
			class: self variableBindingClass
			version: 0
			instSize: 2;
		nextPut: aVariableBinding key;
		nextPut: aVariableBinding value!

variableBindingClass
	^Association!

writeByteObject: aByteObject
	"Private - Bytes of byte objects other than ByteArrays were written individually"

	| size |
	size := aByteObject basicSize.
	stream nextPut: size.
	1 to: size do: [:i | stream nextPut: (aByteObject basicAt: i)]!

writeClass: aClass prefix: anInteger version: verInteger instSize: sizeInteger
	| code locatorString |
	locatorString := self locatorKeyFor: aClass.
	code := anInteger bitOr: ((locatorString size bitShift: PrefixLocatorLenShift)
						bitOr: (sizeInteger bitShift: PrefixInstSizeShift)).
	aClass isVariable
		ifTrue: [code := code bitOr: (aClass isBytes ifTrue: [PrefixBytesMask] ifFalse: [PrefixVariableMask])].
	verInteger == 0
		ifTrue: [stream nextPut: code]
		ifFalse: 
			[stream
				nextPut: (code bitOr: PrefixNonZeroVersionMask);
				nextPut: verInteger].
	stream nextPut: aClass!

writeReference: anInteger
	"nil was not written as a literal, but as its STB reference, 0"

	stream nextPut: (anInteger bitShift: PrefixRefShift)! !
!Kernel.STLOutFiler3 categoriesForMethods!
inFilerClass!constants!private! !
locatorKeyFor:!helpers!public! !
nextPut:!accessing!public! !
objectIsGlobal:!globals!private! !
putGlobal:!globals!private! !
register:asGlobal:!globals!public! !
registerPredefined!initializing!public! !
registerPredefinedObjects!initializing!private! !
saveArray:!operations!public! !
saveCharacter:!operations!public! !
saveClass:!operations!public! !
saveFloat:!operations!public! !
saveMetaclass:!operations!public! !
saveNil!operations!public! !
saveObject:as:!operations!public! !
saveScaledDecimal:!public!serializing! !
saveStatic:!public!serializing! !
saveString:!public!serializing! !
saveSymbol:!public!serializing! !
saveVariableBinding:!public!serializing! !
variableBindingClass!constants!private! !
writeByteObject:!operations!private! !
writeClass:prefix:version:instSize:!operations!private! !
writeReference:!operations!private! !
!

!Kernel.STLOutFiler3 class methodsFor!

initialize
	"
	self initialize
	"

	self register!

literalPrinterClass
	^LegacySTLPrinter!

uninitialize
	self unregister!

version
	"Answer the version number of the format produced by the receiver."

	^3! !
!Kernel.STLOutFiler3 class categoriesForMethods!
initialize!class initialization!public! !
literalPrinterClass!constants!public! !
uninitialize!class hierarchy-removing!public! !
version!constants!public! !
!

