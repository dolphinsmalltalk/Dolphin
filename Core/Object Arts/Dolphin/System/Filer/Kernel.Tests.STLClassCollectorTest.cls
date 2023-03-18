"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Kernel.Tests.STLClassCollectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.STLClassCollectorTest guid: (Core.GUID fromString: '{c73c341b-d268-45b7-8893-0219243afb8c}')!
Kernel.Tests.STLClassCollectorTest comment: ''!
!Kernel.Tests.STLClassCollectorTest methodsFor!

testClassAndBindingReference
	| subject classes |
	subject := STLClassCollector
				on: #(#'!!STL' 5 34 1 1049094 #{Core.Association} 8 #{Core.Object} #{Core.Object}) readStream.
	classes := subject contents.
	self assert: classes asSortedArray
		equals: {Array. Association. FullBindingReference. Object. SmallInteger. Symbol}!

testEmptyArray
	| subject classes expected |
	subject := STLClassCollector on: #() literalStoreArray readStream.
	classes := subject contents.
	expected := {Array. SmallInteger. Symbol}.
	self assert: classes asSortedArray equals: expected!

testLiterals
	| subject classes expected |
	subject := STLClassCollector
				on: #(#'!!STL' 5 34 6 $a 8 #(true false nil) 247 8 1.23 8 1.2s 8 1073741824) readStream.
	classes := subject contents.
	expected := #(#{Core.Array} #{Core.Character} #{Core.False} #{Core.Float} #{Core.LargeInteger} #{Core.ScaledDecimal} #{Core.SmallInteger} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject})
				collect: [:each | each value].
	self assert: classes asSortedArray equals: expected!

testMetaclass
	| subject classes expected |
	subject := STLClassCollector
				on: #(#'!!STL' 5 1049094 #{Core.Association} 8 #{Core.Object class} #{Core.Object class}) readStream.
	classes := subject contents.
	expected := {Array. Association. MetaBindingReference. Object. SmallInteger. Symbol}.
	self assert: classes asSortedArray equals: expected!

testNil
	| subject classes expected |
	subject := STLClassCollector on: nil literalStoreArray readStream.
	classes := subject contents.
	expected := {Array. SmallInteger. Symbol. UndefinedObject}.
	self assert: classes asSortedArray equals: expected!

