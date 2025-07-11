﻿"Filed out from Dolphin Smalltalk"!

External.PermanentLibrary
	subclass: #'Kernel.VMLibrary'
	instanceVariableNames: 'wndProc dlgProc genericCallback vtable specialSelectorStart versionInfo'
	classVariableNames: 'Registry RegistryKeys'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.VMLibrary guid: (Core.GUID fromString: '{87b4c58f-026e-11d3-9fd7-00a0cc3e4a32}')!

Kernel.VMLibrary comment: 'VMLibrary is an <ExternalLibrary> to represent the Dolphin Smalltalk Virtual Machine (VM). 

The VM contains, for example, a number of exports to implement pseudo-primitive operations, in particular to simplify the interface to other external library functions, and external call methods to access these exported functions are implemented here.

Instance Variables:
	wndProc 		- <Integer> address of the VM''s window procedure.
	dlgProc 		- <ExternalAddress>. Pointer to the VM''s dialog procedure.
	genericCallback 	- <Integer> address of the VM''s common callback entry point.
	vtable		- <ExternalAddress>. Pointer to the VM''s common virtual table (for implementing C++/COM objects).

Class Variables:
	Registry		- <Array> of <Object>s shared between the VM and the image. 	N.B. It is not possible to modify this object directly, as it is read-only.
	RegistryKeys	- <LookupTable> mapping symbolic names to the <Integer> indices of objects in the VM registry.
'!

!Kernel.VMLibrary categoriesForClass!External-Libraries! !

!Kernel.VMLibrary methodsFor!

_snprintf_s: buffer bufferSize: sizeInteger count: countInteger format: format with: arg
	"Private - Write data formatted by the format string into the buffer.
	see _snprintf:count:format:with:with:with: for further information."

	<cdecl: int32 _snprintf_s lpvoid intptr intptr lpstr lpvoid>
	^self invalidCall: _failureCode!

_snprintf_s: buffer bufferSize: sizeInteger count: countInteger format: format with: arg1 with: arg2
	"Private - Write data formatted by the format string into the buffer.
	see _snprintf:count:format:with:with:with: for further information."

	<cdecl: int32 _snprintf_s lpvoid intptr intptr lpstr lpvoid lpvoid>
	^self invalidCall: _failureCode!

addressFromInteger: anInteger
	"Private - Answer a new ExternalAddress instantiated from the argument."

	"Implementation Note: AnswerIntPtr() is a simple function which returns its pointer-sized argument. By appropriately specifying the argument and return types, we can use external call primitive's argument coercion and return object instantiation, to perform useful type conversions very quickly."

	<stdcall: lpvoid AnswerIntPtr uint32>
	^self invalidCall: _failureCode!

applicationHandle
	"Answer the handle of the Dolphin application instance."

	^Registry at: 123!

argc
	"Private - Answer the number of arguments passed to the host executable at startup"

	<cdecl: int32 argc>
	^self invalidCall: _failureCode!

argv
	"Private - Answer a pointer to the array of UTF-16 strings which constitute the command line arguments, 
	starting with the host executable's full path."

	<cdecl: lpvoid argv>
	^self invalidCall: _failureCode!

basePatchLevel
	"Private - Answer the base patch level of this image. We can assume that the image already
	incorporates patches to this level so we don't allow patches below this to be installed"

	^0!

bytecodeVersion
	"Answer the <integer> bytecode version number.
		VM bytecodeVersion
	"

	^Integer fromString: (self versionInfo at: 'PrivateBuild')!

compilerFileName
	"Private - Answer the name of the compiler library."

	^self fileName!

crashDump: message
	"Private - Write a full VM state log to the crash dump file with the <readableString>,
	message, as an exception argument which will appear in the dump.
	This can be handy for debugging in run-time systems when you detect an
	unexpected situation and want the sort of information available in the crash
	dump (the stack state at the time, etc), but you don't actually want to raise a
	non-continuable exception.
		VM crashDump: 'Hello'
	N.B. In order for a crash dump to be produced the registry on the machine
	must be appropriately configured."

	| parms str |
	parms := ByteArray new: VMConstants.IntPtrSize.
	str := message asUtf16String.
	parms intPtrAtOffset: 0 put: str yourAddress.
	Kernel32
		raiseException: 16r20000002
		dwExceptionFlags: 0
		nNumberOfArguments: 1
		lpArguments: parms	"Special exception code recognised by the VM"!

