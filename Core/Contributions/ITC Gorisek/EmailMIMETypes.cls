"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #EmailMIMETypes
	instanceVariableNames: 'mimes encodings'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'singelton'!
EmailMIMETypes guid: (GUID fromString: '{945BFA7B-D6DA-42F7-86EA-9C43880CE43F}')!
EmailMIMETypes comment: ''!
!EmailMIMETypes categoriesForClass!Unclassified! !
!EmailMIMETypes methodsFor!

getEncoding: aString

	^encodings at: (self getType: aString) ifAbsent: [ 'base64' ]!

getType: aString

	^mimes at: aString ifAbsent: [ 'application/octet-stream' ]!

initEncodings
	encodings := LookupTable new.
	encodings
		at: 'text/html' put: '8bit';
		at: 'text/plain' put: '7bit'!

initialize

	self
		initMimes;
		initEncodings!

initMimes
	mimes := LookupTable new.
	mimes
		at: 'doc' put: 'application/msword';
		at: 'bin' put: 'application/octet-stream';
		at: 'lha' put: 'application/octet-stream';
		at: 'lza' put: 'application/octet-stream';
		at: 'exe' put: 'application/octet-stream';
		at: 'pdf' put: 'application/pdf';
		at: 'ps' put: 'application/postscript';
		at: 'rtf' put: 'application/rtf';
		at: 'xls' put: 'application/vnd.ms-excel';
		at: 'ppt' put: 'application/vnd.ms-powerpoint';
		at: 'gtar' put: 'application/x-gtar';
		at: 'js' put: 'application/x-javascript';
		at: 'swf' put: 'application/x-shockwave-flash';
		at: 'tar' put: 'application/x-tar';
		at: 'zip' put: 'application/zip';
		at: 'au' put: 'audio/basic';
		at: 'snd' put: 'audio/basic';
		at: 'mpga' put: 'audio/mpeg';
		at: 'mp2' put: 'audio/mpeg';
		at: 'mp3' put: 'audio/mpeg';
		at: 'aif' put: 'audio/x-aiff';
		at: 'aiff' put: 'audio/x-aiff';
		at: 'ram' put: 'audio/x-pn-realaudio';
		at: 'rm' put: 'audio/-pn-realaudio';
		at: 'ra' put: 'audio/x-realaudio';
		at: 'wav' put: 'audio/x-wav';
		at: 'bmp' put: 'image/bmp';
		at: 'gif' put: 'image/gif';
		at: 'jpeg' put: 'image/jpeg';
		at: 'jpg' put: 'image/jpeg';
		at: 'jpe' put: 'image/jpeg';
		at: 'png' put: 'image/png';
		at: 'tiff' put: 'image/tiff';
		at: 'tif' put: 'image/tiff';
		at: 'css' put: 'text/css';
		at: 'html' put: 'text/html';
		at: 'htm' put: 'text/html';
		at: 'txt' put: 'text/plain';
		at: 'asc' put: 'text/plain';
		at: 'rtf' put: 'text/rtf';
		at: 'xml' put: 'text/xml';
		at: 'mpeg' put: 'video/mpeg';
		at: 'mpg' put: 'video/mpeg';
		at: 'mpe' put: 'video/mpeg';
		at: 'qt' put: 'video/quicktime';
		at: 'mov' put: 'video/quicktime';
		at: 'avi' put: 'video/x-msvideo'! !
!EmailMIMETypes categoriesFor: #getEncoding:!public! !
!EmailMIMETypes categoriesFor: #getType:!public! !
!EmailMIMETypes categoriesFor: #initEncodings!public! !
!EmailMIMETypes categoriesFor: #initialize!public! !
!EmailMIMETypes categoriesFor: #initMimes!public! !

!EmailMIMETypes class methodsFor!

default
	singelton isNil 
		ifTrue: 
			[singelton := EmailMIMETypes new.
			singelton initialize].
	^singelton!

reset

	singelton := nil! !
!EmailMIMETypes class categoriesFor: #default!public! !
!EmailMIMETypes class categoriesFor: #reset!public! !

