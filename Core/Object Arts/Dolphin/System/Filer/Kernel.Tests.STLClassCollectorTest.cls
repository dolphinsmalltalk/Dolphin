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
	"A BindingReference in the original object graph will appear in the STL like any literal (i.e. immediately after the literal prefix code, 8), and will not be resolved when the STL is read. A BindingReference that is representing a class (or metaclass) will not have a literal prefix. These will get resolved when the STL is read and replaced in the output object graph with the value of the referenced static variable, usually a class."

	| subject classes |
	subject := STLClassCollector
				on: #(#'!!STL' 5 34 1 1049094 #{Core.Association} 8 #{Core.Object} #{Core.Object}) readStream.
	classes := subject contents.
	self assert: classes asSortedArray
		equals: { Array. Association. FullBindingReference. Object. SmallInteger. STLInFiler5. Symbol }!

testEmptyArray
	| expected |
	"All STL arrays must consist of instance of at least these 3 classes
		- the store array itself is obviously an Array
		- at the very least there will be a SmallInteger for the STL version, although usually at least one prefix code too.
		- the STL signature is a Symbol"
	expected := { Array. SmallInteger. Symbol }.
	3 to: STLOutFiler version
		do: 
			[:ver |
			| classes stl |
			stl := (STLOutFiler version: ver)
						nextPut: #();
						contents.
			classes := (STLClassCollector on: stl readStream) contents.
			self assert: classes asSortedArray
				equals: (expected copyWith: (STLInFiler classForVersion: ver)) asSortedArray]!

testLiterals
	| literals |
	literals := #(#($a #(true false nil) 123 1.23 1.2s 9223372036854775808) 'abc' #[1 2 3] #{Core.Object}).
	5 to: STLInFiler version
		do: 
			[:ver |
			| stl classes expected |
			stl := (STLOutFiler version: ver)
						nextPut: literals;
						contents.
			classes := (STLClassCollector on: stl readStream) contents.
			expected := #(#{Core.Array} #{Core.ByteArray} #{Core.Character} #{Core.False} #{Core.Float} #{Kernel.FullBindingReference} #{Core.LargeInteger} #{Core.ScaledDecimal} #{Core.SmallInteger} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String})
						collect: [:each | each value].
			expected := expected copyWith: (STLInFiler classForVersion: ver).
			self assert: classes asSortedArray equals: expected asSortedArray]!

testLiterals3to4
	"Some literals have special encodings (nil, Characters) or may be pre-registered (true, false). We want to make sure the classes of these are still captured."

	| literals |
	literals := #(#($a #(true false nil) 123 1.23 1.2s 9223372036854775808) 'abc' #[1 2 3]).
	3 to: 4
		do: 
			[:ver |
			| stl classes expected |
			stl := (STLOutFiler version: ver)
						nextPut: literals;
						contents.
			classes := (STLClassCollector on: stl readStream) contents.
			"We get a Fraction in the STL because in STL3/4 ScaledDecimals are not stored as literals"
			expected := #(#{Core.Array} #{Core.ByteArray} #{Core.Character} #{Core.False} #{Core.Float} #{Core.Fraction} #{Core.LargeInteger} #{Core.ScaledDecimal} #{Core.SmallInteger} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String})
						collect: [:each | each value].
			expected := expected copyWith: (STLInFiler classForVersion: ver).
			self assert: classes asSortedArray equals: expected asSortedArray]!

testMetaclass
	| expected |
	"With STL 5+, the metaclass proxy is not used, so the class reference (to Object) is directly visible). Note that the original content also includes a meta binding reference to Class class, but this does not generate a reference to Class as these are not considered hard references."
	expected := { Array. Association. MetaBindingReference. Object. SmallInteger. Symbol }.
	5 to: STLOutFiler version
		do: 
			[:ver |
			| stl classes |
			stl := ((STLOutFiler version: ver)
						nextPut: #{Core.Class class} -> Object class;
						stream) contents.
			classes := (STLClassCollector on: stl readStream) contents.
			self assert: classes asSortedArray
				equals: (expected copyWith: (STLInFiler classForVersion: ver)) asSortedArray]!

testMetaclass3to4
	| classes expected |
	"For STL 4 (and 3) direct class references were proxied, so we expect to see STBMetaclassProxy. However we still expect the underlying Object class reference to be collected"
	expected := { Array. Object. SmallInteger. STBMetaclassProxy. Symbol. Utf8String }.
	3 to: 4
		do: 
			[:ver |
			| stl |
			stl := (STLOutFiler version: ver)
						nextPut: Object class;
						contents.
			classes := (STLClassCollector on: stl readStream) contents.
			self assert: classes asSortedArray
				equals: (expected copyWith: (STLInFiler classForVersion: ver)) asSortedArray]!

