"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IPropertySetStorage'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.STATSTG private})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.IPropertySetStorage guid: (OS.COM.IID fromString: '{0000013a-0000-0000-c000-000000000046}')!

OS.COM.IPropertySetStorage comment: '`IPropertySetStorage` is a wrapper class for the COM Property Storage interface of the same name.

IDL definition follows:
```
[
	object, 
	uuid(0000013a-0000-0000-c000-000000000046)
]
interface IPropertySetStorage : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall Create(
		[in]GUID* rfmtid,
		[in]GUID* pclsid,
		[in]DWORD grfFlags,
		[in]DWORD grfMode,
		[out]IPropertyStorage** ppprstg);
	[id(0x60010001)]
	HRESULT __stdcall Open(
		[in]GUID* rfmtid,
		[in]DWORD grfMode,
		[out]IPropertyStorage** ppprstg);
	[id(0x60010002)]
	HRESULT __stdcall Delete(
		[in]GUID* rfmtid);
	[id(0x60010003)]
	HRESULT __stdcall Enum(
		[out]IEnumSTATPROPSETSTG** ppenum);
};
```
'!

!OS.COM.IPropertySetStorage categoriesForClass!COM-Interfaces!Win32-Interfaces! !

!OS.COM.IPropertySetStorage methodsFor!

create: rfmtid pclsid: pclsid grfFlags: grfFlags grfMode: grfMode
	"Answer the <IPropertyStorage> result of invoking the Create() method of the COM object."

	| answer |
	answer := IPropertyStorage newPointer.
	self
		Create: rfmtid
		pclsid: pclsid
		grfFlags: grfFlags
		grfMode: grfMode
		ppprstg: answer.
	^answer asObject!

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

Create: rfmtid pclsid: pclsid grfFlags: grfFlags grfMode: grfMode ppprstg: ppprstg
	"Private - Invoke the Create() method of the COM object.

		HRESULT __stdcall Create(
			[in]GUID* rfmtid,
			[in]GUID* pclsid,
			[in]DWORD grfFlags,
			[in]DWORD grfMode,
			[out]IPropertyStorage** ppprstg);"

	<virtual stdcall: hresult 4 guid* guid* uint32 uint32 IPropertyStorage**>
	^self invalidCall: _failureCode!

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
	"Invoke the Delete() method of the COM object."

	^self Delete: rfmtid!

Delete: rfmtid
	"Private - Invoke the Delete() method of the COM object.

		HRESULT __stdcall Delete(
			[in]GUID* rfmtid);"

	<virtual stdcall: hresult 6 guid*>
	^self invalidCall: _failureCode!

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
	"Private - Invoke the Enum() method of the COM object.

		HRESULT __stdcall Enum(
			[out]IEnumSTATPROPSETSTG** ppenum);"

	<virtual stdcall: hresult 7 IEnumStruct**>
	^self invalidCall: _failureCode!

open: aGUID
	"Open the property storage within the receiver identified by the <GUID> argument."

	^self open: aGUID grfMode: STGM_READ | STGM_SHARE_EXCLUSIVE!

open: rfmtid grfMode: grfMode
	"Answer the <IPropertyStorage> result of invoking the Open() method of the COM object."

	| answer |
	answer := IPropertyStorage newPointer.
	self
		Open: rfmtid
		grfMode: grfMode
		ppprstg: answer.
	^answer asObject!

Open: rfmtid grfMode: grfMode ppprstg: ppprstg
	"Private - Invoke the Open() method of the COM object.

		HRESULT __stdcall Open(
			[in]GUID* rfmtid,
			[in]DWORD grfMode,
			[out]IPropertyStorage** ppprstg);"

	<virtual stdcall: hresult 5 guid* uint32 IPropertyStorage**>
	^self invalidCall: _failureCode! !

!OS.COM.IPropertySetStorage categoriesForMethods!
create:pclsid:grfFlags:grfMode:!**auto generated**!methods!public! !
create:pClsid:grfFlags:grfMode:!**auto generated**!methods!public! !
Create:pclsid:grfFlags:grfMode:ppprstg:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
Create:pClsid:grfFlags:grfMode:ppprstg:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
delete:!**auto generated**!methods!public! !
Delete:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
directory!accessing!public! !
enum!methods!public! !
Enum:!COM Interfaces-IPropertySetStorage!private! !
open:!**auto generated**!methods!public! !
open:grfMode:!**auto generated**!methods!public! !
Open:grfMode:ppprstg:!**auto generated**!COM Interfaces-IPropertySetStorage!private! !
!

!OS.COM.IPropertySetStorage class methodsFor!

