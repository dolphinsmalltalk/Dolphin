"Filed out from Dolphin Smalltalk"!

OS.CRTLibrary
	subclass: #'OS.CRTLibraryNonBlocking'
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

fgetc: aFILE
	<overlap cdecl: int32 fgetc handle>
	^self invalidCall: _failureCode!

fgets: buf n: bufsize stream: aFILE
	<overlap cdecl: int32 fgets lpstr int32 handle>
	^self invalidCall: _failureCode!

fgetwc: aFILE
	<overlap cdecl: int32 fgetwc handle>
	^self invalidCall: _failureCode!

fgetws: buf n: bufsize stream: aFILE
	<overlap cdecl: intptr fgetws lpwstr int32 handle>
	^self invalidCall: _failureCode!

fread_s: buffer bufferSize: bufsizeInteger elementSize: elemSizeInteger count: countInteger stream: aFILE
	<overlap cdecl: int32 fread_s lpvoid intptr intptr intptr handle>
	^self invalidCall: _failureCode! !
!OS.CRTLibraryNonBlocking categoriesForMethods!
_errno!CRT functions-process and environment control!public! !
fgetc:!CRT functions-stream I/O!public! !
fgets:n:stream:!CRT functions-stream I/O!public! !
fgetwc:!CRT functions-stream I/O!public! !
fgetws:n:stream:!CRT functions-stream I/O!public! !
fread_s:bufferSize:elementSize:count:stream:!CRT functions-stream I/O!public! !
!

!OS.CRTLibraryNonBlocking class methodsFor!

sharedVariableName
	^nil! !
!OS.CRTLibraryNonBlocking class categoriesForMethods!
sharedVariableName!constants!private! !
!

