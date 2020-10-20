"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIBodyPart
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIBodyPart guid: (IID fromString: '{cd000021-8b95-11d1-82db-00c04fb1625d}')!
CDOIBodyPart comment: '<CDOIBodyPart> is a wrapper class for the COM interface ''CDO.IBodyPart'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a message body part"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIBodyPart categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIBodyPart methodsFor!

addBodyPart: index
	"Answer the <CDOIBodyPart> result of invoking the COM Object's AddBodyPart() method.
	Helpstring: 'Adds a body part to the object''s BodyParts collection.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		AddBodyPart: index
		ppPart: answer.
	^answer asObject
!

AddBodyPart: index ppPart: ppPart
	"Private - Invoke the AddBodyPart() method of the COM object wrapped by the receiver.
	Helpstring: 'Adds a body part to the object''s BodyParts collection.'

		HRESULT __stdcall AddBodyPart(
			[in, optional, defaultvalue(-1)] long Index,
			[out, retval] IBodyPart** ppPart);
	"

	<virtual stdcall: hresult 23 sdword CDOIBodyPart**>
	^self invalidCall: _failureCode!

bodyParts
	"Answer the <CDOIBodyParts> value of the 'BodyParts' property of the receiver.
	Helpstring: 'The object''s BodyParts collection.'"

	| answer |
	answer := CDOIBodyParts newPointer.
	self
		get_BodyParts: answer.
	^answer asObject
!

charset
	"Answer the <bstr> value of the 'Charset' property of the receiver.
	Helpstring: 'The character set of the body part''s text content (not applicable for non-text content types).'"

	| answer |
	answer := BSTR new.
	self
		get_Charset: answer.
	^answer asObject
!

charset: pCharset
	"Set the 'Charset' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The character set of the body part''s text content (not applicable for non-text content types).'"

	self
		put_Charset: pCharset
!

contentClass
	"Answer the <bstr> value of the 'ContentClass' property of the receiver.
	Helpstring: 'The body part''s content class.'"

	| answer |
	answer := BSTR new.
	self
		get_ContentClass: answer.
	^answer asObject
!

contentClass: pContentClass
	"Set the 'ContentClass' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The body part''s content class.'"

	self
		put_ContentClass: pContentClass
!

contentClassName
	"Answer the <bstr> value of the 'ContentClassName' property of the receiver.
	Helpstring: 'Deprecated. Do not use.'"

	| answer |
	answer := BSTR new.
	self
		get_ContentClassName: answer.
	^answer asObject
!

contentClassName: pContentClassName
	"Set the 'ContentClassName' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'Deprecated. Do not use.'"

	self
		put_ContentClassName: pContentClassName
!

contentMediaType
	"Answer the <bstr> value of the 'ContentMediaType' property of the receiver.
	Helpstring: 'The content media type portion of the body part''s content type.'"

	| answer |
	answer := BSTR new.
	self
		get_ContentMediaType: answer.
	^answer asObject
!

contentMediaType: pContentMediaType
	"Set the 'ContentMediaType' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The content media type portion of the body part''s content type.'"

	self
		put_ContentMediaType: pContentMediaType
!

contentTransferEncoding
	"Answer the <bstr> value of the 'ContentTransferEncoding' property of the receiver.
	Helpstring: 'The method used to encode the body part content. For example, quoted-printable or base64.'"

	| answer |
	answer := BSTR new.
	self
		get_ContentTransferEncoding: answer.
	^answer asObject
!

contentTransferEncoding: pContentTransferEncoding
	"Set the 'ContentTransferEncoding' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The method used to encode the body part content. For example, quoted-printable or base64.'"

	self
		put_ContentTransferEncoding: pContentTransferEncoding
!

dataSource
	"Answer the <CDOIDataSource> value of the 'DataSource' property of the receiver.
	Helpstring: 'The object''s IDataSource interface.'"

	| answer |
	answer := CDOIDataSource newPointer.
	self
		get_DataSource: answer.
	^answer asObject
!

fields
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	Helpstring: 'Returns the Fields collection for the body part'
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODBFields newPointer.
	self get_Fields: answer.
	^ADOCollection on: answer
!

fileName
	"Answer the <bstr> value of the 'FileName' property of the receiver.
	Helpstring: 'The value of the filename parameter for the content-disposition MIME header.'"

	| answer |
	answer := BSTR new.
	self
		get_FileName: answer.
	^answer asObject
!

