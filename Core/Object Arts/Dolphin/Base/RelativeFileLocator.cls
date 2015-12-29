"Filed out from Dolphin Smalltalk X6"!

FileLocator subclass: #RelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RelativeFileLocator guid: (GUID fromString: '{B1397191-87FC-4D23-9E6D-3730F12E4B5C}')!
RelativeFileLocator comment: 'RelativeFileLocator is the abstract class of <FileLocator>s that can be used to map between an absolute path and a path relative to a certain base directory.
RelativeFileLocators use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.'!
!RelativeFileLocator categoriesForClass!System-Support! !
!RelativeFileLocator methodsFor!

relativePathTo: aString 
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path from the receiver's base path."

	^self relativePathIfSubPath: aString! !
!RelativeFileLocator categoriesFor: #relativePathTo:!accessing!public! !

