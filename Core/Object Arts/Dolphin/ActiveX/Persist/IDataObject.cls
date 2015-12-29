"Filed out from Dolphin Smalltalk X6"!

IUnknown subclass: #IDataObject
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IDataObject guid: (IID fromString: '{0000010E-0000-0000-C000-000000000046}')!
IDataObject comment: '<IDataObject> is a wrapper class for the COM interface ''OCIDL.IDataObject'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

WARNING: This comment was automatically generated from the interface''s type information and any changes made here may be overwritten the next time this wrapper class is so generated.'!
!IDataObject categoriesForClass!COM-Interfaces! !
!IDataObject methodsFor!

dAdvise: pFormatetc advf: advf pAdvSink: pAdvSink 
	"Answer the <DWORD> result of invoking the COM Object's DAdvise() method."

	| answer |
	answer := (DWORD new).
	self
		DAdvise: pFormatetc
		advf: advf
		pAdvSink: pAdvSink
		pdwConnection: answer.
	^answer asObject
!

DAdvise: pFormatetc advf: advf pAdvSink: pAdvSink pdwConnection: pdwConnection
	"Private - Invoke the DAdvise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall DAdvise(
			[in] FORMATETC* pFormatetc,
			[in] unsigned long advf,
			[in] IAdviseSink* pAdvSink,
			[out] unsigned long* pdwConnection);
	"

	<virtual stdcall: hresult 10 FORMATETC* dword IAdviseSink* dword*>
	^self invalidCall
!

dUnadvise: dwConnection 
	"Invoke the DUnadvise() method of the COM Object."

	self
		DUnadvise: dwConnection
!

DUnadvise: dwConnection
	"Private - Invoke the DUnadvise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall DUnadvise(
			[in] unsigned long dwConnection);
	"

	<virtual stdcall: hresult 11 dword>
	^self invalidCall
!

enumDAdvise
	"Answer the <IEnumSTATDATA> result of invoking the COM Object's EnumDAdvise() method."

	| answer |
	answer := IEnumStruct elementClass: STATDATA.
	self EnumDAdvise: answer.
	^answer!

EnumDAdvise: ppenumAdvise
	"Private - Invoke the EnumDAdvise() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumDAdvise(
			[out] IEnumSTATDATA** ppenumAdvise);
	"

	<virtual stdcall: hresult 12 void**>
	^self invalidCall
!

enumFormatEtc: dwDirection 
	"Answer the <IEnumFORMATETC> result of invoking the COM Object's EnumFormatEtc() method."

	| answer |
	answer := IEnumStruct elementClass: FORMATETC.
	self EnumFormatEtc: dwDirection ppenumFormatEtc: answer.
	^answer asObject!

EnumFormatEtc: dwDirection ppenumFormatEtc: ppenumFormatEtc
	"Private - Invoke the EnumFormatEtc() method of the COM object wrapped by the receiver.

		HRESULT __stdcall EnumFormatEtc(
			[in] unsigned long dwDirection,
			[out] IEnumFORMATETC** ppenumFormatEtc);
	"

	<virtual stdcall: hresult 9 dword void**>
	^self invalidCall
!

getCanonicalFormatEtc: pformatectIn 
	"Answer the <FORMATETC> result of invoking the COM Object's GetCanonicalFormatEtc() method."

	| answer |
	answer := (FORMATETC new).
	self
		GetCanonicalFormatEtc: pformatectIn
		pformatetcOut: answer.
	^answer asObject
!

GetCanonicalFormatEtc: pformatectIn pformatetcOut: pformatetcOut
	"Private - Invoke the GetCanonicalFormatEtc() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetCanonicalFormatEtc(
			[in] FORMATETC* pformatectIn,
			[out] FORMATETC* pformatetcOut);
	"

	<virtual stdcall: hresult 7 FORMATETC* FORMATETC*>
	^self invalidCall
!

getData: pFormatetc
	"Answer the <STGMEDIUM> result of invoking the COM Object's GetDataHere() method."

	| answer |
	answer := STGMEDIUM new.
	self
		GetData: pFormatetc
		pmedium: answer.
	^answer
!

GetData: pformatetcIn pmedium: pMedium
	"Private - Invoke the GetData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetData(
			[in] FORMATETC* pformatetcIn,
			[out]STGMEDIUM* pmedium);
	"

	<virtual stdcall: hresult 4 FORMATETC* STGMEDIUM*>
	^self invalidCall
