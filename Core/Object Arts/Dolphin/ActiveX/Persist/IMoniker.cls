"Filed out from Dolphin Smalltalk X6"!

IPersistStream subclass: #IMoniker
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IMoniker guid: (IID fromString: '{0000000F-0000-0000-C000-000000000046}')!
IMoniker comment: '<IMoniker> is a wrapper class for the custom interface ''OBJIDL.IMoniker'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IMoniker categoriesForClass!COM-Interfaces! !
!IMoniker methodsFor!

= anObject
	"Answer whether the receiver is equal to the argument."

	^self species == anObject species 
		and: [(self IsEqual: anObject) == S_OK]!

asString
	"Answer a string representation of the receiver."

	^self asUnicodeString asString!

asUnicodeString
	"Answer a string representation of the receiver.
	This conversion is sensible as it is invertible with ParseDisplayName."

	| pbc ppszDisplayName answer |
	pbc := IBindCtx new.
	#todo "Set a deadline to avoid lengthy binding operation?".
	ppszDisplayName := COMTaskMemory new.
	self GetDisplayName: pbc pmkToLeft: nil ppszDisplayName: ppszDisplayName.
	answer := UnicodeString fromAddress: ppszDisplayName.
	ppszDisplayName free.
	pbc free.
	^answer!

BindToObject: pbc pmkToLeft: pmkToLeft riidResult: riidResult ppvResult: ppvResult
	"Invoke the BindToObject() method of the object wrapped by the receiver.
	
		HRESULT __stdcall BindToObject(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[in] GUID* riidResult,
			[out] IUnknown** ppvResult);
	"

	<virtual stdcall: hresult 9 IBindCtx* IMoniker* GUID* IUnknown**>
	^self invalidCall!

BindToStorage: pbc pmkToLeft: pmkToLeft riid: riid ppvObj: ppvObj
	"Invoke the BindToStorage() method of the object wrapped by the receiver.
	
		HRESULT __stdcall BindToStorage(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[in] GUID* riid,
			[out] IUnknown** ppvObj);
	"

	<virtual stdcall: hresult 10 IBindCtx* IMoniker* GUID* IUnknown**>
	^self invalidCall!

commonPrefixWith: pmkOther
	"Answer an <IMoniker> naming the common prefix between the receiver
	and the <IMoniker> argument, pmkOther."

	| pmkPrefix |
	pmkPrefix := self class newPointer.
	self CommonPrefixWith: pmkOther ppmkPrefix: pmkPrefix.
	^pmkPrefix

"
(IMoniker forPath: 'c:\winnt\system32\kernel32.dll') 
	commonPrefixWith: (IMoniker forPath: 'c:\winnt\explorer.exe')
"!

CommonPrefixWith: pmkOther ppmkPrefix: ppmkPrefix
	"Invoke the CommonPrefixWith() method of the object wrapped by the receiver.
	
		HRESULT __stdcall CommonPrefixWith(
			[in] IMoniker* pmkOther,
			[out] IMoniker** ppmkPrefix);

	"

	<virtual stdcall: hresult 19 IMoniker* IMoniker**>
	^self invalidCall
!

composeWith: pmkRight
	"Answer a composite moniker constructed from the receiver with the <IMoniker>
	pmkRight to its right."

	^self composeWith: pmkRight onlyIfNotGeneric: false

"
1) Example which composes a path:
((IMoniker forPath: 'c:\')
	composeWith: (IMoniker forPath: 'winnt')) displayString.
2) Example which composes a typical file!!item moniker (must be generic):
((IMoniker forPath: 'c:\blah')
	composeWith: (IMoniker forItem: 'blah')) displayString.
"!

ComposeWith: pmkRight fOnlyIfNotGeneric: fOnlyIfNotGeneric ppmkComposite: ppmkComposite
	"Invoke the ComposeWith() method of the object wrapped by the receiver.
	
		HRESULT __stdcall ComposeWith(
			[in] IMoniker* pmkRight,
			[in] long fOnlyIfNotGeneric,
			[out] IMoniker** ppmkComposite);

	"

	<virtual stdcall: hresult 12 IMoniker* sdword IMoniker**>
	^self invalidCall
