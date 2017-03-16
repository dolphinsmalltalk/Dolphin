"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #LIBEAY32Library
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LIBEAY32Library guid: (GUID fromString: '{1350b932-c807-4736-86a4-ff321b526944}')!
LIBEAY32Library comment: ''!
!LIBEAY32Library categoriesForClass!Unclassified! !
!LIBEAY32Library methodsFor!

errErrorString: errorCode buf: buf 
	"const char* ERR_error_string(
		unsinged long error,
	     	char* buf);"

	<stdcall: sdword ERR_error_string dword lpvoid>
	^self invalidCall!

errGetError
	"int ERR_get_error ();"

	<stdcall: sdword ERR_get_error>
	^self invalidCall! !
!LIBEAY32Library categoriesFor: #errErrorString:buf:!public! !
!LIBEAY32Library categoriesFor: #errGetError!public! !

!LIBEAY32Library class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'LIBEAY32'! !
!LIBEAY32Library class categoriesFor: #fileName!constants!public! !