testNil
	| classes expected |
	expected := { Array. SmallInteger. Symbol. UndefinedObject }.
	3 to: STLOutFiler version
		do: 
			[:ver |
			| stl |
			stl := (STLOutFiler version: ver)
						nextPut: nil;
						contents.
			classes := (STLClassCollector on: stl readStream) contents.
			self assert: classes asSortedArray
				equals: (expected copyWith: (STLInFiler classForVersion: ver)) asSortedArray]!

testVersion3ViewResource
	| actual expected |
	actual := (STLClassCollector on: self version3ViewResource readStream) contents.
	expected := #(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{UI.ContainerView} #{Core.IdentityDictionary} #{Kernel.IdentitySearchPolicy} #{Core.LargeInteger} #{UI.ListModel} #{Core.MessageSend} #{Core.MessageSequence} #{Core.OrderedCollection} #{Graphics.Point} #{Graphics.Rectangle} #{Graphics.RGB} #{Smalltalk.ScribbleView} #{Core.SearchPolicy} #{Core.SmallInteger} #{Kernel.STBCollectionProxy} #{Kernel.STBIdentityDictionaryProxy} #{Kernel.STBSingletonProxy} #{UI.STBViewProxy} #{Kernel.STLInFiler3} #{Core.Symbol} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value].
	self assert: actual asSortedArray equals: expected!

testVersion4ViewResource
	| actual expected |
	actual := (STLClassCollector on: self version4ViewResource readStream) contents.
	expected := #(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{Graphics.Color} #{Graphics.ColorDefault} #{UI.CommandDescription} #{UI.CommandMenuItem} #{Graphics.Icon} #{Core.IdentityDictionary} #{Kernel.ImageRelativeFileLocator} #{Core.LargeInteger} #{UI.Menu} #{UI.MenuBar} #{Core.MessageSend} #{Core.MessageSequence} #{Core.OrderedCollection} #{Graphics.Point} #{UI.ReferenceView} #{UI.ResourceIdentifier} #{External.ResourceLibrary} #{Smalltalk.Scribble} #{UI.ShellView} #{Core.SmallInteger} #{Kernel.STBCollectionProxy} #{Kernel.STBExternalResourceLibraryProxy} #{Kernel.STBIdentityDictionaryProxy} #{UI.STBViewProxy} #{Kernel.STLInFiler4} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value].
	self assert: actual asSortedArray equals: expected!

testVersion5ViewResource
	| actual expected |
	actual := (STLClassCollector on: self version5ViewResource readStream) contents.
	expected := #(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{Graphics.Color} #{Graphics.ColorDefault} #{UI.CommandDescription} #{UI.CommandMenuItem} #{Graphics.Icon} #{Core.IdentityDictionary} #{Graphics.ImageFromStringResourceInitializer} #{Core.LargeInteger} #{UI.Menu} #{UI.MenuBar} #{Core.MessageSend} #{Core.MessageSequence} #{Graphics.Point} #{UI.ReferenceView} #{UI.ResourceIdentifier} #{External.ResourceLibrary} #{Smalltalk.Scribble} #{UI.ShellView} #{Core.SmallInteger} #{Kernel.STBExternalResourceLibraryProxy} #{Kernel.STBIdentityDictionaryProxy} #{UI.STBViewProxy} #{Kernel.STLInFiler5} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT})
				collect: [:each | each value].
	self assert: actual asSortedArray equals: expected!

testVersion6ViewResource
	| actual stl6 expected |
	stl6 := self version6ViewResource.
	actual := (STLClassCollector on: stl6 readStream) contents.
	"Note: STBIdentityDictonaryProxy is absent because the collection proxies are no longer used in version 6"
	expected := #(#{Core.Array} #{UI.BorderLayout} #{Core.ByteArray} #{Graphics.Color} #{Graphics.ColorDefault} #{UI.CommandDescription} #{UI.CommandMenuItem} #{Graphics.Icon} #{Core.IdentityDictionary} #{Graphics.ImageFromStringResourceInitializer} #{Core.LargeInteger} #{UI.Menu} #{UI.MenuBar} #{Core.MessageSend} #{Core.MessageSequence} #{Graphics.Point} #{UI.ReferenceView} #{UI.ResourceIdentifier} #{External.ResourceLibrary} #{Smalltalk.Scribble} #{UI.ShellView} #{Core.SmallInteger} #{Kernel.STBExternalResourceLibraryProxy} #{UI.STBViewProxy} #{Kernel.STLInFiler} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String} #{OS.WINDOWPLACEMENT}).
	self assert: actual asSortedArray equals: (expected collect: [:each | each value]).
	"In STL 6 there are also no pre-registered classes, so the only classes not represented as BindingReferences in the STL will be those of literals or any that are proxied somehow (e.g. the ColorDefault singleton, written to the stream as Color default), and ExternalResourceLibrary which has an actual proxy class."
	self assert: (expected difference: (stl6 select: [:each | each isKindOf: BindingReference]))
		equals: #(#{Core.ByteArray} #{Graphics.ColorDefault} #{Core.LargeInteger} #{External.ResourceLibrary} #{Core.SmallInteger} #{Kernel.STLInFiler} #{Core.Symbol} #{Core.True} #{Core.UndefinedObject} #{Core.Utf8String})!

