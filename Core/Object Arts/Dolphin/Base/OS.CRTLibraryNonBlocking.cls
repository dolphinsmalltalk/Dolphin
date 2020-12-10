"Filed out from Dolphin Smalltalk 7"!

OS.CRTLibrary subclass: #'OS.CRTLibraryNonBlocking'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.CRTLibraryNonBlocking guid: (Core.GUID fromString: '{3214435f-9afe-47b3-8f9b-0d4b533d5b1d}')!
OS.CRTLibraryNonBlocking comment: ''!
!OS.CRTLibraryNonBlocking categoriesForClass!External-Libraries! !
!OS.CRTLibraryNonBlocking methodsFor!

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
!OS.CRTLibraryNonBlocking categoriesFor: #_errno!CRT functions-process and environment control!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #chmod:pmode:!CRT functions-file handling!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #fgetc:!CRT functions-stream I/O!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #fgets:n:stream:!CRT functions-stream I/O!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #fgetwc:!CRT functions-stream I/O!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #fgetws:n:stream:!CRT functions-stream I/O!public! !
!OS.CRTLibraryNonBlocking categoriesFor: #fread_s:bufferSize:elementSize:count:stream:!CRT functions-stream I/O!public! !

