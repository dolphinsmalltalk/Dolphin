"Filed out from Dolphin Smalltalk 7"!

IDispatch subclass: #CDOIMessage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CDOConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
CDOIMessage guid: (IID fromString: '{cd000020-8b95-11d1-82db-00c04fb1625d}')!
CDOIMessage comment: '<CDOIMessage> is a wrapper class for the COM interface ''CDO.IMessage'' generated from type information in the ''Microsoft CDO for Windows 2000 Library'' library. It contains methods to invoke the member functions exposed by that interface.

The type library contains the following helpstring for this interface
	"Defines abstract methods and properties used to manage a complete message"

Warning: This comment was automatically generated from the interface''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.'!
!CDOIMessage categoriesForClass!CDO-Interfaces!COM-Interfaces! !
!CDOIMessage methodsFor!

addAttachment: url userName: userName password: password
	"Answer the <CDOIBodyPart> result of invoking the COM Object's AddAttachment() method.
	Helpstring: 'Adds an attachment (BodyPart) to the message.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		AddAttachment: url
		UserName: userName
		Password: password
		ppBody: answer.
	^answer asObject
!

AddAttachment: url UserName: userName Password: password ppBody: ppBody
	"Private - Invoke the AddAttachment() method of the COM object wrapped by the receiver.
	Helpstring: 'Adds an attachment (BodyPart) to the message.'

		HRESULT __stdcall AddAttachment(
			[in] BSTR URL,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password,
			[out, retval] IBodyPart** ppBody);
	"

	<virtual stdcall: hresult 55 bstr bstr bstr CDOIBodyPart**>
	^self invalidCall: _failureCode!

addRelatedBodyPart: url reference: reference referenceType: referenceType userName: userName password: password
	"Answer the <CDOIBodyPart> result of invoking the COM Object's AddRelatedBodyPart() method.
	Helpstring: 'Adds a BodyPart object with content referenced within the text/html portion of the message body.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		AddRelatedBodyPart: url
		Reference: reference
		ReferenceType: referenceType
		UserName: userName
		Password: password
		ppBody: answer.
	^answer asObject
!

AddRelatedBodyPart: url Reference: reference ReferenceType: referenceType UserName: userName Password: password ppBody: ppBody
	"Private - Invoke the AddRelatedBodyPart() method of the COM object wrapped by the receiver.
	Helpstring: 'Adds a BodyPart object with content referenced within the text/html portion of the message body.'

		HRESULT __stdcall AddRelatedBodyPart(
			[in] BSTR URL,
			[in] BSTR Reference,
			[in] CdoReferenceType ReferenceType,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password,
			[out, retval] IBodyPart** ppBody);
	"

	<virtual stdcall: hresult 54 bstr bstr sdword bstr bstr CDOIBodyPart**>
	^self invalidCall: _failureCode!

attachments
	"Answer the <CDOIBodyParts> value of the 'Attachments' property of the receiver.
	Helpstring: 'The object''s Attachments collection.'"

	| answer |
	answer := CDOIBodyParts newPointer.
	self
		get_Attachments: answer.
	^answer asObject
!

autoGenerateTextBody
	"Answer the <varbool> value of the 'AutoGenerateTextBody' property of the receiver.
	Helpstring: 'Indicates whether a text/plain alternate representation should automatically be generated from the text/html part of the message body.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_AutoGenerateTextBody: answer.
	^answer asObject
!

autoGenerateTextBody: pAutoGenerateTextBody
	"Set the 'AutoGenerateTextBody' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Indicates whether a text/plain alternate representation should automatically be generated from the text/html part of the message body.'"

	self
		put_AutoGenerateTextBody: pAutoGenerateTextBody
!

bcc
	"Answer the <bstr> value of the 'BCC' property of the receiver.
	Helpstring: 'The message''s hidden carbon copy (BCC header) recipients.'"

	| answer |
	answer := BSTR new.
	self
		get_BCC: answer.
	^answer asObject
!

bcc: pBCC
	"Set the 'BCC' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s hidden carbon copy (BCC header) recipients.'"

	self
		put_BCC: pBCC
!

bodyPart
	"Answer the <CDOIBodyPart> value of the 'BodyPart' property of the receiver.
	Helpstring: 'The object''s IBodyPart interface.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		get_BodyPart: answer.
	^answer asObject
!

cc
	"Answer the <bstr> value of the 'CC' property of the receiver.
	Helpstring: 'The message''s secondary (CC header) recipients.'"

	| answer |
	answer := BSTR new.
	self
		get_CC: answer.
	^answer asObject
!

cc: pCC
	"Set the 'CC' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s secondary (CC header) recipients.'"

	self
		put_CC: pCC
!

configuration
	"Answer the <CDOIConfiguration> value of the 'Configuration' property of the receiver.
	Helpstring: 'The object''s Configuration object.'"

	| answer |
	answer := CDOIConfiguration newPointer.
	self
		get_Configuration: answer.
	^answer asObject
!

configuration: pConfiguration
	"Set the 'Configuration' property of the receiver to the <CDOIConfiguration*> value of the argument.
	Helpstring: 'The object''s Configuration object.'"

	self
		put_Configuration: pConfiguration
!

CreateMHTMLBody: url Flags: flags UserName: userName Password: password
	"Invoke the CreateMHTMLBody() method of the COM object wrapped by the receiver.
	Helpstring: 'Creates an MHTML-formatted message body using the resource(s) at the specified URL.'

		HRESULT __stdcall CreateMHTMLBody(
			[in] BSTR URL,
			[in, optional, defaultvalue(0)] CdoMHTMLFlags Flags,
			[in, optional] BSTR UserName,
			[in, optional] BSTR Password);
	"

	<virtual stdcall: hresult 56 bstr sdword bstr bstr>
	^self invalidCall: _failureCode!

