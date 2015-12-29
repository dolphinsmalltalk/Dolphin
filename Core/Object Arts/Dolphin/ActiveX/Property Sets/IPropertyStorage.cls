"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IPropertyStorage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IPropertyStorage guid: (IID fromString: '{00000138-0000-0000-C000-000000000046}')!
IPropertyStorage comment: '<IPropertyStorage> is a wrapper class for the COM interface ''OBJIDL.IPropertyStorage'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(00000138-0000-0000-C000-000000000046)
]
interface IPropertyStorage : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall ReadMultiple(
		[in] unsigned long cpspec,
		[in] PROPSPEC* rgpspec,
		[out] PROPVARIANT* rgpropvar);
	[id(0x60010001)]
	HRESULT __stdcall WriteMultiple(
		[in] unsigned long cpspec,
		[in] PROPSPEC* rgpspec,
		[in] PROPVARIANT* rgpropvar,
		[in] unsigned long propidNameFirst);
	[id(0x60010002)]
	HRESULT __stdcall DeleteMultiple(
		[in] unsigned long cpspec,
		[in] PROPSPEC* rgpspec);
	[id(0x60010003)]
	HRESULT __stdcall ReadPropertyNames(
		[in] unsigned long cpropid,
		[in] unsigned long* rgpropid,
		[out] LPWSTR* rglpwstrName);
	[id(0x60010004)]
	HRESULT __stdcall WritePropertyNames(
		[in] unsigned long cpropid,
		[in] unsigned long* rgpropid,
		[in] LPWSTR* rglpwstrName);
	[id(0x60010005)]
	HRESULT __stdcall DeletePropertyNames(
		[in] unsigned long cpropid,
		[in] unsigned long* rgpropid);
	[id(0x60010006)]
	HRESULT __stdcall Commit(
		[in] unsigned long grfCommitFlags);
	[id(0x60010007)]
	HRESULT __stdcall Revert();
	[id(0x60010008)]
	HRESULT __stdcall Enum(
		[out] IEnumSTATPROPSTG** ppenum);
	[id(0x60010009)]
	HRESULT __stdcall SetTimes(
		[in] FILETIME* pctime,
		[in] FILETIME* patime,
		[in] FILETIME* pmtime);
	[id(0x6001000a)]
	HRESULT __stdcall SetClass(
		[in] GUID* clsid);
	[id(0x6001000b)]
	HRESULT __stdcall Stat(
		[out] STATPROPSETSTG* pstatpsstg);
};
'!
!IPropertyStorage categoriesForClass!COM-Interfaces!OBJIDL-Interfaces! !
!IPropertyStorage methodsFor!

commit: grfCommitFlags 
	"Invoke the Commit() method of the COM Object."

	^self
		Commit: grfCommitFlags
!

Commit: grfCommitFlags
	"Private - Invoke the Commit() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Commit(
			[in] unsigned long grfCommitFlags);
	"

	<virtual stdcall: hresult 10 dword>
	^self invalidCall
!

deleteMultiple: cpspec rgpspec: rgpspec 
	"Invoke the DeleteMultiple() method of the COM Object."

	^self
		DeleteMultiple: cpspec
		rgpspec: rgpspec
!

DeleteMultiple: cpspec rgpspec: rgpspec
	"Private - Invoke the DeleteMultiple() method of the COM object wrapped by the receiver.

		HRESULT __stdcall DeleteMultiple(
			[in] unsigned long cpspec,
			[in] PROPSPEC* rgpspec);
	"

	<virtual stdcall: hresult 6 dword PROPSPEC*>
	^self invalidCall
!

deletePropertyNames: cpropid rgpropid: rgpropid 
	"Invoke the DeletePropertyNames() method of the COM Object."

	^self
		DeletePropertyNames: cpropid
		rgpropid: rgpropid
!

DeletePropertyNames: cpropid rgpropid: rgpropid
	"Private - Invoke the DeletePropertyNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall DeletePropertyNames(
			[in] unsigned long cpropid,
			[in] unsigned long* rgpropid);
	"

	<virtual stdcall: hresult 9 dword dword*>
	^self invalidCall
