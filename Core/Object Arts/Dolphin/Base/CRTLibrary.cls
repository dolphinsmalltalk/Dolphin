"Filed out from Dolphin Smalltalk 7"!

PermanentLibrary subclass: #CRTLibrary
	instanceVariableNames: 'decimalSeparator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibrary guid: (GUID fromString: '{87b4c58b-026e-11d3-9fd7-00a0cc3e4a32}')!
CRTLibrary comment: 'CRTLibrary is the <ExternalLibrary> class to represent the MS C run-time library, MSVCRT.DLL.

The C runtime library is linked with the VM and is therefore permanently available. It provides many useful services (some of which are not wrapped at present) and is used quite extensively by the base image to avoid re-inventing the wheel and to keep the image size down.

If there is a function of the C runtime library which you wish to make use of then you should add it using the existing methods as a guide. It is possible to call vararg functions, but you may need to add a number of methods with increasing numbers of arguments. Note that all the functions use the cdecl calling convention.'!
!CRTLibrary categoriesForClass!External-Libraries! !
!CRTLibrary methodsFor!

__iscsym: aCharacter
	"Answer whether the argument is a letter, underscore, or digit.
		int __iscsym(int c)"

	<cdecl: bool __iscsym char>
	^self invalidCall
!

__iscsymf: aCharacter
	"Answer whether the argument is a letter or underscore.
		int __iscsymf(int c)"

	<cdecl: bool __iscsymf char>
	^self invalidCall
!

_chdir: aString
	"Change the current working directory to that identified by the path, aString.

		int _chdir( const char *dirname);"

	<cdecl: sdword _chdir lpstr>
	^self invalidCall!

_chmod: aFilenameString pmode: aModeInteger
	"Change the file-permission settings of aFilenameString to aModeInteger

		int _chmod( const char *filename, int pmode );"

	<cdecl: sdword _chmod lpstr sdword>
	^self invalidCall!

_clearfp 
	"Clear and return the floating point status word

		unsigned int _clearfp( void );"

	<cdecl: dword _clearfp>
	^self invalidCall!

_close: anInteger 
	"Close the file associated with the descriptor, anInteger, and release the descriptor."

	<cdecl: sdword _close sdword>
	^self invalidCall!

_controlfp: newInteger mask: maskInteger
	<cdecl: dword _controlfp dword dword>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

_dup: anInteger 
	"Create and answer a duplicate file descriptor for the open file with descriptor, anInteger.
	Note that the underlying file handle is also duplicated."

	<cdecl: sdword _dup sdword>
	^self invalidCall!

_dup2: anInteger handle2: anInteger2 
	"Reassign a file descriptor by copying a duplicate of the file descriptor, anInteger, over
	the file descriptor, anInteger2. Note that the underlying file handle of the first
	descriptor is duplicated, and any open file associated with the target file descriptor is
	closed."

	<cdecl: sdword _dup2 sdword sdword>
	^self invalidCall!

_eof: handleInteger
	<cdecl: sdword _eof sdword>
	^self invalidCall!

_errno
	"Answer a pointer to the errno variable."

	<cdecl: sdword _errno>
	^self invalidCall!

_fdopen: anInteger mode: aString
	"Associate a stream with an open file handle.
		FILE *_fdopen( int handle, const char *mode );
	Note that we treat the stdio FILE* pointer as an opaque handle, as these
	are automatically nulled on image load."

	<cdecl: handle _fdopen sdword lpstr>
	^self invalidCall!

_filelength: handleInteger
	<cdecl: sdword _filelength sdword>
	^self invalidCall!

_fileno: aFILE
	"Answer the <integer> file number of a CRT FILE stream."

	<cdecl: sdword _fileno handle>
	^self invalidCall!

_finite: aFloat
	"Answer whether the argument is finite floating point number."

	<cdecl: bool _finite double>
	^self invalidCall!

