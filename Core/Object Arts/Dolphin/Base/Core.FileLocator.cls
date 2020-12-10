"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'Core.FileLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.FileLocator guid: (Core.GUID fromString: '{391014f8-ebb8-4dd3-bd5d-fb6f303de483}')!
Core.FileLocator isNonInstantiable: true!
Core.FileLocator comment: '`FileLocator` is an abstract root for a hierarchy of subclasses that implement the <fileLocator> protocol. 
A <fileLocator> is used map between an external resource pathname and an internal name. First an external name is mapped to an internal form using #relativePathTo:. The latter can be held in the image and later mapped back to it''s is full external name using #localFileSpecFor:.

Several singleton <fileLocator>s are supplied and can be referenced using the following class methods:

 `imageRelative`	- An instance of `Kernel.ImageRelativeFileLocator`
 `installRelative`	- An instance of `Kernel.InstallRelativeFileLocator`
 `absolute`		- An instance of `Kernel.AbsoluteFileLocator`
  `default`			- Answers the `imageRelative` locator

<fileLocator>s for resolving files relative to arbitrary folders can be created using the class-side `folderRelative:` and `imageFolderRelative:`. The first expects the absolute path of a folder that is will subsequently use as a base path. The second expects a folder path relative to the image base path.

For example, say that you want to reference an Icon resource file that is held relative to your current image file (perhaps in the \Resources sudirectory). You want to do this in such a way that if you move your image then the \Resources directory will be expected to move with it.

```
icon := Icon fromFile: ''Resources\myIcon.ico'' usingLocator: FileLocator imageRelative.
```

Here, the path to the icon file will be held within the Icon instance in a form that is relative to the base location of the image directory. Icons also hold the file locator too and use this to map back to the full path of the icon file when it is necessary to load it. Hence if you move your image file, the Icon will still expect to be able to load the icon resource from a location that relative to the image directory.

Typically, this is the behaviour that you''ll want by default. At development time, resources are referenced relative to the image and, at runtime, relative to the executable file (which is effective an image, anyway). For this reason the above example could also have been written as:

```
icon := Icon fromFile: ''Resources\myIcon.ico'' usingLocator: FileLocator default
```
or
```
icon := Icon fromFile: ''Resources\myIcon.ico'' 
```
Sometimes, especially in the case of development tools, you might want a resource to be referenced relative to the Dolphin installation directory. In this case `FileLocator installRelative` would be moe appropriate. Take a look at `DolphinSureCertificate>>#image`, for example. Note that, at runtime, the image location and installation location are treated as the same by a standard `RuntimeSessionManager`.
'!
!Core.FileLocator categoriesForClass!System-Support! !
!Core.FileLocator methodsFor!

basePath
	^SessionManager current imageBase!

findOrImportForeignClass
	"An attempt is being made by a <ClassLocator> to load a class when the dynamic loading
	capability is not installed. This is normally available as part of the Web Deployment Kit.
	Raise an error to the effect that the class cannot be found."

	^self errorClassNotFound!

localFileSpecFor: aString
	"Answer a full filespec for the <readableString> relative path argument, formed according to
	the rules of this particular file locator. This is the reverse operation to
	#relativePathTo:, and is performed when the file needs to be located."

	^File fullPathOf: aString relativeTo: self basePath!

relativePathIfSubPath: aFilename
	"Private - Answer a minimal <readableString> relative path to the resource with the
	specified <readableString> path, but only if a sub-path of the receiver's base path,
	otherwise answer the full absolute path."

	| relative |
	relative := self relativeToBase: aFilename.
	^(relative beginsWith: '..') ifTrue: [File fullPathOf: aFilename] ifFalse: [relative]!

relativePathTo: aString 
	"Answer a minimal <readableString> relative path to the resource with the specified
	<readableString> path from the receiver's base path."

	^self relativeToBase: aString!

relativeToBase: aFilename
	^File relativePathOf: aFilename to: self basePath! !
!Core.FileLocator categoriesFor: #basePath!accessing!public! !
!Core.FileLocator categoriesFor: #findOrImportForeignClass!operations!private! !
!Core.FileLocator categoriesFor: #localFileSpecFor:!accessing!public! !
!Core.FileLocator categoriesFor: #relativePathIfSubPath:!accessing!private! !
!Core.FileLocator categoriesFor: #relativePathTo:!accessing!public! !
!Core.FileLocator categoriesFor: #relativeToBase:!accessing!private! !

Core.FileLocator methodProtocol: #fileLocator attributes: #(#readOnly) selectors: #(#localFileSpecFor: #relativePathTo:)!

!Core.FileLocator class methodsFor!

absolute
	"Answers an instance of the receiver that can be used to locate external files
	with an absolute path."

	^AbsoluteFileLocator current!

default
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current image directory."

	^self imageRelative
!

folderRelative: aString
	^FolderRelativeFileLocator basePath: aString!

imageFolderRelative: aString
	^self folderRelative: (self imageRelative localFileSpecFor: aString)!

imageRelative
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current image  directory."

	^ImageRelativeFileLocator current!

imageRelative: aFilenameString
	^self imageRelative localFileSpecFor: aFilenameString
!

installRelative
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current installation directory."

	^InstallRelativeFileLocator current!

installRelative: aFilenameString
	^self installRelative localFileSpecFor: aFilenameString
! !
!Core.FileLocator class categoriesFor: #absolute!accessing!public! !
!Core.FileLocator class categoriesFor: #default!accessing!public! !
!Core.FileLocator class categoriesFor: #folderRelative:!instance creation!public! !
!Core.FileLocator class categoriesFor: #imageFolderRelative:!instance creation!public! !
!Core.FileLocator class categoriesFor: #imageRelative!accessing!public! !
!Core.FileLocator class categoriesFor: #imageRelative:!instance creation!public! !
!Core.FileLocator class categoriesFor: #installRelative!accessing!public! !
!Core.FileLocator class categoriesFor: #installRelative:!instance creation!public! !

