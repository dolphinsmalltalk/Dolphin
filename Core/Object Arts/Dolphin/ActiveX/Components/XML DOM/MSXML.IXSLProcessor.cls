"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IXSLProcessor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXSLProcessor guid: (OS.COM.IID fromString: '{2933bf92-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXSLProcessor comment: '<IXSLProcessor> is a wrapper class for the COM interface ''MSXML2.IXSLProcessor'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IXSLProcessor Interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(2933BF92-7B36-11D2-B20E-00C04F983E60), 
	helpstring("IXSLProcessor Interface"), 
	dual, 
	nonextensible
]
interface IXSLProcessor : IDispatch
 {
	[id(0x00000002), propput, helpstring("XML input tree to transform")]
	HRESULT __stdcall input(
		[in]VARIANT pVar);
	[id(0x00000002), propget, helpstring("XML input tree to transform")]
	HRESULT __stdcall input(
		[out, retval]VARIANT* pVar);
	[id(0x00000003), propget, helpstring("template object used to create this processor object")]
	HRESULT __stdcall ownerTemplate(
		[out, retval]IXSLTemplate** ppTemplate);
	[id(0x00000004), helpstring("set XSL mode and it''s namespace")]
	HRESULT __stdcall setStartMode(
		[in]BSTR mode,
		[in, defaultvalue("")]BSTR namespaceURI);
	[id(0x00000005), propget, helpstring("starting XSL mode")]
	HRESULT __stdcall startMode(
		[out, retval]BSTR* mode);
	[id(0x00000006), propget, helpstring("namespace of starting XSL mode")]
	HRESULT __stdcall startModeURI(
		[out, retval]BSTR* namespaceURI);
	[id(0x00000007), propput, helpstring("custom stream object for transform output")]
	HRESULT __stdcall output(
		[in]VARIANT pOutput);
	[id(0x00000007), propget, helpstring("custom stream object for transform output")]
	HRESULT __stdcall output(
		[out, retval]VARIANT* pOutput);
	[id(0x00000008), helpstring("start/resume the XSL transformation process")]
	HRESULT __stdcall transform(
		[out, retval]VARIANT_BOOL* pDone);
	[id(0x00000009), helpstring("reset state of processor and abort current transform")]
	HRESULT __stdcall reset();
	[id(0x0000000a), propget, helpstring("current state of the processor")]
	HRESULT __stdcall readyState(
		[out, retval]long* pReadyState);
	[id(0x0000000b), helpstring("set <xsl:param> values")]
	HRESULT __stdcall addParameter(
		[in]BSTR baseName,
		[in]VARIANT parameter,
		[in, defaultvalue("")]BSTR namespaceURI);
	[id(0x0000000c), helpstring("pass object to stylesheet")]
	HRESULT __stdcall addObject(
		[in]IDispatch* obj,
		[in]BSTR namespaceURI);
	[id(0x0000000d), propget, helpstring("current stylesheet being used")]
	HRESULT __stdcall stylesheet(
		[out, retval]IXMLDOMNode** stylesheet);
};
'!
!MSXML.IXSLProcessor categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IXSLProcessor methodsFor!

AddObject: obj namespaceURI: namespaceURI
	"Invoke the addObject() method of the COM object.
	Helpstring: pass object to stylesheet

		HRESULT __stdcall addObject(
			[in]IDispatch* obj,
			[in]BSTR namespaceURI);"

	<virtual stdcall: hresult 20 IDispatch* bstr>
	^self invalidCall: _failureCode!

addParameter: baseName parameter: parameter
	"Invoke the addParameter() method of the COM object.
	Default values are passed for all optional parameters."

	^self
		addParameter: baseName
		parameter: parameter
		namespaceURI: '0'!

addParameter: baseName parameter: parameter namespaceURI: namespaceURI
	"Invoke the addParameter() method of the COM object.
	Helpstring: set <xsl:param> values"

	^self
		AddParameter: baseName
		parameter: parameter asVariant
		namespaceURI: namespaceURI!

AddParameter: baseName parameter: parameter namespaceURI: namespaceURI
	"Private - Invoke the addParameter() method of the COM object.
	Helpstring: set <xsl:param> values

		HRESULT __stdcall addParameter(
			[in]BSTR baseName,
			[in]VARIANT parameter,
			[in, defaultvalue('0')]BSTR namespaceURI);"

	<virtual stdcall: hresult 19 bstr variant bstr>
	^self invalidCall: _failureCode!

