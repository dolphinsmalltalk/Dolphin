"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontCollection subclass: #'Graphics.Gdiplus.InstalledFontCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.InstalledFontCollection guid: (Core.GUID fromString: '{c09d8c03-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.InstalledFontCollection comment: 'GdiplusInstalledFontCollection class represents the fonts installed on the system.'!
!Graphics.Gdiplus.InstalledFontCollection methodsFor!

clone
	^self class new!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^InstalledFontCollectionInitializer!

ownedHandle: aHandle
	"Private - Set the handle of the external graphics's tool object represented and owned by the receiver to be the argument."

	"The underlying handle is to a singleton object. We don't want to (or need to) free it, so don't take ownership"
	ownsHandle := false.
	self handle: aHandle! !
!Graphics.Gdiplus.InstalledFontCollection categoriesForMethods!
clone!copying!public! !
initializerClass!constants!private! !
ownedHandle:!accessing!private! !
!

!Graphics.Gdiplus.InstalledFontCollection class methodsFor!

new
	^self fromInitializer: InstalledFontCollectionInitializer default! !
!Graphics.Gdiplus.InstalledFontCollection class categoriesForMethods!
new!instance creation!public! !
!

