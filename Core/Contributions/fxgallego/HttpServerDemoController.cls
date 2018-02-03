"Filed out from Dolphin Smalltalk 7"!

Object subclass: #HttpServerDemoController
	instanceVariableNames: 'request response'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HttpServerDemoController guid: (GUID fromString: '{95bba584-e6aa-4364-994b-d35e9fa2652a}')!
HttpServerDemoController comment: ''!
!HttpServerDemoController categoriesForClass!Kernel-Objects! !
!HttpServerDemoController methodsFor!

actionSelectors
	^self class selectorsInCategory: (MethodCategory name: 'actions')!

bootstrapSiteExample
	self respondOk: self bootstrapSiteExampleView!

bootstrapSiteExampleView
	^'
	<!!DOCTYPE html>
	<html lang=en>
		<head>
		<title>Dolphin Smalltalk Bootstrap Site Example</title>
		<!!-- Required meta tags -->
		<meta charset="utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/css/bootstrap.min.css" integrity="sha384-Zug+QiDoJOrZ5t4lssLdxGhVrurbmBWopoEl+M6BdEfwnCJZtKxi1KgxUyJq13dy" crossorigin="anonymous">
		</head>
		<body>
		<nav class="navbar navbar-expand-lg navbar-light bg-light">
		  <a class="navbar-brand" href="#">Dolphin Smalltalk</a>
		  <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
		    <span class="navbar-toggler-icon"></span>
		  </button>

		  <div class="collapse navbar-collapse" id="navbarSupportedContent">
		    <ul class="navbar-nav mr-auto">
		      <li class="nav-item active">
			<a class="nav-link" href="/">Home <span class="sr-only">(current)</span></a>
		      </li>
		      <li class="nav-item">
			<a class="nav-link" href="#">Link</a>
		      </li>
		      <li class="nav-item dropdown">
			<a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
			  Dropdown
			</a>
			<div class="dropdown-menu" aria-labelledby="navbarDropdown">
			  <a class="dropdown-item" href="#">Action</a>
			  <a class="dropdown-item" href="#">Another action</a>
			  <div class="dropdown-divider"></div>
			  <a class="dropdown-item" href="#">Something else here</a>
			</div>
		      </li>
		      <li class="nav-item">
			<a class="nav-link disabled" href="#">Disabled</a>
		      </li>
		    </ul>
		    <form class="form-inline my-2 my-lg-0">
		      <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search">
		      <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
		    </form>
		  </div>
		</nav>
		<h1> Hello From Dolphin Smalltalk!! </h1>
		<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta.3/js/bootstrap.min.js" integrity="sha384-a5N7Y/aK3qNeh15eJKGWxsqtnX/wWdSZSKp+81YjTmS15nvnvxKHuzaWwXHDli+4" crossorigin="anonymous"></script>
		</body>
	</html>
	'!

cookieTest
	| name |
	name := (self request paramAt: 'name') ifNil: [''].
	name notEmpty
		ifTrue: 
			[self response addCookie: ((HttpServerCookie name: 'cookie-test-name' value: name displayString)
						expiresLocalTime: (TimeStamp current addSeconds: 20);
						yourself)].
	self respondOk: self cookieTestView!

cookieTestView
	^'<a href="/"> Back to index </a>
	<br>
	<h3>Cookie test</h3>
	<p>Submit some data in the form and the server will send you it back in a cookie.<br>
		The response page will show you the cookie contents using javascript. <br>
		You can double check using the browser''s inspector.</p>
	<form  action="/cookieTest" method="post" enctype="multipart/form-data">
		<label for="text-input"> Your Name: </label>
		<input id="name"  name="name" type="text">
		<input type="submit" value="submit" id="submit" />
	<h3>Cookie data (read by javascript)</h3>
	<p><a href="/cookieTest">Reload</a> to check the cookie expired. It should expire within 15 seconds<p>
	<ul>
		<li>The cookie says your name is: <span id="cookie-value"></span></li>
	</ul>
	</form>
	<script>
		function getCookie(name) {
		  match = document.cookie.match(new RegExp(name + "=([^;]+)"));
		  if (match) return match[1];
		}
		document.getElementById("cookie-value").innerHTML = "<b>" + getCookie("cookie-test-name") + "</b>";		
	</script>
	'!

file
	"asUnicodeString used because an equality bug in string and unicodestring comparison"

	| name |
	name := self request queryFields at: 'name'.
	(name notNil & name notEmpty and: [File exists: File tempPath , name]) ifFalse: [^self notFound].
	self respondOk: (File readAllBytes: File tempPath , name)!