testVersion3ViewResource
	| subject classes |
	subject := STLClassCollector on: self version3ViewResource readStream.
	classes := subject contents.
	self assert: classes asSortedArray
		equals: (#(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{UI.ContainerView} #{Core.IdentityDictionary} #{Core.LargeInteger} #{UI.ListModel} #{Core.MessageSend} #{Core.MessageSequence} #{Core.OrderedCollection} #{Graphics.Point} #{Graphics.Rectangle} #{Graphics.RGB} #{Smalltalk.ScribbleView} #{Core.SearchPolicy} #{Core.SmallInteger} #{Kernel.STBCollectionProxy} #{Kernel.STBIdentityDictionaryProxy} #{Kernel.STBSingletonProxy} #{UI.STBViewProxy} #{Core.Symbol} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value])!

testVersion4ViewResource
	| subject classes |
	subject := STLClassCollector on: self version4ViewResource readStream.
	classes := subject contents.
	self assert: classes asSortedArray
		equals: (#(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{Graphics.Color} #{UI.CommandDescription} #{UI.CommandMenuItem} #{Graphics.Icon} #{Core.IdentityDictionary} #{Kernel.ImageRelativeFileLocator} #{Core.LargeInteger} #{UI.Menu} #{UI.MenuBar} #{Core.MessageSend} #{Core.MessageSequence} #{Core.OrderedCollection} #{Graphics.Point} #{UI.ReferenceView} #{UI.ResourceIdentifier} #{Smalltalk.Scribble} #{UI.ShellView} #{Core.SmallInteger} #{Kernel.STBCollectionProxy} #{Kernel.STBExternalResourceLibraryProxy} #{Kernel.STBIdentityDictionaryProxy} #{UI.STBViewProxy} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value])!

testVersion5ViewResource
	| subject classes |
	subject := STLClassCollector on: self version5ViewResource readStream.
	classes := subject contents.
	self assert: classes asSortedArray
		equals: (#(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{Graphics.Color} #{UI.CommandDescription} #{UI.CommandMenuItem} #{Graphics.Icon} #{Core.IdentityDictionary} #{Graphics.ImageFromStringResourceInitializer} #{Core.LargeInteger} #{UI.Menu} #{UI.MenuBar} #{Core.MessageSend} #{Core.MessageSequence} #{Graphics.Point} #{UI.ReferenceView} #{UI.ResourceIdentifier} #{Smalltalk.Scribble} #{UI.ShellView} #{Core.SmallInteger} #{Kernel.STBExternalResourceLibraryProxy} #{Kernel.STBIdentityDictionaryProxy} #{UI.STBViewProxy} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value])!

version3ViewResource
	<namespace: Smalltalk>
	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1140850688 131073 416 0 196934 1 ##(RGB) 8454655 0 7 0 0 0 416 788230 ##(BorderLayout) 1 1 0 0 0 0 410 8 ##(ScribbleView) 98 12 0 416 98 2 8 1140850688 1 560 590662 2 ##(ListModel) 202 208 98 0 0 1114638 ##(Kernel.STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 498 16908287 0 7 0 0 0 560 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 41 41 914 681 471 560 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 104 1 0 0 255 0 0 0] 98 0 914 193 193 0 27 234 256 98 2 560 8 'scribble' 590342 ##(Rectangle) 914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 20001 20001 914 761 551 416 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 140 40 0 0 35 40 0 0] 98 2 560 410 432 98 15 0 416 98 2 8 1140850688 131073 1312 0 498 8454655 0 7 0 0 0 1312 530 1 1 0 0 0 0 410 576 98 12 0 1312 98 2 8 1140850688 1 1408 642 202 208 688 0 720 498 16908287 0 7 0 0 0 1408 786 202 208 98 1 850 880 98 2 914 41 41 914 621 421 1408 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 74 1 0 0 230 0 0 0] 98 0 1024 0 27 234 256 98 2 1408 8 'scribble' 1090 914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 21 23 914 701 501 1312 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 104 1 0 0 5 1 0 0] 98 1 1408 1024 0 27 1024 0 27)!

version4ViewResource
	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Scribble) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 738 1169 683 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 738 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1010 1 1042 #fileOpen 8 '&Open...' 9375 1 1090 nil true 1136 8 'OpenWorkspace.ico' 1184 nil nil 1010 1 1042 #fileSave 8 '&Save' 9383 1 1090 nil true 1136 8 'FileSave.ico' 1184 nil nil 1010 1 1042 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 13077 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 1090 nil true 1136 8 'Scribble.ico' 1184 nil nil nil 1 nil nil 626 138 144 34 2 690 #createAt:extent: 34 2 738 3839 21 738 1201 801 416 690 #updateMenuBar 832 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 848 nil 27 )!

version5ViewResource
	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376838 1 #{UI.ResourceIdentifier} #{Smalltalk.Scribble} #resource_Default_view nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 722 1169 683 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 722 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 658246 4 #{UI.MenuBar} nil true 34 1 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 994 1 1026 #fileOpen 8 '&Open…' 9375 1 1074 nil true 1106 8 'OpenWorkspace.ico' 1168 65541 nil nil nil 994 1 1026 #fileSave 8 '&Save' 9383 1 1074 nil true 1106 8 'FileSave.ico' 1168 65541 nil nil nil 994 1 1026 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 21855 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 1074 nil true 1106 8 'Scribble.ico' 1168 65541 nil nil nil nil 1 nil nil 626 34 1 674 #createAt:extent: 34 2 722 12287 21 722 1201 801 416 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 1 528 832 nil 27)! !
!Kernel.Tests.STLClassCollectorTest categoriesForMethods!
testClassAndBindingReference!public! !
testEmptyArray!public! !
testLiterals!public! !
testMetaclass!public! !
testNil!public! !
testVersion3ViewResource!public! !
testVersion4ViewResource!public! !
testVersion5ViewResource!public! !
version3ViewResource!constants!private! !
version4ViewResource!constants!private! !
version5ViewResource!constants!private! !
!

