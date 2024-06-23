"Filed out from Dolphin Smalltalk"!

External.PermanentLibrary
	subclass: #'OS.CRTLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.CRTLibrary guid: (Core.GUID fromString: '{87b4c58b-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.CRTLibrary comment: 'CRTLibrary is the <ExternalLibrary> class to represent the MS C run-time library, MSVCRT.DLL.

The C runtime library is linked with the VM and is therefore permanently available. It provides many useful services (some of which are not wrapped at present) and is used quite extensively by the base image to avoid re-inventing the wheel and to keep the image size down.

If there is a function of the C runtime library which you wish to make use of then you should add it using the existing methods as a guide. It is possible to call vararg functions, but you may need to add a number of methods with increasing numbers of arguments. Note that all the functions use the cdecl calling convention.'!

!OS.CRTLibrary categoriesForClass!External-Libraries! !

!OS.CRTLibrary methodsFor!

_chsize_s: fdInteger size: sizeInteger
	<cdecl: errno _chsize_s int32 int64>
	^self invalidCall: _failureCode!

_clearfp
	"Clear and return the floating point status word

		unsigned int _clearfp( void );"

	<cdecl: uint32 _clearfp>
	^self invalidCall: _failureCode!

_close: anInteger
	"Close the file associated with the descriptor, anInteger, and release the descriptor."

	<cdecl: int32 _close int32>
	^self invalidCall: _failureCode!

_control87: newInteger mask: maskInteger
	<cdecl: int32 _control87 uint32 uint32>
	^self invalidCall: _failureCode!

_dup: anInteger
	"Create and answer a duplicate file descriptor for the open file with descriptor, anInteger.
	Note that the underlying file handle is also duplicated."

	<cdecl: int32 _dup int32>
	^self invalidCall: _failureCode!

_dup2: anInteger handle2: anInteger2
	"Reassign a file descriptor by copying a duplicate of the file descriptor, anInteger, over
	the file descriptor, anInteger2. Note that the underlying file handle of the first
	descriptor is duplicated, and any open file associated with the target file descriptor is
	closed."

	<cdecl: int32 _dup2 int32 int32>
	^self invalidCall: _failureCode!

_errno
	"Answer a pointer to the errno variable."

	<cdecl: void* _errno>
	^self invalidCall: _failureCode!

_fdopen: anInteger mode: aString
	"Associate a stream with an open file handle.
		FILE *_fdopen( int handle, const char *mode );
	Note that we treat the stdio FILE* pointer as an opaque handle, as these
	are automatically nulled on image load."

	<cdecl: handle _fdopen int32 lpstr>
	^self invalidCall: _failureCode!

_filelengthi64: handleInteger
	<cdecl: int64 _filelengthi64 int32>
	^self invalidCall: _failureCode!

_fileno: aFILE
	"Answer the <integer> file number of a CRT FILE stream."

	<cdecl: int32 _fileno handle>
	^self invalidCall: _failureCode!

_fseeki64: aFILE offset: offsetInteger origin: originInteger
	<cdecl: int32 _fseeki64 handle int64 int32>
	^self invalidCall: _failureCode!

_ftelli64: anExternalHandle
	"Answer the <integer> position (zero-based) of the CRT FILE stream."

	<cdecl: int64 _ftelli64 handle>
	^self invalidCall: _failureCode!

_get_osfhandle: anInteger
	<cdecl: handle _get_osfhandle int32>
	^self invalidCall: _failureCode!

_isatty: anInteger
	<cdecl: bool _isatty int32>
	^self invalidCall: _failureCode!

_makepath_s: path bufferSize: sizeInBytes drive: drive dir: dir fname: fname ext: ext
	<cdecl: errno _makepath_s char* intptr char* char* char* char*>
	^self invalidCall: _failureCode!

_open_osfhandle: osfhandle flags: flags
	<cdecl: int32 _open_osfhandle handle int32>
	^self invalidCall: _failureCode!

_setmode: fd mode: modeFlag
	<cdecl: int32 _setmode int32 int32>
	^self invalidCall: _failureCode!

_splitpath_s: path drive: drive driveLen: driveInteger dir: dir dirLen: dirInteger fname: fname fnameLen: nameInteger ext: ext extLen: extInteger
	<cdecl: errno _splitpath_s char* char* intptr char* intptr char* intptr char* intptr>
	^self invalidCall: _failureCode!

_statusfp
	<cdecl: uint32 _statusfp>
	^self invalidCall: _failureCode!

