"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IPropertySetStorage'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.StorageConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPropertySetStorage guid: (OS.COM.IID fromString: '{0000013a-0000-0000-c000-000000000046}')!

OS.COM.IPropertySetStorage comment: '<IPropertySetStorage> is a wrapper class for the COM interface ''OBJIDL.IPropertySetStorage'' generated from type information in the ''ObjIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(0000013A-0000-0000-C000-000000000046)
]
interface IPropertySetStorage : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall Create(
		[in] GUID* rfmtid,
		[in] GUID* pClsid,
		[in] unsigned long grfFlags,
		[in] unsigned long grfMode,
		[out] IPropertyStorage** ppprstg);
	[id(0x60010001)]
	HRESULT __stdcall Open(
		[in] GUID* rfmtid,
		[in] unsigned long grfMode,
		[out] IPropertyStorage** ppprstg);
	[id(0x60010002)]
	HRESULT __stdcall Delete(
		[in] GUID* rfmtid);
	[id(0x60010003)]
	HRESULT __stdcall Enum(
		[out] IEnumSTATPROPSETSTG** ppenum);
};
'!

!OS.COM.IPropertySetStorage categoriesForClass!COM-Interfaces!OBJIDL-Interfaces! !

!OS.COM.IPropertySetStorage methodsFor!

create: rfmtid pClsid: pClsid grfFlags: grfFlags grfMode: grfMode 
	"Answer the <IPropertyStorage> result of invoking the COM Object's Create() method."

	| answer |
	answer := IPropertyStorage newPointer.
	self
		Create: rfmtid
		pClsid: pClsid
		grfFlags: grfFlags
		grfMode: grfMode
		ppprstg: answer.
	^answer asObject
!

Create: rfmtid pClsid: pClsid grfFlags: grfFlags grfMode: grfMode ppprstg: ppprstg
	"Private - Invoke the Create() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Create(
			[in] GUID* rfmtid,
			[in] GUID* pClsid,
			[in] unsigned long grfFlags,
			[in] unsigned long grfMode,
			[out] IPropertyStorage** ppprstg);
	"

	<virtual stdcall: hresult 4 GUID* GUID* dword dword IPropertyStorage**>
	^self invalidCall
!

delete: rfmtid 
	"Invoke the Delete() method of the COM Object."

	^self
		Delete: rfmtid
!

Delete: rfmtid
	"Private - Invoke the Delete() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Delete(
			[in] GUID* rfmtid);
	"

	<virtual stdcall: hresult 6 GUID*>
	^self invalidCall
!

directory
	"Answer a <sequencedReadableCollection> of <STATPROPSETSTG> structures describing the
	elements of the receiver."

	^Enumerable onIEnum: self enum!

enum
	"Answer the <IEnumSTATPROPSETSTG> result of invoking the COM Object's Enum() method."

	| answer |
	answer := IEnumStruct elementClass: STATPROPSETSTG.
	self Enum: answer.
	^answer!

Enum: ppenum
	"Private - Invoke the Enum() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Enum(
			[out] IEnumSTATPROPSETSTG** ppenum);
	"

	<virtual stdcall: hresult 7 void**>
	^self invalidCall
!

open: aGUID
	"Open the property storage within the receiver identified by the <GUID> argument."

	^self open: aGUID grfMode: STGM_READ | STGM_SHARE_EXCLUSIVE!

open: rfmtid grfMode: grfMode 
	"Answer the <IPropertyStorage> result of invoking the COM Object's Open() method."

	| answer |
	answer := IPropertyStorage newPointer.
	self
		Open: rfmtid
		grfMode: grfMode
		ppprstg: answer.
	^answer asObject
!

Open: rfmtid grfMode: grfMode ppprstg: ppprstg
	"Private - Invoke the Open() method of the COM object wrapped by the receiver.

		HRESULT __stdcall Open(
			[in] GUID* rfmtid,
			[in] unsigned long grfMode,
			[out] IPropertyStorage** ppprstg);
	"

	<virtual stdcall: hresult 5 GUID* dword IPropertyStorage**>
	^self invalidCall
! !

!OS.COM.IPropertySetStorage categoriesForMethods!
create:pClsid:grfFlags:grfMode:!**auto generated**!methods!public! !
Create:pClsid:grfFlags:grfMode:ppprstg:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
delete:!**auto generated**!methods!public! !
Delete:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
directory!accessing!public! !
enum!methods!public! !
Enum:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
open:!**auto generated**!methods!public! !
open:grfMode:!**auto generated**!methods!public! !
Open:grfMode:ppprstg:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
!

!OS.COM.IPropertySetStorage class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OBJIDL.IPropertySetStorage'
		IPropertySetStorage defineTemplate
	"

	self
		defineFunction: #Create:pClsid:grfFlags:grfMode:ppprstg:
			argumentTypes: 'GUID* GUID* dword dword IPropertyStorage**';
		defineFunction: #Open:grfMode:ppprstg:
			argumentTypes: 'GUID* dword IPropertyStorage**';
		defineFunction: #Delete:
			argumentTypes: 'GUID*';
		defineFunction: #Enum:
			argumentTypes: 'void**'
! !

!OS.COM.IPropertySetStorage class categoriesForMethods!
defineFunctions!initializing!public! !
!

