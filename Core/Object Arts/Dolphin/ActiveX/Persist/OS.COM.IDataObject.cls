"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'OS.COM.IDataObject'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.IDataObject guid: (OS.COM.IID fromString: '{0000010e-0000-0000-c000-000000000046}')!
OS.COM.IDataObject comment: '`IDataObject` is a wrapper class for the COM interface ''OCIDL.IDataObject'' generated from type information in the ''OCIDL Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains no documentation for this interface

IDL definition follows:
```
[
	object, 
	uuid(0000010e-0000-0000-c000-000000000046)
]
interface IDataObject : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall GetData(
		[in]FORMATETC* pformatetcIn,
		[out]STGMEDIUM* pRemoteMedium);
	[id(0x60010001)]
	HRESULT __stdcall GetDataHere(
		[in]FORMATETC* pformatetc,
		[in, out]STGMEDIUM* pRemoteMedium);
	[id(0x60010002)]
	HRESULT __stdcall QueryGetData(
		[in]FORMATETC* pformatetc);
	[id(0x60010003)]
	HRESULT __stdcall GetCanonicalFormatEtc(
		[in]FORMATETC* pformatectIn,
		[out]FORMATETC* pformatetcOut);
	[id(0x60010004)]
	HRESULT __stdcall SetData(
		[in]FORMATETC* pformatetc,
		[in]STGMEDIUM* pmedium,
		[in]long fRelease);
	[id(0x60010005)]
	HRESULT __stdcall EnumFormatEtc(
		[in]unsigned long dwDirection,
		[out]IEnumFORMATETC** ppenumFormatEtc);
	[id(0x60010006)]
	HRESULT __stdcall DAdvise(
		[in]FORMATETC* pformatetc,
		[in]unsigned long advf,
		[in]IAdviseSink* pAdvSink,
		[out]unsigned long* pdwConnection);
	[id(0x60010007)]
	HRESULT __stdcall DUnadvise(
		[in]unsigned long dwConnection);
	[id(0x60010008)]
	HRESULT __stdcall EnumDAdvise(
		[out]IEnumSTATDATA** ppenumAdvise);
};
```
'!
!OS.COM.IDataObject categoriesForClass!OBJIDL-Interfaces! !
!OS.COM.IDataObject methodsFor!

dAdvise: pformatetc advf: advf pAdvSink: pAdvSink
	"Answer the <UInt32> result of invoking the DAdvise() method of the COM object."

	| answer |
	answer := UInt32 new.
	self
		DAdvise: pformatetc
		advf: advf
		pAdvSink: pAdvSink
		pdwConnection: answer.
	^answer asObject!

DAdvise: pformatetc advf: advf pAdvSink: pAdvSink pdwConnection: pdwConnection
	"Private - Invoke the DAdvise() method of the COM object.

		HRESULT __stdcall DAdvise(
			[in]FORMATETC* pformatetc,
			[in]unsigned long advf,
			[in]IAdviseSink* pAdvSink,
			[out]unsigned long* pdwConnection);"

	<virtual stdcall: hresult 10 FORMATETC* uint32 IAdviseSink* uint32*>
	^self invalidCall: _failureCode!

DUnadvise: dwConnection
	"Invoke the DUnadvise() method of the COM object.

		HRESULT __stdcall DUnadvise(
			[in]unsigned long dwConnection);"

	<virtual stdcall: hresult 11 uint32>
	^self invalidCall: _failureCode!

enumDAdvise
	"Answer the <IEnumSTATDATA> result of invoking the EnumDAdvise() method of the COM object."

	| answer |
	answer := IEnumStruct elementClass: STATDATA.
	self EnumDAdvise: answer.
	^answer!

EnumDAdvise: ppenumAdvise
	"Private - Invoke the EnumDAdvise() method of the COM object.

		HRESULT __stdcall EnumDAdvise(
			[out]IEnumSTATDATA** ppenumAdvise);"

	<virtual stdcall: hresult 12 Smalltalk.IUnknown**>
	^self invalidCall: _failureCode!

enumFormatEtc: dwDirection
	"Answer the <IEnumFORMATETC> result of invoking the EnumFormatEtc() method of the COM object."

	| answer |
	answer := IEnumStruct elementClass: FORMATETC.
	self EnumFormatEtc: dwDirection ppenumFormatEtc: answer.
	^answer asObject!

EnumFormatEtc: dwDirection ppenumFormatEtc: ppenumFormatEtc
	"Private - Invoke the EnumFormatEtc() method of the COM object.

		HRESULT __stdcall EnumFormatEtc(
			[in]unsigned long dwDirection,
			[out]IEnumFORMATETC** ppenumFormatEtc);"

	<virtual stdcall: hresult 9 uint32 Smalltalk.IUnknown**>
	^self invalidCall: _failureCode!

getCanonicalFormatEtc: pformatectIn
	"Answer the <FORMATETC> result of invoking the GetCanonicalFormatEtc() method of the COM object."

	| answer |
	answer := FORMATETC new.
	self GetCanonicalFormatEtc: pformatectIn pformatetcOut: answer.
	^answer asObject!

