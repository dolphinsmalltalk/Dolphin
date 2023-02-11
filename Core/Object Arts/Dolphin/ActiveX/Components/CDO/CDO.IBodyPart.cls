"Filed out from Dolphin Smalltalk"!

OS.COM.IDispatch subclass: #'CDO.IBodyPart'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CDO.IBodyPart guid: (OS.COM.IID fromString: '{cd000021-8b95-11d1-82db-00c04fb1625d}')!
CDO.IBodyPart comment: '<CDO.IBodyPart> is a wrapper class for the COM interface ''CDO.IBodyPart'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a message body part"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDO.IBodyPart categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDO.IBodyPart methodsFor!

addBodyPart
	"Answer the <IBodyPart> result of invoking the AddBodyPart() method of the COM object.
	Default values are passed for all optional parameters."

	^self addBodyPart: -1!

addBodyPart: index
	"Answer the <IBodyPart> result of invoking the AddBodyPart() method of the COM object.
	Helpstring: Adds a body part to the object's BodyParts collection."

	| answer |
	answer := IBodyPart newPointer.
	self AddBodyPart: index ppPart: answer.
	^answer asObject!

AddBodyPart: index ppPart: ppPart
	"Private - Invoke the AddBodyPart() method of the COM object.
	Helpstring: Adds a body part to the object's BodyParts collection.

		HRESULT __stdcall AddBodyPart(
			[in, defaultvalue(-1)]long Index,
			[out, retval]IBodyPart** ppPart);"

	<virtual stdcall: hresult 23 int32 IBodyPart**>
	^self invalidCall: _failureCode!

bodyParts
	"Answer the <IBodyParts> value of the 'BodyParts' property of the receiver.
	Helpstring: The object's BodyParts collection."

	| answer |
	answer := IBodyParts newPointer.
	self get_BodyParts: answer.
	^answer asObject!

charset
	"Answer the <bstr> value of the 'Charset' property of the receiver.
	Helpstring: The character set of the body part's text content (not applicable for non-text content types)."

	| answer |
	answer := BSTR new.
	self get_Charset: answer.
	^answer asObject!

charset: pCharset
	"Set the 'Charset' property of the receiver to the <bstr> value of the argument.
	Helpstring: The character set of the body part's text content (not applicable for non-text content types)."

	self put_Charset: pCharset!

contentClass
	"Answer the <bstr> value of the 'ContentClass' property of the receiver.
	Helpstring: The body part's content class."

	| answer |
	answer := BSTR new.
	self get_ContentClass: answer.
	^answer asObject!

contentClass: pContentClass
	"Set the 'ContentClass' property of the receiver to the <bstr> value of the argument.
	Helpstring: The body part's content class."

	self put_ContentClass: pContentClass!

contentClassName
	"Answer the <bstr> value of the 'ContentClassName' property of the receiver.
	Helpstring: Deprecated. Do not use."

	| answer |
	answer := BSTR new.
	self get_ContentClassName: answer.
	^answer asObject!

contentClassName: pContentClassName
	"Set the 'ContentClassName' property of the receiver to the <bstr> value of the argument.
	Helpstring: Deprecated. Do not use."

	self put_ContentClassName: pContentClassName!

contentMediaType
	"Answer the <bstr> value of the 'ContentMediaType' property of the receiver.
	Helpstring: The content media type portion of the body part's content type."

	| answer |
	answer := BSTR new.
	self get_ContentMediaType: answer.
	^answer asObject!

contentMediaType: pContentMediaType
	"Set the 'ContentMediaType' property of the receiver to the <bstr> value of the argument.
	Helpstring: The content media type portion of the body part's content type."

	self put_ContentMediaType: pContentMediaType!

contentTransferEncoding
	"Answer the <bstr> value of the 'ContentTransferEncoding' property of the receiver.
	Helpstring: The method used to encode the body part content. For example, quoted-printable or base64."

	| answer |
	answer := BSTR new.
	self get_ContentTransferEncoding: answer.
	^answer asObject!

contentTransferEncoding: pContentTransferEncoding
	"Set the 'ContentTransferEncoding' property of the receiver to the <bstr> value of the argument.
	Helpstring: The method used to encode the body part content. For example, quoted-printable or base64."

	self put_ContentTransferEncoding: pContentTransferEncoding!

dataSource
	"Answer the <IDataSource> value of the 'DataSource' property of the receiver.
	Helpstring: The object's IDataSource interface."

	| answer |
	answer := IDataSource newPointer.
	self get_DataSource: answer.
	^answer asObject!

