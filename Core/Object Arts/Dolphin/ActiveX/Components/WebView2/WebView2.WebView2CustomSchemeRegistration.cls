"Filed out from Dolphin Smalltalk"!

OS.COM.InterfaceImplementation
	subclass: #'WebView2.WebView2CustomSchemeRegistration'
	instanceVariableNames: 'flags schemeName allowedOrigins'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'AuthorityComponentMask' -> 16r1. 'TreatAsSecureMask' -> 16r2 }!

WebView2.WebView2CustomSchemeRegistration guid: (Core.GUID fromString: '{f6fc08a7-3b60-45af-a5a6-52774afc30fe}')!

WebView2.WebView2CustomSchemeRegistration comment: ''!

!WebView2.WebView2CustomSchemeRegistration methodsFor!

allowedOrigins
	^allowedOrigins!

allowedOrigins: aCollectionOfStrings
	allowedOrigins := aCollectionOfStrings asArray!

get_HasAuthorityComponent: hasAuthorityComponent
	"Private - Get the value of the 'HasAuthorityComponent' property of the receiver.

		HRESULT __stdcall HasAuthorityComponent(
			[out, retval]long* HasAuthorityComponent);"

	hasAuthorityComponent value: self hasAuthorityComponent asParameter.
	^S_OK!

get_SchemeName: pwszSchemeName
	"Private - Get the value of the 'SchemeName' property of the receiver.

		HRESULT __stdcall SchemeName(
			[out, retval]LPWSTR* SchemeName);"

	pwszSchemeName value: self schemeName asUtf16String copyToCOMTaskMemory detach.
	^S_OK!

get_TreatAsSecure: treatAsSecure
	"Private - Get the value of the 'TreatAsSecure' property of the receiver.

		HRESULT __stdcall TreatAsSecure(
			[out, retval]long* TreatAsSecure);"

	treatAsSecure value: self treatAsSecure asParameter.
	^S_OK!

GetAllowedOrigins: allowedOriginsCount allowedOrigins: pawszAllowedOrigins
	"Private - Implement the GetAllowedOrigins() method of the COM object.

		HRESULT __stdcall GetAllowedOrigins(
			[out]unsigned int* allowedOriginsCount,
			[out]LPWSTR** allowedOrigins);"

	| count buf |
	count := allowedOrigins size.
	allowedOriginsCount value: count.
	count = 0
		ifTrue: 
			[pawszAllowedOrigins value: 0.
			^S_OK].
	"We are expected to allocate the array from task memory, then each of the strings also from task memory. Ownership of the array and string allocations is passed to the caller (i.e. it must free them)."
	buf := PointerArray new: count bufferClass: TaskMemory.
	buf elementClass: Utf16String.
	1 to: count
		do: [:i | buf uncheckedAt: i put: (allowedOrigins at: i) asUtf16String copyToCOMTaskMemory detach].
	pawszAllowedOrigins value: buf bytes detach.
	^S_OK!

hasAuthorityComponent
	^flags allMask: AuthorityComponentMask!

hasAuthorityComponent: aBoolean
	flags := flags mask: AuthorityComponentMask set: aBoolean!

initialize
	super initialize.
	flags := 0.
	allowedOrigins := #()!

put_HasAuthorityComponent: hasAuthorityComponent
	"Private - Set the value of the 'HasAuthorityComponent' property of the object wrapped by the 
	 receiver to the <sdword> argument, hasAuthorityComponent.

		HRESULT __stdcall HasAuthorityComponent(
			[in]long HasAuthorityComponent);"

	self hasAuthorityComponent: hasAuthorityComponent asBoolean.
	^S_OK!

put_TreatAsSecure: treatAsSecure
	"Private - Set the value of the 'TreatAsSecure' property of the object wrapped by the 
	 receiver to the <sdword> argument, treatAsSecure.

		HRESULT __stdcall TreatAsSecure(
			[in]long TreatAsSecure);"

	self treatAsSecure: treatAsSecure asBoolean.
	^S_OK!

schemeName
	^schemeName!

SetAllowedOrigins: allowedOriginsCount allowedOrigins: pawszAllowedOrigins
	"Private - Implement the SetAllowedOrigins() method of the COM object.

		HRESULT __stdcall SetAllowedOrigins(
			[in]unsigned int allowedOriginsCount,
			[in]LPWSTR* allowedOrigins);"

	allowedOrigins := (PointerArray
				fromAddress: pawszAllowedOrigins bytes
				length: allowedOriginsCount
				elementClass: Utf16String) asArray.
	^S_OK!

setSchemeName: aString
	schemeName := aString!

supportedInterfaces
	"Answer the set of interface classes supported by the receiver."

	^##({ IUnknown. ICoreWebView2CustomSchemeRegistration })!

treatAsSecure
	^flags allMask: TreatAsSecureMask!

treatAsSecure: aBoolean
	flags := flags mask: TreatAsSecureMask set: aBoolean! !

!WebView2.WebView2CustomSchemeRegistration categoriesForMethods!
allowedOrigins!accessing!public! !
allowedOrigins:!accessing!public! !
get_HasAuthorityComponent:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
get_SchemeName:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
get_TreatAsSecure:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
GetAllowedOrigins:allowedOrigins:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
hasAuthorityComponent!accessing!public! !
hasAuthorityComponent:!accessing!public! !
initialize!initializing!private! !
put_HasAuthorityComponent:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
put_TreatAsSecure:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
schemeName!accessing!public! !
SetAllowedOrigins:allowedOrigins:!**auto generated**!COM Interfaces-ICoreWebView2CustomSchemeRegistration!private! !
setSchemeName:!accessing!initializing!private! !
supportedInterfaces!constants!public! !
treatAsSecure!accessing!public! !
treatAsSecure:!accessing!public! !
!

WebView2.WebView2CustomSchemeRegistration methodProtocol: #ICoreWebView2CustomSchemeRegistration attributes: #(#readOnly) selectors: #(#get_HasAuthorityComponent: #get_SchemeName: #get_TreatAsSecure: #GetAllowedOrigins:allowedOrigins: #put_HasAuthorityComponent: #put_TreatAsSecure: #SetAllowedOrigins:allowedOrigins:)!

!WebView2.WebView2CustomSchemeRegistration class methodsFor!

icon
	^ICoreWebView2 icon!

newScheme: aString
	^self new setSchemeName: aString! !

!WebView2.WebView2CustomSchemeRegistration class categoriesForMethods!
icon!constants!development!public! !
newScheme:!public! !
!

