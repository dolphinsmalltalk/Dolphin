"Filed out from Dolphin Smalltalk 7"!

OS.COM.IDispatch subclass: #'MSXML.IMXWriter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IMXWriter guid: (OS.COM.IID fromString: '{4d7ff4ba-1565-4ea8-94e1-6e724a46f98d}')!
MSXML.IMXWriter comment: '<IMXWriter> is a wrapper class for the COM interface ''MSXML2.IMXWriter'' generated from type information in the ''Microsoft XML, v4.0'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"IMXWriter interface"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	object, 
	uuid(4D7FF4BA-1565-4EA8-94E1-6E724A46F98D), 
	helpstring("IMXWriter interface"), 
	dual, 
	nonextensible
]
interface IMXWriter : IDispatch
 {
	[id(0x00000569), propput, helpstring("Set or get the output.")]
	HRESULT __stdcall output(
		[in]VARIANT varDestination);
	[id(0x00000569), propget, helpstring("Set or get the output.")]
	HRESULT __stdcall output(
		[out, retval]VARIANT* varDestination);
	[id(0x0000056b), propput, helpstring("Set or get the output encoding.")]
	HRESULT __stdcall encoding(
		[in]BSTR strEncoding);
	[id(0x0000056b), propget, helpstring("Set or get the output encoding.")]
	HRESULT __stdcall encoding(
		[out, retval]BSTR* strEncoding);
	[id(0x0000056c), propput, helpstring("Determine whether or not to write the byte order mark")]
	HRESULT __stdcall byteOrderMark(
		[in]VARIANT_BOOL fWriteByteOrderMark);
	[id(0x0000056c), propget, helpstring("Determine whether or not to write the byte order mark")]
	HRESULT __stdcall byteOrderMark(
		[out, retval]VARIANT_BOOL* fWriteByteOrderMark);
	[id(0x0000056d), propput, helpstring("Enable or disable auto indent mode.")]
	HRESULT __stdcall indent(
		[in]VARIANT_BOOL fIndentMode);
	[id(0x0000056d), propget, helpstring("Enable or disable auto indent mode.")]
	HRESULT __stdcall indent(
		[out, retval]VARIANT_BOOL* fIndentMode);
	[id(0x0000056e), propput, helpstring("Set or get the standalone document declaration.")]
	HRESULT __stdcall standalone(
		[in]VARIANT_BOOL fValue);
	[id(0x0000056e), propget, helpstring("Set or get the standalone document declaration.")]
	HRESULT __stdcall standalone(
		[out, retval]VARIANT_BOOL* fValue);
	[id(0x0000056f), propput, helpstring("Determine whether or not to omit the XML declaration.")]
	HRESULT __stdcall omitXMLDeclaration(
		[in]VARIANT_BOOL fValue);
	[id(0x0000056f), propget, helpstring("Determine whether or not to omit the XML declaration.")]
	HRESULT __stdcall omitXMLDeclaration(
		[out, retval]VARIANT_BOOL* fValue);
	[id(0x00000570), propput, helpstring("Set or get the xml version info.")]
	HRESULT __stdcall version(
		[in]BSTR strVersion);
	[id(0x00000570), propget, helpstring("Set or get the xml version info.")]
	HRESULT __stdcall version(
		[out, retval]BSTR* strVersion);
	[id(0x00000571), propput, helpstring("When enabled, the writer no longer escapes out its input when writing it out.")]
	HRESULT __stdcall disableOutputEscaping(
		[in]VARIANT_BOOL fValue);
	[id(0x00000571), propget, helpstring("When enabled, the writer no longer escapes out its input when writing it out.")]
	HRESULT __stdcall disableOutputEscaping(
		[out, retval]VARIANT_BOOL* fValue);
	[id(0x00000572), helpstring("Flushes all writer buffers forcing the writer to write to the underlying output object")]
	HRESULT __stdcall flush();
};
'!
!MSXML.IMXWriter categoriesForClass!COM-Interfaces!MSXML2-Interfaces! !
!MSXML.IMXWriter methodsFor!

byteOrderMark
	"Answer the <varbool> value of the 'byteOrderMark' property of the receiver.
	Helpstring: Determine whether or not to write the byte order mark"

	| answer |
	answer := (VARIANT_BOOL new).
	self get_byteOrderMark: answer.
	^answer asObject
!