_fpclass: aFloat
	<cdecl: sdword _fpclass double>
	^self invalidCall!

_gcvt: aFloat count: anInteger buffer: aString
	<cdecl: char* _gcvt double sdword char*>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

_get_osfhandle: anInteger
	<cdecl: handle _get_osfhandle sdword>
	^self invalidCall!

_getcwd: aString maxlen: anInteger
	"Copy up to anInteger characters of the the current working directory path over the <String>
	buffer, aString."

	<cdecl: lpstr _getcwd lpstr sdword>
	^self invalidCall!

_logb: aFloat
	"Answer the exponent of the argument, aFloat."

	<cdecl: double _logb double>
	^self invalidCall!

_makepath: path drive: drive dir: dir fname: fname ext: ext
	<cdecl: void _makepath char* char* char* char* char*>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

_open_osfhandle: osfhandle flags: flags
	<cdecl: sdword _open_osfhandle handle sdword>
	^self invalidCall!

_rotl: anUnsignedlInteger shift: anInteger
	"Answer anUnsignedInteger bit rotated left by anInteger bits."

	<cdecl: dword _rotl dword sdword>
	^self invalidCall!

_rotr: anUnsignedlInteger shift: anInteger
	"Answer anUnsignedInteger bit rotated right by anInteger bits."

	<cdecl: dword _rotr dword sdword>
	^self invalidCall!

_setmode: fd mode: modeFlag
	<cdecl: sdword _setmode sdword sdword>
	^self invalidCall!

_spawnvp: mode cmdname: aString argv: argv
	"Spawn a new process.

		int _spawnv( int mode, const char *cmdname, const char *const *argv );

	Implementation Note: Overlapped so as to block only the calling process, as the
	spawned external process may run for a lengthy time.
	"

	<overlap cdecl: sdword _spawnvp sdword lpstr lpvoid>
	^self invalidCall

"
[CRTLibrary default _spawnvp: 0 cmdname: 'command.com' argv: DWORD new.0] fork
"!

_splitpath: path drive: drive dir: dir fname: fname ext: ext
	<cdecl: void _splitpath char* char* char* char* char*>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

_stricmp: string1 string2: string2
	"Answer the result of a case insensitive string comparison between string1 and string2,
	answer <0, 0, or >0 according to whether string1 is lexicographically less than, 
	equal to, or greater than string2."

	<cdecl: sdword _stricmp lpstr lpstr>
	^self invalidCall!

_stricoll: string1 string2: string2
	"Answer the result of a case insensitive string comparison between string1 and string2,
	answer <0, 0, or >0 according to whether string1 is lexicographically less than, 
	equal to, or greater than string2."

	<cdecl: sdword _stricoll lpstr lpstr>
	^self invalidCall!

_strnicmp: string1 string2: string2 count: count 
	"Answer the result of a case insensitive string comparison between string1 and
	string2,comparing only the first, count, characters. Answer <0, 0, or >0 according to
	whether the first count characters of are lexicographically less than, equal to, or greater
	than the first count characters of string2."

	<cdecl: sdword _strnicmp lpstr lpstr intptr>
	^self invalidCall!

_strrev: aString
	"Answer aString, reversed.

		char *_strrev( char *string );

	N.B. We ignore the return value, as it will be a pointer to the argument,
	and the functions works 'in-place'"

	<cdecl: void _strrev lpstr>
	^self invalidCall
!

acos: aFloat
	"Answer the arccosine of the argument, aFloat.

		double acos( double x );"

	<cdecl: double acos double>
	^self invalidCall!

asin: aFloat
	"Answer the arcsine of the argument, aFloat.

		double asin( double x );"

	<cdecl: double asin double>
	^self invalidCall!

atan: aFloat
	"Answer the arctangent of the argument, aFloat.

		double atan( double x );"

	<cdecl: double atan double>
	^self invalidCall!

atan: yFloat x: xFloat
	"Answer the arctangent of the argument, aFloat.

		double atan2( double y, double x );"

	<cdecl: double atan2 double double>
	^self invalidCall!

atoi: aString
	"Convert a String to an integer.

		int atoi( const char *string );"

	<cdecl: sdword atoi lpstr>
	^self invalidCall!

ceil: aFloat
	"Answer the integer nearest the aFloat toward positive infinity.

		double floor( double x );"

	<cdecl: double ceil double>
	^self invalidCall!

close
	"The C-runtime library cannot be closed."

	^false!

cos: aFloat
	"Answer the cosine of the argument, aFloat.

		double cos( double x );"

	<cdecl: double cos double>
	^self invalidCall!

decimalSeparator
	"Private - Answer the decimal separator String used by the CRT in the current locale."

	^decimalSeparator!

errno
	"Answer the <integer> value of the last recorded CRT error."

	^self _errno asExternalAddress sdwordAtOffset: 0!

exp: aFloat
	"Answer the exponential of the argument, aFloat.

		double exp( double x );"

	<cdecl: double exp double>
	^self invalidCall!

fabs: aFloat
	"Answer the absolute value of the double precision floating-point argument, aFloat
		double fabs( double x );"

	<cdecl: double fabs double>
	^self invalidCall!

fclose: anAddress
	"Closes the specified stream. Answers 0 if successful.
			int fclose( FILE *stream );"

	<cdecl: sdword fclose handle>
	^self invalidCall!

feof: stream
	<cdecl: sdword feof handle>
	^self invalidCall!

fflush: anExternalAddress 
	<cdecl: sdword fflush handle>
	^self invalidCall!

fgetc: aFILE 
	<overlap cdecl: sdword fgetc handle>
	^self invalidCall!

fgets: buf n: bufsize stream: aFILE
	<overlap cdecl: lpstr fgets lpstr sdword handle>
	^self invalidCall!

floor: aFloat
	"Answer the integer nearest the aFloat toward negative infinity.

		double floor( double x );"

	<cdecl: double floor double>
	^self invalidCall!

fopen: nameString mode: modeString
	<cdecl: handle fopen lpstr lpstr>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

fputc: charValue stream: aFILE
	<cdecl: sdword fputc sdword handle>
	^self invalidCall!

fread: buffer size: size count: count stream: aFILE
	<overlap cdecl: sdword fread lpvoid intptr intptr handle>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

freopen: pathString mode: modeString stream: anExternalHandle
	<cdecl: handle freopen char* char* handle>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

frexp: x expptr: expptr

	<cdecl: double frexp double sdword*>
	^self invalidCall!

fseek: aFILE offset: offsetInteger origin: originInteger
	<cdecl: sdword fseek handle sdword sdword>
	^self invalidCall!

ftell: aFILE
	"Answer the <integer> position (zero-based) of the CRT FILE stream."

	<cdecl: sdword ftell handle>
	^self invalidCall!

fwrite: data size: sizeInteger count: countInteger stream: aFILE 
	<cdecl: sdword fwrite lpvoid intptr intptr handle>
	^self invalidCall!

initialize
	"Private - Initialize and answer the receiver."

	self synchronizeLocale.
	^self!

iswcntrl: aCharacter
	"Answer whether the argument is a control character.
		int iswcntrl( wint_t c )"

	<cdecl: bool iswcntrl char>
	^self invalidCall
!

iswprint: aCharacter
	"Answer whether the argument is a printable character.
		int iswprint( wint_t c )"

	<cdecl: bool iswprint char>
	^self invalidCall
!

iswpunct: aCharacter
	"Answer whether the argument is a punctuation character.
		int iswpunct( wint_t c )"

	<cdecl: bool iswpunct char>
	^self invalidCall
!

iswspace: aCharacter
	"Answer whether the argument is a white space character.
		int iswspace( wint_t c )"

	<cdecl: bool iswspace char>
	^self invalidCall
!