create: fileName 
	"Answer an instance of the receiver on a new DocFile with the specified
	name and the default access mode."

	^self create: fileName mode: self defaultCreateMode!

create: fileName mode: stgMode
	"Answer an instance of the receiver on a new compound file with the specified
	name. The access mode of the answered IStorage is as specified in the stgMode
	argument."

	| answer |
	answer := self newPointer.
	Ole32
		stgCreateDocfile: fileName asUtf16String
		grfMode: stgMode
		reserved: 0
		ppstgOpen: answer.
	^answer

	"STGM_FAILIFTHERE is 0, and therefore has no effect!! STGM_CREATE must be specified in order to overwrite
	an existing file. If not, creation will only complete if the file does not exist."!

createOn: anIStorage
	"Answer an instance of the receiver created on the specified IStorage object."

	| answer |
	answer := self newPointer.
	Ole32
		stgCreatePropSetStg: anIStorage
		dwReserved: 0
		ppPropSetStg: answer.
	^answer!

defaultCreateMode
	"Answer the default access mode for a newly created storage."

	^##(STGM_CREATE | STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

defaultOpenMode
	"Answer the default access mode for a opening an existing storage."

	^##(STGM_READWRITE | STGM_SHARE_EXCLUSIVE)!

defineFunctions
	"Declare the virtual function table for the COM interface 'IPropertySetStorage'
		IPropertySetStorage defineTemplate"

	self
		defineFunction: #Create:pclsid:grfFlags:grfMode:ppprstg:
			argumentTypes: 'GUID* GUID* uint32 uint32 IPropertyStorage**';
		defineFunction: #Open:grfMode:ppprstg:
			argumentTypes: 'GUID* uint32 IPropertyStorage**';
		defineFunction: #Delete:
			argumentTypes: 'GUID*';
		defineFunction: #Enum:
			argumentTypes: 'IEnumStruct**'
!

open: pathName 
	"Open the specified compound document file, and answer an instance of the receiver for
	accessing it. The compound file is opened in the default mode, read/write, write exclusive,
	transacted."

	^self open: pathName mode: self defaultOpenMode	" ##(STGM_TRANSACTED | STGM_READWRITE | STGM_SHARE_DENY_WRITE)"!

open: pathName mode: stgMode
	"Open the specified compound document file, and answer an instance of the receiver for
	accessing it. The compound file is opened in the specified mode which is a combination
	of the following flags:

		STGM_READ 				- Request read access (default)
		STGM_WRITE				- Request write access. Allows changes to be committed
							  	(i.e. read-only storages can be written too if transacted, but commit will fail)
		STGM_READWRITE 			- Request read and write access
		STGM_SHARE_DENY_NONE 	- No locking
		STGM_SHARE_DENY_READ 	- Read lock
		STGM_SHARE_DENY_WRITE 	- Write lock  
  		STGM_SHARE_EXCLUSIVE 	- Exclusive lock
		STGM_DIRECT 			- Not transacted, changes written immediately, no rollback (default)
		STGM_TRANSACTED 		- Transacted, can be rolled back, must be committed
		STGM_CREATE			- Create if not found
		STGM_CONVERT			- Convert if not a compound document file
		STGM_FAILIFTHERE		- Do not overwrite existing storages/streams when creating (default)
							  	Specify STGM_CREATE as the alternative (but only with create methods).
		STGM_PRIORITY			- High performance, unsociable, read-only access mode 
		STGM_DELETEONRELEASE	- Deletes the storage when released (e.g. for temporary storages)"

	| answer |
	answer := self newPointer.
	Ole32
		stgOpenStorage: pathName asUtf16String
		pstgPriority: nil
		grfMode: stgMode
		snbExclude: nil
		reserved: 0
		ppstgOpen: answer.
	^answer!

openOn: anIStorageOrStream format: aGUID flags: anInteger
	"Answer an instance of the receiver opened on the specified storage object."

	| answer |
	answer := self newPointer.
	Ole32
		stgOpenPropStg: anIStorageOrStream
		fmtid: aGUID
		grfFlags: anInteger
		dwReserved: 0
		ppPropStg: answer.
	^answer! !

!OS.COM.IPropertySetStorage class categoriesForMethods!
create:!instance creation!public! !
create:mode:!instance creation!public! !
createOn:!instance creation!public! !
defaultCreateMode!constants!public! !
defaultOpenMode!constants!public! !
defineFunctions!initializing!public!template definition! !
open:!instance creation!public! !
open:mode:!instance creation!public! !
openOn:format:flags:!instance creation!public! !
!

