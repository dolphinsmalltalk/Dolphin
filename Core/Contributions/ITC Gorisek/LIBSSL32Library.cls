"Filed out from Dolphin Smalltalk X6.2"!

ExternalLibrary subclass: #LIBSSL32Library
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'isInitialized'!
LIBSSL32Library guid: (GUID fromString: '{520FB318-EB8B-47CA-A2B0-D406FD2EC7C6}')!
LIBSSL32Library comment: 'The OpenSSL dynamic link library.

Author: Chris Double
mailto: chris@double.co.nz
http://www.double.co.nz/smalltalk'!
!LIBSSL32Library categoriesForClass!Unclassified! !
!LIBSSL32Library methodsFor!

sslConnect: p1 
	"int SSL_connect (
		void* ssl);"

	<overlap stdcall: sdword SSL_connect lpvoid>
	^self invalidCall!

sslCtxFree: p1
	"void SSL_CTX_free (
		void* ctx);"

	<stdcall: void SSL_CTX_free lpvoid>
	^self invalidCall
!

sslCtxNew: p1
	"void* SSL_CTX_new (
		void* meth);"

	<stdcall: lpvoid SSL_CTX_new lpvoid>
	^self invalidCall!

sslFree: p1
	"void SSL_free (
		void* ssl);"

	<stdcall: void SSL_free lpvoid>
	^self invalidCall!

sslGetError: p1 code: p2
	"int SSL_set_fd (
		void* s,
	     	int rc);"

	<stdcall: sdword SSL_get_error lpvoid sdword>
	^self invalidCall

!

sslLibraryInit
	"int SSL_library_init(void);"

	<stdcall: sdword SSL_library_init>
	^self invalidCall!

sslLoadErrorStrings
	"void SSL_load_error_strings(void);"

	<stdcall: void SSL_load_error_strings>
	^self invalidCall!

sslNew: p1
	"void* SSL_new (
		void* ctx);"

	<stdcall: lpvoid SSL_new lpvoid>
	^self invalidCall
!

sslRead: p1 buffer: p2 length: p3 
	"int SSL_read (
		void* ssl,
                char* buffer,
		int length);"

	<stdcall: sdword SSL_read lpvoid lpvoid sdword>
	^self invalidCall!

sslSetFd: p1 descriptor: p2
	"int SSL_set_fd (
		void* s,
	     	int fd);"

	<stdcall: sdword SSL_set_fd lpvoid sdword>
	^self invalidCall

!

sslShutdown: p1
	"int SSL_shutdown(void* s);"

	<stdcall: sdword SSL_shutdown lpvoid>
	^self invalidCall!

sslStateString: ssl 
	"
NAME
       SSL_state_string, SSL_state_string_long - get textual description of
       state of an SSL object

SYNOPSIS
        #include <openssl/ssl.h>

        const char *SSL_state_string(const SSL *ssl);
        const char *SSL_state_string_long(const SSL *ssl);

DESCRIPTION
       SSL_state_string() returns a 6 letter string indicating the current
       state of the SSL object ssl.

       SSL_state_string_long() returns a string indicating the current state
       of the SSL object ssl.

NOTES
       During its use, an SSL objects passes several states. The state is
       internally maintained. Querying the state information is not very
       informative before or when a connection has been established. It how-however
       ever can be of significant interest during the handshake.

       When using non-blocking sockets, the function call performing the hand-handshake
       shake may return with SSL_ERROR_WANT_READ or SSL_ERROR_WANT_WRITE con-condition,
       dition, so that SSL_state_string[_long]() may be called.

       For both blocking or non-blocking sockets, the details state informa-information
       tion can be used within the info_callback function set with the
       SSL_set_info_callback() call.

RETURN VALUES
       Detailed description of possible states to be included later."

	<stdcall: lpstr SSL_state_string lpvoid>
	^self invalidCall!

sslStateStringLong: ssl 
	"
NAME
       SSL_state_string, SSL_state_string_long - get textual description of
       state of an SSL object

