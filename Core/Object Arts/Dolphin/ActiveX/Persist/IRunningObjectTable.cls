"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #IRunningObjectTable
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IRunningObjectTable guid: (IID fromString: '{00000010-0000-0000-C000-000000000046}')!
IRunningObjectTable comment: '<IRunningObjectTable> is a wrapper class for the custom interface ''OBJIDL.IRunningObjectTable'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

No function table has been generated for IRunningObjectTable because this interface is implemented by the system and it is not expected that there will be any reason to implement it in Dolphin.'!
!IRunningObjectTable categoriesForClass!COM-Interfaces! !
!IRunningObjectTable methodsFor!

EnumRunning: ppenumMoniker
	"Invoke the EnumRunning() method of the object wrapped by the receiver.
	
		HRESULT __stdcall EnumRunning(
			[out] IEnumMoniker** ppenumMoniker);

	"

	<virtual stdcall: hresult 10 IEnumMoniker**>
	^self invalidCall
!

GetObject: pmkObjectName ppunkObject: ppunkObject
	"Invoke the GetObject() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetObject(
			[in] IMoniker* pmkObjectName,
			[out] IUnknown** ppunkObject);

	"

	<virtual stdcall: hresult 7 IMoniker* IUnknown**>
	^self invalidCall
!

GetTimeOfLastChange: pmkObjectName pfiletime: pfiletime
	"Invoke the GetTimeOfLastChange() method of the object wrapped by the receiver.
	
		HRESULT __stdcall GetTimeOfLastChange(
			[in] IMoniker* pmkObjectName,
			[out] FILETIME* pfiletime);

	"

	<virtual stdcall: hresult 9 IMoniker* FILETIME*>
	^self invalidCall
!

IsRunning: pmkObjectName
	"Invoke the IsRunning() method of the object wrapped by the receiver.
	
		HRESULT __stdcall IsRunning(
			[in] IMoniker* pmkObjectName);

	"

	<virtual stdcall: hresult 6 IMoniker*>
	^self invalidCall
!

NoteChangeTime: dwRegister pfiletime: pfiletime
	"Invoke the NoteChangeTime() method of the object wrapped by the receiver.
	
		HRESULT __stdcall NoteChangeTime(
			[in] unsigned long dwRegister,
			[in] FILETIME* pfiletime);

	"

	<virtual stdcall: hresult 8 dword FILETIME*>
	^self invalidCall
!

Register: grfFlags punkObject: punkObject pmkObjectName: pmkObjectName pdwRegister: pdwRegister
	"Invoke the Register() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Register(
			[in] unsigned long grfFlags,
			[in] IUnknown* punkObject,
			[in] IMoniker* pmkObjectName,
			[out] unsigned long* pdwRegister);

	"

	<virtual stdcall: hresult 4 dword IUnknown* IMoniker* dword*>
	^self invalidCall
!

Revoke: dwRegister
	"Invoke the Revoke() method of the object wrapped by the receiver.
	
		HRESULT __stdcall Revoke(
			[in] unsigned long dwRegister);

	"

	<virtual stdcall: hresult 5 dword>
	^self invalidCall
!

running
	"Answer a <collection> of all monikers for all running objects."
	
	| enum answer |
	enum := IEnumMoniker newPointer.
	self EnumRunning: enum.
	answer := enum contents.
	enum free.
	^answer! !
!IRunningObjectTable categoriesFor: #EnumRunning:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #GetObject:ppunkObject:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #GetTimeOfLastChange:pfiletime:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #IsRunning:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #NoteChangeTime:pfiletime:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #Register:punkObject:pmkObjectName:pdwRegister:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #Revoke:!**auto generated**!COM Interfaces-OBJIDL.IRunningObjectTable!primitives!public! !
!IRunningObjectTable categoriesFor: #running!enumerating!public! !

IRunningObjectTable methodProtocol: #IRunningObjectTable attributes: #(#readOnly) selectors: #(#EnumRunning: #GetObject:ppunkObject: #GetTimeOfLastChange:pfiletime: #IsRunning: #NoteChangeTime:pfiletime: #Register:punkObject:pmkObjectName:pdwRegister: #Revoke:)!

!IRunningObjectTable class methodsFor!

new
	"Answer a new instance of the receiver on the ROT."

	| answer |
	answer := self newPointer.
	OLELibrary default getRunningObjectTable: 0 pprot: answer.
	^answer! !
!IRunningObjectTable class categoriesFor: #new!instance creation!public! !

