"Filed out from Dolphin Smalltalk X6.1"!

PermanentLibrary subclass: #CRTLibrary
	instanceVariableNames: 'decimalSeparator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRTLibrary guid: (GUID fromString: '{87B4C58B-026E-11D3-9FD7-00A0CC3E4A32}')!
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

_chdir: aDirectoryString
	"Change the cuyrrent working directoryto aDirectoryNameString

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

_controlfp: newInteger mask: maskInteger
	"Get and set the floating-point control word.

		unsigned int _controlfp( unsigned int new, unsigned int mask );"

	<cdecl: dword _controlfp dword dword>
	^self invalidCall!

_dup: anInteger
	"Duplicate a file handle
		int_dup( int handle );"

	<cdecl: sdword _dup sdword>
	^self invalidCall
!

_dup2: anInteger handle2: anInteger2
	"Duplicate a file handle
		int _dup2(int handle1, int handle2);"

	<cdecl: sdword _dup2 sdword sdword>
	^self invalidCall
!

_ecvt: aFloat count: anInteger dec: decInteger sign: signInteger
	"Answer a String representation of the argument, aFloat, with anInteger significant figures.
	decInteger and signInteger receive the position of the decimal point and the sign of
	aFloat respectively.

		char *_ecvt( double value, int count, int *dec, int *sign );"
  
	<cdecl: lpstr _ecvt double sdword SDWORD* SDWORD* >
	^self invalidCall!

_eof: handleInteger
	<cdecl: sdword _eof sdword>
	^self invalidCall!

_errno
	"Answer a pointer to the errno variable."

	<cdecl: sdword _errno>
	^self invalidCall!

_fcvt: aFloat count: anInteger dec: decInteger sign: signInteger
	"Answer a String representation of the argument, aFloat, with anInteger decimal places.
	decInteger and signInteger receive the position of the decimal point and the sign of
	aFloat respectively.

		char *_fcvt( double value, int count, int *dec, int *sign );"
  
	<cdecl: lpstr _fcvt double sdword SDWORD* SDWORD* >
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

_gcvt: aFloat count: anInteger buffer: aString
	"Answer a String representation of the argument, aFloat, with anInteger significant
	figures. Includes a sign (if negative) and decimal point. Exponential format may be used.
	Buffer size should be sufficient to accommodate signed exponential representation with
	decimal point. aString is overwritten with the printable representation, but the answer
	is a new String of the correct size.

		char *_gcvt( double value, int count, char* buffer)"
  
	<cdecl: char* _gcvt double sdword char*>
	^self invalidCall!

_getcwd: buffer maxlen: maxlen
	"Copy up to <integer>, maxlen>, characters of the the current working directory 
	path to the <String> buffer."
  
	<cdecl: lpstr _getcwd lpstr sdword>
	^self invalidCall!

_i64toa: aSmallInteger string: aString radix: anInteger
	"Answer the String representation of a 64-bit Integer."

	<cdecl: lpstr _i64toa sqword lpstr sdword>
	^self invalidCall!

_isnan: aFloat
	"Answer whether the argument is NaN (Not a Number)."

	<cdecl: bool _isnan double>
	^self invalidCall!

_logb: aFloat
	"Answer the exponent of the argument, aFloat."

	<cdecl: double _logb double>
	^self invalidCall!

_ltoa: aSmallInteger string: aString radix: anInteger
	"Answer the String representation of a 32-bit Integer."

	<cdecl: lpstr _ltoa sdword lpstr sdword>
	^self invalidCall!

_makepath: path drive: drive dir: dir fname: fname ext: ext
	"Compose a path name from its constituent components.

		void _makepath(char* path, const char* drive, const char* dir, const char* fname, const char* ext);
	"

	<cdecl: void _makepath char* char* char* char* char*>
	^self invalidCall!

_open_osfhandle: osfhandle flags: flags
	<cdecl: sdword _open_osfhandle handle sdword>
	^self invalidCall!