get_BodyParts: varBodyParts
	"Private - Get the value of the 'BodyParts' property of the receiver.
	Helpstring: 'The object''s BodyParts collection.'

		HRESULT __stdcall BodyParts(
			[out, retval] IBodyParts** varBodyParts);
	"

	<virtual stdcall: hresult 8 CDOIBodyParts**>
	^self invalidCall: _failureCode!

get_Charset: pCharset
	"Private - Get the value of the 'Charset' property of the receiver.
	Helpstring: 'The character set of the body part''s text content (not applicable for non-text content types).'

		HRESULT __stdcall Charset(
			[out, retval] BSTR* pCharset);
	"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall: _failureCode!

get_ContentClass: pContentClass
	"Private - Get the value of the 'ContentClass' property of the receiver.
	Helpstring: 'The body part''s content class.'

		HRESULT __stdcall ContentClass(
			[out, retval] BSTR* pContentClass);
	"

	<virtual stdcall: hresult 18 bstr*>
	^self invalidCall: _failureCode!

get_ContentClassName: pContentClassName
	"Private - Get the value of the 'ContentClassName' property of the receiver.
	Helpstring: 'Deprecated. Do not use.'

		HRESULT __stdcall ContentClassName(
			[out, retval] BSTR* pContentClassName);
	"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_ContentMediaType: pContentMediaType
	"Private - Get the value of the 'ContentMediaType' property of the receiver.
	Helpstring: 'The content media type portion of the body part''s content type.'

		HRESULT __stdcall ContentMediaType(
			[out, retval] BSTR* pContentMediaType);
	"

	<virtual stdcall: hresult 11 bstr*>
	^self invalidCall: _failureCode!

get_ContentTransferEncoding: pContentTransferEncoding
	"Private - Get the value of the 'ContentTransferEncoding' property of the receiver.
	Helpstring: 'The method used to encode the body part content. For example, quoted-printable or base64.'

		HRESULT __stdcall ContentTransferEncoding(
			[out, retval] BSTR* pContentTransferEncoding);
	"

	<virtual stdcall: hresult 9 bstr*>
	^self invalidCall: _failureCode!

get_DataSource: varDataSource
	"Private - Get the value of the 'DataSource' property of the receiver.
	Helpstring: 'The object''s IDataSource interface.'

		HRESULT __stdcall DataSource(
			[out, retval] IDataSource** varDataSource);
	"

	<virtual stdcall: hresult 17 CDOIDataSource**>
	^self invalidCall: _failureCode!

get_Fields: varFields
	"Private - Get the value of the 'Fields' property of the receiver.
	Helpstring: 'The object''s Fields collection.'

		HRESULT __stdcall Fields(
			[out, retval] Fields** varFields);
	"

	<virtual stdcall: hresult 13 ADODBFields**>
	^self invalidCall: _failureCode!

get_FileName: varFileName
	"Private - Get the value of the 'FileName' property of the receiver.
	Helpstring: 'The value of the filename parameter for the content-disposition MIME header.'

		HRESULT __stdcall FileName(
			[out, retval] BSTR* varFileName);
	"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

get_Parent: varParent
	"Private - Get the value of the 'Parent' property of the receiver.
	Helpstring: 'The object''s parent object in the body part hierarchy.'

		HRESULT __stdcall Parent(
			[out, retval] IBodyPart** varParent);
	"

	<virtual stdcall: hresult 22 CDOIBodyPart**>
	^self invalidCall: _failureCode!

getDecodedContentStream
	"Answer the <ADODB_Stream> result of invoking the COM Object's GetDecodedContentStream() method.
	Helpstring: 'Returns a Stream object containing the body part content in decoded format.'"

	| answer |
	answer := ADODB_Stream newPointer.
	self
		GetDecodedContentStream: answer.
	^answer asObject
!

GetDecodedContentStream: ppStream
	"Private - Invoke the GetDecodedContentStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Stream object containing the body part content in decoded format.'

		HRESULT __stdcall GetDecodedContentStream(
			[out, retval] _Stream** ppStream);
	"

	<virtual stdcall: hresult 26 ADODB_Stream**>
	^self invalidCall: _failureCode!

getEncodedContentStream
	"Answer the <ADODB_Stream> result of invoking the COM Object's GetEncodedContentStream() method.
	Helpstring: 'Returns a Stream object containing the body part content in encoded format. The encoding method is specified in the ContentTransferEncoding property.'"

	| answer |
	answer := ADODB_Stream newPointer.
	self
		GetEncodedContentStream: answer.
	^answer asObject
