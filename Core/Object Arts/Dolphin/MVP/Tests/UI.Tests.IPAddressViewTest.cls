"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.IPAddressViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.IPAddressViewTest guid: (Core.GUID fromString: '{7e69c5e0-2b6e-414b-b8fb-f46e5e3c9c60}')!

UI.Tests.IPAddressViewTest comment: ''!

!UI.Tests.IPAddressViewTest methodsFor!

classToTest
	^IPAddressView!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view interactor identicalTo: view.
	self assert: view typeconverter isNullConverter.
	self assert: view backcolor identicalTo: Color default.
! !

!UI.Tests.IPAddressViewTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.IPAddressViewTest class methodsFor!

resource_IP_address_view_D6
	"Answer the literal data from which the 'IP address view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_IP_address_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.IPAddressView)  98 15 0 0 98 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder)  0 32 1310726 ##(Smalltalk.EqualitySearchPolicy)  0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 5 0 0 0 416 0 8 4294904871 852486 ##(Smalltalk.NullConverter)  0 0 983302 ##(Smalltalk.MessageSequence)  202 208 98 1 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point)  2799 21 786 281 43 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 3 6 0 0 31 0 0 0] 98 0 786 193 193 0 27 )!

resource_IP_address_view_D7
	"Answer the literal data from which the 'IP address view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_IP_address_view)
	"

	^#(#'!!STL' 4 788558 11 ##(Smalltalk.STBViewProxy) ##(Smalltalk.IPAddressView) 34 15 nil nil 34 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1783600896 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createWindow: 34 1 787462 ##(Smalltalk.CreateWindow) 262406 ##(Smalltalk.RECT) 8 #[255 11 0 0 10 0 0 0 139 12 0 0 31 0 0 0] 193 448 8 '0.0.0.0' 416 1 8 #() 328198 ##(Smalltalk.Point) 193 193 nil 27 )! !

!UI.Tests.IPAddressViewTest class categoriesForMethods!
resource_IP_address_view_D6!public! !
resource_IP_address_view_D7!public! !
!