version3ViewResource
	"A resource in STL 3 format, from Dolphin 6"

	<namespace: Smalltalk>
	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ContainerView) 98 15 0 0 98 2 8 1140850688 131073 416 0 196934 1 ##(RGB) 8454655 0 7 0 0 0 416 788230 ##(BorderLayout) 1 1 0 0 0 0 410 8 ##(ScribbleView) 98 12 0 416 98 2 8 1140850688 1 560 590662 2 ##(ListModel) 202 208 98 0 0 1114638 ##(Kernel.STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 498 16908287 0 7 0 0 0 560 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 41 41 914 681 471 560 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 104 1 0 0 255 0 0 0] 98 0 914 193 193 0 27 234 256 98 2 560 8 'scribble' 590342 ##(Rectangle) 914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 20001 20001 914 761 551 416 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 16 39 0 0 16 39 0 0 140 40 0 0 35 40 0 0] 98 2 560 410 432 98 15 0 416 98 2 8 1140850688 131073 1312 0 498 8454655 0 7 0 0 0 1312 530 1 1 0 0 0 0 410 576 98 12 0 1312 98 2 8 1140850688 1 1408 642 202 208 688 0 720 498 16908287 0 7 0 0 0 1408 786 202 208 98 1 850 880 98 2 914 41 41 914 621 421 1408 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 20 0 0 0 20 0 0 0 74 1 0 0 230 0 0 0] 98 0 1024 0 27 234 256 98 2 1408 8 'scribble' 1090 914 41 41 914 41 41 786 202 208 98 1 850 880 98 2 914 21 23 914 701 501 1312 962 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 10 0 0 0 11 0 0 0 104 1 0 0 5 1 0 0] 98 1 1408 1024 0 27 1024 0 27)!

version4ViewResource
	"A resource in STL 4 format from Dolphin 7"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ShellView) 34 27 nil nil 8 #(13565952 65536) 416 nil 327686 ##(Smalltalk.Color) #default nil 549 nil nil nil 416 788230 ##(Smalltalk.BorderLayout) 1 1 nil nil nil nil 410 ##(Smalltalk.ReferenceView) 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1180230 1 ##(Smalltalk.ResourceIdentifier) ##(Smalltalk.Scribble) #resource_Default_view nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 1 1 738 1169 683 528 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 738 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 461638 4 ##(Smalltalk.MenuBar) nil true 34 1 265030 4 ##(Smalltalk.Menu) nil true 34 4 984134 2 ##(Smalltalk.CommandMenuItem) 1 1180998 4 ##(Smalltalk.CommandDescription) #fileNew 8 '&New' 9373 1 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'DocumentShell.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil nil nil 1010 1 1042 #fileOpen 8 '&Open...' 9375 1 1090 nil true 1136 8 'OpenWorkspace.ico' 1184 nil nil 1010 1 1042 #fileSave 8 '&Save' 9383 1 1090 nil true 1136 8 'FileSave.ico' 1184 nil nil 1010 1 1042 #fileSaveAs 8 'Save &As...' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 13077 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 1090 nil true 1136 8 'Scribble.ico' 1184 nil nil nil 1 nil nil 626 138 144 34 2 690 #createAt:extent: 34 2 738 3839 21 738 1201 801 416 690 #updateMenuBar 832 416 786 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 215 9 0 0 154 1 0 0] 34 1 528 848 nil 27)!

