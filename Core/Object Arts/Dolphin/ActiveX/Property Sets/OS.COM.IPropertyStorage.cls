"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IPropertyStorage'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPropertyStorage guid: (OS.COM.IID fromString: '{00000138-0000-0000-c000-000000000046}')!

OS.COM.IPropertyStorage comment: '`IPropertyStorage` is a wrapper class for the COM Property Storage interface of the same name.

IDL definition follows:
```
[
	object, 
	uuid(00000138-0000-0000-c000-000000000046)
]
interface IPropertyStorage : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall ReadMultiple(
		[in]ULONG cpspec,
		[in]PROPSPEC* rgpspec,
		[out]_inner_PROPVARIANT* rgpropvar);
	[id(0x60010001)]
	HRESULT __stdcall WriteMultiple(
		[in]ULONG cpspec,
		[in]PROPSPEC* rgpspec,
		[in]_inner_PROPVARIANT* rgpropvar,
		[in]unsigned long propidNameFirst);
	[id(0x60010002)]
	HRESULT __stdcall DeleteMultiple(
		[in]ULONG cpspec,
		[in]PROPSPEC* rgpspec);
	[id(0x60010003)]
	HRESULT __stdcall ReadPropertyNames(
		[in]ULONG cpropid,
		[in]unsigned long* rgpropid,
		[out]LPWSTR* rglpwstrName);
	[id(0x60010004)]
	HRESULT __stdcall WritePropertyNames(
		[in]ULONG cpropid,
		[in]unsigned long* rgpropid,
		[in]LPWSTR* rglpwstrName);
	[id(0x60010005)]
	HRESULT __stdcall DeletePropertyNames(
		[in]ULONG cpropid,
		[in]unsigned long* rgpropid);
	[id(0x60010006)]
	HRESULT __stdcall Commit(
		[in]DWORD grfCommitFlags);
	[id(0x60010007)]
	HRESULT __stdcall Revert();
	[id(0x60010008)]
	HRESULT __stdcall Enum(
		[out]IEnumSTATPROPSTG** ppenum);
	[id(0x60010009)]
	HRESULT __stdcall SetTimes(
		[in]FILETIME* pctime,
		[in]FILETIME* patime,
		[in]FILETIME* pmtime);
	[id(0x6001000a)]
	HRESULT __stdcall SetClass(
		[in]GUID* clsid);
	[id(0x6001000b)]
	HRESULT __stdcall Stat(
		[out]STATPROPSETSTG* pstatpsstg);
};
```
'!

!OS.COM.IPropertyStorage categoriesForClass!COM-Interfaces!Win32-Interfaces! !

!OS.COM.IPropertyStorage methodsFor!

commit: grfCommitFlags
	"Invoke the Commit() method of the COM object."

	^self Commit: grfCommitFlags!

Commit: grfCommitFlags
	"Private - Invoke the Commit() method of the COM object.

		HRESULT __stdcall Commit(
			[in]DWORD grfCommitFlags);"

	<virtual stdcall: hresult 10 uint32>
	^self invalidCall: _failureCode!

deleteMultiple: cpspec rgpspec: rgpspec
	"Invoke the DeleteMultiple() method of the COM object."

	^self DeleteMultiple: cpspec rgpspec: rgpspec!

DeleteMultiple: cpspec rgpspec: rgpspec
	"Private - Invoke the DeleteMultiple() method of the COM object.

		HRESULT __stdcall DeleteMultiple(
			[in]ULONG cpspec,
			[in]PROPSPEC* rgpspec);"

	<virtual stdcall: hresult 6 uint32 PROPSPEC*>
	^self invalidCall: _failureCode!

deletePropertyNames: cpropid rgpropid: rgpropid
	"Invoke the DeletePropertyNames() method of the COM object."

	^self DeletePropertyNames: cpropid rgpropid: rgpropid!

DeletePropertyNames: cpropid rgpropid: rgpropid
	"Private - Invoke the DeletePropertyNames() method of the COM object.

		HRESULT __stdcall DeletePropertyNames(
			[in]ULONG cpropid,
			[in]unsigned long* rgpropid);"

	<virtual stdcall: hresult 9 uint32 uint32*>
	^self invalidCall: _failureCode!