!

composeWith: pmkRight onlyIfNotGeneric: genericUnacceptable
	"Answer a composite moniker constructed from the receiver with the <IMoniker>
	pmkRight to its right. If the <boolean> flag, genericUnacceptable, is true
	then it is an error if the <IMoniker> pmkRight is not composable with the receiver
	except as a generic composite."

	| pmkComposite |
	pmkComposite := self class newPointer.
	self ComposeWith: pmkRight fOnlyIfNotGeneric: genericUnacceptable ppmkComposite: pmkComposite.
	^pmkComposite

"
1) Example which composes a path:
((IMoniker forPath: 'c:\')
	composeWith: (IMoniker forPath: 'winnt') 
	onlyIfNotGeneric: true) displayString.
2) Example which composes a typical file!!item moniker (must be generic):
((IMoniker forPath: 'c:\blah')
	composeWith: (IMoniker forItem: 'blah') 
	onlyIfNotGeneric: false) displayString.
"!

displayOn: aStream
	"Append a user friendly textual representation of the receiver to aStream."

	| displayName |
	[displayName := self asUnicodeString]  on: HRESULTError do: [:e | 
		^super displayOn: aStream].
	aStream display: displayName!

enum: forward
	"Answer an <IEnumMoniker> on the receiver.
	N.B. Only works if the receiver is a composite moniker (bad factoring)."

	| enum |
	enum := IEnumMoniker newPointer.
	self Enum: forward ppenumMoniker: enum.
	^enum isNull 
		ifTrue: [self error: 'Not a composite moniker']
		ifFalse: [enum]

"
(((IMoniker forPath: 'c:\blah')
	composeWith: (IMoniker forItem: 'blah') 
	onlyIfNotGeneric: false) enum: true) contents
"!

Enum: fForward ppenumMoniker: ppenumMoniker
	"Invoke the Enum() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Enum(
			[in] long fForward,
			[out] IEnumMoniker** ppenumMoniker);

	"

	<virtual stdcall: hresult 13 sdword IEnumMoniker**>
	^self invalidCall
!

GetDisplayName: pbc pmkToLeft: pmkToLeft ppszDisplayName: ppszDisplayName
	"Invoke the GetDisplayName() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetDisplayName(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[out] LPWSTR* ppszDisplayName);

	"

	<virtual stdcall: hresult 21 IBindCtx* IMoniker* lpwstr*>
	^self invalidCall!

GetTimeOfLastChange: pbc pmkToLeft: pmkToLeft pfiletime: pfiletime
	"Invoke the GetTimeOfLastChange() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetTimeOfLastChange(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[out] FILETIME* pfiletime);

	"

	<virtual stdcall: hresult 17 IBindCtx* IMoniker* FILETIME*>
	^self invalidCall
!

hash
	"Answer the hash value for the receiver."

	| answer |
	answer := DWORD new.
	self Hash: answer.
	^answer value!

Hash: pdwHash
	"Invoke the Hash() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Hash(
			[out] unsigned long* pdwHash);
	"

	<virtual stdcall: hresult 15 dword*>
	^self invalidCall
!

inverse
	"Answer the receiver's anti-moniker (i.e. a moniker which, when composed to the right
	of the receiver, cancels it out)."

	| answer |
	answer := IMoniker newPointer.
	self Inverse: answer.
	^answer

"
(IMoniker forPath: 'c:\temp') inverse.
((IMoniker forPath: 'c:\blah')
	composeWith: (IMoniker forItem: 'blah')) inverse.
"!

Inverse: ppmk
	"Invoke the Inverse() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Inverse(
			[out] IMoniker** ppmk);
	"

	<virtual stdcall: hresult 18 IMoniker**>
	^self invalidCall
!

IsEqual: pmkOtherMoniker
	"Invoke the IsEqual() method of the object wrapped by the receiver.
	
		HRESULT __stdcall IsEqual(
			[in] IMoniker* pmkOtherMoniker);
	"

	<virtual stdcall: hresult 14 IMoniker*>
	^self invalidCall
