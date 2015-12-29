"Filed out from Dolphin Smalltalk X6.1"!

WebHttpScriptFileServlet subclass: #WebHttpCssFileServlet
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WebHttpCssFileServlet guid: (GUID fromString: '{0B0BB71C-7190-4FEB-B675-571C631234E6}')!
WebHttpCssFileServlet comment: ''!
!WebHttpCssFileServlet categoriesForClass!Unclassified! !
!WebHttpCssFileServlet methodsFor!

doMinify
	^false!

getCachedCssContentFor: selector 
	| array |
	(array := self cacheAt: selector) isNil 
		ifTrue: 
			[array := self 
						createTimestampWithContents: ((selector == #cssStyleItcExt 
								or: [selector == #cssStyleItcExtForMobileClient]) 
									ifTrue: [self class cssPrivateItcExt]
									ifFalse: [application perform: selector]).
			self cacheAt: selector put: array].
	^array!

processGet: request on: stream 
	| selector array css modification fileSize ifModifiedSince |
	((selector := self extractFilenameFrom: request) notNil 
		and: [self supportedStyleSheets includes: selector]) ifFalse: [^stream fileNotFoundResponse].
	request isMobileBrowser ifTrue: [selector := (selector asString , 'ForMobileClient') asSymbol].
	array := self getCachedCssContentFor: selector.
	css := array at: 2.
	fileSize := css size.
	modification := array at: 1.
	((ifModifiedSince := request header ifModifiedSince) notNil and: 
			[(ifModifiedSince last isNil or: [ifModifiedSince last = fileSize]) and: 
					[ifModifiedSince first date = modification date and: 
							[ifModifiedSince first time minutes = modification time minutes 
								and: [ifModifiedSince first time seconds = modification time seconds]]]]) 
		ifTrue: [^stream notModifiedResponse].
	ItcSystemManager logDevTimeError: 'CSS download: ' , selector.
	stream nextPutAll: css.
	stream
		expires: (Timestamp date: (Date today addDays: 10) time: Time now);
		cacheControl: 'max-age=864000, public';
		date: modification;
		lastModified: modification;
		contentType: 'text/css'!

servletNamePrefix
	^'css'!

supportedStyleSheets
	^#(#cssStyleItcDefault #cssStyleItcExt #cssStyleTopFrame)! !
!WebHttpCssFileServlet categoriesFor: #doMinify!private! !
!WebHttpCssFileServlet categoriesFor: #getCachedCssContentFor:!private! !
!WebHttpCssFileServlet categoriesFor: #processGet:on:!public! !
!WebHttpCssFileServlet categoriesFor: #servletNamePrefix!private! !
!WebHttpCssFileServlet categoriesFor: #supportedStyleSheets!private! !

!WebHttpCssFileServlet class methodsFor!

cssPrivateItcExt
	^'.itc-x-button-icon .x-btn-text {background-image: url(../images/toolBar_icons.gif);}
.itc-grid-field-error {background-image: url(../images/default/grid/invalid_line.gif);
	background-repeat: repeat-x;
	background-position: bottom;}
.x-form-field-wrap .grid-calendar-button {
	background:transparent url(../images/koledar.gif) no-repeat 0 0;
	cursor:pointer;
}
.itc-grid {
	border: 1px solid black;
}'! !
!WebHttpCssFileServlet class categoriesFor: #cssPrivateItcExt!private! !

