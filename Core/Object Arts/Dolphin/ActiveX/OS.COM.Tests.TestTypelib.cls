"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestResource subclass: #TestTypelib
	instanceVariableNames: 'analyzer'
	classVariableNames: ''
	imports: #(#{OS.Win32Constants})
	classInstanceVariableNames: ''
	classConstants: {}!
TestTypelib guid: (Core.GUID fromString: '{bda93d8c-df4b-4461-8950-9db6e8797384}')!
TestTypelib comment: ''!
!TestTypelib categoriesForClass!Unclassified! !
!TestTypelib methodsFor!

analyzer
	^analyzer!

libid
	^GUID fromString: '{39EA4CC5-6518-4C4B-BD48-0FC1B44A08C8}'!

setUp
	super setUp.
	
	[analyzer := AXTypeLibraryAnalyzer
				load: self libid
				major: 1
				minor: 0
				locale: NlsConstants.LOCALE_USER_DEFAULT]
			on: HRESULTError
			do: [:ex | ex hresult asInteger = AXAutomationErrors.TYPE_E_LIBNOTREGISTERED ifFalse: [ex pass]]!

tearDown
	analyzer notNil 
		ifTrue: 
			[analyzer package uninstall.
			analyzer free.
			analyzer := nil].
	super tearDown! !
!TestTypelib categoriesFor: #analyzer!private!unit tests! !
!TestTypelib categoriesFor: #libid!Init / Release!public! !
!TestTypelib categoriesFor: #setUp!Init / Release!public! !
!TestTypelib categoriesFor: #tearDown!public!Running! !