ldexp: aFloat exp: anInteger
	"Answer xFloat * (2 ** exp)

		double ldexp( double x, int exp );"

	<cdecl: double ldexp double sdword>
	^self invalidCall!

log: aFloat
	"Answer the natural logarithm of the argument, aFloat."

	<cdecl: double log double>
	^self invalidCall!

log10: aFloat
	"Answer the base 10 logarithm of the double precision
	floating point argument, aFloat."

	<cdecl: double log10 double>
	^self invalidCall!

memcmp: buf1 buf2: buf2 count: count
	"Compare the first count bytes in two buffers, answering <0 if buf1 is < buf2, 0 if equal,
	and >0 if buf2 > buf1.

		int memcmp( const void *buf1, const void *buf2, size_t count );"

	<cdecl: sdword memcmp lpvoid lpvoid intptr>
	^self invalidCall!

memset: dest c: c count: count
	"Fill a block of memory.
				void *memset( void *dest, int c, size_t count );
	"

	<cdecl: sdword memset lpvoid sdword intptr>
	^self invalidCall!

modf: aFloat intptr: intFloatOut
	"Splits aFloat into fractional and integer parts. Answer the fractional part.

		double modf( double x, double *intptr );"

	<cdecl: double modf double lpvoid>
	^self invalidCall
!

pow: xFloat y: yFloat
	"Answer xFloat raised to the power of yFloat."

	<cdecl: double pow double double>
	^self invalidCall!

rand
	<cdecl: sdword rand>
	^self invalidCall!

rewind: aFILE
	"Rewind to the beginning of the CRT FILE*.
	Implementation Note: As with other FILE routines, treat the stream argument as an opaque handle."

	<cdecl: void rewind handle>
	^self invalidCall!

setlocale: category locale: localeString
	"Set a specified locale category.

		char *setlocale( int category, const char *locale );	"

	<cdecl: lpstr setlocale sdword lpstr>
	^self invalidCall
!

sin: aFloat
	"Answer the Sine of the argument, aFloat."

	<cdecl: double sin double>
	^self invalidCall!

sqrt: aFloat
	"Answer the square root of the argument, aFloat."

	<cdecl: double sqrt double>
	^self invalidCall!

srand: anInteger 
	<cdecl: void srand dword>
	^self invalidCall!

strcat: strDestination strSource: strSource
	"Be careful: Buffer overruns a distinct possibility if you use this function!!"

	<cdecl: lpstr strcat lpstr lpstr>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

strcmp: string1 string2: string2 
	"Answer the order between the <String> arguments, string1 and string2.

		int strcmp( const char *string1, const char *string2);
	"

	<cdecl: sdword strcmp lpstr lpstr>
	^self invalidCall!

strcspn: string strCharSet: strCharSet
	<cdecl: dword strcspn lpvoid char*>
	^self invalidCall!

strerror: errno
	"Answer a <readableString> description of the specified <integer> CRT error number."

	<cdecl: lpstr strerror sdword>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

strncmp: string1 string2: string2 count: count
	"Answer the order between the <String> arguments, string1 and string2,
	considering up to <integer>, count, characters.

		int strncmp( const char *string1, const char *string2, size_t count );
	"

	<cdecl: sdword strncmp lpstr lpstr intptr>
	^self invalidCall!

strncpy: strDest strSource: strSource count: count
	<cdecl: lpvoid strncpy lpvoid lpvoid intptr>
	#deprecated.	"Insecure - see MSDN"
	^self invalidCall!

