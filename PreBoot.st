"This file contains patches to base system classes that are required in order to be able to reload the base class library, but which are not yet consolidated into the boot image. Note that the BCL is reloaded anyway (see Boot.st), so most BCL changes do not require pre-patching; try without first"!

VMLibrary default primRegistryAt: 71 put: #~~; primRegistryAt: 72 put: #not!

!Array class methodsFor!
 
newFromStack: aSmallInteger
	<primitive: 190>
	^self primitiveFailed! !

AttributeDescriptorFlags keysAndValuesDo: [:k :v | AttributeDescriptor addClassConstant: k value: v].
AttributeDescriptor addClassConstant: 'NonBrowsableMask' value: 128!
#(#AttributeDescriptorFlags #STBPrefixConstants) do: [:each | Package manager systemPackage removeGlobalNamed: each. Smalltalk removeKey: each ifAbsent: []]!
ClassLocator.ImportedClasses := nil!
!ClassLocator class methodsFor!

isImportedClass: aClass
	^ImportedClasses notNil and: [ImportedClasses identityIncludes: aClass]! !
!ClassLocator class categoriesFor: #isImportedClass:!public!testing! !
!Package methodsFor!

isImportedClass: aClass
	"Private - Answer true if aClass is an imported binary class"

	^ClassLocator isImportedClass: aClass! !
!Package categoriesFor: #isImportedClass:!private!testing! !

"Switch to new identity hash - which is tricky"!

!Object methodsFor!

basicIdentityHash
	<primitive: 75>
	^self primitiveFailed! !

!SmallInteger methodsFor!

basicIdentityHash
	^self! !

!MethodDictionary methodsFor!

hash: anObject max: anInteger
	"Implementation Note: This must match the selector hashing implementation used by the VM."

	^(anObject basicIdentityHash bitAnd: anInteger - 1) + 1! !

!IdentitySet methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!SharedIdentitySet methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!IdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!SharedIdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!WeakIdentityDictionary methodsFor!

hash: anObject max: anInteger
	^anObject identityHash \\ anInteger + 1! !

!IdentitySearchPolicy methodsFor!

hash: operand max: maximum
	^operand identityHash \\ maximum + 1! !

!Object methodsFor!

identityHash
	^self basicIdentityHash bitShift: 14!

hash
	^self identityHash! !

| m st | 
st := Smalltalk.
m := Symbol basicCompile: 'hash ^self identityHash'.
"As soon as we replace Symbol>>hash, the Smalltalk dictionary is invalidated"
st rehash!

Set allSubinstances do: [:each | each size > 0 ifTrue: [each rehash]]!

"Behavior.methodDictionary can now be nil"
Behavior addClassConstant: '_NullMethodDictionary'
		value: ((MethodDictionary new)
				isImmutable: true;
				yourself)!

!Behavior methodsFor!

addSelector: aSymbol withMethod: aCompiledMethod
	| selector |
	selector := aSymbol asSymbol.
	aCompiledMethod
		methodClass: self;
		selector: selector.
	(methodDictionary ifNil: [methodDictionary := MethodDictionary new]) at: selector
		put: aCompiledMethod.

	self flushMethodCache!

basicCompile: aString flags: anInteger
	| error result stubMethod |
	result := error := stubMethod := nil.
	
	[result := self compilerClass
				compile: aString
				in: self
				flags: anInteger]
			on: self compilerClass errorClass
			do: 
				[:n |
				error := n.
				stubMethod := (MethodCompileFailed with: n) signal: n description.
				n pass].
	error notNil ifTrue: [result := stubMethod].
	result notNil
		ifTrue: 
			[| selector method |
			method := result method.
			selector := method selector asSymbol.
			methodDictionary
				ifNotNil: 
					[| oldMethod |
					oldMethod := methodDictionary at: selector ifAbsent: [].
					result oldMethod: oldMethod.
					oldMethod ifNotNil: [method isPrivate: oldMethod isPrivate]].
			self addSelector: selector withMethod: method.
			method
				storeSourceString: aString asString;
				isImmutable: true].
	^result! !