dataSource
	"Answer the <CDOIDataSource> value of the 'DataSource' property of the receiver.
	Helpstring: 'The object''s IDataSource interface.'"

	| answer |
	answer := CDOIDataSource newPointer.
	self
		get_DataSource: answer.
	^answer asObject
!

dsnOptions
	"Answer the <sdword> value of the 'DSNOptions' property of the receiver.
	Helpstring: 'The delivery status notification (DSN) options for the message.'"

	| answer |
	answer := (SDWORD new).
	self
		get_DSNOptions: answer.
	^answer asObject
!

dsnOptions: pDSNOptions
	"Set the 'DSNOptions' property of the receiver to the <sdword> value of the argument.
	Helpstring: 'The delivery status notification (DSN) options for the message.'"

	self
		put_DSNOptions: pDSNOptions
!

envelopeFields
	"Answer the <ADODBFields> value of the 'EnvelopeFields' property of the receiver.
	Helpstring: 'Returns the transport envelope Fields collection for the message (transport event sinks only) '
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODBFields newPointer.
	self get_EnvelopeFields: answer.
	^ADOCollection on: answer

!

fields
	"Answer the <ADODBFields> value of the 'Fields' property of the receiver.
	Helpstring: 'Returns the Fields collection for the message'
	Implementation Note: Originally auto-generated from the ADO type library,
	this method has been modified to answer a Smalltalk <sequencedReadableCollection>."

	| answer |
	answer := ADODBFields newPointer.
	self get_Fields: answer.
	^ADOCollection on: answer

!

followUpTo
	"Answer the <bstr> value of the 'FollowUpTo' property of the receiver.
	Helpstring: 'The message''s follow-up recipients.'"

	| answer |
	answer := BSTR new.
	self
		get_FollowUpTo: answer.
	^answer asObject
!

followUpTo: pFollowUpTo
	"Set the 'FollowUpTo' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s follow-up recipients.'"

	self
		put_FollowUpTo: pFollowUpTo
!

forward
	"Answer the <CDOIMessage> result of invoking the COM Object's Forward() method.
	Helpstring: 'Returns a Message object used to forward a message.'"

	| answer |
	answer := CDOIMessage newPointer.
	self
		Forward: answer.
	^answer asObject
!

Forward: ppMsg
	"Private - Invoke the Forward() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Message object used to forward a message.'

		HRESULT __stdcall Forward(
			[out, retval] IMessage** ppMsg);
	"

	<virtual stdcall: hresult 57 CDOIMessage**>
	^self invalidCall: _failureCode!

from
	"Answer the <bstr> value of the 'From' property of the receiver.
	Helpstring: 'The message''s principle (From header) authors.'"

	| answer |
	answer := BSTR new.
	self
		get_From: answer.
	^answer asObject
!

from: pFrom
	"Set the 'From' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s principle (From header) authors.'"

	self
		put_From: pFrom
!

get_Attachments: varAttachments
	"Private - Get the value of the 'Attachments' property of the receiver.
	Helpstring: 'The object''s Attachments collection.'

		HRESULT __stdcall Attachments(
			[out, retval] IBodyParts** varAttachments);
	"

	<virtual stdcall: hresult 38 CDOIBodyParts**>
	^self invalidCall: _failureCode!

get_AutoGenerateTextBody: pAutoGenerateTextBody
	"Private - Get the value of the 'AutoGenerateTextBody' property of the receiver.
	Helpstring: 'Indicates whether a text/plain alternate representation should automatically be generated from the text/html part of the message body.'

		HRESULT __stdcall AutoGenerateTextBody(
			[out, retval] VARIANT_BOOL* pAutoGenerateTextBody);
	"

	<virtual stdcall: hresult 44 varbool*>
	^self invalidCall: _failureCode!

get_BCC: pBCC
	"Private - Get the value of the 'BCC' property of the receiver.
	Helpstring: 'The message''s hidden carbon copy (BCC header) recipients.'

		HRESULT __stdcall BCC(
			[out, retval] BSTR* pBCC);
	"

	<virtual stdcall: hresult 8 bstr*>
	^self invalidCall: _failureCode!

get_BodyPart: varBodyPart
	"Private - Get the value of the 'BodyPart' property of the receiver.
	Helpstring: 'The object''s IBodyPart interface.'

		HRESULT __stdcall BodyPart(
			[out, retval] IBodyPart** varBodyPart);
	"

	<virtual stdcall: hresult 49 CDOIBodyPart**>
	^self invalidCall: _failureCode!

get_CC: pCC
	"Private - Get the value of the 'CC' property of the receiver.
	Helpstring: 'The message''s secondary (CC header) recipients.'

		HRESULT __stdcall CC(
			[out, retval] BSTR* pCC);
	"

	<virtual stdcall: hresult 10 bstr*>
	^self invalidCall: _failureCode!

get_Configuration: pConfiguration
	"Private - Get the value of the 'Configuration' property of the receiver.
	Helpstring: 'The object''s Configuration object.'

		HRESULT __stdcall Configuration(
			[out, retval] IConfiguration** pConfiguration);
	"

	<virtual stdcall: hresult 41 CDOIConfiguration**>
	^self invalidCall: _failureCode!

get_DataSource: varDataSource
	"Private - Get the value of the 'DataSource' property of the receiver.
	Helpstring: 'The object''s IDataSource interface.'

		HRESULT __stdcall DataSource(
			[out, retval] IDataSource** varDataSource);
	"

	<virtual stdcall: hresult 50 CDOIDataSource**>
	^self invalidCall: _failureCode!