GetCanonicalFormatEtc: pformatectIn pformatetcOut: pformatetcOut
	"Private - Invoke the GetCanonicalFormatEtc() method of the COM object.

		HRESULT __stdcall GetCanonicalFormatEtc(
			[in]FORMATETC* pformatectIn,
			[out]FORMATETC* pformatetcOut);"

	<virtual stdcall: hresult 7 FORMATETC* FORMATETC*>
	^self invalidCall: _failureCode!

getData: pformatetcIn
	"Answer the <STGMEDIUM> result of invoking the GetData() method of the COM object."

	| answer |
	answer := STGMEDIUM new.
	self GetData: pformatetcIn pmedium: answer.
	^answer!

GetData: pformatetcIn pmedium: pRemoteMedium
	"Private - Invoke the GetData() method of the COM object.

		HRESULT __stdcall GetData(
			[in]FORMATETC* pformatetcIn,
			[out]STGMEDIUM* pmedium);"

	<virtual stdcall: hresult 4 FORMATETC* STGMEDIUM*>
	^self invalidCall: _failureCode!

getDataHere: pFormatetc pmedium: pMedium 
	"Answer the <STGMEDIUM> result of invoking the COM Object's GetDataHere() method."

	self
		GetDataHere: pFormatetc
		pmedium: pMedium.
	^pMedium
!

GetDataHere: pformatetc pmedium: pRemoteMedium
	"Private - Invoke the GetDataHere() method of the COM object.

		HRESULT __stdcall GetDataHere(
			[in]FORMATETC* pformatetc,
			[in, out]STGMEDIUM* pmedium);"

	<virtual stdcall: hresult 5 FORMATETC* STGMEDIUM*>
	^self invalidCall: _failureCode!

queryGetData: pFormatetc 
	"Answer whether data of the specified format is available."

	^(self QueryGetData: pFormatetc) == S_OK
!

QueryGetData: pformatetc
	"Invoke the QueryGetData() method of the COM object.

		HRESULT __stdcall QueryGetData(
			[in]FORMATETC* pformatetc);"

	<virtual stdcall: hresult 6 FORMATETC*>
	^self invalidCall: _failureCode!

SetData: pformatetc pmedium: pmedium fRelease: fRelease
	"Invoke the SetData() method of the COM object.

		HRESULT __stdcall SetData(
			[in]FORMATETC* pformatetc,
			[in]STGMEDIUM* pmedium,
			[in]long fRelease);"

	<virtual stdcall: hresult 8 FORMATETC* STGMEDIUM* int32>
	^self invalidCall: _failureCode! !
!OS.COM.IDataObject categoriesForMethods!
dAdvise:advf:pAdvSink:!**auto generated**!methods!public! !
DAdvise:advf:pAdvSink:pdwConnection:!**auto generated**!COM Interfaces-IDataObject!private! !
DUnadvise:!**auto generated**!COM Interfaces-IDataObject!public! !
enumDAdvise!methods!public! !
EnumDAdvise:!**auto generated**!COM Interfaces-IDataObject!private! !
enumFormatEtc:!methods!public! !
EnumFormatEtc:ppenumFormatEtc:!**auto generated**!COM Interfaces-IDataObject!private! !
getCanonicalFormatEtc:!**auto generated**!methods!public! !
GetCanonicalFormatEtc:pformatetcOut:!**auto generated**!COM Interfaces-IDataObject!private! !
getData:!methods!public! !
GetData:pmedium:!**auto generated**!COM Interfaces-IDataObject!private! !
getDataHere:pmedium:!methods!public! !
GetDataHere:pmedium:!**auto generated**!COM Interfaces-IDataObject!private! !
queryGetData:!methods!public! !
QueryGetData:!**auto generated**!COM Interfaces-IDataObject!public! !
SetData:pmedium:fRelease:!**auto generated**!COM Interfaces-IDataObject!public! !
!

!OS.COM.IDataObject class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'WebView2.IDataObject'
		IDataObject defineTemplate"

	self
		defineFunction: #GetData:pmedium: argumentTypes: 'FORMATETC* STGMEDIUM*';
		defineFunction: #GetDataHere:pmedium: argumentTypes: 'FORMATETC* STGMEDIUM*';
		defineFunction: #QueryGetData: argumentTypes: 'FORMATETC*';
		defineFunction: #GetCanonicalFormatEtc:pformatetcOut: argumentTypes: 'FORMATETC* FORMATETC*';
		defineFunction: #SetData:pmedium:fRelease: argumentTypes: 'FORMATETC* STGMEDIUM* int32';
		defineFunction: #EnumFormatEtc:ppenumFormatEtc: argumentTypes: 'uint32 IUnknown**';
		defineFunction: #DAdvise:advf:pAdvSink:pdwConnection:
			argumentTypes: 'FORMATETC* uint32 IAdviseSink* uint32*';
		defineFunction: #DUnadvise: argumentTypes: 'uint32';
		defineFunction: #EnumDAdvise: argumentTypes: 'IUnknown**'! !
!OS.COM.IDataObject class categoriesForMethods!
defineFunctions!initializing!public! !
!

