"Filed out from Dolphin Smalltalk"!

IPersistStream subclass: #IMoniker
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IMoniker guid: (IID fromString: '{0000000f-0000-0000-c000-000000000046}')!

IMoniker comment: '<IMoniker> is a wrapper class for the custom interface ''OBJIDL.IMoniker'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!

!IMoniker categoriesForClass!OBJIDL-Interfaces! !

!IMoniker methodsFor!

= anObject
	"Answer whether the receiver is equal to the argument."

	^self species == anObject species 
		and: [(self IsEqual: anObject) == S_OK]!

asString
	"Answer a string representation of the receiver."

	^self displayName!

bindToObject: aCOMInterfaceClass
	| pbc bound |
	pbc := IBindCtx new.
	bound := self
				bindToObject: pbc
				toLeft: nil
				interface: aCOMInterfaceClass.
	pbc free.
	^bound!

BindToObject: pbc pmkToLeft: pmkToLeft riidResult: riidResult ppvResult: ppvResult
	"Private - Invoke the BindToObject() method of the COM object.

		HRESULT __stdcall BindToObject(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[in]GUID* riidResult,
			[out]IUnknown** ppvResult);"

	<virtual stdcall: hresult 9 IBindCtx* IMoniker* guid* IUnknown**>
	^self invalidCall: _failureCode!

bindToObject: anIBindCtx toLeft: anIMoniker interface: interfaceClass
	| answer |
	answer := interfaceClass newPointer.
	self
		BindToObject: anIBindCtx
		pmkToLeft: anIMoniker
		riidResult: interfaceClass iid
		ppvResult: answer.
	^answer!

BindToStorage: pbc pmkToLeft: pmkToLeft riid: riid ppvObj: ppvObj
	"Private - Invoke the BindToStorage() method of the COM object.

		HRESULT __stdcall BindToStorage(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[in]GUID* riid,
			[out]IUnknown** ppvObj);"

	<virtual stdcall: hresult 10 IBindCtx* IMoniker* guid* IUnknown**>
	^self invalidCall: _failureCode!

bindToStorage: anIBindCtx toLeft: anIMoniker interface: aCOMInterfaceClass
	| answer |
	answer := aCOMInterfaceClass newPointer.
	self
		BindToStorage: anIBindCtx
		pmkToLeft: anIMoniker
		riid: aCOMInterfaceClass iid
		ppvObj: answer.
	^answer!

commonPrefixWith: pmkOther
	"Answer an <IMoniker> naming the common prefix between the receiver
	and the <IMoniker> argument, pmkOther."

	| pmkPrefix |
	pmkPrefix := self class newPointer.
	self CommonPrefixWith: pmkOther ppmkPrefix: pmkPrefix.
	^pmkPrefix!

CommonPrefixWith: pmkOther ppmkPrefix: ppmkPrefix
	"Private - Invoke the CommonPrefixWith() method of the COM object.

		HRESULT __stdcall CommonPrefixWith(
			[in]IMoniker* pmkOther,
			[out]IMoniker** ppmkPrefix);"

	<virtual stdcall: hresult 19 IMoniker* IMoniker**>
	^self invalidCall: _failureCode!

components
	"Answer a <sequencedReadableCollection> of the components of the receiver, or an empty collection if it is not a composite."

	^(self enum: true) contents!

composeWith: pmkRight
	"Answer a composite moniker constructed from the receiver with the <IMoniker>	pmkRight to its right."

	^self composeWith: pmkRight fOnlyIfNotGeneric: false!

composeWith: pmkRight fOnlyIfNotGeneric: fOnlyIfNotGeneric
	"Answer the <IMoniker> result of invoking the ComposeWith() method of the COM object."

	| answer |
	answer := IMoniker newPointer.
	self
		ComposeWith: pmkRight
		fOnlyIfNotGeneric: fOnlyIfNotGeneric
		ppmkComposite: answer.
	^answer asObject!

ComposeWith: pmkRight fOnlyIfNotGeneric: fOnlyIfNotGeneric ppmkComposite: ppmkComposite
	"Private - Invoke the ComposeWith() method of the COM object.

		HRESULT __stdcall ComposeWith(
			[in]IMoniker* pmkRight,
			[in]bool fOnlyIfNotGeneric,
			[out]IMoniker** ppmkComposite);"

	<virtual stdcall: hresult 12 IMoniker* bool IMoniker**>
	^self invalidCall: _failureCode!

