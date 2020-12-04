"Filed out from Dolphin Smalltalk 7"!

UI.ValuePresenter subclass: #'UI.ImagePresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ImagePresenter guid: (Core.GUID fromString: '{87b4c6d0-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.ImagePresenter comment: 'ImagePresenter is a <valuePresenter> that displays a <valueModel> onto an <image> value. A ImagePresenter can be connected to any <valueView> capable of displaying <image> values. Normally, this will be an <ImageView> or <StaticImage>, although alternative views may be chosen with the installation of an appropriate <typeConverter>.'!
!UI.ImagePresenter categoriesForClass!MVP-Presenters!MVP-Resources-Images! !
!UI.ImagePresenter class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

resource_Animated_view
	"Answer the literal data from which the 'Animated view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Animated_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.AnimatedImageView) 34 14 nil nil 34 2 8 1409286144 1 416 918598 2 ##(UI.ValueHolder) nil false 1638406 ##(Kernel.EqualitySearchPolicy) nil 917510 ##(Graphics.Color) #violet nil 5 nil nil nil 416 nil true 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 690 247 201 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 122 12 0 0 110 0 0 0] 8 #() 690 193 193 nil 27)!

resource_Basic_image
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.ImageView) 34 21 nil nil 34 2 8 1140850944 1 416 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #= 8 #() 546 #hash 8 #() nil 917510 ##(Graphics.Color) #default nil 7 nil nil nil 416 nil 8 4294903431 1049094 ##(UI.NullConverter) nil nil nil nil #scaleToFit 1 nil nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 818 225 201 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 111 12 0 0 110 0 0 0] 8 #() 818 193 193 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.StaticBitmap) 34 17 nil nil 34 2 8 1149239566 1 416 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #== 8 #() 546 #hash 8 #() nil nil nil 7 nil nil nil 416 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil false nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 786 441 331 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 219 12 0 0 175 0 0 0] 8 #() 786 193 193 nil 27)!

resource_Static_icon
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 4 985166 10 ##(UI.STBViewProxy) ##(UI.StaticIcon) 34 17 nil nil 34 2 8 1149239555 1 416 918598 2 ##(UI.ValueHolder) nil nil 1704454 ##(Core.PluggableSearchPolicy) 786950 ##(Core.Message) #== 8 #() 546 #hash 8 #() nil nil nil 7 nil nil nil 416 nil 8 1920531648 1049094 ##(UI.NullConverter) nil nil false nil 1310982 ##(Core.MessageSequence) 138 144 34 1 1049350 ##(Core.MessageSend) #createAt:extent: 34 2 655878 ##(Graphics.Point) 6143 21 786 241 221 416 1179910 ##(OS.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 120 0 0 0] 8 #() 786 193 193 nil 27)! !
!UI.ImagePresenter class categoriesFor: #icon!constants!public! !
!UI.ImagePresenter class categoriesFor: #resource_Animated_view!public!resources-views! !
!UI.ImagePresenter class categoriesFor: #resource_Basic_image!public!resources-views! !
!UI.ImagePresenter class categoriesFor: #resource_Default_view!public!resources-views! !
!UI.ImagePresenter class categoriesFor: #resource_Static_icon!public!resources-views! !

