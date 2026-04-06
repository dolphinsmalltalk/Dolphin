"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'OS.COM.RecordInfo'
	instanceVariableNames: 'recordClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.RecordInfo guid: (Core.GUID fromString: '{c3fe2744-4276-4c31-a7ea-ddbd87286f02}')!

OS.COM.RecordInfo comment: '`OS.COM.RecordInfo` is an implementation of the OLE Automation IRecordInfo interface for Dolphin `<externalStructure class>` objects, e.g. subclasses of `External.Structure`. It enables storing any class of structure into a `VARIANT` or `SAFEARRAY` by implementing methods of the interface to create, initialize, access, update, copy, and destroy ''records'' with the memory layout described by the structure.

## Instance Variables:
  `recordClass`		`<externalStructure class>`
'!

!OS.COM.RecordInfo methodsFor!

GetField: pvData szFieldName: szFieldName pvarField: pvarField
	"Implement the IRecordInfo::GetField() method for the UDT described by the receiver.

		HRESULT __stdcall GetField(
			[in] void* pvData,
			[in] LPWSTR szFieldName,
			[out] VARIANT* pvarField);

	"

	"[IRecordInfo::GetField method](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/nf-oaidl-irecordinfo-getfield) specifies that VariantClear is called on pvarField before copying, rather than just the normal VariantInit that one would expect for an output argument. Not sure if this is a documentation bug, or is correct, so do as instructed..."

	recordClass clear: pvarField yourAddress.
	pvarField value: ((recordClass fromAddress: pvData) getField: szFieldName
				ifAbsent: [^IRecordInfo.TYPE_E_FIELDNOTFOUND]).
	^S_OK!

GetFieldNames: pcNames rgBstrNames: rgBstrNames
	"Implement the IRecordInfo::GetFieldNames() method for the UDT described by the receiver.

		HRESULT __stdcall GetFieldNames(
			[in, out] unsigned long* pcNames,
			[out] BSTR* rgBstrNames);
	"

	| names |
	names := recordClass getFieldNames.
	rgBstrNames isNull
		ifTrue: [pcNames value: names size]
		ifFalse: 
			[| namesArray maxNames end |
			maxNames := pcNames value.
			"rgBstrNames will be an LPVOID holding the address of the buffer, which is a sufficiently sized array of BSTR pointers"
			namesArray := BSTRArray fromAddress: rgBstrNames yourAddress length: maxNames.
			end := names size min: maxNames.
			1 to: end do: [:i | namesArray at: i put: (names at: i)].
			end + 1 to: maxNames do: [:i | namesArray at: i put: 0].
			pcNames value: end].
	^S_OK!

GetFieldNoCopy: pvData szFieldName: szFieldName pvarField: pvarField ppvDataCArray: ppvDataCArray
	"Implement the IRecordInfo::GetFieldNoCopy() method for the UDT described by the receiver.

		HRESULT __stdcall GetFieldNoCopy(
			[in] void* pvData,
			[in] LPWSTR szFieldName,
			[out] VARIANT* pvarField,
			[out] void** ppvDataCArray);
	"

	^E_NOTIMPL
!

GetGuid: pguid
	"Implement the IRecordInfo::GetGuid() method for the UDT described by the receiver.

		HRESULT __stdcall GetGuid(
			[out] GUID* pguid);
	"

	pguid value: recordClass guid.
	^S_OK
!

GetName: pbstrName
	"Implement the IRecordInfo::GetName() method for the UDT described by the receiver,
	i.e. answer the name of the record class via the <BSTR>* output parameter.

		HRESULT __stdcall GetName(
			[out] BSTR* pbstrName);
	"

	pbstrName value: recordClass name asBSTR detach.
	^S_OK
!

GetSize: pcbSize
	"Implement the IRecordInfo::GetSize() method for the UDT described by the receiver.

		HRESULT __stdcall GetSize(
			[out] unsigned long* pcbSize);
	"
	
	pcbSize value: recordClass byteSize.
	^S_OK!

