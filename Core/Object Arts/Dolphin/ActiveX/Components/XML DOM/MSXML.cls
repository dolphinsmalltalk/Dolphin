"Filed out from Dolphin Smalltalk 7"!

Kernel.Namespace subclass: #MSXML
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM private} #{OS private} #{MSXML.MSXMLConstants private})
	classInstanceVariableNames: ''
	classConstants: {}!
MSXML guid: (Core.GUID fromString: '{e41b4db3-8003-4382-a819-bf7d3581272d}')!
MSXML comment: 'Namespace for the generated MSXML DOM component wrapper classes and some associated utilities for working with XML.'!
!MSXML categoriesForClass!Kernel-Objects! !
!MSXML class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

newDocument
	^IXMLDOMDocument3 new! !
!MSXML class categoriesFor: #icon!constants!public! !
!MSXML class categoriesFor: #newDocument!private! !

