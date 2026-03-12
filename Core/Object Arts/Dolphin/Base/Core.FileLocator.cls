"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'Core.FileLocator'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.FileLocator guid: (Core.GUID fromString: '{391014f8-ebb8-4dd3-bd5d-fb6f303de483}')!

Core.FileLocator isNonInstantiable: true!

Core.FileLocator comment: '`FileLocator` is an abstract root for a hierarchy of subclasses that implement the <fileLocator> protocol. 
A <fileLocator> is used map between an external resource pathname and an internal name. First an external name is mapped to an internal form using #locatorPathTo:. The latter can be held in the image and later mapped back to it''s is full external name using #localPathFor:.

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

abstract: aPathOrString
	"Answer a <readableString> token for the resource with the specified <Path> or <readableString> path argument. For many locators this will be a relative path that can be resolved back to the original path via that locator's #resolve: implementation, but the abstracted form should generally be treated as opaque."

	^self subclassResponsibility!

resolve: aString
	"Answer a full <Path> for the argument, which is expected to be some internal representation of a <Path> created be a previous call to #abstract: on this or an equivalent locator. Typically the argument will be a <readableString> relative path formed according to the rules of this particular file locator, but this is not required. It is only necessary that the object be reversible from the form created by this locator's #abstract: operation to an equivalent full <Path> at the time where abstracted path needs to be resolved."

	^self subclassResponsibility! !

!Core.FileLocator categoriesForMethods!
abstract:!mapping!public! !
resolve:!mapping!public! !
!

Core.FileLocator methodProtocol: #fileLocator attributes: #(#readOnly) selectors: #(#abstract: #resolve:)!

!Core.FileLocator class methodsFor!

absolute
	"Answers an instance of the receiver that can be used to locate external files
	with an absolute path."

	^AbsoluteFileLocator current!

default
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current image directory."

	^ImageRelativeFileLocator current!

folderRelative: aPathOrString
	^FolderRelativeFileLocator basePath: aPathOrString!

imageFolderRelative: aString
	^self folderRelative: (self imageRelative resolve: aString)!

imageRelative
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current image  directory."

	^ImageRelativeFileLocator current!

installRelative
	"Answers an instance of the receiver that can be used to locate external files
	relative to the current installation directory."

	^InstallRelativeFileLocator current!

new
	"FileLocators are typically either singletons, or require parameters."

	^self shouldNotImplement! !

!Core.FileLocator class categoriesForMethods!
absolute!instance creation!public! !
default!instance creation!public! !
folderRelative:!instance creation!public! !
imageFolderRelative:!instance creation!public! !
imageRelative!instance creation!public! !
installRelative!instance creation!public! !
new!instance creation!public! !
!

