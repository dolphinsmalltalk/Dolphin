"Filed out from Dolphin Smalltalk 7"!

OSVERSIONINFOEXW subclass: #OSVERSIONINFO
	instanceVariableNames: 'osName'
	classVariableNames: 'Current'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
OSVERSIONINFO guid: (GUID fromString: '{87b4c604-026e-11d3-9fd7-00a0cc3e4a32}')!
OSVERSIONINFO comment: 'OSVERSIONINFO is an ExternalStructure class to represent the Win32 OSVERSIONINFOEX structure.

OSVERSIONINFO was used to retrieve version information about the host OS on which an application is running. However the Windows API GetVersionEx has been deprecated by Microsoft, and consequently the functions of this class that relied on information returned by GetVersionEx are deprecated. The Version Helper functions on VMLibrary should be used instead. 

Note that rather than test for a specific OS version in class library methods, it is preferable to define a capability enquiry with an appropriate intention revealing name, e.g. see those in SystemMetrics. In other words, don''t check for the OS version info that supports the functionality you required from your application code you should use (or define and use) a query to test for the specific feature or functionality on which you depend.
'!
!OSVERSIONINFO categoriesForClass!Deprecated! !
!OSVERSIONINFO methodsFor!

calculateOsName
	| major minor type |
	self assert: [self dwPlatformId = VER_PLATFORM_WIN32_NT].
	major := self dwMajorVersion.
	minor := self dwMinorVersion.
	type := self wProductType.
	major <= 5 
		ifTrue: 
			[minor = 0 ifTrue: [^#win2k].
			minor = 1 ifTrue: [^#winXP].
			^#win2k3].
	major = 6 
		ifTrue: 
			[minor = 0 ifTrue: [^type == VER_NT_WORKSTATION ifTrue: [#winVista] ifFalse: [#win2k8]].
			minor = 1 ifTrue: [^type == VER_NT_WORKSTATION ifTrue: [#win7] ifFalse: [#win2k8r2]].
			minor = 2 ifTrue: [^#win8].
			^#win81].
	^#win10!

hasThemes
	^self isWinXPOrLater!

isNT
	"Answer whether the host OS is NT (4 or 2000).
		OSVERSIONINFO current isNT
	"

	^self dwPlatformId == VER_PLATFORM_WIN32_NT!

isNT4
	"Answer whether the host OS is NT4.
		OSVERSIONINFO current isNT
	"

	"NT4 is no longer supported"
	^false!

isWin2K
	"Answer whether the host OS is Windows 2000.
		OSVERSIONINFO current isWin2K
	"

	^self osName == #win2k!

isWin2K3
	"Answer whether the host OS is Windows Server 2003 specifically."

	^self osName = #win2k3!

isWin2K3OrLater
	"Answer whether the host OS is Windows Server 2003, or some later version."

	^self dwPlatformId == VER_PLATFORM_WIN32_NT 
		and: [self dwMajorVersion > 5 or: [self dwMajorVersion == 5 and: [self dwMinorVersion >= 2]]]!

isWin95
	"Answer whether the host OS is Windows 95.
		OSVERSIONINFO current isWin95
	"

	"Dolphin no longer supports the pre-NT Windows OSs"

	^false!

isWin98
	"Answer whether the host OS is Windows 98.
		OSVERSIONINFO current isWin98
	"

	"Dolphin no longer supports the pre-NT Windows OSs"

	^false!

isWin9X
	"Answer whether the host OS is Windows 95/98 or ME."

	"Dolphin no longer supports the pre-NT Windows OSs"

	^false!

isWinMe
	"Answer whether the host OS is Windows Me.
		OSVERSIONINFO current isWinMe
	"

	"Dolphin no longer supports the pre-NT Windows OSs"

	^false!

isWinV5
	^#(#win2k #winXP #win98 #winMe) identityIncludes: self osName!

isWinV5OrLater
	"Answer whether the host OS is Windows 98 or Windows 2000 or later. These OSs added certain
	UI features such as menus with images.
		OSVERSIONINFO current isWinV5OrLater 
	"

	| major |
	major := self dwMajorVersion.
	^self dwPlatformId = VER_PLATFORM_WIN32_NT 
		ifTrue: [major >= 5]
		ifFalse: [major > 4 or: [major == 4 and: [self dwMinorVersion > 0]]]!

isWinV6OrLater
	"Answer whether the host OS is Windows Vista or later."

	^self dwMajorVersion >= 6!

isWinVista
	"Answer whether the host OS is Windows Vista or later."

	^self dwMajorVersion = 6!

isWinXP
	"Answer whether the host OS is Windows XP specifically."

	^self osName == #winXP!

isWinXPOrLater
	"Answer whether the host OS is Windows XP, Windows Server 2003, or some later version."

	^self dwPlatformId == VER_PLATFORM_WIN32_NT 
		and: [self dwMajorVersion > 5 or: [self dwMajorVersion == 5 and: [self dwMinorVersion >= 1]]]!

osName
	"Answer a symbolic name which indicates which is the host operating system, this will be one
	of #win7 #win28kr2, #win2k8, #win2k3, #winXP, #win2k. Dolphin no longer supports NT4 or the
	pre-NT generation of OSs such as Windows 98."

	osName isNil ifTrue: [osName := self calculateOsName].
	^osName! !
!OSVERSIONINFO categoriesFor: #calculateOsName!helpers!private! !
!OSVERSIONINFO categoriesFor: #hasThemes!accessing!private! !
!OSVERSIONINFO categoriesFor: #isNT!public!testing! !
!OSVERSIONINFO categoriesFor: #isNT4!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin2K!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin2K3!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin2K3OrLater!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin95!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin98!public!testing! !
!OSVERSIONINFO categoriesFor: #isWin9X!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinMe!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinV5!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinV5OrLater!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinV6OrLater!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinVista!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinXP!public!testing! !
!OSVERSIONINFO categoriesFor: #isWinXPOrLater!public!testing! !
!OSVERSIONINFO categoriesFor: #osName!accessing!public! !

!OSVERSIONINFO class methodsFor!

clear
	"Private - Reinitialize the receiver."

	Current := nil!

current
	"Answer the current instance of the receiver."

	Current isNil ifTrue: [Current := self getCurrent].
	^Current!

defineFields
	"Define the fields of the Win32 OSVERSIONINFO structure.

		OSVERSIONINFO compileDefinition
	"

	super defineFields!

getCurrent
	"Private - Get the current OSVERSIONINFO."

	| current |
	current := self new.
	KernelLibrary default getVersionEx: current.
	^current!

uninitialize
	"Private - Uninitialize the receiver as it is about to be removed from the system."

	self clear.
! !
!OSVERSIONINFO class categoriesFor: #clear!initializing!private! !
!OSVERSIONINFO class categoriesFor: #current!instance creation!public! !
!OSVERSIONINFO class categoriesFor: #defineFields!public!template definition! !
!OSVERSIONINFO class categoriesFor: #getCurrent!instance creation!private! !
!OSVERSIONINFO class categoriesFor: #uninitialize!class hierarchy-removing!private! !