!

directory
	"Answer a <sequencedReadableCollection> of <STATPROPSTG> structures describing the
	elements of the receiver."

	^OLEEnumerator onIEnum: self enum!

enum
	"Answer the <IEnumSTATPROPSTG> result of invoking the COM Object's Enum() method."

	| answer |
	answer := IEnumStruct elementClass: STATPROPSTG.
	self Enum: answer.
	^answer!

Enum: ppenum
	"Private - Invoke the Enum() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Enum(
			[out] IEnumSTATPROPSTG** ppenum);
	"

	<virtual stdcall: hresult 12 void**>
	^self invalidCall
!

readMultiple: cpspec rgpspec: rgpspec 
	"Answer the <VARIANT> result of invoking the COM Object's ReadMultiple() method."

	| answer |
	answer := VARIANT new.
	self
		ReadMultiple: cpspec
		rgpspec: rgpspec
		rgpropvar: answer.
	^answer asObject
!

ReadMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar
	"Private - Invoke the ReadMultiple() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ReadMultiple(
			[in] unsigned long cpspec,
			[in] PROPSPEC* rgpspec,
			[out] PROPVARIANT* rgpropvar);
	"

	<virtual stdcall: hresult 4 dword PROPSPEC* variant*>
	^self invalidCall
!

readPropertyNames: cpropid rgpropid: rgpropid 
	"Answer the <UnicodeString> result of invoking the COM Object's ReadPropertyNames() method."

	| answer |
	answer := (StructurePointer newNull: COMTaskMemory elementClass: UnicodeString).
	self
		ReadPropertyNames: cpropid
		rgpropid: rgpropid
		rglpwstrName: answer.
	^answer asObject
!

ReadPropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName
	"Private - Invoke the ReadPropertyNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall ReadPropertyNames(
			[in] unsigned long cpropid,
			[in] unsigned long* rgpropid,
			[out] LPWSTR* rglpwstrName);
	"

	<virtual stdcall: hresult 7 dword dword* lpwstr*>
	^self invalidCall
!

revert  
	"Invoke the Revert() method of the COM Object."

	^self Revert
!

Revert 
	"Private - Invoke the Revert() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Revert();
	"

	<virtual stdcall: hresult 11>
	^self invalidCall
!

setClass: clsid 
	"Invoke the SetClass() method of the COM Object."

	^self
		SetClass: clsid
!

SetClass: clsid
	"Private - Invoke the SetClass() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetClass(
			[in] GUID* clsid);
	"

	<virtual stdcall: hresult 14 GUID*>
	^self invalidCall
!

setTimes: pctime patime: patime pmtime: pmtime 
	"Invoke the SetTimes() method of the COM Object."

	^self
		SetTimes: pctime
		patime: patime
		pmtime: pmtime
!

SetTimes: pctime patime: patime pmtime: pmtime
	"Private - Invoke the SetTimes() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetTimes(
			[in] FILETIME* pctime,
			[in] FILETIME* patime,
			[in] FILETIME* pmtime);
	"

	<virtual stdcall: hresult 13 FILETIME* FILETIME* FILETIME*>
	^self invalidCall
!

stat
	"Answer the <STATPROPSETSTG> result of invoking the COM Object's Stat() method."

	| answer |
	answer := (STATPROPSETSTG new).
	self
		Stat: answer.
	^answer asObject
!

Stat: pstatpsstg
	"Private - Invoke the Stat() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Stat(
			[out] STATPROPSETSTG* pstatpsstg);
	"

	<virtual stdcall: hresult 15 STATPROPSETSTG*>
	^self invalidCall
!

writeMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar propidNameFirst: propidNameFirst 
	"Invoke the WriteMultiple() method of the COM Object."

	^self
		WriteMultiple: cpspec
		rgpspec: rgpspec
		rgpropvar: rgpropvar asVariant
		propidNameFirst: propidNameFirst
!