crtHandle
	"Private - Answer the handle of the CRTLibrary. This cannot be obtained in the normal way
	as we do not necessarily know which CRT library the VM is itself using."

	^self registryAt: #CRTHandle!

debugDump: msgString
	"Write a VM state log with unconstrained stack and walkback dumps to 
	the OS debug trace device with <readableString> message, 
	msgString, as the header description"

	<stdcall: void DebugDump lpwstr>
	^self invalidCall: _failureCode!

defaultProductDetails
	"Private - Answers a <LookupTable> describing the default version of the development environment as based on the VM version information.

	- Product name (includes major version)
	- Short product name
	- Product version in SemVer form (M.N.P[-prerel+buildmeta])
	- Special build information (usually empty)
	- Image patch level (usually zero as the image patching feature is no longer used)
	- Abbreviated (very short) product name
	- Serial number (no longer used)
	- Boot source version information
	- Registry version number - used to form a key for saving/restoring settings in registry."

	| version |
	version := self versionInfo.
	^LookupTable new
		at: #productName put: (version formatVersionString: '%1 %2!!d!!');
		at: #shortProductName put: (version formatVersionString: '%1');
		at: #productVersionString put: version productVersionString;
		at: #specialBuild put: version specialBuild;
		at: #basePatchLevel put: self basePatchLevel;
		at: #abbreviatedProductName put: 'D8';
		at: #serialNumber put: nil;
		at: #bootInfo put: nil;
		at: #registryVersion put: (version at: 'RegistryVersion');
		yourself!

dump: msgString path: pathString stackDepth: slotsInteger walkbackDepth: framesInteger
	"Write a VM state log to the file with <readableString> path, pathString, with the 
	<readableString> message, msgString, as the header description, and with the
	stack and walkback depths constrained to the depths specified by the <integer>s, 
	slotInteger and framesInteger, respectively (-1 can be used for unconstrained
	dumps). If either depth is less than that required to dump the entire stack, then
	stack slots or frames (respectively) will be omitted from the dump. In the case of
	the raw stack dump, slots are omitted from the middle of the stack. In the case
	of the walkback, frames are omitted at the bottom of the stack.
	This method can be handy for debugging in run-time systems when you detect an
	unexpected situation and want the sort of information available in the crash
	dump (the stack state at the time, etc), but you don't actually want to raise a
	non-continuable exception, and you want want to output a crash dump using
	parameters (such as the log file) other than those in the registry."

	<stdcall: void Dump lpwstr lpwstr int32 int32>
	^self invalidCall: _failureCode!

emptyBlock
	"Private - Answer the singleton empty clean block instance the compiler installs into methods with empty zero-arg blocks as a space saving optimization."

	^self registry at: 7!

errorIntegerMoreThan32Bits: anInteger
	"Private - Raise an exception to the effect that anInteger cannot be represented
	as a 32-bit two's complement integer (it's too 'large')."

	^self
		error: ('<1p> is too large for 32-bit two''s complement representation.' expandMacrosWith: anInteger)!

fullVersion
	"Answer a String which describes the full name and version number of the VM."

	| verinfo |
	verinfo := self versionInfo.
	^verinfo productName , ' ' , (verinfo productVersionString readStream upTo: $+)!

getDlgProc
	"Private - Answer a pointer to the VM's dialog window procedure.
	The dialog window procedure does nothing except return 0. It's purpose is to act
	as the target of a CallDefaultProc() in order to regularize the interface
	so that there is no difference in handling between dialogs and non-dialogs."

	dlgProc isNil ifTrue: [ dlgProc := self getProcAddress: 'DlgProc' ].
	^dlgProc!

getGenericCallback
	"Private - Answer a pointer to the VM's generic callback function."

	genericCallback isNil
		ifTrue: 
			[genericCallback := Kernel32 getProcAddressUIntPtr: self asParameter lpProcName: 'GenericCallback'].
	^genericCallback!

