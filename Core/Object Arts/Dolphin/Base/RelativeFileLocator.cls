"Filed out from Dolphin Smalltalk"!

FileLocator subclass: #RelativeFileLocator
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RelativeFileLocator guid: (GUID fromString: '{b1397191-87fc-4d23-9e6d-3730f12e4b5c}')!
RelativeFileLocator comment: 'RelativeFileLocator is the abstract class of <FileLocator>s that can be used to map between an absolute path and a path relative to a certain base directory.
RelativeFileLocators use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.'!
!RelativeFileLocator categoriesForClass!System-Support! !
!RelativeFileLocator methodsFor!

relativePathTo: aString 
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path from the receiver's base path."

	^self relativePathIfSubPath: aString! !
!RelativeFileLocator categoriesForMethods!
relativePathTo:!accessing!public! !
!

