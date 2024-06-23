"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IRunningObjectTable'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IRunningObjectTable guid: (OS.COM.IID fromString: '{00000010-0000-0000-c000-000000000046}')!

OS.COM.IRunningObjectTable isEgressOnly: true!

OS.COM.IRunningObjectTable comment: '<IRunningObjectTable> is a wrapper class for the custom interface ''OBJIDL.IRunningObjectTable'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface.

No function table has been generated for IRunningObjectTable because this interface is implemented by the system and it is not expected that there will be any reason to implement it in Dolphin.'!

!OS.COM.IRunningObjectTable categoriesForClass!OBJIDL-Interfaces! !

!OS.COM.IRunningObjectTable methodsFor!

enumRunning
	"Answer the <IEnumMoniker> result of invoking the EnumRunning() method of the COM object."

	| answer |
	answer := IEnumMoniker newPointer.
	self EnumRunning: answer.
	^answer asObject!

EnumRunning: ppenumMoniker
	"Private - Invoke the EnumRunning() method of the COM object.

		HRESULT __stdcall EnumRunning(
			[out]IEnumMoniker** ppenumMoniker);"

	<virtual stdcall: hresult 10 IEnumMoniker**>
	^self invalidCall: _failureCode!

getObject: pmkObjectName
	"Answer the <IUnknown> result of invoking the GetObject() method of the COM object."

	| answer |
	answer := IUnknown newPointer.
	self GetObject: pmkObjectName ppunkObject: answer.
	^answer asObject!

GetObject: pmkObjectName ppunkObject: ppunkObject
	"Private - Invoke the GetObject() method of the COM object.

		HRESULT __stdcall GetObject(
			[in]IMoniker* pmkObjectName,
			[out]IUnknown** ppunkObject);"

	<virtual stdcall: hresult 7 IMoniker* IUnknown**>
	^self invalidCall: _failureCode!

getTimeOfLastChange: pmkObjectName
	"Answer the <FILETIME> result of invoking the GetTimeOfLastChange() method of the COM object."

	| answer |
	answer := FILETIME new.
	self GetTimeOfLastChange: pmkObjectName pfiletime: answer.
	^answer asObject!

GetTimeOfLastChange: pmkObjectName pfiletime: pfiletime
	"Private - Invoke the GetTimeOfLastChange() method of the COM object.

		HRESULT __stdcall GetTimeOfLastChange(
			[in]IMoniker* pmkObjectName,
			[out]FILETIME* pfiletime);"

	<virtual stdcall: hresult 9 IMoniker* FILETIME*>
	^self invalidCall: _failureCode!

IsRunning: pmkObjectName
	"Invoke the IsRunning() method of the COM object.

		HRESULT __stdcall IsRunning(
			[in]IMoniker* pmkObjectName);"

	<virtual stdcall: hresult 6 IMoniker*>
	^self invalidCall: _failureCode!

NoteChangeTime: dwRegister pfiletime: pfiletime
	"Invoke the NoteChangeTime() method of the COM object.

		HRESULT __stdcall NoteChangeTime(
			[in]unsigned long dwRegister,
			[in]FILETIME* pfiletime);"

	<virtual stdcall: hresult 8 uint32 FILETIME*>
	^self invalidCall: _failureCode!

register: grfFlags punkObject: punkObject pmkObjectName: pmkObjectName
	"Answer the <UInt32> result of invoking the Register() method of the COM object."

	| answer |
	answer := UInt32 new.
	self
		Register: grfFlags
		punkObject: punkObject
		pmkObjectName: pmkObjectName
		pdwRegister: answer.
	^answer asObject!

Register: grfFlags punkObject: punkObject pmkObjectName: pmkObjectName pdwRegister: pdwRegister
	"Private - Invoke the Register() method of the COM object.

		HRESULT __stdcall Register(
			[in]unsigned long grfFlags,
			[in]IUnknown* punkObject,
			[in]IMoniker* pmkObjectName,
			[out]unsigned long* pdwRegister);"

	<virtual stdcall: hresult 4 uint32 IUnknown* IMoniker* uint32*>
	^self invalidCall: _failureCode!

Revoke: dwRegister
	"Invoke the Revoke() method of the COM object.

		HRESULT __stdcall Revoke(
			[in]unsigned long dwRegister);"

	<virtual stdcall: hresult 5 uint32>
	^self invalidCall: _failureCode!

running
	"Answer a <collection> of all monikers for all running objects."

	| enum answer |
	enum := IEnumMoniker newPointer.
	self EnumRunning: enum.
	answer := enum contents.
	enum free.
	^answer! !

!OS.COM.IRunningObjectTable categoriesForMethods!
enumRunning!**auto generated**!methods!public! !
EnumRunning:!**auto generated**!COM Interfaces-IRunningObjectTable!private! !
getObject:!**auto generated**!methods!public! !
GetObject:ppunkObject:!**auto generated**!COM Interfaces-IRunningObjectTable!private! !
getTimeOfLastChange:!**auto generated**!methods!public! !
GetTimeOfLastChange:pfiletime:!**auto generated**!COM Interfaces-IRunningObjectTable!private! !
IsRunning:!**auto generated**!COM Interfaces-IRunningObjectTable!public! !
NoteChangeTime:pfiletime:!**auto generated**!COM Interfaces-IRunningObjectTable!public! !
register:punkObject:pmkObjectName:!**auto generated**!methods!public! !
Register:punkObject:pmkObjectName:pdwRegister:!**auto generated**!COM Interfaces-IRunningObjectTable!private! !
Revoke:!**auto generated**!COM Interfaces-IRunningObjectTable!public! !
running!enumerating!public! !
!

!OS.COM.IRunningObjectTable class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'Win32.IRunningObjectTable'
		IRunningObjectTable defineTemplate"

	self
		defineFunction: #Register:punkObject:pmkObjectName:pdwRegister:
			argumentTypes: 'dword IUnknown* IMoniker* dword*';
		defineFunction: #Revoke:
			argumentTypes: 'dword';
		defineFunction: #IsRunning:
			argumentTypes: 'IMoniker*';
		defineFunction: #GetObject:ppunkObject:
			argumentTypes: 'IMoniker* IUnknown**';
		defineFunction: #NoteChangeTime:pfiletime:
			argumentTypes: 'dword FILETIME*';
		defineFunction: #GetTimeOfLastChange:pfiletime:
			argumentTypes: 'IMoniker* FILETIME*';
		defineFunction: #EnumRunning:
			argumentTypes: 'IEnumMoniker**'
!

new
	"Answer a new instance of the receiver on the ROT."

	| answer |
	answer := self newPointer.
	Ole32 getRunningObjectTable: 0 pprot: answer.
	^answer! !

!OS.COM.IRunningObjectTable class categoriesForMethods!
defineFunctions!**auto generated**!initializing!public!template definition! !
new!instance creation!public! !
!

