"Filed out from Dolphin Smalltalk 7"!

LayoutManagerTest subclass: #BorderLayoutTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BorderLayoutTest guid: (GUID fromString: '{67C32A2B-ADF6-4987-95FA-C9BB9B7A4E9C}')!
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
	self assert: (resources viewNamed: 'resources') extent x = resources extent x! !
!BorderLayoutTest categoriesFor: #layoutManagerClass!private!unit tests! !
!BorderLayoutTest categoriesFor: #testResourceBrowserPreview!public!unit tests! !