_putenv: aString
	<cdecl: sdword _putenv lpstr>
	^self invalidCall
!

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

_snprintf: buffer count: maxbuf format: format with: arg
	"Private - Write data formatted by the format string into the buffer.
	see _snprintf:count:format:with:with:with: for further information."

	<cdecl: sdword _snprintf lpvoid intptr lpstr lpvoid>
	^self invalidCall!

_snprintf: buffer count: maxbuf format: format with: arg1 with: arg2
	"Private - Write data formatted by the format string into the buffer.
	see _snprintf:count:format:with:with:with: for further information."

	<cdecl: sdword _snprintf lpvoid intptr lpstr lpvoid lpvoid>
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
	"Break a path name into its constituent components.

		void _splitpath(const char* path, char* drive, char* dir, char* fname, char* ext);

	Any of the output components (drive, dir, fname, ext), can be nil if that components
	is not required.
	"

	<cdecl: void _splitpath char* char* char* char* char*>
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

argc
	"Answer the number of arguments passed to the host executable at startup"

	^(self getProcAddress: '__argc') sdwordAtOffset: 0!

argv
	"Answer the array of strings which constitute the command line arguments, 
	starting with the host executable's full path."

	^((self getProcAddress: '__argv') dwordAtOffset: 0) asExternalAddress!

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

connectDescriptor: fdInteger toWinStdHandle: stdHandleInteger mode: modeString
	"Private - Connect the CRT FILE with the descriptor/index, fdInteger, to the standard Win32 OS file
	handle identified by the constant, stdHandleInteger. Answer the handle of the CRT file stream.
	This is necessary to correctly associate CRT stdin/stdout streams with the correct OS file handles after 
	allocating a console in a GUI app. See MSDN article Q105305."

	| fd2 hFile |
	fd2 := CRTLibrary default
				_open_osfhandle: (KernelLibrary default getStdHandle: stdHandleInteger)
				flags: 0.
	fd2 < 0 ifTrue: [CRTError signal].
	hFile := CRTLibrary default _fdopen: fd2 mode: modeString.
	"It seems a bit of a hack to overwrite the CRT structure in this way, but this is what the code in the MSDN
	 article does (a structure assignment)"
	CRTLibrary default 
		memcpy: (self getStdHandle: fdInteger) asInteger 
		src: hFile asInteger 
		count: self sizeofFILE.
	^hFile
!

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
	"Open the specified file with the specified mode.
	Note that we treat the stdio FILE* pointer as an opaque handle, as these
	are automatically nulled on image load.

			FILE *fopen( const char *filename, const char *mode );"

	<cdecl: handle fopen lpstr lpstr>
	^self invalidCall
!

fputc: charValue stream: aFILE
	<cdecl: sdword fputc sdword handle>
	^self invalidCall!

fread: buffer size: size count: count stream: aFILE
	<overlap cdecl: sdword fread lpvoid intptr intptr handle>
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

getenv: varname
	"Answer a string containing the named environment variable setting, or nil
	if no such environment variable exists. The name comparison is case insensitive.

		char *getenv( const char *varname );"

	<cdecl: lpstr getenv lpstr>
	^self invalidCall
!

getStdHandle: fdInteger
	"Private - Answer the CRT stream (FILE*) handle of the standard file stream with the specified index
	(0 = stdin, 1 = stdout, 2 = stderr)."

	^((CRTLibrary default getProcAddress: '_iob') asInteger
		+ (fdInteger * self sizeofFILE)) asExternalHandle!

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

memcpy: dest src: src count: count
	<cdecl: lpvoid memcpy lpvoid lpvoid intptr>
	^self invalidCall!

memmove: dest src: src count: count
	<cdecl: void* memmove void* void* intptr>
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

sizeofFILE
	"Private - Answer the size, in bytes, of the CRT FILE structure."

	^32
!

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
	^self invalidCall!

