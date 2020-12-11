"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.HRESULTTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.HRESULTTest guid: (Core.GUID fromString: '{b4d51222-9be2-40de-9f0a-3dd5d377e0a4}')!
OS.Tests.HRESULTTest comment: ''!
!OS.Tests.HRESULTTest categoriesForClass!Unclassified! !
!OS.Tests.HRESULTTest methodsFor!

testDisplayString
	| subject installedLangIds |
	subject := HRESULT fromInteger: Win32Errors.E_ABORT.
	installedLangIds := Locale installedUILanguages collect: [:each | each languageId].
	({{Locale smalltalk. 'Operation aborted'}.
		{Locale lcid: NlsConstants.LOCALE_CUSTOM_UNSPECIFIED. 'Operation aborted'}}
			, {{Locale named: 'fr-CA'. 'Opération abandonnée'}.
					{Locale named: 'es-AR'. 'Operación anulada'}.
					{Locale named: 'en-GB'. 'Operation aborted'}.
					{Locale named: 'ja-JP'. '操作は中断されました'}}
			select: [:each | installedLangIds includes: each first languageId]) do: 
				[:pair |
				| actual |
				actual := subject displayString: pair first.
				self assert: actual equals: pair second]! !
!OS.Tests.HRESULTTest categoriesFor: #testDisplayString!public!unit tests! !

