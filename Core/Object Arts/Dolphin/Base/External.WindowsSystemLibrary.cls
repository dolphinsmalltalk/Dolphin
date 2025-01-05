"Filed out from Dolphin Smalltalk"!

External.DynamicLinkLibrary
	subclass: #'External.WindowsSystemLibrary'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.WindowsSystemLibrary guid: (Core.GUID fromString: '{8f9fa452-2b2f-4bc1-b0f9-cce474238025}')!

External.WindowsSystemLibrary isNonInstantiable: true!

External.WindowsSystemLibrary comment: '`WindowsSystemLibrary` is the class of all the Windows libraries that should only ever (for security reasons) be loaded from `%windows%\system32`.'!

!External.WindowsSystemLibrary methodsFor!

loadFlags
	"Private - Only ever load the Windows system libraries from %windows%\system32"

	^LOAD_LIBRARY_SEARCH_SYSTEM32! !

!External.WindowsSystemLibrary categoriesForMethods!
loadFlags!constants!private! !
!

