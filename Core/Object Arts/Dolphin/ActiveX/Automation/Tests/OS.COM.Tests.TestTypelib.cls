"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource subclass: #'OS.COM.Tests.TestTypelib'
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.TestTypelib guid: (Core.GUID fromString: '{bda93d8c-df4b-4461-8950-9db6e8797384}')!
OS.COM.Tests.TestTypelib comment: ''!
!OS.COM.Tests.TestTypelib methodsFor!

analyzer
	^analyzer!

libid
	^GUID fromString: '{39EA4CC5-6518-4C4B-BD48-0FC1B44A08C8}'!

setUp
	super setUp.
	
	[analyzer := TypeLibraryAnalyzer
				load: self libid
				major: 1
				minor: 0
				locale: NlsConstants.LOCALE_USER_DEFAULT]
			on: HRESULTError
			do: [:ex | ex hresult asInteger = AutomationErrors.TYPE_E_LIBNOTREGISTERED ifFalse: [ex pass]]!

tearDown
	analyzer notNil 
		ifTrue: 
			[analyzer package uninstall.
			analyzer free.
			analyzer := nil].
	super tearDown! !
!OS.COM.Tests.TestTypelib categoriesForMethods!
analyzer!private!unit tests! !
libid!Init / Release!public! !
setUp!Init / Release!public! !
tearDown!public!Running! !
!