get_DSNOptions: pDSNOptions
	"Private - Get the value of the 'DSNOptions' property of the receiver.
	Helpstring: 'The delivery status notification (DSN) options for the message.'

		HRESULT __stdcall DSNOptions(
			[out, retval] CdoDSNOptions* pDSNOptions);
	"

	<virtual stdcall: hresult 27 sdword*>
	^self invalidCall: _failureCode!

get_EnvelopeFields: varEnvelopeFields
	"Private - Get the value of the 'EnvelopeFields' property of the receiver.
	Helpstring: 'The transport envelope Fields collection for the message (transport event sinks only).'

		HRESULT __stdcall EnvelopeFields(
			[out, retval] Fields** varEnvelopeFields);
	"

	<virtual stdcall: hresult 46 ADODBFields**>
	^self invalidCall: _failureCode!

get_Fields: varFields
	"Private - Get the value of the 'Fields' property of the receiver.
	Helpstring: 'The object''s Fields collection.'

		HRESULT __stdcall Fields(
			[out, retval] Fields** varFields);
	"

	<virtual stdcall: hresult 51 ADODBFields**>
	^self invalidCall: _failureCode!

get_FollowUpTo: pFollowUpTo
	"Private - Get the value of the 'FollowUpTo' property of the receiver.
	Helpstring: 'The message''s follow-up recipients.'

		HRESULT __stdcall FollowUpTo(
			[out, retval] BSTR* pFollowUpTo);
	"

	<virtual stdcall: hresult 12 bstr*>
	^self invalidCall: _failureCode!

get_From: pFrom
	"Private - Get the value of the 'From' property of the receiver.
	Helpstring: 'The message''s principle (From header) authors.'

		HRESULT __stdcall From(
			[out, retval] BSTR* pFrom);
	"

	<virtual stdcall: hresult 14 bstr*>
	^self invalidCall: _failureCode!

get_HTMLBody: pHTMLBody
	"Private - Get the value of the 'HTMLBody' property of the receiver.
	Helpstring: 'The text/html portion of the message body.'

		HRESULT __stdcall HTMLBody(
			[out, retval] BSTR* pHTMLBody);
	"

	<virtual stdcall: hresult 36 bstr*>
	^self invalidCall: _failureCode!

get_HTMLBodyPart: varHTMLBodyPart
	"Private - Get the value of the 'HTMLBodyPart' property of the receiver.
	Helpstring: 'Returns the BodyPart object (IBodyPart interface) containing the text/html portion of the message body.'

		HRESULT __stdcall HTMLBodyPart(
			[out, retval] IBodyPart** varHTMLBodyPart);
	"

	<virtual stdcall: hresult 48 CDOIBodyPart**>
	^self invalidCall: _failureCode!

get_Keywords: pKeywords
	"Private - Get the value of the 'Keywords' property of the receiver.
	Helpstring: 'The message''s keywords.'

		HRESULT __stdcall Keywords(
			[out, retval] BSTR* pKeywords);
	"

	<virtual stdcall: hresult 16 bstr*>
	^self invalidCall: _failureCode!

get_MDNRequested: pMDNRequested
	"Private - Get the value of the 'MDNRequested' property of the receiver.
	Helpstring: 'Indicates whether a mail delivery notification (MDN) should be sent when the message is received.'

		HRESULT __stdcall MDNRequested(
			[out, retval] VARIANT_BOOL* pMDNRequested);
	"

	<virtual stdcall: hresult 52 varbool*>
	^self invalidCall: _failureCode!

get_MimeFormatted: pMimeFormatted
	"Private - Get the value of the 'MimeFormatted' property of the receiver.
	Helpstring: 'Indicates whether the message is to be serialized using the MIME (True) or UUENCODE (False) format.'

		HRESULT __stdcall MimeFormatted(
			[out, retval] VARIANT_BOOL* pMimeFormatted);
	"

	<virtual stdcall: hresult 18 varbool*>
	^self invalidCall: _failureCode!

get_Newsgroups: pNewsgroups
	"Private - Get the value of the 'Newsgroups' property of the receiver.
	Helpstring: 'The message''s newsgroup (Newsgroups header) recipients.'

		HRESULT __stdcall Newsgroups(
			[out, retval] BSTR* pNewsgroups);
	"

	<virtual stdcall: hresult 20 bstr*>
	^self invalidCall: _failureCode!

get_Organization: pOrganization
	"Private - Get the value of the 'Organization' property of the receiver.
	Helpstring: 'The sender''s organization name.'

		HRESULT __stdcall Organization(
			[out, retval] BSTR* pOrganization);
	"

	<virtual stdcall: hresult 22 bstr*>
	^self invalidCall: _failureCode!

get_ReceivedTime: varReceivedTime
	"Private - Get the value of the 'ReceivedTime' property of the receiver.
	Helpstring: 'The date and time the message was received.'

		HRESULT __stdcall ReceivedTime(
			[out, retval] DATE* varReceivedTime);
	"

	<virtual stdcall: hresult 24 date*>
	^self invalidCall: _failureCode!

get_ReplyTo: pReplyTo
	"Private - Get the value of the 'ReplyTo' property of the receiver.
	Helpstring: 'The email addresses (Reply-To header) to which to reply.'

		HRESULT __stdcall ReplyTo(
			[out, retval] BSTR* pReplyTo);
	"

	<virtual stdcall: hresult 25 bstr*>
	^self invalidCall: _failureCode!

get_Sender: pSender
	"Private - Get the value of the 'Sender' property of the receiver.
	Helpstring: 'The message''s actual sender.'

		HRESULT __stdcall Sender(
			[out, retval] BSTR* pSender);
	"

	<virtual stdcall: hresult 39 bstr*>
	^self invalidCall: _failureCode!

get_SentOn: varSentOn
	"Private - Get the value of the 'SentOn' property of the receiver.
	Helpstring: 'The date and time the message was sent.'

		HRESULT __stdcall SentOn(
			[out, retval] DATE* varSentOn);
	"

	<virtual stdcall: hresult 29 date*>
	^self invalidCall: _failureCode!

get_Subject: pSubject
	"Private - Get the value of the 'Subject' property of the receiver.
	Helpstring: 'The message''s subject (Subject header).'

		HRESULT __stdcall Subject(
			[out, retval] BSTR* pSubject);
	"

	<virtual stdcall: hresult 30 bstr*>
	^self invalidCall: _failureCode!

get_TextBody: pTextBody
	"Private - Get the value of the 'TextBody' property of the receiver.
	Helpstring: 'The text/plain portion of the message body.'

		HRESULT __stdcall TextBody(
			[out, retval] BSTR* pTextBody);
	"

	<virtual stdcall: hresult 34 bstr*>
	^self invalidCall: _failureCode!

get_TextBodyPart: varTextBodyPart
	"Private - Get the value of the 'TextBodyPart' property of the receiver.
	Helpstring: 'Returns the BodyPart object (IBodyPart interface) containing the text/plain part of the message body.'

		HRESULT __stdcall TextBodyPart(
			[out, retval] IBodyPart** varTextBodyPart);
	"

	<virtual stdcall: hresult 47 CDOIBodyPart**>
	^self invalidCall: _failureCode!

get_To: pTo
	"Private - Get the value of the 'To' property of the receiver.
	Helpstring: 'The message''s principle (To header) recipients.'

		HRESULT __stdcall To(
			[out, retval] BSTR* pTo);
	"

	<virtual stdcall: hresult 32 bstr*>
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

	<virtual stdcall: hresult 64 bstr IDispatch**>
	^self invalidCall: _failureCode!

getStream
	"Answer the <ADODB_Stream> result of invoking the COM Object's GetStream() method.
	Helpstring: 'Returns an ADO Stream object containing the message in serialized, RFC 822 format. The message body is encoded using either MIME or UUENCODE as specified by the MIMEFormatted property.'"

	| answer |
	answer := ADODB_Stream newPointer.
	self
		GetStream: answer.
	^answer asObject
!

GetStream: ppStream
	"Private - Invoke the GetStream() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns an ADO Stream object containing the message in serialized, RFC 822 format. The message body is encoded using either MIME or UUENCODE as specified by the MIMEFormatted property.'

		HRESULT __stdcall GetStream(
			[out, retval] _Stream** ppStream);
	"

	<virtual stdcall: hresult 63 ADODB_Stream**>
	^self invalidCall: _failureCode!

htmlBody
	"Answer the <bstr> value of the 'HTMLBody' property of the receiver.
	Helpstring: 'The text/html portion of the message body.'"

	| answer |
	answer := BSTR new.
	self
		get_HTMLBody: answer.
	^answer asObject
!

htmlBody: pHTMLBody
	"Set the 'HTMLBody' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The text/html portion of the message body.'"

	self
		put_HTMLBody: pHTMLBody
!

htmlBodyPart
	"Answer the <CDOIBodyPart> value of the 'HTMLBodyPart' property of the receiver.
	Helpstring: 'Returns the BodyPart object (IBodyPart interface) containing the text/html portion of the message body.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		get_HTMLBodyPart: answer.
	^answer asObject
!

isExtensible
	"Answer whether the receiver may add methods at run-time."

	^false!

isVBCollection
	"Answer whether the receiver is a VB style collection."

	^false!

keywords
	"Answer the <bstr> value of the 'Keywords' property of the receiver.
	Helpstring: 'The message''s keywords.'"

	| answer |
	answer := BSTR new.
	self
		get_Keywords: answer.
	^answer asObject
!

keywords: pKeywords
	"Set the 'Keywords' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s keywords.'"

	self
		put_Keywords: pKeywords
!

mdnRequested
	"Answer the <varbool> value of the 'MDNRequested' property of the receiver.
	Helpstring: 'Indicates whether a mail delivery notification (MDN) should be sent when the message is received.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_MDNRequested: answer.
	^answer asObject
!

mdnRequested: pMDNRequested
	"Set the 'MDNRequested' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Indicates whether a mail delivery notification (MDN) should be sent when the message is received.'"

	self
		put_MDNRequested: pMDNRequested
!

mimeFormatted
	"Answer the <varbool> value of the 'MimeFormatted' property of the receiver.
	Helpstring: 'Indicates whether the message is to be serialized using the MIME (True) or UUENCODE (False) format.'"

	| answer |
	answer := (VARIANT_BOOL new).
	self
		get_MimeFormatted: answer.
	^answer asObject
!

mimeFormatted: pMimeFormatted
	"Set the 'MimeFormatted' property of the receiver to the <varbool> value of the argument.
	Helpstring: 'Indicates whether the message is to be serialized using the MIME (True) or UUENCODE (False) format.'"

	self
		put_MimeFormatted: pMimeFormatted
!

newsgroups
	"Answer the <bstr> value of the 'Newsgroups' property of the receiver.
	Helpstring: 'The message''s newsgroup (Newsgroups header) recipients.'"

	| answer |
	answer := BSTR new.
	self
		get_Newsgroups: answer.
	^answer asObject
!

newsgroups: pNewsgroups
	"Set the 'Newsgroups' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s newsgroup (Newsgroups header) recipients.'"

	self
		put_Newsgroups: pNewsgroups
!

organization
	"Answer the <bstr> value of the 'Organization' property of the receiver.
	Helpstring: 'The sender''s organization name.'"

	| answer |
	answer := BSTR new.
	self
		get_Organization: answer.
	^answer asObject
!

organization: pOrganization
	"Set the 'Organization' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The sender''s organization name.'"

	self
		put_Organization: pOrganization
!

Post
	"Invoke the Post() method of the COM object wrapped by the receiver.
	Helpstring: 'Posts the message using the method specified in the associated Configuration object.'

		HRESULT __stdcall Post();
	"

	<virtual stdcall: hresult 58>
	^self invalidCall: _failureCode!

postReply
	"Answer the <CDOIMessage> result of invoking the COM Object's PostReply() method.
	Helpstring: 'Returns a Message object used to post a reply to the message.'"

	| answer |
	answer := CDOIMessage newPointer.
	self
		PostReply: answer.
	^answer asObject
!

PostReply: ppMsg
	"Private - Invoke the PostReply() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Message object used to post a reply to the message.'

		HRESULT __stdcall PostReply(
			[out, retval] IMessage** ppMsg);
	"

	<virtual stdcall: hresult 59 CDOIMessage**>
	^self invalidCall: _failureCode!

put_AutoGenerateTextBody: pAutoGenerateTextBody
	"Private - Set the value of the 'AutoGenerateTextBody' property of the object wrapped by the 
	 receiver to the <varbool> argument, pAutoGenerateTextBody.
	Helpstring: 'Indicates whether a text/plain alternate representation should automatically be generated from the text/html part of the message body.'

		HRESULT __stdcall AutoGenerateTextBody(
			[in] VARIANT_BOOL pAutoGenerateTextBody);
	"

	<virtual stdcall: hresult 45 varbool>
	^self invalidCall: _failureCode!

put_BCC: pBCC
	"Private - Set the value of the 'BCC' property of the object wrapped by the 
	 receiver to the <bstr> argument, pBCC.
	Helpstring: 'The message''s hidden carbon copy (BCC header) recipients.'

		HRESULT __stdcall BCC(
			[in] BSTR pBCC);
	"

	<virtual stdcall: hresult 9 bstr>
	^self invalidCall: _failureCode!

put_CC: pCC
	"Private - Set the value of the 'CC' property of the object wrapped by the 
	 receiver to the <bstr> argument, pCC.
	Helpstring: 'The message''s secondary (CC header) recipients.'

		HRESULT __stdcall CC(
			[in] BSTR pCC);
	"

	<virtual stdcall: hresult 11 bstr>
	^self invalidCall: _failureCode!

put_Configuration: pConfiguration
	"Private - Set the value of the 'Configuration' property of the object wrapped by the 
	 receiver to the <CDOIConfiguration*> argument, pConfiguration.
	Helpstring: 'The object''s Configuration object.'

		HRESULT __stdcall Configuration(
			[in] IConfiguration* pConfiguration);
	"

	<virtual stdcall: hresult 42 CDOIConfiguration*>
	^self invalidCall: _failureCode!

put_DSNOptions: pDSNOptions
	"Private - Set the value of the 'DSNOptions' property of the object wrapped by the 
	 receiver to the <sdword> argument, pDSNOptions.
	Helpstring: 'The delivery status notification (DSN) options for the message.'

		HRESULT __stdcall DSNOptions(
			[in] CdoDSNOptions pDSNOptions);
	"

	<virtual stdcall: hresult 28 sdword>
	^self invalidCall: _failureCode!

put_FollowUpTo: pFollowUpTo
	"Private - Set the value of the 'FollowUpTo' property of the object wrapped by the 
	 receiver to the <bstr> argument, pFollowUpTo.
	Helpstring: 'The message''s follow-up recipients.'

		HRESULT __stdcall FollowUpTo(
			[in] BSTR pFollowUpTo);
	"

	<virtual stdcall: hresult 13 bstr>
	^self invalidCall: _failureCode!

put_From: pFrom
	"Private - Set the value of the 'From' property of the object wrapped by the 
	 receiver to the <bstr> argument, pFrom.
	Helpstring: 'The message''s principle (From header) authors.'

		HRESULT __stdcall From(
			[in] BSTR pFrom);
	"

	<virtual stdcall: hresult 15 bstr>
	^self invalidCall: _failureCode!

put_HTMLBody: pHTMLBody
	"Private - Set the value of the 'HTMLBody' property of the object wrapped by the 
	 receiver to the <bstr> argument, pHTMLBody.
	Helpstring: 'The text/html portion of the message body.'

		HRESULT __stdcall HTMLBody(
			[in] BSTR pHTMLBody);
	"

	<virtual stdcall: hresult 37 bstr>
	^self invalidCall: _failureCode!

put_Keywords: pKeywords
	"Private - Set the value of the 'Keywords' property of the object wrapped by the 
	 receiver to the <bstr> argument, pKeywords.
	Helpstring: 'The message''s keywords.'

		HRESULT __stdcall Keywords(
			[in] BSTR pKeywords);
	"

	<virtual stdcall: hresult 17 bstr>
	^self invalidCall: _failureCode!

put_MDNRequested: pMDNRequested
	"Private - Set the value of the 'MDNRequested' property of the object wrapped by the 
	 receiver to the <varbool> argument, pMDNRequested.
	Helpstring: 'Indicates whether a mail delivery notification (MDN) should be sent when the message is received.'

		HRESULT __stdcall MDNRequested(
			[in] VARIANT_BOOL pMDNRequested);
	"

	<virtual stdcall: hresult 53 varbool>
	^self invalidCall: _failureCode!

