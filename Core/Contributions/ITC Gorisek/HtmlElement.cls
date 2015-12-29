"Filed out from Dolphin Smalltalk X6.1"!

Object subclass: #HtmlElement
	instanceVariableNames: 'color background cssClass elementId cssStyle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HtmlElement guid: (GUID fromString: '{EE35295C-37ED-4BB9-A8BE-8EBD9A3AA16E}')!
HtmlElement comment: ''!
!HtmlElement categoriesForClass!Unclassified! !
!HtmlElement methodsFor!

addBodyOnLoadScript: onLoadScript on: aStream 
	onLoadScript isNilOrEmpty ifTrue: [^self].
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: 
			[| initFunctionName |
			initFunctionName := 'init' , ItcSystemManager generateRandomString.
			Processor activeProcess webAjaxRequestJavascriptOnLoadCollector 
				nextPutAll: 'self.' , initFunctionName , '=function(){' , onLoadScript , '};' , initFunctionName 
						, '();self.' , initFunctionName 
						, '=null;']
		ifFalse: 
			[Processor activeProcess webProcessingAjaxCodeSnippetRequest == true 
				ifTrue: 
					[| initFunctionName |
					initFunctionName := 'init' , ItcSystemManager generateRandomString.
					Processor activeProcess webAjaxRequestJavascriptOnLoadCollector 
						nextPutAll: 'var ' , initFunctionName , '=function(){' , onLoadScript , '};' , initFunctionName 
								, '();' , initFunctionName 
								, '=this.undefined;']
				ifFalse: 
					[Processor activeProcess webRequest isInternetExplorer 
						ifTrue: 
							[self addJavascript: 'window.attachEvent(''onload'', function() {
' , onLoadScript , '
});
'
								on: aStream]
						ifFalse: 
							[self 
								addJavascript: 'window.addEventListener(''load'', function() {
' , onLoadScript , '
}, true);
'
								on: aStream]]]!

addJavascript: aScript on: aStream 
	Processor activeProcess webProcessingAjaxRequest 
		ifTrue: [Processor activeProcess webAjaxRequestJavascriptCollector nextPutAll: aScript]
		ifFalse: 
			[aStream
				nextPutAll: HtmlElement javascriptBeginString;
				nextPutAll: aScript;
				nextPutAll: HtmlElement javascriptEndString]!

background: aString 
	background := aString!

color: aString 
	color := aString!

cssClass
	^cssClass!

cssClass: stringName 
	cssClass := stringName!

cssStyle: aCssStyle

	cssStyle := aCssStyle!

cssStyleAdd: aCssStyle 
	cssStyle := cssStyle add: aCssStyle withDelimiter: ';'!

elementId
	^elementId!

elementId: aStringOrSymbol 
	elementId := aStringOrSymbol asString!

generateOn: aStream 
	self subclassResponsibility!

setGreyBackground
	self background: '#f0f0f0'! !
!HtmlElement categoriesFor: #addBodyOnLoadScript:on:!private! !
!HtmlElement categoriesFor: #addJavascript:on:!private! !
!HtmlElement categoriesFor: #background:!public! !
!HtmlElement categoriesFor: #color:!public! !
!HtmlElement categoriesFor: #cssClass!public! !
!HtmlElement categoriesFor: #cssClass:!public! !
!HtmlElement categoriesFor: #cssStyle:!public! !
!HtmlElement categoriesFor: #cssStyleAdd:!public! !
!HtmlElement categoriesFor: #elementId!public! !
!HtmlElement categoriesFor: #elementId:!public! !
!HtmlElement categoriesFor: #generateOn:!public! !
!HtmlElement categoriesFor: #setGreyBackground!public! !

!HtmlElement class methodsFor!

ajaxLoadingIndicatorImageFragment
	^'<img src="images/ajax-loading.gif" width="16" height="16" border="0" alt="" />'!

javascriptBeginString
	^'<script type="text/javascript" language="JavaScript">
'!

javascriptEndString
	^'
</script>'!

openExcelDocumentsInNewWindow
	^true!

openOpenOfficeCalcDocumentsInNewWindow
	^true!

openOpenOfficeWriteDocumentsInNewWindow
	| session browserSettings |
	(session := self webSession) isNil 
		ifFalse: [browserSettings := session sessionData at: #browserSettings ifAbsent: []].
	(browserSettings isNil or: 
			[browserSettings docAttachmentOOWrite isNil 
				or: [browserSettings docAttachmentOOWrite == #docAttachmentOpenWithDefaultSettings]]) 
		ifFalse: [^browserSettings docAttachmentOOWrite == #docAttachmentOpenInNewWindow].
	^false!

openPdfDocumentsInNewWindow
	| session browserSettings |
	(session := self webSession) isNil 
		ifFalse: [browserSettings := session sessionData at: #browserSettings ifAbsent: []].
	(browserSettings isNil or: 
			[browserSettings docAttachmentPDF isNil 
				or: [browserSettings docAttachmentPDF == #docAttachmentOpenWithDefaultSettings]]) 
		ifFalse: [^browserSettings docAttachmentPDF == #docAttachmentOpenInNewWindow].
	^true!

openRtfDocumentsInNewWindow
	| session usesMsOffice |
	usesMsOffice := ((session := self webSession) notNil and: 
					[session user notNil and: 
							[(session user respondsTo: #officeAplikacijaOpenOffice) 
								and: [session user officeAplikacijaOpenOffice]]]) 
				not.
	^usesMsOffice 
		ifTrue: [self openWordDocumentsInNewWindow]
		ifFalse: [self openOpenOfficeWriteDocumentsInNewWindow]!

openRtfPdfDocumentsInNewWindow
	"This is temporarily always set to true until the print server is updated and considering browser settings."

	^true!

openWordDocumentsInNewWindow
	| session browserSettings |
	(session := self webSession) isNil 
		ifFalse: [browserSettings := session sessionData at: #browserSettings ifAbsent: []].
	(browserSettings isNil or: 
			[browserSettings docAttachmentWord isNil 
				or: [browserSettings docAttachmentWord == #docAttachmentOpenWithDefaultSettings]]) 
		ifFalse: [^browserSettings docAttachmentWord == #docAttachmentOpenInNewWindow].
	^self webRequest isInternetExplorer! !
!HtmlElement class categoriesFor: #ajaxLoadingIndicatorImageFragment!public! !
!HtmlElement class categoriesFor: #javascriptBeginString!public! !
!HtmlElement class categoriesFor: #javascriptEndString!public! !
!HtmlElement class categoriesFor: #openExcelDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openOpenOfficeCalcDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openOpenOfficeWriteDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openPdfDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openRtfDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openRtfPdfDocumentsInNewWindow!public! !
!HtmlElement class categoriesFor: #openWordDocumentsInNewWindow!public! !

