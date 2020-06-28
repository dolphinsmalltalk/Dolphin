"Filed out from Dolphin Smalltalk 7"!

ExternalLibrary subclass: #HTMLHelpLibrary
	instanceVariableNames: 'cookie'
	classVariableNames: ''
	poolDictionaries: 'HTMLHelpConstants'
	classInstanceVariableNames: ''
	classConstants: {}!
HTMLHelpLibrary guid: (GUID fromString: '{9e0d2430-3877-11d3-93bd-00a024ca708a}')!
HTMLHelpLibrary comment: ''!
!HTMLHelpLibrary categoriesForClass!Unclassified! !
!HTMLHelpLibrary methodsFor!

close
	"Release the reference the receiver has to the External Library it represents, but
	before doing so make sure the HH_UNINITIALIZE command is issued (if
	necessary)."

	self htmlHelpUninitialize.
	^super close!

handle: aHandle
	"Private - Set the handle of the external library which the receiver represents,
	and initialize the HTML help system (if the handle is not being nulled).
	Answer the receiver."

	super handle: aHandle.
	aHandle isNil
		ifTrue: [cookie := nil]
		ifFalse: [self htmlHelpInitialize]!

htmlHelp: hwndCaller pszFile: pszFile uCommand: uCommand dwData: dwData
	"Pop-up the HTML help viewer on the specified file.

		HWND HtmlHelp( 
			HWND hwndCaller, 
			LPCWSTR pszFile, 
			UINT uCommand, 
			DWORD dwData) ; 
		"

	<stdcall: handle HtmlHelpW handle lpwstr dword lpvoid>
	^self invalidCall: _failureCode!

htmlHelpCloseAll
	"Closes all help windows opened by the current application"

	self assert: [cookie notNil].
	self htmlHelp: 0 pszFile: nil uCommand: HH_CLOSE_ALL dwData: 0!

htmlHelpInitialize
	"Private - Initialize the HTML help system - must be the first command."

	cookie := DWORD new.	
	self htmlHelp: 0 pszFile: nil uCommand: HH_INITIALIZE dwData: cookie yourAddress.
	cookie := cookie asInteger!

htmlHelpUninitialize
	"Private - Uninitialize the HTML help system - must be the last command."

	cookie isNil ifTrue: [^self].
	self 
		htmlHelp: 0
		pszFile: nil
		uCommand: HH_UNINITIALIZE
		dwData: cookie.
	cookie := nil!

htmlHelpUrl: url 
	"Brings up the default HTML help window on the <readableString> url."

	^self htmlHelpUrl: url style: nil!

htmlHelpUrl: url style: styleOrNil 
	"Brings up the HTML help window on the <readableString> url. If styleOrNil is not nil
	then the help window is brought up as the specified style."

	self assert: [cookie notNil].
	^self 
		htmlHelp: UserLibrary default getDesktopWindow
		pszFile: (styleOrNil isNil ifTrue: [url] ifFalse: [url , '>' , styleOrNil])
		uCommand: HH_DISPLAY_TOPIC
		dwData: 0! !
!HTMLHelpLibrary categoriesFor: #close!public!realizing/unrealizing! !
!HTMLHelpLibrary categoriesFor: #handle:!accessing!private! !
!HTMLHelpLibrary categoriesFor: #htmlHelp:pszFile:uCommand:dwData:!operations!public! !
!HTMLHelpLibrary categoriesFor: #htmlHelpCloseAll!operations!public! !
!HTMLHelpLibrary categoriesFor: #htmlHelpInitialize!operations!private! !
!HTMLHelpLibrary categoriesFor: #htmlHelpUninitialize!operations!private! !
!HTMLHelpLibrary categoriesFor: #htmlHelpUrl:!operations!public! !
!HTMLHelpLibrary categoriesFor: #htmlHelpUrl:style:!operations!public! !

!HTMLHelpLibrary class methodsFor!

fileName
	"Answer the host system file name of the external library which the 
	receiver represents"

	^'hhctrl.ocx'!

htmlHelpCloseAll
	"Closes all help windows opened by the current application (if any), but avoiding
	loading the OCX if help not previously used."

	(default notNil and: [default isOpen]) ifTrue: [
		default htmlHelpCloseAll]! !
!HTMLHelpLibrary class categoriesFor: #fileName!constants!public! !
!HTMLHelpLibrary class categoriesFor: #htmlHelpCloseAll!operations!public! !