displayName
	"Answer a string representation of the receiver.
	This conversion is sensible as it is invertible with ParseDisplayName."

	^self getDisplayName: nil!

displayOn: aStream
	"Append a user friendly textual representation of the receiver to aStream."

	[aStream display: (self getDisplayName: ##(10 milliseconds))] on: HRESULTError
		do: [:e | super displayOn: aStream]!

enum: forward
	"Answer an <IEnumMoniker> on the receiver's components.
	Implementations aside from Generic composite moniker generally return S_OK (with the exception of Pointer Moniker, which returns E_NOTIMPL), but provide a null moniker. This makes for a rather awkward API, so we return an empty IEnumMoniker instead."

	| enum hr |
	enum := IEnumMoniker newPointer.
	hr := self Enum: forward ppenumMoniker: enum.
	(hr < 0 and: [hr ~= E_NOTIMPL]) ifTrue: [HRESULTError signal: hr].
	^enum isNull ifTrue: [COMInterfaceEnumerator newEnumerator: IEnumMoniker on: #()] ifFalse: [enum]!

Enum: fForward ppenumMoniker: ppenumMoniker
	"Private - Invoke the Enum() method of the COM object.

		HRESULT __stdcall Enum(
			[in]bool fForward,
			[out]IEnumMoniker** ppenumMoniker);"

	<virtual stdcall: sdword 13 bool IEnumMoniker**>
	^self invalidCall: _failureCode!

getDisplayName: aDuration
	"Answer the moniker's display name within the specified <Duration>.  If aDuration is nil or zero, then the timeout is infinite. If the timeout is exceeded, an <HRESULTError> is thrown."

	| displayName pbc ppszDisplayName |
	pbc := IBindCtx new.
	aDuration
		ifNotNil: 
			[| bindOpts |
			bindOpts := pbc getBindOptions.
			bindOpts dwTickCountDeadline: aDuration asMilliseconds.
			pbc SetBindOptions: bindOpts].
	ppszDisplayName := COMTaskMemory new.
	self
		GetDisplayName: pbc
		pmkToLeft: nil
		ppszDisplayName: ppszDisplayName.
	displayName := Utf16String fromAddress: ppszDisplayName.
	ppszDisplayName free.
	pbc free.
	^displayName!

GetDisplayName: pbc pmkToLeft: pmkToLeft ppszDisplayName: ppszDisplayName
	"Private - Invoke the GetDisplayName() method of the COM object.

		HRESULT __stdcall GetDisplayName(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[out]LPWSTR* ppszDisplayName);"

	<virtual stdcall: hresult 21 IBindCtx* IMoniker* lpwstr*>
	^self invalidCall: _failureCode!

getTimeOfLastChange: pbc pmkToLeft: pmkToLeft
	"Answer the <FILETIME> result of invoking the GetTimeOfLastChange() method of the COM object."

	| answer |
	answer := FILETIME new.
	self
		GetTimeOfLastChange: pbc
		pmkToLeft: pmkToLeft
		pFileTime: answer.
	^answer asObject!

GetTimeOfLastChange: pbc pmkToLeft: pmkToLeft pFileTime: pFileTime
	"Private - Invoke the GetTimeOfLastChange() method of the COM object.

		HRESULT __stdcall GetTimeOfLastChange(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[out]FILETIME* pFileTime);"

	<virtual stdcall: hresult 17 IBindCtx* IMoniker* FILETIME*>
	^self invalidCall: _failureCode!

hash
	"Answer the hash value for the receiver."

	| answer |
	answer := DWORDBytes new.
	self Hash: answer.
	^answer value!

Hash: pdwHash
	"Private - Invoke the Hash() method of the COM object.

		HRESULT __stdcall Hash(
			[out]unsigned long* pdwHash);"

	<virtual stdcall: hresult 15 dword*>
	^self invalidCall: _failureCode!

inverse
	"Answer the receiver's anti-moniker (i.e. a moniker which, when composed to the right	of the receiver, cancels it out)."

	| answer |
	answer := IMoniker newPointer.
	self Inverse: answer.
	^answer!

Inverse: ppmk
	"Private - Invoke the Inverse() method of the COM object.

		HRESULT __stdcall Inverse(
			[out]IMoniker** ppmk);"

	<virtual stdcall: hresult 18 IMoniker**>
	^self invalidCall: _failureCode!

isComposite
	^self systemMonikerKind == #composite!

IsEqual: pmkOtherMoniker
	"Invoke the IsEqual() method of the COM object.

		HRESULT __stdcall IsEqual(
			[in]IMoniker* pmkOtherMoniker);"

	<virtual stdcall: hresult 14 IMoniker*>
	^self invalidCall: _failureCode!

isRunning
	"Answer whether the object named by the receiver is already running."

	| pbc hr |
	pbc := IBindCtx new.
	hr := self
				IsRunning: pbc
				pmkToLeft: nil
				pmkNewlyRunning: nil.
	pbc free.
	^hr == S_OK!

IsRunning: pbc pmkToLeft: pmkToLeft pmkNewlyRunning: pmkNewlyRunning
	"Invoke the IsRunning() method of the COM object.

		HRESULT __stdcall IsRunning(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[in]IMoniker* pmkNewlyRunning);"

	<virtual stdcall: hresult 16 IBindCtx* IMoniker* IMoniker*>
	^self invalidCall: _failureCode!

isSystemMoniker
	"Answer whether the receiver is a 'system moniker', i.e. one with an 
	implemenation provided by OLE itself."

	| mksys |
	mksys := DWORDBytes new.
	^(self IsSystemMoniker: mksys) == S_OK!

IsSystemMoniker: pdwMksys
	"Private - Invoke the IsSystemMoniker() method of the COM object.

		HRESULT __stdcall IsSystemMoniker(
			[out]unsigned long* pdwMksys);"

	<virtual stdcall: hresult 23 dword*>
	^self invalidCall: _failureCode!

parseDisplayName: pbc pmkToLeft: pmkToLeft pszDisplayName: pszDisplayName
	"Invoke the ParseDisplayName() method of the COM object."

	| outputs |
	outputs := {DWORD new. IMoniker newPointer}.
	self
		ParseDisplayName: pbc
		pmkToLeft: pmkToLeft
		pszDisplayName: pszDisplayName asUtf16String
		pchEaten: (outputs basicAt: 1)
		ppmkOut: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

ParseDisplayName: pbc pmkToLeft: pmkToLeft pszDisplayName: pszDisplayName pchEaten: pchEaten ppmkOut: ppmkOut
	"Private - Invoke the ParseDisplayName() method of the COM object.

		HRESULT __stdcall ParseDisplayName(
			[in]IBindCtx* pbc,
			[in]IMoniker* pmkToLeft,
			[in]LPWSTR pszDisplayName,
			[out]unsigned long* pchEaten,
			[out]IMoniker** ppmkOut);"

	<virtual stdcall: hresult 22 IBindCtx* IMoniker* lpwstr dword* IMoniker**>
	^self invalidCall: _failureCode!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream.
	Implementation Note: Override to scrape out the moniker's display name."

	aStream
		basicPrint: self;
		nextPut: $(;
		print: ([self getDisplayName: ##(10 milliseconds)] on: HRESULTError do: [:e | bytes]);
		nextPut: $)!

reduce: pbc dwReduceHowFar: dwReduceHowFar ppmkToLeft: ppmkToLeft
	"Invoke the Reduce() method of the COM object."

	| outputs |
	outputs := {ppmkToLeft. IMoniker newPointer}.
	self
		Reduce: pbc
		dwReduceHowFar: dwReduceHowFar
		ppmkToLeft: (outputs basicAt: 1)
		ppmkReduced: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

Reduce: pbc dwReduceHowFar: dwReduceHowFar ppmkToLeft: ppmkToLeft ppmkReduced: ppmkReduced
	"Private - Invoke the Reduce() method of the COM object.

		HRESULT __stdcall Reduce(
			[in]IBindCtx* pbc,
			[in]unsigned long dwReduceHowFar,
			[in, out]IMoniker** ppmkToLeft,
			[out]IMoniker** ppmkReduced);"

	<virtual stdcall: hresult 11 IBindCtx* dword IMoniker** IMoniker**>
	^self invalidCall: _failureCode!

relativePathTo: anIMoniker
	"Answer an <IMoniker> naming the relative path from the receiver to the <IMoniker> argument."

	| pmkPrefix |
	pmkPrefix := self class newPointer.
	self RelativePathTo: anIMoniker ppmkRelPath: pmkPrefix.
	^pmkPrefix!

RelativePathTo: pmkOther ppmkRelPath: ppmkRelPath
	"Private - Invoke the RelativePathTo() method of the COM object.

		HRESULT __stdcall RelativePathTo(
			[in]IMoniker* pmkOther,
			[out]IMoniker** ppmkRelPath);"

	<virtual stdcall: hresult 20 IMoniker* IMoniker**>
	^self invalidCall: _failureCode!

systemMonikerKind
	"Answer the symbolic name of the system moniker kind of the receiver, or #none if not a system moniker."

	| mksys |
	mksys := DWORDBytes new.
	self IsSystemMoniker: mksys.
	mksys := mksys asInteger.
	^#(#none #composite #file #anti #item #pointer #url #class #objref #session #lua) at: mksys + 1!

timeOfLastChange
	"Answer a FILETIME with the modification time for the receiver.
	Often this is not implemented, or may not make sense for the moniker type. This may also involve binding the object, which might take an arbitrarily long time."

	| pbc answer |
	pbc := IBindCtx new.
	answer := FILETIME new.
	self
		GetTimeOfLastChange: pbc
		pmkToLeft: nil
		pFileTime: answer.
	pbc free.
	^answer! !

!IMoniker categoriesForMethods!
=!comparing!public! !
asString!converting!public! !
bindToObject:!methods!public! !
BindToObject:pmkToLeft:riidResult:ppvResult:!**auto generated**!COM Interfaces-IMoniker!private! !
bindToObject:toLeft:interface:!methods!public! !
BindToStorage:pmkToLeft:riid:ppvObj:!**auto generated**!COM Interfaces-IMoniker!private! !
bindToStorage:toLeft:interface:!methods!public! !
commonPrefixWith:!comparing!public! !
CommonPrefixWith:ppmkPrefix:!**auto generated**!COM Interfaces-IMoniker!private! !
components!accessing!public! !
composeWith:!operations!public! !
composeWith:fOnlyIfNotGeneric:!**auto generated**!methods!public! !
ComposeWith:fOnlyIfNotGeneric:ppmkComposite:!**auto generated**!COM Interfaces-IMoniker!private! !
displayName!accessing!public! !
displayOn:!printing!public! !
enum:!enumerating!public! !
Enum:ppenumMoniker:!**auto generated**!COM Interfaces-IMoniker!private! !
getDisplayName:!printing!public! !
GetDisplayName:pmkToLeft:ppszDisplayName:!**auto generated**!COM Interfaces-IMoniker!private! !
getTimeOfLastChange:pmkToLeft:!**auto generated**!methods!public! !
GetTimeOfLastChange:pmkToLeft:pFileTime:!**auto generated**!COM Interfaces-IMoniker!private! !
hash!comparing!public! !
Hash:!**auto generated**!COM Interfaces-IMoniker!private! !
inverse!accessing!public! !
Inverse:!**auto generated**!COM Interfaces-IMoniker!private! !
isComposite!public!testing! !
IsEqual:!**auto generated**!COM Interfaces-IMoniker!public! !
isRunning!public!testing! !
IsRunning:pmkToLeft:pmkNewlyRunning:!**auto generated**!COM Interfaces-IMoniker!public! !
isSystemMoniker!public!testing! !
IsSystemMoniker:!**auto generated**!COM Interfaces-IMoniker!private! !
parseDisplayName:pmkToLeft:pszDisplayName:!**auto generated**!methods!public! !
ParseDisplayName:pmkToLeft:pszDisplayName:pchEaten:ppmkOut:!**auto generated**!COM Interfaces-IMoniker!private! !
printOn:!printing!public! !
reduce:dwReduceHowFar:ppmkToLeft:!**auto generated**!methods!public! !
Reduce:dwReduceHowFar:ppmkToLeft:ppmkReduced:!**auto generated**!COM Interfaces-IMoniker!private! !
relativePathTo:!comparing!public! !
RelativePathTo:ppmkRelPath:!**auto generated**!COM Interfaces-IMoniker!private! !
systemMonikerKind!accessing!public! !
timeOfLastChange!accessing!public! !
!

!IMoniker class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IMoniker'
		IMoniker defineTemplate"

	self
		defineFunction: #BindToObject:pmkToLeft:riidResult:ppvResult:
			argumentTypes: 'IBindCtx* IMoniker* GUID* IUnknown**';
		defineFunction: #BindToStorage:pmkToLeft:riid:ppvObj:
			argumentTypes: 'IBindCtx* IMoniker* GUID* IUnknown**';
		defineFunction: #Reduce:dwReduceHowFar:ppmkToLeft:ppmkReduced:
			argumentTypes: 'IBindCtx* dword IMoniker** IMoniker**';
		defineFunction: #ComposeWith:fOnlyIfNotGeneric:ppmkComposite:
			argumentTypes: 'IMoniker* bool IMoniker**';
		defineFunction: #Enum:ppenumMoniker:
			returnType: 'sdword'
			argumentTypes: 'bool IEnumMoniker**';
		defineFunction: #IsEqual: argumentTypes: 'IMoniker*';
		defineFunction: #Hash: argumentTypes: 'dword*';
		defineFunction: #IsRunning:pmkToLeft:pmkNewlyRunning:
			argumentTypes: 'IBindCtx* IMoniker* IMoniker*';
		defineFunction: #GetTimeOfLastChange:pmkToLeft:pFileTime:
			argumentTypes: 'IBindCtx* IMoniker* FILETIME*';
		defineFunction: #Inverse: argumentTypes: 'IMoniker**';
		defineFunction: #CommonPrefixWith:ppmkPrefix: argumentTypes: 'IMoniker* IMoniker**';
		defineFunction: #RelativePathTo:ppmkRelPath: argumentTypes: 'IMoniker* IMoniker**';
		defineFunction: #GetDisplayName:pmkToLeft:ppszDisplayName:
			argumentTypes: 'IBindCtx* IMoniker* lpwstr*';
		defineFunction: #ParseDisplayName:pmkToLeft:pszDisplayName:pchEaten:ppmkOut:
			argumentTypes: 'IBindCtx* IMoniker* lpwstr dword* IMoniker**';
		defineFunction: #IsSystemMoniker: argumentTypes: 'dword*'!

forCLSID: aCLSID
	| answer |
	answer := self newPointer.
	OLELibrary default createClassMoniker: aCLSID ppmk: answer.
	^answer!

forItem: itemName
	"Answer a new instance of the receiver on an Item Moniker object with the specified
	<readableString> item name. The interpretation of the name depends on the container
	(e.g. a coclass which implements IOleItemContainer to answer named instances)."

	^self forItem: itemName delimiter: '!!'!

forItem: itemName delimiter: separatorString
	"Answer a new instance of the receiver on an Item Moniker object with the specified
	<readableString> item name. The interpretation of the name depends on the container
	(e.g. a coclass which implements IOleItemContainer to answer named instances)."

	| answer |
	answer := self newPointer.
	OLELibrary default
		createItemMoniker: separatorString asUtf16String
		lpszItem: itemName asUtf16String
		ppmk: answer.
	^answer!

forPath: path
	"Answer a new instance on a File Moniker object for the specified
	<readableString> path."

	| answer |
	answer := self newPointer.
	OLELibrary default createFileMoniker: path asUtf16String ppmk: answer.
	^answer!

forPointer: anIUnknown
	"Answer a new instance of the receiver wrapping the specified interface
	pointer."

	| answer |
	answer := self newPointer.
	OLELibrary default createPointerMoniker: anIUnknown ppmk: answer.
	^answer! !

!IMoniker class categoriesForMethods!
defineFunctions!initializing!public! !
forCLSID:!instance creation!public! !
forItem:!instance creation!public! !
forItem:delimiter:!instance creation!public! !
forPath:!instance creation!public! !
forPointer:!instance creation!public! !
!