get_input: pVar
	"Private - Get the value of the 'input' property of the receiver.

		HRESULT __stdcall input(
			[out, retval]VARIANT* pVar);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall: _failureCode!

get_output: pOutput
	"Private - Get the value of the 'output' property of the receiver.

		HRESULT __stdcall output(
			[out, retval]VARIANT* pOutput);"

	<virtual stdcall: hresult 15 variant*>
	^self invalidCall: _failureCode!

get_ownerTemplate: ppTemplate
	"Private - Get the value of the 'ownerTemplate' property of the receiver.

		HRESULT __stdcall ownerTemplate(
			[out, retval]IXSLTemplate** ppTemplate);"

	<virtual stdcall: hresult 10 IXSLTemplate**>
	^self invalidCall: _failureCode!

get_readyState: pReadyState
	"Private - Get the value of the 'readyState' property of the receiver.

		HRESULT __stdcall readyState(
			[out, retval]long* pReadyState);"

	<virtual stdcall: hresult 18 sdword*>
	^self invalidCall: _failureCode!

get_startMode: mode
	"Private - Get the value of the 'startMode' property of the receiver.

		HRESULT __stdcall startMode(
			[out, retval]BSTR* mode);"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

get_startModeURI: namespaceURI
	"Private - Get the value of the 'startModeURI' property of the receiver.

		HRESULT __stdcall startModeURI(
			[out, retval]BSTR* namespaceURI);"

	<virtual stdcall: hresult 13 bstr*>
	^self invalidCall: _failureCode!

get_stylesheet: stylesheet
	"Private - Get the value of the 'stylesheet' property of the receiver.

		HRESULT __stdcall stylesheet(
			[out, retval]IXMLDOMNode** stylesheet);"

	<virtual stdcall: hresult 21 IXMLDOMNode**>
	^self invalidCall: _failureCode!

input
	"Answer the <variant> value of the 'input' property of the receiver.
	Helpstring: XML input tree to transform"

	| answer |
	answer := VARIANT new.
	self get_input: answer.
	^answer asObject!

input: pVar
	"Set the 'input' property of the receiver to the <variant> value of the argument.
	Helpstring: XML input tree to transform"

	self put_input: pVar asVariant!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

output
	"Answer the <variant> value of the 'output' property of the receiver.
	Helpstring: custom stream object for transform output"

	| answer |
	answer := VARIANT new.
	self get_output: answer.
	^answer asObject!

output: pOutput
	"Set the 'output' property of the receiver to the <variant> value of the argument.
	Helpstring: custom stream object for transform output"

	self put_output: pOutput asVariant!

ownerTemplate
	"Answer the <IXSLTemplate> value of the 'ownerTemplate' property of the receiver.
	Helpstring: template object used to create this processor object"

	| answer |
	answer := IXSLTemplate newPointer.
	self get_ownerTemplate: answer.
	^answer asObject!

put_input: pVar
	"Private - Set the value of the 'input' property of the object wrapped by the 
	 receiver to the <variant> argument, pVar.

		HRESULT __stdcall input(
			[in]VARIANT pVar);"

	<virtual stdcall: hresult 8 variant>
	^self invalidCall: _failureCode!

put_output: pOutput
	"Private - Set the value of the 'output' property of the object wrapped by the 
	 receiver to the <variant> argument, pOutput.

		HRESULT __stdcall output(
			[in]VARIANT pOutput);"

	<virtual stdcall: hresult 14 variant>
	^self invalidCall: _failureCode!

readyState
	"Answer the <sdword> value of the 'readyState' property of the receiver.
	Helpstring: current state of the processor"

	| answer |
	answer := SDWORD new.
	self get_readyState: answer.
	^answer asObject!

Reset
	"Invoke the reset() method of the COM object.
	Helpstring: reset state of processor and abort current transform

		HRESULT __stdcall reset();"

	<virtual stdcall: hresult 17>
	^self invalidCall: _failureCode!

setStartMode: mode
	"Invoke the setStartMode() method of the COM object.
	Default values are passed for all optional parameters."

	^self SetStartMode: mode namespaceURI: '0'!

SetStartMode: mode namespaceURI: namespaceURI
	"Invoke the setStartMode() method of the COM object.
	Helpstring: set XSL mode and it's namespace

		HRESULT __stdcall setStartMode(
			[in]BSTR mode,
			[in, defaultvalue('0')]BSTR namespaceURI);"

	<virtual stdcall: hresult 11 bstr bstr>
	^self invalidCall: _failureCode!

