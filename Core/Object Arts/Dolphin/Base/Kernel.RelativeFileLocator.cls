"Filed out from Dolphin Smalltalk"!

Core.FileLocator
	subclass: #'Kernel.RelativeFileLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.RelativeFileLocator guid: (Core.GUID fromString: '{b1397191-87fc-4d23-9e6d-3730f12e4b5c}')!

Kernel.RelativeFileLocator isNonInstantiable: true!

Kernel.RelativeFileLocator comment: 'RelativeFileLocator is the abstract class of <FileLocator>s that can be used to map between an absolute path and a path relative to a certain base directory.
RelativeFileLocators use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.'!

!Kernel.RelativeFileLocator categoriesForClass!System-Support! !

!Kernel.RelativeFileLocator methodsFor!

relativePathTo: aString 
	"Answer a minimal <readableString> relative path to the resource with the 
	specified <readableString> path from the receiver's base path."

	^self relativePathIfSubPath: aString! !

!Kernel.RelativeFileLocator categoriesForMethods!
relativePathTo:!accessing!public! !
!