formEdit
	self respondOk: self formEditView!

formEditView
	^'<a href="/"> Back to index </a>
	<br>
	<h3>Form and File upload test</h3>
	<p>Try writing a name with special or unicode characters.</p>
	<form  action="/formPost?query-param=fooBar" method="post" enctype="multipart/form-data">
		<label for="text-input"> Your Name: </label>
		<input id="name"  name="name" type="text">
		<label for="lang"> Favourite Proggraming Language: </label>
		<select id="lang" name="lang">
		  <option value="C">C</option>
		  <option value="C++">C++</option>
		  <option value="Java">Java</option>
		  <option value="Smalltalk">Smalltalk</option>
		</select>
		<label for="picture"> Upload your picture: </label>
		<input id="picture" name="picture" type="file" accept="image/*" />
		<input type="submit" value="submit" id="submit" />
	</form>
	'!

formPost
	self respondOk: self formPostView
	!

formPostView
	| name lang picture queryParam|
	name := self request paramAt: 'name'.
	lang := self request paramAt: 'lang'.
	picture := self request paramAt: 'picture'.
	queryParam := self request paramAt: 'query-param'.
	^'<a href="/"> Back to index </a>
	<ul>
		<li>Your name: %1</li>
		<li>Your favourite language: %2</li>
		<li>Your picture: <img src="./file?name=%3"></li>
		<li>This parameter comes along with the query, not the form fields, and should be "fooBar": %4</li>
	</ul>
	' formatWith: name displayString with: lang displayString with: (picture ifNil: [''] ifNotNil: [picture tempFile]) with: queryParam displayString!