startMode
	"Answer the <bstr> value of the 'startMode' property of the receiver.
	Helpstring: starting XSL mode"

	| answer |
	answer := BSTR new.
	self get_startMode: answer.
	^answer asObject!

startModeURI
	"Answer the <bstr> value of the 'startModeURI' property of the receiver.
	Helpstring: namespace of starting XSL mode"

	| answer |
	answer := BSTR new.
	self get_startModeURI: answer.
	^answer asObject!

stylesheet
	"Answer the <IXMLDOMNode> value of the 'stylesheet' property of the receiver.
	Helpstring: current stylesheet being used"

	| answer |
	answer := IXMLDOMNode newPointer.
	self get_stylesheet: answer.
	^answer asObject!

transform
	"Answer the <varbool> result of invoking the transform() method of the COM object.
	Helpstring: start/resume the XSL transformation process"

	| answer |
	answer := VARIANT_BOOL new.
	self Transform: answer.
	^answer asObject!

Transform: pDone
	"Private - Invoke the transform() method of the COM object.
	Helpstring: start/resume the XSL transformation process

		HRESULT __stdcall transform(
			[out, retval]VARIANT_BOOL* pDone);"

	<virtual stdcall: hresult 16 varbool*>
	^self invalidCall: _failureCode! !
!MSXML.IXSLProcessor categoriesFor: #AddObject:namespaceURI:!**auto generated**!COM Interfaces-IXSLProcessor!public! !
!MSXML.IXSLProcessor categoriesFor: #addParameter:parameter:!**auto generated**!methods!public! !
!MSXML.IXSLProcessor categoriesFor: #addParameter:parameter:namespaceURI:!**auto generated**!methods!public! !
!MSXML.IXSLProcessor categoriesFor: #AddParameter:parameter:namespaceURI:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_input:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_output:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_ownerTemplate:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_readyState:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_startMode:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_startModeURI:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #get_stylesheet:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #input!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #input:!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IXSLProcessor categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IXSLProcessor categoriesFor: #output!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #output:!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #ownerTemplate!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #put_input:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #put_output:!**auto generated**!COM Interfaces-IXSLProcessor!private! !
!MSXML.IXSLProcessor categoriesFor: #readyState!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #Reset!**auto generated**!COM Interfaces-IXSLProcessor!public! !
!MSXML.IXSLProcessor categoriesFor: #setStartMode:!**auto generated**!methods!public! !
!MSXML.IXSLProcessor categoriesFor: #SetStartMode:namespaceURI:!**auto generated**!COM Interfaces-IXSLProcessor!public! !
!MSXML.IXSLProcessor categoriesFor: #startMode!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #startModeURI!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #stylesheet!**auto generated**!properties!public! !
!MSXML.IXSLProcessor categoriesFor: #transform!**auto generated**!methods!public! !
!MSXML.IXSLProcessor categoriesFor: #Transform:!**auto generated**!COM Interfaces-IXSLProcessor!private! !

!MSXML.IXSLProcessor class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXSLProcessor'
		IXSLProcessor defineTemplate"

	self
		defineFunction: #put_input:
			argumentTypes: 'variant';
		defineFunction: #get_input:
			argumentTypes: 'variant*';
		defineFunction: #get_ownerTemplate:
			argumentTypes: 'IXSLTemplate**';
		defineFunction: #SetStartMode:namespaceURI:
			argumentTypes: 'bstr bstr';
		defineFunction: #get_startMode:
			argumentTypes: 'bstr*';
		defineFunction: #get_startModeURI:
			argumentTypes: 'bstr*';
		defineFunction: #put_output:
			argumentTypes: 'variant';
		defineFunction: #get_output:
			argumentTypes: 'variant*';
		defineFunction: #Transform:
			argumentTypes: 'varbool*';
		defineFunction: #Reset;
		defineFunction: #get_readyState:
			argumentTypes: 'sdword*';
		defineFunction: #AddParameter:parameter:namespaceURI:
			argumentTypes: 'bstr variant bstr';
		defineFunction: #AddObject:namespaceURI:
			argumentTypes: 'IDispatch* bstr';
		defineFunction: #get_stylesheet:
			argumentTypes: 'IXMLDOMNode**'
! !
!MSXML.IXSLProcessor class categoriesFor: #defineFunctions!**auto generated**!initializing!private! !

