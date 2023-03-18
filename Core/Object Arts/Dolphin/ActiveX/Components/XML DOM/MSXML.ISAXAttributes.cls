"Filed out from Dolphin Smalltalk"!

OS.COM.IUnknown
	subclass: #'MSXML.ISAXAttributes'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.ISAXAttributes guid: (OS.COM.IID fromString: '{f078abe1-45d2-4832-91ea-4466ce2f25c9}')!
MSXML.ISAXAttributes comment: '<ISAXAttributes> is a wrapper class for the COM interface ''MSXML2.ISAXAttributes'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISAXAttributes interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(F078ABE1-45D2-4832-91EA-4466CE2F25C9), 
	helpstring("ISAXAttributes interface"), 
	hidden
]
interface ISAXAttributes : IUnknown
 {
	[id(0x60010000)]
	HRESULT __stdcall getLength(
		[out, retval]int* pnLength);
	[id(0x60010001)]
	HRESULT __stdcall getURI(
		[in]int nIndex,
		[out]unsigned short** ppwchUri,
		[out]int* pcchUri);
	[id(0x60010002)]
	HRESULT __stdcall getLocalName(
		[in]int nIndex,
		[out]unsigned short** ppwchLocalName,
		[out]int* pcchLocalName);
	[id(0x60010003)]
	HRESULT __stdcall getQName(
		[in]int nIndex,
		[out]unsigned short** ppwchQName,
		[out]int* pcchQName);
	[id(0x60010004)]
	HRESULT __stdcall getName(
		[in]int nIndex,
		[out]unsigned short** ppwchUri,
		[out]int* pcchUri,
		[out]unsigned short** ppwchLocalName,
		[out]int* pcchLocalName,
		[out]unsigned short** ppwchQName,
		[out]int* pcchQName);
	[id(0x60010005)]
	HRESULT __stdcall getIndexFromName(
		[in]unsigned short* pwchUri,
		[in]int cchUri,
		[in]unsigned short* pwchLocalName,
		[in]int cchLocalName,
		[out, retval]int* pnIndex);
	[id(0x60010006)]
	HRESULT __stdcall getIndexFromQName(
		[in]unsigned short* pwchQName,
		[in]int cchQName,
		[out, retval]int* pnIndex);
	[id(0x60010007)]
	HRESULT __stdcall getType(
		[in]int nIndex,
		[out]unsigned short** ppwchType,
		[out]int* pcchType);
	[id(0x60010008)]
	HRESULT __stdcall getTypeFromName(
		[in]unsigned short* pwchUri,
		[in]int cchUri,
		[in]unsigned short* pwchLocalName,
		[in]int cchLocalName,
		[out]unsigned short** ppwchType,
		[out]int* pcchType);
	[id(0x60010009)]
	HRESULT __stdcall getTypeFromQName(
		[in]unsigned short* pwchQName,
		[in]int cchQName,
		[out]unsigned short** ppwchType,
		[out]int* pcchType);
	[id(0x6001000a)]
	HRESULT __stdcall getValue(
		[in]int nIndex,
		[out]unsigned short** ppwchValue,
		[out]int* pcchValue);
	[id(0x6001000b)]
	HRESULT __stdcall getValueFromName(
		[in]unsigned short* pwchUri,
		[in]int cchUri,
		[in]unsigned short* pwchLocalName,
		[in]int cchLocalName,
		[out]unsigned short** ppwchValue,
		[out]int* pcchValue);
	[id(0x6001000c)]
	HRESULT __stdcall getValueFromQName(
		[in]unsigned short* pwchQName,
		[in]int cchQName,
		[out]unsigned short** ppwchValue,
		[out]int* pcchValue);
};
'!
!MSXML.ISAXAttributes categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.ISAXAttributes methodsFor!

getIndexFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName
	"Answer the <sdword> result of invoking the getIndexFromName() method of the COM object."

	| answer |
	answer := Int32 new.
	self
		GetIndexFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		pnIndex: answer.
	^answer asObject!

GetIndexFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName pnIndex: pnIndex
	"Private - Invoke the getIndexFromName() method of the COM object.

		HRESULT __stdcall getIndexFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out, retval]int* pnIndex);"

	<virtual stdcall: hresult 9 uint16* int32 uint16* int32 int32*>
	^self invalidCall: _failureCode!

getIndexFromQName: pwchQName cchQName: cchQName
	"Answer the <sdword> result of invoking the getIndexFromQName() method of the COM object."

	| answer |
	answer := Int32 new.
	self
		GetIndexFromQName: pwchQName
		cchQName: cchQName
		pnIndex: answer.
	^answer asObject!

