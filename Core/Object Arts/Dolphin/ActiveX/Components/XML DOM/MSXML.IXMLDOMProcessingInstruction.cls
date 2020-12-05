"Filed out from Dolphin Smalltalk 7"!

MSXML.IXMLDOMNode subclass: #'MSXML.IXMLDOMProcessingInstruction'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML.IXMLDOMProcessingInstruction guid: (OS.COM.IID fromString: '{2933bf89-7b36-11d2-b20e-00c04f983e60}')!
MSXML.IXMLDOMProcessingInstruction comment: '<IXMLDOMProcessingInstruction> is a wrapper class for the COM interface ''MSXML.IXMLDOMProcessingInstruction'' generated from type information in the ''Microsoft XML, version 2.0'' library. It contains methods to invoke the member functions exposed by that interface.

This is a specialized DOM node to represent processing instructions. These are used to define processor-specific infromation in the text of the document.'!
!MSXML.IXMLDOMProcessingInstruction categoriesForClass!COM-Interfaces!MSXML-Interfaces! !
!MSXML.IXMLDOMProcessingInstruction methodsFor!

= anObject 
	^self class == anObject class and: [self target = anObject target and: [self data = anObject data]]!

childNodes
	"Answer the a <sequencedReadableCollection> on the <IXMLDOMNodeList> 
	value of the 'childNodes' property of the receiver."

	"Implementation Note: Text, CDATA, and Comment nodes cannot have any child nodes."

	^#()!

data
	"Answer the <bstr> value of the 'data' property of the receiver.
	Helpstring: the data"

	| answer |
	answer := BSTR new.
	self get_data: answer.
	^answer asObject
!

data: value
	"Set the 'data' property of the receiver to the <bstr> value of the argument.
	Helpstring: the data"

	self put_data: value
!

get_data: value
	"Private - Get the value of the 'data' property of the receiver.

		HRESULT __stdcall data(
			[out, retval]BSTR* value);"

	<virtual stdcall: hresult 45 bstr*>
	^self invalidCall: _failureCode!

get_target: name
	"Private - Get the value of the 'target' property of the receiver.

		HRESULT __stdcall target(
			[out, retval]BSTR* name);"

	<virtual stdcall: hresult 44 bstr*>
	^self invalidCall: _failureCode!

printOn: aStream
	"Append a developer friendly textual representation of the receiver to aStream."

	aStream basicPrint: self.
	[aStream nextPutAll: self xml]
		on: HRESULTError do: [:e | aStream nextPut: $(; print: bytes; nextPut: $)]

!

put_data: value
	"Private - Set the value of the 'data' property of the object wrapped by the 
	 receiver to the <bstr> argument, value.

		HRESULT __stdcall data(
			[in]BSTR value);"

	<virtual stdcall: hresult 46 bstr>
	^self invalidCall: _failureCode!

target
	"Answer the <bstr> value of the 'target' property of the receiver.
	Helpstring: the target"

	| answer |
	answer := BSTR new.
	self get_target: answer.
	^answer asObject
! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #=!comparing!public! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #childNodes!properties!public! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #data!**auto generated**!properties!public! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #data:!**auto generated**!properties!public! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #get_data:!**auto generated**!COM Interfaces-IXMLDOMProcessingInstruction!private! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #get_target:!**auto generated**!COM Interfaces-IXMLDOMProcessingInstruction!private! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #printOn:!development!printing!public! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #put_data:!**auto generated**!COM Interfaces-IXMLDOMProcessingInstruction!private! !
!MSXML.IXMLDOMProcessingInstruction categoriesFor: #target!**auto generated**!properties!public! !

!MSXML.IXMLDOMProcessingInstruction class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'MSXML2.IXMLDOMProcessingInstruction'
		IXMLDOMProcessingInstruction defineTemplate"

	self
		defineFunction: #get_target:
			argumentTypes: 'bstr*';
		defineFunction: #get_data:
			argumentTypes: 'bstr*';
		defineFunction: #put_data:
			argumentTypes: 'bstr'
! !
!MSXML.IXMLDOMProcessingInstruction class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !

