"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #WebHttpStream
	instanceVariableNames: 'socketStream contents cookie compressedContents responseStatus contentType contentEncoding responseLocation expires isBytes date lastModified noCache keepConnection cacheControl compressAlways contentDisposition acceptByteRanges contentRange eTag'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpStream guid: (GUID fromString: '{27749A91-CD8A-4F50-BD27-5F1B7D5156EC}')!
WebHttpStream comment: ''!
!WebHttpStream categoriesForClass!Unclassified! !
!WebHttpStream methodsFor!

acceptByteRanges: aBoolean 
	acceptByteRanges := aBoolean!

attachmentFilename: aString 
	contentDisposition := aString isNilOrEmpty ifFalse: ['attachment; filename="' , aString , '";']!

badRequestResponse
	responseStatus := '400 Bad Request'.
	Processor activeProcess language = 'Serbian' ifTrue: [^self badRequestResponseSerbian].
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Bad Request</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Bad Request</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Bad Request</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

badRequestResponseSerbian
	contentType := 'text/html; charset=windows-1250'.
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Pogrešan zahtev</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Pogrešan zahtev</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Pogrešan zahtev</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

cacheControl: aString 
	cacheControl := aString!

close

	!

compressResponseForInternetExplorer
	"This will compress (deflate) response when the client is Internet Explorer."

	(contentType notNil and: 
			[(contentType beginsWith: 'image') or: 
					[(contentType beginsWith: 'audio') or: 
							[(contentType beginsWith: 'video') or: 
									[contentType = 'text/css' or: 
											[contentType = 'application/pdf' 
												or: [contentType = 'application/x-zip' or: [contentType = 'application/x-javascript']]]]]]]) 
		ifTrue: [compressAlways = true ifFalse: [^self]].
	(contents position > 150 and: [self responseStatus = '200 OK']) 
		ifTrue: 
			[(compressedContents := self zLibCompressNoFail: contents contents) notNil 
				ifTrue: [compressedContents := compressedContents copyFrom: 3 to: compressedContents size]]!

compressResponseForMozilla
	"This will compress (deflate) response when the client is Mozilla."

	(contentType notNil and: 
			[(contentType beginsWith: 'image') or: 
					[(contentType beginsWith: 'audio') or: 
							[(contentType beginsWith: 'video') or: 
									[contentType = 'text/css' 
										or: [contentType = 'application/pdf' or: [contentType = 'application/x-zip']]]]]]) 
		ifTrue: [^self].
	(contents position > 150 and: [self responseStatus = '200 OK']) 
		ifTrue: 
			[(compressedContents := self zLibCompressNoFail: contents contents) notNil 
				ifTrue: [compressedContents := compressedContents copyFrom: 3 to: compressedContents size]]!

compressResponseForOpera6
	"This will compress (deflate) response when the client is Opera 6.0."

	(contentType notNil and: 
			[(contentType beginsWith: 'image') or: 
					[(contentType beginsWith: 'audio') or: 
							[(contentType beginsWith: 'video') or: 
									[contentType = 'application/x-zip' or: 
											[contentType = 'application/msword' or: 
													[contentType = 'application/vnd.sun.xml.writer' or: 
															[contentType = 'application/vnd.sun.xml.calc' 
																or: [contentType = 'application/vnd.ms-excel' or: [contentType = 'application/pdf']]]]]]]]]) 
		ifTrue: [^self].
	(contents position > 150 and: [self responseStatus = '200 OK']) 
		ifTrue: [compressedContents := self zLibCompressNoFail: contents contents]!

connectionClose
	keepConnection := false!

connectionKeepAlive
	keepConnection := true!

contentDisposition: aString 
	contentDisposition := aString!

contentEncoding
	^contentEncoding!

contentEncoding: aString 
	contentEncoding := aString!

contentLength
	^contents position!

contentRange: anAssociation 
	"Content range is an association with key=start offset, value=total size of the resource in bytes."

	contentRange := anAssociation!

contents
	^contents contents!

contentType
	^contentType isNil ifTrue: ['text/html'] ifFalse: [contentType]!

contentType: aString 
	contentType := aString!

cr
	contents itcCrLf!

date
	^date!

date: aTimestamp 
	date := aTimestamp!

disallowAllRobotsResponse

	self nextPutAll:
'# this server is running web applications serving dynamic pages only
# no robots are allowed
User-agent: *
Disallow: /

'!

errorResponseWithDescription: errorDescription 
	responseStatus := '500 Internal Server Error'.
	contentType := 'text/html'.
	Processor activeProcess language = 'Slovene' 
		ifTrue: [^self errorResponseWithDescriptionSlovene: errorDescription].
	Processor activeProcess language = 'Serbian' 
		ifTrue: [^self errorResponseWithDescriptionSerbian: errorDescription].
	contents := WriteStream on: (String new: 2048).
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Internal Server Error</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="650" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Internal Server Error</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Your request could not be processed due to the following software error:<BR><BR><b>' 
				, errorDescription webHtmlEncoded , '</b><BR><BR>Server time: ' 
				, Timestamp now asWebString 
					, '<BR>Please report this error to support.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

errorResponseWithDescriptionSerbian: errorDescription 
	contentType := 'text/html; charset=windows-1250'.
	contents := WriteStream on: (String new: 2048).
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Interna greška na serveru</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="650" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Interna greška na serveru</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Vaš zahtev nije procesiran zbog softverske greške:<BR><BR><b>' 
				, errorDescription webHtmlEncoded , '</b><BR><BR>Datum i vreme na serveru: ' 
				, Timestamp now asWebString 
					, '<BR><BR>Uzrok greške može biti programska greška, ali i interna provera ispravnosti podataka ako vaši uneti podaci nisu u skladu sa izvršenjem programa.
<BR><BR>O kvaru koji se dogodio administrator sistema je automatski obavešten.
<BR><BR>Za nastavak rada preporuèujemo Vam da ponovite ceo postupak koji ste želeli da završite. Ako to ne bude delovalo pokušajte sa drugim redosledom operacija ili sa ponovnom prijavom u program.
</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

errorResponseWithDescriptionSlovene: errorDescription 
	contents := WriteStream on: (String new: 2048).
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Programska napaka na strezniku</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="650" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Prekinitev izvajanja programa na strezniku</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Vase zahteve ni bilo mogoce zakljuciti zaradi naslednje prekinitve izvajanja programske kode:<BR><BR><b>' 
				, errorDescription webHtmlEncoded , '</b><BR><BR>Datum in cas na strezniku: ' 
				, Timestamp now asWebString 
					, '<BR><BR>Vzrok za prekinitev izvajanja je lahko bodisi programska napaka, hrosc ali pa interna kontrola pravilnosti podatkov, ki je v vasi konkretni podatkovni konstelaciji prekinila izvajanje programske kode.
<BR><BR>O napaki, ki se je pravkar zgodila je bil administrator sistema avtomatsko obvescen.
<BR><BR>Za nadaljevanje vasega dela vam priporocamo, da poskusite ponoviti celotno opravilo, ki ste ga zeleli dokoncati. V kolikor to ne bi delovalo poskusite z drugim zaporedjem operacij ali s ponovno prijavo v program.
</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

eTag: aString 
	eTag := aString!

expires
	^expires!

expires: aTimestamp 
	expires := aTimestamp!

expiresNow

	expires := Timestamp date: (Date newDay: 1 monthIndex: 1 year: 1980) time: (Time fromSeconds: 0) !

fileNotFoundResponse
	responseStatus := '404 Not Found'.
	Processor activeProcess language = 'Serbian' ifTrue: [^self fileNotFoundResponseSerbian].
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>File Not Found</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>File Not Found</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">The requested URL was not found on this server.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

fileNotFoundResponseSerbian
	contentType := 'text/html; charset=windows-1250'.
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Fajl nije pronaðen</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Fajl nije pronaðen</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Zatraženi URL nije pronaðen na ovom serveru.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

flush

	!

forbiddenResponse

	responseStatus := '403 Forbidden'.
	Processor activeProcess language = 'Serbian' ifTrue: [^self forbiddenResponseSerbian].
	self nextPutAll: '<HTML>
<HEAD>
<TITLE>Forbidden</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Access Denied</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Access to requested URL is denied.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

forbiddenResponseSerbian
	contentType := 'text/html; charset=windows-1250'.
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Zabranjeno</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Pristup odbijen</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Pristup do traženog URL-a je odbijen.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

getHeader
	| stream contentLength |
	stream := WriteStream on: (String new: 1024).
	stream
		nextPutAll: 'HTTP/1.1 ';
		nextPutAll: self responseStatus;
		itcCrLf;
		nextPutAll: 'Server: David''s little web server powered by Smalltalk from www.gorisek.com';
		itcCrLf.
	keepConnection == true 
		ifTrue: 
			[stream
				nextPutAll: 'Connection: Keep-Alive';
				itcCrLf]
		ifFalse: 
			[stream
				nextPutAll: 'Connection: Close';
				itcCrLf].
	date isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Date: ';
				nextPutAll: (self timestampToString: date);
				itcCrLf].
	lastModified isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Last-Modified: ';
				nextPutAll: (self timestampToString: lastModified);
				itcCrLf].
	eTag isNil 
		ifFalse: 
			[stream
				nextPutAll: 'ETag: ';
				nextPutAll: eTag;
				itcCrLf].
	expires isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Expires: ';
				nextPutAll: (self timestampToString: expires);
				itcCrLf].
	noCache == true 
		ifTrue: 
			[stream
				nextPutAll: 'Pragma: no-cache';
				itcCrLf;
				nextPutAll: 'Cache-control: private';
				itcCrLf;
				nextPutAll: 'Cache-control: no-cache';
				itcCrLf;
				nextPutAll: 'Cache-control: no-store';
				itcCrLf].
	cacheControl isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Cache-control: ';
				nextPutAll: cacheControl;
				itcCrLf].
	responseLocation isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Location: ';
				nextPutAll: responseLocation;
				itcCrLf].
	cookie isNil ifFalse: [stream nextPutAll: cookie].
	compressedContents isNil 
		ifTrue: 
			[contentLength := contents position.
			contentEncoding isNil 
				ifTrue: 
					[stream
						nextPutAll: 'Content-Encoding: 8-bit';
						itcCrLf]
				ifFalse: 
					[stream
						nextPutAll: 'Content-Encoding: ';
						nextPutAll: contentEncoding;
						itcCrLf]]
		ifFalse: 
			[contentLength := compressedContents size.
			stream
				nextPutAll: 'Content-Encoding: deflate';
				itcCrLf].
	contentDisposition isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Content-Disposition: ';
				nextPutAll: contentDisposition;
				itcCrLf].
	acceptByteRanges isNil 
		ifFalse: 
			[stream
				nextPutAll: 'Accept-Ranges: ';
				nextPutAll: (acceptByteRanges = true ifTrue: ['bytes'] ifFalse: ['none']);
				itcCrLf].
	contentRange isNil 
		ifFalse: 
			["content rage is an association key=start offset, value=total size of the resource in bytes"
			stream
				nextPutAll: 'Content-Range: bytes ';
				nextPutAll: contentRange key printString;
				nextPut: $-;
				nextPutAll: (contentRange key + contentLength - 1) printString;
				nextPut: $/;
				nextPutAll: contentRange value printString;
				itcCrLf].
	stream
		nextPutAll: 'Content-Type: ';
		nextPutAll: self contentType;
		itcCrLf;
		nextPutAll: 'Content-Length: ';
		nextPutAll: contentLength printString;
		itcCrLf;
		itcCrLf.
	^stream contents!

isBytes: aBoolean 
	(isBytes := aBoolean) 
		ifTrue: [contents := WriteStream on: (ByteArray new: 4096)]
		ifFalse: [contents := WriteStream on: (String new: 4096)]!

isForRequestForInnerHtml
	^false!

isKeepAlive
	^keepConnection == true!

lastModified
	^lastModified!

lastModified: aTimestamp 
	lastModified := aTimestamp!

nextPut: aCharacter 
	contents nextPut: aCharacter!

nextPutAll: aString 
	contents nextPutAll: aString!

notImplementedResponse
	responseStatus := '501 Not Implemented'.
	Processor activeProcess language = 'Slovene' ifTrue: [^self notImplementedResponseSlovene].
	Processor activeProcess language = 'Serbian' ifTrue: [^self notImplementedResponseSerbian].
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Not Implemented</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="560" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Not Implemented</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Response for your request is currently not implemented.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