getVTable
	"Private - Answer a pointer to the VM's vtable (a fixed size virtual
	function pointer table for use in conjunction with the COM implementation)."

	vtable isNil ifTrue: [vtable := self getProcAddress: 'VTable'].
	^vtable!

getWndProc
	"Answer a pointer to the VM's window procedure. The VM's window procedure does very little
	except forward messages to Smalltalk for dispatching to the appropriate Window. It
	calls the windows default proc (either the proc. before the window was subclassed by Dolphin
	or the DefWindowProc if a Dolphin Window) if a non-integer value is returned to it."

	"There is not point throwing an error here if it fails, because that will be terminal anyway."

	wndProc isNil
		ifTrue: [wndProc := Kernel32 getProcAddressUIntPtr: self asParameter lpProcName: 'WndProc'].
	^wndProc!

handleFromInteger: anInteger
	"Private - Answer a new ExternalHandle instantiated from the argument."

	"Implementation Note: AnswerIntPtr() is a simple function which returns its pointer-sized argument. By appropriately specifying the argument and return types, we can use external call primitive's argument coercion and return object instantiation, to perform useful type conversions very quickly."

	<stdcall: handle AnswerIntPtr uintptr>
	^External.Handle new value: anInteger asInteger!

hashBytes: aByteObject count: anInteger
	"Private - Hash the specified number of bytes at the specified address using the function
	which implements the standard byte hashing primitive (106). "

	"Implementation Notes: The algorithm is FNV1a."

	<cdecl: uint32 HashBytes lpvoid uint32>
	^self invalidCall: _failureCode!

highBit: anInteger
	"Answer the index of the high bit of the argument."

	<stdcall: int32 highBit uint32>
	^self invalidCall: _failureCode!

indexOfSpecialSelector: aSymbol ifAbsent: exceptionHandler
	"Private - Answer the index of the special selector, aSymbol, or 
	the result of evalating the niladic valuable, exceptionHandler,
	if aSymbol is not a Special Selector."

	| index |
	index := Registry 
				nextIdentityIndexOf: aSymbol
				from: specialSelectorStart
				to: specialSelectorStart + 31.
	^index == 0 
		ifTrue: [exceptionHandler value]
		ifFalse: [index - specialSelectorStart + 1]!

int32FromUInt32: anInteger
	"Private - Answer a 32-bit signed integer value instantiated from the unsigned 32-bit integer
	argument. Use the VM's external call primitive to perform the conversion very quickly."

	<stdcall: int32 AnswerDWORD uint32>
	^anInteger highBit > 32
		ifTrue: [self errorIntegerMoreThan32Bits: anInteger]
		ifFalse: [(16r80000000 + anInteger bitAnd: 16rFFFFFFFF) - 16r80000000]!

isSlowMachine
	"Answer true if this machine is judged to be slow."

	^(User32 getSystemMetrics: SM_SLOWMACHINE) ~~ 0

	"
	VM isSlowMachine
"!

isUserBreakRequested
	"Private - Answer whether the user has pressed the break key sequence. The key sequence is
	configurable through the Development System option 'interruptHotKey', the default being
	set by SmalltalkSystem>>#initialize."

	<cdecl: bool IsUserBreakRequested>
	^self invalidCall: _failureCode!

kernelHandle
	"Private - Answer the handle of the KernelLibrary. This cannot be obtained in the normal way
	because there is a bit of a chicken and egg problem."

	^self registryAt: #KernelHandle!

largeSignedFromUnsigned: anInteger
	"Private - Answer a 64-bit signed integer value instantiated from the unsigned integer
	argument. Use the VM's external call primitive to perform the conversion very quickly."

	<stdcall: int64 AnswerQWORD uint64>
	^self invalidCall: _failureCode!

largeUnsignedFromSigned: anInteger
	"Private - Answer a 64-bit signed integer value instantiated from the signed integer
	argument. Use the VM's external call primitive to perform the conversion very quickly."

	<stdcall: uint64 AnswerQWORD int64>
	^self invalidCall: _failureCode!