GetTypeInfo: ppTypeInfo
	"Implement the IRecordInfo::GetTypeInfo() method for the UDT described by the receiver.

		HRESULT __stdcall GetTypeInfo(
			[out] ITypeInfo** ppTypeInfo);
	"

	| ti |
	ppTypeInfo value: 0.
	ti := recordClass typeInfoIfNone: [^S_FALSE].
	ti addRef.
	ppTypeInfo value: ti yourAddress.
	^S_OK
!

IsMatchingType: pRecordInfo
	"Implement the IRecordInfo::IsMatchingType() method for the UDT described by the receiver.

		long __stdcall IsMatchingType(
			[in] IRecordInfo* pRecordInfo);
	"

	^(recordClass isMatchingType: pRecordInfo) asParameter!

PutField: wFlags pvData: pvData szFieldName: szFieldName pvarField: pvarField
	"Implement the IRecordInfo::PutField() method for the UDT described by the receiver.

		HRESULT __stdcall PutField(
			[in] unsigned long wFlags,
			[in, out] void* pvData,
			[in] LPWSTR szFieldName,
			[in] VARIANT* pvarField);
	"

	^
	[| refInst value fieldName |
	refInst := recordClass fromAddress: pvData.
	fieldName := szFieldName asSymbol.
	wFlags = IDispatch.INVOKE_PROPERTYPUT
		ifTrue: 
			[| fieldValue |
			fieldValue := refInst getField: fieldName
						ifAbsent: [HRESULTError signalWith: IRecordInfo.TYPE_E_FIELDNOTFOUND].
			value := pvarField isDispatch ifTrue: [pvarField dispatch value] ifFalse: [pvarField value].
			(fieldValue isKindOf: IDispatch)
				ifTrue: 
					[fieldValue isNull ifTrue: [HRESULTError signalWith: E_POINTER].
					fieldValue value: value]
				ifFalse: [refInst setField: fieldName value: value]]
		ifFalse: 
			[wFlags = IDispatch.INVOKE_PROPERTYPUTREF
				ifFalse: [InvalidArgumentError signalWith: 'wFlags'].
			value := pvarField value.
			refInst
				setField: fieldName
				value: value
				ifAbsent: [HRESULTError signalWith: IRecordInfo.TYPE_E_FIELDNOTFOUND]].
	S_OK]
"			on: MessageNotUnderstood
			do: [:ex | AutomationErrors.DISP_E_TYPEMISMATCH]"
			on: Error
			do: [:ex | ex hresult asInteger]!

PutFieldNoCopy: wFlags pvData: pvData szFieldName: szFieldName pvarField: pvarField
	"Implement the IRecordInfo::PutFieldNoCopy() method for the UDT described by the receiver.

		HRESULT __stdcall PutFieldNoCopy(
			[in] unsigned long wFlags,
			[in, out] void* pvData,
			[in] LPWSTR szFieldName,
			[in] VARIANT* pvarField);
	"

	^E_NOTIMPL
!

recordClass: aRecordClass
	recordClass := aRecordClass.
	^self!

RecordClear: pvExisting
	"Implement the IRecordInfo::RecordClear() method for the UDT described by the receiver.
	Clearing down a record involves freeing any of the fields that need to be finalized, it does not include releasing the memory owned by the record.

		HRESULT __stdcall RecordClear(
			[in] void* pvExisting);
	"

	recordClass clear: pvExisting.
	^S_OK
!

RecordCopy: pvExisting pvNew: pvNew
	"Implement IRecordInfo::RecordCopy() method for the UDT described by the receiver.
	Copy an existing area of memory occupied by a record of the receiver's type to a new location. Relies on a correct implementation of #copyBytes:from:to:into: in the record class, which must create an independent copy with separate copies of any owned resource such as references to owned sub-structures.

		HRESULT __stdcall RecordCopy(
			[in] void* pvExisting,
			[out] void* pvNew);
	"

	recordClass
		copyBytes: pvExisting
		from: 1
		to: recordClass byteSize
		into: pvNew.
	^S_OK!

