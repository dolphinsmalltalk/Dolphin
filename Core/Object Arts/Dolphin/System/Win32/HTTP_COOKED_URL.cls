"Filed out from Dolphin Smalltalk 7"!

HttpServerStructure subclass: #HTTP_COOKED_URL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HTTP_COOKED_URL guid: (GUID fromString: '{24928162-1798-46a3-b2c1-3c6ee66c08be}')!
HTTP_COOKED_URL comment: '<HTTP_COOKED_URL> is an <ExternalStructure> class to wrap the struct ''Win32.HTTP_COOKED_URL'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The HTTP_COOKED_URL structure contains a validated, canonical, UTF-16 Unicode-encoded URL request string together with pointers into it and element lengths."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(24928162-1798-46a3-b2c1-3c6ee66c08be), helpstring("The HTTP_COOKED_URL structure contains a validated, canonical, UTF-16 Unicode-encoded URL request string together with pointers into it and element lengths.")]
struct tagHTTP_COOKED_URL {
	[nonbrowsable, readonly, helpstring("Size, in bytes, of the data pointed to by the pFullUrl member, not including a terminating null character.")] USHORT FullUrlLength;
	[nonbrowsable, readonly, helpstring("Size, in bytes, of the data pointed to by the pHost member, not including a terminating null character.")] USHORT HostLength;
	[nonbrowsable, readonly, helpstring("Size, in bytes, of the data pointed to by the pAbsPath member, not including a terminating null character.")] USHORT AbsPathLength;
	[nonbrowsable, readonly, helpstring("Size, in bytes, of the data pointed to by the pQueryString member, not including a terminating null character.")] USHORT QueryStringLength;
	[readonly, helpstring("Pointer to the scheme element at the beginning of the URL (must be either ''http://...'' or ''https://...'')."), string, size_is("FullUrlLength/2")] LPCWSTR pFullUrl;
	[readonly, helpstring("Pointer to the first character in the host element, immediately following the double slashes at the end of the scheme element."), string, size_is("HostLength>>1")] LPCWSTR pHost;
	[readonly, helpstring("Pointer to the third forward slash (''/'') in the string. In a UrlPrefix string, this is the slash immediately preceding the relativeUri element."), string, size_is("AbsPathLength>>1")] LPCWSTR pAbsPath;
	[readonly, helpstring("Pointer to the first question mark (?) in the string, or NULL if there is none."), string, size_is("QueryStringLength>>1")] LPCWSTR pQueryString;
} HTTP_COOKED_URL;
'!
!HTTP_COOKED_URL categoriesForClass!Win32-Structs! !
!HTTP_COOKED_URL methodsFor!

AbsPathLength
	"Private - Answer the <Integer> value of the receiver's 'AbsPathLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #AbsPathLength)!

FullUrlLength
	"Private - Answer the <Integer> value of the receiver's 'FullUrlLength' field."

	^bytes wordAtOffset: 0!

HostLength
	"Private - Answer the <Integer> value of the receiver's 'HostLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #HostLength)!

pAbsPath
	"Answer the <UnicodeString> value of the receiver's 'pAbsPath' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pAbsPath))
		length: self AbsPathLength >> 1!

pFullUrl
	"Answer the <UnicodeString> value of the receiver's 'pFullUrl' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pFullUrl))
		length: self FullUrlLength / 2!

pHost
	"Answer the <UnicodeString> value of the receiver's 'pHost' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pHost))
		length: self HostLength >> 1!

pQueryString
	"Answer the <UnicodeString> value of the receiver's 'pQueryString' field."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #pQueryString))
		length: self QueryStringLength >> 1!

QueryStringLength
	"Private - Answer the <Integer> value of the receiver's 'QueryStringLength' field."

	^bytes wordAtOffset: ##(self offsetOf: #QueryStringLength)! !
