"Filed out from Dolphin Smalltalk"!

UI.ValuePresenter
	subclass: #'UI.ImagePresenter'
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
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Animated_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.AnimatedImageView} 38 #{Core.Array} 14 nil nil 50 2 8 1409286144 1 32 1094 2 #{UI.ValueHolder} nil false 6 #{Kernel.EqualitySearchPolicy} nil 6 #{Graphics.Color} #violet nil 5 nil nil nil 32 nil true 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 306 247 201 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 122 12 0 0 110 0 0 0] 8 #() 306 193 193 nil 27)!

resource_Basic_image
	"Answer the literal data from which the 'Basic image' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Basic_image)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ImageView} 38 #{Core.Array} 21 nil nil 50 2 8 1140850944 1 32 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #= 8 #() 178 #hash 8 #() nil 6 #{Graphics.Color} #default nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil nil nil #scaleToFit 1 nil nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 418 225 201 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 111 12 0 0 110 0 0 0] 8 #() 418 193 193 nil 27)!

resource_Default_view
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.StaticBitmap} 38 #{Core.Array} 17 nil nil 50 2 8 1149239566 1 32 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #== 8 #() 178 #hash 8 #() nil nil nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil false nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 386 441 331 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 219 12 0 0 175 0 0 0] 8 #() 386 193 193 nil 27)!

resource_Static_icon
	"Answer the literal data from which the 'Static icon' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	Tools.ViewComposer openOn: (UI.ResourceIdentifier class: self selector: #resource_Static_icon)
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.StaticIcon} 38 #{Core.Array} 17 nil nil 50 2 8 1149239555 1 32 1094 2 #{UI.ValueHolder} nil nil 518 #{Kernel.PluggableSearchPolicy} 518 #{Core.Message} #== 8 #() 178 #hash 8 #() nil nil nil 5 nil nil nil 32 nil nil 518 #{UI.NullConverter} nil nil false nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 6143 21 386 241 221 32 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 11 0 0 10 0 0 0 119 12 0 0 120 0 0 0] 8 #() 386 193 193 nil 27)! !
!UI.ImagePresenter class categoriesForMethods!
icon!constants!public! !
resource_Animated_view!public!resources-views! !
resource_Basic_image!public!resources-views! !
resource_Default_view!public!resources-views! !
resource_Static_icon!public!resources-views! !
!