!

GetEncodedContentStream: ppStream
	"Private - Invoke the GetEncodedContentStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Stream object containing the body part content in encoded format. The encoding method is specified in the ContentTransferEncoding property.'

		HRESULT __stdcall GetEncodedContentStream(
			[out, retval] _Stream** ppStream);
	"

	<virtual stdcall: hresult 25 ADODB_Stream**>
	^self invalidCall: _failureCode!

getFieldParameter: fieldName parameter: parameter
	"Answer the <BSTR> result of invoking the COM Object's GetFieldParameter() method.
	Helpstring: 'Returns the specified parameter from the body part''s specified header field.'"

	| answer |
	answer := BSTR new.
	self
		GetFieldParameter: fieldName
		Parameter: parameter
		pbstrValue: answer.
	^answer asObject
!

GetFieldParameter: fieldName Parameter: parameter pbstrValue: pbstrValue
	"Private - Invoke the GetFieldParameter() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns the specified parameter from the body part''s specified header field.'

		HRESULT __stdcall GetFieldParameter(
			[in] BSTR FieldName,
			[in] BSTR Parameter,
			[out, retval] BSTR* pbstrValue);
	"

	<virtual stdcall: hresult 28 bstr bstr bstr*>
	^self invalidCall: _failureCode!

getInterface: interface
	"Answer the <IDispatch> result of invoking the COM Object's GetInterface() method.
	Helpstring: 'Returns a specified interface on this object; provided for script languages.'"

	| answer |
	answer := IDispatch newPointer.
	self
		GetInterface: interface
		ppUnknown: answer.
	^answer asObject
!

GetInterface: interface ppUnknown: ppUnknown
	"Private - Invoke the GetInterface() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a specified interface on this object; provided for script languages.'

		HRESULT __stdcall GetInterface(
			[in] BSTR Interface,
			[out, retval] IDispatch** ppUnknown);
	"

	<virtual stdcall: hresult 29 bstr IDispatch**>
	^self invalidCall: _failureCode!

getStream
	"Answer the <ADODB_Stream> result of invoking the COM Object's GetStream() method.
	Helpstring: 'Returns an ADO Stream object containing the body part in serialized, MIME encoded format.'"

	| answer |
	answer := ADODB_Stream newPointer.
	self
		GetStream: answer.
	^answer asObject
!

GetStream: ppStream
	"Private - Invoke the GetStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns an ADO Stream object containing the body part in serialized, MIME encoded format.'

		HRESULT __stdcall GetStream(
			[out, retval] _Stream** ppStream);
	"

	<virtual stdcall: hresult 27 ADODB_Stream**>
	^self invalidCall: _failureCode!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

parent
	"Answer the <CDOIBodyPart> value of the 'Parent' property of the receiver.
	Helpstring: 'The object''s parent object in the body part hierarchy.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		get_Parent: answer.
	^answer asObject
!

put_Charset: pCharset
	"Private - Set the value of the 'Charset' property of the object wrapped by the 
	 receiver to the <bstr> argument, pCharset.
	Helpstring: 'The character set of the body part''s text content (not applicable for non-text content types).'

		HRESULT __stdcall Charset(
			[in] BSTR pCharset);
	"

	<virtual stdcall: hresult 15 bstr>
	^self invalidCall: _failureCode!

put_ContentClass: pContentClass
	"Private - Set the value of the 'ContentClass' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentClass.
	Helpstring: 'The body part''s content class.'

		HRESULT __stdcall ContentClass(
			[in] BSTR pContentClass);
	"

	<virtual stdcall: hresult 19 bstr>
	^self invalidCall: _failureCode!

put_ContentClassName: pContentClassName
	"Private - Set the value of the 'ContentClassName' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentClassName.
	Helpstring: 'Deprecated. Do not use.'

		HRESULT __stdcall ContentClassName(
			[in] BSTR pContentClassName);
	"

	<virtual stdcall: hresult 21 bstr>
	^self invalidCall: _failureCode!

put_ContentMediaType: pContentMediaType
	"Private - Set the value of the 'ContentMediaType' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentMediaType.
	Helpstring: 'The content media type portion of the body part''s content type.'

		HRESULT __stdcall ContentMediaType(
			[in] BSTR pContentMediaType);
	"

	<virtual stdcall: hresult 12 bstr>
	^self invalidCall: _failureCode!