!HTTP_COOKED_URL categoriesFor: #AbsPathLength!**compiled accessors**!private! !
!HTTP_COOKED_URL categoriesFor: #FullUrlLength!**compiled accessors**!private! !
!HTTP_COOKED_URL categoriesFor: #HostLength!**compiled accessors**!private! !
!HTTP_COOKED_URL categoriesFor: #pAbsPath!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pFullUrl!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pHost!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #pQueryString!**compiled accessors**!public! !
!HTTP_COOKED_URL categoriesFor: #QueryStringLength!**compiled accessors**!private! !

!HTTP_COOKED_URL class methodsFor!

defineFields
	"Define the fields of the HTTP_COOKED_URL structure.

	HTTP_COOKED_URL compileDefinition

		typedef [uuid(24928162-1798-46a3-b2c1-3c6ee66c08be), helpstring('The HTTP_COOKED_URL structure contains a validated, canonical, UTF-16 Unicode-encoded URL request string together with pointers into it and element lengths.')]
		struct tagHTTP_COOKED_URL {
			[nonbrowsable, readonly, helpstring('Size, in bytes, of the data pointed to by the pFullUrl member, not including a terminating null character.')] USHORT FullUrlLength;
			[nonbrowsable, readonly, helpstring('Size, in bytes, of the data pointed to by the pHost member, not including a terminating null character.')] USHORT HostLength;
			[nonbrowsable, readonly, helpstring('Size, in bytes, of the data pointed to by the pAbsPath member, not including a terminating null character.')] USHORT AbsPathLength;
			[nonbrowsable, readonly, helpstring('Size, in bytes, of the data pointed to by the pQueryString member, not including a terminating null character.')] USHORT QueryStringLength;
			[readonly, helpstring('Pointer to the scheme element at the beginning of the URL (must be either 'http://...' or 'https://...').'), string, size_is('FullUrlLength/2')] LPCWSTR pFullUrl;
			[readonly, helpstring('Pointer to the first character in the host element, immediately following the double slashes at the end of the scheme element.'), string, size_is('HostLength>>1')] LPCWSTR pHost;
			[readonly, helpstring('Pointer to the third forward slash ('/') in the string. In a UrlPrefix string, this is the slash immediately preceding the relativeUri element.'), string, size_is('AbsPathLength>>1')] LPCWSTR pAbsPath;
			[readonly, helpstring('Pointer to the first question mark (?) in the string, or NULL if there is none.'), string, size_is('QueryStringLength>>1')] LPCWSTR pQueryString;
		} HTTP_COOKED_URL;
"

	self
		defineField: #FullUrlLength type: WORDField new beReadOnly beNonBrowsable offset: 0;
		defineField: #HostLength type: WORDField new beReadOnly beNonBrowsable offset: 2;
		defineField: #AbsPathLength type: WORDField new beReadOnly beNonBrowsable offset: 4;
		defineField: #QueryStringLength type: WORDField new beReadOnly beNonBrowsable offset: 6;
		defineField: #pFullUrl type: (ArrayPointerField type: UnicodeString arrayLength: (SizeIsArrayFieldLength sizeIs: 'FullUrlLength / 2')) beReadOnly offset: 8;
		defineField: #pHost type: (ArrayPointerField type: UnicodeString arrayLength: (SizeIsArrayFieldLength sizeIs: 'HostLength >> 1')) beReadOnly offset: 12;
		defineField: #pAbsPath type: (ArrayPointerField type: UnicodeString arrayLength: (SizeIsArrayFieldLength sizeIs: 'AbsPathLength >> 1')) beReadOnly offset: 16;
		defineField: #pQueryString type: (ArrayPointerField type: UnicodeString arrayLength: (SizeIsArrayFieldLength sizeIs: 'QueryStringLength >> 1')) beReadOnly offset: 20.
	self byteSize: 24! !
!HTTP_COOKED_URL class categoriesFor: #defineFields!**auto generated**!initializing!public! !