strpbrk: string strCharSet: strCharSet
	"Answer a pointer to the first occurrence of any of the characters
	from the <String>, strCharSet, in the <String>, string.

		char *strpbrk( const char *string, const char *strCharSet 
	"

	<cdecl: char* strpbrk char* char*>
	^self invalidCall
!

synchronizeLocale
	"Private - Synchronize the CRT's locale with the OS locale setting."

	| buf |
	self setlocale: 0 locale: ''.
	buf := String new: 10.
	buf := self _gcvt: 0 count: 2 buffer: buf.
	decimalSeparator := buf copyFrom: 2



!

tan: aFloat
	"Answer the Tangent of the argument, aFloat."

	<cdecl: double tan double>
	^self invalidCall!

thread_chmod: aFilenameString pmode: aModeInteger
	<overlap cdecl: sdword _chmod lpstr sdword>
	^self invalidCall!

thread_errno
	<overlap cdecl: sdword _errno>
	^self invalidCall!

ungetc: c stream: stream
	"Pushes the character with integer code point, c, back onto the FILE*, stream."

	<cdecl: sdword ungetc sdword handle>
	^self invalidCall!

wcscspn: aUnicodeString strCharSet: strCharSet
	<cdecl: dword wcscspn lpvoid lpwstr>
	^self invalidCall! !
!CRTLibrary categoriesFor: #__iscsym:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #__iscsymf:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #_chdir:!CRT functions-directory control!public! !
!CRTLibrary categoriesFor: #_chmod:pmode:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_clearfp!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_close:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_controlfp:mask:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_dup:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_dup2:handle2:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_eof:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_errno!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #_fdopen:mode:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #_filelength:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_fileno:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #_finite:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_fpclass:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_gcvt:count:buffer:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_get_osfhandle:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_getcwd:maxlen:!CRT functions-directory control!public! !
!CRTLibrary categoriesFor: #_logb:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_makepath:drive:dir:fname:ext:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_open_osfhandle:flags:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_rotl:shift:!CRT functions-bit manipulation!public! !
!CRTLibrary categoriesFor: #_rotr:shift:!CRT functions-bit manipulation!public! !
!CRTLibrary categoriesFor: #_setmode:mode:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_spawnvp:cmdname:argv:!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #_splitpath:drive:dir:fname:ext:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_stricmp:string2:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_stricoll:string2:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_strnicmp:string2:count:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_strrev:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #acos:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #asin:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atan:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atan:x:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atoi:!CRT functions-data conversion!public! !
!CRTLibrary categoriesFor: #ceil:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #close!public!realizing/unrealizing! !
!CRTLibrary categoriesFor: #cos:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #decimalSeparator!enquiries!private! !
!CRTLibrary categoriesFor: #errno!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #exp:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #fabs:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #fclose:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #feof:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fflush:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fgetc:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fgets:n:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #floor:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #fopen:mode:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fputc:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fread:size:count:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #freopen:mode:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #frexp:expptr:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #fseek:offset:origin:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #ftell:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fwrite:size:count:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #initialize!initializing!private! !
!CRTLibrary categoriesFor: #iswcntrl:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswprint:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswpunct:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswspace:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #ldexp:exp:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #log:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #log10:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #memcmp:buf2:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #memset:c:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #modf:intptr:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #pow:y:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #rand!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #rewind:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #setlocale:locale:!CRT functions-localization!public! !
!CRTLibrary categoriesFor: #sin:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #sqrt:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #srand:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #strcat:strSource:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strcmp:string2:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strcspn:strCharSet:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strerror:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strncmp:string2:count:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strncpy:strSource:count:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #strpbrk:strCharSet:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #synchronizeLocale!CRT functions-localization!private! !
!CRTLibrary categoriesFor: #tan:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #thread_chmod:pmode:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #thread_errno!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #ungetc:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #wcscspn:strCharSet:!CRT functions-string manipulation!public! !

!CRTLibrary class methodsFor!

fileName
	"Answer the host system file name for the external library the 
	receiver represents."

	^File splitStemFrom: (self default fileName)!

open
	"Answer a new instance of the receiver to represent the CRT DLL."

	^(self fromHandle: VMLibrary default crtHandle) initialize! !
!CRTLibrary class categoriesFor: #fileName!constants!public! !
!CRTLibrary class categoriesFor: #open!instance creation!public! !