fields
	"Answer the <ADODB.Fields> value of the 'Fields' property of the receiver.
	Helpstring: 'Returns the Fields collection for the body part'
	Implementation Note: Originally auto-generated from the CDO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODB.Fields newPointer.
	self get_Fields: answer.
	^ADODB.ADOCollection on: answer
!

fileName
	"Answer the <bstr> value of the 'FileName' property of the receiver.
	Helpstring: The value of the filename parameter for the content-disposition MIME header."

	| answer |
	answer := BSTR new.
	self get_FileName: answer.
	^answer asObject!

get_BodyParts: varBodyParts
	"Private - Get the value of the 'BodyParts' property of the receiver.

		HRESULT __stdcall BodyParts(
			[out, retval]IBodyParts** varBodyParts);"

	<virtual stdcall: hresult 8 IBodyParts**>
	^self invalidCall: _failureCode!

get_Charset: pCharset
	"Private - Get the value of the 'Charset' property of the receiver.

		HRESULT __stdcall Charset(
			[out, retval]BSTR* pCharset);"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall: _failureCode!

get_ContentClass: pContentClass
	"Private - Get the value of the 'ContentClass' property of the receiver.

		HRESULT __stdcall ContentClass(
			[out, retval]BSTR* pContentClass);"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall: _failureCode!

get_ContentClassName: pContentClassName
	"Private - Get the value of the 'ContentClassName' property of the receiver.

		HRESULT __stdcall ContentClassName(
			[out, retval]BSTR* pContentClassName);"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_ContentMediaType: pContentMediaType
	"Private - Get the value of the 'ContentMediaType' property of the receiver.

		HRESULT __stdcall ContentMediaType(
			[out, retval]BSTR* pContentMediaType);"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_ContentTransferEncoding: pContentTransferEncoding
	"Private - Get the value of the 'ContentTransferEncoding' property of the receiver.

		HRESULT __stdcall ContentTransferEncoding(
			[out, retval]BSTR* pContentTransferEncoding);"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_DataSource: varDataSource
	"Private - Get the value of the 'DataSource' property of the receiver.

		HRESULT __stdcall DataSource(
			[out, retval]IDataSource** varDataSource);"

	<virtual stdcall: hresult 17 IDataSource**>
	^self invalidCall: _failureCode!

get_Fields: varFields
	"Private - Get the value of the 'Fields' property of the receiver.

		HRESULT __stdcall Fields(
			[out, retval]Fields** varFields);"

	<virtual stdcall: hresult 13 ADODB.Fields**>
	^self invalidCall: _failureCode!

get_FileName: varFileName
	"Private - Get the value of the 'FileName' property of the receiver.

		HRESULT __stdcall FileName(
			[out, retval]BSTR* varFileName);"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

get_Parent: varParent
	"Private - Get the value of the 'Parent' property of the receiver.

		HRESULT __stdcall Parent(
			[out, retval]IBodyPart** varParent);"

	<virtual stdcall: hresult 22 IBodyPart**>
	^self invalidCall: _failureCode!

getDecodedContentStream
	"Answer the <ADODB._Stream> result of invoking the GetDecodedContentStream() method of the COM object.
	Helpstring: Returns a Stream object containing the body part content in decoded format."

	| answer |
	answer := ADODB._Stream newPointer.
	self GetDecodedContentStream: answer.
	^answer asObject!

GetDecodedContentStream: ppStream
	"Private - Invoke the GetDecodedContentStream() method of the COM object.
	Helpstring: Returns a Stream object containing the body part content in decoded format.

		HRESULT __stdcall GetDecodedContentStream(
			[out, retval]_Stream** ppStream);"

	<virtual stdcall: hresult 26 ADODB._Stream**>
	^self invalidCall: _failureCode!

getEncodedContentStream
	"Answer the <ADODB._Stream> result of invoking the GetEncodedContentStream() method of the COM object.
	Helpstring: Returns a Stream object containing the body part content in encoded format. The encoding method is specified in the ContentTransferEncoding property."

	| answer |
	answer := ADODB._Stream newPointer.
	self GetEncodedContentStream: answer.
	^answer asObject!

GetEncodedContentStream: ppStream
	"Private - Invoke the GetEncodedContentStream() method of the COM object.
	Helpstring: Returns a Stream object containing the body part content in encoded format. The encoding method is specified in the ContentTransferEncoding property.

		HRESULT __stdcall GetEncodedContentStream(
			[out, retval]_Stream** ppStream);"

	<virtual stdcall: hresult 25 ADODB._Stream**>
	^self invalidCall: _failureCode!