makeLargeSigned: aLARGE_INTEGER
	"Private - Answer an Integer (a SmallInteger or a LargeInteger, whichever is the minimum
	representation) instantiated from the 64-bit signed integer argument.
	This routine is used by the external call primitives, and is exported from the VM
	for reuse from Smalltalk or external primitives."

	<stdcall: int64 AnswerQWORD uint64>
	^self invalidCall: _failureCode!

makeLargeSigned: highSDWORD highPart: lowSDWORD
	"Private - Answer an Integer of up to 64 bits, as necessary, to represent the signed
	integer formed from the high and low order DWORD arguments. The result will be zero
	if highSDWORD has its high bit set.
	This routine is an example of a function returing a signed 8-byte integer (sqword)."

	<stdcall: int64 AnswerQWORD int32 uint32>
	^self invalidCall: _failureCode!

makeLargeUnsigned: eightBytes
	"Private - Answer a positive Integer (i.e. a SmallInteger or a LargeInteger)
	instantiated from the 64-bit argument."

	<stdcall: uint64 AnswerQWORD uint64>
	^self invalidCall: _failureCode!

makeLargeUnsigned: lowDWORD highPart: highDWORD
	"Private - Answer an Integer of up to 64 bits, as necessary, to represent the unsigned
	integer formed from the high and low order DWORD arguments.
	This routine is an example of a qword (8-byte Integer) return type."

	<stdcall: uint64 AnswerQWORD uint32 uint32>
	^self invalidCall: _failureCode!

onPreStripImage
	versionInfo := nil!

onStartup
	"Initialize the receiver immediately following system startup.
	THIS MUST BE DONE FIRST."

	handle := Registry at: 122.
	specialSelectorStart := RegistryKeys at: #arithmeticSelectors.
	versionInfo := wndProc := dlgProc := vtable := genericCallback := nil!

productName
	"Answer the localised name for Dolphin."

	^self versionInfo productName
!

registerEventSource: aString
	<stdcall: handle RegisterAsEventSource lpwstr>
	^self invalidCall: _failureCode!

registry
	"Private - Answer the VM registry of objects."

	^Registry!

registryAt: aSymbol 
	"Private - Answer the VM registered object with the name, aSymbol."

	^Registry at: (RegistryKeys at: aSymbol)!

registryAt: aSymbol put: anObject
	"Private - Register the argument, anObject, as the VM registered object with the name,
	aSymbol."

	self registryAtIndex: (RegistryKeys at: aSymbol) put: anObject.
	^anObject!

registryAtIndex: anInteger put: anObject
	"Private - Generic VM object registering primitive. Used to register cookies, Semaphores,
	the Corpse object, etc.

	Equivalent to 'Registry at: anInteger put: anObject', but allows the VM to reload any
	information it caches.

	Primitive failure reasons:
		InvalidParameter1	- anInteger is not a SmallInteger
		OutOfBounds		- anInteger is out of the bounds of the registry
		InvalidParameter2	- anObject is not of the appropriate class for the object being registered."

	<primitive: 93>
	^self primitiveFailed: _failureCode!

selectorOfSpecialSend: anInteger
	^Registry at: specialSelectorStart + anInteger!

selectorOfSpecialSendEx: anInteger
	^Registry at: 71 + anInteger!

specialSelectors
	"Private - Answer all special messages that have their own individual bytecodes.
		VM specialSelectors
	"

	| selectors |
	selectors := IdentitySet new: 36.
	specialSelectorStart to: specialSelectorStart + 31 do: [:i | selectors add: (Registry at: i)].
	71 to: 74 do: [:i | selectors add: (Registry at: i)].
	^selectors!

stderr
	"Private - Answer the handle of the CRT stdio standard error stream"

	<cdecl: handle StdErr>
	^self invalidCall: _failureCode!

stdin
	"Private - Answer the handle of the CRT stdio standard input stream"

	<cdecl: handle StdIn>
	^self invalidCall: _failureCode!

stdout
	"Private - Answer the handle of the CRT stdio standard output stream"

	<cdecl: handle StdOut>
	^self invalidCall: _failureCode!

unregisterObject: anObject
	| i |
	i := self registry identityIndexOf: anObject.
	i > 0 ifFalse: [^self].
	Notification signal: 'Unregistering VM ref ' , anObject printString.
	self registryAtIndex: i put: nil!

