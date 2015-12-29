"Filed out from Dolphin Smalltalk X6"!

IdeExtensions subclass: #IdeClassBrowserExtensions
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
IdeClassBrowserExtensions guid: (GUID fromString: '{3B160391-FD9A-45A4-B6A7-378DCB5386AE}')!
IdeClassBrowserExtensions comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!IdeClassBrowserExtensions categoriesForClass!IDB Goodies! !
!IdeClassBrowserExtensions class methodsFor!

extendedClasses
	| sys |
	sys := SmalltalkSystem current.
	^sys classBrowserClasses! !
!IdeClassBrowserExtensions class categoriesFor: #extendedClasses!accessing!public! !