strncmp: string1 string2: string2 count: count
	"Answer the order between the <String> arguments, string1 and string2,
	considering up to <integer>, count, characters.

		int strncmp( const char *string1, const char *string2, size_t count );
	"

	<cdecl: sdword strncmp lpstr lpstr intptr>
	^self invalidCall!

strncpy: strDest strSource: strSource count: count
	"Copy up to count characters of the <String> strSource to the <String> strDest 
	and answer strDest. A null appended if there is sufficient space in the destination 
	buffer. The source and destination must not overlap.

		char *strncpy( char *strDest, const char *strSource, size_t count );
	"

	<cdecl: lpvoid strncpy lpvoid lpvoid intptr>
	^self invalidCall
!

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
	buf := self _gcvt: Float zero count: 2 buffer: buf.
	decimalSeparator := buf copyFrom: 2

!

tan: aFloat
	"Answer the Tangent of the argument, aFloat."

	<cdecl: double tan double>
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
!CRTLibrary categoriesFor: #_chdir:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_chmod:pmode:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_clearfp!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_controlfp:mask:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_dup:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_dup2:handle2:!CRT functions-low level I/O!public! !
!CRTLibrary categoriesFor: #_ecvt:count:dec:sign:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_eof:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_errno!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #_fcvt:count:dec:sign:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_fdopen:mode:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #_filelength:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_fileno:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #_gcvt:count:buffer:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_getcwd:maxlen:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_i64toa:string:radix:!CRT functions-data conversion!public! !
!CRTLibrary categoriesFor: #_isnan:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_logb:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #_ltoa:string:radix:!CRT functions-data conversion!public! !
!CRTLibrary categoriesFor: #_makepath:drive:dir:fname:ext:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_open_osfhandle:flags:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_putenv:!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #_rotl:shift:!CRT functions-bit manipulation!public! !
!CRTLibrary categoriesFor: #_rotr:shift:!CRT functions-bit manipulation!public! !
!CRTLibrary categoriesFor: #_setmode:mode:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_snprintf:count:format:with:!CRT functions-stream I/O!private! !
!CRTLibrary categoriesFor: #_snprintf:count:format:with:with:!CRT functions-stream I/O!private! !
!CRTLibrary categoriesFor: #_spawnvp:cmdname:argv:!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #_splitpath:drive:dir:fname:ext:!CRT functions-file handling!public! !
!CRTLibrary categoriesFor: #_stricmp:string2:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_stricoll:string2:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_strnicmp:string2:count:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #_strrev:!CRT functions-string manipulation!public! !
!CRTLibrary categoriesFor: #acos:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #argc!accessing!public! !
!CRTLibrary categoriesFor: #argv!accessing!public! !
!CRTLibrary categoriesFor: #asin:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atan:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atan:x:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #atoi:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #ceil:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #close!public!realizing/unrealizing! !
!CRTLibrary categoriesFor: #connectDescriptor:toWinStdHandle:mode:!helpers!public! !
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
!CRTLibrary categoriesFor: #frexp:expptr:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #fseek:offset:origin:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #ftell:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #fwrite:size:count:stream:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #getenv:!CRT functions-process and environment control!public! !
!CRTLibrary categoriesFor: #getStdHandle:!helpers!private! !
!CRTLibrary categoriesFor: #initialize!initializing!private! !
!CRTLibrary categoriesFor: #iswcntrl:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswprint:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswpunct:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #iswspace:!CRT functions-character classification!public! !
!CRTLibrary categoriesFor: #ldexp:exp:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #log:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #log10:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #memcmp:buf2:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #memcpy:src:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #memmove:src:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #memset:c:count:!CRT functions-buffer manipulation!public! !
!CRTLibrary categoriesFor: #modf:intptr:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #pow:y:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #rand!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #rewind:!CRT functions-stream I/O!public! !
!CRTLibrary categoriesFor: #setlocale:locale:!CRT functions-localization!public! !
!CRTLibrary categoriesFor: #sin:!CRT functions-floating point support!public! !
!CRTLibrary categoriesFor: #sizeofFILE!constants!private! !
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

