"Filed out from Dolphin Smalltalk X6"!

IdePrinterExtensions subclass: #IdeBrowserPrinterExtension
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeBrowserPrinterExtension guid: (GUID fromString: '{A04C63AB-AC0E-4272-9D82-4350AE5660A3}')!
IdeBrowserPrinterExtension comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdeBrowserPrinterExtension categoriesForClass!IDB Goodies! !
!IdeBrowserPrinterExtension class methodsFor!

extendedClasses
	^(Set with: SmalltalkSystem current methodExplorerClass
		with: SmalltalkSystem current workspaceShellClass)
		addAll: SmalltalkSystem current classBrowserClasses;
		yourself!

extendMenuIn: aBrowser 
	self extendMenuIn: aBrowser before: #exit!

isExtension
	^true! !
!IdeBrowserPrinterExtension class categoriesFor: #extendedClasses!accessing!public! !
!IdeBrowserPrinterExtension class categoriesFor: #extendMenuIn:!operations!public! !
!IdeBrowserPrinterExtension class categoriesFor: #isExtension!constants!public! !