handle
	| actionName action |
	actionName := (self request path copyReplaceAll: '/' with: '') asLowercase.
	actionName isEmpty ifTrue: [^self index].
	action := self actionSelectors detect: [:each | each asLowercase = actionName asString] ifNone: [#notFound].
	self perform: action!

hello
	^self respondOk: 'Hello from Dolphin'
	!

index
	self respondOk: self indexView!

indexView
	^'<h1>Hello from Dolphin HTTP Server!!</h1>
	<ul>
		<li><a href="/redirectTest">Redirect test (redirect to Google) </a></li>
		<li><a href="/formEdit">Form and file upload</a></li>
		<li><a href="/urlParamsTest?name=foo&age=30&ids=1&ids=2&utfvalue=%E1%9A%A0%E1%9B%87%E1%9A%BB%E1%9B%AB%E1%9B%92%E1%9B%A6%E1%9A%A6%E1%9B%AB%E1%9A%A0%E1%9A%B1%E1%9A%A9%E1%9A%A0%E1%9A%A2%E1%9A%B1%E1%9B%AB%E1%9A%A0%E1%9B%81%E1%9A%B1%E1%9A%AA%E1%9B%AB%E1%9A%B7%E1%9B%96%E1%9A%BB%E1%9A%B9%E1%9B%A6%E1%9B%9A%E1%9A%B3%E1%9A%A2%E1%9B%97&%E1%83%95%E1%83%94%E1%83%9E%E1%83%AE%E1%83%98%E1%83%A1%20%E1%83%A2%E1%83%A7%E1%83%90%E1%83%9D%E1%83%A1%E1%83%90%E1%83%9C%E1%83%98%20%E1%83%A8%E1%83%9D%E1%83%97%E1%83%90%20%E1%83%A0%E1%83%A3%E1%83%A1%E1%83%97%E1%83%90%E1%83%95%E1%83%94%E1%83%9A%E1%83%98=utfkey">URL params test</a></li>
		<li><a href="/bootstrapSiteExample">Botstrap Site Example</a></li>
		<li><a href="/uploadAndDownloadFileEdit">Upload and download attached file (max 100MB set in #maxPayload method)</a></li>
		<li><a href="/cookieTest">Cookie test</a></li>
	</ul>
	'!

notFound
	self response
		statusCode: 404;
		reason: 'Resource not found';
		contentType: 'text/html';
		content: ('<h1>404 - Resource "%1" not found</h1>' formatWith: self request path asString)
					, (String streamContents: 
								[:stream |
								stream
									nextPutAll: '<h3> Known actions are: </h3>';
									nextPutAll: '<ul>'.
								self actionSelectors do: [:each | stream nextPutAll: '<li>' , each asString , '</li>'].
								stream nextPutAll: '</ul>'])!

redirectTest
	self response
		statusCode: 302;
		reason: 'Found';
		content: ' ';
		headerAt: 'Location' put: '//www.google.com'!

request
	^request!

request: anObject
	request := anObject!

respondOk: contents
	self respondOk: contents contentType: 'text/html; charset=utf-8'!

respondOk: contents contentType: type
	self response
		statusCode: 200;
		reason: 'OK';
		contentType: type;
		content: contents!

response
	^response!

response: anObject
	response := anObject!

uploadAndDownloadFileEdit
	^self respondOk: self uploadAndDownloadFileEditView!

uploadAndDownloadFileEditView
	^'<a href="/"> Back to index </a>
	<br>
	<h3>File upload test</h3>
	<p>The uploaded file will be sent to you again with the same name and extension.</p>
	<form  action="/uploadAndDownloadFilePost" method="post" enctype="multipart/form-data">
		<label for="file"> Upload your picture: </label>
		<input id="file" name="uploadedfile" type="file" accept="*/*" />
		<input type="submit" value="submit" id="submit" />
	</form>
	'!

uploadAndDownloadFilePost
	| file |
	file := self request postFields at: 'uploadedfile' ifAbsent: [].
	(file isNil or: [file fileName isEmpty]) ifTrue: [^self respondOk: 'No file uploaded. <a href="/uploadAndDownloadFileEdit">Go Back</a>'].
	self response attachFile: file!

urlParamsTest
	self respondOk: self urlParamsTestView!

urlParamsTestView
	^(String streamContents: 
			[:stream |
			stream
				nextPutAll: '<a href="/"> Back to index </a><h1>Received Params</h1>';
				nextPutAll: '<p>Test that keys and values in query are correctly decoded handling unicode.<br>You can test your own combinations changing the url.<p>';
				nextPutAll: '<ul>'.
			self request queryFields keysAndValuesDo: 
					[:eachKey :eachValue |
					stream
						nextPutAll: '<li>';
						nextPutAll: eachKey;
						nextPutAll: ': ';
						nextPutAll: eachValue displayString;
						nextPutAll: '</li>'].
			stream nextPutAll: '</ul>'])! !
!HttpServerDemoController categoriesFor: #actionSelectors!private! !
!HttpServerDemoController categoriesFor: #bootstrapSiteExample!actions!private! !
!HttpServerDemoController categoriesFor: #bootstrapSiteExampleView!private!templates! !
!HttpServerDemoController categoriesFor: #cookieTest!actions!private! !
!HttpServerDemoController categoriesFor: #cookieTestView!private!templates! !
!HttpServerDemoController categoriesFor: #file!actions!private! !
!HttpServerDemoController categoriesFor: #formEdit!actions!private! !
!HttpServerDemoController categoriesFor: #formEditView!private!templates! !
!HttpServerDemoController categoriesFor: #formPost!actions!private! !
!HttpServerDemoController categoriesFor: #formPostView!private!templates! !
!HttpServerDemoController categoriesFor: #handle!private! !
!HttpServerDemoController categoriesFor: #hello!actions!private! !
!HttpServerDemoController categoriesFor: #index!actions!private! !
!HttpServerDemoController categoriesFor: #indexView!private!templates! !
!HttpServerDemoController categoriesFor: #notFound!actions!private! !
!HttpServerDemoController categoriesFor: #redirectTest!actions!private! !
!HttpServerDemoController categoriesFor: #request!accessing!private! !
!HttpServerDemoController categoriesFor: #request:!accessing!private! !
!HttpServerDemoController categoriesFor: #respondOk:!private! !
!HttpServerDemoController categoriesFor: #respondOk:contentType:!private! !
!HttpServerDemoController categoriesFor: #response!accessing!private! !
!HttpServerDemoController categoriesFor: #response:!accessing!private! !
!HttpServerDemoController categoriesFor: #uploadAndDownloadFileEdit!actions!private! !
!HttpServerDemoController categoriesFor: #uploadAndDownloadFileEditView!private!templates! !
!HttpServerDemoController categoriesFor: #uploadAndDownloadFilePost!actions!private! !
!HttpServerDemoController categoriesFor: #urlParamsTest!actions!private! !
!HttpServerDemoController categoriesFor: #urlParamsTestView!private!templates! !

!HttpServerDemoController class methodsFor!

handle: aHttpServerRequest with: aHttpServerResponse
	^self new
		request: aHttpServerRequest;
		response: aHttpServerResponse;
		handle! !
!HttpServerDemoController class categoriesFor: #handle:with:!public! !

