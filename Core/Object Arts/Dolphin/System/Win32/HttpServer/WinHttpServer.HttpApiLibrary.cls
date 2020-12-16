"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'WinHttpServer.HttpApiLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'HTTP_AUTH_ENABLE_ALL' -> 16r1F.
		'HTTP_AUTH_ENABLE_BASIC' -> 16r1.
		'HTTP_AUTH_ENABLE_DIGEST' -> 16r2.
		'HTTP_AUTH_ENABLE_KERBEROS' -> 16r10.
		'HTTP_AUTH_ENABLE_NEGOTIATE' -> 16r8.
		'HTTP_AUTH_ENABLE_NTLM' -> 16r4.
		'HTTP_AUTH_EX_FLAG_CAPTURE_CREDENTIAL' -> 16r2.
		'HTTP_AUTH_EX_FLAG_ENABLE_KERBEROS_CREDENTIAL_CACHING' -> 16r1.
		'HTTP_BYTE_RANGE_TO_EOF' -> -16r1.
		'HTTP_CHANNEL_BIND_CLIENT_SERVICE' -> 16r10.
		'HTTP_CHANNEL_BIND_DOTLESS_SERVICE' -> 16r4.
		'HTTP_CHANNEL_BIND_NO_SERVICE_NAME_CHECK' -> 16r2.
		'HTTP_CHANNEL_BIND_PROXY' -> 16r1.
		'HTTP_CHANNEL_BIND_PROXY_COHOSTING' -> 16r20.
		'HTTP_CHANNEL_BIND_SECURE_CHANNEL_TOKEN' -> 16r8.
		'HTTP_CREATE_REQUEST_QUEUE_FLAG_CONTROLLER' -> 16r2.
		'HTTP_CREATE_REQUEST_QUEUE_FLAG_OPEN_EXISTING' -> 16r1.
		'HTTP_FLUSH_RESPONSE_FLAG_RECURSIVE' -> 16r1.
		'HTTP_INITIALIZE_CONFIG' -> 16r2.
		'HTTP_INITIALIZE_SERVER' -> 16r1.
		'HTTP_LIMIT_INFINITE' -> -16r1.
		'HTTP_LOG_FIELD_BYTES_RECV' -> 16r2000.
		'HTTP_LOG_FIELD_BYTES_SENT' -> 16r1000.
		'HTTP_LOG_FIELD_CLIENT_IP' -> 16r4.
		'HTTP_LOG_FIELD_CLIENT_PORT' -> 16r400000.
		'HTTP_LOG_FIELD_COMPUTER_NAME' -> 16r20.
		'HTTP_LOG_FIELD_COOKIE' -> 16r20000.
		'HTTP_LOG_FIELD_DATE' -> 16r1.
		'HTTP_LOG_FIELD_HOST' -> 16r100000.
		'HTTP_LOG_FIELD_METHOD' -> 16r80.
		'HTTP_LOG_FIELD_QUEUE_NAME' -> 16r4000000.
		'HTTP_LOG_FIELD_REASON' -> 16r2000000.
		'HTTP_LOG_FIELD_REFERER' -> 16r40000.
		'HTTP_LOG_FIELD_SERVER_IP' -> 16r40.
		'HTTP_LOG_FIELD_SERVER_PORT' -> 16r8000.
		'HTTP_LOG_FIELD_SITE_ID' -> 16r1000000.
		'HTTP_LOG_FIELD_SITE_NAME' -> 16r10.
		'HTTP_LOG_FIELD_STATUS' -> 16r400.
		'HTTP_LOG_FIELD_STREAM_ID' -> 16r8000000.
		'HTTP_LOG_FIELD_SUB_STATUS' -> 16r200000.
		'HTTP_LOG_FIELD_TIME' -> 16r2.
		'HTTP_LOG_FIELD_TIME_TAKEN' -> 16r4000.
		'HTTP_LOG_FIELD_URI' -> 16r800000.
		'HTTP_LOG_FIELD_URI_QUERY' -> 16r200.
		'HTTP_LOG_FIELD_URI_STEM' -> 16r100.
		'HTTP_LOG_FIELD_USER_AGENT' -> 16r10000.
		'HTTP_LOG_FIELD_USER_NAME' -> 16r8.
		'HTTP_LOG_FIELD_VERSION' -> 16r80000.
		'HTTP_LOG_FIELD_WIN32_STATUS' -> 16r800.
		'HTTP_LOGGING_FLAG_LOCAL_TIME_ROLLOVER' -> 16r1.
		'HTTP_LOGGING_FLAG_LOG_ERRORS_ONLY' -> 16r4.
		'HTTP_LOGGING_FLAG_LOG_SUCCESS_ONLY' -> 16r8.
		'HTTP_LOGGING_FLAG_USE_UTF8_CONVERSION' -> 16r2.
		'HTTP_MAX_SERVER_QUEUE_LENGTH' -> 16r7FFFFFFF.
		'HTTP_MIN_ALLOWED_BANDWIDTH_THROTTLING_RATE' -> 16r400.
		'HTTP_MIN_ALLOWED_LOG_FILE_ROLLOVER_SIZE' -> 16r100000.
		'HTTP_MIN_SERVER_QUEUE_LENGTH' -> 16r1.
		'HTTP_RECEIVE_REQUEST_ENTITY_BODY_FLAG_FILL_BUFFER' -> 16r1.
		'HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY' -> 16r1.
		'HTTP_RECEIVE_REQUEST_FLAG_FLUSH_BODY' -> 16r2.
		'HTTP_RECEIVE_SECURE_CHANNEL_TOKEN' -> 16r1.
		'HTTP_REQUEST_AUTH_FLAG_TOKEN_FOR_CACHED_CRED' -> 16r1.
		'HTTP_REQUEST_FLAG_HTTP2' -> 16r4.
		'HTTP_REQUEST_FLAG_IP_ROUTED' -> 16r2.
		'HTTP_REQUEST_FLAG_MORE_ENTITY_BODY_EXISTS' -> 16r1.
		'HTTP_RESPONSE_FLAG_MULTIPLE_ENCODINGS_AVAILABLE' -> 16r1.
		'HTTP_RESPONSE_INFO_FLAGS_PRESERVE_ORDER' -> 16r1.
		'HTTP_SEND_RESPONSE_FLAG_BUFFER_DATA' -> 16r4.
		'HTTP_SEND_RESPONSE_FLAG_DISCONNECT' -> 16r1.
		'HTTP_SEND_RESPONSE_FLAG_ENABLE_NAGLING' -> 16r8.
		'HTTP_SEND_RESPONSE_FLAG_MORE_DATA' -> 16r2.
		'HTTP_SEND_RESPONSE_FLAG_OPAQUE' -> 16r40.
		'HTTP_SEND_RESPONSE_FLAG_PROCESS_RANGES' -> 16r20.
		'HTTP_SERVICE_CONFIG_SSL_FLAG_NEGOTIATE_CLIENT_CERT' -> 16r2.
		'HTTP_SERVICE_CONFIG_SSL_FLAG_NO_RAW_FILTER' -> 16r4.
		'HTTP_SERVICE_CONFIG_SSL_FLAG_REJECT' -> 16r8.
		'HTTP_SERVICE_CONFIG_SSL_FLAG_USE_DS_MAPPER' -> 16r1.
		'HTTP_URL_FLAG_REMOVE_ALL' -> 16r1
	}!
WinHttpServer.HttpApiLibrary guid: (Core.GUID fromString: '{06475580-47cf-4641-9eb7-96d83f2d2e96}')!
WinHttpServer.HttpApiLibrary comment: 'HttpApiLibrary is the <ExternalLibrary> class to represent the dynamic link library, ''HttpApi.dll''.It was generated generated from type information in the ''Win32 API'' library. It contains methods for each of the functions defined by the corresponding module in that type library.

The type library contains the following helpstring for this module
	"Windows HTTP Server API"

Warning: This comment was automatically generated from the module''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