directory
	"Answer a <sequencedReadableCollection> of <STATPROPSTG> structures describing the
	elements of the receiver."

	^Enumerable onIEnum: self enum!

enum
	"Answer the <IEnumSTATPROPSTG> result of invoking the COM Object's Enum() method."

	| answer |
	answer := IEnumStruct elementClass: STATPROPSTG.
	self Enum: answer.
	^answer!

Enum: ppenum
	"Private - Invoke the Enum() method of the COM object.

		HRESULT __stdcall Enum(
			[out]IEnumSTATPROPSTG** ppenum);"

	<virtual stdcall: hresult 12 IEnumStruct**>
	^self invalidCall: _failureCode!

readMultiple: cpspec rgpspec: rgpspec
	"Answer the <PROPVARIANT> result of invoking the ReadMultiple() method of the COM object."

	| answer |
	answer := PROPVARIANT new.
	self
		ReadMultiple: cpspec
		rgpspec: rgpspec
		rgpropvar: answer.
	^answer asObject!

ReadMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar
	"Private - Invoke the ReadMultiple() method of the COM object.

		HRESULT __stdcall ReadMultiple(
			[in]ULONG cpspec,
			[in]PROPSPEC* rgpspec,
			[out]PROPVARIANT* rgpropvar);"

	<virtual stdcall: hresult 4 uint32 PROPSPEC* PROPVARIANT*>
	^self invalidCall: _failureCode!

readPropertyNames: cpropid rgpropid: rgpropid
	"Answer the <lpwstr> result of invoking the ReadPropertyNames() method of the COM object."

	| answer |
	answer := StructurePointer newNull: TaskMemory elementClass: Utf16String.
	self
		ReadPropertyNames: cpropid
		rgpropid: rgpropid
		rglpwstrName: answer.
	^answer asObject!

ReadPropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName
	"Private - Invoke the ReadPropertyNames() method of the COM object.

		HRESULT __stdcall ReadPropertyNames(
			[in]ULONG cpropid,
			[in]unsigned long* rgpropid,
			[out]LPWSTR* rglpwstrName);"

	<virtual stdcall: hresult 7 uint32 uint32* lpwstr*>
	^self invalidCall: _failureCode!

revert
	"Invoke the Revert() method of the COM object."

	^self Revert!

Revert
	"Private - Invoke the Revert() method of the COM object.

		HRESULT __stdcall Revert();"

	<virtual stdcall: hresult 11>
	^self invalidCall: _failureCode!

setClass: clsid
	"Invoke the SetClass() method of the COM object."

	^self SetClass: clsid!

SetClass: clsid
	"Private - Invoke the SetClass() method of the COM object.

		HRESULT __stdcall SetClass(
			[in]GUID* clsid);"

	<virtual stdcall: hresult 14 guid*>
	^self invalidCall: _failureCode!

setTimes: pctime patime: patime pmtime: pmtime
	"Invoke the SetTimes() method of the COM object."

	^self
		SetTimes: pctime
		patime: patime
		pmtime: pmtime!

SetTimes: pctime patime: patime pmtime: pmtime
	"Private - Invoke the SetTimes() method of the COM object.

		HRESULT __stdcall SetTimes(
			[in]FILETIME* pctime,
			[in]FILETIME* patime,
			[in]FILETIME* pmtime);"

	<virtual stdcall: hresult 13 FILETIME* FILETIME* FILETIME*>
	^self invalidCall: _failureCode!

stat
	"Answer the <STATPROPSETSTG> result of invoking the Stat() method of the COM object."

	| answer |
	answer := STATPROPSETSTG new.
	self Stat: answer.
	^answer asObject!

Stat: pstatpsstg
	"Private - Invoke the Stat() method of the COM object.

		HRESULT __stdcall Stat(
			[out]STATPROPSETSTG* pstatpsstg);"

	<virtual stdcall: hresult 15 STATPROPSETSTG*>
	^self invalidCall: _failureCode!

writeMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar propidNameFirst: propidNameFirst
	"Invoke the WriteMultiple() method of the COM object."

	^self
		WriteMultiple: cpspec
		rgpspec: rgpspec
		rgpropvar: rgpropvar
		propidNameFirst: propidNameFirst!

WriteMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar propidNameFirst: propidNameFirst
	"Private - Invoke the WriteMultiple() method of the COM object.

		HRESULT __stdcall WriteMultiple(
			[in]ULONG cpspec,
			[in]PROPSPEC* rgpspec,
			[in]PROPVARIANT* rgpropvar,
			[in]unsigned long propidNameFirst);"

	<virtual stdcall: hresult 5 uint32 PROPSPEC* PROPVARIANT* uint32>
	^self invalidCall: _failureCode!

writePropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName
	"Invoke the WritePropertyNames() method of the COM object."

	^self
		WritePropertyNames: cpropid
		rgpropid: rgpropid
		rglpwstrName: rglpwstrName asUtf16String!

WritePropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName
	"Private - Invoke the WritePropertyNames() method of the COM object.

		HRESULT __stdcall WritePropertyNames(
			[in]ULONG cpropid,
			[in]unsigned long* rgpropid,
			[in]LPWSTR* rglpwstrName);"

	<virtual stdcall: hresult 8 uint32 uint32* lpwstr*>
	^self invalidCall: _failureCode! !

!OS.COM.IPropertyStorage categoriesForMethods!
commit:!**auto generated**!methods!public! !
Commit:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
deleteMultiple:rgpspec:!**auto generated**!methods!public! !
DeleteMultiple:rgpspec:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
deletePropertyNames:rgpropid:!**auto generated**!methods!public! !
DeletePropertyNames:rgpropid:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
directory!accessing!public! !
enum!methods!public! !
Enum:!COM Interfaces-IPropertyStorage!private! !
readMultiple:rgpspec:!**auto generated**!methods!public! !
ReadMultiple:rgpspec:rgpropvar:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
readPropertyNames:rgpropid:!**auto generated**!methods!public! !
ReadPropertyNames:rgpropid:rglpwstrName:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
revert!**auto generated**!methods!public! !
Revert!**auto generated**!COM Interfaces-IPropertyStorage!private! !
setClass:!**auto generated**!methods!public! !
SetClass:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
setTimes:patime:pmtime:!**auto generated**!methods!public! !
SetTimes:patime:pmtime:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
stat!**auto generated**!methods!public! !
Stat:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
writeMultiple:rgpspec:rgpropvar:propidNameFirst:!**auto generated**!methods!public! !
WriteMultiple:rgpspec:rgpropvar:propidNameFirst:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
writePropertyNames:rgpropid:rglpwstrName:!**auto generated**!methods!public! !
WritePropertyNames:rgpropid:rglpwstrName:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!

!OS.COM.IPropertyStorage class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WIC.IPropertyStorage'
		IPropertyStorage defineTemplate"

	self
		defineFunction: #ReadMultiple:rgpspec:rgpropvar:
			argumentTypes: 'uint32 PROPSPEC* PROPVARIANT*';
		defineFunction: #WriteMultiple:rgpspec:rgpropvar:propidNameFirst:
			argumentTypes: 'uint32 PROPSPEC* PROPVARIANT* uint32';
		defineFunction: #DeleteMultiple:rgpspec:
			argumentTypes: 'uint32 PROPSPEC*';
		defineFunction: #ReadPropertyNames:rgpropid:rglpwstrName:
			argumentTypes: 'uint32 uint32* lpwstr*';
		defineFunction: #WritePropertyNames:rgpropid:rglpwstrName:
			argumentTypes: 'uint32 uint32* lpwstr*';
		defineFunction: #DeletePropertyNames:rgpropid:
			argumentTypes: 'uint32 uint32*';
		defineFunction: #Commit:
			argumentTypes: 'uint32';
		defineFunction: #Revert;
		defineFunction: #Enum:
			argumentTypes: 'IEnumStruct**';
		defineFunction: #SetTimes:patime:pmtime:
			argumentTypes: 'FILETIME* FILETIME* FILETIME*';
		defineFunction: #SetClass:
			argumentTypes: 'GUID*';
		defineFunction: #Stat:
			argumentTypes: 'STATPROPSETSTG*'
! !

!OS.COM.IPropertyStorage class categoriesForMethods!
defineFunctions!initializing!public!template definition! !
!