!

isRunning
	"Answer whether the object named by the receiver is already running."

	| pbc hr |
	pbc := IBindCtx new.
	hr := self IsRunning: pbc pmkToLeft: nil pmkNewlyRunning: nil.
	pbc free.
	^hr == S_OK

"
(IMoniker forPath: 'c:\winnt\system32\kernel32.dll') isRunning
"!

IsRunning: pbc pmkToLeft: pmkToLeft pmkNewlyRunning: pmkNewlyRunning
	"Invoke the IsRunning() method of the object wrapped by the receiver.
	
		HRESULT __stdcall IsRunning(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[in] IMoniker* pmkNewlyRunning);

	"

	<virtual stdcall: hresult 16 IBindCtx* IMoniker* IMoniker*>
	^self invalidCall
!

isSystemMoniker
	"Answer whether the receiver is a 'system moniker', i.e. one with an 
	implemenation provided by OLE itself."

	| mksys |
	mksys := DWORDBytes new.
	^(self IsSystemMoniker: mksys) == S_OK

"
(IMoniker forPath: 'c:\') isSystemMoniker
"!

IsSystemMoniker: pdwMksys
	"Invoke the IsSystemMoniker() method of the object wrapped by the receiver.
	
		HRESULT __stdcall IsSystemMoniker(
			[out] unsigned long* pdwMksys);

	"

	<virtual stdcall: hresult 23 dword*>
	^self invalidCall
!

ParseDisplayName: pbc pmkToLeft: pmkToLeft pszDisplayName: pszDisplayName pchEaten: pchEaten ppmkOut: ppmkOut
	"Invoke the ParseDisplayName() method of the object wrapped by the receiver.
	
		HRESULT __stdcall ParseDisplayName(
			[in] IBindCtx* pbc,
			[in] IMoniker* pmkToLeft,
			[in] LPWSTR pszDisplayName,
			[out] unsigned long* pchEaten,
			[out] IMoniker** ppmkOut);

	"

	<virtual stdcall: hresult 22 IBindCtx* IMoniker* lpwstr dword* IMoniker**>
	^self invalidCall
!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream.
	Implementation Note: Override to scrape out the moniker's display name."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: ([self asUnicodeString] on: HRESULTError do: [:e | bytes]);
		nextPut: $)!

Reduce: pbc dwReduceHowFar: dwReduceHowFar ppmkToLeft: ppmkToLeft ppmkReduced: ppmkReduced
	"Invoke the Reduce() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Reduce(
			[in] IBindCtx* pbc,
			[in] unsigned long dwReduceHowFar,
			[in, out] IMoniker** ppmkToLeft,
			[out] IMoniker** ppmkReduced);

	"

	<virtual stdcall: hresult 11 IBindCtx* dword IMoniker** IMoniker**>
	^self invalidCall
!

relativePathTo: pmkOther
	"Answer an <IMoniker> naming the relative path from the receiver
	to the <IMoniker> argument, pmkOther."

	| pmkPrefix |
	pmkPrefix := self class newPointer.
	self RelativePathTo: pmkOther ppmkRelPath: pmkPrefix.
	^pmkPrefix

"
1) Relative path from image to COM package:
(IMoniker forPath: SessionManager current imagePath)
	relativePathTo: (IMoniker forPath: ((PackageManager current at: 'OLE Com') fileOutName))
"!

RelativePathTo: pmkOther ppmkRelPath: ppmkRelPath
	"Invoke the RelativePathTo() method of the object wrapped by the receiver.
	
		HRESULT __stdcall RelativePathTo(
			[in] IMoniker* pmkOther,
			[out] IMoniker** ppmkRelPath);

	"

	<virtual stdcall: hresult 20 IMoniker* IMoniker**>
	^self invalidCall
!