[
	dllname("HttpApi.dll"), 
	uuid(06475580-47CF-4641-9EB7-96D83F2D2E96), 
	helpstring("Windows HTTP Server API")
]
module HttpApi
{
	[entry(0x60000000), helpstring("The HttpInitialize function initializes the HTTP Server API driver, starts it, if it has not already been started, and allocates data structures for the calling application to support response-queue creation and other operations.")]
	unsigned long __stdcall HttpInitialize(
		[in]HTTPAPI_VERSION Version,
		[in]unsigned long flags,
		[in, out]void* pReserved);
	[entry(0x60000001), helpstring("Cleans up resources used by the HTTP Server API to process calls by an application. An application should call HttpTerminate once for every time it called HttpInitialize, with matching flag settings.")]
	unsigned long __stdcall HttpTerminate(
		[in]unsigned long flags,
		[in, out]void* pReserved);
	[entry(0x60000002), helpstring("Creates a new request queue or opens an existing request queue.")]
	unsigned long __stdcall HttpCreateRequestQueue(
		[in]HTTPAPI_VERSION Version,
		[in]LPCWSTR name,
		[in]SECURITY_ATTRIBUTES* securityAttributes,
		[in]unsigned long flags,
		[out]HANDLE* RequestQueueHandle);
	[entry(0x60000003), helpstring("Close a request queue when it is no longer required.")]
	unsigned long __stdcall HttpCloseRequestQueue(
		[in]HANDLE RequestQueueHandle);
	[entry(0x60000004), helpstring("Set a new property or modifies an existing property on the request queue identified by the specified handle.")]
	unsigned long __stdcall HttpSetRequestQueueProperty(
		[in]HANDLE RequestQueueHandle,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength,
		[in]unsigned long Reserved1,
		[in]void* Reserved2);
	[entry(0x60000005), helpstring("Query a property of the request queue identified by the specified handle")]
	unsigned long __stdcall HttpQueryRequestQueueProperty(
		[in]HANDLE RequestQueueProperty,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength,
		[in]unsigned long Reserved1,
		unsigned long* ReturnLength,
		[in]void* Reserved2);
	[entry(0x60000006), helpstring("Stop queuing requests for the specified request queue process.")]
	unsigned long __stdcall HttpShutdownRequestQueue(
		[in]HANDLE RequestQueueHandle);
	[entry(0x60000007)]
	unsigned long __stdcall HttpReceiveClientCertificate(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 ConnectionId,
		[in]unsigned long flags,
		PHTTP_SSL_CLIENT_CERT_INFO SslClientCertInfo,
		[in]unsigned long SslClientCertInfoSize,
		unsigned long* BytesReceived,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x60000008), helpstring("Create a server session for the specified version.")]
	unsigned long __stdcall HttpCreateServerSession(
		[in]HTTPAPI_VERSION Version,
		[out]unsigned __int64* ServerSessionId,
		[in]unsigned long Reserved);
	[entry(0x60000009), helpstring("Deletes the server session identified by the server session ID. All remaining URL Groups associated with the server session will also be closed.")]
	unsigned long __stdcall HttpCloseServerSession(
		[in]unsigned __int64 ServerSessionId);
	[entry(0x6000000a), helpstring("Queries a server property on the specified server session.")]
	unsigned long __stdcall HttpQueryServerSessionProperty(
		[in]unsigned __int64 ServerSessionId,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength,
		unsigned long* ReturnLength);
	[entry(0x6000000b), helpstring("Sets a new server session property or modifies an existing property on the specified server session.")]
	unsigned long __stdcall HttpSetServerSessionProperty(
		[in]unsigned __int64 ServerSessionId,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength);
	[entry(0x6000000c), helpstring("Creates a URL Group under the specified server session.")]
	unsigned long __stdcall HttpCreateUrlGroup(
		[in]unsigned __int64 ServerSessionId,
		[out]unsigned __int64* pUrlGroupId,
		[in]unsigned long Reserved);
	[entry(0x6000000d), helpstring("Closes the URL Group identified by the URL Group ID. This call also removes all of the URLs that are associated with the URL Group")]
	unsigned long __stdcall HttpCloseUrlGroup(
		[in]unsigned __int64 UrlGroupId);
	[entry(0x6000000e), helpstring("Adds the specified URL to the URL Group identified by the URL Group ID.")]
	unsigned long __stdcall HttpAddUrlToUrlGroup(
		[in]unsigned __int64 UrlGroupId,
		[in]LPCWSTR pFullyQualifiedUrl,
		[in]HTTP_URL_CONTEXT UrlContext,
		[in]unsigned long Reserved);
	[entry(0x6000000f), helpstring("The HttpRemoveUrlFromUrlGroup function removes the specified URL from the group identified by the URL Group ID. This function removes one, or all, of the URLs from the group. ")]
	unsigned long __stdcall HttpRemoveUrlFromUrlGroup(
		[in]unsigned __int64 UrlGroupId,
		[in]LPCWSTR pFullyQualifiedUrl,
		[in]unsigned long flags);
	[entry(0x60000010), helpstring("Sets a new property or modifies an existing property on the specified URL Group.")]
	unsigned long __stdcall HttpSetUrlGroupProperty(
		[in]unsigned __int64 UrlGroupId,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength);
	[entry(0x60000011), helpstring("Query a property on the specified URL Group.")]
	unsigned long __stdcall HttpQueryUrlGroupProperty(
		[in]unsigned __int64 UrlGroupId,
		[in]HTTP_SERVER_PROPERTY Property,
		void* PropertyInformation,
		[in]unsigned long PropertyInformationLength,
		unsigned long* ReturnLength);
	[entry(0x60000012), helpstring("Parses, analyzes, and normalizes a non-normalized Unicode or punycode URL so it is safe and valid to use in other HTTP functions (Win8+).")]
	unsigned long __stdcall HttpPrepareUrl(
		void* Reserved,
		unsigned long flags,
		LPCWSTR Url,
		LPWSTR* PreparedUrl);
	[entry(0x60000013), helpstring("Retrieve the next available HTTP request from the specified request queue either synchronously or asynchronously.")]
	unsigned long __stdcall HttpReceiveHttpRequest(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 RequestId,
		[in]unsigned long flags,
		PHTTP_REQUEST RequestBuffer,
		[in]unsigned long RequestBufferLength,
		unsigned long* BytesReturned,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x60000014)]
	unsigned long __stdcall HttpReceiveRequestEntityBody(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 RequestId,
		[in]unsigned long flags,
		void* EntityBuffer,
		[in]unsigned long EntityBufferLength,
		unsigned long* BytesReturned,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x60000015), helpstring("Sends an HTTP response to the specified HTTP request.")]
	unsigned long __stdcall HttpSendHttpResponse(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 RequestId,
		[in]unsigned long flags,
		[in]PHTTP_RESPONSE HttpResponse,
		[in]PHTTP_CACHE_POLICY CachePolicy,
		[out]unsigned long* BytesSent,
		void* Reserved2,
		unsigned long reserved3,
		[in]LPOVERLAPPED OVERLAPPED,
		[in]PHTTP_LOG_DATA LogData);
	[entry(0x60000016), helpstring("Sends entity-body data associated with an HTTP response.")]
	unsigned long __stdcall HttpSendResponseEntityBody(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 RequestId,
		[in]unsigned long flags,
		[in]unsigned short EntityChunkCount,
		HTTP_DATA_CHUNK* EntityChunks,
		[out]unsigned long* BytesSent,
		void* Reserved1,
		unsigned long Reserved2,
		[in]LPOVERLAPPED OVERLAPPED,
		[in]PHTTP_LOG_DATA LogData);
	[entry(0x60000017), helpstring("Declares a resource-to-subresource relationship to use for an HTTP server push. HTTP.sys then performs an HTTP 2.0 server push for the given resource, if the underlying protocol, connection, client, and policies allow the push operation.")]
	unsigned long __stdcall HttpDeclarePush(
		HANDLE RequestQueueHandle,
		unsigned __int64 RequestId,
		HTTP_VERB Verb,
		LPCWSTR Path,
		LPCSTR Query,
		PHTTP_REQUEST_HEADERS Headers);
	[entry(0x60000018), helpstring("Notifies the application when the connection to an HTTP client is broken for any reason.")]
	unsigned long __stdcall HttpWaitForDisconnect(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 ConnectionId,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x60000019), helpstring("This function is an extension to HttpWaitForDisconnect.")]
	unsigned long __stdcall HttpWaitForDisconnectEx(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 ConnectionId,
		[in]unsigned long Reserved,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001a), helpstring("Cancels a specified reqest.")]
	unsigned long __stdcall HttpCancelHttpRequest(
		[in]HANDLE RequestQueueHandle,
		[in]unsigned __int64 RequestId,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001b), helpstring("Wait for the arrival of a new request that can be served by a new request queue process.")]
	unsigned long __stdcall HttpWaitForDemandStart(
		[in]HANDLE RequestQueueHandle,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001c), helpstring("Remove from the HTTP Server API cache associated with a given request queue all response fragments that have a name whose site portion matches a specified UrlPrefix.")]
	unsigned long __stdcall HttpFlushResponseCache(
		[in]HANDLE RequestQueueHandle,
		[in]LPCWSTR UrlPrefix,
		[in]unsigned long flags,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001d), helpstring(" caches a data fragment with a specified name by which it can be retrieved, or updates data cached under a specified name. Such cached data fragments can be used repeatedly to construct dynamic responses without going to disk.")]
	unsigned long __stdcall HttpAddFragmentToCache(
		[in]HANDLE RequestQueueHandle,
		[in]LPCWSTR UrlPrefix,
		[in]HTTP_DATA_CHUNK* DataChunk,
		[in]PHTTP_CACHE_POLICY CachePolicy,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001e)]
	unsigned long __stdcall HttpReadFragmentFromCache(
		[in]HANDLE RequestQueueHandle,
		[in]LPCWSTR UrlPrefix,
		[in]PHTTP_BYTE_RANGE ByteRange,
		void* Buffer,
		[in]unsigned long BufferLength,
		unsigned long* BytesRead,
		[in]LPOVERLAPPED OVERLAPPED);
	[entry(0x6000001f), helpstring("creates and sets a configuration record for the HTTP Server API configuration store. The call fails if the specified record already exists.")]
	unsigned long __stdcall HttpSetServiceConfiguration(
		[in]HANDLE ServiceHandle,
		[in]HTTP_SERVICE_CONFIG_ID ConfigId,
		[in]void* pConfigInformation,
		[in]unsigned long ConfigInformationLength,
		[in]LPOVERLAPPED pOverlapped);
	[entry(0x60000020), helpstring("Deletes specified data, such as IP addresses or SSL Certificates, from the HTTP Server API configuration store, one record at a time.")]
	unsigned long __stdcall HttpDeleteServiceConfiguration(
		[in]HANDLE ServiceHandle,
		[in]HTTP_SERVICE_CONFIG_ID ConfigId,
		[in]void* pConfigInformation,
		[in]unsigned long ConfigInformationLength,
		[in]LPOVERLAPPED pOverlapped);
	[entry(0x60000021), helpstring("Retrieves one or more HTTP Server API configuration records.")]
	unsigned long __stdcall HttpQueryServiceConfiguration(
		[in]HANDLE ServiceHandle,
		[in]HTTP_SERVICE_CONFIG_ID ConfigId,
		[in]void* pInput,
		[in]unsigned long InputLength,
		[out]void* pOutput,
		[in]unsigned long OutputLength,
		[out]unsigned long* pReturnLength,
		[in]LPOVERLAPPED pOverlapped);
};
'!
!WinHttpServer.HttpApiLibrary categoriesForClass!Win32-Modules! !
!WinHttpServer.HttpApiLibrary methodsFor!