put_MimeFormatted: pMimeFormatted
	"Private - Set the value of the 'MimeFormatted' property of the object wrapped by the 
	 receiver to the <varbool> argument, pMimeFormatted.
	Helpstring: 'Indicates whether the message is to be serialized using the MIME (True) or UUENCODE (False) format.'

		HRESULT __stdcall MimeFormatted(
			[in] VARIANT_BOOL pMimeFormatted);
	"

	<virtual stdcall: hresult 19 varbool>
	^self invalidCall: _failureCode!

put_Newsgroups: pNewsgroups
	"Private - Set the value of the 'Newsgroups' property of the object wrapped by the 
	 receiver to the <bstr> argument, pNewsgroups.
	Helpstring: 'The message''s newsgroup (Newsgroups header) recipients.'

		HRESULT __stdcall Newsgroups(
			[in] BSTR pNewsgroups);
	"

	<virtual stdcall: hresult 21 bstr>
	^self invalidCall: _failureCode!

put_Organization: pOrganization
	"Private - Set the value of the 'Organization' property of the object wrapped by the 
	 receiver to the <bstr> argument, pOrganization.
	Helpstring: 'The sender''s organization name.'

		HRESULT __stdcall Organization(
			[in] BSTR pOrganization);
	"

	<virtual stdcall: hresult 23 bstr>
	^self invalidCall: _failureCode!

put_ReplyTo: pReplyTo
	"Private - Set the value of the 'ReplyTo' property of the object wrapped by the 
	 receiver to the <bstr> argument, pReplyTo.
	Helpstring: 'The email addresses (Reply-To header) to which to reply.'

		HRESULT __stdcall ReplyTo(
			[in] BSTR pReplyTo);
	"

	<virtual stdcall: hresult 26 bstr>
	^self invalidCall: _failureCode!

put_Sender: pSender
	"Private - Set the value of the 'Sender' property of the object wrapped by the 
	 receiver to the <bstr> argument, pSender.
	Helpstring: 'The message''s actual sender.'

		HRESULT __stdcall Sender(
			[in] BSTR pSender);
	"

	<virtual stdcall: hresult 40 bstr>
	^self invalidCall: _failureCode!

put_Subject: pSubject
	"Private - Set the value of the 'Subject' property of the object wrapped by the 
	 receiver to the <bstr> argument, pSubject.
	Helpstring: 'The message''s subject (Subject header).'

		HRESULT __stdcall Subject(
			[in] BSTR pSubject);
	"

	<virtual stdcall: hresult 31 bstr>
	^self invalidCall: _failureCode!

put_TextBody: pTextBody
	"Private - Set the value of the 'TextBody' property of the object wrapped by the 
	 receiver to the <bstr> argument, pTextBody.
	Helpstring: 'The text/plain portion of the message body.'

		HRESULT __stdcall TextBody(
			[in] BSTR pTextBody);
	"

	<virtual stdcall: hresult 35 bstr>
	^self invalidCall: _failureCode!

put_To: pTo
	"Private - Set the value of the 'To' property of the object wrapped by the 
	 receiver to the <bstr> argument, pTo.
	Helpstring: 'The message''s principle (To header) recipients.'

		HRESULT __stdcall To(
			[in] BSTR pTo);
	"

	<virtual stdcall: hresult 33 bstr>
	^self invalidCall: _failureCode!

putref_Configuration: pConfiguration
	"Private - Set the value of the 'Configuration' property of the object wrapped by the 
	 receiver to the <CDOIConfiguration*> argument, pConfiguration.
	Helpstring: 'The object''s Configuration object.'

		HRESULT __stdcall Configuration(
			[in] IConfiguration* pConfiguration);
	"

	<virtual stdcall: hresult 43 CDOIConfiguration*>
	^self invalidCall: _failureCode!

receivedTime
	"Answer the <date> value of the 'ReceivedTime' property of the receiver.
	Helpstring: 'The date and time the message was received.'"

	| answer |
	answer := (DATE new).
	self
		get_ReceivedTime: answer.
	^answer asObject
!

reply
	"Answer the <CDOIMessage> result of invoking the COM Object's Reply() method.
	Helpstring: 'Returns a Message object used to reply to the message.'"

	| answer |
	answer := CDOIMessage newPointer.
	self
		Reply: answer.
	^answer asObject
!

Reply: ppMsg
	"Private - Invoke the Reply() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Message object used to reply to the message.'

		HRESULT __stdcall Reply(
			[out, retval] IMessage** ppMsg);
	"

	<virtual stdcall: hresult 60 CDOIMessage**>
	^self invalidCall: _failureCode!

replyAll
	"Answer the <CDOIMessage> result of invoking the COM Object's ReplyAll() method.
	Helpstring: 'Returns a Message object used to post a reply to all recipients of the message.'"

	| answer |
	answer := CDOIMessage newPointer.
	self
		ReplyAll: answer.
	^answer asObject
!

ReplyAll: ppMsg
	"Private - Invoke the ReplyAll() method of the COM object wrapped by the receiver.
	Helpstring: 'Returns a Message object used to post a reply to all recipients of the message.'

		HRESULT __stdcall ReplyAll(
			[out, retval] IMessage** ppMsg);
	"

	<virtual stdcall: hresult 61 CDOIMessage**>
	^self invalidCall: _failureCode!

replyTo
	"Answer the <bstr> value of the 'ReplyTo' property of the receiver.
	Helpstring: 'The email addresses (Reply-To header) to which to reply.'"

	| answer |
	answer := BSTR new.
	self
		get_ReplyTo: answer.
	^answer asObject
!

replyTo: pReplyTo
	"Set the 'ReplyTo' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The email addresses (Reply-To header) to which to reply.'"

	self
		put_ReplyTo: pReplyTo
!

Send
	"Invoke the Send() method of the COM object wrapped by the receiver.
	Helpstring: 'Sends the message using the method specified in the associated Configuration object.'

		HRESULT __stdcall Send();
	"

	<virtual stdcall: hresult 62>
	^self invalidCall: _failureCode!

