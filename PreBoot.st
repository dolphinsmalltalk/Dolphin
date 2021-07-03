Kernel.ProtoObject subclass: #'External.DynamicLinkLibraryStub'
	instanceVariableNames: 'libraryClass'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
	
!External.DynamicLinkLibraryStub methodsFor!

doesNotUnderstand: failedMessage
	^failedMessage forwardTo: libraryClass default!

libraryClass: aClass
	libraryClass := aClass! !
	
!External.DynamicLinkLibraryStub class methodsFor!

libraryClass: aClass
	^self new libraryClass: aClass; yourself! !

Kernel at: #VM put: VMLibrary default!
OS at: #User32 put: UserLibrary default!
OS at: #Kernel32 put: KernelLibrary default!
OS at: #Ucrt put: CRTLibrary default!
| ntdll isWine |
isWine := OS.NTLibrary.IsWine.
ntdll := OS.NTLibrary default.
#(#isWine #openDefault) do: [:each | OS.NTLibrary class removeSelector: each].
External.PermanentLibrary subclass: #'OS.NTLibrary'
	instanceVariableNames: 'isWine'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}.
ntdll instVarAt: (OS.NTLibrary indexOfInstVar: 'isWine') put: isWine.
OS at: #NtDll put: ntdll!
OS at: #Shlwapi put: ShlwapiLibrary default!
OS at: #AdvApi32 put: AdvApiLibrary default!

| systemPackage |
systemPackage := Object owningPackage.
DynamicLinkLibraryStub owningPackage: systemPackage.
#(#{Kernel.VM} #{OS.User32} #{OS.Kernel32} #{OS.Ucrt} #{OS.NtDll} #{OS.Shlwapi} #{OS.AdvApi32}) do: [:each |
	each binding owningPackage: systemPackage]!