addUrl: aString toUrlGroup: anIntegerUrlGroupId
	self checkReturnCode: (self
				httpAddUrlToUrlGroup: anIntegerUrlGroupId
				pFullyQualifiedUrl: aString
				urlContext: 0
				reserved: 0)!

asyncReceiveHttpRequest: requestQueueHandle requestId: requestId flags: flags requestBuffer: requestBuffer requestBufferLength: requestBufferLength bytesReturned: bytesReturned overlapped: overlapped
	"Invoke the HttpReceiveHttpRequest() function of the module wrapped by the receiver.
	Helpstring: Retrieve the next available HTTP request from the specified request queue either synchronously or asynchronously.

		unsigned long __stdcall HttpReceiveHttpRequest(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]unsigned long flags,
			PHTTP_REQUEST RequestBuffer,
			[in]unsigned long RequestBufferLength,
			unsigned long* BytesReturned,
			[in]LPOVERLAPPED OVERLAPPED);"

	<overlap stdcall: dword HttpReceiveHttpRequest handle qword dword HTTP_REQUEST_V2* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

asyncReceiveHttpRequestEntityBody: requestQueueHandle requestId: requestId flags: flags entityBuffer: entityBuffer entityBufferLength: entityBufferLength bytesReturned: bytesReturned overlapped: overlapped
	"Invoke the HttpReceiveRequestEntityBody() function of the module wrapped by the receiver.

		ULONG __stdcall HttpReceiveRequestEntityBody(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]ULONG Flags,
			[out]void* EntityBuffer,
			[in]ULONG EntityBufferLength,
			[out]ULONG* BytesReturned,
			[in]LPOVERLAPPED OVERLAPPED);"

	<overlap stdcall: dword HttpReceiveRequestEntityBody handle qword dword void* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

asyncSendHttpResponse: requestQueueHandle requestId: requestId flags: flags httpResponse: httpResponse cachePolicy: cachePolicy bytesSent: bytesSent reserved2: reserved2 reserved3: reserved3 overlapped: overlapped logData: logData
	"Invoke the HttpSendHttpResponse() function of the module wrapped by the receiver.
	Helpstring: Sends an HTTP response to the specified HTTP request.

		unsigned long __stdcall HttpSendHttpResponse(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]unsigned long flags,
			[in]PHTTP_RESPONSE HttpResponse,
			[in]PHTTP_CACHE_POLICY CachePolicy,
			[out]unsigned long* BytesSent,
			void* Reserved2,
			unsigned long reserved3,
			[in]LPOVERLAPPED OVERLAPPED,
			[in]PHTTP_LOG_DATA LogData);"

	<overlap stdcall: dword HttpSendHttpResponse handle qword dword HTTP_RESPONSE_V2* HTTP_CACHE_POLICY* dword* void* dword OVERLAPPED* HTTP_LOG_FIELDS_DATA*>
	^self invalidCall: _failureCode!

bindQueue: anExternalHandle toUrlGroup: anIntegerGroupId
	self setUrlGroup: anIntegerGroupId
		property: (HTTP_BINDING_INFO new
				requestQueueHandle: anExternalHandle;
				yourself)!

checkReturnCode: anInteger
	anInteger == Win32Errors.NO_ERROR ifFalse: [(Win32Error fromInteger: anInteger) signal]!

close
	"Release the reference the receiver has to the External Library it represents. Answer whether the
	library was successfully closed."

	^(handle notNull and: [(self httpTerminate: self class initFlags pReserved: nil) == NO_ERROR])
		& super close!

createRequestQueue: aString
	| queue |
	queue := Handle new.
	self checkReturnCode: (self
				httpCreateRequestQueue: self class apiVersion
				name: aString
				securityAttributes: nil
				flags: 0
				requestQueueHandle: queue).
	^queue!

createServerSession
	| sessionId |
	sessionId := ULARGE_INTEGER new.
	self checkReturnCode: (self
				httpCreateServerSession: self class apiVersion
				serverSessionId: sessionId
				reserved: 0).
	^sessionId asInteger!

createUrlGroup: anIntegerSessionId
	| groupId |
	groupId := ULARGE_INTEGER new.
	self checkReturnCode: (self
				httpCreateUrlGroup: anIntegerSessionId
				pUrlGroupId: groupId
				reserved: 0).
	^groupId asInteger!