getFieldParameter: fieldName parameter: parameter
	"Answer the <bstr> result of invoking the GetFieldParameter() method of the COM object.
	Helpstring: Returns the specified parameter from the body part's specified header field."

	| answer |
	answer := BSTR new.
	self
		GetFieldParameter: fieldName
		Parameter: parameter
		pbstrValue: answer.
	^answer asObject!

GetFieldParameter: fieldName Parameter: parameter pbstrValue: pbstrValue
	"Private - Invoke the GetFieldParameter() method of the COM object.
	Helpstring: Returns the specified parameter from the body part's specified header field.

		HRESULT __stdcall GetFieldParameter(
			[in]BSTR FieldName,
			[in]BSTR Parameter,
			[out, retval]BSTR* pbstrValue);"

	<virtual stdcall: hresult 28 bstr bstr bstr*>
	^self invalidCall: _failureCode!

getInterface: interface
	"Answer the <IDispatch> result of invoking the GetInterface() method of the COM object.
	Helpstring: Returns a specified interface on this object; provided for script languages."

	| answer |
	answer := IDispatch newPointer.
	self GetInterface: interface ppUnknown: answer.
	^answer asObject!

GetInterface: interface ppUnknown: ppUnknown
	"Private - Invoke the GetInterface() method of the COM object.
	Helpstring: Returns a specified interface on this object; provided for script languages.

		HRESULT __stdcall GetInterface(
			[in]BSTR Interface,
			[out, retval]IDispatch** ppUnknown);"

	<virtual stdcall: hresult 29 bstr IDispatch**>
	^self invalidCall: _failureCode!

getStream
	"Answer the <ADODB._Stream> result of invoking the GetStream() method of the COM object.
	Helpstring: Returns an ADO Stream object containing the body part in serialized, MIME encoded format."

	| answer |
	answer := ADODB._Stream newPointer.
	self GetStream: answer.
	^answer asObject!

GetStream: ppStream
	"Private - Invoke the GetStream() method of the COM object.
	Helpstring: Returns an ADO Stream object containing the body part in serialized, MIME encoded format.

		HRESULT __stdcall GetStream(
			[out, retval]_Stream** ppStream);"

	<virtual stdcall: hresult 27 ADODB._Stream**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

parent
	"Answer the <IBodyPart> value of the 'Parent' property of the receiver.
	Helpstring: The object's parent object in the body part hierarchy."

	| answer |
	answer := IBodyPart newPointer.
	self get_Parent: answer.
	^answer asObject!

put_Charset: pCharset
	"Private - Set the value of the 'Charset' property of the object wrapped by the 
	 receiver to the <bstr> argument, pCharset.

		HRESULT __stdcall Charset(
			[in]BSTR pCharset);"

	<virtual stdcall: hresult 15 bstr>
	^self invalidCall: _failureCode!

put_ContentClass: pContentClass
	"Private - Set the value of the 'ContentClass' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentClass.

		HRESULT __stdcall ContentClass(
			[in]BSTR pContentClass);"

	<virtual stdcall: hresult 19 bstr>
	^self invalidCall: _failureCode!

put_ContentClassName: pContentClassName
	"Private - Set the value of the 'ContentClassName' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentClassName.

		HRESULT __stdcall ContentClassName(
			[in]BSTR pContentClassName);"

	<virtual stdcall: hresult 21 bstr>
	^self invalidCall: _failureCode!

put_ContentMediaType: pContentMediaType
	"Private - Set the value of the 'ContentMediaType' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentMediaType.

		HRESULT __stdcall ContentMediaType(
			[in]BSTR pContentMediaType);"

	<virtual stdcall: hresult 12 bstr>
	^self invalidCall: _failureCode!

put_ContentTransferEncoding: pContentTransferEncoding
	"Private - Set the value of the 'ContentTransferEncoding' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentTransferEncoding.

		HRESULT __stdcall ContentTransferEncoding(
			[in]BSTR pContentTransferEncoding);"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

SaveToFile: fileName
	"Invoke the SaveToFile() method of the COM object.
	Helpstring: Saves the body part content to the specified file.

		HRESULT __stdcall SaveToFile(
			[in]BSTR FileName);"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall: _failureCode! !