version5ViewResource
	"A resource in STL 5 format from Dolphin 8, with direct class references replaced by BindingReferences, and namespaces."

	^#(#'!!STL' 5 985166 10 #{UI.STBViewProxy} #{UI.ShellView} 34 27 nil nil 8 #(13565952 65536) 416 nil 917510 #{Graphics.Color} #default nil 551 nil nil nil 416 984838 #{UI.BorderLayout} 1 1 nil nil nil nil 410 #{UI.ReferenceView} 34 14 nil 416 34 2 8 1140850688 131073 528 nil nil nil 7 nil nil nil 528 1376838 1 #{UI.ResourceIdentifier} #{Smalltalk.Scribble} #resource_Default_view nil 1310982 #{Core.MessageSequence} 34 1 1049350 #{Core.MessageSend} #createAt:extent: 34 2 918022 #{Graphics.Point} 1 1 722 1169 683 528 1179910 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 722 193 193 nil 27 170 192 34 2 528 8 'scribble' nil 658246 4 #{UI.MenuBar} nil true 34 1 461638 4 #{UI.Menu} nil true 34 4 1180742 2 #{UI.CommandMenuItem} 1 1377606 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 852806 4 #{Graphics.Icon} nil true 2819078 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 2490894 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 994 1 1026 #fileOpen 8 '&Open…' 9375 1 1074 nil true 1106 8 'OpenWorkspace.ico' 1168 65541 nil nil nil 994 1 1026 #fileSave 8 '&Save' 9383 1 1074 nil true 1106 8 'FileSave.ico' 1168 65541 nil nil nil 994 1 1026 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 21855 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 1074 nil true 1106 8 'Scribble.ico' 1168 65541 nil nil nil nil 1 nil nil 626 34 1 674 #createAt:extent: 34 2 722 12287 21 722 1201 801 416 770 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 23 0 0 10 0 0 0 87 26 0 0 154 1 0 0] 34 1 528 832 nil 27)!

version6ViewResource
	"A resource in STL 6 format from Dolphin 8. Created from the v5 resource as follows:

	shell := (STLInFiler on: self new version5ViewResource readStream)
				context: UI.DesktopView current;
				next.
	stl := (STLOutFiler on: Array writeStream)
				nextPut: shell;
				stream.
	stl := stl contents.
	text := STLPrinter printLiteralStoreArray: stl.
	"

	^#(#'!!STL' 6 2118 10 #{UI.STBViewProxy} #{UI.ShellView} 38 #{Core.Array} 27 nil nil 8 #(13565952 65536) 32 nil 6 #{Graphics.Color} #default nil 517 nil nil nil 32 1798 #{UI.BorderLayout} 1 1 nil nil nil nil 18 #{UI.ReferenceView} 50 14 nil 32 50 2 8 1140850688 131073 160 nil nil nil 5 nil nil nil 160 582 1 #{UI.ResourceIdentifier} #{Smalltalk.Scribble} #resource_Default_view nil 262 #{Core.MessageSequence} 50 1 774 #{Core.MessageSend} #createAt:extent: 50 2 518 #{Graphics.Point} 1 1 354 1169 683 160 262 #{OS.WINDOWPLACEMENT} 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 0 0 0 0 0 0 0 0 72 2 0 0 85 1 0 0] 8 #() 354 193 193 nil 27 550 #{Core.IdentityDictionary} 1 160 8 'scribble' nil 2886 4 #{UI.MenuBar} nil true 50 1 2886 4 #{UI.Menu} nil true 50 4 1094 2 #{UI.CommandMenuItem} 1 1350 4 #{UI.CommandDescription} #fileNew 8 '&New' 9373 1 838 4 #{Graphics.Icon} nil true 1030 #{Graphics.ImageFromStringResourceInitializer} 8 'DocumentShell.ico' 518 #{Kernel.STBExternalResourceLibraryProxy} 8 'dolphindr8.dll' nil 65541 nil nil nil 626 1 658 #fileOpen 8 '&Open…' 9375 1 706 nil true 738 8 'OpenWorkspace.ico' 800 65541 nil nil nil 626 1 658 #fileSave 8 '&Save' 9383 1 706 nil true 738 8 'FileSave.ico' 800 65541 nil nil nil 626 1 658 #fileSaveAs 8 'Save &As…' 1 1 nil nil nil 8 '&File' nil 134217729 nil nil 38585 nil nil 8 '' nil 134217729 nil nil nil nil nil nil nil nil 1 706 nil true 738 8 'Scribble.ico' 800 65541 nil nil nil nil 1 nil nil 258 50 1 306 #createAt:extent: 50 2 354 781 781 354 4609 2443 32 402 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 134 1 0 0 134 1 0 0 134 10 0 0 75 6 0 0] 50 1 160 464 nil 27)! !
!Kernel.Tests.STLClassCollectorTest categoriesForMethods!
testClassAndBindingReference!public! !
testEmptyArray!public! !
testLiterals!public! !
testLiterals3to4!public! !
testMetaclass!public! !
testMetaclass3to4!public! !
testNil!public! !
testVersion3ViewResource!public! !
testVersion4ViewResource!public! !
testVersion5ViewResource!public! !
testVersion6ViewResource!public! !
version3ViewResource!constants!private! !
version4ViewResource!constants!private! !
version5ViewResource!constants!private! !
version6ViewResource!constants!private! !
!

