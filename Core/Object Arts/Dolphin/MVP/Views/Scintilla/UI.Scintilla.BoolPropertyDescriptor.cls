"Filed out from Dolphin Smalltalk"!

UI.Scintilla.PropertyDescriptor
	subclass: #'UI.Scintilla.BoolPropertyDescriptor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Scintilla.BoolPropertyDescriptor guid: (Core.GUID fromString: '{fedb8ade-0d58-42d9-af37-157b58390869}')!
UI.Scintilla.BoolPropertyDescriptor comment: '`BoolPropertyDescriptor`s are `PropertyDescriptor`s for `ScintillaView` properties defined as being of `bool` type in the `scintilla.iface` definition file.

`bool` types in the control API are represented by the integer 0 for false, and any non-zero integer for true. The public Smalltalk realisation of the attribute property is as a `Boolean` object, either `false` or `true`, but internally the integer representation used by the view is exchanged with the `Attribute`. The `defaultValue` of a `BoolPropertyDescriptor` is normally either 0 or 1.'!
!UI.Scintilla.BoolPropertyDescriptor categoriesForClass!Kernel-Objects! !