SYNOPSIS
        #include <openssl/ssl.h>

        const char *SSL_state_string(const SSL *ssl);
        const char *SSL_state_string_long(const SSL *ssl);

DESCRIPTION
       SSL_state_string() returns a 6 letter string indicating the current
       state of the SSL object ssl.

       SSL_state_string_long() returns a string indicating the current state
       of the SSL object ssl.

NOTES
       During its use, an SSL objects passes several states. The state is
       internally maintained. Querying the state information is not very
       informative before or when a connection has been established. It how-however
       ever can be of significant interest during the handshake.

       When using non-blocking sockets, the function call performing the hand-handshake
       shake may return with SSL_ERROR_WANT_READ or SSL_ERROR_WANT_WRITE con-condition,
       dition, so that SSL_state_string[_long]() may be called.

       For both blocking or non-blocking sockets, the details state informa-information
       tion can be used within the info_callback function set with the
       SSL_set_info_callback() call.

RETURN VALUES
       Detailed description of possible states to be included later."

	<stdcall: lpstr SSL_state_string_long lpvoid>
	^self invalidCall!

sslv23ClientMethod
	"void* SSLv23_client_method(void);"

	<stdcall: lpvoid SSLv23_client_method>
	^self invalidCall
!

sslv2ClientMethod
	"void* SSLv2_client_method(void);"

	<stdcall: lpvoid SSLv2_client_method>
	^self invalidCall!

sslv3ClientMethod
	"void* SSLv3_client_method(void);"

	<stdcall: lpvoid SSLv3_client_method>
	^self invalidCall
!

sslWrite: p1 buffer: p2 length: p3 
	"int SSL_write (
		void* ssl,
                char* buffer,
		int length);"

	<stdcall: sdword SSL_write lpvoid lpvoid sdword>
	^self invalidCall! !
!LIBSSL32Library categoriesFor: #sslConnect:!public! !
!LIBSSL32Library categoriesFor: #sslCtxFree:!public! !
!LIBSSL32Library categoriesFor: #sslCtxNew:!public! !
!LIBSSL32Library categoriesFor: #sslFree:!public! !
!LIBSSL32Library categoriesFor: #sslGetError:code:!public! !
!LIBSSL32Library categoriesFor: #sslLibraryInit!public! !
!LIBSSL32Library categoriesFor: #sslLoadErrorStrings!public! !
!LIBSSL32Library categoriesFor: #sslNew:!public! !
!LIBSSL32Library categoriesFor: #sslRead:buffer:length:!public! !
!LIBSSL32Library categoriesFor: #sslSetFd:descriptor:!public! !
!LIBSSL32Library categoriesFor: #sslShutdown:!public! !
!LIBSSL32Library categoriesFor: #sslStateString:!public! !
!LIBSSL32Library categoriesFor: #sslStateStringLong:!public! !
!LIBSSL32Library categoriesFor: #sslv23ClientMethod!public! !
!LIBSSL32Library categoriesFor: #sslv2ClientMethod!public! !
!LIBSSL32Library categoriesFor: #sslv3ClientMethod!public! !
!LIBSSL32Library categoriesFor: #sslWrite:buffer:length:!public! !

!LIBSSL32Library class methodsFor!

default
	isInitialized == true 
		ifFalse: 
			[self startSocketSystem.
			isInitialized := true].
	^super default!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'SSLEAY32'!

onStartup2
	"Perform session startup processing for this library."

	isInitialized := false!

startSocketSystem
	"Initialise the SSL system."

	(super default)
		sslLibraryInit;
		sslLoadErrorStrings! !
!LIBSSL32Library class categoriesFor: #default!event handling!public! !
!LIBSSL32Library class categoriesFor: #fileName!constants!public! !
!LIBSSL32Library class categoriesFor: #onStartup2!event handling!public! !
!LIBSSL32Library class categoriesFor: #startSocketSystem!initializing!public! !