GetIndexFromQName: pwchQName cchQName: cchQName pnIndex: pnIndex
	"Private - Invoke the getIndexFromQName() method of the COM object.

		HRESULT __stdcall getIndexFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out, retval]int* pnIndex);"

	<virtual stdcall: hresult 10 uint16* int32 int32*>
	^self invalidCall: _failureCode!

getLength
	"Answer the <sdword> result of invoking the getLength() method of the COM object."

	| answer |
	answer := Int32 new.
	self GetLength: answer.
	^answer asObject!

GetLength: pnLength
	"Private - Invoke the getLength() method of the COM object.

		HRESULT __stdcall getLength(
			[out, retval]int* pnLength);"

	<virtual stdcall: hresult 4 int32*>
	^self invalidCall: _failureCode!

getLocalName: nIndex
	"Invoke the getLocalName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetLocalName: nIndex
		ppwchLocalName: (outputs basicAt: 1)
		pcchLocalName: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetLocalName: nIndex ppwchLocalName: ppwchLocalName pcchLocalName: pcchLocalName
	"Private - Invoke the getLocalName() method of the COM object.

		HRESULT __stdcall getLocalName(
			[in]int nIndex,
			[out]unsigned short** ppwchLocalName,
			[out]int* pcchLocalName);"

	<virtual stdcall: hresult 6 int32 uint16** int32*>
	^self invalidCall: _failureCode!

getName: nIndex
	"Invoke the getName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory.
				Int32 new.
				UInt16 newBufferClass: TaskMemory.
				Int32 new.
				UInt16 newBufferClass: TaskMemory.
				Int32 new}.
	self
		GetName: nIndex
		ppwchUri: (outputs basicAt: 1)
		pcchUri: (outputs basicAt: 2)
		ppwchLocalName: (outputs basicAt: 3)
		pcchLocalName: (outputs basicAt: 4)
		ppwchQName: (outputs basicAt: 5)
		pcchQName: (outputs basicAt: 6).
	^outputs collect: [:each | each asObject]!

GetName: nIndex ppwchUri: ppwchUri pcchUri: pcchUri ppwchLocalName: ppwchLocalName pcchLocalName: pcchLocalName ppwchQName: ppwchQName pcchQName: pcchQName
	"Private - Invoke the getName() method of the COM object.

		HRESULT __stdcall getName(
			[in]int nIndex,
			[out]unsigned short** ppwchUri,
			[out]int* pcchUri,
			[out]unsigned short** ppwchLocalName,
			[out]int* pcchLocalName,
			[out]unsigned short** ppwchQName,
			[out]int* pcchQName);"

	<virtual stdcall: hresult 8 int32 uint16** int32* uint16** int32* uint16** int32*>
	^self invalidCall: _failureCode!

getQName: nIndex
	"Invoke the getQName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetQName: nIndex
		ppwchQName: (outputs basicAt: 1)
		pcchQName: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetQName: nIndex ppwchQName: ppwchQName pcchQName: pcchQName
	"Private - Invoke the getQName() method of the COM object.

		HRESULT __stdcall getQName(
			[in]int nIndex,
			[out]unsigned short** ppwchQName,
			[out]int* pcchQName);"

	<virtual stdcall: hresult 7 int32 uint16** int32*>
	^self invalidCall: _failureCode!