systemMonikerType
	"Answer whether the receiver is a 'system moniker', i.e. one with an 
	implemenation provided by OLE itself."

	| mksys |
	mksys := DWORDBytes new.
	self IsSystemMoniker: mksys.
	^mksys asInteger

"
(IMoniker forPath: 'c:\') systemMonikerType
"!

timeOfLastChange
	"Answer a FILETIME with the modification time for the receiver.
	Often this is not implemented, or does not make sense for the moniker type
	(bad factoring againg). This may also involve binding the object, which
	might take an arbitrarily long time."

	| pbc answer |
	pbc := IBindCtx new.
	answer := FILETIME new.
	self GetTimeOfLastChange: pbc pmkToLeft: nil pfiletime: answer.
	^answer

"
1) Time the temp dir was last modified:
	(IMoniker forPath: 'c:\temp') timeOfLastChange
2) Attempt to bind an item moniker without specifying context, gives error:
	(IMoniker forItem: 'blah') timeOfLastChange
3) Pointer moniker, not implemented:
	(IMoniker forPointer: IMalloc task) timeOfLastChange
"! !
!IMoniker categoriesFor: #=!comparing!public! !
!IMoniker categoriesFor: #asString!converting!public! !
!IMoniker categoriesFor: #asUnicodeString!converting!public! !
!IMoniker categoriesFor: #BindToObject:pmkToLeft:riidResult:ppvResult:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #BindToStorage:pmkToLeft:riid:ppvObj:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #commonPrefixWith:!comparing!public! !
!IMoniker categoriesFor: #CommonPrefixWith:ppmkPrefix:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #composeWith:!operations!public! !
!IMoniker categoriesFor: #ComposeWith:fOnlyIfNotGeneric:ppmkComposite:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #composeWith:onlyIfNotGeneric:!COM Interfaces!COM Interfaces-OBJIDL.IMoniker!public! !
!IMoniker categoriesFor: #displayOn:!printing!public! !
!IMoniker categoriesFor: #enum:!enumerating!public! !
!IMoniker categoriesFor: #Enum:ppenumMoniker:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #GetDisplayName:pmkToLeft:ppszDisplayName:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #GetTimeOfLastChange:pmkToLeft:pfiletime:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #hash!comparing!public! !
!IMoniker categoriesFor: #Hash:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #inverse!accessing!public! !
!IMoniker categoriesFor: #Inverse:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #IsEqual:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #isRunning!public!testing! !
!IMoniker categoriesFor: #IsRunning:pmkToLeft:pmkNewlyRunning:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #isSystemMoniker!public!testing! !
!IMoniker categoriesFor: #IsSystemMoniker:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #ParseDisplayName:pmkToLeft:pszDisplayName:pchEaten:ppmkOut:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #printOn:!printing!public! !
!IMoniker categoriesFor: #Reduce:dwReduceHowFar:ppmkToLeft:ppmkReduced:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #relativePathTo:!comparing!public! !
!IMoniker categoriesFor: #RelativePathTo:ppmkRelPath:!**auto generated**!COM Interfaces-OBJIDL.IMoniker!primitives!public! !
!IMoniker categoriesFor: #systemMonikerType!accessing!public! !
!IMoniker categoriesFor: #timeOfLastChange!accessing!public! !

IMoniker methodProtocol: #IMoniker attributes: #(#readOnly) selectors: #(#BindToObject:pmkToLeft:riidResult:ppvResult: #BindToStorage:pmkToLeft:riid:ppvObj: #CommonPrefixWith:ppmkPrefix: #ComposeWith:fOnlyIfNotGeneric:ppmkComposite: #Enum:ppenumMoniker: #GetClassID: #GetDisplayName:pmkToLeft:ppszDisplayName: #GetSizeMax: #GetTimeOfLastChange:pmkToLeft:pfiletime: #Hash: #Inverse: #IsDirty #IsRunning:pmkToLeft:pmkNewlyRunning: #IsSystemMoniker: #Load: #ParseDisplayName:pmkToLeft:pszDisplayName:pchEaten:ppmkOut: #Reduce:dwReduceHowFar:ppmkToLeft:ppmkReduced: #RelativePathTo:ppmkRelPath: #Save:fClearDirty:)!