put_ContentTransferEncoding: pContentTransferEncoding
	"Private - Set the value of the 'ContentTransferEncoding' property of the object wrapped by the 
	 receiver to the <bstr> argument, pContentTransferEncoding.
	Helpstring: 'The method used to encode the body part content. For example, quoted-printable or base64.'

		HRESULT __stdcall ContentTransferEncoding(
			[in] BSTR pContentTransferEncoding);
	"

	<virtual stdcall: hresult 10 bstr>
	^self invalidCall: _failureCode!

SaveToFile: fileName
	"Invoke the SaveToFile() method of the COM object wrapped by the receiver.
	Helpstring: 'Saves the body part content to the specified file.'

		HRESULT __stdcall SaveToFile(
			[in] BSTR FileName);
	"

	<virtual stdcall: hresult 24 bstr>
	^self invalidCall: _failureCode! !
!CDOIBodyPart categoriesFor: #addBodyPart:!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #AddBodyPart:ppPart:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #bodyParts!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #charset!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #charset:!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentClass!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentClass:!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentClassName!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentClassName:!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentMediaType!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentMediaType:!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentTransferEncoding!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #contentTransferEncoding:!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #dataSource!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #fields!properties!public! !
!CDOIBodyPart categoriesFor: #fileName!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #get_BodyParts:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_Charset:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_ContentClass:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_ContentClassName:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_ContentMediaType:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_ContentTransferEncoding:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_DataSource:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_Fields:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_FileName:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #get_Parent:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #getDecodedContentStream!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #GetDecodedContentStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #getEncodedContentStream!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #GetEncodedContentStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #getFieldParameter:parameter:!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #GetFieldParameter:Parameter:pbstrValue:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #getInterface:!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #GetInterface:ppUnknown:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #getStream!**auto generated**!methods!public! !
!CDOIBodyPart categoriesFor: #GetStream:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIBodyPart categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOIBodyPart categoriesFor: #parent!**auto generated**!properties!public! !
!CDOIBodyPart categoriesFor: #put_Charset:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #put_ContentClass:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #put_ContentClassName:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #put_ContentMediaType:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #put_ContentTransferEncoding:!**auto generated**!COM Interfaces-IBodyPart!private! !
!CDOIBodyPart categoriesFor: #SaveToFile:!**auto generated**!COM Interfaces-IBodyPart!public! !

!CDOIBodyPart class methodsFor!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IBodyPart'
		CDOIBodyPart defineTemplate
	"

	self
		defineFunction: #get_BodyParts:
			argumentTypes: 'CDOIBodyParts**';
		defineFunction: #get_ContentTransferEncoding:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentTransferEncoding:
			argumentTypes: 'bstr';
		defineFunction: #get_ContentMediaType:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentMediaType:
			argumentTypes: 'bstr';
		defineFunction: #get_Fields:
			argumentTypes: 'ADODBFields**';
		defineFunction: #get_Charset:
			argumentTypes: 'bstr*';
		defineFunction: #put_Charset:
			argumentTypes: 'bstr';
		defineFunction: #get_FileName:
			argumentTypes: 'bstr*';
		defineFunction: #get_DataSource:
			argumentTypes: 'CDOIDataSource**';
		defineFunction: #get_ContentClass:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentClass:
			argumentTypes: 'bstr';
		defineFunction: #get_ContentClassName:
			argumentTypes: 'bstr*';
		defineFunction: #put_ContentClassName:
			argumentTypes: 'bstr';
		defineFunction: #get_Parent:
			argumentTypes: 'CDOIBodyPart**';
		defineFunction: #AddBodyPart:ppPart:
			argumentTypes: 'sdword CDOIBodyPart**';
		defineFunction: #SaveToFile:
			argumentTypes: 'bstr';
		defineFunction: #GetEncodedContentStream:
			argumentTypes: 'ADODB_Stream**';
		defineFunction: #GetDecodedContentStream:
			argumentTypes: 'ADODB_Stream**';
		defineFunction: #GetStream:
			argumentTypes: 'ADODB_Stream**';
		defineFunction: #GetFieldParameter:Parameter:pbstrValue:
			argumentTypes: 'bstr bstr bstr*';
		defineFunction: #GetInterface:ppUnknown:
			argumentTypes: 'bstr IDispatch**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIBodyPart initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIBodyPart class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIBodyPart class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