_wcserror_s: buffer sizeInWords: sizeInWords errnum: errnum
	<cdecl: errno _wcserror_s lpwstr uintptr int32>
	^_failureCode!

_wfsopen: nameString mode: modeString shflag: shflagInteger
	<cdecl: handle _wfsopen lpwstr lpwstr int32>
	^self invalidCall: _failureCode!

atoi: aString
	"Convert a String to an integer.

		int atoi( const char *string );"

	<cdecl: int32 atoi lpstr>
	^self invalidCall: _failureCode!

close
	"The C-runtime library cannot be closed."

	^false!

errno
	"Answer the <integer> value of the last recorded CRT error."

	^self _errno int32AtOffset: 0!

fclose: anAddress
	"Closes the specified stream. Answers 0 if successful.
			int fclose( FILE *stream );"

	<cdecl: int32 fclose handle>
	^self invalidCall: _failureCode!

feof: stream
	<cdecl: bool feof handle>
	^self invalidCall: _failureCode!

fflush: anExternalAddress
	<cdecl: int32 fflush handle>
	^self invalidCall: _failureCode!

fgetc: aFILE
	<cdecl: int32 fgetc handle>
	^self invalidCall: _failureCode!

fgets: buf n: bufsize stream: aFILE
	<cdecl: int32 fgets lpstr int32 handle>
	^self invalidCall: _failureCode!

fgetwc: aFILE
	<cdecl: int32 fgetwc handle>
	^self invalidCall: _failureCode!

fgetws: buf n: bufsize stream: aFILE
	<cdecl: intptr fgetws lpwstr int32 handle>
	^self invalidCall: _failureCode!

fputc: charValue stream: aFILE
	<cdecl: int32 fputc int32 handle>
	^self invalidCall: _failureCode!

fputs: str stream: aFILE
	<cdecl: int32 fputs lpstr handle>
	^self invalidCall: _failureCode!

fputwc: charValue stream: aFILE
	<cdecl: int32 fputwc int32 handle>
	^self invalidCall: _failureCode!

fputws: str stream: aFILE
	<cdecl: int32 fputws lpwstr handle>
	^self invalidCall: _failureCode!

fread_s: buffer bufferSize: bufsizeInteger elementSize: elemSizeInteger count: countInteger stream: aFILE
	<cdecl: int32 fread_s lpvoid intptr intptr intptr handle>
	^self invalidCall: _failureCode!

free: memblock
	<cdecl: void free lpvoid>
	^self invalidCall: _failureCode!

fwrite: data size: sizeInteger count: countInteger stream: aFILE
	<cdecl: int32 fwrite lpvoid intptr intptr handle>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize and answer the receiver."

	self synchronizeLocale.
	^self!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive. If the function has an errno return type, then the value may be a errno_t value (a small positive integer) from the CRT error codes. Usually only the more modern 'secure' CRT functions have a signature with an errno_t return code. One of these error codes, STRUNCATE, is more of a status code than an error, indicating that the function truncated input, e.g. when copying to a buffer. For all other errno's we throw a CRTError exception."

	^anInteger < 0
		ifTrue: [self invalidCall: anInteger fromFrame: Processor activeProcess topFrame sender]
		ifFalse: 
			[anInteger == CRTConstants.STRUNCATE ifTrue: [anInteger] ifFalse: [CRTError signalWith: anInteger]]!

isNonBlocking
	^false!

memcmp: buf1 buf2: buf2 count: count
	"Compare the first count bytes in two buffers, answering <0 if buf1 is < buf2, 0 if equal,
	and >0 if buf2 > buf1.

		int memcmp( const void *buf1, const void *buf2, size_t count );"

	<cdecl: int32 memcmp lpvoid lpvoid intptr>
	^self invalidCall: _failureCode!

memcpy_s: dest destSize: destSize src: src count: count
	<cdecl: errno memcpy_s void* uint32 void* uint32>
	^self invalidCall: _failureCode!

setlocale: category locale: localeString
	"Set a specified locale category.

		char *setlocale( int category, const char *locale );	"

	<cdecl: lpstr setlocale int32 lpstr>
	^self invalidCall: _failureCode!

strlen: aString
	<cdecl: int32 strlen lpvoid>
	^self invalidCall: _failureCode!

synchronizeLocale
	"Private - Synchronize the CRT's locale with the OS locale setting."

	self setlocale: CRTConstants.LC_ALL locale: ''!

