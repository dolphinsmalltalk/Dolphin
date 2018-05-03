"Filed out from Dolphin Smalltalk 7"!

LayoutManagerTest subclass: #BorderLayoutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BorderLayoutTest guid: (GUID fromString: '{67c32a2b-adf6-4987-95fa-c9bb9b7a4e9c}')!
BorderLayoutTest comment: ''!
!BorderLayoutTest categoriesForClass!Unclassified! !
!BorderLayoutTest methodsFor!

layoutManagerClass
	^BorderLayout!

testResourceBrowserPreview
	"#1758"

	| resourceId resourceView bmp container toolbox resources |
	resourceId := ResourceIdentifier class: ResourceBrowser name: 'Default view'.
	resourceView := 
			[Smalltalk developmentSystem loadViewResource: resourceId resource inContext: View desktop]
					on: Error
					do: [:x | ].
	bmp := resourceView notNil
				ifTrue: 
					[resourceView invalidateLayoutDeeply.
					Bitmap fromView: resourceView]
				ifFalse: [Error icon].
	toolbox := resourceView viewNamed: 'resourceToolbox'.
	resources := resourceView viewNamed: 'resources'.
	self assert: (resources viewNamed: 'resources') extent x equals: resources extent x.
	resourceView destroy! !
!BorderLayoutTest categoriesFor: #layoutManagerClass!private!unit tests! !
!BorderLayoutTest categoriesFor: #testResourceBrowserPreview!public!unit tests! !