httpAddFragmentToCache: requestQueueHandle urlPrefix: urlPrefix dataChunk: dataChunk cachePolicy: cachePolicy overlapped: overlapped
	"Invoke the HttpAddFragmentToCache() function of the module wrapped by the receiver.
	Helpstring:  caches a data fragment with a specified name by which it can be retrieved, or updates data cached under a specified name. Such cached data fragments can be used repeatedly to construct dynamic responses without going to disk.

		ULONG __stdcall HttpAddFragmentToCache(
			[in]HANDLE RequestQueueHandle,
			[in]LPCWSTR UrlPrefix,
			[in]HTTP_DATA_CHUNK* DataChunk,
			[in]PHTTP_CACHE_POLICY CachePolicy,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpAddFragmentToCache handle lpwstr HTTP_DATA_CHUNK* HTTP_CACHE_POLICY* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpAddUrlToUrlGroup: urlGroupId pFullyQualifiedUrl: pFullyQualifiedUrl urlContext: urlContext reserved: reserved
	"Invoke the HttpAddUrlToUrlGroup() function of the module wrapped by the receiver.
	Helpstring: Adds the specified URL to the URL Group identified by the URL Group ID.

		ULONG __stdcall HttpAddUrlToUrlGroup(
			[in]unsigned __int64 UrlGroupId,
			[in]LPCWSTR pFullyQualifiedUrl,
			[in]HTTP_URL_CONTEXT UrlContext,
			[in]ULONG Reserved);"

	<stdcall: dword HttpAddUrlToUrlGroup qword lpwstr qword dword>
	^self invalidCall: _failureCode!

httpCancelHttpRequest: requestQueueHandle requestId: requestId overlapped: overlapped
	"Invoke the HttpCancelHttpRequest() function of the module wrapped by the receiver.
	Helpstring: Cancels a specified reqest.

		ULONG __stdcall HttpCancelHttpRequest(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpCancelHttpRequest handle qword OVERLAPPED*>
	^self invalidCall: _failureCode!

httpCloseRequestQueue: requestQueueHandle
	"Invoke the HttpCloseRequestQueue() function of the module wrapped by the receiver.
	Helpstring: Close a request queue when it is no longer required.

		ULONG __stdcall HttpCloseRequestQueue(
			[in]HANDLE RequestQueueHandle);"

	<stdcall: dword HttpCloseRequestQueue handle>
	^self invalidCall: _failureCode!

httpCloseServerSession: serverSessionId
	"Invoke the HttpCloseServerSession() function of the module wrapped by the receiver.
	Helpstring: Deletes the server session identified by the server session ID. All remaining URL Groups associated with the server session will also be closed.

		ULONG __stdcall HttpCloseServerSession(
			[in]unsigned __int64 ServerSessionId);"

	<stdcall: dword HttpCloseServerSession qword>
	^self invalidCall: _failureCode!

httpCloseUrlGroup: urlGroupId
	"Invoke the HttpCloseUrlGroup() function of the module wrapped by the receiver.
	Helpstring: Closes the URL Group identified by the URL Group ID. This call also removes all of the URLs that are associated with the URL Group

		ULONG __stdcall HttpCloseUrlGroup(
			[in]unsigned __int64 UrlGroupId);"

	<stdcall: dword HttpCloseUrlGroup qword>
	^self invalidCall: _failureCode!

httpCreateRequestQueue: version name: name securityAttributes: securityAttributes flags: flags requestQueueHandle: requestQueueHandle
	"Invoke the HttpCreateRequestQueue() function of the module wrapped by the receiver.
	Helpstring: Creates a new request queue or opens an existing request queue.

		ULONG __stdcall HttpCreateRequestQueue(
			[in]HTTPAPI_VERSION Version,
			[in]LPCWSTR Name,
			[in]SECURITY_ATTRIBUTES* SecurityAttributes,
			[in]ULONG Flags,
			[out]HANDLE* RequestQueueHandle);"

	<stdcall: dword HttpCreateRequestQueue dword lpwstr SECURITY_ATTRIBUTES* dword handle*>
	^self invalidCall: _failureCode!

httpCreateServerSession: version serverSessionId: serverSessionId reserved: reserved
	"Invoke the HttpCreateServerSession() function of the module wrapped by the receiver.
	Helpstring: Create a server session for the specified version.

		ULONG __stdcall HttpCreateServerSession(
			[in]HTTPAPI_VERSION Version,
			[out]unsigned __int64* ServerSessionId,
			[in]ULONG Reserved);"

	<stdcall: dword HttpCreateServerSession dword qword* dword>
	^self invalidCall: _failureCode!

httpCreateUrlGroup: serverSessionId pUrlGroupId: pUrlGroupId reserved: reserved
	"Invoke the HttpCreateUrlGroup() function of the module wrapped by the receiver.
	Helpstring: Creates a URL Group under the specified server session.

		ULONG __stdcall HttpCreateUrlGroup(
			[in]unsigned __int64 ServerSessionId,
			[out]unsigned __int64* pUrlGroupId,
			[in]ULONG Reserved);"

	<stdcall: dword HttpCreateUrlGroup qword qword* dword>
	^self invalidCall: _failureCode!

httpDeclarePush: requestQueueHandle requestId: requestId verb: verb path: path query: query headers: headers
	"Invoke the HttpDeclarePush() function of the module wrapped by the receiver.
	Helpstring: Declares a resource-to-subresource relationship to use for an HTTP server push. HTTP.sys then performs an HTTP 2.0 server push for the given resource, if the underlying protocol, connection, client, and policies allow the push operation.

		ULONG __stdcall HttpDeclarePush(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]HTTP_VERB Verb,
			[in]LPCWSTR Path,
			[in]LPCSTR Query,
			[in]HTTP_REQUEST_HEADERS* Headers);"

	<stdcall: dword HttpDeclarePush handle qword sdword lpwstr lpstr HTTP_REQUEST_HEADERS*>
	^self invalidCall: _failureCode!

httpDeleteServiceConfiguration: serviceHandle configId: configId pConfigInformation: pConfigInformation configInformationLength: configInformationLength pOverlapped: pOverlapped
	"Invoke the HttpDeleteServiceConfiguration() function of the module wrapped by the receiver.
	Helpstring: Deletes specified data, such as IP addresses or SSL Certificates, from the HTTP Server API configuration store, one record at a time.

		ULONG __stdcall HttpDeleteServiceConfiguration(
			[in]HANDLE ServiceHandle,
			[in]HTTP_SERVICE_CONFIG_ID ConfigId,
			[in]PVOID pConfigInformation,
			[in]ULONG ConfigInformationLength,
			[in]LPOVERLAPPED pOverlapped);"

	<stdcall: dword HttpDeleteServiceConfiguration handle sdword void* dword OVERLAPPED*>
	^self invalidCall: _failureCode!

httpFlushResponseCache: requestQueueHandle urlPrefix: urlPrefix flags: flags overlapped: overlapped
	"Invoke the HttpFlushResponseCache() function of the module wrapped by the receiver.
	Helpstring: Remove from the HTTP Server API cache associated with a given request queue all response fragments that have a name whose site portion matches a specified UrlPrefix.

		ULONG __stdcall HttpFlushResponseCache(
			[in]HANDLE RequestQueueHandle,
			[in]LPCWSTR UrlPrefix,
			[in]ULONG Flags,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpFlushResponseCache handle lpwstr dword OVERLAPPED*>
	^self invalidCall: _failureCode!

httpInitialize: version flags: flags pReserved: pReserved
	"Invoke the HttpInitialize() function of the module wrapped by the receiver.
	Helpstring: The HttpInitialize function initializes the HTTP Server API driver, starts it, if it has not already been started, and allocates data structures for the calling application to support response-queue creation and other operations.

		ULONG __stdcall HttpInitialize(
			[in]HTTPAPI_VERSION Version,
			[in]ULONG Flags,
			[in, out]PVOID pReserved);"

	<stdcall: dword HttpInitialize dword dword void*>
	^self invalidCall: _failureCode!

httpPrepareUrl: reserved flags: flags url: url preparedUrl: preparedUrl
	"Invoke the HttpPrepareUrl() function of the module wrapped by the receiver.
	Helpstring: Parses, analyzes, and normalizes a non-normalized Unicode or punycode URL so it is safe and valid to use in other HTTP functions (Win8+).

		ULONG __stdcall HttpPrepareUrl(
			PVOID Reserved,
			ULONG Flags,
			[in]LPCWSTR Url,
			[out]LPWSTR* PreparedUrl);"

	<stdcall: dword HttpPrepareUrl void* dword lpwstr lpwstr*>
	^self invalidCall: _failureCode!

httpQueryRequestQueueProperty: requestQueueProperty property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength reserved1: reserved1 returnLength: returnLength reserved2: reserved2
	"Invoke the HttpQueryRequestQueueProperty() function of the module wrapped by the receiver.
	Helpstring: Query a property of the request queue identified by the specified handle

		ULONG __stdcall HttpQueryRequestQueueProperty(
			[in]HANDLE RequestQueueProperty,
			[in]HTTP_SERVER_PROPERTY Property,
			[out]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength,
			[in]ULONG Reserved1,
			[out]ULONG* ReturnLength,
			[in]PVOID Reserved2);"

	<stdcall: dword HttpQueryRequestQueueProperty handle sdword void* dword dword dword* void*>
	^self invalidCall: _failureCode!

httpQueryServerSessionProperty: serverSessionId property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength returnLength: returnLength
	"Invoke the HttpQueryServerSessionProperty() function of the module wrapped by the receiver.
	Helpstring: Queries a server property on the specified server session.

		ULONG __stdcall HttpQueryServerSessionProperty(
			[in]unsigned __int64 ServerSessionId,
			[in]HTTP_SERVER_PROPERTY Property,
			[out]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength,
			[out]ULONG* ReturnLength);"

	<stdcall: dword HttpQueryServerSessionProperty qword sdword void* dword dword*>
	^self invalidCall: _failureCode!

httpQueryServiceConfiguration: serviceHandle configId: configId pInput: pInput inputLength: inputLength pOutput: pOutput outputLength: outputLength pReturnLength: pReturnLength pOverlapped: pOverlapped
	"Invoke the HttpQueryServiceConfiguration() function of the module wrapped by the receiver.
	Helpstring: Retrieves one or more HTTP Server API configuration records.

		ULONG __stdcall HttpQueryServiceConfiguration(
			[in]HANDLE ServiceHandle,
			[in]HTTP_SERVICE_CONFIG_ID ConfigId,
			[in]PVOID pInput,
			[in]ULONG InputLength,
			[out]PVOID pOutput,
			[in]ULONG OutputLength,
			[out]ULONG* pReturnLength,
			[in]LPOVERLAPPED pOverlapped);"

	<stdcall: dword HttpQueryServiceConfiguration handle sdword void* dword void* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpQueryUrlGroupProperty: urlGroupId property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength returnLength: returnLength
	"Invoke the HttpQueryUrlGroupProperty() function of the module wrapped by the receiver.
	Helpstring: Query a property on the specified URL Group.

		ULONG __stdcall HttpQueryUrlGroupProperty(
			[in]unsigned __int64 UrlGroupId,
			[in]HTTP_SERVER_PROPERTY Property,
			[out]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength,
			[out]ULONG* ReturnLength);"

	<stdcall: dword HttpQueryUrlGroupProperty qword sdword void* dword dword*>
	^self invalidCall: _failureCode!

httpReadFragmentFromCache: requestQueueHandle urlPrefix: urlPrefix byteRange: byteRange buffer: buffer bufferLength: bufferLength bytesRead: bytesRead overlapped: overlapped
	"Invoke the HttpReadFragmentFromCache() function of the module wrapped by the receiver.

		ULONG __stdcall HttpReadFragmentFromCache(
			[in]HANDLE RequestQueueHandle,
			[in]LPCWSTR UrlPrefix,
			[in]PHTTP_BYTE_RANGE ByteRange,
			[out]PVOID Buffer,
			[in]ULONG BufferLength,
			[out]ULONG* BytesRead,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpReadFragmentFromCache handle lpwstr HTTP_BYTE_RANGE* void* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpReceiveClientCertificate: requestQueueHandle connectionId: connectionId flags: flags sslClientCertInfo: sslClientCertInfo sslClientCertInfoSize: sslClientCertInfoSize bytesReceived: bytesReceived overlapped: overlapped
	"Invoke the HttpReceiveClientCertificate() function of the module wrapped by the receiver.

		ULONG __stdcall HttpReceiveClientCertificate(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 ConnectionId,
			[in]ULONG Flags,
			[out]PHTTP_SSL_CLIENT_CERT_INFO SslClientCertInfo,
			[in]ULONG SslClientCertInfoSize,
			[out]ULONG* BytesReceived,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpReceiveClientCertificate handle qword dword HTTP_SSL_CLIENT_CERT_INFO* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpReceiveHttpRequest: requestQueueHandle requestId: requestId flags: flags requestBuffer: requestBuffer requestBufferLength: requestBufferLength bytesReturned: bytesReturned overlapped: overlapped
	"Invoke the HttpReceiveHttpRequest() function of the module wrapped by the receiver.
	Helpstring: Retrieve the next available HTTP request from the specified request queue either synchronously or asynchronously.

		ULONG __stdcall HttpReceiveHttpRequest(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]ULONG Flags,
			[out]HTTP_REQUEST* RequestBuffer,
			[in]ULONG RequestBufferLength,
			[out]ULONG* BytesReturned,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpReceiveHttpRequest handle qword dword HTTP_REQUEST_V2* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpReceiveRequestEntityBody: requestQueueHandle requestId: requestId flags: flags entityBuffer: entityBuffer entityBufferLength: entityBufferLength bytesReturned: bytesReturned overlapped: overlapped
	"Invoke the HttpReceiveRequestEntityBody() function of the module wrapped by the receiver.

		ULONG __stdcall HttpReceiveRequestEntityBody(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]ULONG Flags,
			[out]PVOID EntityBuffer,
			[in]ULONG EntityBufferLength,
			[out]ULONG* BytesReturned,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpReceiveRequestEntityBody handle qword dword void* dword dword* OVERLAPPED*>
	^self invalidCall: _failureCode!

httpRemoveUrlFromUrlGroup: urlGroupId pFullyQualifiedUrl: pFullyQualifiedUrl flags: flags
	"Invoke the HttpRemoveUrlFromUrlGroup() function of the module wrapped by the receiver.
	Helpstring: The HttpRemoveUrlFromUrlGroup function removes the specified URL from the group identified by the URL Group ID. This function removes one, or all, of the URLs from the group. 

		ULONG __stdcall HttpRemoveUrlFromUrlGroup(
			[in]unsigned __int64 UrlGroupId,
			[in]LPCWSTR pFullyQualifiedUrl,
			[in]ULONG Flags);"

	<stdcall: dword HttpRemoveUrlFromUrlGroup qword lpwstr dword>
	^self invalidCall: _failureCode!

httpSendHttpResponse: requestQueueHandle requestId: requestId flags: flags httpResponse: httpResponse cachePolicy: cachePolicy bytesSent: bytesSent reserved2: reserved2 reserved3: reserved3 overlapped: overlapped logData: logData
	"Invoke the HttpSendHttpResponse() function of the module wrapped by the receiver.
	Helpstring: Sends an HTTP response to the specified HTTP request.

		ULONG __stdcall HttpSendHttpResponse(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]ULONG Flags,
			[in]PHTTP_RESPONSE HttpResponse,
			[in]PHTTP_CACHE_POLICY CachePolicy,
			[out]ULONG* BytesSent,
			PVOID Reserved2,
			ULONG Reserved3,
			[in]LPOVERLAPPED OVERLAPPED,
			[in]PHTTP_LOG_DATA LogData);"

	<stdcall: dword HttpSendHttpResponse handle qword dword HTTP_RESPONSE_V2* HTTP_CACHE_POLICY* dword* void* dword OVERLAPPED* HTTP_LOG_FIELDS_DATA*>
	^self invalidCall: _failureCode!

httpSendResponseEntityBody: requestQueueHandle requestId: requestId flags: flags entityChunkCount: entityChunkCount entityChunks: entityChunks bytesSent: bytesSent reserved1: reserved1 reserved2: reserved2 overlapped: overlapped logData: logData
	"Invoke the HttpSendResponseEntityBody() function of the module wrapped by the receiver.
	Helpstring: Sends entity-body data associated with an HTTP response.

		ULONG __stdcall HttpSendResponseEntityBody(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 RequestId,
			[in]ULONG Flags,
			[in]USHORT EntityChunkCount,
			[in]HTTP_DATA_CHUNK* EntityChunks,
			[out]ULONG* BytesSent,
			PVOID Reserved1,
			ULONG Reserved2,
			[in]LPOVERLAPPED OVERLAPPED,
			[in]PHTTP_LOG_DATA LogData);"

	<stdcall: dword HttpSendResponseEntityBody handle qword dword word HTTP_DATA_CHUNK* dword* void* dword OVERLAPPED* HTTP_LOG_FIELDS_DATA*>
	^self invalidCall: _failureCode!

httpSetRequestQueueProperty: requestQueueHandle property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength reserved1: reserved1 reserved2: reserved2
	"Invoke the HttpSetRequestQueueProperty() function of the module wrapped by the receiver.
	Helpstring: Set a new property or modifies an existing property on the request queue identified by the specified handle.

		ULONG __stdcall HttpSetRequestQueueProperty(
			[in]HANDLE RequestQueueHandle,
			[in]HTTP_SERVER_PROPERTY Property,
			[in]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength,
			[in]ULONG Reserved1,
			[in]PVOID Reserved2);"

	<stdcall: dword HttpSetRequestQueueProperty handle sdword void* dword dword void*>
	^self invalidCall: _failureCode!

httpSetServerSessionProperty: serverSessionId property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength
	"Invoke the HttpSetServerSessionProperty() function of the module wrapped by the receiver.
	Helpstring: Sets a new server session property or modifies an existing property on the specified server session.

		ULONG __stdcall HttpSetServerSessionProperty(
			[in]unsigned __int64 ServerSessionId,
			[in]HTTP_SERVER_PROPERTY Property,
			[in]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength);"

	<stdcall: dword HttpSetServerSessionProperty qword sdword void* dword>
	^self invalidCall: _failureCode!

httpSetServiceConfiguration: serviceHandle configId: configId pConfigInformation: pConfigInformation configInformationLength: configInformationLength pOverlapped: pOverlapped
	"Invoke the HttpSetServiceConfiguration() function of the module wrapped by the receiver.
	Helpstring: creates and sets a configuration record for the HTTP Server API configuration store. The call fails if the specified record already exists.

		ULONG __stdcall HttpSetServiceConfiguration(
			[in]HANDLE ServiceHandle,
			[in]HTTP_SERVICE_CONFIG_ID ConfigId,
			[in]PVOID pConfigInformation,
			[in]ULONG ConfigInformationLength,
			[in]LPOVERLAPPED pOverlapped);"

	<stdcall: dword HttpSetServiceConfiguration handle sdword void* dword OVERLAPPED*>
	^self invalidCall: _failureCode!

httpSetUrlGroupProperty: urlGroupId property: property propertyInformation: propertyInformation propertyInformationLength: propertyInformationLength
	"Invoke the HttpSetUrlGroupProperty() function of the module wrapped by the receiver.
	Helpstring: Sets a new property or modifies an existing property on the specified URL Group.

		ULONG __stdcall HttpSetUrlGroupProperty(
			[in]unsigned __int64 UrlGroupId,
			[in]HTTP_SERVER_PROPERTY Property,
			[in]PVOID PropertyInformation,
			[in]ULONG PropertyInformationLength);"

	<stdcall: dword HttpSetUrlGroupProperty qword sdword void* dword>
	^self invalidCall: _failureCode!

httpShutdownRequestQueue: requestQueueHandle
	"Invoke the HttpShutdownRequestQueue() function of the module wrapped by the receiver.
	Helpstring: Stop queuing requests for the specified request queue process.

		ULONG __stdcall HttpShutdownRequestQueue(
			[in]HANDLE RequestQueueHandle);"

	<stdcall: dword HttpShutdownRequestQueue handle>
	^self invalidCall: _failureCode!

httpTerminate: flags pReserved: pReserved
	"Invoke the HttpTerminate() function of the module wrapped by the receiver.
	Helpstring: Cleans up resources used by the HTTP Server API to process calls by an application. An application should call HttpTerminate once for every time it called HttpInitialize, with matching flag settings.

		ULONG __stdcall HttpTerminate(
			[in]ULONG Flags,
			[in, out]PVOID pReserved);"

	<stdcall: dword HttpTerminate dword void*>
	^self invalidCall: _failureCode!

httpWaitForDemandStart: requestQueueHandle overlapped: overlapped
	"Invoke the HttpWaitForDemandStart() function of the module wrapped by the receiver.
	Helpstring: Wait for the arrival of a new request that can be served by a new request queue process.

		ULONG __stdcall HttpWaitForDemandStart(
			[in]HANDLE RequestQueueHandle,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpWaitForDemandStart handle OVERLAPPED*>
	^self invalidCall: _failureCode!

httpWaitForDisconnect: requestQueueHandle connectionId: connectionId overlapped: overlapped
	"Invoke the HttpWaitForDisconnect() function of the module wrapped by the receiver.
	Helpstring: Notifies the application when the connection to an HTTP client is broken for any reason.

		ULONG __stdcall HttpWaitForDisconnect(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 ConnectionId,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpWaitForDisconnect handle qword OVERLAPPED*>
	^self invalidCall: _failureCode!

httpWaitForDisconnectEx: requestQueueHandle connectionId: connectionId reserved: reserved overlapped: overlapped
	"Invoke the HttpWaitForDisconnectEx() function of the module wrapped by the receiver.
	Helpstring: This function is an extension to HttpWaitForDisconnect.

		ULONG __stdcall HttpWaitForDisconnectEx(
			[in]HANDLE RequestQueueHandle,
			[in]unsigned __int64 ConnectionId,
			[in]ULONG Reserved,
			[in]LPOVERLAPPED OVERLAPPED);"

	<stdcall: dword HttpWaitForDisconnectEx handle qword dword OVERLAPPED*>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize http.sys"

	| ret |
	ret := self
				httpInitialize: self class apiVersion
				flags: self class initFlags
				pReserved: nil.
	ret ~= NO_ERROR ifTrue: [(Win32Error fromInteger: ret) signal].
	^self!

querySession: sessionIdInteger property: propIdInteger
	| type buf ret bufSize |
	type := ##((Array new: HttpServerProtectionLevelProperty + 1)
				at: HttpServerAuthenticationProperty + 1 put: HTTP_SERVER_AUTHENTICATION_INFO;
				at: HttpServerLoggingProperty + 1 put: HTTP_LOGGING_INFO;
				at: HttpServerTimeoutsProperty + 1 put: HTTP_TIMEOUT_LIMIT_INFO;
				at: HttpServerQueueLengthProperty + 1 put: nil;
				at: HttpServerStateProperty + 1 put: HTTP_STATE_INFO;
				at: HttpServer503VerbosityProperty + 1 put: DWORDBytes;
				at: HttpServerBindingProperty + 1 put: HTTP_BINDING_INFO;
				at: HttpServerExtendedAuthenticationProperty + 1 put: HTTP_SERVER_AUTHENTICATION_INFO;
				at: HttpServerListenEndpointProperty + 1 put: nil;
				at: HttpServerChannelBindProperty + 1 put: HTTP_CHANNEL_BIND_INFO;
				at: HttpServerProtectionLevelProperty + 1 put: nil;
				yourself) at: propIdInteger + 1.
	type isNil ifTrue: [^self error: 'Unable to query property ' , propIdInteger printString].
	buf := type new.
	bufSize := DWORDBytes new.
	ret := self
				httpQueryServerSessionProperty: sessionIdInteger
				property: propIdInteger
				propertyInformation: buf
				propertyInformationLength: buf byteSize
				returnLength: bufSize.
	ret == Win32Errors.ERROR_MORE_DATA
		ifTrue: 
			[buf := type new: bufSize value.
			ret := self
						httpQueryServerSessionProperty: sessionIdInteger
						property: propIdInteger
						propertyInformation: buf
						propertyInformationLength: buf byteSize
						returnLength: bufSize].
	^ret == Win32Errors.ERROR_INVALID_PARAMETER
		ifFalse: 
			[self checkReturnCode: ret.
			buf]!

querySession: sessionIdInteger qosProperty: qosTypeInteger
	| query ret bufSize |
	query := HTTP_QOS_SETTING_INFO new.
	query QosType: qosTypeInteger.
	bufSize := DWORDBytes new.
	ret := self
				httpQueryServerSessionProperty: sessionIdInteger
				property: HttpServerQosProperty
				propertyInformation: query
				propertyInformationLength: query byteSize
				returnLength: bufSize.
	ret == Win32Errors.ERROR_MORE_DATA ifFalse: [^self checkReturnCode: ret].
	query := HTTP_QOS_SETTING_INFO new: bufSize value.
	ret := self
				httpQueryServerSessionProperty: sessionIdInteger
				property: HttpServerQosProperty
				propertyInformation: query
				propertyInformationLength: query byteSize
				returnLength: bufSize.
	self checkReturnCode: ret.
	^query!

queryUrlGroup: urlGroupId qosSetting: anInteger
	| query ret bufSize |
	query := HTTP_QOS_SETTING_INFO new
				QosType: anInteger;
				yourself.
	bufSize := DWORDBytes new.
	ret := self
				httpQueryUrlGroupProperty: urlGroupId
				property: HttpServerQosProperty
				propertyInformation: query
				propertyInformationLength: query byteSize
				returnLength: bufSize.
	ret == Win32Errors.ERROR_MORE_DATA ifFalse: [^self checkReturnCode: ret].
	query := (HTTP_QOS_SETTING_INFO new: bufSize value)
				QosType: anInteger;
				yourself.
	ret := self
				httpQueryUrlGroupProperty: urlGroupId
				property: HttpServerQosProperty
				propertyInformation: query
				propertyInformationLength: query byteSize
				returnLength: bufSize.
	self checkReturnCode: ret.
	^query value!

receiveRequest: anExternalHandle
	^self receiveRequest: anExternalHandle flags: HTTP_RECEIVE_REQUEST_FLAG_COPY_BODY!

receiveRequest: anExternalHandle flags: anInteger
	| bytesReceived buf requestId |
	buf := HTTP_REQUEST new: 4096.
	bytesReceived := DWORDBytes new.
	requestId := 0.
	
	[| ret |
	ret := self
				asyncReceiveHttpRequest: anExternalHandle
				requestId: requestId
				flags: anInteger
				requestBuffer: buf
				requestBufferLength: buf size
				bytesReturned: bytesReceived
				overlapped: nil.
	(ret == Win32Errors.ERROR_INVALID_PARAMETER and: [requestId ~~ 0])
		ifTrue: 
			["Start again"
			requestId := 0]
		ifFalse: 
			[ret == Win32Errors.ERROR_MORE_DATA
				ifTrue: 
					["Allocate required size buffer and go round again"
					requestId := buf RequestId.
					buf := HTTP_REQUEST new: bytesReceived asInteger]
				ifFalse: 
					[self checkReturnCode: ret.
					^buf]]]
			repeat!

receiveRequestEntityBody: anExternalHandle requestId: requestId
	| bytesReceived buf bufLen data |
	bufLen := 32768.
	buf := ByteArray new: bufLen.
	data := WriteStream on: (ByteArray new: buf size).
	bytesReceived := DWORDBytes new.
	
	[| ret |
	ret := self
				asyncReceiveHttpRequestEntityBody: anExternalHandle
				requestId: requestId
				flags: HTTP_RECEIVE_REQUEST_ENTITY_BODY_FLAG_FILL_BUFFER
				entityBuffer: buf
				entityBufferLength: buf size
				bytesReturned: bytesReceived
				overlapped: nil.
	ret == Win32Errors.ERROR_INVALID_PARAMETER
		ifTrue: 
			[self checkReturnCode: ret.
			^buf]
		ifFalse: 
			[ret == Win32Errors.NO_ERROR
				ifTrue: 
					[data
						next: bytesReceived asInteger
						putAll: buf
						startingAt: 1]
				ifFalse: 
					[ret == Win32Errors.ERROR_HANDLE_EOF
						ifTrue: [^data contents]
						ifFalse: 
							[self checkReturnCode: ret.
							^data contents]]]]
			repeat!

sendResponse: response queue: queue id: request
	| bytesSent |
	bytesSent := DWORD new.
	self checkReturnCode: (self
		asyncSendHttpResponse: queue
		requestId: request
		flags: 0
		httpResponse: response
		cachePolicy: nil
		bytesSent: bytesSent
		reserved2: 0
		reserved3: 0
		overlapped: nil
		logData: nil).
	^bytesSent value
	!

setQueue: anExternalHandle property: aWinHttpPropertyInfo
	self checkReturnCode: (self
				httpSetRequestQueueProperty: anExternalHandle
				property: aWinHttpPropertyInfo propertyId
				propertyInformation: aWinHttpPropertyInfo
				propertyInformationLength: aWinHttpPropertyInfo byteSize
				reserved1: 0
				reserved2: 0)!

setSession: anInteger property: anHttpPropertyStruct
	self checkReturnCode: (self
				httpSetServerSessionProperty: anInteger
				property: anHttpPropertyStruct propertyId
				propertyInformation: anHttpPropertyStruct
				propertyInformationLength: anHttpPropertyStruct byteSize)!

setUrlGroup: anIntegerGroupId property: aWinHttpPropertyInfo
	self checkReturnCode: (self
				httpSetUrlGroupProperty: anIntegerGroupId
				property: aWinHttpPropertyInfo propertyId
				propertyInformation: aWinHttpPropertyInfo
				propertyInformationLength: aWinHttpPropertyInfo byteSize)! !
!WinHttpServer.HttpApiLibrary categoriesFor: #addUrl:toUrlGroup:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #asyncReceiveHttpRequest:requestId:flags:requestBuffer:requestBufferLength:bytesReturned:overlapped:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #asyncReceiveHttpRequestEntityBody:requestId:flags:entityBuffer:entityBufferLength:bytesReturned:overlapped:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #asyncSendHttpResponse:requestId:flags:httpResponse:cachePolicy:bytesSent:reserved2:reserved3:overlapped:logData:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #bindQueue:toUrlGroup:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #checkReturnCode:!helpers!private! !
!WinHttpServer.HttpApiLibrary categoriesFor: #close!public!realizing/unrealizing! !
!WinHttpServer.HttpApiLibrary categoriesFor: #createRequestQueue:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #createServerSession!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #createUrlGroup:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpAddFragmentToCache:urlPrefix:dataChunk:cachePolicy:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpAddUrlToUrlGroup:pFullyQualifiedUrl:urlContext:reserved:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCancelHttpRequest:requestId:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCloseRequestQueue:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCloseServerSession:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCloseUrlGroup:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCreateRequestQueue:name:securityAttributes:flags:requestQueueHandle:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCreateServerSession:serverSessionId:reserved:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpCreateUrlGroup:pUrlGroupId:reserved:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpDeclarePush:requestId:verb:path:query:headers:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpDeleteServiceConfiguration:configId:pConfigInformation:configInformationLength:pOverlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpFlushResponseCache:urlPrefix:flags:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpInitialize:flags:pReserved:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpPrepareUrl:flags:url:preparedUrl:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpQueryRequestQueueProperty:property:propertyInformation:propertyInformationLength:reserved1:returnLength:reserved2:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpQueryServerSessionProperty:property:propertyInformation:propertyInformationLength:returnLength:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpQueryServiceConfiguration:configId:pInput:inputLength:pOutput:outputLength:pReturnLength:pOverlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpQueryUrlGroupProperty:property:propertyInformation:propertyInformationLength:returnLength:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpReadFragmentFromCache:urlPrefix:byteRange:buffer:bufferLength:bytesRead:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpReceiveClientCertificate:connectionId:flags:sslClientCertInfo:sslClientCertInfoSize:bytesReceived:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpReceiveHttpRequest:requestId:flags:requestBuffer:requestBufferLength:bytesReturned:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpReceiveRequestEntityBody:requestId:flags:entityBuffer:entityBufferLength:bytesReturned:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpRemoveUrlFromUrlGroup:pFullyQualifiedUrl:flags:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSendHttpResponse:requestId:flags:httpResponse:cachePolicy:bytesSent:reserved2:reserved3:overlapped:logData:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSendResponseEntityBody:requestId:flags:entityChunkCount:entityChunks:bytesSent:reserved1:reserved2:overlapped:logData:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSetRequestQueueProperty:property:propertyInformation:propertyInformationLength:reserved1:reserved2:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSetServerSessionProperty:property:propertyInformation:propertyInformationLength:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSetServiceConfiguration:configId:pConfigInformation:configInformationLength:pOverlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpSetUrlGroupProperty:property:propertyInformation:propertyInformationLength:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpShutdownRequestQueue:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpTerminate:pReserved:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpWaitForDemandStart:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpWaitForDisconnect:connectionId:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #httpWaitForDisconnectEx:connectionId:reserved:overlapped:!**auto generated**!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #initialize!initializing!private! !
!WinHttpServer.HttpApiLibrary categoriesFor: #querySession:property:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #querySession:qosProperty:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #queryUrlGroup:qosSetting:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #receiveRequest:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #receiveRequest:flags:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #receiveRequestEntityBody:requestId:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #sendResponse:queue:id:!operations!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #setQueue:property:!accessing!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #setSession:property:!public! !
!WinHttpServer.HttpApiLibrary categoriesFor: #setUrlGroup:property:!operations!public! !

!WinHttpServer.HttpApiLibrary class methodsFor!

apiVersion
	"Answer the required Win32 Http Server API version in HTTPAPI_VERSION representation, i.e. a
	4-byte value with the first word being the major version, and the 2nd word being the major
	version.

		typedef [uuid(61D915C6-278B-4ED6-942B-DB3B81C86C11), helpstring('Api Version. This is used to ensure compatibility between applications and httpapi.dll and http.sys. This should not be confused with the HTTP Protocol version.')]
		struct tagHTTPAPI_VERSION {
			unsigned short HttpApiMajorVersion;
			unsigned short HttpApiMinorVersion;
		} HTTPAPI_VERSION;"

	^##((WORDArray withAll: #(2 0)) bytes dwordAtOffset: 0)!

example1
	"
	Note 1: If you get access denied, either run as admin, or use 'netsh http add urlacl' to add permissions on a URL for your user a/c.
		self example1
	
	Note 2: This will work for https, but some configuration is required to set up a server
	cert; for test purposes you can generate a self-signed certificate using makecert, and then
	associate it with the ip/port you want to listen on using 'netsh http add sslcert'. For more
	info see, for example,
	https://blogs.msdn.microsoft.com/jpsanders/2009/09/29/how-to-walkthrough-using-httplistener-or-http-server-unmanaged-code-c-as-an-ssl-simple-server/.
	If you use VS with IIS Express for web development, you can piggy back off the setup it does config a self-signed cert against the range of ports 44300-44399.
	"

	| lib sessionId queue groupId urlPrefix iveConfiguredSsl |
	iveConfiguredSsl := false.
	urlPrefix := iveConfiguredSsl
				ifTrue: [
					"Change this to the URL you've added your SSL cert to."
					'https://localhost:44300/dolphin/']
				ifFalse: 
					["By default, any user should be able to listen on this URL prefix"
					'http://+:80/Temporary_Listen_Addresses/'].
	lib := self default.
	
	[| listener |
	sessionId := lib createServerSession.
	Transcript
		display: 'Created http server session ';
		display: sessionId hex;
		cr.
	"Register the URLs to listen on (MSDN sample uses old v1 API HttpAddUrl here)"
	groupId := lib createUrlGroup: sessionId.
	Transcript
		display: 'Created http server url group ';
		display: groupId hex;
		cr.
	lib addUrl: urlPrefix toUrlGroup: groupId.
	Transcript
		display: 'Registered http server url group ';
		print: urlPrefix;
		cr.
	"Associate the request queue with the URL group"
	queue := lib createRequestQueue: 'MyQueue'.
	Transcript
		display: 'Created  http server request queue ';
		print: queue;
		cr.
	lib bindQueue: queue toUrlGroup: groupId.
	Transcript
		display: 'Associated  http server request queue with url group';
		cr.

	"Receive a request, this can use either the Windows Overlapped I/O mechanisn, or Dolphin's own overlapped calls. The latter is simpler."
	listener := 
			[
			[| request response |
			Transcript
				display: 'Listening for requests on ';
				display: urlPrefix;
				nextPutAll: ' ... ';
				cr.
			request := lib receiveRequest: queue.
			Transcript
				nextPutAll: 'Received request for ';
				display: request CookedUrl pFullUrl;
				cr.
			response := HTTP_RESPONSE new.
			response
				StatusCode: 200;
				pReason: 'OK';
				contentType: 'text/html';
				content: ((String writeStream)
							nextPutAll: '<!!DOCTYPE html>';
							cr;
							nextPutAll: '<html><body><h3>Request received:</h3>';
							print: request;
							nextPutAll: '</body></html>';
							contents).
			Transcript
				nextPutAll: 'Sent ';
				print: (lib
							sendResponse: response
							queue: queue
							id: request RequestId);
				nextPutAll: ' bytes';
				cr.
			#todo	"Send a response"]
					repeat]
					fork.
	UI.MessageBox notify: ((String writeStream)
				nextPutAll: 'Listening for HTTP requests on ';
				display: urlPrefix;
				nextPutAll: ' ... ';
				cr;
				cr;
				nextPutAll: 'Press OK to stop';
				contents).
	listener terminate]
			ensure: 
				[queue notNil
					ifTrue: 
						["Finished with request queue"
						Transcript
							display: 'Closing request queue ';
							print: queue;
							cr.
						lib httpCloseRequestQueue: queue].
				groupId notNil
					ifTrue: 
						["Finished with URL group"
						Transcript
							display: 'Closing URL group ';
							print: groupId;
							cr.
						lib httpCloseUrlGroup: groupId].
				sessionId notNil
					ifTrue: 
						["Finished with the session"
						Transcript
							display: 'Closing Http session ';
							print: sessionId;
							cr.
						lib httpCloseServerSession: sessionId]]!

example3
	"Example of service config set/query API - Sets/queries IP listen list.
		self example3
	"

	| param bufSize lib ret sizeRequired buf |
	lib := self default.
	"Add IPv6 localhost to the listen list - needs admin rights"
	param := HTTP_SERVICE_CONFIG_IP_LISTEN_PARAM new.
	param address: (SOCKADDR fromString: '::1').
	ret := lib
				httpSetServiceConfiguration: 0
				configId: HttpServiceConfigIPListenList
				pConfigInformation: param
				configInformationLength: param byteSize
				pOverlapped: nil.
	(ret == 0 or: [ret == Win32Errors.ERROR_ALREADY_EXISTS]) ifFalse: [Win32Error signalWith: ret].
	bufSize := DWORDBytes new.
	buf := HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY new.
	ret := lib
				httpQueryServiceConfiguration: 0
				configId: HttpServiceConfigIPListenList
				pInput: nil
				inputLength: 0
				pOutput: buf
				outputLength: buf byteSize
				pReturnLength: bufSize
				pOverlapped: nil.
	ret == 0
		ifFalse: 
			["The query struct has space for one sockaddr, but if there are more we'll need to re-allocate and try again"
			ret == Win32Errors.ERROR_MORE_DATA ifFalse: [Win32Error signalWith: ret].
			sizeRequired := bufSize value.
			buf := HTTP_SERVICE_CONFIG_IP_LISTEN_QUERY new: sizeRequired.
			ret := lib
						httpQueryServiceConfiguration: 0
						configId: HttpServiceConfigIPListenList
						pInput: nil
						inputLength: 0
						pOutput: buf
						outputLength: sizeRequired
						pReturnLength: bufSize
						pOverlapped: nil.
			ret == 0 ifFalse: [Win32Error signalWith: ret]].
	"Remove the IPv6 entry added above from the listen list"
	ret := lib
				httpDeleteServiceConfiguration: 0
				configId: HttpServiceConfigIPListenList
				pConfigInformation: param
				configInformationLength: param byteSize
				pOverlapped: nil.
	^buf!

example4
	"Example of querying session properties.
		self example4
	"

	| lib sessionId |
	lib := self default.
	
	[sessionId := lib createServerSession.
	^lib querySession: sessionId property: HttpServerTimeoutsProperty]
			ensure: [lib httpCloseServerSession: sessionId]!

example6
	"Example of querying URL group QOS properties.
		self example6
	"

	| lib sessionId groupId queue |
	lib := self default.
	^
	[sessionId := lib createServerSession.
	groupId := lib createUrlGroup: sessionId.
	queue := lib createRequestQueue: 'Temp'.
	lib setUrlGroup: groupId property: (HTTP_QOS_SETTING_INFO maxConnections: 100).
	lib setUrlGroup: groupId property: (HTTP_QOS_SETTING_INFO maxBandwidth: 10000).
	"lib setQueue: queue
		property: (HTTP_QOS_SETTING_INFO new value: (HTTP_FLOWRATE_INFO
						maxBandwidth: 10000
						maxPeakBandwidth: 30000
						burstSize: 20000))."
	{lib queryUrlGroup: groupId qosSetting: HttpQosSettingTypeConnectionLimit.
		lib queryUrlGroup: groupId qosSetting: HttpQosSettingTypeBandwidth}
	"with: (lib queryUrlGroup: groupId qosSetting: HttpQosSettingTypeFlowRate)"]
			ensure: 
				[queue ifNotNil: [lib httpCloseRequestQueue: queue].
				groupId ifNotNil: [lib httpCloseUrlGroup: groupId].
				sessionId ifNotNil: [lib httpCloseServerSession: sessionId]]!

example7
	"Example of querying/setting the session enablement state property.
		self example7
	"

	| lib sessionId |
	lib := self default.
	^
	[sessionId := lib createServerSession.
	lib setSession: sessionId property: HTTP_STATE_INFO inactive.
	lib querySession: sessionId property: HttpServerStateProperty]
			ensure: [lib httpCloseServerSession: sessionId]!

example8
	"Example of setting/querying HTTP_LOGGING_INFO session properties.
		self example8
	"

	| lib sessionId |
	lib := self default.
	
	[sessionId := lib createServerSession.
	lib setSession: sessionId
		property: (HTTP_LOGGING_INFO new
				Present: true;
				DirectoryName: FileLocator imageRelative basePath;
				SoftwareName: 'Dolphin';
				Format: HttpLoggingTypeW3C;
				RolloverType: HttpLoggingRolloverSize;
				RolloverSize: 1024 * 1024;
				Fields: HTTP_LOG_FIELD_DATE | HTTP_LOG_FIELD_TIME | HTTP_LOG_FIELD_CLIENT_IP | HTTP_LOG_FIELD_METHOD
							| HTTP_LOG_FIELD_URI;
				yourself).
	^lib halt querySession: sessionId property: HttpServerLoggingProperty]
			ensure: [lib httpCloseServerSession: sessionId]!

fileName
	"Answer the host system file name for the library."

	^'HttpApi'
!

initFlags
	^##(HTTP_INITIALIZE_SERVER | HTTP_INITIALIZE_CONFIG)!

querySslCertInfo
	"Example of calling config query API - Returns all SSL cert settings configured.
		self querySslCertInfo last
	"

	| parms bufSize lib count answer ret |
	parms := HTTP_SERVICE_CONFIG_SSL_QUERY new.
	parms QueryDesc: HttpServiceConfigQueryNext.
	lib := self default.
	count := 0.
	bufSize := DWORDBytes new.
	answer := OrderedCollection new.
	
	[parms dwToken: count.
	ret := lib
				httpQueryServiceConfiguration: 0
				configId: HttpServiceConfigSSLCertInfo
				pInput: parms
				inputLength: parms byteSize
				pOutput: nil
				outputLength: 0
				pReturnLength: bufSize
				pOverlapped: nil.
	ret == Win32Errors.ERROR_NO_MORE_ITEMS]
			whileFalse: 
				[| buf sizeRequired |
				ret == Win32Errors.ERROR_INSUFFICIENT_BUFFER ifFalse: [Win32Error signalWith: ret].
				sizeRequired := bufSize value.
				buf := HTTP_SERVICE_CONFIG_SSL_SET new: sizeRequired.
				ret := lib
							httpQueryServiceConfiguration: 0
							configId: HttpServiceConfigSSLCertInfo
							pInput: parms
							inputLength: parms byteSize
							pOutput: buf
							outputLength: sizeRequired
							pReturnLength: bufSize
							pOverlapped: nil.
				ret == 0 ifFalse: [Win32Error signalWith: ret].
				answer addLast: buf.
				count := count + 1].
	^answer!

queryUrlAclInfo
	"Example of calling config query API - Returns all URL ACLs settings currently configured.
		self queryUrlAclInfo
	"

	| parms bufSize lib count answer ret |
	parms := HTTP_SERVICE_CONFIG_URLACL_QUERY new.
	parms QueryDesc: HttpServiceConfigQueryNext.
	lib := self default.
	count := 0.
	bufSize := DWORDBytes new.
	answer := OrderedCollection new.
	
	[parms dwToken: count.
	ret := lib
				httpQueryServiceConfiguration: 0
				configId: HttpServiceConfigUrlAclInfo
				pInput: parms
				inputLength: parms byteSize
				pOutput: nil
				outputLength: 0
				pReturnLength: bufSize
				pOverlapped: nil.
	ret == Win32Errors.ERROR_NO_MORE_ITEMS]
			whileFalse: 
				[| buf sizeRequired |
				ret == Win32Errors.ERROR_INSUFFICIENT_BUFFER ifFalse: [Win32Error signalWith: ret].
				sizeRequired := bufSize value.
				buf := HTTP_SERVICE_CONFIG_URLACL_SET new: sizeRequired.
				ret := lib
							httpQueryServiceConfiguration: 0
							configId: HttpServiceConfigUrlAclInfo
							pInput: parms
							inputLength: parms byteSize
							pOutput: buf
							outputLength: sizeRequired
							pReturnLength: bufSize
							pOverlapped: nil.
				ret == 0 ifFalse: [Win32Error signalWith: ret].
				answer addLast: buf.
				count := count + 1].
	^answer! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #apiVersion!constants!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example1!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example3!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example4!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example6!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example7!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #example8!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #fileName!**auto generated**!constants!private! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #initFlags!constants!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #querySslCertInfo!examples!public! !
!WinHttpServer.HttpApiLibrary class categoriesFor: #queryUrlAclInfo!examples!public! !