sender
	"Answer the <bstr> value of the 'Sender' property of the receiver.
	Helpstring: 'The message''s actual sender.'"

	| answer |
	answer := BSTR new.
	self
		get_Sender: answer.
	^answer asObject
!

sender: pSender
	"Set the 'Sender' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s actual sender.'"

	self
		put_Sender: pSender
!

sentOn
	"Answer the <date> value of the 'SentOn' property of the receiver.
	Helpstring: 'The date and time the message was sent.'"

	| answer |
	answer := (DATE new).
	self
		get_SentOn: answer.
	^answer asObject
!

setConfiguration: pConfiguration
	"Set the 'Configuration' property of the receiver to the <CDOIConfiguration*> value of the argument.
	Helpstring: 'The object''s Configuration object.'"

	self
		putref_Configuration: pConfiguration
!

subject
	"Answer the <bstr> value of the 'Subject' property of the receiver.
	Helpstring: 'The message''s subject (Subject header).'"

	| answer |
	answer := BSTR new.
	self
		get_Subject: answer.
	^answer asObject
!

subject: pSubject
	"Set the 'Subject' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s subject (Subject header).'"

	self
		put_Subject: pSubject
!

textBody
	"Answer the <bstr> value of the 'TextBody' property of the receiver.
	Helpstring: 'The text/plain portion of the message body.'"

	| answer |
	answer := BSTR new.
	self
		get_TextBody: answer.
	^answer asObject
!

textBody: pTextBody
	"Set the 'TextBody' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The text/plain portion of the message body.'"

	self
		put_TextBody: pTextBody
!

textBodyPart
	"Answer the <CDOIBodyPart> value of the 'TextBodyPart' property of the receiver.
	Helpstring: 'Returns the BodyPart object (IBodyPart interface) containing the text/plain part of the message body.'"

	| answer |
	answer := CDOIBodyPart newPointer.
	self
		get_TextBodyPart: answer.
	^answer asObject
!

to
	"Answer the <bstr> value of the 'To' property of the receiver.
	Helpstring: 'The message''s principle (To header) recipients.'"

	| answer |
	answer := BSTR new.
	self
		get_To: answer.
	^answer asObject
!

to: pTo
	"Set the 'To' property of the receiver to the <bstr> value of the argument.
	Helpstring: 'The message''s principle (To header) recipients.'"

	self
		put_To: pTo
! !
!CDOIMessage categoriesFor: #addAttachment:userName:password:!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #AddAttachment:UserName:Password:ppBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #addRelatedBodyPart:reference:referenceType:userName:password:!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #AddRelatedBodyPart:Reference:ReferenceType:UserName:Password:ppBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #attachments!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #autoGenerateTextBody!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #autoGenerateTextBody:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #bcc!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #bcc:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #bodyPart!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #cc!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #cc:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #configuration!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #configuration:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #CreateMHTMLBody:Flags:UserName:Password:!**auto generated**!COM Interfaces-IMessage!public! !
!CDOIMessage categoriesFor: #dataSource!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #dsnOptions!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #dsnOptions:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #envelopeFields!properties!public! !
!CDOIMessage categoriesFor: #fields!properties!public! !
!CDOIMessage categoriesFor: #followUpTo!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #followUpTo:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #forward!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #Forward:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #from!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #from:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #get_Attachments:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_AutoGenerateTextBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_BCC:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_BodyPart:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_CC:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Configuration:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_DataSource:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_DSNOptions:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_EnvelopeFields:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Fields:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_FollowUpTo:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_From:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_HTMLBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_HTMLBodyPart:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Keywords:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_MDNRequested:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_MimeFormatted:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Newsgroups:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Organization:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_ReceivedTime:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_ReplyTo:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Sender:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_SentOn:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_Subject:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_TextBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_TextBodyPart:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #get_To:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #getInterface:!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #GetInterface:ppUnknown:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #getStream!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #GetStream:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #htmlBody!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #htmlBody:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #htmlBodyPart!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #isExtensible!**auto generated**!public!testing! !
!CDOIMessage categoriesFor: #isVBCollection!**auto generated**!public!testing! !
!CDOIMessage categoriesFor: #keywords!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #keywords:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #mdnRequested!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #mdnRequested:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #mimeFormatted!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #mimeFormatted:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #newsgroups!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #newsgroups:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #organization!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #organization:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #Post!**auto generated**!COM Interfaces-IMessage!public! !
!CDOIMessage categoriesFor: #postReply!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #PostReply:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_AutoGenerateTextBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_BCC:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_CC:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Configuration:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_DSNOptions:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_FollowUpTo:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_From:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_HTMLBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Keywords:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_MDNRequested:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_MimeFormatted:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Newsgroups:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Organization:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_ReplyTo:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Sender:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_Subject:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_TextBody:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #put_To:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #putref_Configuration:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #receivedTime!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #reply!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #Reply:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #replyAll!**auto generated**!methods!public! !
!CDOIMessage categoriesFor: #ReplyAll:!**auto generated**!COM Interfaces-IMessage!private! !
!CDOIMessage categoriesFor: #replyTo!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #replyTo:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #Send!**auto generated**!COM Interfaces-IMessage!public! !
!CDOIMessage categoriesFor: #sender!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #sender:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #sentOn!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #setConfiguration:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #subject!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #subject:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #textBody!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #textBody:!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #textBodyPart!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #to!**auto generated**!properties!public! !
!CDOIMessage categoriesFor: #to:!**auto generated**!properties!public! !

!CDOIMessage class methodsFor!