RecordCreate
	"Implement the IRecordInfo::RecordCreate() method for the UDT described by the receiver
	Create a new record of the receiver's type in COM task memory.

		void* __stdcall RecordCreate();
	"

	"From [IRecordInfo::RecordCreate method](https://learn.microsoft.com/en-us/windows/win32/api/oaidl/nf-oaidl-irecordinfo-recordcreate)
		- The memory is set to zeros before it is returned.
		- The records created must be freed by calling RecordDestroy."

	| pRecord |
	pRecord := Ole32 coTaskMemAlloc: recordClass byteSize.
	pRecord isNull ifFalse: [self RecordInit: pRecord].
	^pRecord!

RecordCreateCopy: pvSource ppvDest: ppvDest
	"Implement the IRecordInfo::RecordCreate() method for the UDT described by the receiver

		HRESULT __stdcall RecordCreateCopy(
			[in] void* pvSource,
			[out] void** ppvDest);
	"

	| pv |
	pv := self RecordCreate.
	ppvDest value: pv.
	pv isNull ifTrue: [^E_OUTOFMEMORY].
	^self RecordCopy: pvSource pvNew: pv!

RecordDestroy: pvRecord
	"Implement the RecordDestroy() method for the UDT described by the receiver.
	Free up a record of the receiver's type previously created with RecordCreate().

		HRESULT __stdcall RecordDestroy(
			[in] void* pvRecord);
	"

	| hr |
	hr := self RecordClear: pvRecord.
	hr < 0 ifFalse: [Ole32 coTaskMemFree: pvRecord].
	^hr!

RecordInit: pvNew
	"Implement the IRecordInfo::RecordInit() method for the UDT described by the receiver.
	Initialize a new empty buffer for a record of the receiver's type.

		HRESULT __stdcall RecordInit(
			[out] void* pvNew);
	"

	recordClass init: pvNew.
	^S_OK!

server
	"Answer the server object on behalf of which the receiver is implementing an
	interface or interfaces. By default this is the receiver itself, but subclasses
	may implement interfaces on behalf of other objects in order that any particular
	server object can support any number of interfaces with different implementors."

	^recordClass!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^##({ IUnknown. IRecordInfo })! !

!OS.COM.RecordInfo categoriesForMethods!
GetField:szFieldName:pvarField:!COM Interfaces-IRecordInfo!public! !
GetFieldNames:rgBstrNames:!COM Interfaces-IRecordInfo!public! !
GetFieldNoCopy:szFieldName:pvarField:ppvDataCArray:!COM Interfaces-IRecordInfo!public! !
GetGuid:!COM Interfaces-IRecordInfo!public! !
GetName:!COM Interfaces-IRecordInfo!public! !
GetSize:!COM Interfaces-IRecordInfo!public! !
GetTypeInfo:!COM Interfaces-IRecordInfo!public! !
IsMatchingType:!COM Interfaces-IRecordInfo!public! !
PutField:pvData:szFieldName:pvarField:!COM Interfaces-IRecordInfo!public! !
PutFieldNoCopy:pvData:szFieldName:pvarField:!COM Interfaces-IRecordInfo!public! !
recordClass:!accessing!initializing!private! !
RecordClear:!COM Interfaces-IRecordInfo!public! !
RecordCopy:pvNew:!COM Interfaces-IRecordInfo!public! !
RecordCreate!COM Interfaces-IRecordInfo!public! !
RecordCreateCopy:ppvDest:!COM Interfaces-IRecordInfo!public! !
RecordDestroy:!COM Interfaces-IRecordInfo!public! !
RecordInit:!COM Interfaces-IRecordInfo!public! !
server!accessing!public! !
supportedInterfaces!constants!public! !
!

!OS.COM.RecordInfo class methodsFor!

recordClass: aRecordClass
	^self new recordClass: aRecordClass! !

!OS.COM.RecordInfo class categoriesForMethods!
recordClass:!instance creation!public! !
!