unsignedFromSigned: anInteger
	"Private - Answer a 32-bit unsigned integer value instantiated from the signed 32-bit integer
	argument.
	Implementation Note: AnswerDWORD() is a simple function which returns its 32-bit argument.
	By appropriately specifying the argument and return types, we can use external call
	primitive's argument coercion and return object instantiation, to perform useful type
	conversions very quickly."

	<stdcall: uint32 AnswerDWORD int32>
	^anInteger isInteger
		ifTrue: [self errorIntegerMoreThan32Bits: anInteger]
		ifFalse: [self invalidCall: _failureCode]!

utf16StringFromAddress: pointer
	"Private - Answer a new <Utf16String> instantiated from the null-terminated string pointed at by the argument."

	<stdcall: lpwstr AnswerIntPtr lpvoid>
	^Utf16String fromAddress: pointer length: (Ucrt wcslen: pointer)!

versionFormatString
	"Private - Answer a String containing the version format used by the receiver."

	^'%2!!d!!.%3!!d!!.%4!!d!!.%5!!d!!'!

versionInfo
	"Answer a <VersionInfo> containing the version details from the receiver."

	^versionInfo ifNil: [versionInfo := super versionInfo]! !

!Kernel.VMLibrary categoriesForMethods!
_snprintf_s:bufferSize:count:format:with:!helpers!private! !
_snprintf_s:bufferSize:count:format:with:with:!helpers!private! !
addressFromInteger:!helpers!private! !
applicationHandle!accessing-handles!public! !
argc!accessing!private! !
argv!accessing!private! !
basePatchLevel!constants!patching!private! !
bytecodeVersion!accessing-version!public! !
compilerFileName!accessing!private! !
crashDump:!exceptions!private! !
crtHandle!accessing-handles!private! !
debugDump:!exceptions!private! !
defaultProductDetails!accessing!private! !
dump:path:stackDepth:walkbackDepth:!exceptions!private! !
emptyBlock!accessing-handles!private! !
errorIntegerMoreThan32Bits:!exceptions!private! !
fullVersion!accessing-version!public! !
getDlgProc!accessing-callbacks!private! !
getGenericCallback!accessing-callbacks!private! !
getVTable!accessing-callbacks!private! !
getWndProc!accessing-callbacks!public! !
handleFromInteger:!helpers!private! !
hashBytes:count:!hash algorithms!helpers!private! !
highBit:!arithmetic!public! !
indexOfSpecialSelector:ifAbsent:!accessing-registry!private! !
int32FromUInt32:!helpers!private! !
isSlowMachine!environment!public! !
isUserBreakRequested!accessing!helpers!private! !
kernelHandle!accessing-handles!private! !
largeSignedFromUnsigned:!helpers!private! !
largeUnsignedFromSigned:!helpers!private! !
makeLargeSigned:!helpers!private! !
makeLargeSigned:highPart:!helpers!private! !
makeLargeUnsigned:!helpers!private! !
makeLargeUnsigned:highPart:!helpers!private! !
onPreStripImage!class hierarchy-removing!private! !
onStartup!event handling!public! !
productName!accessing!public! !
registerEventSource:!arithmetic!public! !
registry!accessing!private! !
registryAt:!accessing-registry!private! !
registryAt:put:!accessing-registry!private! !
registryAtIndex:put:!accessing-registry!private! !
selectorOfSpecialSend:!enquiries!private! !
selectorOfSpecialSendEx:!enquiries!private! !
specialSelectors!accessing-registry!private! !
stderr!accessing-handles!private! !
stdin!accessing-handles!private! !
stdout!accessing-handles!private! !
unregisterObject:!accessing-registry!private! !
unsignedFromSigned:!helpers!private! !
utf16StringFromAddress:!helpers!private! !
versionFormatString!constants!private! !
versionInfo!accessing-version!public! !
!

!Kernel.VMLibrary class methodsFor!

fileName
	"Answer the host system file name of the library. This may vary."

	^self shouldNotImplement!

hasBytecodeRepresentation: anObject
	"Private - Answer whether the specified object has a special instruction or instructions that when
	executed will push an identical object on the on the stack, e.g. nil, true, false,
	SmallIntegers, byte Characters."

	^anObject isImmediate or: 
			[anObject isNil or: 
					[anObject == true
						or: [anObject == false or: [anObject class == Character and: [anObject codePoint <= 127]]]]]!

