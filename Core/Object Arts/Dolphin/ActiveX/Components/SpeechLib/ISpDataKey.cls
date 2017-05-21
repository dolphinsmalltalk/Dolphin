"Filed out from Dolphin Smalltalk 7"!

IUnknown subclass: #ISpDataKey
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpDataKey guid: (IID fromString: '{14056581-E16C-11D2-BB90-00C04F8EE6C0}')!
ISpDataKey comment: '<ISpDataKey> is a wrapper class for the COM interface ''SpeechLib.ISpDataKey'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpDataKey Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(14056581-E16C-11D2-BB90-00C04F8EE6C0), 
	helpstring("ISpDataKey Interface"), 
	restricted
]
interface ISpDataKey : IUnknown {
	[id(0x60010000)]
	HRESULT __stdcall SetData(
		unsigned short* pszValueName,
		unsigned long cbData,
		BYTE* pData);
	[id(0x60010001)]
	HRESULT __stdcall GetData(
		unsigned short* pszValueName,
		unsigned long* pcbData,
		BYTE* pData);
	[id(0x60010002)]
	HRESULT __stdcall SetStringValue(
		unsigned short* pszValueName,
		unsigned short* pszValue);
	[id(0x60010003)]
	HRESULT __stdcall GetStringValue(
		unsigned short* pszValueName,
		unsigned short** ppszValue);
	[id(0x60010004)]
	HRESULT __stdcall SetDWORD(
		unsigned short* pszValueName,
		unsigned long dwValue);
	[id(0x60010005)]
	HRESULT __stdcall GetDWORD(
		unsigned short* pszValueName,
		unsigned long* pdwValue);
	[id(0x60010006)]
	HRESULT __stdcall OpenKey(
		unsigned short* pszSubKeyName,
		ISpDataKey** ppSubKey);
	[id(0x60010007)]
	HRESULT __stdcall CreateKey(
		unsigned short* pszSubKey,
		ISpDataKey** ppSubKey);
	[id(0x60010008)]
	HRESULT __stdcall DeleteKey(
		unsigned short* pszSubKey);
	[id(0x60010009)]
	HRESULT __stdcall DeleteValue(
		unsigned short* pszValueName);
	[id(0x6001000a)]
	HRESULT __stdcall EnumKeys(
		unsigned long Index,
		unsigned short** ppszSubKeyName);
	[id(0x6001000b)]
	HRESULT __stdcall EnumValues(
		unsigned long Index,
		unsigned short** ppszValueName);
};
'!
!ISpDataKey categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpDataKey methodsFor!

createKey: pszSubKey ppSubKey: ppSubKey
	"Invoke the CreateKey() method of the COM object."

	^self
		CreateKey: pszSubKey
		ppSubKey: ppSubKey
!

CreateKey: pszSubKey ppSubKey: ppSubKey
	"Private - Invoke the CreateKey() method of the COM object.

		HRESULT __stdcall CreateKey(
			unsigned short* pszSubKey,
			ISpDataKey** ppSubKey);"

	<virtual stdcall: hresult 11 word* ISpDataKey**>
	^self invalidCall
!

deleteKey: pszSubKey
	"Invoke the DeleteKey() method of the COM object."

	^self DeleteKey: pszSubKey
!

DeleteKey: pszSubKey
	"Private - Invoke the DeleteKey() method of the COM object.

		HRESULT __stdcall DeleteKey(
			unsigned short* pszSubKey);"

	<virtual stdcall: hresult 12 word*>
	^self invalidCall
!

deleteValue: pszValueName
	"Invoke the DeleteValue() method of the COM object."

	^self DeleteValue: pszValueName
!

DeleteValue: pszValueName
	"Private - Invoke the DeleteValue() method of the COM object.

		HRESULT __stdcall DeleteValue(
			unsigned short* pszValueName);"

	<virtual stdcall: hresult 13 word*>
	^self invalidCall
!

enumKeys: index ppszSubKeyName: ppszSubKeyName
	"Invoke the EnumKeys() method of the COM object."

	^self
		EnumKeys: index
		ppszSubKeyName: ppszSubKeyName
!

EnumKeys: index ppszSubKeyName: ppszSubKeyName
	"Private - Invoke the EnumKeys() method of the COM object.

		HRESULT __stdcall EnumKeys(
			unsigned long Index,
			unsigned short** ppszSubKeyName);"

	<virtual stdcall: hresult 14 dword word**>
	^self invalidCall
!

enumValues: index ppszValueName: ppszValueName
	"Invoke the EnumValues() method of the COM object."

	^self
		EnumValues: index
		ppszValueName: ppszValueName
!

EnumValues: index ppszValueName: ppszValueName
	"Private - Invoke the EnumValues() method of the COM object.

		HRESULT __stdcall EnumValues(
			unsigned long Index,
			unsigned short** ppszValueName);"

	<virtual stdcall: hresult 15 dword word**>
	^self invalidCall
!

getData: pszValueName pcbData: pcbData pData: pData
	"Invoke the GetData() method of the COM object."

	^self
		GetData: pszValueName
		pcbData: pcbData
		pData: pData
!

GetData: pszValueName pcbData: pcbData pData: pData
	"Private - Invoke the GetData() method of the COM object.

		HRESULT __stdcall GetData(
			unsigned short* pszValueName,
			unsigned long* pcbData,
			BYTE* pData);"

	<virtual stdcall: hresult 5 word* dword* byte*>
	^self invalidCall
!