WriteMultiple: cpspec rgpspec: rgpspec rgpropvar: rgpropvar propidNameFirst: propidNameFirst
	"Private - Invoke the WriteMultiple() method of the COM object wrapped by the receiver.

		HRESULT __stdcall WriteMultiple(
			[in] unsigned long cpspec,
			[in] PROPSPEC* rgpspec,
			[in] PROPVARIANT* rgpropvar,
			[in] unsigned long propidNameFirst);
	"

	<virtual stdcall: hresult 5 dword PROPSPEC* variant* dword>
	^self invalidCall
!

writePropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName 
	"Invoke the WritePropertyNames() method of the COM Object."

	^self
		WritePropertyNames: cpropid
		rgpropid: rgpropid
		rglpwstrName: rglpwstrName asUnicodeString
!

WritePropertyNames: cpropid rgpropid: rgpropid rglpwstrName: rglpwstrName
	"Private - Invoke the WritePropertyNames() method of the COM object wrapped by the receiver.

		HRESULT __stdcall WritePropertyNames(
			[in] unsigned long cpropid,
			[in] unsigned long* rgpropid,
			[in] LPWSTR* rglpwstrName);
	"

	<virtual stdcall: hresult 8 dword dword* lpwstr*>
	^self invalidCall
! !
!IPropertyStorage categoriesFor: #commit:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #Commit:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #deleteMultiple:rgpspec:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #DeleteMultiple:rgpspec:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #deletePropertyNames:rgpropid:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #DeletePropertyNames:rgpropid:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #directory!accessing!public! !
!IPropertyStorage categoriesFor: #enum!methods!public! !
!IPropertyStorage categoriesFor: #Enum:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #readMultiple:rgpspec:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #ReadMultiple:rgpspec:rgpropvar:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #readPropertyNames:rgpropid:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #ReadPropertyNames:rgpropid:rglpwstrName:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #revert!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #Revert!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #setClass:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #SetClass:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #setTimes:patime:pmtime:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #SetTimes:patime:pmtime:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #stat!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #Stat:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #writeMultiple:rgpspec:rgpropvar:propidNameFirst:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #WriteMultiple:rgpspec:rgpropvar:propidNameFirst:!**auto generated**!COM Interfaces-IPropertyStorage!private! !
!IPropertyStorage categoriesFor: #writePropertyNames:rgpropid:rglpwstrName:!**auto generated**!methods!public! !
!IPropertyStorage categoriesFor: #WritePropertyNames:rgpropid:rglpwstrName:!**auto generated**!COM Interfaces-IPropertyStorage!private! !

!IPropertyStorage class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IPropertyStorage'
		IPropertyStorage defineTemplate
	"

	self
		defineFunction: #ReadMultiple:rgpspec:rgpropvar:
			argumentTypes: 'dword PROPSPEC* variant*';
		defineFunction: #WriteMultiple:rgpspec:rgpropvar:propidNameFirst:
			argumentTypes: 'dword PROPSPEC* variant* dword';
		defineFunction: #DeleteMultiple:rgpspec:
			argumentTypes: 'dword PROPSPEC*';
		defineFunction: #ReadPropertyNames:rgpropid:rglpwstrName:
			argumentTypes: 'dword dword* lpwstr*';
		defineFunction: #WritePropertyNames:rgpropid:rglpwstrName:
			argumentTypes: 'dword dword* lpwstr*';
		defineFunction: #DeletePropertyNames:rgpropid:
			argumentTypes: 'dword dword*';
		defineFunction: #Commit:
			argumentTypes: 'dword';
		defineFunction: #Revert;
		defineFunction: #Enum:
			argumentTypes: 'void**';
		defineFunction: #SetTimes:patime:pmtime:
			argumentTypes: 'FILETIME* FILETIME* FILETIME*';
		defineFunction: #SetClass:
			argumentTypes: 'GUID*';
		defineFunction: #Stat:
			argumentTypes: 'STATPROPSETSTG*'
! !
!IPropertyStorage class categoriesFor: #defineFunctions!initializing!public! !