byteOrderMark: fWriteByteOrderMark
	"Set the 'byteOrderMark' property of the receiver to the <varbool> value of the argument.
	Helpstring: Determine whether or not to write the byte order mark"

	self put_byteOrderMark: fWriteByteOrderMark
!

disableOutputEscaping
	"Answer the <varbool> value of the 'disableOutputEscaping' property of the receiver.
	Helpstring: When enabled, the writer no longer escapes out its input when writing it out."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_disableOutputEscaping: answer.
	^answer asObject
!

disableOutputEscaping: fValue
	"Set the 'disableOutputEscaping' property of the receiver to the <varbool> value of the argument.
	Helpstring: When enabled, the writer no longer escapes out its input when writing it out."

	self put_disableOutputEscaping: fValue
!

encoding
	"Answer the <bstr> value of the 'encoding' property of the receiver.
	Helpstring: Set or get the output encoding."

	| answer |
	answer := BSTR new.
	self get_encoding: answer.
	^answer asObject
!

encoding: strEncoding
	"Set the 'encoding' property of the receiver to the <bstr> value of the argument.
	Helpstring: Set or get the output encoding."

	self put_encoding: strEncoding
!

Flush
	"Invoke the flush() method of the COM object.
	Helpstring: Flushes all writer buffers forcing the writer to write to the underlying output object

		HRESULT __stdcall flush();"

	<virtual stdcall: hresult 24>
	^self invalidCall: _failureCode!

get_byteOrderMark: fWriteByteOrderMark
	"Private - Get the value of the 'byteOrderMark' property of the receiver.

		HRESULT __stdcall byteOrderMark(
			[out, retval]VARIANT_BOOL* fWriteByteOrderMark);"

	<virtual stdcall: hresult 13 varbool*>
	^self invalidCall: _failureCode!

get_disableOutputEscaping: fValue
	"Private - Get the value of the 'disableOutputEscaping' property of the receiver.

		HRESULT __stdcall disableOutputEscaping(
			[out, retval]VARIANT_BOOL* fValue);"

	<virtual stdcall: hresult 23 varbool*>
	^self invalidCall: _failureCode!

get_encoding: strEncoding
	"Private - Get the value of the 'encoding' property of the receiver.

		HRESULT __stdcall encoding(
			[out, retval]BSTR* strEncoding);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_indent: fIndentMode
	"Private - Get the value of the 'indent' property of the receiver.

		HRESULT __stdcall indent(
			[out, retval]VARIANT_BOOL* fIndentMode);"

	<virtual stdcall: hresult 15 varbool*>
	^self invalidCall: _failureCode!

get_omitXMLDeclaration: fValue
	"Private - Get the value of the 'omitXMLDeclaration' property of the receiver.

		HRESULT __stdcall omitXMLDeclaration(
			[out, retval]VARIANT_BOOL* fValue);"

	<virtual stdcall: hresult 19 varbool*>
	^self invalidCall: _failureCode!

get_output: varDestination
	"Private - Get the value of the 'output' property of the receiver.

		HRESULT __stdcall output(
			[out, retval]VARIANT* varDestination);"

	<virtual stdcall: hresult 9 variant*>
	^self invalidCall: _failureCode!

get_standalone: fValue
	"Private - Get the value of the 'standalone' property of the receiver.

		HRESULT __stdcall standalone(
			[out, retval]VARIANT_BOOL* fValue);"

	<virtual stdcall: hresult 17 varbool*>
	^self invalidCall: _failureCode!

get_version: strVersion
	"Private - Get the value of the 'version' property of the receiver.

		HRESULT __stdcall version(
			[out, retval]BSTR* strVersion);"

	<virtual stdcall: hresult 21 bstr*>
	^self invalidCall: _failureCode!

indent
	"Answer the <varbool> value of the 'indent' property of the receiver.
	Helpstring: Enable or disable auto indent mode."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_indent: answer.
	^answer asObject
!

indent: fIndentMode
	"Set the 'indent' property of the receiver to the <varbool> value of the argument.
	Helpstring: Enable or disable auto indent mode."

	self put_indent: fIndentMode
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

omitXMLDeclaration
	"Answer the <varbool> value of the 'omitXMLDeclaration' property of the receiver.
	Helpstring: Determine whether or not to omit the XML declaration."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_omitXMLDeclaration: answer.
	^answer asObject
!

