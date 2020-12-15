"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #WinHttp
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private} #{OS private})
	classInstanceVariableNames: ''
	classConstants: {
		'AutoLogonPolicy_Always' -> 16r0.
		'AutoLogonPolicy_Never' -> 16r2.
		'AutoLogonPolicy_OnlyIfBypassProxy' -> 16r1.
		'SecureProtocol_ALL' -> 16rA8.
		'SecureProtocol_SSL2' -> 16r8.
		'SecureProtocol_SSL3' -> 16r20.
		'SecureProtocol_TLS1' -> 16r80.
		'SecureProtocol_TLS1_1' -> 16r200.
		'SecureProtocol_TLS1_2' -> 16r800.
		'SslErrorFlag_CertCNInvalid' -> 16r1000.
		'SslErrorFlag_CertDateInvalid' -> 16r2000.
		'SslErrorFlag_CertWrongUsage' -> 16r200.
		'SslErrorFlag_Ignore_All' -> 16r3300.
		'SslErrorFlag_UnknownCA' -> 16r100.
		'WinHttpRequestOption_EnableCertificateRevocationCheck' -> 16r12.
		'WinHttpRequestOption_EnableHttp1_1' -> 16r11.
		'WinHttpRequestOption_EnableHttpsToHttpRedirects' -> 16rC.
		'WinHttpRequestOption_EnablePassportAuthentication' -> 16rD.
		'WinHttpRequestOption_EnableRedirects' -> 16r6.
		'WinHttpRequestOption_EnableTracing' -> 16rA.
		'WinHttpRequestOption_EscapePercentInURL' -> 16r3.
		'WinHttpRequestOption_MaxAutomaticRedirects' -> 16rE.
		'WinHttpRequestOption_MaxResponseDrainSize' -> 16r10.
		'WinHttpRequestOption_MaxResponseHeaderSize' -> 16rF.
		'WinHttpRequestOption_RejectUserpwd' -> 16r13.
		'WinHttpRequestOption_RevertImpersonationOverSsl' -> 16rB.
		'WinHttpRequestOption_SecureProtocols' -> 16r9.
		'WinHttpRequestOption_SelectCertificate' -> 16r5.
		'WinHttpRequestOption_SslErrorIgnoreFlags' -> 16r4.
		'WinHttpRequestOption_URL' -> 16r1.
		'WinHttpRequestOption_URLCodePage' -> 16r2.
		'WinHttpRequestOption_UrlEscapeDisable' -> 16r7.
		'WinHttpRequestOption_UrlEscapeDisableQuery' -> 16r8.
		'WinHttpRequestOption_UserAgentString' -> 16r0
	}!
WinHttp guid: (Core.GUID fromString: '{168eedf7-2e1e-4f8c-92f3-260db4cae775}')!
WinHttp comment: ''!
!WinHttp categoriesForClass!Kernel-Objects! !
