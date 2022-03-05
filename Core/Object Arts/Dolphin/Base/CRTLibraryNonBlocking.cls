"Filed out from Dolphin Smalltalk"!

CRTLibrary subclass: #CRTLibraryNonBlocking
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibraryNonBlocking guid: (GUID fromString: '{3214435f-9afe-47b3-8f9b-0d4b533d5b1d}')!
CRTLibraryNonBlocking comment: ''!
!CRTLibraryNonBlocking categoriesForClass!External-Libraries! !
!CRTLibraryNonBlocking methodsFor!

_errno
	<overlap cdecl: void* _errno>
	^self invalidCall: _failureCode!

chmod: aFilenameString pmode: aModeInteger
	<overlap cdecl: sdword _chmod lpstr sdword>
	^self invalidCall: _failureCode!

fgetc: aFILE
	<overlap cdecl: sdword fgetc handle>
	^self invalidCall: _failureCode!

fgets: buf n: bufsize stream: aFILE
	<overlap cdecl: sdword fgets lpstr sdword handle>
	^self invalidCall: _failureCode!

fgetwc: aFILE
	<overlap cdecl: sdword fgetwc handle>
	^self invalidCall: _failureCode!

fgetws: buf n: bufsize stream: aFILE
	<overlap cdecl: intptr fgetws lpwstr sdword handle>
	^self invalidCall: _failureCode!

fread_s: buffer bufferSize: bufsizeInteger elementSize: elemSizeInteger count: countInteger stream: aFILE
	<overlap cdecl: sdword fread_s lpvoid intptr intptr intptr handle>
	^self invalidCall: _failureCode! !
!CRTLibraryNonBlocking categoriesForMethods!
_errno!CRT functions-process and environment control!public! !
chmod:pmode:!CRT functions-file handling!public! !
fgetc:!CRT functions-stream I/O!public! !
fgets:n:stream:!CRT functions-stream I/O!public! !
fgetwc:!CRT functions-stream I/O!public! !
fgetws:n:stream:!CRT functions-stream I/O!public! !
fread_s:bufferSize:elementSize:count:stream:!CRT functions-stream I/O!public! !
!

