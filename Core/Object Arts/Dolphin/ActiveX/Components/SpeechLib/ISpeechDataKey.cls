"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #ISpeechDataKey
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'SpeechLibConstants'
	classInstanceVariableNames: ''!
ISpeechDataKey guid: (IID fromString: '{CE17C09B-4EFA-44D5-A4C9-59D9585AB0CD}')!
ISpeechDataKey comment: '<ISpeechDataKey> is a wrapper class for the COM interface ''SpeechLib.ISpeechDataKey'' generated from type information in the ''Microsoft Speech Object Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"ISpeechDataKey Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(CE17C09B-4EFA-44D5-A4C9-59D9585AB0CD), 
	helpstring("ISpeechDataKey Interface"), 
	dual
]
interface ISpeechDataKey : IDispatch {
	[id(0x00000001), helpstring("SetBinaryValue")]
	HRESULT __stdcall SetBinaryValue(
		[in] BSTR ValueName,
		[in] VARIANT Value);
	[id(0x00000002), helpstring("GetBinaryValue")]
	HRESULT __stdcall GetBinaryValue(
		[in] BSTR ValueName,
		[out, retval] VARIANT* Value);
	[id(0x00000003), helpstring("SetStringValue")]
	HRESULT __stdcall SetStringValue(
		[in] BSTR ValueName,
		[in] BSTR Value);
	[id(0x00000004), helpstring("GetStringValue")]
	HRESULT __stdcall GetStringValue(
		[in] BSTR ValueName,
		[out, retval] BSTR* Value);
	[id(0x00000005), helpstring("SetLongValue")]
	HRESULT __stdcall SetLongValue(
		[in] BSTR ValueName,
		[in] long Value);
	[id(0x00000006), helpstring("GetlongValue")]
	HRESULT __stdcall GetLongValue(
		[in] BSTR ValueName,
		[out, retval] long* Value);
	[id(0x00000007), helpstring("OpenKey")]
	HRESULT __stdcall OpenKey(
		[in] BSTR SubKeyName,
		[out, retval] ISpeechDataKey** SubKey);
	[id(0x00000008), helpstring("CreateKey")]
	HRESULT __stdcall CreateKey(
		[in] BSTR SubKeyName,
		[out, retval] ISpeechDataKey** SubKey);
	[id(0x00000009), helpstring("DeleteKey")]
	HRESULT __stdcall DeleteKey(
		[in] BSTR SubKeyName);
	[id(0x0000000a), helpstring("DeleteValue")]
	HRESULT __stdcall DeleteValue(
		[in] BSTR ValueName);
	[id(0x0000000b), helpstring("EnumKeys")]
	HRESULT __stdcall EnumKeys(
		[in] long Index,
		[out, retval] BSTR* SubKeyName);
	[id(0x0000000c), helpstring("EnumValues")]
	HRESULT __stdcall EnumValues(
		[in] long Index,
		[out, retval] BSTR* ValueName);
};
'!
!ISpeechDataKey categoriesForClass!COM-Interfaces!SpeechLib-Interfaces! !
!ISpeechDataKey methodsFor!

createKey: subKeyName
	"Answer the <ISpeechDataKey> result of invoking the CreateKey() method of the COM object.
	Helpstring: 'CreateKey'"

	| answer |
	answer := ISpeechDataKey newPointer.
	self
		CreateKey: subKeyName
		SubKey: answer.
	^answer asObject
!

CreateKey: subKeyName SubKey: subKey
	"Private - Invoke the CreateKey() method of the COM object.
	Helpstring: 'CreateKey'

		HRESULT __stdcall CreateKey(
			[in] BSTR SubKeyName,
			[out, retval] ISpeechDataKey** SubKey);"

	<virtual stdcall: hresult 15 bstr ISpeechDataKey**>
	^self invalidCall
!

deleteKey: subKeyName
	"Invoke the DeleteKey() method of the COM object.
	Helpstring: 'DeleteKey'"

	^self DeleteKey: subKeyName
!

DeleteKey: subKeyName
	"Private - Invoke the DeleteKey() method of the COM object.
	Helpstring: 'DeleteKey'

		HRESULT __stdcall DeleteKey(
			[in] BSTR SubKeyName);"

	<virtual stdcall: hresult 16 bstr>
	^self invalidCall