ungetc: c stream: stream
	"Pushes the byte, c, back onto the FILE*, stream."

	<cdecl: int32 ungetc int32 handle>
	^self invalidCall: _failureCode!

ungetwc: c stream: stream
	"Pushes the UTF-16 code unit, c, back onto the FILE*, stream."

	<cdecl: int32 ungetwc int32 handle>
	^self invalidCall: _failureCode!

wcslen: aString
	<cdecl: int32 wcslen lpvoid>
	^self invalidCall: _failureCode!

wcsncpy_s: strDestination bufferSize: numberOfElements strSource: strSource count: count
	<cdecl: errno wcsncpy_s lpvoid uintptr lpwstr uintptr>
	^self invalidCall: _failureCode! !

!OS.CRTLibrary categoriesForMethods!
_chsize_s:size:!CRT functions-file handling!public! !
_clearfp!CRT functions-floating point support!public! !
_close:!CRT functions-low level I/O!public! !
_control87:mask:!CRT functions-floating point support!public! !
_dup:!CRT functions-low level I/O!public! !
_dup2:handle2:!CRT functions-low level I/O!public! !
_errno!CRT functions-process and environment control!public! !
_fdopen:mode:!CRT functions-stream I/O!public! !
_filelengthi64:!CRT functions-file handling!public! !
_fileno:!CRT functions-stream I/O!public! !
_fseeki64:offset:origin:!CRT functions-stream I/O!public! !
_ftelli64:!CRT functions-stream I/O!public! !
_get_osfhandle:!CRT functions-file handling!public! !
_isatty:!CRT functions-file handling!public! !
_makepath_s:bufferSize:drive:dir:fname:ext:!CRT functions-file handling!public! !
_open_osfhandle:flags:!CRT functions-file handling!public! !
_setmode:mode:!CRT functions-file handling!public! !
_splitpath_s:drive:driveLen:dir:dirLen:fname:fnameLen:ext:extLen:!CRT functions-file handling!public! !
_statusfp!CRT functions-floating point support!public! !
_wcserror_s:sizeInWords:errnum:!CRT functions-string manipulation!public! !
_wfsopen:mode:shflag:!CRT functions-stream I/O!public! !
atoi:!CRT functions-data conversion!public! !
close!public!realizing/unrealizing! !
errno!CRT functions-process and environment control!public! !
fclose:!CRT functions-stream I/O!public! !
feof:!CRT functions-stream I/O!public! !
fflush:!CRT functions-stream I/O!public! !
fgetc:!CRT functions-stream I/O!public! !
fgets:n:stream:!CRT functions-stream I/O!public! !
fgetwc:!CRT functions-stream I/O!public! !
fgetws:n:stream:!CRT functions-stream I/O!public! !
fputc:stream:!CRT functions-stream I/O!public! !
fputs:stream:!CRT functions-stream I/O!public! !
fputwc:stream:!CRT functions-stream I/O!public! !
fputws:stream:!CRT functions-stream I/O!public! !
fread_s:bufferSize:elementSize:count:stream:!CRT functions-stream I/O!public! !
free:!CRT functions-memory allocation!public! !
fwrite:size:count:stream:!CRT functions-stream I/O!public! !
initialize!initializing!private! !
invalidCall:!exceptions!private! !
isNonBlocking!public!testing! !
memcmp:buf2:count:!CRT functions-buffer manipulation!public! !
memcpy_s:destSize:src:count:!CRT functions-buffer manipulation!public! !
setlocale:locale:!CRT functions-localization!public! !
strlen:!CRT functions-string manipulation!public! !
synchronizeLocale!CRT functions-localization!private! !
ungetc:stream:!CRT functions-stream I/O!public! !
ungetwc:stream:!CRT functions-stream I/O!public! !
wcslen:!CRT functions-string manipulation!public! !
wcsncpy_s:bufferSize:strSource:count:!CRT functions-string manipulation!public! !
!

!OS.CRTLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^File splitStemFrom: self default fileName!

nonblocking
	"Answer the instance of the receiver to use for overlapped invocations of CRT library functions."

	^CRTLibraryNonBlocking default!

open
	"Answer a new instance of the receiver to represent the CRT DLL."

	^(self fromHandle: VM crtHandle) initialize!

sharedVariableName
	^#{Ucrt}! !

!OS.CRTLibrary class categoriesForMethods!
fileName!constants!public! !
nonblocking!accessing!public! !
open!instance creation!public! !
sharedVariableName!constants!private! !
!