notImplementedResponseSerbian
	contentType := 'text/html; charset=windows-1250'.
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Strana nije implementirana</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="560" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Strana nije implementirana</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Programski kod za Vaš zahtev nije trenutno implenentiran.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

notImplementedResponseSlovene
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Stran ni implementirana</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="560" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Stran ni implementirana</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Programska koda, ki bi se odzvala na va&#353;o zahtevo &#353;e ni implementirana.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

notModifiedResponse
	responseStatus := '304 Not modified'!

on: aStream 
	socketStream := aStream.
	contents := WriteStream on: (String new: 32768).
	isBytes := false!

partialContentResponse
	responseStatus := '206 Partial content'!

position
	^contents position!

putAjaxResults: results 
	^self putAjaxResults: results isFrameRequest: (self webRequest booleanAt: 'isFrame')!

putAjaxResults: results isFrameRequest: isFrameRequest 
	| pa |
	pa := Processor activeProcess.
	self contentType: 'text/html; charset=utf-8'.
	isFrameRequest == true 
		ifTrue: 
			[self 
				nextPutAll: '<html><head><title></title><script type="text/javascript" language="JavaScript"><!!--
var xmlData='].
	pa webProcessingAjaxRequest 
		ifFalse: [self nextPutAll: results asJavascriptValueUTF8]
		ifTrue: 
			[| str action session |
			str := (session := self webSession) isNil 
						ifTrue: ['']
						ifFalse: 
							['ITC.widget.SessionRefresher.getSingleton().setSleepTimer(' 
								, (session expirationTime // 60) asJavascriptValue , ');'].
			str := str , 'ITC.widget.WaitClock.Hide();' 
						add: ((pa webAjaxRequestJavascriptCollectorContentsOrNil add: results withDelimiter: '
') 
								add: pa webAjaxRequestJavascriptOnLoadCollectorContentsOrNil
								withDelimiter: '
')
						withDelimiter: '
'.
			self
				setNoCache;
				nextPutAll: str asJavascriptValueUTF8.
			((action := pa webRequest action) notNil and: [action beginsWith: 'ajaxPost']) 
				ifTrue: 
					["for AJAX post requests (form posted to iframe) evaluate JS in the parent window's context"
					self nextPutAll: ';window.parent.eval(xmlData);'].
			ItcSystemManager isRuntime 
				ifFalse: 
					[ItcSystemManager 
						logLine: 'AJAX response' , (isFrameRequest == true ifTrue: ['(inside FRAME)'] ifFalse: ['']) , ':
' 
								, str , '
---
']].
	isFrameRequest == true ifTrue: [self nextPutAll: '
//-->
</script></head><body></body></html>']!

redirectAsPostRequestTo: url fields: dict 
	self
		nextPutAll: '<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><body onload="javascript:document.form.submit();"><form name="form" action="';
		nextPutAll: url webHtmlEncodedForForm;
		nextPutAll: '" method="post">'.
	dict keysAndValuesDo: 
			[:eachKey :eachValue | 
			self
				nextPutAll: '<input type="hidden" name="';
				nextPutAll: eachKey asString;
				nextPutAll: '" value="';
				nextPutAll: (eachValue isString 
							ifTrue: [eachValue webHtmlEncodedForForm]
							ifFalse: [eachValue asWebString]);
				nextPutAll: '" />'].
	self
		nextPutAll: '<input type="submit" name="_continueOnNoScript" value="';
		nextPutAll: ('asp.button.Continue' webTranslateIfAbsent: 'Click to continue...') 
					webHtmlEncodedForForm;
		nextPutAll: '" />';
		nextPutAll: '</form></body></html>'!

redirectReponseInParentFrameTo: url 
	self 
		nextPutAll: '<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><body onload="javascript:window.parent.location=''' 
				, url , ''';"></body></html>'!

redirectReponseInTopFrameTo: url 
	self 
		nextPutAll: '<!!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html><body onload="javascript:top.location=''' 
				, url , ''';"></body></html>'!

redirectResponseTemporarilyTo: newURL 
	responseStatus := '302 Object moved'.
	self
		expiresNow;
		responseLocation: newURL;
		nextPutAll: '<html><meta http-equiv="Refresh" content="0;url=' , newURL , '"><body></body></html>'!

redirectResponseTo: newURL 
	responseStatus := '301 Moved Permanently'.
	self
		responseLocation: newURL;
		nextPutAll: '<html><meta http-equiv="Refresh" content="0;url=' , newURL , '"><body></body></html>'!

requestEntityTooLarge
	responseStatus := '413 Request Entity Too Large'!

responseLocation
	^responseLocation!

responseLocation: aString 
	responseLocation := aString!

responseStatus
	responseStatus isNil 
		ifTrue: 
			[contents position = 0 
				ifTrue: [self notImplementedResponse]
				ifFalse: [responseStatus := '200 OK']].
	^responseStatus!

responseStatus: aString 
	responseStatus := aString!

sendResponse
	socketStream
		nextPutAll: self getHeader;
		isBytes: isBytes;
		nextPutAll: (compressedContents isNil 
					ifTrue: [contents contents]
					ifFalse: [compressedContents])!

sendResponseHeader
	socketStream nextPutAll: self getHeader!

serviceTemporarilyUnavailableResponse
	responseStatus := '503 Service Unavailable'.
	Processor activeProcess language = 'Slovene' 
		ifTrue: [^self serviceTemporarilyUnavailableResponseSlovene].
	Processor activeProcess language = 'Serbian' 
		ifTrue: [^self serviceTemporarilyUnavailableResponseSerbian].
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Service temporarily unavailable</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Service temporarily unavailable</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">The requested service or application is currently unavailable. The reason for this could be system restart, administration or malfunction.<br><br>Please try again later.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

serviceTemporarilyUnavailableResponseSerbian
	contentType := 'text/html; charset=windows-1250'.
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Servis je trenutno nedostupan</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Servis je trenutno nedostupan</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Traženi servis, odnosno aplikacija je trenutno nedostupna.
<BR><BR>Razlog može biti restart, administracija ili kvar sistema
<br><br>Molim pokušajte kasnije.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

serviceTemporarilyUnavailableResponseSlovene
	self 
		nextPutAll: '<HTML>
<HEAD>
<TITLE>Storitev je zacasno nedosegljiva</TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFFF">
<CENTER>
<BR><BR>
<TABLE BORDER="1" WIDTH="416" CELLSPACING="0">
  <TR>
    <TD BGCOLOR="#6666CC">
    <TABLE>
      <TR>
	<TD><FONT SIZE="5" COLOR="#FFFFFF" FACE="Helvetica, Arial"><B>Storitev je zacasno nedosegljiva</B></FONT></TD>
      </TR>
    </TABLE>
    </TD>
  </TR>
  <TR>
    <TD>
      <BR>
      <BLOCKQUOTE>
	  <FONT COLOR="#000000" FACE="Helvetica, Arial">Stran oz. aplikacija, ki deluje na tem naslovu je zacasno nedosegljiva.
<BR><BR>Vzrok za nedosegljivost storitve je lahko ponovni zagon sistema, vzdrzevalna dela ali okvara opreme.
<br><br>Prosimo vas, da poskusite znova cez nekaj trenutkov.</FONT>
      </BLOCKQUOTE>&nbsp;
    </TD>
  </TR>
</TABLE>
</CENTER>
</BODY>
</HTML>'!

setCompressAlways
	"Compress response regardless of its content type."

	compressAlways := true!

setContentTypeAdobePDF
	self contentType: 'application/pdf'!

setCookieNamed: cookieName value: cookieValue path: path expires: expirationTS domain: domain secure: secureBool 
	| ws |
	ws := WriteStream on: (String new: 256).
	ws
		nextPutAll: 'Set-Cookie: ';
		nextPutAll: cookieName;
		nextPut: $=;
		nextPutAll: cookieValue;
		nextPutAll: '; expires=';
		nextPutAll: (self timestampToStringGMT: expirationTS);
		nextPutAll: '; path=';
		nextPutAll: path.
	domain isNil 
		ifFalse: 
			[ws
				nextPutAll: '; domain=';
				nextPutAll: domain].
	secureBool = true ifTrue: [ws nextPutAll: '; secure'].
	ws itcCrLf.
	cookie isNil ifTrue: [cookie := ws contents] ifFalse: [cookie := cookie , ws contents]!

setDateAndLastModified

	date := lastModified := Timestamp now. !

setNoCache

	noCache := true!

space

	contents space!

tab

	contents tab!

timestampToString: aTimestamp 
	"Private - Answer String in the following format:

	Thu, 01 Jan 1980 12:00:00 GMT"

	| datum time stream |
	aTimestamp class = Array 
		ifFalse: 
			[datum := aTimestamp date.
			time := aTimestamp time]
		ifTrue: 
			[datum := aTimestamp at: 1.
			time := aTimestamp at: 2].
	stream := WriteStream on: (String new: 64).
	stream
		nextPutAll: (#('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat') at: datum dayOfWeek);
		nextPutAll: ', '.
	datum dayOfMonth < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: datum dayOfMonth printString;
		space;
		nextPutAll: (#('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') 
					at: datum monthIndex);
		space;
		nextPutAll: datum year printString;
		space.
	time hours < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time hours printString;
		nextPut: $:.
	time minutes < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time minutes printString;
		nextPut: $:.
	time seconds < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time seconds printString;
		nextPutAll: ' GMT+1'.
	^stream contents!

timestampToStringGMT: aTimestamp 
	"Private - Answer String in the following format (for cookies):

	Thu, 01-Jan-1980 12:00:00 GMT"

	| datum time stream |
	aTimestamp class = Array 
		ifFalse: 
			[datum := aTimestamp date.
			time := aTimestamp time]
		ifTrue: 
			[datum := aTimestamp at: 1.
			time := aTimestamp at: 2].
	stream := WriteStream on: (String new: 64).
	stream
		nextPutAll: (#('Sun' 'Mon' 'Tue' 'Wed' 'Thu' 'Fri' 'Sat') at: datum dayOfWeek);
		nextPutAll: ', '.
	datum dayOfMonth < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: datum dayOfMonth printString;
		nextPut: $-;
		nextPutAll: (#('Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 'Aug' 'Sep' 'Oct' 'Nov' 'Dec') 
					at: datum monthIndex);
		nextPut: $-;
		nextPutAll: datum year printString;
		space.
	time hours < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time hours printString;
		nextPut: $:.
	time minutes < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time minutes printString;
		nextPut: $:.
	time seconds < 10 ifTrue: [stream nextPut: $0].
	stream
		nextPutAll: time seconds printString;
		nextPutAll: ' GMT'.
	^stream contents!

zLibCompressNoFail: pageContents 
	"Private - This is used to compress web pages instead of calling ZLibInterface directly.
	Sometimes ZLIB fails and then it should downgrade to serve non-compressed pages without giving error messages to the client.

	Answer <nil> if ZLIB compression failed.
	"

	| result |
	[result := ZLibInterface compressForWeb: pageContents] on: Error
		do: [:ex | ItcSystemManager logLineWithTS: 'ERROR: ZLib compression failed: ' , ex itcDescription].
	^result! !
!WebHttpStream categoriesFor: #acceptByteRanges:!public! !
!WebHttpStream categoriesFor: #attachmentFilename:!public! !
!WebHttpStream categoriesFor: #badRequestResponse!public!response status! !
!WebHttpStream categoriesFor: #badRequestResponseSerbian!public!response status! !
!WebHttpStream categoriesFor: #cacheControl:!public! !
!WebHttpStream categoriesFor: #close!public! !
!WebHttpStream categoriesFor: #compressResponseForInternetExplorer!public! !
!WebHttpStream categoriesFor: #compressResponseForMozilla!public! !
!WebHttpStream categoriesFor: #compressResponseForOpera6!public! !
!WebHttpStream categoriesFor: #connectionClose!public! !
!WebHttpStream categoriesFor: #connectionKeepAlive!public! !
!WebHttpStream categoriesFor: #contentDisposition:!public! !
!WebHttpStream categoriesFor: #contentEncoding!public! !
!WebHttpStream categoriesFor: #contentEncoding:!public! !
!WebHttpStream categoriesFor: #contentLength!public! !
!WebHttpStream categoriesFor: #contentRange:!public! !
!WebHttpStream categoriesFor: #contents!public! !
!WebHttpStream categoriesFor: #contentType!public! !
!WebHttpStream categoriesFor: #contentType:!public! !
!WebHttpStream categoriesFor: #cr!public! !
!WebHttpStream categoriesFor: #date!public! !
!WebHttpStream categoriesFor: #date:!public! !
!WebHttpStream categoriesFor: #disallowAllRobotsResponse!public! !
!WebHttpStream categoriesFor: #errorResponseWithDescription:!public!response status! !
!WebHttpStream categoriesFor: #errorResponseWithDescriptionSerbian:!public!response status! !
!WebHttpStream categoriesFor: #errorResponseWithDescriptionSlovene:!public!response status! !
!WebHttpStream categoriesFor: #eTag:!public! !
!WebHttpStream categoriesFor: #expires!public! !
!WebHttpStream categoriesFor: #expires:!public! !
!WebHttpStream categoriesFor: #expiresNow!public! !
!WebHttpStream categoriesFor: #fileNotFoundResponse!public!response status! !
!WebHttpStream categoriesFor: #fileNotFoundResponseSerbian!public!response status! !
!WebHttpStream categoriesFor: #flush!public! !
!WebHttpStream categoriesFor: #forbiddenResponse!public!response status! !
!WebHttpStream categoriesFor: #forbiddenResponseSerbian!public!response status! !
!WebHttpStream categoriesFor: #getHeader!public! !
!WebHttpStream categoriesFor: #isBytes:!public! !
!WebHttpStream categoriesFor: #isForRequestForInnerHtml!public!testing! !
!WebHttpStream categoriesFor: #isKeepAlive!public! !
!WebHttpStream categoriesFor: #lastModified!public! !
!WebHttpStream categoriesFor: #lastModified:!public! !
!WebHttpStream categoriesFor: #nextPut:!public! !
!WebHttpStream categoriesFor: #nextPutAll:!public! !
!WebHttpStream categoriesFor: #notImplementedResponse!public!response status! !
!WebHttpStream categoriesFor: #notImplementedResponseSerbian!public!response status! !
!WebHttpStream categoriesFor: #notImplementedResponseSlovene!public!response status! !
!WebHttpStream categoriesFor: #notModifiedResponse!public!response status! !
!WebHttpStream categoriesFor: #on:!public! !
!WebHttpStream categoriesFor: #partialContentResponse!public!response status! !
!WebHttpStream categoriesFor: #position!public! !
!WebHttpStream categoriesFor: #putAjaxResults:!ajax support!public! !
!WebHttpStream categoriesFor: #putAjaxResults:isFrameRequest:!ajax support!public! !
!WebHttpStream categoriesFor: #redirectAsPostRequestTo:fields:!public! !
!WebHttpStream categoriesFor: #redirectReponseInParentFrameTo:!public! !
!WebHttpStream categoriesFor: #redirectReponseInTopFrameTo:!public! !
!WebHttpStream categoriesFor: #redirectResponseTemporarilyTo:!public!response status! !
!WebHttpStream categoriesFor: #redirectResponseTo:!public!response status! !
!WebHttpStream categoriesFor: #requestEntityTooLarge!public!response status! !
!WebHttpStream categoriesFor: #responseLocation!public! !
!WebHttpStream categoriesFor: #responseLocation:!public! !
!WebHttpStream categoriesFor: #responseStatus!public! !
!WebHttpStream categoriesFor: #responseStatus:!public! !
!WebHttpStream categoriesFor: #sendResponse!public! !
!WebHttpStream categoriesFor: #sendResponseHeader!public! !
!WebHttpStream categoriesFor: #serviceTemporarilyUnavailableResponse!public!response status! !
!WebHttpStream categoriesFor: #serviceTemporarilyUnavailableResponseSerbian!public!response status! !
!WebHttpStream categoriesFor: #serviceTemporarilyUnavailableResponseSlovene!public!response status! !
!WebHttpStream categoriesFor: #setCompressAlways!public! !
!WebHttpStream categoriesFor: #setContentTypeAdobePDF!public! !
!WebHttpStream categoriesFor: #setCookieNamed:value:path:expires:domain:secure:!public! !
!WebHttpStream categoriesFor: #setDateAndLastModified!public! !
!WebHttpStream categoriesFor: #setNoCache!public! !
!WebHttpStream categoriesFor: #space!public! !
!WebHttpStream categoriesFor: #tab!public! !
!WebHttpStream categoriesFor: #timestampToString:!private! !
!WebHttpStream categoriesFor: #timestampToStringGMT:!private! !
!WebHttpStream categoriesFor: #zLibCompressNoFail:!private! !