getType: nIndex
	"Invoke the getType() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetType: nIndex
		ppwchType: (outputs basicAt: 1)
		pcchType: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetType: nIndex ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getType() method of the COM object.

		HRESULT __stdcall getType(
			[in]int nIndex,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 11 int32 uint16** int32*>
	^self invalidCall: _failureCode!

getTypeFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName
	"Invoke the getTypeFromName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetTypeFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		ppwchType: (outputs basicAt: 1)
		pcchType: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetTypeFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getTypeFromName() method of the COM object.

		HRESULT __stdcall getTypeFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 12 uint16* int32 uint16* int32 uint16** int32*>
	^self invalidCall: _failureCode!

getTypeFromQName: pwchQName cchQName: cchQName
	"Invoke the getTypeFromQName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetTypeFromQName: pwchQName
		cchQName: cchQName
		ppwchType: (outputs basicAt: 1)
		pcchType: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetTypeFromQName: pwchQName cchQName: cchQName ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getTypeFromQName() method of the COM object.

		HRESULT __stdcall getTypeFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 13 uint16* int32 uint16** int32*>
	^self invalidCall: _failureCode!

getURI: nIndex
	"Invoke the getURI() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetURI: nIndex
		ppwchUri: (outputs basicAt: 1)
		pcchUri: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetURI: nIndex ppwchUri: ppwchUri pcchUri: pcchUri
	"Private - Invoke the getURI() method of the COM object.

		HRESULT __stdcall getURI(
			[in]int nIndex,
			[out]unsigned short** ppwchUri,
			[out]int* pcchUri);"

	<virtual stdcall: hresult 5 int32 uint16** int32*>
	^self invalidCall: _failureCode!

getValue: nIndex
	"Invoke the getValue() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetValue: nIndex
		ppwchValue: (outputs basicAt: 1)
		pcchValue: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetValue: nIndex ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValue() method of the COM object.

		HRESULT __stdcall getValue(
			[in]int nIndex,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 14 int32 uint16** int32*>
	^self invalidCall: _failureCode!

getValueFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName
	"Invoke the getValueFromName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetValueFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		ppwchValue: (outputs basicAt: 1)
		pcchValue: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetValueFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValueFromName() method of the COM object.

		HRESULT __stdcall getValueFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 15 uint16* int32 uint16* int32 uint16** int32*>
	^self invalidCall: _failureCode!

getValueFromQName: pwchQName cchQName: cchQName
	"Invoke the getValueFromQName() method of the COM object."

	| outputs |
	outputs := {UInt16 newBufferClass: TaskMemory. Int32 new}.
	self
		GetValueFromQName: pwchQName
		cchQName: cchQName
		ppwchValue: (outputs basicAt: 1)
		pcchValue: (outputs basicAt: 2).
	^outputs collect: [:each | each asObject]!

GetValueFromQName: pwchQName cchQName: cchQName ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValueFromQName() method of the COM object.

		HRESULT __stdcall getValueFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 16 uint16* int32 uint16** int32*>
	^self invalidCall: _failureCode! !
!MSXML.ISAXAttributes categoriesForMethods!
getIndexFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
GetIndexFromName:cchUri:pwchLocalName:cchLocalName:pnIndex:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getIndexFromQName:cchQName:!**auto generated**!methods!public! !
GetIndexFromQName:cchQName:pnIndex:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getLength!**auto generated**!methods!public! !
GetLength:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getLocalName:!**auto generated**!methods!public! !
GetLocalName:ppwchLocalName:pcchLocalName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getName:!**auto generated**!methods!public! !
GetName:ppwchUri:pcchUri:ppwchLocalName:pcchLocalName:ppwchQName:pcchQName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getQName:!**auto generated**!methods!public! !
GetQName:ppwchQName:pcchQName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getType:!**auto generated**!methods!public! !
GetType:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getTypeFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
GetTypeFromName:cchUri:pwchLocalName:cchLocalName:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getTypeFromQName:cchQName:!**auto generated**!methods!public! !
GetTypeFromQName:cchQName:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getURI:!**auto generated**!methods!public! !
GetURI:ppwchUri:pcchUri:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getValue:!**auto generated**!methods!public! !
GetValue:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getValueFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
GetValueFromName:cchUri:pwchLocalName:cchLocalName:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
getValueFromQName:cchQName:!**auto generated**!methods!public! !
GetValueFromQName:cchQName:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!

!MSXML.ISAXAttributes class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.ISAXAttributes'
		ISAXAttributes defineTemplate"

	self
		defineFunction: #GetLength:
			argumentTypes: 'sdword*';
		defineFunction: #GetURI:ppwchUri:pcchUri:
			argumentTypes: 'sdword word** sdword*';
		defineFunction: #GetLocalName:ppwchLocalName:pcchLocalName:
			argumentTypes: 'sdword word** sdword*';
		defineFunction: #GetQName:ppwchQName:pcchQName:
			argumentTypes: 'sdword word** sdword*';
		defineFunction: #GetName:ppwchUri:pcchUri:ppwchLocalName:pcchLocalName:ppwchQName:pcchQName:
			argumentTypes: 'sdword word** sdword* word** sdword* word** sdword*';
		defineFunction: #GetIndexFromName:cchUri:pwchLocalName:cchLocalName:pnIndex:
			argumentTypes: 'word* sdword word* sdword sdword*';
		defineFunction: #GetIndexFromQName:cchQName:pnIndex:
			argumentTypes: 'word* sdword sdword*';
		defineFunction: #GetType:ppwchType:pcchType:
			argumentTypes: 'sdword word** sdword*';
		defineFunction: #GetTypeFromName:cchUri:pwchLocalName:cchLocalName:ppwchType:pcchType:
			argumentTypes: 'word* sdword word* sdword word** sdword*';
		defineFunction: #GetTypeFromQName:cchQName:ppwchType:pcchType:
			argumentTypes: 'word* sdword word** sdword*';
		defineFunction: #GetValue:ppwchValue:pcchValue:
			argumentTypes: 'sdword word** sdword*';
		defineFunction: #GetValueFromName:cchUri:pwchLocalName:cchLocalName:ppwchValue:pcchValue:
			argumentTypes: 'word* sdword word* sdword word** sdword*';
		defineFunction: #GetValueFromQName:cchQName:ppwchValue:pcchValue:
			argumentTypes: 'word* sdword word** sdword*'
! !
!MSXML.ISAXAttributes class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