(Array with: ExternalCallback with: ExternalDescriptor) do: [:each | each class removeSelector: #initialize]!
ExternalDescriptor addClassConstant: 'RetTypeMask' value: 63!
#(always caseInsensitive equality identity never uninitialize) do: [:each | SearchPolicy class removeSelector: each]!
#(current uninitialize) do: [:each | SymbolStringSearchPolicy class removeSelector: each. AssociationSearchPolicy class removeSelector: each]!

BYTE subclass: #BOOLEAN
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

!BOOLEAN class methodsFor!

fileOutStem
	^super fileOutStem, '_struct'! !

NTLibrary addClassVariable: 'IsWine' value: false!

(Array with: ArrayField with: ArrayPointerField) do: [:each | each withAllSubclassesDo: [:f | (f whichSelectorsAccess: 'length') do: [:s | f removeSelector: s]]]!

(Array with: CPINFO with: TIME_ZONE_INFORMATION) do: [:each | each resetTemplate]!

ByteCodeDispatcher.RunStarts at: #shortSpecialSendEx: put: 200!

!Dictionary methodsFor!

lookup: keyObject
	^self at: keyObject ifAbsent: []! !

!LookupTable methodsFor!

lookup: keyObject
	^self at: keyObject ifAbsent: []! !

!PoolDictionary methodsFor!

lookup: keyObject
	^super lookup: keyObject asString! !

!SystemDictionary methodsFor!

lookup: keyObject
	^super lookup: keyObject asSymbol! !

!CRTLibrary methodsFor!

_splitpath_s: path drive: drive driveLen: driveInteger dir: dir dirLen: dirInteger fname: fname fnameLen: nameInteger ext: ext extLen: extInteger
	<cdecl: sdword _splitpath_s char* char* sdword char* sdword char* sdword char* sdword>
	^self invalidCall!

strcat_s: strDestination bufferSize: anInteger strSource: strSource
	<cdecl: sdword strcat_s lpstr sdword lpstr>
	^self invalidCall!

_makepath_s: path bufferSize: sizeInBytes drive: drive dir: dir fname: fname ext: ext
	<cdecl: sdword _makepath_s char* intptr char* char* char* char*>
	^self invalidCall! !

Object subclass: #InputState
	instanceVariableNames: 'inputSemaphore idler idleTimer main windows deferredActions lastWindow wakeupEvent msgWindow queueStatusMask'
	classVariableNames: 'EnumHandlesDescriptor SamplingInterval UserInterruptSignal'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: 'maxIdleSleep'!

SessionManager inputState instVarAt: 10 put: 16rFF!

!StackFrame methodsFor!

callstackDo: aMonadicValuable depth: anInteger
	| frame i |
	frame := self.
	i := anInteger.
	[i ~~ 0 and: [frame notNil and: [frame method selector notNil]]] whileTrue: 
			[aMonadicValuable value: frame.
			frame := frame sender.
			i := i - 1]!

printStackOn: aPuttableStream depth: anInteger
	self callstackDo: 
			[:frame |
			aPuttableStream
				display: frame;
				cr]
		depth: anInteger! !

!KernelLibrary methodsFor!

getFileSizeEx: hfile lpFileSize: lpFileSize
	<stdcall: bool GetFileSizeEx handle sqword*>
	^self invalidCall!

setFilePointerEx: hfile liDistanceToMove: liDistanceToMove lpNewFilePointer: lpNewFilePointer dwMoveMethod: dwMoveMethod
	<stdcall: bool SetFilePointerEx handle sqword sqword* dword>
	^self invalidCall! !

Object subclass: #File
	instanceVariableNames: 'handle spec flags shareFlags intBuffer'
	classVariableNames: 'AccessFlagsMask CheckModes NoCheckModes OpenFlagsMask ShareModes'
	poolDictionaries: 'CRTConstants Win32Constants Win32Errors'
	classInstanceVariableNames: ''!

!File methodsFor!

seek: offsetInteger sense: senseFlag
	intBuffer:= ByteArray newFixed: 8.
	^(KernelLibrary default
		setFilePointerEx: handle
		liDistanceToMove: offsetInteger
		lpNewFilePointer: intBuffer
		dwMoveMethod: senseFlag) ifTrue: [
			intBuffer sqwordAtOffset: 0] ifFalse: [self signalOsError: false]! !

File class removeSelector: #initialize!
FileStream class removeSelector: #initialize!

!FileStream methodsFor!

beDirty
	flags := flags bitOr: 3!

nextPut: anIntegerOrCharacter
	self primitiveNextPut: anIntegerOrCharacter.
	flags := flags bitOr: 3.
	^anIntegerOrCharacter!

updateLimits
	(flags anyMask: 1)
		ifTrue: 
			[| absolute |
			flags := flags bitAnd: 1 bitInvert.
			readLimit < position ifTrue: [readLimit := position].
			logicalFileSize < (absolute := self position) ifTrue: [logicalFileSize := absolute]]! !

(FileStream compiledMethodAt: #beDirty) loseSource!

SequencedStream subclass: #StdioFileStream
	instanceVariableNames: 'stream flags name oldFd fd crtlib'
	classVariableNames: 'DeviceMask ReadOnlyMask TextMask'
	poolDictionaries: 'CRTConstants'
	classInstanceVariableNames: ''!

!StdioFileStream methodsFor!

setStream: anExternalHandle flags: anInteger name: aString
	stream := anExternalHandle.
	flags := anInteger.
	crtlib := CRTLibrary default.
	fd := crtlib _fileno: stream.
	name := aString! !

SessionManager current stdioStreams do: [:each | each setStream: each asParameter flags: 16r80 name: nil]!

!Process methodsFor!

at: anInteger 
	<primitive: 60>
	^self errorAt: anInteger! !

Process instanceVariableString: 'suspendedFrame priority myList callbackDepth primitiveFailureCode primitiveFailureData fpControl threadSync thread exceptionEnvironment _alreadyPrinted _reserved1 debugger name reserved2'!

CRTConstants at: '_EM_INEXACT' put: 1!

!Magnitude methodsFor!
isNaN
	^false! !

(Array with: Process class with: Process) do: [:each | each removeSelector: #initialize]!

Process addClassConstant: 'DefaultFPEMask' value: CRTConstants._EM_DENORMAL | CRTConstants._EM_INEXACT | CRTConstants._EM_UNDERFLOW!
Processor activeProcess fpeMask: Process.DefaultFPEMask | CRTConstants._EM_OVERFLOW | CRTConstants._EM_INVALID!
#(#fpeMask #fpeMask:) do: [:each | Process removeSelector: each]!

#(#absPrintExactlyOn:base:decimalPlaces:showTrailingFractionalZeros: #absPrintExactlyOn:base:) do: [:each | Float removeSelector: each]!
Float class removeSelector: #fminDenormalized!

| infinity |
infinity := Float fmax * 2.
Float addClassConstant: 'Infinity' value: infinity.
Float addClassConstant: 'NegativeInfinity' value: infinity negated.
Float addClassConstant: 'NaN' value: infinity - infinity!

#(#decimalSeparator #synchronizeLocale) do: [:each | CRTLibrary removeSelector: each]!

Behavior addClassConstant: '_BasicSpecMask' value: 32767!
Behavior addClassConstant: '_BytesSubMask' value: 18432!
Behavior addClassConstant: '_FundamentalShapeMask' value: 12543!
Behavior addClassConstant: '_IndirectMask' value: 2048!
Behavior addClassConstant: '_MournerMask' value: 1024!
Behavior addClassConstant: '_NonInstantiableMask' value: 512!
Behavior addClassConstant: '_NullTermMask' value: 16384!
Behavior addClassConstant: '_PointersMask' value: 8192!
Behavior addClassConstant: '_ShapeMask' value: 28927!
Behavior addClassConstant: '_SizeMask' value: 255!
Behavior addClassConstant: '_VariableMask' value: 4096!

ClassBuilder setSharedPoolNames: (ClassBuilder sharedPoolNames copyWithout: #_BehaviorMasks)!

!Class methodsFor!

isAbstract: aBoolean
	self setShapeFlags: _NonInstantiableMask to: aBoolean! !

Behavior owningPackage removeGlobalNamed: #_BehaviorMasks!
Smalltalk removeKey: #_BehaviorMasks ifAbsent: []!

!String methodsFor!

contains: aString
	"Answer whether the receiver contains the specified sub-string."

	^(self findString: aString startingAt: 1) ~~ 0! !

Character instanceVariableString: 'codePoint'!

Smalltalk at: #Utf16String put: UnicodeString!
UnicodeString setName: #Utf16String!
(Smalltalk associationAt: #UnicodeString) isImmutable: false!

!Utf16String class methodsFor!
fromString: aString
	| answer cch |
	cch := aString size.
	answer := self new: cch.
	^(cch := KernelLibrary default
				multiByteToWideChar: Win32Constants.CP_ACP
				dwFlags: 0
				lpMultiByteStr: aString
				cchMultiByte: -1
				lpWideCharStr: answer
				cchWideChar: cch + 1) == 0
		ifTrue: [KernelLibrary default systemError]
		ifFalse: [answer resize: cch - 1]! !

!String class methodsFor!
formatSystemMessage: anIntegerId withArguments: arguments
	^KernelLibrary default
		formatMessage: anIntegerId
		source: 0
		flags: Win32Constants.FORMAT_MESSAGE_FROM_SYSTEM
		withArguments: arguments! !

!String methodsFor!
formatWithArguments: aCollection 
	^KernelLibrary default 
		formatMessage: 0
		source: self
		flags: Win32Constants.FORMAT_MESSAGE_FROM_STRING
		withArguments: aCollection! !

String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

UtfEncodedString variableByteSubclass: #Utf8String
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Utf8String extraInstanceSpec: 1.
Utf16String extraInstanceSpec: 2!

| i |
i := String class indexOfInstVar: 'empty'.
String instVarAt: i put: ''.
Symbol instVarAt: i put: #''.
Utf16String instVarAt: i put: Utf16String new.
Utf8String instVarAt: i put: Utf8String new!

!Package methodsFor!

removeClassName: aSymbol
	classNames remove: aSymbol! !

!String methodsFor!

asAnsiString
	^self! !

!Utf16String methodsFor!

asAnsiString
	^self asByteString: String!

asByteString: aClass
	| bytes buf size |
	(size := self size) == 0 ifTrue: [^''].
	buf := String newFixed: size * 4.
	bytes := KernelLibrary default
				wideCharToMultiByte: (aClass == String ifTrue: [0] ifFalse: [65001])
				dwFlags: 0
				lpWideCharStr: self
				cchWideChar: size
				lpMultiByteStr: buf
				cchMultiByte: buf size
				lpDefaultChar: nil
				lpUsedDefaultChar: nil.
	bytes == 0 ifTrue: [^KernelLibrary default systemError].
	buf resize: bytes.
	^buf! !


!File class methodsFor!
relativePathOf: aPathString to: aBasePathString

	| relPath |
	relPath := Utf16String new: self maxPath.
	relPath := (ShlwapiLibrary default
				pathRelativePathTo: relPath
				pszFrom: aBasePathString
				dwAttrFrom: 0
				pszTo: aPathString
				dwAttrTo: 0)
					ifTrue: 
						[relPath asAnsiString trimNulls]
					ifFalse: [aPathString].
	^(relPath beginsWith: '.\') ifTrue: [relPath allButFirst: 2] ifFalse: [relPath]!

composePath: path subPath: subpath
	| fullName |
	fullName := Utf16String new: self maxPath.
	^(ShlwapiLibrary default
		pathCombine: fullName
		lpszDir: path
		lpszFile: subpath) asAnsiString! 

fullPathOf: aPathnameString

	| fullpath len|
	fullpath := Utf16String new: self maxPath.
	(len := KernelLibrary default
		getFullPathName: aPathnameString
		nBufferLength: fullpath size + 1
		lpBuffer: fullpath
		lpFilePart: nil) == 0
		ifTrue: [KernelLibrary default systemError].
	^(fullpath resize: len) asAnsiString! !

!KernelLibrary methodsFor!


getFullPathName: fname nBufferLength: anInteger lpBuffer: path lpFilePart: aDWORD
	<stdcall: dword GetFullPathNameW lpwstr dword lpwstr lpvoid>
	^self invalidCall! !

!ShlwapiLibrary methodsFor!

pathCombine: szDest lpszDir: lpszDir lpszFile: lpszFile
	<stdcall: lpwstr PathCombineW lpwstr lpwstr lpwstr>
	^self invalidCall!

pathRelativePathTo: pszPath pszFrom: pszFrom dwAttrFrom: dwAttrFrom pszTo: pszTo dwAttrTo: dwAttrTo
	<stdcall: bool PathRelativePathToW lpwstr lpwstr dword lpwstr dword>
	^self invalidCall! !

!WriteStream methodsFor!

nextWORDPut: anInteger
	self
		nextPut: (anInteger bitAnd: 16rFF);
		nextPut: (anInteger bitShift: -8)! !

MessageBox class removeSelector: #initialize!
