"Filed out from Dolphin Smalltalk X6.1"!

WebHttpServlet subclass: #WikiDocGetRequestParameterFromUrlServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WikiDocGetRequestParameterFromUrlServlet guid: (GUID fromString: '{4A1B6521-426D-474C-8C29-76C553DFFC0C}')!
WikiDocGetRequestParameterFromUrlServlet comment: ''!
!WikiDocGetRequestParameterFromUrlServlet categoriesForClass!Unclassified! !
!WikiDocGetRequestParameterFromUrlServlet methodsFor!

process: request on: stream 
	| result parameterName |
	(parameterName := request stringAt: 'paramName') isNilOrEmpty 
		ifFalse: 
			[result := (Processor activeProcess attributes at: #originalHttpRequest ifAbsent: [request]) 
						stringAt: parameterName].
	result isNilOrEmpty 
		ifTrue: 
			[(parameterName := request stringAt: 'encodedParamName') isNilOrEmpty 
				ifFalse: 
					[result := ((Processor activeProcess attributes at: #originalHttpRequest ifAbsent: [request]) 
								stringAt: parameterName) webDeserializeFromString]].
	stream nextPutAll: (result isNilOrEmpty ifTrue: [' '] ifFalse: [result webHtmlEncoded])! !
!WikiDocGetRequestParameterFromUrlServlet categoriesFor: #process:on:!public! !

!WikiDocGetRequestParameterFromUrlServlet class methodsFor!

COMMENT
	"This servlet makes it possible to insert dynamic contents into WikiPage which is set from its URL. For instance:

	GET url:

	/WikiDoc/WikiPage?page=SomePage&a=Some+text+for+testing

	WikiDoc source:

	<div src=''/WikiDoc/GetRequestParameterFromUrl?paramName=a''></div>

	On rendering the div above will be replace with the value of parameter ''a'' as set with the calling URL =>  'Some text for testing'


	This is primarily used for e-racuni server where the ASP server always redirects to the homepage for instance when the login was unsuccessfull and it has to display the error message."

	!

servletName
	^'GetRequestParameterFromUrl'! !
!WikiDocGetRequestParameterFromUrlServlet class categoriesFor: #COMMENT!public! !
!WikiDocGetRequestParameterFromUrlServlet class categoriesFor: #servletName!public! !