clsid
	"Private - Answer the CLSID of the coclass (Message) for which the receiver is the default interface.
	"

	^CLSID fromString: '{CD000001-8B95-11D1-82DB-00C04FB1625D}'
!

defineFunctions
	"Declare the virtual function table for the COM interface 'CDO.IMessage'
		CDOIMessage defineTemplate
	"

	self
		defineFunction: #get_BCC:
			argumentTypes: 'bstr*';
		defineFunction: #put_BCC:
			argumentTypes: 'bstr';
		defineFunction: #get_CC:
			argumentTypes: 'bstr*';
		defineFunction: #put_CC:
			argumentTypes: 'bstr';
		defineFunction: #get_FollowUpTo:
			argumentTypes: 'bstr*';
		defineFunction: #put_FollowUpTo:
			argumentTypes: 'bstr';
		defineFunction: #get_From:
			argumentTypes: 'bstr*';
		defineFunction: #put_From:
			argumentTypes: 'bstr';
		defineFunction: #get_Keywords:
			argumentTypes: 'bstr*';
		defineFunction: #put_Keywords:
			argumentTypes: 'bstr';
		defineFunction: #get_MimeFormatted:
			argumentTypes: 'varbool*';
		defineFunction: #put_MimeFormatted:
			argumentTypes: 'varbool';
		defineFunction: #get_Newsgroups:
			argumentTypes: 'bstr*';
		defineFunction: #put_Newsgroups:
			argumentTypes: 'bstr';
		defineFunction: #get_Organization:
			argumentTypes: 'bstr*';
		defineFunction: #put_Organization:
			argumentTypes: 'bstr';
		defineFunction: #get_ReceivedTime:
			argumentTypes: 'date*';
		defineFunction: #get_ReplyTo:
			argumentTypes: 'bstr*';
		defineFunction: #put_ReplyTo:
			argumentTypes: 'bstr';
		defineFunction: #get_DSNOptions:
			argumentTypes: 'sdword*';
		defineFunction: #put_DSNOptions:
			argumentTypes: 'sdword';
		defineFunction: #get_SentOn:
			argumentTypes: 'date*';
		defineFunction: #get_Subject:
			argumentTypes: 'bstr*';
		defineFunction: #put_Subject:
			argumentTypes: 'bstr';
		defineFunction: #get_To:
			argumentTypes: 'bstr*';
		defineFunction: #put_To:
			argumentTypes: 'bstr';
		defineFunction: #get_TextBody:
			argumentTypes: 'bstr*';
		defineFunction: #put_TextBody:
			argumentTypes: 'bstr';
		defineFunction: #get_HTMLBody:
			argumentTypes: 'bstr*';
		defineFunction: #put_HTMLBody:
			argumentTypes: 'bstr';
		defineFunction: #get_Attachments:
			argumentTypes: 'CDOIBodyParts**';
		defineFunction: #get_Sender:
			argumentTypes: 'bstr*';
		defineFunction: #put_Sender:
			argumentTypes: 'bstr';
		defineFunction: #get_Configuration:
			argumentTypes: 'CDOIConfiguration**';
		defineFunction: #put_Configuration:
			argumentTypes: 'CDOIConfiguration*';
		defineFunction: #putref_Configuration:
			argumentTypes: 'CDOIConfiguration*';
		defineFunction: #get_AutoGenerateTextBody:
			argumentTypes: 'varbool*';
		defineFunction: #put_AutoGenerateTextBody:
			argumentTypes: 'varbool';
		defineFunction: #get_EnvelopeFields:
			argumentTypes: 'ADODBFields**';
		defineFunction: #get_TextBodyPart:
			argumentTypes: 'CDOIBodyPart**';
		defineFunction: #get_HTMLBodyPart:
			argumentTypes: 'CDOIBodyPart**';
		defineFunction: #get_BodyPart:
			argumentTypes: 'CDOIBodyPart**';
		defineFunction: #get_DataSource:
			argumentTypes: 'CDOIDataSource**';
		defineFunction: #get_Fields:
			argumentTypes: 'ADODBFields**';
		defineFunction: #get_MDNRequested:
			argumentTypes: 'varbool*';
		defineFunction: #put_MDNRequested:
			argumentTypes: 'varbool';
		defineFunction: #AddRelatedBodyPart:Reference:ReferenceType:UserName:Password:ppBody:
			argumentTypes: 'bstr bstr sdword bstr bstr CDOIBodyPart**';
		defineFunction: #AddAttachment:UserName:Password:ppBody:
			argumentTypes: 'bstr bstr bstr CDOIBodyPart**';
		defineFunction: #CreateMHTMLBody:Flags:UserName:Password:
			argumentTypes: 'bstr sdword bstr bstr';
		defineFunction: #Forward:
			argumentTypes: 'CDOIMessage**';
		defineFunction: #Post;
		defineFunction: #PostReply:
			argumentTypes: 'CDOIMessage**';
		defineFunction: #Reply:
			argumentTypes: 'CDOIMessage**';
		defineFunction: #ReplyAll:
			argumentTypes: 'CDOIMessage**';
		defineFunction: #Send;
		defineFunction: #GetStream:
			argumentTypes: 'ADODB_Stream**';
		defineFunction: #GetInterface:ppUnknown:
			argumentTypes: 'bstr IDispatch**'
!

initializeTypeLib
	"Private - Establish a connection to the receiver's type library.
		CDOIMessage initializeTypeLib
	"

	typeLib := CDOLib! !
!CDOIMessage class categoriesFor: #clsid!**auto generated**!constants!private! !
!CDOIMessage class categoriesFor: #defineFunctions!**auto generated**!initializing!public! !
!CDOIMessage class categoriesFor: #initializeTypeLib!**auto generated**!initializing!private! !