!

deleteValue: valueName
	"Invoke the DeleteValue() method of the COM object.
	Helpstring: 'DeleteValue'"

	^self DeleteValue: valueName
!

DeleteValue: valueName
	"Private - Invoke the DeleteValue() method of the COM object.
	Helpstring: 'DeleteValue'

		HRESULT __stdcall DeleteValue(
			[in] BSTR ValueName);"

	<virtual stdcall: hresult 17 bstr>
	^self invalidCall
!

enumKeys: index
	"Answer the <BSTR> result of invoking the EnumKeys() method of the COM object.
	Helpstring: 'EnumKeys'"

	| answer |
	answer := BSTR new.
	self
		EnumKeys: index
		SubKeyName: answer.
	^answer asObject
!

EnumKeys: index SubKeyName: subKeyName
	"Private - Invoke the EnumKeys() method of the COM object.
	Helpstring: 'EnumKeys'

		HRESULT __stdcall EnumKeys(
			[in] long Index,
			[out, retval] BSTR* SubKeyName);"

	<virtual stdcall: hresult 18 sdword bstr*>
	^self invalidCall
!

enumValues: index
	"Answer the <BSTR> result of invoking the EnumValues() method of the COM object.
	Helpstring: 'EnumValues'"

	| answer |
	answer := BSTR new.
	self
		EnumValues: index
		ValueName: answer.
	^answer asObject
!

EnumValues: index ValueName: valueName
	"Private - Invoke the EnumValues() method of the COM object.
	Helpstring: 'EnumValues'

		HRESULT __stdcall EnumValues(
			[in] long Index,
			[out, retval] BSTR* ValueName);"

	<virtual stdcall: hresult 19 sdword bstr*>
	^self invalidCall
!

getBinaryValue: valueName
	"Answer the <VARIANT> result of invoking the GetBinaryValue() method of the COM object.
	Helpstring: 'GetBinaryValue'"

	| answer |
	answer := VARIANT new.
	self
		GetBinaryValue: valueName
		Value: answer.
	^answer asObject
!

GetBinaryValue: valueName Value: value
	"Private - Invoke the GetBinaryValue() method of the COM object.
	Helpstring: 'GetBinaryValue'

		HRESULT __stdcall GetBinaryValue(
			[in] BSTR ValueName,
			[out, retval] VARIANT* Value);"

	<virtual stdcall: hresult 9 bstr variant*>
	^self invalidCall
!

getLongValue: valueName
	"Answer the <SDWORD> result of invoking the GetLongValue() method of the COM object.
	Helpstring: 'GetlongValue'"

	| answer |
	answer := (SDWORD new).
	self
		GetLongValue: valueName
		Value: answer.
	^answer asObject
!

GetLongValue: valueName Value: value
	"Private - Invoke the GetLongValue() method of the COM object.
	Helpstring: 'GetlongValue'

		HRESULT __stdcall GetLongValue(
			[in] BSTR ValueName,
			[out, retval] long* Value);"

	<virtual stdcall: hresult 13 bstr sdword*>
	^self invalidCall
!

getStringValue: valueName
	"Answer the <BSTR> result of invoking the GetStringValue() method of the COM object.
	Helpstring: 'GetStringValue'"

	| answer |
	answer := BSTR new.
	self
		GetStringValue: valueName
		Value: answer.
	^answer asObject
!

GetStringValue: valueName Value: value
	"Private - Invoke the GetStringValue() method of the COM object.
	Helpstring: 'GetStringValue'

		HRESULT __stdcall GetStringValue(
			[in] BSTR ValueName,
			[out, retval] BSTR* Value);"

	<virtual stdcall: hresult 11 bstr bstr*>
	^self invalidCall
!

openKey: subKeyName
	"Answer the <ISpeechDataKey> result of invoking the OpenKey() method of the COM object.
	Helpstring: 'OpenKey'"

	| answer |
	answer := ISpeechDataKey newPointer.
	self
		OpenKey: subKeyName
		SubKey: answer.
	^answer asObject
!

