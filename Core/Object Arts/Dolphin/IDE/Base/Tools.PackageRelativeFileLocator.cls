"Filed out from Dolphin Smalltalk 7"!

Kernel.RelativeFileLocator subclass: #'Tools.PackageRelativeFileLocator'
	instanceVariableNames: 'packageName'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.PackageRelativeFileLocator guid: (Core.GUID fromString: '{01881ac6-d4ec-4fc2-be62-f07236be9753}')!
Tools.PackageRelativeFileLocator comment: 'PackageRelativeFileLocator is a <RelativeFileLocator> that can be used to map between an absolute path and a path relative to a certain package''s directory. At runtime (i.e. in a deployed application from which packages have been stripped) PackageRelativeFileLocator''s behave in the same way as <ImageRelativeFileLocator>s.

Thanks to Chris Uppal for the original idea behind this class.'!
!Tools.PackageRelativeFileLocator categoriesForClass!System-Support! !
!Tools.PackageRelativeFileLocator methodsFor!

basePath
	^self package ifNil: [super basePath] ifNotNil: [:pkg | pkg path]!

package
	"Answer the <Package> who's folder is used as the base path, or nil if the package is not loaded."

	^#{Package} ifDefined: [:class | class manager packageNamed: packageName ifNone: []]!

packageName
	"Answer the <readableString> name of the Package who's folder is used as the base path."

	^packageName!

setPackageName: aString 
	packageName := aString! !
!Tools.PackageRelativeFileLocator categoriesFor: #basePath!accessing!public! !
!Tools.PackageRelativeFileLocator categoriesFor: #package!accessing!public! !
!Tools.PackageRelativeFileLocator categoriesFor: #packageName!accessing!public! !
!Tools.PackageRelativeFileLocator categoriesFor: #setPackageName:!initializing!private! !

!Tools.PackageRelativeFileLocator class methodsFor!

package: aPackage 
	"Answer a new instance of the receiver for locating files relative to the folder containing
	the specified <Package>. Should the package be unloaded subsequently, then the instance will
	behave as if it were an ,ImageRelativeFileLocator>."

	^self packageNamed: aPackage name!

packageNamed: aString 
	"Answer a new instance of the receiver for locating files relative to the folder containing
	the named package. If the package is not loaded, then the instance will behave as if it were
	an <ImageRelativeFileLocator>."

	^(super new)
		setPackageName: aString;
		yourself! !
!Tools.PackageRelativeFileLocator class categoriesFor: #package:!instance creation!public! !
!Tools.PackageRelativeFileLocator class categoriesFor: #packageNamed:!instance creation!public! !