!

getDataHere: pFormatetc pmedium: pMedium 
	"Answer the <STGMEDIUM> result of invoking the COM Object's GetDataHere() method."

	self
		GetDataHere: pFormatetc
		pmedium: pMedium.
	^pMedium
!

GetDataHere: pFormatetc pmedium: pMedium
	"Private - Invoke the GetDataHere() method of the COM object wrapped by the receiver.

		HRESULT __stdcall GetDataHere(
			[in] FORMATETC* pFormatetc,
			[in, out] wireSTGMEDIUM* pMedium);
	"

	<virtual stdcall: hresult 5 FORMATETC* STGMEDIUM*>
	^self invalidCall
!

queryGetData: pFormatetc 
	"Answer whether data of the specified format is available."

	^(self QueryGetData: pFormatetc) == S_OK
!

QueryGetData: pFormatetc
	"Private - Invoke the QueryGetData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall QueryGetData(
			[in] FORMATETC* pFormatetc);
	"

	<virtual stdcall: hresult 6 FORMATETC*>
	^self invalidCall
!

setData: pFormatetc pmedium: pmedium fRelease: fRelease 
	"Invoke the SetData() method of the COM Object."

	self
		SetData: pFormatetc
		pmedium: pmedium
		fRelease: fRelease asParameter
!

SetData: pFormatetc pmedium: pmedium fRelease: fRelease
	"Private - Invoke the SetData() method of the COM object wrapped by the receiver.

		HRESULT __stdcall SetData(
			[in] FORMATETC* pFormatetc,
			[in] STGMEDIUM* pmedium,
			[in] long fRelease);
	"

	<virtual stdcall: hresult 8 FORMATETC* STGMEDIUM* sdword>
	^self invalidCall
! !
!IDataObject categoriesFor: #dAdvise:advf:pAdvSink:!**auto generated**!methods!public! !
!IDataObject categoriesFor: #DAdvise:advf:pAdvSink:pdwConnection:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #dUnadvise:!**auto generated**!methods!public! !
!IDataObject categoriesFor: #DUnadvise:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #enumDAdvise!methods!public! !
!IDataObject categoriesFor: #EnumDAdvise:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #enumFormatEtc:!methods!public! !
!IDataObject categoriesFor: #EnumFormatEtc:ppenumFormatEtc:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #getCanonicalFormatEtc:!**auto generated**!methods!public! !
!IDataObject categoriesFor: #GetCanonicalFormatEtc:pformatetcOut:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #getData:!methods!public! !
!IDataObject categoriesFor: #GetData:pmedium:!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #getDataHere:pmedium:!methods!public! !
!IDataObject categoriesFor: #GetDataHere:pmedium:!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #queryGetData:!methods!public! !
!IDataObject categoriesFor: #QueryGetData:!**auto generated**!COM Interfaces-IDataObject!private! !
!IDataObject categoriesFor: #setData:pmedium:fRelease:!methods!public! !
!IDataObject categoriesFor: #SetData:pmedium:fRelease:!COM Interfaces-IDataObject!private! !

!IDataObject class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'OCIDL.IDataObject'
		IDataObject defineTemplate
	"

	self
		defineFunction: #GetData:pmedium:
			argumentTypes: 'FORMATETC* STGMEDIUM*';
		defineFunction: #GetDataHere:pmedium:
			argumentTypes: 'FORMATETC* STGMEDIUM*';
		defineFunction: #QueryGetData:
			argumentTypes: 'FORMATETC*';
		defineFunction: #GetCanonicalFormatEtc:pformatetcOut:
			argumentTypes: 'FORMATETC* FORMATETC*';
		defineFunction: #SetData:pmedium:fRelease:
			argumentTypes: 'FORMATETC* STGMEDIUM** sdword';
		defineFunction: #EnumFormatEtc:ppenumFormatEtc:
			argumentTypes: 'dword void**';
		defineFunction: #DAdvise:advf:pAdvSink:pdwConnection:
			argumentTypes: 'FORMATETC* dword IAdviseSink* dword*';
		defineFunction: #DUnadvise:
			argumentTypes: 'dword';
		defineFunction: #EnumDAdvise:
			argumentTypes: 'void**'
! !
!IDataObject class categoriesFor: #defineFunctions!initializing!public! !

