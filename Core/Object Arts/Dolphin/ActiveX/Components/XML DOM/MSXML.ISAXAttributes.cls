"Filed out from Dolphin Smalltalk 7"!

OS.COM.IUnknown subclass: #'MSXML.ISAXAttributes'
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
	"Answer the <SDWORD> result of invoking the getIndexFromName() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		GetIndexFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		pnIndex: answer.
	^answer asObject
!

GetIndexFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName pnIndex: pnIndex
	"Private - Invoke the getIndexFromName() method of the COM object.

		HRESULT __stdcall getIndexFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out, retval]int* pnIndex);"

	<virtual stdcall: hresult 9 word* sdword word* sdword sdword*>
	^self invalidCall: _failureCode!

getIndexFromQName: pwchQName cchQName: cchQName
	"Answer the <SDWORD> result of invoking the getIndexFromQName() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self
		GetIndexFromQName: pwchQName
		cchQName: cchQName
		pnIndex: answer.
	^answer asObject
!

GetIndexFromQName: pwchQName cchQName: cchQName pnIndex: pnIndex
	"Private - Invoke the getIndexFromQName() method of the COM object.

		HRESULT __stdcall getIndexFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out, retval]int* pnIndex);"

	<virtual stdcall: hresult 10 word* sdword sdword*>
	^self invalidCall: _failureCode!

getLength
	"Answer the <SDWORD> result of invoking the getLength() method of the COM object."

	| answer |
	answer := (SDWORD new).
	self GetLength: answer.
	^answer asObject
!

GetLength: pnLength
	"Private - Invoke the getLength() method of the COM object.

		HRESULT __stdcall getLength(
			[out, retval]int* pnLength);"

	<virtual stdcall: hresult 4 sdword*>
	^self invalidCall: _failureCode!

getLocalName: nIndex
	"Invoke the getLocalName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetLocalName: nIndex
		ppwchLocalName: (answer basicAt: 1)
		pcchLocalName: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetLocalName: nIndex ppwchLocalName: ppwchLocalName pcchLocalName: pcchLocalName
	"Private - Invoke the getLocalName() method of the COM object.

		HRESULT __stdcall getLocalName(
			[in]int nIndex,
			[out]unsigned short** ppwchLocalName,
			[out]int* pcchLocalName);"

	<virtual stdcall: hresult 6 sdword word** sdword*>
	^self invalidCall: _failureCode!

getName: nIndex
	"Invoke the getName() method of the COM object."

	| answer |
	answer := (Array new: 6)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				basicAt: 3 put: (WORD newBufferClass: TaskMemory);
				basicAt: 4 put: (SDWORD new);
				basicAt: 5 put: (WORD newBufferClass: TaskMemory);
				basicAt: 6 put: (SDWORD new);
				yourself.
	self
		GetName: nIndex
		ppwchUri: (answer basicAt: 1)
		pcchUri: (answer basicAt: 2)
		ppwchLocalName: (answer basicAt: 3)
		pcchLocalName: (answer basicAt: 4)
		ppwchQName: (answer basicAt: 5)
		pcchQName: (answer basicAt: 6).
	^answer collect: [:each | each asObject]
!

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

	<virtual stdcall: hresult 8 sdword word** sdword* word** sdword* word** sdword*>
	^self invalidCall: _failureCode!

getQName: nIndex
	"Invoke the getQName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetQName: nIndex
		ppwchQName: (answer basicAt: 1)
		pcchQName: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetQName: nIndex ppwchQName: ppwchQName pcchQName: pcchQName
	"Private - Invoke the getQName() method of the COM object.

		HRESULT __stdcall getQName(
			[in]int nIndex,
			[out]unsigned short** ppwchQName,
			[out]int* pcchQName);"

	<virtual stdcall: hresult 7 sdword word** sdword*>
	^self invalidCall: _failureCode!

getType: nIndex
	"Invoke the getType() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetType: nIndex
		ppwchType: (answer basicAt: 1)
		pcchType: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetType: nIndex ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getType() method of the COM object.

		HRESULT __stdcall getType(
			[in]int nIndex,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 11 sdword word** sdword*>
	^self invalidCall: _failureCode!

getTypeFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName
	"Invoke the getTypeFromName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetTypeFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		ppwchType: (answer basicAt: 1)
		pcchType: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetTypeFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getTypeFromName() method of the COM object.

		HRESULT __stdcall getTypeFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 12 word* sdword word* sdword word** sdword*>
	^self invalidCall: _failureCode!

getTypeFromQName: pwchQName cchQName: cchQName
	"Invoke the getTypeFromQName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetTypeFromQName: pwchQName
		cchQName: cchQName
		ppwchType: (answer basicAt: 1)
		pcchType: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetTypeFromQName: pwchQName cchQName: cchQName ppwchType: ppwchType pcchType: pcchType
	"Private - Invoke the getTypeFromQName() method of the COM object.

		HRESULT __stdcall getTypeFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out]unsigned short** ppwchType,
			[out]int* pcchType);"

	<virtual stdcall: hresult 13 word* sdword word** sdword*>
	^self invalidCall: _failureCode!