!CDO.IBodyPart categoriesForMethods!
addBodyPart!**auto generated**!methods!public! !
addBodyPart:!**auto generated**!methods!public! !
AddBodyPart:ppPart:!**auto generated**!COM Interfaces-IBodyPart!private! !
bodyParts!**auto generated**!properties!public! !
charset!**auto generated**!properties!public! !
charset:!**auto generated**!properties!public! !
contentClass!**auto generated**!properties!public! !
contentClass:!**auto generated**!properties!public! !
contentClassName!**auto generated**!properties!public! !
contentClassName:!**auto generated**!properties!public! !
contentMediaType!**auto generated**!properties!public! !
contentMediaType:!**auto generated**!properties!public! !
contentTransferEncoding!**auto generated**!properties!public! !
contentTransferEncoding:!**auto generated**!properties!public! !
dataSource!**auto generated**!properties!public! !
fields!properties!public! !
fileName!**auto generated**!properties!public! !
get_BodyParts:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_Charset:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_ContentClass:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_ContentClassName:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_ContentMediaType:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_ContentTransferEncoding:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_DataSource:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_Fields:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_FileName:!**auto generated**!COM Interfaces-IBodyPart!private! !
get_Parent:!**auto generated**!COM Interfaces-IBodyPart!private! !
getDecodedContentStream!**auto generated**!methods!public! !
GetDecodedContentStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
getEncodedContentStream!**auto generated**!methods!public! !
GetEncodedContentStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
getFieldParameter:parameter:!**auto generated**!methods!public! !
GetFieldParameter:Parameter:pbstrValue:!**auto generated**!COM Interfaces-IBodyPart!private! !
getInterface:!**auto generated**!methods!public! !
GetInterface:ppUnknown:!**auto generated**!COM Interfaces-IBodyPart!private! !
getStream!**auto generated**!methods!public! !
GetStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
isExtensible!**auto generated**!public!testing! !
isVBCollection!**auto generated**!public!testing! !
parent!**auto generated**!properties!public! !
put_Charset:!**auto generated**!COM Interfaces-IBodyPart!private! !
put_ContentClass:!**auto generated**!COM Interfaces-IBodyPart!private! !
put_ContentClassName:!**auto generated**!COM Interfaces-IBodyPart!private! !
put_ContentMediaType:!**auto generated**!COM Interfaces-IBodyPart!private! !
put_ContentTransferEncoding:!**auto generated**!COM Interfaces-IBodyPart!private! !
SaveToFile:!**auto generated**!COM Interfaces-IBodyPart!public! !
!

!CDO.IBodyPart class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IBodyPart'
		IBodyPart defineTemplate"

	self
		defineFunction: #get_BodyParts:
			argumentTypes: 'IBodyParts**';
		defineFunction: #get_ContentTransferEncoding:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentTransferEncoding:
			argumentTypes: 'bstr';
		defineFunction: #get_ContentMediaType:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentMediaType:
			argumentTypes: 'bstr';
		defineFunction: #get_Fields:
			argumentTypes: 'ADODB.Fields**';
		defineFunction: #get_Charset:
			argumentTypes: 'bstr*';
		defineFunction: #put_Charset:
			argumentTypes: 'bstr';
		defineFunction: #get_FileName:
			argumentTypes: 'bstr*';
		defineFunction: #get_DataSource:
			argumentTypes: 'IDataSource**';
		defineFunction: #get_ContentClass:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentClass:
			argumentTypes: 'bstr';
		defineFunction: #get_ContentClassName:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentClassName:
			argumentTypes: 'bstr';
		defineFunction: #get_Parent:
			argumentTypes: 'IBodyPart**';
		defineFunction: #AddBodyPart:ppPart:
			argumentTypes: 'sdword IBodyPart**';
		defineFunction: #SaveToFile:
			argumentTypes: 'bstr';
		defineFunction: #GetEncodedContentStream:
			argumentTypes: 'ADODB._Stream**';
		defineFunction: #GetDecodedContentStream:
			argumentTypes: 'ADODB._Stream**';
		defineFunction: #GetStream:
			argumentTypes: 'ADODB._Stream**';
		defineFunction: #GetFieldParameter:Parameter:pbstrValue:
			argumentTypes: 'bstr bstr bstr*';
		defineFunction: #GetInterface:ppUnknown:
			argumentTypes: 'bstr IDispatch**'
! !
!CDO.IBodyPart class categoriesForMethods!
defineFunctions!**auto generated**!initializing!private! !
!