omitXMLDeclaration: fValue
	"Set the 'omitXMLDeclaration' property of the receiver to the <varbool> value of the argument.
	Helpstring: Determine whether or not to omit the XML declaration."

	self put_omitXMLDeclaration: fValue
!

output
	"Answer the <variant> value of the 'output' property of the receiver.
	Helpstring: Set or get the output."

	| answer |
	answer := VARIANT new.
	self get_output: answer.
	^answer asObject
!

output: varDestination
	"Set the 'output' property of the receiver to the <variant> value of the argument.
	Helpstring: Set or get the output."

	self put_output: varDestination asVariant
!

put_byteOrderMark: fWriteByteOrderMark
	"Private - Set the value of the 'byteOrderMark' property of the object wrapped by the 
	 receiver to the <varbool> argument, fWriteByteOrderMark.

		HRESULT __stdcall byteOrderMark(
			[in]VARIANT_BOOL fWriteByteOrderMark);"

	<virtual stdcall: hresult 12 varbool>
	^self invalidCall: _failureCode!

put_disableOutputEscaping: fValue
	"Private - Set the value of the 'disableOutputEscaping' property of the object wrapped by the 
	 receiver to the <varbool> argument, fValue.

		HRESULT __stdcall disableOutputEscaping(
			[in]VARIANT_BOOL fValue);"

	<virtual stdcall: hresult 22 varbool>
	^self invalidCall: _failureCode!

put_encoding: strEncoding
	"Private - Set the value of the 'encoding' property of the object wrapped by the 
	 receiver to the <bstr> argument, strEncoding.

		HRESULT __stdcall encoding(
			[in]BSTR strEncoding);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

put_indent: fIndentMode
	"Private - Set the value of the 'indent' property of the object wrapped by the 
	 receiver to the <varbool> argument, fIndentMode.

		HRESULT __stdcall indent(
			[in]VARIANT_BOOL fIndentMode);"

	<virtual stdcall: hresult 14 varbool>
	^self invalidCall: _failureCode!

put_omitXMLDeclaration: fValue
	"Private - Set the value of the 'omitXMLDeclaration' property of the object wrapped by the 
	 receiver to the <varbool> argument, fValue.

		HRESULT __stdcall omitXMLDeclaration(
			[in]VARIANT_BOOL fValue);"

	<virtual stdcall: hresult 18 varbool>
	^self invalidCall: _failureCode!

put_output: varDestination
	"Private - Set the value of the 'output' property of the object wrapped by the 
	 receiver to the <variant> argument, varDestination.

		HRESULT __stdcall output(
			[in]VARIANT varDestination);"

	<virtual stdcall: hresult 8 variant>
	^self invalidCall: _failureCode!

put_standalone: fValue
	"Private - Set the value of the 'standalone' property of the object wrapped by the 
	 receiver to the <varbool> argument, fValue.

		HRESULT __stdcall standalone(
			[in]VARIANT_BOOL fValue);"

	<virtual stdcall: hresult 16 varbool>
	^self invalidCall: _failureCode!

put_version: strVersion
	"Private - Set the value of the 'version' property of the object wrapped by the 
	 receiver to the <bstr> argument, strVersion.

		HRESULT __stdcall version(
			[in]BSTR strVersion);"

	<virtual stdcall: hresult 20 bstr>
	^self invalidCall: _failureCode!

standalone
	"Answer the <varbool> value of the 'standalone' property of the receiver.
	Helpstring: Set or get the standalone document declaration."

	| answer |
	answer := (VARIANT_BOOL new).
	self get_standalone: answer.
	^answer asObject
!

standalone: fValue
	"Set the 'standalone' property of the receiver to the <varbool> value of the argument.
	Helpstring: Set or get the standalone document declaration."

	self put_standalone: fValue
!

version
	"Answer the <bstr> value of the 'version' property of the receiver.
	Helpstring: Set or get the xml version info."

	| answer |
	answer := BSTR new.
	self get_version: answer.
	^answer asObject
!

version: strVersion
	"Set the 'version' property of the receiver to the <bstr> value of the argument.
	Helpstring: Set or get the xml version info."

	self put_version: strVersion