getURI: nIndex
	"Invoke the getURI() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetURI: nIndex
		ppwchUri: (answer basicAt: 1)
		pcchUri: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetURI: nIndex ppwchUri: ppwchUri pcchUri: pcchUri
	"Private - Invoke the getURI() method of the COM object.

		HRESULT __stdcall getURI(
			[in]int nIndex,
			[out]unsigned short** ppwchUri,
			[out]int* pcchUri);"

	<virtual stdcall: hresult 5 sdword word** sdword*>
	^self invalidCall: _failureCode!

getValue: nIndex
	"Invoke the getValue() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetValue: nIndex
		ppwchValue: (answer basicAt: 1)
		pcchValue: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetValue: nIndex ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValue() method of the COM object.

		HRESULT __stdcall getValue(
			[in]int nIndex,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 14 sdword word** sdword*>
	^self invalidCall: _failureCode!

getValueFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName
	"Invoke the getValueFromName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetValueFromName: pwchUri
		cchUri: cchUri
		pwchLocalName: pwchLocalName
		cchLocalName: cchLocalName
		ppwchValue: (answer basicAt: 1)
		pcchValue: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetValueFromName: pwchUri cchUri: cchUri pwchLocalName: pwchLocalName cchLocalName: cchLocalName ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValueFromName() method of the COM object.

		HRESULT __stdcall getValueFromName(
			[in]unsigned short* pwchUri,
			[in]int cchUri,
			[in]unsigned short* pwchLocalName,
			[in]int cchLocalName,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 15 word* sdword word* sdword word** sdword*>
	^self invalidCall: _failureCode!

getValueFromQName: pwchQName cchQName: cchQName
	"Invoke the getValueFromQName() method of the COM object."

	| answer |
	answer := (Array new: 2)
				basicAt: 1 put: (WORD newBufferClass: TaskMemory);
				basicAt: 2 put: (SDWORD new);
				yourself.
	self
		GetValueFromQName: pwchQName
		cchQName: cchQName
		ppwchValue: (answer basicAt: 1)
		pcchValue: (answer basicAt: 2).
	^answer collect: [:each | each asObject]
!

GetValueFromQName: pwchQName cchQName: cchQName ppwchValue: ppwchValue pcchValue: pcchValue
	"Private - Invoke the getValueFromQName() method of the COM object.

		HRESULT __stdcall getValueFromQName(
			[in]unsigned short* pwchQName,
			[in]int cchQName,
			[out]unsigned short** ppwchValue,
			[out]int* pcchValue);"

	<virtual stdcall: hresult 16 word* sdword word** sdword*>
	^self invalidCall: _failureCode! !
!MSXML.ISAXAttributes categoriesFor: #getIndexFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetIndexFromName:cchUri:pwchLocalName:cchLocalName:pnIndex:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getIndexFromQName:cchQName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetIndexFromQName:cchQName:pnIndex:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getLength!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetLength:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getLocalName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetLocalName:ppwchLocalName:pcchLocalName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetName:ppwchUri:pcchUri:ppwchLocalName:pcchLocalName:ppwchQName:pcchQName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getQName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetQName:ppwchQName:pcchQName:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getType:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetType:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getTypeFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetTypeFromName:cchUri:pwchLocalName:cchLocalName:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getTypeFromQName:cchQName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetTypeFromQName:cchQName:ppwchType:pcchType:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getURI:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetURI:ppwchUri:pcchUri:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getValue:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetValue:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getValueFromName:cchUri:pwchLocalName:cchLocalName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetValueFromName:cchUri:pwchLocalName:cchLocalName:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !
!MSXML.ISAXAttributes categoriesFor: #getValueFromQName:cchQName:!**auto generated**!methods!public! !
!MSXML.ISAXAttributes categoriesFor: #GetValueFromQName:cchQName:ppwchValue:pcchValue:!**auto generated**!COM Interfaces-ISAXAttributes!private! !

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
!MSXML.ISAXAttributes class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