!IMoniker class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IMoniker'
		IMoniker defineTemplate
	"

	self
		defineFunction: #BindToObject:pmkToLeft:riidResult:ppvResult:
			argumentTypes: 'IBindCtx* IMoniker* GUID* IUnknown**';
		defineFunction: #BindToStorage:pmkToLeft:riid:ppvObj:
			argumentTypes: 'IBindCtx* IMoniker* GUID* IUnknown**';
		defineFunction: #Reduce:dwReduceHowFar:ppmkToLeft:ppmkReduced:
			argumentTypes: 'IBindCtx* dword IMoniker** IMoniker**';
		defineFunction: #ComposeWith:fOnlyIfNotGeneric:ppmkComposite:
			argumentTypes: 'IMoniker* sdword IMoniker**';
		defineFunction: #Enum:ppenumMoniker:
			argumentTypes: 'sdword IEnumMoniker**';
		defineFunction: #IsEqual:
			argumentTypes: 'IMoniker*';
		defineFunction: #Hash:
			argumentTypes: 'dword*';
		defineFunction: #IsRunning:pmkToLeft:pmkNewlyRunning:
			argumentTypes: 'IBindCtx* IMoniker* IMoniker*';
		defineFunction: #GetTimeOfLastChange:pmkToLeft:pfiletime:
			argumentTypes: 'IBindCtx* IMoniker* FILETIME*';
		defineFunction: #Inverse:
			argumentTypes: 'IMoniker**';
		defineFunction: #CommonPrefixWith:ppmkPrefix:
			argumentTypes: 'IMoniker* IMoniker**';
		defineFunction: #RelativePathTo:ppmkRelPath:
			argumentTypes: 'IMoniker* IMoniker**';
		defineFunction: #GetDisplayName:pmkToLeft:ppszDisplayName:
			argumentTypes: 'IBindCtx* IMoniker* lpwstr*';
		defineFunction: #ParseDisplayName:pmkToLeft:pszDisplayName:pchEaten:ppmkOut:
			argumentTypes: 'IBindCtx* IMoniker* lpwstr dword* IMoniker**';
		defineFunction: #IsSystemMoniker:
			argumentTypes: 'dword*'!

forItem: itemName
	"Answer a new instance of the receiver on an Item Moniker object with the specified
	<readableString> item name. The interpretation of the name depends on the container
	(e.g. a coclass which implements IOleItemContainer to answer named instances)."

	^self forItem: itemName delimiter: '!!'

"
IMoniker forItem: 'blah'
"!

forItem: itemName delimiter: separatorString
	"Answer a new instance of the receiver on an Item Moniker object with the specified
	<readableString> item name. The interpretation of the name depends on the container
	(e.g. a coclass which implements IOleItemContainer to answer named instances)."

	| answer |
	answer := self newPointer.
	OLELibrary default 
		createItemMoniker: separatorString asUnicodeString 
		lpszItem: itemName asUnicodeString 
		ppmk: answer.
	^answer!

forPath: path
	"Answer a new instance on a File Moniker object for the specified
	<readableString> path."

	| answer |
	answer := self newPointer.
	OLELibrary default createFileMoniker: path asUnicodeString ppmk: answer.
	^answer.

"
IMoniker forPath: 'c:\winnt\system32\kernel32.dll'
"!

forPointer: anIUnknown
	"Answer a new instance of the receiver wrapping the specified interface
	pointer."

	| answer |
	answer := self newPointer.
	OLELibrary default createPointerMoniker: anIUnknown ppmk: answer.
	^answer.

"
IMoniker forPointer: IMalloc task
"! !
!IMoniker class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!IMoniker class categoriesFor: #forItem:!instance creation!public! !
!IMoniker class categoriesFor: #forItem:delimiter:!instance creation!public! !
!IMoniker class categoriesFor: #forPath:!instance creation!public! !
!IMoniker class categoriesFor: #forPointer:!instance creation!public! !