! !
!MSXML.IMXWriter categoriesFor: #byteOrderMark!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #byteOrderMark:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #disableOutputEscaping!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #disableOutputEscaping:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #encoding!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #encoding:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #Flush!**auto generated**!COM Interfaces-IMXWriter!public! !
!MSXML.IMXWriter categoriesFor: #get_byteOrderMark:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_disableOutputEscaping:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_encoding:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_indent:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_omitXMLDeclaration:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_output:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_standalone:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #get_version:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #indent!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #indent:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #isExtensible!**auto generated**!public!testing! !
!MSXML.IMXWriter categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!MSXML.IMXWriter categoriesFor: #omitXMLDeclaration!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #omitXMLDeclaration:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #output!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #output:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #put_byteOrderMark:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_disableOutputEscaping:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_encoding:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_indent:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_omitXMLDeclaration:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_output:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_standalone:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #put_version:!**auto generated**!COM Interfaces-IMXWriter!private! !
!MSXML.IMXWriter categoriesFor: #standalone!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #standalone:!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #version!**auto generated**!properties!public! !
!MSXML.IMXWriter categoriesFor: #version:!**auto generated**!properties!public! !

!MSXML.IMXWriter class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IMXWriter'
		IMXWriter defineTemplate"

	self
		defineFunction: #put_output:
			argumentTypes: 'variant';
		defineFunction: #get_output:
			argumentTypes: 'variant*';
		defineFunction: #put_encoding:
			argumentTypes: 'bstr';
		defineFunction: #get_encoding:
			argumentTypes: 'bstr*';
		defineFunction: #put_byteOrderMark:
			argumentTypes: 'varbool';
		defineFunction: #get_byteOrderMark:
			argumentTypes: 'varbool*';
		defineFunction: #put_indent:
			argumentTypes: 'varbool';
		defineFunction: #get_indent:
			argumentTypes: 'varbool*';
		defineFunction: #put_standalone:
			argumentTypes: 'varbool';
		defineFunction: #get_standalone:
			argumentTypes: 'varbool*';
		defineFunction: #put_omitXMLDeclaration:
			argumentTypes: 'varbool';
		defineFunction: #get_omitXMLDeclaration:
			argumentTypes: 'varbool*';
		defineFunction: #put_version:
			argumentTypes: 'bstr';
		defineFunction: #get_version:
			argumentTypes: 'bstr*';
		defineFunction: #put_disableOutputEscaping:
			argumentTypes: 'varbool';
		defineFunction: #get_disableOutputEscaping:
			argumentTypes: 'varbool*';
		defineFunction: #Flush
!

newMXHTMLWriter
	"Answer a new instance of the receiver on the MXHTMLWriter COM object"

	^self onCLSID: (CLSID fromString: '{A4C23EC3-6B70-4466-9127-550077239978}')
!

newMXHTMLWriter30
	"Answer a new instance of the receiver on the MXHTMLWriter30 COM object"

	^self onCLSID: (CLSID fromString: '{853D1540-C1A7-4AA9-A226-4D3BD301146D}')
!

newMXHTMLWriter40
	"Answer a new instance of the receiver on the MXHTMLWriter40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C9-F192-11D4-A65F-0040963251E5}')
!

newMXHTMLWriter60
	"Answer a new instance of the receiver on the MXHTMLWriter60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A10-F192-11D4-A65F-0040963251E5}')
!

newMXXMLWriter
	"Answer a new instance of the receiver on the MXXMLWriter COM object"

	^self onCLSID: (CLSID fromString: '{FC220AD8-A72A-4EE8-926E-0B7AD152A020}')
!

newMXXMLWriter30
	"Answer a new instance of the receiver on the MXXMLWriter30 COM object"

	^self onCLSID: (CLSID fromString: '{3D813DFE-6C91-4A4E-8F41-04346A841D9C}')
!

newMXXMLWriter40
	"Answer a new instance of the receiver on the MXXMLWriter40 COM object"

	^self onCLSID: (CLSID fromString: '{88D969C8-F192-11D4-A65F-0040963251E5}')
!

newMXXMLWriter60
	"Answer a new instance of the receiver on the MXXMLWriter60 COM object"

	^self onCLSID: (CLSID fromString: '{88D96A0F-F192-11D4-A65F-0040963251E5}')
! !
!MSXML.IMXWriter class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!MSXML.IMXWriter class categoriesFor: #newMXHTMLWriter!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXHTMLWriter30!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXHTMLWriter40!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXHTMLWriter60!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXXMLWriter!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXXMLWriter30!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXXMLWriter40!**auto generated**!instance creation!public! !
!MSXML.IMXWriter class categoriesFor: #newMXXMLWriter60!**auto generated**!instance creation!public! !