OpenKey: subKeyName SubKey: subKey
	"Private - Invoke the OpenKey() method of the COM object.
	Helpstring: 'OpenKey'

		HRESULT __stdcall OpenKey(
			[in] BSTR SubKeyName,
			[out, retval] ISpeechDataKey** SubKey);"

	<virtual stdcall: hresult 14 bstr ISpeechDataKey**>
	^self invalidCall
!

setBinaryValue: valueName value: value
	"Invoke the SetBinaryValue() method of the COM object.
	Helpstring: 'SetBinaryValue'"

	^self
		SetBinaryValue: valueName
		Value: value asVariant
!

SetBinaryValue: valueName Value: value
	"Private - Invoke the SetBinaryValue() method of the COM object.
	Helpstring: 'SetBinaryValue'

		HRESULT __stdcall SetBinaryValue(
			[in] BSTR ValueName,
			[in] VARIANT Value);"

	<virtual stdcall: hresult 8 bstr variant>
	^self invalidCall
!

setLongValue: valueName value: value
	"Invoke the SetLongValue() method of the COM object.
	Helpstring: 'SetLongValue'"

	^self
		SetLongValue: valueName
		Value: value
!

SetLongValue: valueName Value: value
	"Private - Invoke the SetLongValue() method of the COM object.
	Helpstring: 'SetLongValue'

		HRESULT __stdcall SetLongValue(
			[in] BSTR ValueName,
			[in] long Value);"

	<virtual stdcall: hresult 12 bstr sdword>
	^self invalidCall
!

setStringValue: valueName value: value
	"Invoke the SetStringValue() method of the COM object.
	Helpstring: 'SetStringValue'"

	^self
		SetStringValue: valueName
		Value: value
!

SetStringValue: valueName Value: value
	"Private - Invoke the SetStringValue() method of the COM object.
	Helpstring: 'SetStringValue'

		HRESULT __stdcall SetStringValue(
			[in] BSTR ValueName,
			[in] BSTR Value);"

	<virtual stdcall: hresult 10 bstr bstr>
	^self invalidCall
! !
!ISpeechDataKey categoriesFor: #createKey:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #CreateKey:SubKey:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #deleteKey:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #DeleteKey:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #deleteValue:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #DeleteValue:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #enumKeys:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #EnumKeys:SubKeyName:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #enumValues:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #EnumValues:ValueName:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #getBinaryValue:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #GetBinaryValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #getLongValue:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #GetLongValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #getStringValue:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #GetStringValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #openKey:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #OpenKey:SubKey:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #setBinaryValue:value:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #SetBinaryValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #setLongValue:value:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #SetLongValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !
!ISpeechDataKey categoriesFor: #setStringValue:value:!**auto generated**!methods!public! !
!ISpeechDataKey categoriesFor: #SetStringValue:Value:!**auto generated**!COM Interfaces-ISpeechDataKey!private! !

!ISpeechDataKey class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'SpeechLib.ISpeechDataKey'
		ISpeechDataKey defineTemplate"

	self
		defineFunction: #SetBinaryValue:Value:
			argumentTypes: 'bstr variant';
		defineFunction: #GetBinaryValue:Value:
			argumentTypes: 'bstr variant*';
		defineFunction: #SetStringValue:Value:
			argumentTypes: 'bstr bstr';
		defineFunction: #GetStringValue:Value:
			argumentTypes: 'bstr bstr*';
		defineFunction: #SetLongValue:Value:
			argumentTypes: 'bstr sdword';
		defineFunction: #GetLongValue:Value:
			argumentTypes: 'bstr sdword*';
		defineFunction: #OpenKey:SubKey:
			argumentTypes: 'bstr ISpeechDataKey**';
		defineFunction: #CreateKey:SubKey:
			argumentTypes: 'bstr ISpeechDataKey**';
		defineFunction: #DeleteKey:
			argumentTypes: 'bstr';
		defineFunction: #DeleteValue:
			argumentTypes: 'bstr';
		defineFunction: #EnumKeys:SubKeyName:
			argumentTypes: 'sdword bstr*';
		defineFunction: #EnumValues:ValueName:
			argumentTypes: 'sdword bstr*'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		ISpeechDataKey initializeTypeLib"

	typeLib := SpeechLib! !
!ISpeechDataKey class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!ISpeechDataKey class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