getDWORD: pszValueName pdwValue: pdwValue
	"Invoke the GetDWORD() method of the COM object."

	^self
		GetDWORD: pszValueName
		pdwValue: pdwValue
!

GetDWORD: pszValueName pdwValue: pdwValue
	"Private - Invoke the GetDWORD() method of the COM object.

		HRESULT __stdcall GetDWORD(
			unsigned short* pszValueName,
			unsigned long* pdwValue);"

	<virtual stdcall: hresult 9 word* dword*>
	^self invalidCall
!

getStringValue: pszValueName ppszValue: ppszValue
	"Invoke the GetStringValue() method of the COM object."

	^self
		GetStringValue: pszValueName
		ppszValue: ppszValue
!

GetStringValue: pszValueName ppszValue: ppszValue
	"Private - Invoke the GetStringValue() method of the COM object.

		HRESULT __stdcall GetStringValue(
			unsigned short* pszValueName,
			unsigned short** ppszValue);"

	<virtual stdcall: hresult 7 word* word**>
	^self invalidCall
!

openKey: pszSubKeyName ppSubKey: ppSubKey
	"Invoke the OpenKey() method of the COM object."

	^self
		OpenKey: pszSubKeyName
		ppSubKey: ppSubKey
!

OpenKey: pszSubKeyName ppSubKey: ppSubKey
	"Private - Invoke the OpenKey() method of the COM object.

		HRESULT __stdcall OpenKey(
			unsigned short* pszSubKeyName,
			ISpDataKey** ppSubKey);"

	<virtual stdcall: hresult 10 word* ISpDataKey**>
	^self invalidCall
!

setData: pszValueName cbData: cbData pData: pData
	"Invoke the SetData() method of the COM object."

	^self
		SetData: pszValueName
		cbData: cbData
		pData: pData
!

SetData: pszValueName cbData: cbData pData: pData
	"Private - Invoke the SetData() method of the COM object.

		HRESULT __stdcall SetData(
			unsigned short* pszValueName,
			unsigned long cbData,
			BYTE* pData);"

	<virtual stdcall: hresult 4 word* dword byte*>
	^self invalidCall
!

setDWORD: pszValueName dwValue: dwValue
	"Invoke the SetDWORD() method of the COM object."

	^self
		SetDWORD: pszValueName
		dwValue: dwValue
!

SetDWORD: pszValueName dwValue: dwValue
	"Private - Invoke the SetDWORD() method of the COM object.

		HRESULT __stdcall SetDWORD(
			unsigned short* pszValueName,
			unsigned long dwValue);"

	<virtual stdcall: hresult 8 word* dword>
	^self invalidCall
!

setStringValue: pszValueName pszValue: pszValue
	"Invoke the SetStringValue() method of the COM object."

	^self
		SetStringValue: pszValueName
		pszValue: pszValue
!

SetStringValue: pszValueName pszValue: pszValue
	"Private - Invoke the SetStringValue() method of the COM object.

		HRESULT __stdcall SetStringValue(
			unsigned short* pszValueName,
			unsigned short* pszValue);"

	<virtual stdcall: hresult 6 word* word*>
	^self invalidCall
! !
!ISpDataKey categoriesFor: #createKey:ppSubKey:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #CreateKey:ppSubKey:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #deleteKey:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #DeleteKey:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #deleteValue:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #DeleteValue:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #enumKeys:ppszSubKeyName:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #EnumKeys:ppszSubKeyName:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #enumValues:ppszValueName:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #EnumValues:ppszValueName:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #getData:pcbData:pData:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #GetData:pcbData:pData:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #getDWORD:pdwValue:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #GetDWORD:pdwValue:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #getStringValue:ppszValue:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #GetStringValue:ppszValue:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #openKey:ppSubKey:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #OpenKey:ppSubKey:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #setData:cbData:pData:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #SetData:cbData:pData:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #setDWORD:dwValue:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #SetDWORD:dwValue:!**auto generated**!COM Interfaces-ISpDataKey!private! !
!ISpDataKey categoriesFor: #setStringValue:pszValue:!**auto generated**!methods!public! !
!ISpDataKey categoriesFor: #SetStringValue:pszValue:!**auto generated**!COM Interfaces-ISpDataKey!private! !

!ISpDataKey class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpDataKey'
		ISpDataKey defineTemplate"

	self
		defineFunction: #SetData:cbData:pData:
			argumentTypes: 'word* dword byte*';
		defineFunction: #GetData:pcbData:pData:
			argumentTypes: 'word* dword* byte*';
		defineFunction: #SetStringValue:pszValue:
			argumentTypes: 'word* word*';
		defineFunction: #GetStringValue:ppszValue:
			argumentTypes: 'word* word**';
		defineFunction: #SetDWORD:dwValue:
			argumentTypes: 'word* dword';
		defineFunction: #GetDWORD:pdwValue:
			argumentTypes: 'word* dword*';
		defineFunction: #OpenKey:ppSubKey:
			argumentTypes: 'word* ISpDataKey**';
		defineFunction: #CreateKey:ppSubKey:
			argumentTypes: 'word* ISpDataKey**';
		defineFunction: #DeleteKey:
			argumentTypes: 'word*';
		defineFunction: #DeleteValue:
			argumentTypes: 'word*';
		defineFunction: #EnumKeys:ppszSubKeyName:
			argumentTypes: 'dword word**';
		defineFunction: #EnumValues:ppszValueName:
			argumentTypes: 'dword word**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpDataKey initializeTypeLib"

	typeLib := SpeechLib! !
!ISpDataKey class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpDataKey class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