initialize
	"Private - Initialize the receiver's class variables - see class comment for further details.

		VMLibrary initialize
	"

	"Registry := DO NOT ASSIGN ME."

	##(RegistryKeys := IdentityDictionary new
				at: #Smalltalk put: 9;
				at: #Processor put: 10;
				at: #arithmeticSelectors put: 16;
				at: #commonSelectors put: 31;
				at: #Metaclass put: 81;
				at: #Character put: 82;
				at: #Array put: 83;
				at: #AnsiString put: 84;
				at: #Symbol put: 85;
				at: #SmallInteger put: 86;
				at: #Process put: 87;
				at: #CompiledMethod put: 88;
				at: #Context put: 89;
				at: #BlockClosure put: 90;
				at: #Message put: 91;
				at: #ByteArray put: 92;
				at: #Utf16String put: 93;
				at: #CompiledExpression put: 94;
				at: #ExternalMethod put: 95;
				at: #Float put: 96;
				at: #UndefinedObject put: 97;
				at: #VariableBinding put: 98;
				at: #Semaphore put: 99;
				at: #Address put: 100;
				at: #Handle put: 101;
				at: #Dispatcher put: 102;
				at: #LPVOID put: 103;
				at: #Utf8String put: 104;
				at: #BindingReference put: 105;
				at: #ArrayBinding put: 106;
				at: #LargeInteger put: 107;
				at: #VARIANT put: 108;
				at: #BSTR put: 109;
				at: #DATE put: 110;
				at: #Corpse put: 111;
				at: #InputSemaphore put: 112;
				at: #FinalizeSemaphore put: 113;
				at: #BereavementSemaphore put: 114;
				at: #FinalizeQueue put: 118;
				at: #BereavementQueue put: 119;
				at: #GUID put: 120;
				at: #KernelHandle put: 121;
				at: #VMHandle put: 122;
				at: #DolphinHandle put: 123;
				at: #IUnknown put: 124;
				at: #WakeupEvent put: 125;
				at: #MsgWndHandle put: 127;
				at: #IDispatch put: 128;
				at: #ImageVersionMajor put: 129;
				at: #ImageVersionMinor put: 130;
				at: #interruptHotKey put: 131;
				at: #CRTHandle put: 132;
				at: #memoryManager put: 133;
				at: #UInt8 put: 134;
				at: #Int8 put: 135;
				at: #UInt16 put: 136;
				at: #Int16 put: 137;
				at: #UInt32 put: 138;
				at: #Int32 put: 139;
				at: #FLOAT put: 140;
				at: #DOUBLE put: 141;
				at: #VARIANT_BOOL put: 142;
				at: #CURRENCY put: 143;
				at: #DECIMAL put: 144;
				at: #LPBSTR put: 145;
				at: #UInt64 put: 146;
				at: #Int64 put: 147;
				at: #TimingSemaphore put: 150;
				at: #MethodAnnotations put: 151;
				beImmutableObject;
				shrink;
				yourself)!

maxBlockNesting
	^VMConstants.MaxBlockNesting!

maxLiterals
	^VMConstants.MaxLiterals!

maxMessageArguments
	^VMConstants.MaxMessageArgs!

maxTemps
	^VMConstants.MaxTemps!

onPreStripImage
	default onPreStripImage!

open
	"Answer the singleton instance of the receiver (it cannot be re-opened)"

	^default!

registryKeys
	"Private - Answer the map between symbolic names and VM registry indices."

	^RegistryKeys!

sharedVariableName
	^#{VM}! !

!Kernel.VMLibrary class categoriesForMethods!
fileName!constants!public! !
hasBytecodeRepresentation:!helpers!private! !
initialize!development!initializing!private! !
maxBlockNesting!limits!public! !
maxLiterals!limits!public! !
maxMessageArguments!limits!public! !
maxTemps!limits!public! !
onPreStripImage!class hierarchy-removing!private! !
open!instance creation!public! !
registryKeys!constants!private! !
sharedVariableName!constants!private! !
!

