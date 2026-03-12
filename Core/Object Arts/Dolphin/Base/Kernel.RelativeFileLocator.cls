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

Kernel.RelativeFileLocator comment: '`RelativeFileLocator` is the abstract class of `FileLocator`s that can be used to map between an absolute path and a path relative to a certain base directory.
`RelativeFileLocator`s use absolute paths for files outside the local directory hierarchy below the base directory, and relative paths within their local directory hierarchy.'!

!Kernel.RelativeFileLocator categoriesForClass!System-Support! !

!Kernel.RelativeFileLocator methodsFor!

abstract: aPathOrString
	"Answer a <readableString> token for the resource with the specified <Path> or <readableString> path argument. For RelativeFileLocators will typically be a path relative to the receiver's base path such that this locator can later resolve it back to the original path via #resolve:. Exceptionally if the specified bath is not under the receiver's base path, then the answer will be a full path string."

	| relative path |
	path := aPathOrString asPath.
	relative := self relativeToBase: path.
	^((relative path beginsWith: '..') ifTrue: [path fullPath] ifFalse: [relative]) path!

basePath
	^SessionManager.Current imageBase!

relativeToBase: aPathOrString
	^(aPathOrString asPath relativeTo: self basePath)!

resolve: aString
	"Answer a full <Path> for the argument, which is expected to be the internal representation of a Path created be a previous call to #abstract: on this or an equivalent locator. We expect the argument to be a <readableString> path to be resolved relative to the receiver's base path."

	^aString asPath fullPathRelativeTo: self basePath! !

!Kernel.RelativeFileLocator categoriesForMethods!
abstract:!mapping!public! !
basePath!accessing!public! !
relativeToBase:!accessing!private! !
resolve:!mapping!public! !
!

